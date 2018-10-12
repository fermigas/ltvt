object ExportTexture_Form: TExportTexture_Form
  Left = 292
  Top = 111
  Width = 652
  Height = 522
  Caption = 'Export current user photo to Simple Cylindrical Texture file'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Export_Button: TButton
    Left = 40
    Top = 224
    Width = 75
    Height = 25
    Hint = 'Open dialog to export image to texture file on disk'
    Caption = 'Export'
    TabOrder = 1
    OnClick = Export_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Close_Button: TButton
    Left = 512
    Top = 440
    Width = 65
    Height = 25
    Hint = 'Close form'
    Cancel = True
    Caption = 'Close'
    TabOrder = 7
    OnClick = Close_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object ExportGeometry_GroupBox: TGroupBox
    Left = 24
    Top = 24
    Width = 481
    Height = 185
    Caption = 'Export Geometry'
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 16
      Width = 89
      Height = 13
      Caption = 'Longitude range :  '
    end
    object Label2: TLabel
      Left = 32
      Top = 75
      Width = 80
      Height = 13
      Caption = 'Latitude range :  '
    end
    object Label3: TLabel
      Left = 256
      Top = 152
      Width = 70
      Height = 13
      Caption = 'No data color :'
    end
    inline BottomLat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 232
      Top = 104
      Width = 138
      Height = 21
      Hint = 'Enter latitude along bottom margin of Texture 3 map'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 57
        Caption = 'Bottom Lat.:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Hint = 'Enter number in decimal degrees'
        Text = '-90'
        OnKeyDown = FormKeyDown
      end
    end
    inline HorizontalPixels_LabeledNumericEdit: TLabeledNumericEdit
      Left = 32
      Top = 148
      Width = 195
      Height = 21
      AutoSize = True
      TabOrder = 4
      inherited Item_Label: TLabel
        Width = 111
        Caption = 'Total pixels horizontally:'
      end
      inherited Units_Label: TLabel
        Left = 192
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 136
        Hint = 'Enter integer number'
        Text = '1000'
        OnKeyDown = FormKeyDown
        InputType = tInteger
      end
    end
    inline LeftLon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 56
      Top = 40
      Width = 130
      Height = 21
      Hint = 'Enter longitude along left margin of texture map'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 48
        Caption = 'Left. Lon.:'
      end
      inherited Units_Label: TLabel
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Hint = 'Enter number in decimal degrees'
        Text = '-180'
        OnKeyDown = FormKeyDown
      end
    end
    inline RightLon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 232
      Top = 40
      Width = 138
      Height = 21
      Hint = 'Enter longitude along right margin of texture map'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 55
        Caption = 'Right. Lon.:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Hint = 'Enter number in decimal degrees'
        Text = '180'
        OnKeyDown = FormKeyDown
      end
    end
    inline TopLat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 56
      Top = 104
      Width = 130
      Height = 21
      Hint = 'Enter latitude along top margin of Texture 3 map'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 43
        Caption = 'Top Lat.:'
      end
      inherited Units_Label: TLabel
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Hint = 'Enter number in decimal degrees'
        Text = '90'
        OnKeyDown = FormKeyDown
      end
    end
    object NoDataColor_ColorBox: TColorBox
      Left = 336
      Top = 147
      Width = 97
      Height = 22
      Hint = 
        'Select the color to be used for drawing areas in which there is ' +
        'no valid data'
      Selected = clWhite
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 5
      OnKeyDown = FormKeyDown
    end
  end
  object Memo1: TMemo
    Left = 24
    Top = 264
    Width = 585
    Height = 161
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object ProgressBar1: TProgressBar
    Left = 139
    Top = 228
    Width = 390
    Height = 16
    Min = 0
    Max = 100
    TabOrder = 2
    Visible = False
  end
  object Abort_Button: TButton
    Left = 552
    Top = 224
    Width = 49
    Height = 25
    Hint = 'Halt processing'
    Caption = 'Abort'
    TabOrder = 3
    Visible = False
    OnClick = Abort_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Copy_Button: TButton
    Left = 75
    Top = 440
    Width = 57
    Height = 25
    Hint = 'copy contents of memo area to clipboard'
    Caption = 'Copy'
    TabOrder = 5
    OnClick = Copy_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Clear_Button: TButton
    Left = 297
    Top = 440
    Width = 51
    Height = 25
    Hint = 'Erase text in memo area'
    Caption = 'Clear'
    TabOrder = 6
    OnClick = Clear_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    Filter = 
      'Bitmaps (*.bmp)|*.bmp|JPEG Image File (*.jpg)|*.jpg|JPEG Image F' +
      'ile (*.jpeg)|*.jpeg|All (*.bmp;*.jpg;*.jpeg)|*.bmp;*.jpg;*.jpeg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 584
    Top = 136
  end
end
