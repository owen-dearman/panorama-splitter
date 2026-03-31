unit PanoramaRenderUnit;

interface

uses
  System.SysUtils,
  System.Math,
  System.Types,
  System.Generics.Collections,
  Vcl.Graphics;

type
  TRenderOptions = record
    Segments: Integer;
    UseInstagramPreset: Boolean;
    PresetWidth: Integer;
    PresetHeight: Integer;
    InstagramModeIndex: Integer; // 0=Fill, 1=Fit
    PadStyleIndex: Integer;      // 0=Black, 1=White, 2=Blurred
    OutputColourIndex: Integer;  // 0=Colour, 1=B&W
    CropAnchorY: Double;         // 0..1
    ApplyNonInstagramRatio: Boolean;
    NonInstagramRatioWidth: Integer;
    NonInstagramRatioHeight: Integer;
    BlurPasses: Integer;
    BlurDownscaleDivisor: Integer;
  end;

  TPanoramaRenderer = class
  public
    class function BuildWorkingBitmapForOutput(const SourceBitmap: TBitmap;
      const Options: TRenderOptions; out BaseWidth, Remainder: Integer): TBitmap; static;
    class procedure GenerateOutputSlices(const SourceBitmap: TBitmap;
      const Options: TRenderOptions; Slices: TObjectList<TBitmap>); static;
    class function TryParseRatioText(const RatioText: string; out AWidth, AHeight: Integer): Boolean; static;
  end;

implementation

uses
  PanoramaAlgorithmsUnit;

procedure ApplyOutputColourMode(const OutputColourIndex: Integer; ABitmap: TBitmap);
begin
  if (OutputColourIndex <> 1) or ABitmap.Empty then
    Exit;
  TPanoramaAlgorithms.ApplyGrayscaleInPlace(ABitmap);
end;

class function TPanoramaRenderer.TryParseRatioText(const RatioText: string; out AWidth, AHeight: Integer): Boolean;
var
  s: string;
  parts: TArray<string>;
  leftVal: Double;
  rightVal: Double;
  fs: TFormatSettings;
begin
  Result := False;
  AWidth := 0;
  AHeight := 0;
  s := StringReplace(Trim(RatioText), ' ', '', [rfReplaceAll]);
  if s = '' then
    Exit;

  parts := s.Split([':']);
  if Length(parts) <> 2 then
    Exit;

  fs := TFormatSettings.Create;
  fs.DecimalSeparator := '.';
  leftVal := StrToFloatDef(StringReplace(parts[0], ',', '.', [rfReplaceAll]), -1.0, fs);
  rightVal := StrToFloatDef(StringReplace(parts[1], ',', '.', [rfReplaceAll]), -1.0, fs);
  if (leftVal <= 0) or (rightVal <= 0) then
    Exit;

  if (leftVal >= 10) or (rightVal >= 10) then
  begin
    AWidth := Round(leftVal);
    AHeight := Round(rightVal);
  end
  else
  begin
    AWidth := Round(leftVal * 100);
    AHeight := Round(rightVal * 100);
  end;

  Result := (AWidth > 0) and (AHeight > 0);
end;

class function TPanoramaRenderer.BuildWorkingBitmapForOutput(const SourceBitmap: TBitmap;
  const Options: TRenderOptions; out BaseWidth, Remainder: Integer): TBitmap;
var
  tempScaled: TBitmap;
  tempFitted: TBitmap;
  tempBackground: TBitmap;
  totalTargetWidth: Integer;
  scale: Double;
  scaledWidth: Integer;
  scaledHeight: Integer;
  cropLeft: Integer;
  cropTop: Integer;
  cropRangeY: Integer;
  drawLeft: Integer;
  drawTop: Integer;
  padColor: TColor;
  targetHeight: Integer;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf32bit;

  if Options.UseInstagramPreset then
  begin
    totalTargetWidth := Options.Segments * Options.PresetWidth;
    if Options.InstagramModeIndex = 0 then
    begin
      scale := Max(
        totalTargetWidth / SourceBitmap.Width,
        Options.PresetHeight / SourceBitmap.Height
      );
      scaledWidth := Ceil(SourceBitmap.Width * scale);
      scaledHeight := Ceil(SourceBitmap.Height * scale);

      tempScaled := TBitmap.Create;
      try
        TPanoramaAlgorithms.ProgressiveResizeBitmap(SourceBitmap, tempScaled, scaledWidth, scaledHeight);
        Result.SetSize(totalTargetWidth, Options.PresetHeight);
        cropLeft := (scaledWidth - totalTargetWidth) div 2;
        cropRangeY := Max(0, scaledHeight - Options.PresetHeight);
        cropTop := Round(cropRangeY * EnsureRange(Options.CropAnchorY, 0.0, 1.0));
        Result.Canvas.CopyRect(
          Rect(0, 0, totalTargetWidth, Options.PresetHeight),
          tempScaled.Canvas,
          Rect(cropLeft, cropTop, cropLeft + totalTargetWidth, cropTop + Options.PresetHeight)
        );
      finally
        tempScaled.Free;
      end;
    end
    else
    begin
      scale := Min(
        totalTargetWidth / SourceBitmap.Width,
        Options.PresetHeight / SourceBitmap.Height
      );
      scaledWidth := Ceil(SourceBitmap.Width * scale);
      scaledHeight := Ceil(SourceBitmap.Height * scale);

      Result.SetSize(totalTargetWidth, Options.PresetHeight);
      case Options.PadStyleIndex of
        1: padColor := clWhite;
        2: padColor := clBlack;
      else
        padColor := clBlack;
      end;
      Result.Canvas.Brush.Color := padColor;
      Result.Canvas.FillRect(Rect(0, 0, totalTargetWidth, Options.PresetHeight));

      if Options.PadStyleIndex = 2 then
      begin
        tempBackground := TBitmap.Create;
        try
          TPanoramaAlgorithms.ProgressiveResizeBitmap(SourceBitmap, tempBackground, totalTargetWidth, Options.PresetHeight);
          TPanoramaAlgorithms.ApplyBlurBackground(tempBackground, Options.BlurPasses, Options.BlurDownscaleDivisor);
          Result.Canvas.Draw(0, 0, tempBackground);
        finally
          tempBackground.Free;
        end;
      end;

      tempFitted := TBitmap.Create;
      try
        TPanoramaAlgorithms.ProgressiveResizeBitmap(SourceBitmap, tempFitted, scaledWidth, scaledHeight);
        drawLeft := (totalTargetWidth - scaledWidth) div 2;
        drawTop := (Options.PresetHeight - scaledHeight) div 2;
        Result.Canvas.CopyRect(
          Rect(drawLeft, drawTop, drawLeft + scaledWidth, drawTop + scaledHeight),
          tempFitted.Canvas,
          Rect(0, 0, scaledWidth, scaledHeight)
        );
      finally
        tempFitted.Free;
      end;
    end;
    BaseWidth := Options.PresetWidth;
    Remainder := 0;
  end
  else
  begin
    Result.Assign(SourceBitmap);
    if Options.ApplyNonInstagramRatio and
      (Options.NonInstagramRatioWidth > 0) and (Options.NonInstagramRatioHeight > 0) then
    begin
      BaseWidth := Result.Width div Options.Segments;
      Remainder := Result.Width mod Options.Segments;
      targetHeight := Max(1, Round((Result.Width / Options.Segments) *
        (Options.NonInstagramRatioHeight / Options.NonInstagramRatioWidth)));

      scale := Max(Result.Width / SourceBitmap.Width, targetHeight / SourceBitmap.Height);
      scaledWidth := Ceil(SourceBitmap.Width * scale);
      scaledHeight := Ceil(SourceBitmap.Height * scale);

      tempScaled := TBitmap.Create;
      try
        TPanoramaAlgorithms.ProgressiveResizeBitmap(SourceBitmap, tempScaled, scaledWidth, scaledHeight);
        Result.SetSize(Result.Width, targetHeight);
        cropLeft := (scaledWidth - Result.Width) div 2;
        cropRangeY := Max(0, scaledHeight - targetHeight);
        cropTop := Round(cropRangeY * EnsureRange(Options.CropAnchorY, 0.0, 1.0));
        Result.Canvas.CopyRect(
          Rect(0, 0, Result.Width, targetHeight),
          tempScaled.Canvas,
          Rect(cropLeft, cropTop, cropLeft + Result.Width, cropTop + targetHeight)
        );
      finally
        tempScaled.Free;
      end;
    end
    else
    begin
      BaseWidth := Result.Width div Options.Segments;
      Remainder := Result.Width mod Options.Segments;
    end;
  end;

  ApplyOutputColourMode(Options.OutputColourIndex, Result);
end;

class procedure TPanoramaRenderer.GenerateOutputSlices(const SourceBitmap: TBitmap;
  const Options: TRenderOptions; Slices: TObjectList<TBitmap>);
var
  workingBitmap: TBitmap;
  baseWidth: Integer;
  remainder: Integer;
  currentX: Integer;
  currentWidth: Integer;
  segmentIndex: Integer;
  sliceBitmap: TBitmap;
begin
  Slices.Clear;
  workingBitmap := TPanoramaRenderer.BuildWorkingBitmapForOutput(SourceBitmap, Options, baseWidth, remainder);
  try
    currentX := 0;
    for segmentIndex := 0 to Options.Segments - 1 do
    begin
      currentWidth := baseWidth;
      if segmentIndex < remainder then
        Inc(currentWidth);

      sliceBitmap := TBitmap.Create;
      sliceBitmap.PixelFormat := pf32bit;
      sliceBitmap.SetSize(currentWidth, workingBitmap.Height);
      sliceBitmap.Canvas.CopyRect(
        Rect(0, 0, currentWidth, workingBitmap.Height),
        workingBitmap.Canvas,
        Rect(currentX, 0, currentX + currentWidth, workingBitmap.Height)
      );
      Slices.Add(sliceBitmap);
      Inc(currentX, currentWidth);
    end;
  finally
    workingBitmap.Free;
  end;
end;

end.

