object H_Terminator_Goto_Form: TH_Terminator_Goto_Form
  Left = 132
  Top = 145
  Width = 448
  Height = 266
  ActiveControl = GoTo_Button
  Caption = 'Mark and/or Re-Center Plot on a Specific Location'
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
  object RuklZone_GroupBox: TGroupBox
    Left = 8
    Top = 32
    Width = 345
    Height = 137
    Hint = 'Select location by longitude and latitude'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    object Label4: TLabel
      Left = 72
      Top = 64
      Width = 52
      Height = 13
      Caption = 'Quadrants:'
    end
    object NW_RadioButton: TRadioButton
      Left = 144
      Top = 64
      Width = 81
      Height = 17
      Hint = 'Position at center of NW quadrant'
      Caption = 'NorthWest'
      TabOrder = 3
      OnKeyDown = NW_RadioButtonKeyDown
    end
    object NE_RadioButton: TRadioButton
      Left = 240
      Top = 64
      Width = 81
      Height = 17
      Hint = 'Position at center of NE quadrant'
      Caption = 'NorthEast'
      TabOrder = 4
      OnKeyDown = NE_RadioButtonKeyDown
    end
    object SW_RadioButton: TRadioButton
      Left = 144
      Top = 96
      Width = 81
      Height = 17
      Hint = 'Position at center of SW quadrant'
      Caption = 'SouthWest'
      TabOrder = 5
      OnKeyDown = SW_RadioButtonKeyDown
    end
    object SE_RadioButton: TRadioButton
      Left = 240
      Top = 96
      Width = 81
      Height = 17
      Hint = 'Position at center of SE quadrant'
      Caption = 'SouthEast'
      TabOrder = 6
      OnKeyDown = SE_RadioButtonKeyDown
    end
    inline RuklZone_LabeledNumericEdit: TLabeledNumericEdit
      Left = 15
      Top = 17
      Width = 99
      Height = 24
      Hint = 'Select R'#252'kl zone (1..76)'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Top = 5
        Width = 53
        Hint = 'Enter desired longitude here'
        Caption = 'R'#252'kl  Zone'
      end
      inherited Units_Label: TLabel
        Left = 96
        Top = 0
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Top = 5
        Width = 33
        Height = 19
        Text = '1'
        InputMin = '1'
        InputMax = '76'
        InputType = tInteger
      end
    end
    object Center_RadioButton: TRadioButton
      Left = 144
      Top = 24
      Width = 65
      Height = 17
      Hint = 'Position at center of zone'
      Caption = 'Center'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnKeyDown = Center_RadioButtonKeyDown
    end
    object Next_Button: TButton
      Left = 72
      Top = 88
      Width = 49
      Height = 25
      Hint = 'Moves selection to next sequential zone'
      Caption = 'Next'
      TabOrder = 7
      OnClick = Next_ButtonClick
      OnKeyDown = Next_ButtonKeyDown
    end
    object AutoLabel_CheckBox: TCheckBox
      Left = 240
      Top = 24
      Width = 81
      Height = 17
      Hint = 'Automatically draw Rukl grid and label features'
      Caption = 'Auto Label'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnKeyDown = AutoLabel_CheckBoxKeyDown
    end
  end
  object XY_GroupBox: TGroupBox
    Left = 8
    Top = 32
    Width = 321
    Height = 81
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
    inline CenterX_LabeledNumericEdit: TLabeledNumericEdit
      Left = 22
      Top = 30
      Width = 75
      Height = 19
      Hint = 
        'Enter desired left-right screen position on scale where size of ' +
        'full Moon is +1.0 to -1.0'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 10
        Caption = 'X:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 16
        Width = 57
        Height = 19
        Hint = 
          'You can use the Up/Down arrows on the keyboard to Increment/Decr' +
          'ement this value'
        Text = '0.000'
        OnKeyDown = CenterX_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline CenterY_LabeledNumericEdit: TLabeledNumericEdit
      Left = 118
      Top = 30
      Width = 75
      Height = 19
      Hint = 
        'Enter desired up-down screen position on scale where size of ful' +
        'l Moon is +1.0 to -1.0'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 10
        Caption = 'Y:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 16
        Width = 57
        Height = 19
        Hint = 
          'You can use the Up/Down arrows on the keyboard to Increment/Decr' +
          'ement this value'
        Text = '0.000'
        OnKeyDown = CenterY_LabeledNumericEditNumericEditKeyDown
      end
    end
    object XY_Redraw_Button: TButton
      Left = 232
      Top = 30
      Width = 57
      Height = 25
      Hint = 
        'Redraw main window image at new X-Y center without closing this ' +
        'form'
      Caption = 'Redraw'
      TabOrder = 2
      OnClick = XY_Redraw_ButtonClick
      OnKeyDown = XY_Redraw_ButtonKeyDown
    end
  end
  object LonLat_GroupBox: TGroupBox
    Left = 8
    Top = 32
    Width = 409
    Height = 145
    Hint = 'Select location by longitude and latitude'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 80
      Width = 82
      Height = 13
      Hint = 'Enter desired longitude and latitude by hand'
      Caption = 'Or enter by hand:'
    end
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 71
      Height = 13
      Hint = 'Select from names in current dot file'
      Caption = 'Select from list:'
    end
    object LTOZone_Label: TLabel
      Left = 304
      Top = 112
      Width = 25
      Height = 13
      Hint = 
        'The initial digits Indicate the LAC zone in which this object fa' +
        'lls, the letter and final digit are the LTO sub-zone;  gray = th' +
        'ere is no LTO map for this subzone'
      Caption = 'Zone'
    end
    object Label3: TLabel
      Left = 250
      Top = 112
      Width = 52
      Height = 13
      Hint = 'LAC map zone corresponding to indicated longitude and latitude'
      Caption = 'LAC/LTO: '
    end
    object RuklZone_Label: TLabel
      Left = 344
      Top = 112
      Width = 47
      Height = 13
      Hint = 
        'Indicates map number containing current longitude and latitude i' +
        'n  R'#252'kl'#39's Atlas of the visible hemisphere'
      Caption = 'RuklZone'
    end
    inline SetToLat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 135
      Top = 96
      Width = 97
      Height = 32
      Hint = 'Selenographic Latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Top = 13
        Width = 41
        Hint = 'Enter desired latitude here'
        Caption = 'Latitude:'
      end
      inherited Units_Label: TLabel
        Left = 88
        Top = 0
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 48
        Top = 13
        Width = 49
        Height = 19
        Text = '0.000'
        OnChange = SetToLat_LabeledNumericEditNumericEditChange
        OnKeyDown = SetToLat_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline SetToLon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 15
      Top = 105
      Width = 105
      Height = 24
      Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Top = 5
        Width = 50
        Hint = 'Enter desired longitude here'
        Caption = 'Longitude:'
      end
      inherited Units_Label: TLabel
        Left = 96
        Top = 0
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Top = 5
        Width = 49
        Height = 19
        Text = '0.000'
        OnChange = SetToLon_LabeledNumericEditNumericEditChange
        OnKeyDown = SetToLon_LabeledNumericEditNumericEditKeyDown
      end
    end
    object FeatureNames_ComboBox: TComboBox
      Left = 24
      Top = 40
      Width = 217
      Height = 21
      Hint = 
        'Type first few letters, then click on desired item in drop-down ' +
        'list'
      AutoDropDown = True
      DropDownCount = 10
      ItemHeight = 13
      TabOrder = 0
      OnKeyDown = FeatureNames_ComboBoxKeyDown
      OnSelect = FeatureNames_ComboBoxSelect
    end
    object MinimizeGotoList_CheckBox: TCheckBox
      Left = 272
      Top = 40
      Width = 129
      Height = 17
      Hint = 
        'If checked, the drop-down box lists only those entries in the cu' +
        'rrent dot file that are flagged by a character in the first colu' +
        'mn'
      Caption = 'Flagged entries only'
      TabOrder = 3
      OnClick = MinimizeGotoList_CheckBoxClick
      OnKeyDown = MinimizeGotoList_CheckBoxKeyDown
    end
  end
  object GoTo_Button: TButton
    Left = 103
    Top = 195
    Width = 66
    Height = 25
    Hint = 
      'Shift current map X-Y center to specified feature and re-draw;  ' +
      'requested point indicated by a cross'
    Caption = 'Center On'
    TabOrder = 7
    OnClick = GoTo_ButtonClick
    OnKeyDown = GoTo_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 352
    Top = 195
    Width = 51
    Height = 25
    Hint = 'Close form without taking any action'
    Caption = 'Cancel'
    TabOrder = 9
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
  object AerialView_Button: TButton
    Left = 192
    Top = 195
    Width = 75
    Height = 25
    Hint = 
      'Reset sub-observer point to specified location  and re-draw (not' +
      'e: this is NOT an Earth-based view)'
    Caption = 'Aerial View'
    TabOrder = 8
    OnClick = AerialView_ButtonClick
    OnKeyDown = AerialView_ButtonKeyDown
  end
  object MarkFeature_Button: TButton
    Left = 8
    Top = 195
    Width = 57
    Height = 25
    Hint = 
      'Use a cross to mark specified location on current map -- also se' +
      't Reference Point to this location'
    Caption = 'Mark'
    TabOrder = 6
    OnClick = MarkFeature_ButtonClick
    OnKeyDown = MarkFeature_ButtonKeyDown
  end
  object LonLat_RadioButton: TRadioButton
    Left = 16
    Top = 8
    Width = 201
    Height = 17
    Hint = 
      'Look up location in list of named features; or manually enter lo' +
      'ngitude and latitude'
    Caption = 'By feature name or longitude/latitude'
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = LonLat_RadioButtonClick
    OnKeyDown = LonLat_RadioButtonKeyDown
  end
  object XY_RadioButton: TRadioButton
    Left = 224
    Top = 8
    Width = 97
    Height = 17
    Hint = 
      'Specify location in X-Y cartesian system with Moon'#39's center at (' +
      '0,0) and radius = 1'
    Caption = 'By X-Y position'
    TabOrder = 1
    OnClick = XY_RadioButtonClick
    OnKeyDown = XY_RadioButtonKeyDown
  end
  object RuklZone_RadioButton: TRadioButton
    Left = 328
    Top = 8
    Width = 89
    Height = 17
    Caption = 'By R'#252'kl zone'
    TabOrder = 2
    OnClick = RuklZone_RadioButtonClick
    OnKeyDown = RuklZone_RadioButtonKeyDown
  end
end
