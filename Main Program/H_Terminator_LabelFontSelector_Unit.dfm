object LabelFontSelector_Form: TLabelFontSelector_Form
  Left = 223
  Top = 99
  Width = 528
  Height = 545
  Caption = 'Dot/Label Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Labels_GroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 489
    Height = 137
    Caption = ' Feature Label Options '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Label3: TLabel
      Left = 96
      Top = 38
      Width = 42
      Height = 13
      Hint = 
        'The labels for the satellite features of a named feature will lo' +
        'ok as shown at right'
      Caption = 'Lettered:'
    end
    object Label2: TLabel
      Left = 8
      Top = 58
      Width = 72
      Height = 13
      Caption = 'Offset from dot:'
    end
    object Label1: TLabel
      Left = 96
      Top = 18
      Width = 26
      Height = 13
      Hint = 
        'The labels for the primary named features will look as shown at ' +
        'right'
      Caption = 'Main:'
    end
    object Label12: TLabel
      Left = 232
      Top = 64
      Width = 74
      Height = 13
      Caption = 'Include in label:'
    end
    object FontSample_Label: TLabel
      Left = 152
      Top = 18
      Width = 55
      Height = 13
      Hint = 
        'This is a sample label -- when you have what you want, click "OK' +
        '"'
      Caption = 'Ptolemaeus'
    end
    object SatelliteFontSample_Label: TLabel
      Left = 152
      Top = 38
      Width = 65
      Height = 13
      Hint = 
        'This is a sample label -- when you have what you want, click "OK' +
        '"'
      Caption = 'Ptolemaeus B'
    end
    object RadialDotOffset_CheckBox: TCheckBox
      Left = 96
      Top = 58
      Width = 89
      Height = 17
      Hint = 
        'Place satellite letters on side towards parent feature by amount' +
        ' in horizontal offset box'
      Caption = 'Radial offset'
      TabOrder = 1
      OnKeyDown = RadialDotOffset_CheckBoxKeyDown
    end
    object IncludeSize_CheckBox: TCheckBox
      Left = 392
      Top = 82
      Width = 81
      Height = 17
      Hint = 'Include the feature size (a numeric value) in the label'
      Caption = 'Feature size'
      TabOrder = 5
      OnClick = IncludeSize_CheckBoxClick
      OnKeyDown = IncludeSize_CheckBoxKeyDown
    end
    object FullCraterNames_CheckBox: TCheckBox
      Left = 264
      Top = 106
      Width = 105
      Height = 17
      Hint = 
        'Applies to IAU list "Satellite Features" only:  include name of ' +
        'parent crater for lettered craters;  if not checked, only the le' +
        'tter is shown'
      Caption = 'Parent name'
      TabOrder = 6
      OnClick = FullCraterNames_CheckBoxClick
      OnKeyDown = FullCraterNames_CheckBoxKeyDown
    end
    inline XOffset_LabeledNumericEdit: TLabeledNumericEdit
      Left = 16
      Top = 82
      Width = 130
      Height = 19
      Hint = 
        'Start of label text will be this number of pixels (+ = right;  -' +
        ' = left) from the dot'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Horizontal:'
      end
      inherited Units_Label: TLabel
        Left = 104
        Width = 26
        Caption = 'pixels'
      end
      inherited NumericEdit: TNumericEdit
        Width = 41
        Height = 19
        Text = '7'
        OnKeyDown = XOffset_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
    inline YOffset_LabeledNumericEdit: TLabeledNumericEdit
      Left = 16
      Top = 106
      Width = 130
      Height = 19
      Hint = 
        'Center of label text will be this number of pixelsfrom the dot (' +
        '+ = above;  - = below)'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 38
        Caption = 'Vertical:'
      end
      inherited Units_Label: TLabel
        Left = 104
        Width = 26
        Caption = 'pixels'
      end
      inherited NumericEdit: TNumericEdit
        Width = 41
        Height = 19
        OnKeyDown = YOffset_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
    object ChangeFont_Button: TButton
      Left = 8
      Top = 18
      Width = 73
      Height = 25
      Hint = 'Change the font, size, style or color'
      Caption = 'Change Font'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = ChangeFont_ButtonClick
      OnKeyDown = ChangeFont_ButtonKeyDown
    end
    object IncludeUnits_CheckBox: TCheckBox
      Left = 392
      Top = 104
      Width = 57
      Height = 17
      Hint = 
        'Include the units of the feature dimension (e.g., km for crater ' +
        'diameters)'
      Caption = 'Units'
      TabOrder = 7
      OnClick = IncludeUnits_CheckBoxClick
      OnKeyDown = IncludeUnits_CheckBoxKeyDown
    end
    object IncludeName_CheckBox: TCheckBox
      Left = 264
      Top = 80
      Width = 97
      Height = 17
      Hint = 'Include the feature name in the label'
      Caption = 'Feature name'
      TabOrder = 4
      OnClick = IncludeName_CheckBoxClick
      OnKeyDown = IncludeName_CheckBoxKeyDown
    end
  end
  object OK_Button: TButton
    Left = 368
    Top = 488
    Width = 57
    Height = 25
    Hint = 'Use these settings'
    Caption = 'OK'
    TabOrder = 5
    OnClick = OK_ButtonClick
    OnKeyDown = OK_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 440
    Top = 488
    Width = 49
    Height = 25
    Hint = 'Close this form, ignoring changes'
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
  object Save_Button: TButton
    Left = 8
    Top = 488
    Width = 89
    Height = 25
    Hint = 'Save these settings as the new defaults'
    Caption = 'Save as Default'
    TabOrder = 3
    OnClick = Save_ButtonClick
    OnKeyDown = Save_ButtonKeyDown
  end
  object Restore_Button: TButton
    Left = 104
    Top = 488
    Width = 89
    Height = 25
    Hint = 'Restore the last saved settings'
    Caption = 'Restore Defaults'
    TabOrder = 4
    OnClick = Restore_ButtonClick
    OnKeyDown = Restore_ButtonKeyDown
  end
  object Dot_GroupBox: TGroupBox
    Left = 8
    Top = 152
    Width = 489
    Height = 217
    Caption = ' Dot options '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 124
      Width = 79
      Height = 13
      Caption = 'Non-crater color:'
    end
    object Label5: TLabel
      Left = 8
      Top = 52
      Width = 216
      Height = 13
      Caption = 'Crater colors in categories by size (kilometers):'
    end
    object Label6: TLabel
      Left = 120
      Top = 82
      Width = 6
      Height = 13
      Caption = '<'
    end
    object Label7: TLabel
      Left = 176
      Top = 82
      Width = 12
      Height = 13
      Caption = '<='
    end
    object Label8: TLabel
      Left = 360
      Top = 82
      Width = 12
      Height = 13
      Caption = '<='
    end
    object Label9: TLabel
      Left = 304
      Top = 82
      Width = 6
      Height = 13
      Caption = '<'
    end
    object Label13: TLabel
      Left = 8
      Top = 172
      Width = 93
      Height = 13
      Caption = 'Feature circle color:'
    end
    object Label14: TLabel
      Left = 232
      Top = 164
      Width = 105
      Height = 13
      Caption = 'Reference mark color:'
    end
    inline DotSize_LabeledNumericEdit: TLabeledNumericEdit
      Left = 256
      Top = 126
      Width = 210
      Height = 19
      Hint = 
        'Dots are drawn as boxes with this height and width; also control' +
        's length of reference (plus) mark arms'
      AutoSize = True
      TabOrder = 7
      inherited Item_Label: TLabel
        Width = 127
        Caption = 'Dot diameter/ref mark size:'
      end
      inherited Units_Label: TLabel
        Left = 184
        Width = 26
        Caption = 'pixels'
      end
      inherited NumericEdit: TNumericEdit
        Left = 144
        Width = 33
        Height = 19
        Text = '2'
        OnKeyDown = DotSize_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
    object LargeCrater_ColorBox: TColorBox
      Left = 380
      Top = 80
      Width = 97
      Height = 22
      Hint = 'Select the color to be used for dots representing large craters'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 5
      OnKeyDown = LargeCrater_ColorBoxKeyDown
    end
    object LargeCraterDiam_NumericEdit: TNumericEdit
      Left = 316
      Top = 82
      Width = 41
      Height = 19
      Hint = 
        'Diameter [km] separating medium from large craters -- enter an i' +
        'nteger value'
      TabOrder = 4
      Text = '100'
      OnKeyDown = LargeCraterDiam_NumericEditKeyDown
      InputType = tExtended
    end
    object MediumCrater_ColorBox: TColorBox
      Left = 200
      Top = 80
      Width = 97
      Height = 22
      Hint = 
        'Select the color to be used for dots representing medium size cr' +
        'aters'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 3
      OnKeyDown = MediumCrater_ColorBoxKeyDown
    end
    object MediumCraterDiam_NumericEdit: TNumericEdit
      Left = 132
      Top = 82
      Width = 41
      Height = 19
      Hint = 
        'Diameter [km] separating small from medium craters -- enter an i' +
        'nteger value'
      TabOrder = 2
      Text = '50'
      OnKeyDown = MediumCraterDiam_NumericEditKeyDown
      InputType = tExtended
    end
    object NonCrater_ColorBox: TColorBox
      Left = 112
      Top = 123
      Width = 97
      Height = 22
      Hint = 
        'Select the color to be used for dots representing non-crater fea' +
        'tures'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 6
      OnKeyDown = NonCrater_ColorBoxKeyDown
    end
    object SmallCrater_ColorBox: TColorBox
      Left = 16
      Top = 80
      Width = 97
      Height = 22
      Hint = 'Select the color to be used for dots representing small craters'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 1
      OnKeyDown = SmallCrater_ColorBoxKeyDown
    end
    object IncludeDiscontinuedNames_CheckBox: TCheckBox
      Left = 8
      Top = 24
      Width = 169
      Height = 17
      Hint = 
        'Applies to IAU list only:  unless checked, names in [square brac' +
        'kets] are not plotted'
      Caption = 'Include discontinued  features'
      TabOrder = 0
      OnKeyDown = IncludeDiscontinuedNames_CheckBoxKeyDown
    end
    object DotCircle_ColorBox: TColorBox
      Left = 112
      Top = 171
      Width = 97
      Height = 22
      Hint = 
        'Select the color to be used for drawing the optional circles rep' +
        'resenting the feature diameters'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 8
      OnKeyDown = DotCircle_ColorBoxKeyDown
    end
    object RefPt_ColorBox: TColorBox
      Left = 352
      Top = 163
      Width = 97
      Height = 22
      Hint = 
        'Select the color of the '#39'+'#39' mark used for the reference point an' +
        'd for marking positions'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 9
      OnKeyDown = RefPt_ColorBoxKeyDown
    end
    object SnapShadowPoint_CheckBox: TCheckBox
      Left = 248
      Top = 192
      Width = 193
      Height = 17
      Hint = 'Show shadow measurement click points in plan view'
      Caption = 'Snap shadow points to plan view'
      TabOrder = 10
      OnKeyDown = SnapShadowPoint_CheckBoxKeyDown
    end
  end
  object SavedImage_GroupBox: TGroupBox
    Left = 8
    Top = 384
    Width = 457
    Height = 81
    Caption = ' Saved Image Label Options '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Label10: TLabel
      Left = 184
      Top = 24
      Width = 88
      Height = 13
      Caption = 'Upper labels color:'
    end
    object Label11: TLabel
      Left = 328
      Top = 24
      Width = 88
      Height = 13
      Caption = 'Lower labels color:'
    end
    object SavedImageUpperLabels_ColorBox: TColorBox
      Left = 200
      Top = 43
      Width = 97
      Height = 22
      Hint = 
        'Select a color for the labels placed at the top of the saved LTV' +
        'T image'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 1
      OnKeyDown = SavedImageUpperLabels_ColorBoxKeyDown
    end
    object SavedImageLowerLabels_ColorBox: TColorBox
      Left = 344
      Top = 43
      Width = 97
      Height = 22
      Hint = 
        'Select a color for the labels placed at the top of the saved LTV' +
        'T image'
      Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
      ItemHeight = 16
      TabOrder = 2
      OnKeyDown = SavedImageLowerLabels_ColorBoxKeyDown
    end
    object AnnotateSavedImages_CheckBox: TCheckBox
      Left = 16
      Top = 24
      Width = 161
      Height = 17
      Hint = 
        'When this box is checked, text lines giving information necessar' +
        'y to reproduce the view will be appended above and below the sav' +
        'ed image'
      Caption = 'Annotate saved images'
      TabOrder = 0
      OnKeyDown = AnnotateSavedImages_CheckBoxKeyDown
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 352
    Top = 8
  end
end
