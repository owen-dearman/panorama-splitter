unit PanoramaConfigUnit;

interface

uses
  PanoramaDataUnit;

type
  TPanoramaConfigLoader = class
  public
    class function LoadOrDefault(const FilePath: string): TPanoramaAppConfig; static;
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.Generics.Collections,
  System.IOUtils,
  System.JSON;

class function TPanoramaConfigLoader.LoadOrDefault(const FilePath: string): TPanoramaAppConfig;
var
  jsonText: string;
  root: TJSONObject;
  arr: TJSONArray;
  i: Integer;
  item: TJSONObject;
begin
  Result := TPanoramaAppConfig.BuildDefault;
  if not TFile.Exists(FilePath) then
    Exit;

  jsonText := TFile.ReadAllText(FilePath, TEncoding.UTF8);
  root := TJSONObject.ParseJSONValue(jsonText) as TJSONObject;
  if root = nil then
    Exit;
  try
    Result.MaxSegments := root.GetValue<Integer>('maxSegments', Result.MaxSegments);
    Result.DefaultBlurLevelIndex := root.GetValue<Integer>('defaultBlurLevelIndex', Result.DefaultBlurLevelIndex);

    arr := root.Values['instagramPresets'] as TJSONArray;
    if (arr <> nil) and (arr.Count > 0) then
    begin
      SetLength(Result.InstagramPresets, arr.Count);
      for i := 0 to arr.Count - 1 do
      begin
        item := arr.Items[i] as TJSONObject;
        if item = nil then
          Continue;
        Result.InstagramPresets[i].Name := item.GetValue<string>('name', 'Preset');
        Result.InstagramPresets[i].Width := item.GetValue<Integer>('width', 1080);
        Result.InstagramPresets[i].Height := item.GetValue<Integer>('height', 1080);
      end;
    end;

    arr := root.Values['ratioOptions'] as TJSONArray;
    if (arr <> nil) and (arr.Count > 0) then
    begin
      SetLength(Result.RatioOptions, arr.Count);
      for i := 0 to arr.Count - 1 do
      begin
        item := arr.Items[i] as TJSONObject;
        if item = nil then
          Continue;
        Result.RatioOptions[i].DisplayText := item.GetValue<string>('label', '1:1');
        Result.RatioOptions[i].RatioWidth := item.GetValue<Integer>('ratioWidth', 1);
        Result.RatioOptions[i].RatioHeight := item.GetValue<Integer>('ratioHeight', 1);
      end;
    end;

    arr := root.Values['blurLevels'] as TJSONArray;
    if (arr <> nil) and (arr.Count > 0) then
    begin
      SetLength(Result.BlurLevels, arr.Count);
      for i := 0 to arr.Count - 1 do
      begin
        item := arr.Items[i] as TJSONObject;
        if item = nil then
          Continue;
        Result.BlurLevels[i].Name := item.GetValue<string>('name', 'Blur');
        Result.BlurLevels[i].Passes := item.GetValue<Integer>('passes', 2);
        Result.BlurLevels[i].DownscaleDivisor := item.GetValue<Integer>('downscaleDivisor', 8);
      end;
    end;

    Result.MaxSegments := EnsureRange(Result.MaxSegments, 1, 100);
    if Length(Result.BlurLevels) = 0 then
      Result := TPanoramaAppConfig.BuildDefault;
    Result.DefaultBlurLevelIndex := EnsureRange(Result.DefaultBlurLevelIndex, 0, Max(0, Length(Result.BlurLevels) - 1));
  finally
    root.Free;
  end;
end;

end.

