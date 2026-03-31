unit PanoramaDataUnit;

interface

type
  TInstagramPresetInfo = record
    Name: string;
    Width: Integer;
    Height: Integer;
  end;

  TRatioOptionInfo = record
    DisplayText: string;
    RatioWidth: Integer;
    RatioHeight: Integer;
  end;

  TBlurLevelInfo = record
    Name: string;
    Passes: Integer;
    DownscaleDivisor: Integer;
  end;

  TPanoramaAppConfig = record
    MaxSegments: Integer;
    InstagramPresets: TArray<TInstagramPresetInfo>;
    RatioOptions: TArray<TRatioOptionInfo>;
    BlurLevels: TArray<TBlurLevelInfo>;
    DefaultBlurLevelIndex: Integer;
    class function BuildDefault: TPanoramaAppConfig; static;
  end;

implementation

class function TPanoramaAppConfig.BuildDefault: TPanoramaAppConfig;
begin
  Result.MaxSegments := 10;
  Result.DefaultBlurLevelIndex := 1;

  SetLength(Result.InstagramPresets, 3);
  Result.InstagramPresets[0].Name := 'Portrait 4:5 (1080 x 1350)';
  Result.InstagramPresets[0].Width := 1080;
  Result.InstagramPresets[0].Height := 1350;
  Result.InstagramPresets[1].Name := 'Square 1:1 (1080 x 1080)';
  Result.InstagramPresets[1].Width := 1080;
  Result.InstagramPresets[1].Height := 1080;
  Result.InstagramPresets[2].Name := 'Landscape 1.91:1 (1080 x 566)';
  Result.InstagramPresets[2].Width := 1080;
  Result.InstagramPresets[2].Height := 566;

  SetLength(Result.RatioOptions, 8);
  Result.RatioOptions[0].DisplayText := '4:5 (portrait)';
  Result.RatioOptions[0].RatioWidth := 4;
  Result.RatioOptions[0].RatioHeight := 5;
  Result.RatioOptions[1].DisplayText := '1:1 (square)';
  Result.RatioOptions[1].RatioWidth := 1;
  Result.RatioOptions[1].RatioHeight := 1;
  Result.RatioOptions[2].DisplayText := '1.91:1 (landscape)';
  Result.RatioOptions[2].RatioWidth := 191;
  Result.RatioOptions[2].RatioHeight := 100;
  Result.RatioOptions[3].DisplayText := '1:3 (tall)';
  Result.RatioOptions[3].RatioWidth := 1;
  Result.RatioOptions[3].RatioHeight := 3;
  Result.RatioOptions[4].DisplayText := '2:3 (tall)';
  Result.RatioOptions[4].RatioWidth := 2;
  Result.RatioOptions[4].RatioHeight := 3;
  Result.RatioOptions[5].DisplayText := '3:2 (wide)';
  Result.RatioOptions[5].RatioWidth := 3;
  Result.RatioOptions[5].RatioHeight := 2;
  Result.RatioOptions[6].DisplayText := '16:9 (wide)';
  Result.RatioOptions[6].RatioWidth := 16;
  Result.RatioOptions[6].RatioHeight := 9;
  Result.RatioOptions[7].DisplayText := '9:16 (story)';
  Result.RatioOptions[7].RatioWidth := 9;
  Result.RatioOptions[7].RatioHeight := 16;

  SetLength(Result.BlurLevels, 3);
  Result.BlurLevels[0].Name := 'Light';
  Result.BlurLevels[0].Passes := 1;
  Result.BlurLevels[0].DownscaleDivisor := 8;
  Result.BlurLevels[1].Name := 'Medium';
  Result.BlurLevels[1].Passes := 2;
  Result.BlurLevels[1].DownscaleDivisor := 8;
  Result.BlurLevels[2].Name := 'Heavy';
  Result.BlurLevels[2].Passes := 3;
  Result.BlurLevels[2].DownscaleDivisor := 10;
end;

end.

