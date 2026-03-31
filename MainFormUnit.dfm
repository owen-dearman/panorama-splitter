object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Panorama Splitter for Instagram'
  ClientHeight = 899
  ClientWidth = 1221
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mmMain
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1221
    Height = 284
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 1100
    DesignSize = (
      1221
      284)
    object lblSplitInfo: TLabel
      Left = 350
      Top = 52
      Width = 57
      Height = 13
      Caption = 'Split info: -'
      WordWrap = True
    end
    object lblQualityWarning: TLabel
      Left = 350
      Top = 73
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object btnLoadImage: TButton
      Left = 16
      Top = 16
      Width = 120
      Height = 30
      Caption = 'Load Panorama'
      TabOrder = 0
      OnClick = ButtonLoadImageClick
    end
    object btnSplitAndSave: TButton
      Left = 144
      Top = 16
      Width = 140
      Height = 30
      Caption = 'Split && Save'
      TabOrder = 1
      OnClick = ButtonSplitAndSaveClick
    end
    object btnPreviewOutput: TButton
      Left = 292
      Top = 16
      Width = 120
      Height = 30
      Caption = 'Preview Output'
      TabOrder = 2
      OnClick = ButtonPreviewOutputClick
    end
    object memMetadata: TMemo
      Left = 16
      Top = 100
      Width = 1205
      Height = 176
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 3
    end
  end
  object pnlPreviewTools: TPanel
    Left = 0
    Top = 284
    Width = 1221
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 1100
    object lblZoom: TLabel
      Left = 290
      Top = 10
      Width = 39
      Height = 13
      Caption = 'Zoom: -'
    end
    object btnFitToScreen: TButton
      Left = 16
      Top = 4
      Width = 100
      Height = 26
      Caption = 'Fit to screen'
      TabOrder = 0
      OnClick = ButtonFitToScreenClick
    end
    object btnZoomIn: TButton
      Left = 122
      Top = 4
      Width = 75
      Height = 26
      Caption = 'Zoom +'
      TabOrder = 1
      OnClick = ButtonZoomInClick
    end
    object btnZoomOut: TButton
      Left = 203
      Top = 4
      Width = 75
      Height = 26
      Caption = 'Zoom -'
      TabOrder = 2
      OnClick = ButtonZoomOutClick
    end
  end
  object grpExportOptions: TGroupBox
    Left = 0
    Top = 319
    Width = 1221
    Height = 128
    Align = alTop
    Caption = 'Export settings'
    Padding.Left = 10
    Padding.Top = 4
    Padding.Right = 10
    Padding.Bottom = 8
    TabOrder = 2
    ExplicitWidth = 1100
    object lblSegments: TLabel
      Left = 10
      Top = 22
      Width = 53
      Height = 13
      Caption = 'Segments:'
    end
    object lblPreset: TLabel
      Left = 430
      Top = 22
      Width = 34
      Height = 13
      Caption = 'Preset:'
    end
    object lblInstagramMode: TLabel
      Left = 10
      Top = 52
      Width = 60
      Height = 13
      Caption = 'Insta mode:'
    end
    object lblPadStyle: TLabel
      Left = 248
      Top = 52
      Width = 48
      Height = 13
      Caption = 'Pad style:'
    end
    object lblOutputColour: TLabel
      Left = 432
      Top = 52
      Width = 77
      Height = 13
      Caption = 'Output colour:'
    end
    object lblCropPercent: TLabel
      Left = 10
      Top = 82
      Width = 66
      Height = 13
      Caption = 'Vertical crop:'
    end
    object lblCropPercentSuffix: TLabel
      Left = 180
      Top = 82
      Width = 135
      Height = 13
      Caption = '%  (0 = top, 100 = bottom)'
    end
    object lblSegmentsValue: TLabel
      Left = 260
      Top = 22
      Width = 6
      Height = 13
      Caption = '3'
    end
    object lblRatioMode: TLabel
      Left = 650
      Top = 52
      Width = 30
      Height = 13
      Caption = 'Ratio:'
    end
    object lblBlurLevel: TLabel
      Left = 340
      Top = 82
      Width = 50
      Height = 13
      Caption = 'Blur level:'
    end
    object trkSegments: TTrackBar
      Left = 72
      Top = 14
      Width = 180
      Height = 33
      Min = 1
      Position = 3
      TabOrder = 0
      OnChange = EditSegmentsChange
    end
    object chkInstagramPreset: TCheckBox
      Left = 285
      Top = 20
      Width = 140
      Height = 17
      Caption = 'Use Instagram preset'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBoxInstagramPresetClick
    end
    object cboInstagramPreset: TComboBox
      Left = 470
      Top = 19
      Width = 320
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnChange = ComboBoxInstagramPresetChange
    end
    object cboInstagramMode: TComboBox
      Left = 92
      Top = 49
      Width = 140
      Height = 21
      Style = csDropDownList
      TabOrder = 3
      OnChange = InstagramOptionsChange
    end
    object cboPadStyle: TComboBox
      Left = 304
      Top = 49
      Width = 110
      Height = 21
      Style = csDropDownList
      TabOrder = 4
      OnChange = InstagramOptionsChange
    end
    object cboOutputColour: TComboBox
      Left = 512
      Top = 49
      Width = 120
      Height = 21
      Style = csDropDownList
      TabOrder = 5
      OnChange = OutputColourChange
    end
    object cboRatioMode: TComboBox
      Left = 690
      Top = 49
      Width = 170
      Height = 21
      Style = csDropDownList
      TabOrder = 9
      OnChange = RatioOptionsChange
    end
    object cboBlurLevel: TComboBox
      Left = 396
      Top = 79
      Width = 150
      Height = 21
      Style = csDropDownList
      TabOrder = 10
      OnChange = InstagramOptionsChange
    end
    object edtCropPercent: TEdit
      Left = 116
      Top = 79
      Width = 40
      Height = 21
      TabOrder = 6
      Text = '50'
      OnChange = CropPercentEditChange
    end
    object udCropPercent: TUpDown
      Left = 156
      Top = 79
      Width = 16
      Height = 21
      Associate = edtCropPercent
      Position = 50
      TabOrder = 7
    end
  end
  object sbxPreview: TScrollBox
    Left = 0
    Top = 447
    Width = 1221
    Height = 416
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    TabOrder = 3
    OnResize = ScrollBoxPreviewResize
    ExplicitWidth = 1100
    ExplicitHeight = 377
    object imgPreview: TImage
      Left = 0
      Top = 0
      Width = 1600
      Height = 900
      Cursor = crSizeNS
      Proportional = True
      Stretch = True
      OnMouseDown = PreviewMouseDown
      OnMouseMove = PreviewMouseMove
      OnMouseUp = PreviewMouseUp
    end
    object pbSplitOverlay: TPaintBox
      Left = 0
      Top = 0
      Width = 1600
      Height = 900
      Cursor = crSizeNS
      OnMouseDown = PreviewMouseDown
      OnMouseMove = PreviewMouseMove
      OnMouseUp = PreviewMouseUp
      OnPaint = SplitOverlayPaint
    end
  end
  object pnlOutput: TPanel
    Left = 0
    Top = 863
    Width = 1221
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 12
    Padding.Top = 4
    Padding.Right = 12
    Padding.Bottom = 4
    TabOrder = 4
    ExplicitTop = 824
    ExplicitWidth = 1100
    object lblOutputFolder: TLabel
      Left = 12
      Top = 4
      Width = 75
      Height = 28
      Align = alLeft
      Caption = 'Output folder:'
      Layout = tlCenter
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitHeight = 13
    end
    object btnBrowseOutput: TButton
      Left = 1121
      Top = 4
      Width = 88
      Height = 28
      Align = alRight
      Caption = 'Browse...'
      TabOrder = 1
      OnClick = ButtonBrowseOutputClick
      ExplicitLeft = 1000
    end
    object edtOutputFolder: TEdit
      Left = 87
      Top = 4
      Width = 1034
      Height = 28
      Align = alClient
      TabOrder = 0
      OnExit = OutputFolderEditExit
      ExplicitWidth = 913
      ExplicitHeight = 21
    end
  end
  object dlgOpenImage: TOpenDialog
    Left = 760
    Top = 20
  end
  object mmMain: TMainMenu
    Left = 840
    Top = 20
    object miFile: TMenuItem
      Caption = '&File'
      object miFileLoadImage: TMenuItem
        Caption = '&Load Panorama...'
        OnClick = MenuFileLoadImageClick
      end
      object miFileSelectOutput: TMenuItem
        Caption = 'Select &Output Folder...'
        OnClick = MenuFileSelectOutputClick
      end
      object miFileSplitSave: TMenuItem
        Caption = '&Split && Save'
        OnClick = MenuFileSplitSaveClick
      end
      object miFileThemes: TMenuItem
        Caption = '&Theme'
        object miFileThemeLight: TMenuItem
          Caption = '&Light'
          OnClick = MenuFileThemeLightClick
        end
        object miFileThemeDark: TMenuItem
          Caption = '&Dark'
          OnClick = MenuFileThemeDarkClick
        end
      end
      object miFileSeparator1: TMenuItem
        Caption = '-'
      end
      object miFileExit: TMenuItem
        Caption = 'E&xit'
        OnClick = MenuFileExitClick
      end
    end
    object miView: TMenuItem
      Caption = '&View'
      object miViewFitToScreen: TMenuItem
        Caption = '&Fit to Screen'
        OnClick = MenuViewFitToScreenClick
      end
      object miViewZoomIn: TMenuItem
        Caption = 'Zoom &In'
        OnClick = MenuViewZoomInClick
      end
      object miViewZoomOut: TMenuItem
        Caption = 'Zoom &Out'
        OnClick = MenuViewZoomOutClick
      end
    end
    object miExport: TMenuItem
      Caption = '&Export'
      object miExportColour: TMenuItem
        Caption = '&Colour'
        OnClick = MenuExportColourClick
      end
      object miExportBW: TMenuItem
        Caption = '&Black and White'
        OnClick = MenuExportBWClick
      end
    end
  end
end
