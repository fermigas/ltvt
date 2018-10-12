object SetObserverLocation_Form: TSetObserverLocation_Form
  Left = 163
  Top = 156
  Width = 532
  Height = 219
  Caption = 'Observer Location on Earth'
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
  OnKeyDown = ShowHelp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Geocentric_RadioButton: TRadioButton
    Left = 8
    Top = 16
    Width = 113
    Height = 17
    Hint = 
      'Compute geometry for an imaginary observer at the center of the ' +
      'earth'
    Caption = 'Geocentric'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = Geocentric_RadioButtonClick
    OnKeyDown = ShowHelp
  end
  object ObserverLocation_Panel: TPanel
    Left = 16
    Top = 48
    Width = 481
    Height = 73
    BevelOuter = bvNone
    TabOrder = 2
    inline ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 0
      Top = 44
      Width = 130
      Height = 21
      Hint = 'Enter observer'#39's longitude in decimal degrees (E=+  W=-)'
      AutoSize = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 27
        Caption = 'Long:'
      end
      inherited Units_Label: TLabel
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 32
        Width = 73
        Text = '0.000'
        OnChange = ObserverLongitude_LabeledNumericEditNumericEditChange
        OnKeyDown = ShowHelp
      end
    end
    inline ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 151
      Top = 44
      Width = 122
      Height = 21
      Hint = 'Enter observer'#39's latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 18
        Caption = 'Lat:'
      end
      inherited Units_Label: TLabel
        Left = 104
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 73
        Text = '0.000'
        OnChange = ObserverLatitude_LabeledNumericEditNumericEditChange
        OnKeyDown = ShowHelp
      end
    end
    inline ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit
      Left = 297
      Top = 44
      Width = 96
      Height = 21
      Hint = 
        'Enter observer'#39's elevation (above sea level) in meters in NN.nnn' +
        ' format'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 14
        Caption = 'Ht:'
      end
      inherited Units_Label: TLabel
        Left = 88
        Width = 8
        Caption = 'm'
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 57
        Text = '0.0'
        OnChange = ObserverElevation_LabeledNumericEditNumericEditChange
        OnKeyDown = ShowHelp
      end
    end
    object ObservatoryList_ComboBox: TComboBox
      Left = 104
      Top = 8
      Width = 377
      Height = 21
      Hint = 
        'Click on any item in this list to copy its location from the Obs' +
        'ervatory List disk file'
      AutoDropDown = True
      ItemHeight = 13
      TabOrder = 0
      OnKeyDown = ShowHelp
      OnSelect = ObservatoryList_ComboBoxSelect
    end
    object AddLocation_Button: TButton
      Left = 424
      Top = 43
      Width = 49
      Height = 25
      Hint = 'Add current location to end of list on disk'
      Caption = 'Add'
      TabOrder = 4
      OnClick = AddLocation_ButtonClick
      OnKeyDown = ShowHelp
    end
  end
  object UserSpecified_RadioButton: TRadioButton
    Left = 8
    Top = 56
    Width = 105
    Height = 17
    Hint = 'Manually specify the observer'#39's position on earth'
    Caption = 'Use this location:'
    Checked = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TabStop = True
    OnClick = UserSpecified_RadioButtonClick
    OnKeyDown = ShowHelp
  end
  object OK_Button: TButton
    Left = 280
    Top = 144
    Width = 57
    Height = 25
    Hint = 'Use the specified data'
    Caption = 'OK'
    TabOrder = 5
    OnClick = OK_ButtonClick
    OnKeyDown = ShowHelp
  end
  object Cancel_Button: TButton
    Left = 360
    Top = 144
    Width = 59
    Height = 25
    Hint = 'Close form, ignoring changes'
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = Cancel_ButtonClick
    OnKeyDown = ShowHelp
  end
  object Save_Button: TButton
    Left = 16
    Top = 144
    Width = 89
    Height = 25
    Hint = 'Save current settings as the default observer mode/location'
    Caption = 'Save as Default'
    TabOrder = 3
    OnClick = Save_ButtonClick
    OnKeyDown = ShowHelp
  end
  object Restore_Button: TButton
    Left = 112
    Top = 144
    Width = 89
    Height = 25
    Hint = 'Restore default mode/location'
    Caption = 'Restore Defaults'
    TabOrder = 4
    OnClick = Restore_ButtonClick
    OnKeyDown = ShowHelp
  end
end
