object TerminatorAbout_Form: TTerminatorAbout_Form
  Left = 192
  Top = 108
  Width = 425
  Height = 235
  ActiveControl = OK_Button
  Caption = 'About LTVT'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 267
    Height = 13
    Caption = 'Program name:  Jim'#39's Lunar Terminator Visualization Tool'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Version_Label: TLabel
    Left = 8
    Top = 32
    Width = 59
    Height = 13
    Caption = 'Version:  3.0'
  end
  object Copyright_Label: TLabel
    Left = 8
    Top = 56
    Width = 228
    Height = 13
    Caption = 'Copyright:  Jim Mosher and Henrik Bondo,  2006'
  end
  object Label4: TLabel
    Left = 8
    Top = 160
    Width = 43
    Height = 13
    Caption = 'Contact: '
  end
  object Email_Label: TLabel
    Left = 56
    Top = 160
    Width = 109
    Height = 13
    Hint = 'Click to send e-mail'
    Caption = 'jimmosher@yahoo.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Email_LabelClick
    OnMouseEnter = Email_LabelMouseEnter
    OnMouseLeave = Email_LabelMouseLeave
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 90
    Height = 13
    Caption = 'About the authors: '
  end
  object JimWebAddress_Label: TLabel
    Left = 40
    Top = 128
    Width = 123
    Height = 13
    Hint = 'Click to open in web browser'
    Caption = 'www.pacifier.com/~tpope'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = JimWebAddress_LabelClick
    OnMouseEnter = Email_LabelMouseEnter
    OnMouseLeave = Email_LabelMouseLeave
  end
  object Label5: TLabel
    Left = 16
    Top = 128
    Width = 18
    Height = 13
    Caption = 'Jim:'
  end
  object Label6: TLabel
    Left = 200
    Top = 128
    Width = 34
    Height = 13
    Caption = 'Henrik:'
  end
  object HenrikWebAddress_Label: TLabel
    Left = 240
    Top = 128
    Width = 106
    Height = 13
    Hint = 'Click to open in web browser'
    Caption = 'www.HenriksUCLA.dk'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = HenrikWebAddress_LabelClick
    OnMouseEnter = Email_LabelMouseEnter
    OnMouseLeave = Email_LabelMouseLeave
  end
  object Label3: TLabel
    Left = 8
    Top = 80
    Width = 96
    Height = 13
    Caption = 'Website/download: '
  end
  object LTVT_WikiWebAddress_Label: TLabel
    Left = 112
    Top = 80
    Width = 92
    Height = 13
    Hint = 'Click to open in web browser'
    Caption = 'ltvt.wikispaces.com'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = LTVT_WikiWebAddress_LabelClick
    OnMouseEnter = Email_LabelMouseEnter
    OnMouseLeave = Email_LabelMouseLeave
  end
  object OK_Button: TButton
    Left = 328
    Top = 160
    Width = 57
    Height = 25
    Hint = 'Close this form'
    Caption = 'Close'
    TabOrder = 1
    OnClick = OK_ButtonClick
    OnKeyDown = OK_ButtonKeyDown
  end
  object More_Button: TButton
    Left = 200
    Top = 160
    Width = 65
    Height = 25
    Hint = 'Click for more information'
    Caption = 'More Info'
    TabOrder = 0
    OnClick = More_ButtonClick
    OnKeyDown = More_ButtonKeyDown
  end
end
