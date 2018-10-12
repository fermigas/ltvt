object CartographicOptions_Form: TCartographicOptions_Form
  Left = 206
  Top = 113
  Width = 482
  Height = 364
  Caption = 'Cartographic Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 117
    Height = 13
    Caption = 'Grid/libration circle color:'
  end
  object Label2: TLabel
    Left = 160
    Top = 152
    Width = 47
    Height = 13
    Caption = 'Sky color:'
  end
  object Label3: TLabel
    Left = 288
    Top = 152
    Width = 145
    Height = 13
    Caption = 'Calibrated photo no data color:'
  end
  object Label4: TLabel
    Left = 24
    Top = 232
    Width = 77
    Height = 13
    Caption = 'Sunlit side color:'
  end
  object Label5: TLabel
    Left = 144
    Top = 232
    Width = 102
    Height = 13
    Caption = 'Shadowed side color:'
  end
  object Label6: TLabel
    Left = 40
    Top = 216
    Width = 177
    Height = 13
    Caption = '------------------   Dots mode --------------------'
  end
  object Label7: TLabel
    Left = 304
    Top = 224
    Width = 111
    Height = 13
    Caption = 'Shadow Measurements'
  end
  object InvertLR_CheckBox: TCheckBox
    Left = 16
    Top = 80
    Width = 105
    Height = 17
    Hint = 'Invert image left-right'
    Caption = 'Invert Left-Right'
    TabOrder = 2
    OnKeyDown = InvertLR_CheckBoxKeyDown
  end
  object InvertUD_CheckBox: TCheckBox
    Left = 152
    Top = 80
    Width = 113
    Height = 17
    Hint = 'Invert image up-down'
    Caption = 'Invert Up-Down'
    TabOrder = 3
    OnKeyDown = InvertUD_CheckBoxKeyDown
  end
  object OK_Button: TButton
    Left = 304
    Top = 296
    Width = 49
    Height = 25
    Hint = 'Close form and make changes'
    Caption = 'OK'
    TabOrder = 15
    OnClick = OK_ButtonClick
    OnKeyDown = OK_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 368
    Top = 296
    Width = 65
    Height = 25
    Hint = 'Close form without making any changes'
    Caption = 'Cancel'
    TabOrder = 16
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
  object Cartographic_CheckBox: TCheckBox
    Left = 16
    Top = 49
    Width = 329
    Height = 17
    Hint = 
      'Make central meridian of full moon image (rather than line of cu' +
      'sps) vertical with north-south up-and-down'
    Caption = 'Draw maps in lunar atlas orientation (central meridian vertical)'
    TabOrder = 1
    OnKeyDown = Cartographic_CheckBoxKeyDown
  end
  object ShowDetails_CheckBox: TCheckBox
    Left = 280
    Top = 80
    Width = 161
    Height = 17
    Hint = 'Show details of calculation of geometry from specified date/time'
    Caption = 'Show Computation Details'
    TabOrder = 4
    Visible = False
    OnKeyDown = ShowDetails_CheckBoxKeyDown
  end
  object LibrationCircle_CheckBox: TCheckBox
    Left = 16
    Top = 120
    Width = 129
    Height = 17
    Hint = 
      'Include a circle at 90 degrees from the Moon'#39's center -- this is' +
      ' the boundary of the region "normally" visible from Earth'
    Caption = 'Show libration circle'
    TabOrder = 5
    OnKeyDown = LibrationCircle_CheckBoxKeyDown
  end
  object LibrationCircle_ColorBox: TColorBox
    Left = 32
    Top = 176
    Width = 97
    Height = 22
    Hint = 
      'Select the color to be used for the libration circle and/or lati' +
      'tude-longitude grid'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 7
    OnKeyDown = LibrationCircle_ColorBoxKeyDown
  end
  object Sky_ColorBox: TColorBox
    Left = 176
    Top = 176
    Width = 97
    Height = 22
    Hint = 'Select the color to be used for drawing areas off the lunar disk'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 8
    OnKeyDown = Sky_ColorBoxKeyDown
  end
  object Save_Button: TButton
    Left = 8
    Top = 297
    Width = 89
    Height = 25
    Hint = 'Save these settings as the new defaults'
    Caption = 'Save as Default'
    TabOrder = 13
    OnClick = Save_ButtonClick
    OnKeyDown = Save_ButtonKeyDown
  end
  object Restore_Button: TButton
    Left = 104
    Top = 297
    Width = 89
    Height = 25
    Hint = 'Restore the last saved settings'
    Caption = 'Restore Defaults'
    TabOrder = 14
    OnClick = Restore_ButtonClick
    OnKeyDown = Restore_ButtonKeyDown
  end
  object TerminatorLines_CheckBox: TCheckBox
    Left = 176
    Top = 120
    Width = 193
    Height = 17
    Hint = 
      'The red line is the boundary of the sunlit hemisphere and the bl' +
      'ue line the boundary of the shaded hemisphere (both calculated f' +
      'or a perfectly spherical Moon)'
    Caption = 'Draw red and blue terminator lines'
    TabOrder = 6
    OnKeyDown = TerminatorLines_CheckBoxKeyDown
  end
  object NoDataColor_ColorBox: TColorBox
    Left = 312
    Top = 176
    Width = 97
    Height = 22
    Hint = 
      'Select the color to be used for drawing areas  in which there is' +
      ' no intensity data when a user supplied photo is being used for ' +
      'the texture map'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 9
    OnKeyDown = NoDataColor_ColorBoxKeyDown
  end
  object UseCurrentUT_CheckBox: TCheckBox
    Left = 16
    Top = 16
    Width = 305
    Height = 17
    Hint = 
      'When program starts, automatically click the "Current UT" button' +
      ' drawing a map of the Moon as it appears at the current moment (' +
      'NOTE: the computation of the lunar geometry requires a JPL ephem' +
      'eris file to be present -- see the Help file)'
    Caption = 'Open LTVT with geometry for current UT'
    TabOrder = 0
    OnKeyDown = UseCurrentUT_CheckBoxKeyDown
  end
  object DotModeSunlitColor_ColorBox: TColorBox
    Left = 16
    Top = 256
    Width = 97
    Height = 22
    Hint = 
      'Select the color to be used as the background for the sunlit sid' +
      'e of the Moon for images drawn in the Dots mode'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 10
    OnKeyDown = DotModeSunlitColor_ColorBoxKeyDown
  end
  object DotModeShadowedColor_ColorBox: TColorBox
    Left = 152
    Top = 256
    Width = 97
    Height = 22
    Hint = 
      'Select the color to be used as the background for the shadowed s' +
      'ide of the Moon for images drawn in the Dots mode'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 11
    OnKeyDown = DotModeShadowedColor_ColorBoxKeyDown
  end
  inline ShadowLineLength_LabeledNumericEdit: TLabeledNumericEdit
    Left = 288
    Top = 248
    Width = 146
    Height = 21
    Hint = 
      'Length of line used for drawing line in shadow direction when ma' +
      'king height measurements'
    AutoSize = True
    TabOrder = 12
    inherited Item_Label: TLabel
      Caption = 'Line length'
    end
    inherited Units_Label: TLabel
      Left = 120
      Width = 26
      Caption = 'pixels'
    end
    inherited NumericEdit: TNumericEdit
      Left = 64
      Hint = 'Enter desired number of pixels as an integer value'
      Text = '100'
      OnKeyDown = ShadowLineLength_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
end
