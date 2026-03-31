unit PanoramaAlgorithmsUnit;

interface

uses
  System.SysUtils,
  System.Math,
  System.Types,
  Winapi.Windows,
  Vcl.Graphics;

type
  TPanoramaAlgorithms = class
  public
    class procedure ProgressiveResizeBitmap(const sourceBitmap: TBitmap; destBitmap: TBitmap;
      targetWidth, targetHeight: Integer); static;
    class procedure ApplyBlurBackground(bitmap: TBitmap; passes, downscaleDivisor: Integer); static;
    class procedure ApplyStrongBlurBackground(bitmap: TBitmap); static;
    class procedure ApplyGrayscaleInPlace(bitmap: TBitmap); static;
    class function BuildAspectRatioText(width, height: Integer): string; static;
  end;

implementation

procedure StretchDrawHighQuality(destCanvas: TCanvas; const destRect: TRect;
  sourceCanvas: TCanvas; const sourceRect: TRect);
var
  brushOrg: TPoint;
begin
  SetStretchBltMode(destCanvas.Handle, HALFTONE);
  SetBrushOrgEx(destCanvas.Handle, 0, 0, @brushOrg);
  StretchBlt(
    destCanvas.Handle,
    destRect.Left, destRect.Top, destRect.Right - destRect.Left, destRect.Bottom - destRect.Top,
    sourceCanvas.Handle,
    sourceRect.Left, sourceRect.Top, sourceRect.Right - sourceRect.Left, sourceRect.Bottom - sourceRect.Top,
    SRCCOPY
  );
end;

class procedure TPanoramaAlgorithms.ProgressiveResizeBitmap(const sourceBitmap: TBitmap; destBitmap: TBitmap;
  targetWidth, targetHeight: Integer);
var
  currentBitmap: TBitmap;
  nextBitmap: TBitmap;
  currentWidth: Integer;
  currentHeight: Integer;
  nextWidth: Integer;
  nextHeight: Integer;
begin
  currentBitmap := TBitmap.Create;
  nextBitmap := TBitmap.Create;
  try
    currentBitmap.PixelFormat := pf32bit;
    currentBitmap.Assign(sourceBitmap);
    currentWidth := currentBitmap.Width;
    currentHeight := currentBitmap.Height;

    while ((currentWidth > targetWidth * 2) or (currentHeight > targetHeight * 2)) do
    begin
      nextWidth := Max(targetWidth, currentWidth div 2);
      nextHeight := Max(targetHeight, currentHeight div 2);
      nextBitmap.PixelFormat := pf32bit;
      nextBitmap.SetSize(nextWidth, nextHeight);
      StretchDrawHighQuality(
        nextBitmap.Canvas, Rect(0, 0, nextWidth, nextHeight),
        currentBitmap.Canvas, Rect(0, 0, currentWidth, currentHeight)
      );
      currentBitmap.Assign(nextBitmap);
      currentWidth := currentBitmap.Width;
      currentHeight := currentBitmap.Height;
    end;

    destBitmap.PixelFormat := pf32bit;
    destBitmap.SetSize(targetWidth, targetHeight);
    StretchDrawHighQuality(
      destBitmap.Canvas, Rect(0, 0, targetWidth, targetHeight),
      currentBitmap.Canvas, Rect(0, 0, currentWidth, currentHeight)
    );
  finally
    nextBitmap.Free;
    currentBitmap.Free;
  end;
end;

class procedure TPanoramaAlgorithms.ApplyStrongBlurBackground(bitmap: TBitmap);
begin
  TPanoramaAlgorithms.ApplyBlurBackground(bitmap, 2, 8);
end;

class procedure TPanoramaAlgorithms.ApplyBlurBackground(bitmap: TBitmap; passes, downscaleDivisor: Integer);
var
  tiny: TBitmap;
  w: Integer;
  h: Integer;
  tw: Integer;
  th: Integer;
  longSide: Integer;
  smallLong: Integer;
  passIndex: Integer;
begin
  if bitmap.Empty then
    Exit;
  if passes < 1 then
    passes := 1;
  if downscaleDivisor < 2 then
    downscaleDivisor := 2;

  bitmap.PixelFormat := pf32bit;
  w := bitmap.Width;
  h := bitmap.Height;
  tiny := TBitmap.Create;
  try
    for passIndex := 1 to passes do
    begin
      longSide := Max(w, h);
      smallLong := Max(6, longSide div downscaleDivisor);
      tw := Max(1, Round(w * (smallLong / longSide)));
      th := Max(1, Round(h * (smallLong / longSide)));
      TPanoramaAlgorithms.ProgressiveResizeBitmap(bitmap, tiny, tw, th);
      TPanoramaAlgorithms.ProgressiveResizeBitmap(tiny, bitmap, w, h);
    end;
  finally
    tiny.Free;
  end;
end;

class procedure TPanoramaAlgorithms.ApplyGrayscaleInPlace(bitmap: TBitmap);
type
  PRgbQuadArray = ^TRgbQuadArray;
  TRgbQuadArray = array[0..32767] of TRGBQuad;
var
  y: Integer;
  x: Integer;
  row: PRgbQuadArray;
  grayValue: Byte;
begin
  if bitmap.Empty then
    Exit;

  bitmap.PixelFormat := pf32bit;
  for y := 0 to bitmap.Height - 1 do
  begin
    row := PRgbQuadArray(bitmap.ScanLine[y]);
    for x := 0 to bitmap.Width - 1 do
    begin
      grayValue := Byte((row[x].rgbRed * 77 + row[x].rgbGreen * 150 + row[x].rgbBlue * 29) div 256);
      row[x].rgbRed := grayValue;
      row[x].rgbGreen := grayValue;
      row[x].rgbBlue := grayValue;
    end;
  end;
end;

function EuclideanGCD(a, b: Integer): Integer;
var
  tempValue: Integer;
begin
  a := Abs(a);
  b := Abs(b);
  while b <> 0 do
  begin
    tempValue := a mod b;
    a := b;
    b := tempValue;
  end;
  Result := a;
end;

class function TPanoramaAlgorithms.BuildAspectRatioText(width, height: Integer): string;
var
  gcdValue: Integer;
begin
  if (width <= 0) or (height <= 0) then
    Exit('-');

  gcdValue := EuclideanGCD(width, height);
  if gcdValue <= 0 then
    Exit('-');

  Result := Format('%d:%d (%.3f)', [width div gcdValue, height div gcdValue, width / height]);
end;

end.
