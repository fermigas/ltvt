object TargetSelection_Form: TTargetSelection_Form
  Left = 349
  Top = 158
  Width = 231
  Height = 135
  Caption = 'Select target planet'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = ProcessKeyStroke
  PixelsPerInch = 96
  TextHeight = 13
  object PlanetSelector_ComboBox: TComboBox
    Left = 24
    Top = 16
    Width = 145
    Height = 21
    Hint = 
      'Select desired object from drop-down list -- LTVT will calculate' +
      ' geometry based on it (rather than the Moon)'
    AutoDropDown = True
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnKeyDown = ProcessKeyStroke
  end
  object OK_Button: TButton
    Left = 24
    Top = 56
    Width = 49
    Height = 25
    Hint = 'Click to change target to specified object'
    Caption = 'OK'
    TabOrder = 1
    OnClick = OK_ButtonClick
    OnKeyDown = ProcessKeyStroke
  end
  object Cancel_Button: TButton
    Left = 120
    Top = 56
    Width = 49
    Height = 25
    Hint = 
      'Click this button (or ESC)  to close dialog without changing obj' +
      'ect'
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Cancel_ButtonClick
    OnKeyDown = ProcessKeyStroke
  end
end
