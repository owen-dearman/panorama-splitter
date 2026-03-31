unit MainFormUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  System.Types,
  System.IOUtils,
  System.IniFiles,
  System.TypInfo,
  System.Generics.Collections,
  Winapi.Windows,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  System.UITypes,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.FileCtrl,
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage,
  PanoramaAlgorithmsUnit,
  PanoramaRenderUnit,
  PanoramaDataUnit,
  PanoramaConfigUnit,
  JpegExifMetadataUnit,
  PreviewFormUnit;

type
  TMainForm = class(TForm)
    pnlTop: TPanel;
    btnLoadImage: TButton;
    btnSplitAndSave: TButton;
    btnPreviewOutput: TButton;
    dlgOpenImage: TOpenDialog;
    lblSplitInfo: TLabel;
    memMetadata: TMemo;
    lblQualityWarning: TLabel;
    btnFitToScreen: TButton;
    btnZoomIn: TButton;
    btnZoomOut: TButton;
    lblZoom: TLabel;
    mmMain: TMainMenu;
    miFile: TMenuItem;
    miFileLoadImage: TMenuItem;
    miFileSelectOutput: TMenuItem;
    miFileSplitSave: TMenuItem;
    miFileThemes: TMenuItem;
    miFileThemeLight: TMenuItem;
    miFileThemeDark: TMenuItem;
    miFileSeparator1: TMenuItem;
    miFileExit: TMenuItem;
    miView: TMenuItem;
    miViewFitToScreen: TMenuItem;
    miViewZoomIn: TMenuItem;
    miViewZoomOut: TMenuItem;
    miExport: TMenuItem;
    miExportColour: TMenuItem;
    miExportBW: TMenuItem;
    pnlPreviewTools: TPanel;
    grpExportOptions: TGroupBox;
    lblSegments: TLabel;
    trkSegments: TTrackBar;
    lblSegmentsValue: TLabel;
    chkInstagramPreset: TCheckBox;
    lblPreset: TLabel;
    cboInstagramPreset: TComboBox;
    lblInstagramMode: TLabel;
    cboInstagramMode: TComboBox;
    lblPadStyle: TLabel;
    cboPadStyle: TComboBox;
    lblOutputColour: TLabel;
    cboOutputColour: TComboBox;
    lblCropPercent: TLabel;
    edtCropPercent: TEdit;
    udCropPercent: TUpDown;
    lblCropPercentSuffix: TLabel;
    lblRatioMode: TLabel;
    cboRatioMode: TComboBox;
    lblBlurLevel: TLabel;
    cboBlurLevel: TComboBox;
    sbxPreview: TScrollBox;
    imgPreview: TImage;
    pbSplitOverlay: TPaintBox;
    pnlOutput: TPanel;
    lblOutputFolder: TLabel;
    edtOutputFolder: TEdit;
    btnBrowseOutput: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonLoadImageClick(Sender: TObject);
    procedure ButtonBrowseOutputClick(Sender: TObject);
    procedure OutputFolderEditExit(Sender: TObject);
    procedure ButtonSplitAndSaveClick(Sender: TObject);
    procedure ButtonPreviewOutputClick(Sender: TObject);
    procedure EditSegmentsChange(Sender: TObject);
    procedure RatioOptionsChange(Sender: TObject);
    procedure CropPercentEditChange(Sender: TObject);
    procedure CheckBoxInstagramPresetClick(Sender: TObject);
    procedure ComboBoxInstagramPresetChange(Sender: TObject);
    procedure ButtonFitToScreenClick(Sender: TObject);
    procedure ButtonZoomInClick(Sender: TObject);
    procedure ButtonZoomOutClick(Sender: TObject);
    procedure ScrollBoxPreviewResize(Sender: TObject);
    procedure MenuFileLoadImageClick(Sender: TObject);
    procedure MenuFileSelectOutputClick(Sender: TObject);
    procedure MenuFileSplitSaveClick(Sender: TObject);
    procedure MenuFileThemeLightClick(Sender: TObject);
    procedure MenuFileThemeDarkClick(Sender: TObject);
    procedure MenuFileExitClick(Sender: TObject);
    procedure MenuViewFitToScreenClick(Sender: TObject);
    procedure MenuViewZoomInClick(Sender: TObject);
    procedure MenuViewZoomOutClick(Sender: TObject);
    procedure MenuExportColourClick(Sender: TObject);
    procedure MenuExportBWClick(Sender: TObject);
    procedure OutputColourChange(Sender: TObject);
    procedure InstagramOptionsChange(Sender: TObject);
    procedure SplitOverlayPaint(Sender: TObject);
    procedure PreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PreviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PreviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FSourceBitmap: TBitmap;
    FPreviewBitmap: TBitmap;
    FSourceFilePath: string;
    FOutputFolder: string;
    FAppConfig: TPanoramaAppConfig;
    FZoomFactor: Double;
    FFitToScreen: Boolean;
    FCropAnchorY: Double;
    FIsDraggingCrop: Boolean;
    FCropDragStartY: Integer;
    FCropDragStartAnchorY: Double;
    FUpdatingCropFromCode: Boolean;
    FLastBaseWidth: Integer;
    FLastRemainder: Integer;
    FLastWorkingWidth: Integer;
    procedure UpdateImageInfo;
    procedure UpdateSplitInfo;
    procedure UpdateMetadataInfo;
    procedure RefreshMainPreviewFromSettings;
    procedure UpdatePreviewZoom;
    procedure FitPreviewToScreen;
    procedure SetZoomFactor(const AZoomFactor: Double; ADisableFitMode: Boolean = True);
    procedure UpdateColourMenuState;
    procedure UpdateZoomControlsState;
    function GetSegments: Integer;
    function GetPresetDimensions(out AWidth, AHeight: Integer): Boolean;
    function GetNonInstagramRatio(out AWidth, AHeight: Integer): Boolean;
    function PixelFormatBitsPerPixel(APixelFormat: TPixelFormat): Integer;
    procedure EnsureSourceLoaded;
    procedure SyncOutputFolderFromEdit;
    procedure EnsureOutputFolder;
    procedure UpdateSplitOverlay;
    procedure LayoutSplitInfoLabels;
    procedure ApplyLightTheme;
    procedure ApplyDarkTheme;
    procedure UpdateThemeMenuState;
    function GetConfigJsonPath: string;
    function GetSettingsIniPath: string;
    procedure LoadSettingsFromIni;
    procedure SaveSettingsToIni;
    procedure UpdateCropPercentEditFromAnchor;
    procedure UpdateExportOptionsCropState;
    function IsCropDragAvailable: Boolean;
    function BuildRenderOptions: TRenderOptions;
  public
    destructor Destroy; override;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
var
  idx: Integer;
begin
  FSourceBitmap := TBitmap.Create;
  FPreviewBitmap := TBitmap.Create;
  FOutputFolder := ExtractFilePath(ParamStr(0));

  dlgOpenImage.Filter :=
    'Image files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.bmp|All files (*.*)|*.*';
  dlgOpenImage.Options := dlgOpenImage.Options + [ofFileMustExist, ofPathMustExist];

  trkSegments.Min := 1;
  FAppConfig := TPanoramaConfigLoader.LoadOrDefault(GetConfigJsonPath);
  trkSegments.Max := FAppConfig.MaxSegments;
  trkSegments.Frequency := 1;
  trkSegments.Position := 3;
  lblSegmentsValue.Caption := IntToStr(trkSegments.Position);
  udCropPercent.Min := 0;
  udCropPercent.Max := 100;
  udCropPercent.Position := 50;
  FUpdatingCropFromCode := False;

  cboInstagramPreset.Items.Clear;
  for idx := 0 to High(FAppConfig.InstagramPresets) do
    cboInstagramPreset.Items.Add(FAppConfig.InstagramPresets[idx].Name);
  cboInstagramPreset.ItemIndex := 0;
  cboInstagramMode.Items.Clear;
  cboInstagramMode.Items.Add('Fill (crop)');
  cboInstagramMode.Items.Add('Fit (no crop, pad)');
  cboInstagramMode.ItemIndex := 0;
  cboPadStyle.Items.Clear;
  cboPadStyle.Items.Add('Black');
  cboPadStyle.Items.Add('White');
  cboPadStyle.Items.Add('Blurred');
  cboPadStyle.ItemIndex := 0;
  cboRatioMode.Items.Clear;
  for idx := 0 to High(FAppConfig.RatioOptions) do
    cboRatioMode.Items.Add(FAppConfig.RatioOptions[idx].DisplayText);
  cboRatioMode.ItemIndex := 0;
  cboBlurLevel.Items.Clear;
  for idx := 0 to High(FAppConfig.BlurLevels) do
    cboBlurLevel.Items.Add(FAppConfig.BlurLevels[idx].Name);
  cboBlurLevel.ItemIndex := EnsureRange(FAppConfig.DefaultBlurLevelIndex, 0, Max(0, cboBlurLevel.Items.Count - 1));
  chkInstagramPreset.Checked := True;
  cboOutputColour.Items.Clear;
  cboOutputColour.Items.Add('Colour');
  cboOutputColour.Items.Add('Black and White');
  cboOutputColour.ItemIndex := 0;
  FCropAnchorY := 0.5;
  FIsDraggingCrop := False;
  FZoomFactor := 1.0;
  FFitToScreen := True;
  edtOutputFolder.Text := FOutputFolder;
  lblSplitInfo.Caption := 'Split info: -';
  lblQualityWarning.Caption := '';
  LayoutSplitInfoLabels;
  memMetadata.Lines.Text := 'Load an image to see file name, size, ratio, and metadata.';
  lblZoom.Caption := 'Zoom: -';

  imgPreview.AutoSize := False;
  imgPreview.Stretch := True;
  imgPreview.Proportional := True;
  pbSplitOverlay.Visible := False;
  pbSplitOverlay.Enabled := True;
  sbxPreview.AutoScroll := True;
  cboInstagramMode.Enabled := chkInstagramPreset.Checked;
  cboPadStyle.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1);
  cboBlurLevel.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1) and (cboPadStyle.ItemIndex = 2);
  lblBlurLevel.Visible := cboBlurLevel.Enabled;
  cboBlurLevel.Visible := cboBlurLevel.Enabled;
  cboRatioMode.Enabled := not chkInstagramPreset.Checked;
  lblRatioMode.Enabled := cboRatioMode.Enabled;
  UpdateCropPercentEditFromAnchor;
  UpdateExportOptionsCropState;
  UpdateColourMenuState;
  ApplyLightTheme;
  UpdateThemeMenuState;
  LoadSettingsFromIni;
  UpdateZoomControlsState;
end;

destructor TMainForm.Destroy;
begin
  FPreviewBitmap.Free;
  FSourceBitmap.Free;
  inherited;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettingsToIni;
end;

procedure TMainForm.ButtonLoadImageClick(Sender: TObject);
var
  pic: TPicture;
begin
  if not dlgOpenImage.Execute then
    Exit;

  FSourceFilePath := dlgOpenImage.FileName;

  pic := TPicture.Create;
  try
    pic.LoadFromFile(FSourceFilePath);
    FSourceBitmap.Assign(pic.Graphic);
    FSourceBitmap.PixelFormat := pf32bit;
    FCropAnchorY := 0.5;
    UpdateCropPercentEditFromAnchor;
  finally
    pic.Free;
  end;

  RefreshMainPreviewFromSettings;
  FitPreviewToScreen;
  UpdateImageInfo;
  UpdateSplitInfo;
  UpdateZoomControlsState;
  UpdateSplitOverlay;
end;

procedure TMainForm.SyncOutputFolderFromEdit;
begin
  FOutputFolder := Trim(edtOutputFolder.Text);
end;

procedure TMainForm.OutputFolderEditExit(Sender: TObject);
begin
  SyncOutputFolderFromEdit;
end;

procedure TMainForm.ButtonBrowseOutputClick(Sender: TObject);
var
  chosenDir: string;
begin
  SyncOutputFolderFromEdit;
  chosenDir := FOutputFolder;
  if chosenDir = '' then
    chosenDir := ExtractFilePath(ParamStr(0));
  if SelectDirectory('Select output folder for split images', '', chosenDir) then
  begin
    FOutputFolder := chosenDir;
    edtOutputFolder.Text := FOutputFolder;
  end;
end;

procedure TMainForm.ButtonSplitAndSaveClick(Sender: TObject);
var
  segments: Integer;
  segmentIndex: Integer;
  outputBaseName: string;
  outputPath: string;
  numberWidth: Integer;
  slices: TObjectList<TBitmap>;
begin
  EnsureSourceLoaded;
  EnsureOutputFolder;

  segments := GetSegments;
  if segments < 1 then
    raise Exception.Create('Segment count must be at least 1.');

  if (not chkInstagramPreset.Checked) and (segments > FSourceBitmap.Width) then
    raise Exception.Create('Segment count cannot exceed image width in pixels.');

  slices := TObjectList<TBitmap>.Create(True);
  try
    TPanoramaRenderer.GenerateOutputSlices(FSourceBitmap, BuildRenderOptions, slices);
  outputBaseName := ChangeFileExt(ExtractFileName(FSourceFilePath), '');
  numberWidth := Max(2, Length(IntToStr(segments)));

    for segmentIndex := 0 to slices.Count - 1 do
    begin
      with TPngImage.Create do
      try
        Assign(slices[segmentIndex]);
        outputPath := IncludeTrailingPathDelimiter(FOutputFolder) +
          Format('%s_%.*d.png', [outputBaseName, numberWidth, segmentIndex + 1]);
        SaveToFile(outputPath);
      finally
        Free;
      end;
    end;
  finally
    slices.Free;
  end;

  MessageDlg(
    Format('Done. Saved %d segments to:%s%s', [segments, sLineBreak, FOutputFolder]),
    mtInformation,
    [mbOK],
    0
  );
end;

procedure TMainForm.ButtonPreviewOutputClick(Sender: TObject);
var
  segments: Integer;
  slices: TObjectList<TBitmap>;
begin
  EnsureSourceLoaded;

  segments := GetSegments;
  if segments < 1 then
    raise Exception.Create('Segment count must be at least 1.');
  if (not chkInstagramPreset.Checked) and (segments > FSourceBitmap.Width) then
    raise Exception.Create('Segment count cannot exceed image width in pixels.');

  slices := TObjectList<TBitmap>.Create(True);
  try
    TPanoramaRenderer.GenerateOutputSlices(FSourceBitmap, BuildRenderOptions, slices);
    TOutputPreviewForm.ShowSlices(Self, slices);
  finally
    slices.Free;
  end;
end;

function TMainForm.BuildRenderOptions: TRenderOptions;
begin
  Result.Segments := GetSegments;
  Result.UseInstagramPreset := GetPresetDimensions(Result.PresetWidth, Result.PresetHeight);
  Result.InstagramModeIndex := cboInstagramMode.ItemIndex;
  Result.PadStyleIndex := cboPadStyle.ItemIndex;
  Result.OutputColourIndex := cboOutputColour.ItemIndex;
  Result.CropAnchorY := FCropAnchorY;
  Result.ApplyNonInstagramRatio := GetNonInstagramRatio(
    Result.NonInstagramRatioWidth,
    Result.NonInstagramRatioHeight
  );
  if (cboBlurLevel.ItemIndex >= 0) and (cboBlurLevel.ItemIndex <= High(FAppConfig.BlurLevels)) then
  begin
    Result.BlurPasses := FAppConfig.BlurLevels[cboBlurLevel.ItemIndex].Passes;
    Result.BlurDownscaleDivisor := FAppConfig.BlurLevels[cboBlurLevel.ItemIndex].DownscaleDivisor;
  end
  else
  begin
    Result.BlurPasses := 2;
    Result.BlurDownscaleDivisor := 8;
  end;
end;

procedure TMainForm.EditSegmentsChange(Sender: TObject);
begin
  lblSegmentsValue.Caption := IntToStr(GetSegments);
  RefreshMainPreviewFromSettings;
  FitPreviewToScreen;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.RatioOptionsChange(Sender: TObject);
begin
  cboRatioMode.Enabled := not chkInstagramPreset.Checked;
  lblRatioMode.Enabled := cboRatioMode.Enabled;
  UpdateExportOptionsCropState;
  RefreshMainPreviewFromSettings;
  FitPreviewToScreen;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.CheckBoxInstagramPresetClick(Sender: TObject);
begin
  cboInstagramPreset.Enabled := chkInstagramPreset.Checked;
  cboInstagramMode.Enabled := chkInstagramPreset.Checked;
  cboPadStyle.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1);
  cboRatioMode.Enabled := not chkInstagramPreset.Checked;
  lblRatioMode.Enabled := cboRatioMode.Enabled;
  cboBlurLevel.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1) and (cboPadStyle.ItemIndex = 2);
  lblBlurLevel.Visible := cboBlurLevel.Enabled;
  cboBlurLevel.Visible := cboBlurLevel.Enabled;
  UpdateExportOptionsCropState;
  RefreshMainPreviewFromSettings;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.ComboBoxInstagramPresetChange(Sender: TObject);
begin
  RefreshMainPreviewFromSettings;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.ButtonFitToScreenClick(Sender: TObject);
begin
  FitPreviewToScreen;
end;

procedure TMainForm.ButtonZoomInClick(Sender: TObject);
begin
  SetZoomFactor(FZoomFactor * 1.25);
end;

procedure TMainForm.ButtonZoomOutClick(Sender: TObject);
begin
  SetZoomFactor(FZoomFactor / 1.25);
end;

procedure TMainForm.ScrollBoxPreviewResize(Sender: TObject);
begin
  if FFitToScreen and (not FSourceBitmap.Empty) then
    FitPreviewToScreen;
end;

procedure TMainForm.MenuFileLoadImageClick(Sender: TObject);
begin
  ButtonLoadImageClick(Sender);
end;

procedure TMainForm.MenuFileSelectOutputClick(Sender: TObject);
begin
  ButtonBrowseOutputClick(Sender);
end;

procedure TMainForm.MenuFileSplitSaveClick(Sender: TObject);
begin
  ButtonSplitAndSaveClick(Sender);
end;

procedure TMainForm.MenuFileThemeLightClick(Sender: TObject);
begin
  ApplyLightTheme;
  UpdateThemeMenuState;
end;

procedure TMainForm.MenuFileThemeDarkClick(Sender: TObject);
begin
  ApplyDarkTheme;
  UpdateThemeMenuState;
end;

procedure TMainForm.MenuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MenuViewFitToScreenClick(Sender: TObject);
begin
  ButtonFitToScreenClick(Sender);
end;

procedure TMainForm.MenuViewZoomInClick(Sender: TObject);
begin
  ButtonZoomInClick(Sender);
end;

procedure TMainForm.MenuViewZoomOutClick(Sender: TObject);
begin
  ButtonZoomOutClick(Sender);
end;

procedure TMainForm.MenuExportColourClick(Sender: TObject);
begin
  cboOutputColour.ItemIndex := 0;
  UpdateColourMenuState;
  RefreshMainPreviewFromSettings;
  UpdateSplitOverlay;
end;

procedure TMainForm.MenuExportBWClick(Sender: TObject);
begin
  cboOutputColour.ItemIndex := 1;
  UpdateColourMenuState;
  RefreshMainPreviewFromSettings;
  UpdateSplitOverlay;
end;

procedure TMainForm.OutputColourChange(Sender: TObject);
begin
  UpdateColourMenuState;
  RefreshMainPreviewFromSettings;
  UpdateSplitOverlay;
end;

procedure TMainForm.InstagramOptionsChange(Sender: TObject);
begin
  cboPadStyle.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1);
  cboBlurLevel.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1) and (cboPadStyle.ItemIndex = 2);
  lblBlurLevel.Visible := cboBlurLevel.Enabled;
  cboBlurLevel.Visible := cboBlurLevel.Enabled;
  UpdateExportOptionsCropState;
  RefreshMainPreviewFromSettings;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.CropPercentEditChange(Sender: TObject);
var
  p: Integer;
begin
  if FUpdatingCropFromCode then
    Exit;
  p := EnsureRange(StrToIntDef(Trim(edtCropPercent.Text), udCropPercent.Position), 0, 100);
  if udCropPercent.Position <> p then
  begin
    FUpdatingCropFromCode := True;
    try
      udCropPercent.Position := p;
    finally
      FUpdatingCropFromCode := False;
    end;
  end;
  FCropAnchorY := p / 100.0;
  RefreshMainPreviewFromSettings;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.UpdateCropPercentEditFromAnchor;
var
  p: Integer;
begin
  p := Round(EnsureRange(FCropAnchorY, 0.0, 1.0) * 100);
  FUpdatingCropFromCode := True;
  try
    udCropPercent.Position := p;
  finally
    FUpdatingCropFromCode := False;
  end;
end;

procedure TMainForm.UpdateExportOptionsCropState;
var
  enabled: Boolean;
begin
  enabled := IsCropDragAvailable;
  lblCropPercent.Enabled := enabled;
  edtCropPercent.Enabled := enabled;
  udCropPercent.Enabled := enabled;
  lblCropPercentSuffix.Enabled := enabled;
end;

procedure TMainForm.PreviewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button <> mbLeft) or (not IsCropDragAvailable) then
    Exit;
  FIsDraggingCrop := True;
  FCropDragStartY := Y;
  FCropDragStartAnchorY := FCropAnchorY;
  Screen.Cursor := crSizeNS;
end;

procedure TMainForm.PreviewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  nextAnchor: Double;
begin
  if not FIsDraggingCrop then
    Exit;
  if imgPreview.Height <= 0 then
    Exit;

  nextAnchor := EnsureRange(
    FCropDragStartAnchorY - ((Y - FCropDragStartY) / imgPreview.Height),
    0.0,
    1.0
  );
  if Abs(nextAnchor - FCropAnchorY) < 0.0005 then
    Exit;

  FCropAnchorY := nextAnchor;
  UpdateCropPercentEditFromAnchor;
  RefreshMainPreviewFromSettings;
  UpdateSplitInfo;
  UpdateSplitOverlay;
end;

procedure TMainForm.PreviewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and FIsDraggingCrop then
  begin
    FIsDraggingCrop := False;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.RefreshMainPreviewFromSettings;
var
  segments: Integer;
  workingBitmap: TBitmap;
begin
  if FSourceBitmap.Empty then
    Exit;

  segments := GetSegments;
  if segments < 1 then
  begin
    FPreviewBitmap.Assign(FSourceBitmap);
    imgPreview.Picture.Assign(FPreviewBitmap);
    Exit;
  end;
  if (not chkInstagramPreset.Checked) and (segments > FSourceBitmap.Width) then
  begin
    FPreviewBitmap.Assign(FSourceBitmap);
    imgPreview.Picture.Assign(FPreviewBitmap);
    FLastBaseWidth := 0;
    FLastRemainder := 0;
    FLastWorkingWidth := FSourceBitmap.Width;
    Exit;
  end;

  workingBitmap := TPanoramaRenderer.BuildWorkingBitmapForOutput(
    FSourceBitmap,
    BuildRenderOptions,
    FLastBaseWidth,
    FLastRemainder
  );
  try
    FPreviewBitmap.Assign(workingBitmap);
    imgPreview.Picture.Assign(FPreviewBitmap);
    FLastWorkingWidth := workingBitmap.Width;
  finally
    workingBitmap.Free;
  end;
end;

procedure TMainForm.UpdateImageInfo;
begin
  if FSourceBitmap.Empty then
  begin
    memMetadata.Lines.Text := 'Load an image to see file name, size, ratio, and metadata.';
    Exit;
  end;

  UpdateMetadataInfo;
end;

procedure TMainForm.UpdateSplitInfo;
var
  segments: Integer;
  baseWidth: Integer;
  remainder: Integer;
  presetWidth: Integer;
  presetHeight: Integer;
  requiredScale: Double;
  cropPercent: Integer;
begin
  if FSourceBitmap.Empty then
  begin
    lblSplitInfo.Caption := 'Split info: load an image first';
    lblQualityWarning.Caption := '';
    LayoutSplitInfoLabels;
    Exit;
  end;

  segments := GetSegments;
  if segments < 1 then
  begin
    lblSplitInfo.Caption := 'Split info: choose at least 1 segment';
    lblQualityWarning.Caption := '';
    LayoutSplitInfoLabels;
    Exit;
  end;

  if (not chkInstagramPreset.Checked) and (segments > FSourceBitmap.Width) then
  begin
    lblSplitInfo.Caption := 'Split info: too many segments for this image width';
    lblQualityWarning.Caption := '';
    LayoutSplitInfoLabels;
    Exit;
  end;

  if GetPresetDimensions(presetWidth, presetHeight) then
  begin
    if cboInstagramMode.ItemIndex = 0 then
    begin
      cropPercent := Round(EnsureRange(FCropAnchorY, 0.0, 1.0) * 100);
      lblSplitInfo.Caption := Format(
        'Split info: Instagram Fill (crop) -> %d images, each %d x %d px (canvas %d x %d), vertical crop %d%%',
        [segments, presetWidth, presetHeight, segments * presetWidth, presetHeight, cropPercent]
      );
      requiredScale := Max(
        (segments * presetWidth) / FSourceBitmap.Width,
        presetHeight / FSourceBitmap.Height
      );
    end
    else
    begin
      lblSplitInfo.Caption := Format(
        'Split info: Instagram Fit (no crop) + %s padding -> %d images, each %d x %d px',
        [LowerCase(cboPadStyle.Text), segments, presetWidth, presetHeight]
      );
      requiredScale := Min(
        (segments * presetWidth) / FSourceBitmap.Width,
        presetHeight / FSourceBitmap.Height
      );
    end;

    if requiredScale > 1.0 then
      lblQualityWarning.Caption := Format(
        'Warning: source must be upscaled by %.0f%% for this preset; quality may decrease.',
        [requiredScale * 100]
      )
    else
      lblQualityWarning.Caption := '';
  end
  else
  begin
    baseWidth := FSourceBitmap.Width div segments;
    remainder := FSourceBitmap.Width mod segments;
    if GetNonInstagramRatio(presetWidth, presetHeight) then
      lblSplitInfo.Caption := Format(
        'Split info: native width split + ratio %d:%d -> %d segments; ~%d px wide each; output height %d px',
        [presetWidth, presetHeight, segments, baseWidth, Round((FSourceBitmap.Width / segments) * (presetHeight / presetWidth))]
      )
    else
      lblSplitInfo.Caption := Format(
        'Split info: %d segments; %d px each (+1 px for first %d segment(s)); height %d px',
        [segments, baseWidth, remainder, FSourceBitmap.Height]
      );
    lblQualityWarning.Caption := '';
  end;
  LayoutSplitInfoLabels;
end;

procedure TMainForm.LayoutSplitInfoLabels;
const
  Gap = 8;
begin
  lblSplitInfo.AutoSize := True;
  lblSplitInfo.WordWrap := True;
  lblSplitInfo.Width := Max(200, pnlTop.ClientWidth - lblSplitInfo.Left - 16);
  lblQualityWarning.AutoSize := True;
  lblQualityWarning.WordWrap := True;
  lblQualityWarning.Left := lblSplitInfo.Left;
  lblQualityWarning.Width := lblSplitInfo.Width;
  if Trim(lblQualityWarning.Caption) = '' then
  begin
    lblQualityWarning.Visible := False;
    Exit;
  end;
  lblQualityWarning.Visible := True;
  lblQualityWarning.Top := lblSplitInfo.Top + lblSplitInfo.Height + Gap;
end;

procedure TMainForm.UpdateMetadataInfo;
var
  searchRec: TSearchRec;
  fileSizeText: string;
begin
  memMetadata.Clear;
  memMetadata.Lines.Add('File: ' + ExtractFileName(FSourceFilePath));
  memMetadata.Lines.Add('Format: ' + UpperCase(TPath.GetExtension(FSourceFilePath)));

  if System.SysUtils.FindFirst(FSourceFilePath, faAnyFile, searchRec) = 0 then
  begin
    try
      fileSizeText := FormatFloat('#,##0', searchRec.Size);
      memMetadata.Lines.Add('File size: ' + fileSizeText + ' bytes');
      memMetadata.Lines.Add('Modified: ' + DateTimeToStr(searchRec.TimeStamp));
    finally
      System.SysUtils.FindClose(searchRec);
    end;
  end;

  memMetadata.Lines.Add(Format('Dimensions: %d x %d px', [FSourceBitmap.Width, FSourceBitmap.Height]));
  memMetadata.Lines.Add('Aspect ratio: ' + TPanoramaAlgorithms.BuildAspectRatioText(FSourceBitmap.Width, FSourceBitmap.Height));
  memMetadata.Lines.Add('Pixel format: ' + GetEnumName(TypeInfo(TPixelFormat), Ord(FSourceBitmap.PixelFormat)));
  memMetadata.Lines.Add('Bits per pixel: ' + IntToStr(PixelFormatBitsPerPixel(FSourceBitmap.PixelFormat)));
  memMetadata.Lines.Add('Bitmap PPI: ' + IntToStr(FSourceBitmap.Canvas.Font.PixelsPerInch));
  if not TJpegExifMetadata.AppendExifMetadataFromJpeg(FSourceFilePath, memMetadata.Lines) then
    memMetadata.Lines.Add('EXIF metadata: not found or unsupported format.');
end;

procedure TMainForm.UpdatePreviewZoom;
var
  targetWidth: Integer;
  targetHeight: Integer;
  leftPos: Integer;
  topPos: Integer;
begin
  if FSourceBitmap.Empty then
    Exit;

  if Assigned(imgPreview.Picture.Graphic) and (imgPreview.Picture.Width > 0) and (imgPreview.Picture.Height > 0) then
  begin
    targetWidth := Max(1, Round(imgPreview.Picture.Width * FZoomFactor));
    targetHeight := Max(1, Round(imgPreview.Picture.Height * FZoomFactor));
  end
  else
  begin
    targetWidth := Max(1, Round(FSourceBitmap.Width * FZoomFactor));
    targetHeight := Max(1, Round(FSourceBitmap.Height * FZoomFactor));
  end;
  if FFitToScreen then
  begin
    leftPos := Max(0, (sbxPreview.ClientWidth - targetWidth) div 2);
    topPos := Max(0, (sbxPreview.ClientHeight - targetHeight) div 2);
  end
  else
  begin
    leftPos := 0;
    topPos := 0;
  end;

  imgPreview.SetBounds(leftPos, topPos, targetWidth, targetHeight);
  pbSplitOverlay.SetBounds(imgPreview.Left, imgPreview.Top, imgPreview.Width, imgPreview.Height);
  UpdateSplitOverlay;
  lblZoom.Caption := Format('Zoom: %.0f%%', [FZoomFactor * 100]);
end;

procedure TMainForm.FitPreviewToScreen;
var
  fitScaleX: Double;
  fitScaleY: Double;
  fitScale: Double;
  previewWidth: Integer;
  previewHeight: Integer;
begin
  if FSourceBitmap.Empty then
    Exit;

  if Assigned(imgPreview.Picture.Graphic) and (imgPreview.Picture.Width > 0) and (imgPreview.Picture.Height > 0) then
  begin
    previewWidth := imgPreview.Picture.Width;
    previewHeight := imgPreview.Picture.Height;
  end
  else
  begin
    previewWidth := FSourceBitmap.Width;
    previewHeight := FSourceBitmap.Height;
  end;

  fitScaleX := Max(1, sbxPreview.ClientWidth - 4) / previewWidth;
  fitScaleY := Max(1, sbxPreview.ClientHeight - 4) / previewHeight;
  fitScale := Min(fitScaleX, fitScaleY);
  if fitScale <= 0 then
    fitScale := 1.0;

  FFitToScreen := True;
  sbxPreview.AutoScroll := False;
  SetZoomFactor(fitScale, False);
end;

procedure TMainForm.SetZoomFactor(const AZoomFactor: Double; ADisableFitMode: Boolean);
begin
  FZoomFactor := EnsureRange(AZoomFactor, 0.1, 8.0);
  if ADisableFitMode then
  begin
    FFitToScreen := False;
    sbxPreview.AutoScroll := True;
  end
  else
    sbxPreview.AutoScroll := False;
  UpdatePreviewZoom;
end;

procedure TMainForm.UpdateColourMenuState;
begin
  miExportColour.Checked := cboOutputColour.ItemIndex = 0;
  miExportBW.Checked := cboOutputColour.ItemIndex = 1;
end;

procedure TMainForm.UpdateZoomControlsState;
var
  hasImage: Boolean;
begin
  hasImage := not FSourceBitmap.Empty;
  btnFitToScreen.Enabled := hasImage;
  btnZoomIn.Enabled := hasImage;
  btnZoomOut.Enabled := hasImage;
  miViewFitToScreen.Enabled := hasImage;
  miViewZoomIn.Enabled := hasImage;
  miViewZoomOut.Enabled := hasImage;
  if not hasImage then
  begin
    lblZoom.Caption := 'Zoom: -';
    pbSplitOverlay.Visible := False;
  end
  else
    pbSplitOverlay.Visible := True;
end;

procedure TMainForm.UpdateSplitOverlay;
begin
  if FSourceBitmap.Empty then
  begin
    pbSplitOverlay.Visible := False;
    Exit;
  end;

  pbSplitOverlay.Visible := True;
  if IsCropDragAvailable then
  begin
    pbSplitOverlay.Cursor := crSizeNS;
    imgPreview.Cursor := crSizeNS;
  end
  else
  begin
    pbSplitOverlay.Cursor := crDefault;
    imgPreview.Cursor := crDefault;
  end;
  UpdateExportOptionsCropState;
  pbSplitOverlay.BringToFront;
  pbSplitOverlay.Invalidate;
end;

procedure TMainForm.ApplyLightTheme;
begin
  TStyleManager.TrySetStyle('Windows11 White Smoke');
end;

procedure TMainForm.ApplyDarkTheme;
begin
  TStyleManager.TrySetStyle('Windows11 MineShaft');
end;

procedure TMainForm.UpdateThemeMenuState;
var
  activeName: string;
begin
  miFileThemeLight.Checked := False;
  miFileThemeDark.Checked := False;
  if not Assigned(TStyleManager.ActiveStyle) then
    Exit;

  activeName := TStyleManager.ActiveStyle.Name;
  miFileThemeLight.Checked := SameText(activeName, 'Windows11 White Smoke');
  miFileThemeDark.Checked := SameText(activeName, 'Windows11 MineShaft') or
    SameText(activeName, 'Windows11 Mine Shaft');
end;

function TMainForm.GetSettingsIniPath: string;
begin
  Result := TPath.Combine(
    TPath.Combine(TPath.GetHomePath, 'AppData\Roaming\PanoramaSplitter'),
    'PanoramaSplitter.ini');
end;

function TMainForm.GetConfigJsonPath: string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), 'PanoramaConfig.json');
end;

procedure TMainForm.LoadSettingsFromIni;
var
  ini: TIniFile;
  path: string;
  seg: Integer;
  cropPct: Integer;
  themeMode: string;
begin
  path := GetSettingsIniPath;
  if not System.SysUtils.FileExists(path) then
    Exit;

  ini := TIniFile.Create(path);
  try
    themeMode := ini.ReadString('Theme', 'Mode', 'Light');
    if SameText(themeMode, 'Dark') then
      ApplyDarkTheme
    else
      ApplyLightTheme;

    seg := ini.ReadInteger('Export', 'Segments', trkSegments.Position);
    seg := EnsureRange(seg, trkSegments.Min, trkSegments.Max);
    trkSegments.Position := seg;
    lblSegmentsValue.Caption := IntToStr(seg);

    chkInstagramPreset.Checked := ini.ReadBool('Export', 'UseInstagramPreset', chkInstagramPreset.Checked);
    cboRatioMode.ItemIndex := EnsureRange(
      ini.ReadInteger('Export', 'RatioModeIndex', cboRatioMode.ItemIndex),
      0,
      cboRatioMode.Items.Count - 1);
    cboInstagramPreset.ItemIndex := EnsureRange(
      ini.ReadInteger('Export', 'PresetIndex', cboInstagramPreset.ItemIndex),
      0,
      cboInstagramPreset.Items.Count - 1);
    cboInstagramMode.ItemIndex := EnsureRange(
      ini.ReadInteger('Export', 'InstaMode', cboInstagramMode.ItemIndex),
      0,
      cboInstagramMode.Items.Count - 1);
    cboPadStyle.ItemIndex := EnsureRange(
      ini.ReadInteger('Export', 'PadStyle', cboPadStyle.ItemIndex),
      0,
      cboPadStyle.Items.Count - 1);
    cboBlurLevel.ItemIndex := EnsureRange(
      ini.ReadInteger('Export', 'BlurLevel', cboBlurLevel.ItemIndex),
      0,
      Max(0, cboBlurLevel.Items.Count - 1));
    cboOutputColour.ItemIndex := EnsureRange(
      ini.ReadInteger('Export', 'OutputColour', cboOutputColour.ItemIndex),
      0,
      cboOutputColour.Items.Count - 1);

    cropPct := ini.ReadInteger('Export', 'CropPercent', 50);
    cropPct := EnsureRange(cropPct, 0, 100);
    FCropAnchorY := cropPct / 100.0;
    UpdateCropPercentEditFromAnchor;

    edtOutputFolder.Text := ini.ReadString('Paths', 'OutputFolder', edtOutputFolder.Text);
    SyncOutputFolderFromEdit;

    cboInstagramPreset.Enabled := chkInstagramPreset.Checked;
    cboInstagramMode.Enabled := chkInstagramPreset.Checked;
    cboPadStyle.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1);
    cboBlurLevel.Enabled := chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 1) and (cboPadStyle.ItemIndex = 2);
    lblBlurLevel.Visible := cboBlurLevel.Enabled;
    cboBlurLevel.Visible := cboBlurLevel.Enabled;
    cboRatioMode.Enabled := not chkInstagramPreset.Checked;
    lblRatioMode.Enabled := cboRatioMode.Enabled;

    UpdateColourMenuState;
    UpdateThemeMenuState;
    UpdateExportOptionsCropState;

    if not FSourceBitmap.Empty then
    begin
      RefreshMainPreviewFromSettings;
      UpdateSplitInfo;
      LayoutSplitInfoLabels;
    end;
  finally
    ini.Free;
  end;
end;

procedure TMainForm.SaveSettingsToIni;
var
  ini: TIniFile;
  path: string;
  dir: string;
begin
  path := GetSettingsIniPath;
  dir := ExtractFilePath(path);
  if (dir <> '') and (not System.SysUtils.DirectoryExists(dir)) then
    System.SysUtils.ForceDirectories(dir);

  ini := TIniFile.Create(path);
  try
    if miFileThemeDark.Checked then
      ini.WriteString('Theme', 'Mode', 'Dark')
    else
      ini.WriteString('Theme', 'Mode', 'Light');

    ini.WriteInteger('Export', 'Segments', GetSegments);
    ini.WriteBool('Export', 'UseInstagramPreset', chkInstagramPreset.Checked);
    ini.WriteInteger('Export', 'RatioModeIndex', cboRatioMode.ItemIndex);
    ini.WriteInteger('Export', 'PresetIndex', cboInstagramPreset.ItemIndex);
    ini.WriteInteger('Export', 'InstaMode', cboInstagramMode.ItemIndex);
    ini.WriteInteger('Export', 'PadStyle', cboPadStyle.ItemIndex);
    ini.WriteInteger('Export', 'BlurLevel', cboBlurLevel.ItemIndex);
    ini.WriteInteger('Export', 'OutputColour', cboOutputColour.ItemIndex);
    ini.WriteInteger('Export', 'CropPercent', Round(EnsureRange(FCropAnchorY, 0.0, 1.0) * 100));

    SyncOutputFolderFromEdit;
    ini.WriteString('Paths', 'OutputFolder', FOutputFolder);
  finally
    ini.Free;
  end;
end;

function TMainForm.IsCropDragAvailable: Boolean;
begin
  Result := (not FSourceBitmap.Empty) and
    ((chkInstagramPreset.Checked and (cboInstagramMode.ItemIndex = 0)) or
     (not chkInstagramPreset.Checked));
end;

procedure TMainForm.SplitOverlayPaint(Sender: TObject);
var
  segments: Integer;
  i: Integer;
  xPos: Integer;
  runningWidth: Integer;
  segWidth: Integer;
  totalWidth: Integer;
  xRatio: Double;
begin
  if FSourceBitmap.Empty then
    Exit;

  segments := GetSegments;
  if segments < 2 then
    Exit;

  pbSplitOverlay.Canvas.Pen.Style := psDot;
  pbSplitOverlay.Canvas.Pen.Width := 1;
  pbSplitOverlay.Canvas.Pen.Color := clLime;

  if (FLastBaseWidth <= 0) or (FLastWorkingWidth <= 0) then
  begin
    for i := 1 to segments - 1 do
    begin
      xPos := Round((pbSplitOverlay.Width * i) / segments);
      pbSplitOverlay.Canvas.MoveTo(xPos, 0);
      pbSplitOverlay.Canvas.LineTo(xPos, pbSplitOverlay.Height);
    end;
  end
  else
  begin
    totalWidth := FLastWorkingWidth;
    runningWidth := 0;
    for i := 0 to segments - 1 do
    begin
      segWidth := FLastBaseWidth;
      if i < FLastRemainder then
        Inc(segWidth);
      Inc(runningWidth, segWidth);
      if i < segments - 1 then
      begin
        xRatio := runningWidth / totalWidth;
        xPos := Round(xRatio * pbSplitOverlay.Width);
        pbSplitOverlay.Canvas.MoveTo(xPos, 0);
        pbSplitOverlay.Canvas.LineTo(xPos, pbSplitOverlay.Height);
      end;
    end;
  end;
end;

function TMainForm.GetSegments: Integer;
begin
  Result := EnsureRange(trkSegments.Position, trkSegments.Min, trkSegments.Max);
end;

function TMainForm.GetPresetDimensions(out AWidth, AHeight: Integer): Boolean;
begin
  Result := chkInstagramPreset.Checked;
  if not Result then
  begin
    AWidth := 0;
    AHeight := 0;
    Exit;
  end;

  if (cboInstagramPreset.ItemIndex < 0) or
     (cboInstagramPreset.ItemIndex > High(FAppConfig.InstagramPresets)) then
  begin
    AWidth := 0;
    AHeight := 0;
    Result := False;
    Exit;
  end;
  AWidth := FAppConfig.InstagramPresets[cboInstagramPreset.ItemIndex].Width;
  AHeight := FAppConfig.InstagramPresets[cboInstagramPreset.ItemIndex].Height;
end;

function TMainForm.GetNonInstagramRatio(out AWidth, AHeight: Integer): Boolean;
begin
  Result := not chkInstagramPreset.Checked;
  if not Result then
  begin
    AWidth := 0;
    AHeight := 0;
    Exit;
  end;

  if (cboRatioMode.ItemIndex < 0) or
     (cboRatioMode.ItemIndex > High(FAppConfig.RatioOptions)) then
  begin
    AWidth := 0;
    AHeight := 0;
    Result := False;
    Exit;
  end;

  AWidth := FAppConfig.RatioOptions[cboRatioMode.ItemIndex].RatioWidth;
  AHeight := FAppConfig.RatioOptions[cboRatioMode.ItemIndex].RatioHeight;
  Result := True;
end;

function TMainForm.PixelFormatBitsPerPixel(APixelFormat: TPixelFormat): Integer;
begin
  case APixelFormat of
    pf1bit: Result := 1;
    pf4bit: Result := 4;
    pf8bit: Result := 8;
    pf15bit: Result := 15;
    pf16bit: Result := 16;
    pf24bit: Result := 24;
    pf32bit: Result := 32;
  else
    Result := 0;
  end;
end;

procedure TMainForm.EnsureSourceLoaded;
begin
  if FSourceBitmap.Empty then
    raise Exception.Create('Load an image first.');
end;

procedure TMainForm.EnsureOutputFolder;
begin
  SyncOutputFolderFromEdit;
  System.SysUtils.ForceDirectories(FOutputFolder);
end;

end.
