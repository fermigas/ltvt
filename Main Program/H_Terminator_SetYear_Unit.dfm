object Terminator_SetYear_Form: TTerminator_SetYear_Form
  Left = 192
  Top = 108
  Width = 198
  Height = 131
  ActiveControl = SetTo_Button
  Caption = 'Set Year'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inline DesiredYear_LabeledNumericEdit: TLabeledNumericEdit
    Left = 31
    Top = 15
    Width = 115
    Height = 26
    Hint = 'Enter the year in YYYY format (may not work for <1601)'
    AutoSize = True
    TabOrder = 0
    inherited Item_Label: TLabel
      Top = 5
      Width = 64
      Caption = 'Desired Year:'
    end
    inherited Units_Label: TLabel
      Top = 0
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 72
      Top = 5
      Width = 41
      Text = '1609'
      OnKeyDown = DesiredYear_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
  object SetTo_Button: TButton
    Left = 31
    Top = 59
    Width = 49
    Height = 25
    Hint = 'Reset Time of Observation to specified year'
    Caption = 'Set To'
    TabOrder = 1
    OnClick = SetTo_ButtonClick
    OnKeyDown = SetTo_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 104
    Top = 59
    Width = 51
    Height = 25
    Hint = 'Close form without taking any action'
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
end
