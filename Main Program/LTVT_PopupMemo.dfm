object LTVT_PopupMemo_Form: TLTVT_PopupMemo_Form
  Left = 90
  Top = 104
  Width = 695
  Height = 424
  Caption = 'LTVT_PopupMemo_Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Clear_Button: TButton
    Left = 488
    Top = 344
    Width = 49
    Height = 25
    Hint = 'Clear memo area'
    Caption = 'Clear'
    TabOrder = 3
    OnClick = Clear_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Close_Button: TButton
    Left = 600
    Top = 344
    Width = 51
    Height = 25
    Hint = 'Close this window'
    Cancel = True
    Caption = 'Close'
    TabOrder = 4
    OnClick = Close_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Memo: TRichEdit
    Left = 16
    Top = 16
    Width = 633
    Height = 313
    Lines.Strings = (
      'Memo')
    ScrollBars = ssBoth
    TabOrder = 0
    OnKeyDown = FormKeyDown
  end
  object WebLink_BitBtn: TBitBtn
    Left = 72
    Top = 344
    Width = 75
    Height = 25
    Hint = 
      'Open related page from the-Moon Wiki in your web browser (requir' +
      'es internet connection)'
    Caption = 'Web Link'
    TabOrder = 1
    OnClick = WebLink_BitBtnClick
    OnKeyDown = FormKeyDown
  end
  object Copy_Button: TButton
    Left = 392
    Top = 344
    Width = 57
    Height = 25
    Hint = 'Copy contents of memo area to clipboard'
    Caption = 'Copy'
    TabOrder = 2
    OnClick = Copy_ButtonClick
    OnKeyDown = FormKeyDown
  end
end
