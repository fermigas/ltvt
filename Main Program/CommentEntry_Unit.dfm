object CommentEntry_Form: TCommentEntry_Form
  Left = 192
  Top = 107
  Width = 696
  Height = 150
  Caption = 'Comment Entry Form'
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
  object Label1: TLabel
    Left = 24
    Top = 8
    Width = 76
    Height = 13
    Caption = 'Enter note here:'
  end
  object Edit1: TEdit
    Left = 24
    Top = 32
    Width = 633
    Height = 21
    Hint = 
      'Enter single line note here; click OK to use, or Cancel to disca' +
      'rd and exit form'
    TabOrder = 0
    Text = 'Edit1'
    OnKeyDown = FormKeyDown
  end
  object Accept_Button: TButton
    Left = 472
    Top = 72
    Width = 57
    Height = 25
    Hint = 'Close form accepting comment as entered'
    Caption = 'OK'
    TabOrder = 2
    OnClick = Accept_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Cancel_Button: TButton
    Left = 568
    Top = 72
    Width = 57
    Height = 25
    Hint = 'Close form without using comment'
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Cancel_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Clear_Button: TButton
    Left = 40
    Top = 72
    Width = 57
    Height = 25
    Hint = 'Erase contents of data entry line'
    Caption = 'Clear'
    TabOrder = 1
    OnClick = Clear_ButtonClick
    OnKeyDown = FormKeyDown
  end
end
