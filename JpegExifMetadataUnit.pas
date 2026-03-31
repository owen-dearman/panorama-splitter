unit JpegExifMetadataUnit;

interface

uses
  System.Classes;

type
  TJpegExifMetadata = class
  public
    class function AppendExifMetadataFromJpeg(const filePath: string; target: TStrings): Boolean; static;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.IOUtils;

class function TJpegExifMetadata.AppendExifMetadataFromJpeg(const filePath: string; target: TStrings): Boolean;
const
  JPEG_SOI = $FFD8;
  JPEG_SOS = $FFDA;
  JPEG_EOI = $FFD9;
  JPEG_APP1 = $FFE1;
var
  fileBytes: TBytes;
  filePos: Integer;
  marker: Word;
  segmentLength: Word;
  segmentDataStart: Integer;
  segmentDataLength: Integer;
  exifBytes: TBytes;
  littleEndian: Boolean;
  tiffStart: Integer;
  ifd0Offset: Cardinal;
  exifIfdOffset: Cardinal;
  gpsIfdOffset: Cardinal;
  gpsLatRef: Char;
  gpsLonRef: Char;
  gpsLat: Double;
  gpsLon: Double;
  gpsAltitude: Double;
  gpsAltitudeRef: Byte;

  function CanRead(offset, size: Integer): Boolean;
  begin
    Result := (offset >= 0) and (size >= 0) and ((offset + size) <= Length(exifBytes));
  end;

  function ReadWordBE(offset: Integer; out value: Word): Boolean;
  begin
    Result := CanRead(offset, 2);
    if not Result then
      Exit;
    value := (Word(exifBytes[offset]) shl 8) or Word(exifBytes[offset + 1]);
  end;

  function ReadLongTIFF(offset: Integer; out value: Cardinal): Boolean;
  begin
    Result := CanRead(offset, 4);
    if not Result then
      Exit;
    if littleEndian then
      value := Cardinal(exifBytes[offset]) or
        (Cardinal(exifBytes[offset + 1]) shl 8) or
        (Cardinal(exifBytes[offset + 2]) shl 16) or
        (Cardinal(exifBytes[offset + 3]) shl 24)
    else
      value := (Cardinal(exifBytes[offset]) shl 24) or
        (Cardinal(exifBytes[offset + 1]) shl 16) or
        (Cardinal(exifBytes[offset + 2]) shl 8) or
        Cardinal(exifBytes[offset + 3]);
  end;

  function ReadWordTIFF(offset: Integer; out value: Word): Boolean;
  begin
    Result := CanRead(offset, 2);
    if not Result then
      Exit;
    if littleEndian then
      value := Word(exifBytes[offset]) or (Word(exifBytes[offset + 1]) shl 8)
    else
      value := (Word(exifBytes[offset]) shl 8) or Word(exifBytes[offset + 1]);
  end;

  function ReadByteTIFF(offset: Integer; out value: Byte): Boolean;
  begin
    Result := CanRead(offset, 1);
    if not Result then
      Exit;
    value := exifBytes[offset];
  end;

  function ReadAsciiTag(entryOffset: Integer; valueCount: Cardinal; out tagValue: string): Boolean;
  var
    valueOffset: Cardinal;
    dataOffset: Integer;
    i: Integer;
    ch: Byte;
  begin
    Result := False;
    tagValue := '';
    if valueCount = 0 then
      Exit;

    if valueCount <= 4 then
      dataOffset := entryOffset + 8
    else
    begin
      if not ReadLongTIFF(entryOffset + 8, valueOffset) then
        Exit;
      dataOffset := tiffStart + Integer(valueOffset);
    end;

    if not CanRead(dataOffset, 1) then
      Exit;

    for i := 0 to Integer(valueCount) - 1 do
    begin
      if not CanRead(dataOffset + i, 1) then
        Break;
      ch := exifBytes[dataOffset + i];
      if ch = 0 then
        Break;
      tagValue := tagValue + Char(AnsiChar(ch));
    end;
    tagValue := Trim(tagValue);
    Result := tagValue <> '';
  end;

  function ReadRationalAt(offset: Integer; out value: Double): Boolean;
  var
    numerator: Cardinal;
    denominator: Cardinal;
  begin
    Result := ReadLongTIFF(offset, numerator) and ReadLongTIFF(offset + 4, denominator);
    if (not Result) or (denominator = 0) then
      Exit(False);
    value := numerator / denominator;
    Result := True;
  end;

  function ReadGpsCoord(entryOffset: Integer; valueCount: Cardinal; out value: Double): Boolean;
  var
    valueOffset: Cardinal;
    dataOffset: Integer;
    degValue: Double;
    minValue: Double;
    secValue: Double;
  begin
    Result := False;
    value := 0;
    if valueCount < 3 then
      Exit;
    if not ReadLongTIFF(entryOffset + 8, valueOffset) then
      Exit;
    dataOffset := tiffStart + Integer(valueOffset);
    if not CanRead(dataOffset, 24) then
      Exit;
    if not ReadRationalAt(dataOffset, degValue) then
      Exit;
    if not ReadRationalAt(dataOffset + 8, minValue) then
      Exit;
    if not ReadRationalAt(dataOffset + 16, secValue) then
      Exit;
    value := degValue + (minValue / 60.0) + (secValue / 3600.0);
    Result := True;
  end;

  function ReadShortOrLong(entryOffset: Integer; tagType: Word; out value: Cardinal): Boolean;
  var
    shortValue: Word;
  begin
    case tagType of
      3:
        begin
          Result := ReadWordTIFF(entryOffset + 8, shortValue);
          if Result then
            value := shortValue;
        end;
      4:
        Result := ReadLongTIFF(entryOffset + 8, value);
    else
      Result := False;
    end;
  end;

  function ReadRationalTag(entryOffset: Integer; out value: Double): Boolean;
  var
    valueOffset: Cardinal;
    dataOffset: Integer;
  begin
    Result := False;
    if not ReadLongTIFF(entryOffset + 8, valueOffset) then
      Exit;
    dataOffset := tiffStart + Integer(valueOffset);
    Result := ReadRationalAt(dataOffset, value);
  end;

  function ReadOrientationText(orientationValue: Cardinal): string;
  begin
    case orientationValue of
      1: Result := 'Top-left (normal)';
      2: Result := 'Top-right (mirrored)';
      3: Result := 'Bottom-right (rotated 180)';
      4: Result := 'Bottom-left (mirrored)';
      5: Result := 'Left-top (mirrored, rotated 90 CW)';
      6: Result := 'Right-top (rotated 90 CW)';
      7: Result := 'Right-bottom (mirrored, rotated 90 CCW)';
      8: Result := 'Left-bottom (rotated 90 CCW)';
    else
      Result := IntToStr(orientationValue);
    end;
  end;

  function FindLinkedIfds(rootIfdOffset: Integer; out outExifIfdOffset, outOutGpsIfdOffset: Cardinal): Boolean;
  var
    entryCount: Word;
    entryIndex: Integer;
    entryOffset: Integer;
    tagId: Word;
    tagType: Word;
    valueCount: Cardinal;
    valueOffset: Cardinal;
  begin
    Result := False;
    outExifIfdOffset := 0;
    outOutGpsIfdOffset := 0;
    if not ReadWordTIFF(rootIfdOffset, entryCount) then
      Exit;

    for entryIndex := 0 to entryCount - 1 do
    begin
      entryOffset := rootIfdOffset + 2 + (entryIndex * 12);
      if not CanRead(entryOffset, 12) then
        Exit;
      if not ReadWordTIFF(entryOffset, tagId) then
        Exit;
      if not ReadWordTIFF(entryOffset + 2, tagType) then
        Exit;
      if not ReadLongTIFF(entryOffset + 4, valueCount) then
        Exit;

      if ((tagId = $8769) or (tagId = $8825)) and (tagType = 4) and (valueCount = 1) then
      begin
        if not ReadLongTIFF(entryOffset + 8, valueOffset) then
          Exit;
        if tagId = $8769 then
          outExifIfdOffset := valueOffset
        else
          outOutGpsIfdOffset := valueOffset;
      end;
    end;
    Result := True;
  end;

  procedure ParseIfdForDisplay(ifdOffset: Integer; const prefix: string);
  var
    entryCount: Word;
    entryIndex: Integer;
    entryOffset: Integer;
    tagId: Word;
    tagType: Word;
    valueCount: Cardinal;
    textValue: string;
    numericValue: Cardinal;
    rationalValue: Double;
  begin
    if ifdOffset = 0 then
      Exit;
    if not ReadWordTIFF(ifdOffset, entryCount) then
      Exit;

    for entryIndex := 0 to entryCount - 1 do
    begin
      entryOffset := ifdOffset + 2 + (entryIndex * 12);
      if not CanRead(entryOffset, 12) then
        Break;
      if not ReadWordTIFF(entryOffset, tagId) then
        Continue;
      if not ReadWordTIFF(entryOffset + 2, tagType) then
        Continue;
      if not ReadLongTIFF(entryOffset + 4, valueCount) then
        Continue;

      case tagId of
        $010F: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Camera make: ' + textValue);
        $0110: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Camera model: ' + textValue);
        $0112:
          if ReadShortOrLong(entryOffset, tagType, numericValue) then
            target.Add(prefix + 'Orientation: ' + ReadOrientationText(numericValue));
        $0131: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Software: ' + textValue);
        $0132: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'DateTime: ' + textValue);
        $013B: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Artist: ' + textValue);
        $8298: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Copyright: ' + textValue);
        $9003: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Date taken: ' + textValue);
        $9004: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Date digitized: ' + textValue);
        $829A:
          if ReadRationalTag(entryOffset, rationalValue) then
            target.Add(prefix + Format('Exposure time: %.6f s (1/%.0f)', [rationalValue, 1 / Max(rationalValue, 0.000001)]));
        $829D:
          if ReadRationalTag(entryOffset, rationalValue) then
            target.Add(prefix + Format('F-number: f/%.1f', [rationalValue]));
        $8827:
          if ReadShortOrLong(entryOffset, tagType, numericValue) then
            target.Add(prefix + 'ISO: ' + IntToStr(numericValue));
        $920A:
          if ReadRationalTag(entryOffset, rationalValue) then
            target.Add(prefix + Format('Focal length: %.1f mm', [rationalValue]));
        $A405:
          if ReadShortOrLong(entryOffset, tagType, numericValue) then
            target.Add(prefix + 'Focal length (35mm): ' + IntToStr(numericValue) + ' mm');
        $A433: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Lens make: ' + textValue);
        $A434: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Lens model: ' + textValue);
        $A420: if ReadAsciiTag(entryOffset, valueCount, textValue) then target.Add(prefix + 'Image unique ID: ' + textValue);
        $A002:
          if ReadShortOrLong(entryOffset, tagType, numericValue) then
            target.Add(prefix + 'EXIF width: ' + IntToStr(numericValue) + ' px');
        $A003:
          if ReadShortOrLong(entryOffset, tagType, numericValue) then
            target.Add(prefix + 'EXIF height: ' + IntToStr(numericValue) + ' px');
      end;
    end;
  end;

  function ParseGpsIfd(ifdOffset: Integer): Boolean;
  var
    entryCount: Word;
    entryIndex: Integer;
    entryOffset: Integer;
    tagId: Word;
    tagType: Word;
    valueCount: Cardinal;
    textValue: string;
    valueOffset: Cardinal;
    dataOffset: Integer;
    hourValue: Double;
    minValue: Double;
    secValue: Double;
  begin
    Result := False;
    gpsLat := 0;
    gpsLon := 0;
    gpsAltitude := 0;
    gpsAltitudeRef := 0;
    gpsLatRef := #0;
    gpsLonRef := #0;

    if not ReadWordTIFF(ifdOffset, entryCount) then
      Exit;

    for entryIndex := 0 to entryCount - 1 do
    begin
      entryOffset := ifdOffset + 2 + (entryIndex * 12);
      if not CanRead(entryOffset, 12) then
        Exit;
      if not ReadWordTIFF(entryOffset, tagId) then
        Exit;
      if not ReadWordTIFF(entryOffset + 2, tagType) then
        Exit;
      if not ReadLongTIFF(entryOffset + 4, valueCount) then
        Exit;

      case tagId of
        $0001:
          if tagType = 2 then
          begin
            if ReadAsciiTag(entryOffset, valueCount, textValue) and (textValue <> '') then
              gpsLatRef := textValue[1];
          end;
        $0002:
          if tagType = 5 then
            ReadGpsCoord(entryOffset, valueCount, gpsLat);
        $0003:
          if tagType = 2 then
          begin
            if ReadAsciiTag(entryOffset, valueCount, textValue) and (textValue <> '') then
              gpsLonRef := textValue[1];
          end;
        $0004:
          if tagType = 5 then
            ReadGpsCoord(entryOffset, valueCount, gpsLon);
        $0005:
          if tagType = 1 then
            ReadByteTIFF(entryOffset + 8, gpsAltitudeRef);
        $0006:
          if tagType = 5 then
            ReadRationalTag(entryOffset, gpsAltitude);
        $001D:
          if tagType = 2 then
            if ReadAsciiTag(entryOffset, valueCount, textValue) then
              target.Add('GPS date stamp: ' + textValue);
        $0007:
          if (tagType = 5) and (valueCount >= 3) then
          begin
            if ReadLongTIFF(entryOffset + 8, valueOffset) then
            begin
              dataOffset := tiffStart + Integer(valueOffset);
              if CanRead(dataOffset, 24) and
                 ReadRationalAt(dataOffset, hourValue) and
                 ReadRationalAt(dataOffset + 8, minValue) and
                 ReadRationalAt(dataOffset + 16, secValue) then
                target.Add(Format('GPS UTC time: %.0f:%.0f:%.2f', [hourValue, minValue, secValue]));
            end;
          end;
      end;
    end;

    if (gpsLatRef = #0) or (gpsLonRef = #0) then
      Exit(False);

    if UpCase(gpsLatRef) = 'S' then
      gpsLat := -gpsLat;
    if UpCase(gpsLonRef) = 'W' then
      gpsLon := -gpsLon;

    target.Add(Format('GPS location: %.6f, %.6f', [gpsLat, gpsLon]));
    target.Add(Format('Maps: https://www.google.com/maps?q=%.6f,%.6f', [gpsLat, gpsLon]));
    if gpsAltitude <> 0 then
    begin
      if gpsAltitudeRef = 1 then
        gpsAltitude := -gpsAltitude;
      target.Add(Format('GPS altitude: %.1f m', [gpsAltitude]));
    end;

    Result := True;
  end;

var
  tiffMarker: Word;
begin
  Result := False;

  if not SameText(TPath.GetExtension(filePath), '.jpg') and
     not SameText(TPath.GetExtension(filePath), '.jpeg') then
    Exit;

  fileBytes := TFile.ReadAllBytes(filePath);
  if Length(fileBytes) < 4 then
    Exit;

  marker := (Word(fileBytes[0]) shl 8) or Word(fileBytes[1]);
  if marker <> JPEG_SOI then
    Exit;

  filePos := 2;
  SetLength(exifBytes, 0);

  while (filePos + 4) <= Length(fileBytes) do
  begin
    if fileBytes[filePos] <> $FF then
    begin
      Inc(filePos);
      Continue;
    end;

    marker := (Word(fileBytes[filePos]) shl 8) or Word(fileBytes[filePos + 1]);
    if (marker = JPEG_SOS) or (marker = JPEG_EOI) then
      Break;

    if not ReadWordBE(filePos + 2, segmentLength) then
      Exit(False);
    if segmentLength < 2 then
      Exit(False);

    segmentDataStart := filePos + 4;
    segmentDataLength := segmentLength - 2;
    if (segmentDataStart + segmentDataLength) > Length(fileBytes) then
      Exit(False);

    if (marker = JPEG_APP1) and (segmentDataLength >= 6) and
       (fileBytes[segmentDataStart] = Ord('E')) and
       (fileBytes[segmentDataStart + 1] = Ord('x')) and
       (fileBytes[segmentDataStart + 2] = Ord('i')) and
       (fileBytes[segmentDataStart + 3] = Ord('f')) and
       (fileBytes[segmentDataStart + 4] = 0) and
       (fileBytes[segmentDataStart + 5] = 0) then
    begin
      SetLength(exifBytes, segmentDataLength);
      Move(fileBytes[segmentDataStart], exifBytes[0], segmentDataLength);
      Break;
    end;

    Inc(filePos, 2 + segmentLength);
  end;

  if Length(exifBytes) = 0 then
    Exit(False);

  tiffStart := 6;
  if not CanRead(tiffStart, 8) then
    Exit(False);

  littleEndian := (exifBytes[tiffStart] = Ord('I')) and (exifBytes[tiffStart + 1] = Ord('I'));
  if not littleEndian and
     not ((exifBytes[tiffStart] = Ord('M')) and (exifBytes[tiffStart + 1] = Ord('M'))) then
    Exit(False);

  if not ReadWordTIFF(tiffStart + 2, tiffMarker) then
    Exit(False);
  if tiffMarker <> 42 then
    Exit(False);

  if not ReadLongTIFF(tiffStart + 4, ifd0Offset) then
    Exit;

  if not FindLinkedIfds(tiffStart + Integer(ifd0Offset), exifIfdOffset, gpsIfdOffset) then
    Exit;

  target.Add('EXIF metadata:');
  ParseIfdForDisplay(tiffStart + Integer(ifd0Offset), '  ');
  if exifIfdOffset <> 0 then
    ParseIfdForDisplay(tiffStart + Integer(exifIfdOffset), '  ');
  if gpsIfdOffset <> 0 then
    ParseGpsIfd(tiffStart + Integer(gpsIfdOffset))
  else
    target.Add('  GPS location: not found in EXIF metadata.');

  Result := True;
end;

end.
