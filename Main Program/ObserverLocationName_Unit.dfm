object ObserverLocationName_Form: TObserverLocationName_Form
  Left = 269
  Top = 362
  Width = 467
  Height = 171
  Caption = 'Add Observer Location Name'
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 148
    Height = 13
    Caption = 'Enter name for current location:'
  end
  object Name_Edit: TEdit
    Left = 24
    Top = 40
    Width = 361
    Height = 21
    Hint = 'Name entered here will be used to create new entry'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnKeyDown = ShowHelp
  end
  object OK_Button: TButton
    Left = 248
    Top = 88
    Width = 57
    Height = 25
    Hint = 'Add entry to list'
    Caption = 'Add'
    TabOrder = 1
    OnClick = OK_ButtonClick
    OnKeyDown = ShowHelp
  end
  object Cancel_Button: TButton
    Left = 328
    Top = 88
    Width = 65
    Height = 25
    Hint = 'Return without adding a new name'
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = Cancel_ButtonClick
    OnKeyDown = ShowHelp
  end
end
