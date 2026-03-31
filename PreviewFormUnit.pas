unit PreviewFormUnit;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math,
  System.Generics.Collections,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Graphics;

type
  TOutputPreviewForm = class(TForm)
    pnlHeader: TPanel;
    lblHeader: TLabel;
    btnClose: TButton;
    lblLayout: TLabel;
    cboLayout: TComboBox;
    sbxImages: TScrollBox;
    procedure CloseClick(Sender: TObject);
    procedure LayoutChange(Sender: TObject);
    procedure FormResized(Sender: TObject);
  private
    FSlices: TObjectList<TBitmap>;
    procedure RenderSlices;
    procedure ClearPreviewControls;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadSlices(const slices: TObjectList<TBitmap>);
    class procedure ShowSlices(AOwner: TComponent; const slices: TObjectList<TBitmap>);
  end;

implementation

constructor TOutputPreviewForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  FSlices := TObjectList<TBitmap>.Create(True);
  Caption := 'Output Preview';
  Position := poScreenCenter;
  Width := 900;
  Height := 700;
  BorderStyle := bsSizeable;

  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := Self;
  pnlHeader.Align := alTop;
  pnlHeader.Height := 44;

  lblHeader := TLabel.Create(Self);
  lblHeader.Parent := pnlHeader;
  lblHeader.Left := 12;
  lblHeader.Top := 14;
  lblHeader.Caption := 'Preview slices';

  btnClose := TButton.Create(Self);
  btnClose.Parent := pnlHeader;
  btnClose.Caption := 'Close';
  btnClose.Width := 90;
  btnClose.Height := 26;
  btnClose.Left := pnlHeader.Width - btnClose.Width - 12;
  btnClose.Top := 9;
  btnClose.Anchors := [akTop, akRight];
  btnClose.OnClick := CloseClick;

  lblLayout := TLabel.Create(Self);
  lblLayout.Parent := pnlHeader;
  lblLayout.Left := 360;
  lblLayout.Top := 14;
  lblLayout.Caption := 'Layout:';

  cboLayout := TComboBox.Create(Self);
  cboLayout.Parent := pnlHeader;
  cboLayout.Left := 410;
  cboLayout.Top := 10;
  cboLayout.Width := 190;
  cboLayout.Style := csDropDownList;
  cboLayout.Items.Add('Vertical list');
  cboLayout.Items.Add('Horizontal carousel strip');
  cboLayout.OnChange := nil;
  cboLayout.ItemIndex := 0;

  sbxImages := TScrollBox.Create(Self);
  sbxImages.Parent := Self;
  sbxImages.Align := alClient;
  sbxImages.VertScrollBar.Tracking := True;
  sbxImages.HorzScrollBar.Tracking := True;

  cboLayout.OnChange := LayoutChange;

  OnResize := FormResized;
end;

destructor TOutputPreviewForm.Destroy;
begin
  OnResize := nil;
  if Assigned(cboLayout) then
    cboLayout.OnChange := nil;
  FreeAndNil(FSlices);
  inherited;
end;

procedure TOutputPreviewForm.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TOutputPreviewForm.LayoutChange(Sender: TObject);
begin
  RenderSlices;
end;

procedure TOutputPreviewForm.FormResized(Sender: TObject);
begin
  RenderSlices;
end;

procedure TOutputPreviewForm.ClearPreviewControls;
var
  i: Integer;
begin
  if not Assigned(sbxImages) then
    Exit;
  for i := sbxImages.ControlCount - 1 downto 0 do
    sbxImages.Controls[i].Free;
end;

procedure TOutputPreviewForm.RenderSlices;
var
  i: Integer;
  topPos: Integer;
  leftPos: Integer;
  img: TImage;
  lbl: TLabel;
  previewWidth: Integer;
  previewHeight: Integer;
  scale: Double;
  maxItemHeight: Integer;
begin
  if (csDestroying in ComponentState) or (not Assigned(FSlices)) or (not Assigned(sbxImages)) or
    (not Assigned(cboLayout)) then
    Exit;
  ClearPreviewControls;
  if FSlices.Count = 0 then
    Exit;

  if cboLayout.ItemIndex = 0 then
  begin
    topPos := 12;
    for i := 0 to FSlices.Count - 1 do
    begin
      lbl := TLabel.Create(Self);
      lbl.Parent := sbxImages;
      lbl.Left := 12;
      lbl.Top := topPos;
      lbl.Caption := Format('Slice %d - %d x %d px', [i + 1, FSlices[i].Width, FSlices[i].Height]);
      Inc(topPos, 20);

      previewWidth := Min(800, sbxImages.ClientWidth - 36);
      if previewWidth <= 0 then
        previewWidth := 320;
      scale := previewWidth / FSlices[i].Width;
      previewHeight := Max(1, Round(FSlices[i].Height * scale));

      img := TImage.Create(Self);
      img.Parent := sbxImages;
      img.Left := 12;
      img.Top := topPos;
      img.Width := previewWidth;
      img.Height := previewHeight;
      img.Stretch := True;
      img.Proportional := True;
      img.Center := False;
      img.Picture.Assign(FSlices[i]);

      Inc(topPos, previewHeight + 18);
    end;
  end
  else
  begin
    leftPos := 12;
    maxItemHeight := Max(200, sbxImages.ClientHeight - 45);
    for i := 0 to FSlices.Count - 1 do
    begin
      lbl := TLabel.Create(Self);
      lbl.Parent := sbxImages;
      lbl.Left := leftPos;
      lbl.Top := 12;
      lbl.Caption := Format('Slice %d', [i + 1]);

      scale := maxItemHeight / FSlices[i].Height;
      previewHeight := maxItemHeight;
      previewWidth := Max(1, Round(FSlices[i].Width * scale));

      img := TImage.Create(Self);
      img.Parent := sbxImages;
      img.Left := leftPos;
      img.Top := 32;
      img.Width := previewWidth;
      img.Height := previewHeight;
      img.Stretch := True;
      img.Proportional := True;
      img.Center := False;
      img.Picture.Assign(FSlices[i]);

      Inc(leftPos, previewWidth + 18);
    end;
  end;
end;

procedure TOutputPreviewForm.LoadSlices(const slices: TObjectList<TBitmap>);
var
  i: Integer;
  clonedSlice: TBitmap;
begin
  FSlices.Clear;
  for i := 0 to slices.Count - 1 do
  begin
    clonedSlice := TBitmap.Create;
    clonedSlice.Assign(slices[i]);
    FSlices.Add(clonedSlice);
  end;
  RenderSlices;
end;

class procedure TOutputPreviewForm.ShowSlices(AOwner: TComponent; const slices: TObjectList<TBitmap>);
var
  form: TOutputPreviewForm;
begin
  form := TOutputPreviewForm.Create(AOwner);
  try
    form.LoadSlices(slices);
    form.lblHeader.Caption := Format('Preview slices (%d total)', [slices.Count]);
    form.ShowModal;
  finally
    form.Free;
  end;
end;

end.
