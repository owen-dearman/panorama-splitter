program PanoramaSplitter;

uses
  Vcl.Forms,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  PanoramaAlgorithmsUnit in 'PanoramaAlgorithmsUnit.pas',
  PanoramaDataUnit in 'PanoramaDataUnit.pas',
  PanoramaConfigUnit in 'PanoramaConfigUnit.pas',
  PanoramaRenderUnit in 'PanoramaRenderUnit.pas',
  JpegExifMetadataUnit in 'JpegExifMetadataUnit.pas',
  PreviewFormUnit in 'PreviewFormUnit.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows11 White Smoke');
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
