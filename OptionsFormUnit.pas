unit OptionsFormUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TExportOptions = record
    segments: Integer;
    useInstagramPreset: Boolean;
    presetIndex: Integer;
    instaModeIndex: Integer;
    padStyleIndex: Integer;
    outputColourIndex: Integer;
  end;

  TOptionsForm = class(TForm)
  private
    lblSegments: TLabel;
    edtSegments: TEdit;
    udSegments: TUpDown;
    chkInstagramPreset: TCheckBox;
    lblPreset: TLabel;
    cboPreset: TComboBox;
    lblInstaMode: TLabel;
    cboInstaMode: TComboBox;
    lblPadStyle: TLabel;
    cboPadStyle: TComboBox;
    lblOutputColour: TLabel;
    cboOutputColour: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure SyncEnabledState;
    procedure InstagramPresetClick(Sender: TObject);
    procedure InstaModeChange(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    class function ExecuteOptions(AOwner: TComponent; var options: TExportOptions): Boolean;
  end;

implementation

constructor TOptionsForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  Caption := 'Export Options';
  Position := poScreenCenter;
  Width := 540;
  Height := 380;
  BorderStyle := bsDialog;
  BorderIcons := [biSystemMenu];
  Constraints.MinWidth := 540;
  Constraints.MinHeight := 380;

  lblSegments := TLabel.Create(Self);
  lblSegments.Parent := Self;
  lblSegments.Left := 16;
  lblSegments.Top := 20;
  lblSegments.Caption := 'Segments:';

  edtSegments := TEdit.Create(Self);
  edtSegments.Parent := Self;
  edtSegments.Left := 160;
  edtSegments.Top := 16;
  edtSegments.Width := 70;

  udSegments := TUpDown.Create(Self);
  udSegments.Parent := Self;
  udSegments.Left := edtSegments.Left + edtSegments.Width;
  udSegments.Top := edtSegments.Top;
  udSegments.Height := edtSegments.Height;
  udSegments.Associate := edtSegments;
  udSegments.Min := 2;
  udSegments.Max := 100;

  chkInstagramPreset := TCheckBox.Create(Self);
  chkInstagramPreset.Parent := Self;
  chkInstagramPreset.Left := 16;
  chkInstagramPreset.Top := 54;
  chkInstagramPreset.Width := 220;
  chkInstagramPreset.Caption := 'Use Instagram preset';
  chkInstagramPreset.OnClick := InstagramPresetClick;

  lblPreset := TLabel.Create(Self);
  lblPreset.Parent := Self;
  lblPreset.Left := 16;
  lblPreset.Top := 86;
  lblPreset.Caption := 'Preset:';

  cboPreset := TComboBox.Create(Self);
  cboPreset.Parent := Self;
  cboPreset.Left := 160;
  cboPreset.Top := 82;
  cboPreset.Width := 350;
  cboPreset.Style := csDropDownList;
  cboPreset.Items.Add('Portrait 4:5 (1080 x 1350)');
  cboPreset.Items.Add('Square 1:1 (1080 x 1080)');
  cboPreset.Items.Add('Landscape 1.91:1 (1080 x 566)');

  lblInstaMode := TLabel.Create(Self);
  lblInstaMode.Parent := Self;
  lblInstaMode.Left := 16;
  lblInstaMode.Top := 118;
  lblInstaMode.Caption := 'Instagram mode:';

  cboInstaMode := TComboBox.Create(Self);
  cboInstaMode.Parent := Self;
  cboInstaMode.Left := 160;
  cboInstaMode.Top := 114;
  cboInstaMode.Width := 350;
  cboInstaMode.Style := csDropDownList;
  cboInstaMode.Items.Add('Fill (crop)');
  cboInstaMode.Items.Add('Fit (no crop, pad)');
  cboInstaMode.OnChange := InstaModeChange;

  lblPadStyle := TLabel.Create(Self);
  lblPadStyle.Parent := Self;
  lblPadStyle.Left := 16;
  lblPadStyle.Top := 150;
  lblPadStyle.Caption := 'Pad style:';

  cboPadStyle := TComboBox.Create(Self);
  cboPadStyle.Parent := Self;
  cboPadStyle.Left := 160;
  cboPadStyle.Top := 146;
  cboPadStyle.Width := 350;
  cboPadStyle.Style := csDropDownList;
  cboPadStyle.Items.Add('Black');
  cboPadStyle.Items.Add('White');
  cboPadStyle.Items.Add('Blurred');

  lblOutputColour := TLabel.Create(Self);
  lblOutputColour.Parent := Self;
  lblOutputColour.Left := 16;
  lblOutputColour.Top := 182;
  lblOutputColour.Caption := 'Output colour:';

  cboOutputColour := TComboBox.Create(Self);
  cboOutputColour.Parent := Self;
  cboOutputColour.Left := 160;
  cboOutputColour.Top := 178;
  cboOutputColour.Width := 350;
  cboOutputColour.Style := csDropDownList;
  cboOutputColour.Items.Add('Colour');
  cboOutputColour.Items.Add('Black and White');

  btnOk := TButton.Create(Self);
  btnOk.Parent := Self;
  btnOk.Left := 334;
  btnOk.Top := 286;
  btnOk.Width := 90;
  btnOk.Caption := 'OK';
  btnOk.ModalResult := mrOk;
  btnOk.Default := True;

  btnCancel := TButton.Create(Self);
  btnCancel.Parent := Self;
  btnCancel.Left := 432;
  btnCancel.Top := 286;
  btnCancel.Width := 90;
  btnCancel.Caption := 'Cancel';
  btnCancel.ModalResult := mrCancel;
  btnCancel.Cancel := True;
end;

procedure TOptionsForm.SyncEnabledState;
begin
  cboPreset.Enabled := chkInstagramPreset.Checked;
  cboInstaMode.Enabled := chkInstagramPreset.Checked;
  cboPadStyle.Enabled := chkInstagramPreset.Checked and (cboInstaMode.ItemIndex = 1);
end;

procedure TOptionsForm.InstagramPresetClick(Sender: TObject);
begin
  SyncEnabledState;
end;

procedure TOptionsForm.InstaModeChange(Sender: TObject);
begin
  SyncEnabledState;
end;

class function TOptionsForm.ExecuteOptions(AOwner: TComponent; var options: TExportOptions): Boolean;
var
  form: TOptionsForm;
begin
  form := TOptionsForm.Create(AOwner);
  try
    form.udSegments.Position := options.segments;
    form.edtSegments.Text := IntToStr(options.segments);
    form.chkInstagramPreset.Checked := options.useInstagramPreset;
    form.cboPreset.ItemIndex := options.presetIndex;
    form.cboInstaMode.ItemIndex := options.instaModeIndex;
    form.cboPadStyle.ItemIndex := options.padStyleIndex;
    form.cboOutputColour.ItemIndex := options.outputColourIndex;
    form.SyncEnabledState;

    Result := form.ShowModal = mrOk;
    if Result then
    begin
      options.segments := StrToIntDef(Trim(form.edtSegments.Text), form.udSegments.Position);
      options.useInstagramPreset := form.chkInstagramPreset.Checked;
      options.presetIndex := form.cboPreset.ItemIndex;
      options.instaModeIndex := form.cboInstaMode.ItemIndex;
      options.padStyleIndex := form.cboPadStyle.ItemIndex;
      options.outputColourIndex := form.cboOutputColour.ItemIndex;
    end;
  finally
    form.Free;
  end;
end;

end.
