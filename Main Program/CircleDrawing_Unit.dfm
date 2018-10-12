object CircleDrawing_Form: TCircleDrawing_Form
  Left = 486
  Top = 116
  Width = 386
  Height = 207
  Caption = 'Circle Drawing Tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 272
    Top = 83
    Width = 84
    Height = 13
    Caption = '(press F1 for help)'
  end
  inline Diam_LabeledNumericEdit: TLabeledNumericEdit
    Left = 16
    Top = 40
    Width = 142
    Height = 21
    Hint = 'Length of arc on lunar surface'
    AutoSize = True
    TabOrder = 2
    inherited Item_Label: TLabel
      Width = 45
      Caption = 'Diameter:'
    end
    inherited Units_Label: TLabel
      Left = 128
      Width = 14
      Caption = 'km'
    end
    inherited NumericEdit: TNumericEdit
      Width = 65
      Hint = 
        'You can use the Up/Down arrows on the keyboard to Increment/Decr' +
        'ement this value'
      Text = '100'
      OnKeyDown = Diam_LabeledNumericEditNumericEditKeyDown
    end
  end
  inline LonDeg_LabeledNumericEdit: TLabeledNumericEdit
    Left = 14
    Top = 8
    Width = 123
    Height = 19
    Hint = 
      'Selenographic longitude in decimal degrees (E=+  W=-) for center' +
      ' of circle'
    AutoSize = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    inherited Item_Label: TLabel
      Width = 50
      Caption = 'Longitude:'
    end
    inherited Units_Label: TLabel
      Left = 120
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Width = 65
      Hint = 
        'You can use the Up/Down arrows on the keyboard to Increment/Decr' +
        'ement this value'
      Text = '0.000'
      OnKeyDown = LonDeg_LabeledNumericEditNumericEditKeyDown
    end
  end
  inline LatDeg_LabeledNumericEdit: TLabeledNumericEdit
    Left = 158
    Top = 8
    Width = 123
    Height = 19
    Hint = 
      'Selenographic latitude in decimal degrees (N=+  S=-) for center ' +
      'of circle'
    AutoSize = True
    TabOrder = 1
    inherited Item_Label: TLabel
      Width = 41
      Caption = 'Latitude:'
    end
    inherited Units_Label: TLabel
      Left = 120
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Width = 65
      Hint = 
        'You can use the Up/Down arrows on the keyboard to Increment/Decr' +
        'ement this value'
      Text = '0.000'
      OnKeyDown = LatDeg_LabeledNumericEditNumericEditKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  object Circle_ColorBox: TColorBox
    Left = 184
    Top = 40
    Width = 97
    Height = 22
    Hint = 'Select the color to be used for drawing circle'
    Selected = clAqua
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 3
    OnKeyDown = Circle_ColorBoxKeyDown
  end
  object DrawCircle_Button: TButton
    Left = 16
    Top = 128
    Width = 57
    Height = 25
    Hint = 'Draw circle on present map'
    Caption = 'Draw'
    TabOrder = 6
    OnClick = DrawCircle_ButtonClick
    OnKeyDown = DrawCircle_ButtonKeyDown
  end
  object ClearCircle_Button: TButton
    Left = 88
    Top = 128
    Width = 57
    Height = 25
    Hint = 
      'Erase circle(s) by reverting to state of map when dialog was inv' +
      'oked'
    Caption = 'Clear'
    TabOrder = 7
    OnClick = ClearCircle_ButtonClick
    OnKeyDown = ClearCircle_ButtonKeyDown
  end
  object Close_Button: TButton
    Left = 304
    Top = 128
    Width = 51
    Height = 25
    Hint = 'Close tool leaving image in current state'
    Caption = 'Close'
    TabOrder = 9
    OnClick = Close_ButtonClick
    OnKeyDown = Close_ButtonKeyDown
  end
  object ShowCenter_CheckBox: TCheckBox
    Left = 16
    Top = 80
    Width = 89
    Height = 17
    Hint = 
      'Check this box if you want to plot a plus-mark at the center of ' +
      'the circle'
    Caption = 'Show center'
    TabOrder = 4
  end
  object Record_Button: TButton
    Left = 184
    Top = 128
    Width = 81
    Height = 25
    Hint = 'Write current point to "CircleList.txt"'
    Caption = 'Record circle'
    TabOrder = 8
    OnClick = Record_ButtonClick
    OnKeyDown = Record_ButtonKeyDown
  end
  object InitiateShadowFile_Button: TButton
    Left = 136
    Top = 80
    Width = 121
    Height = 25
    Hint = 'Use this point and diameter to create a shadow profile file'
    Caption = 'Create shadow pts file'
    TabOrder = 5
    OnClick = InitiateShadowFile_ButtonClick
    OnKeyDown = InitiateShadowFile_ButtonKeyDown
  end
end
