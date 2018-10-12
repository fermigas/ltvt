object PopupMemo_Form: TPopupMemo_Form
  Left = 90
  Top = 104
  Width = 675
  Height = 404
  Caption = 'PopupMemo_Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 649
    Height = 329
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'QuickType II Mono'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Clear_Button: TButton
    Left = 488
    Top = 344
    Width = 49
    Height = 25
    Caption = 'Clear'
    TabOrder = 1
    OnClick = Clear_ButtonClick
  end
  object Close_Button: TButton
    Left = 600
    Top = 344
    Width = 51
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = Close_ButtonClick
  end
end
