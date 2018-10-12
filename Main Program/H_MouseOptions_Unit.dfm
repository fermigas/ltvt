object MouseOptions_Form: TMouseOptions_Form
  Left = 191
  Top = 89
  Width = 620
  Height = 400
  Caption = 'Mouse Options'
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
  object CursorOptions_GroupBox: TGroupBox
    Left = 16
    Top = 16
    Width = 313
    Height = 65
    Caption = 'Cursor'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object NormalCursor_RadioButton: TRadioButton
      Left = 32
      Top = 24
      Width = 113
      Height = 17
      Hint = 'Use default cursor when mouse is over image area'
      Caption = 'Normal Cursor'
      TabOrder = 0
      OnKeyDown = NormalCursor_RadioButtonKeyDown
    end
    object CrosshairCursor_RadioButton: TRadioButton
      Left = 168
      Top = 24
      Width = 113
      Height = 17
      Hint = 'Use a cross-hair cursor when mouse is over image area'
      Caption = 'Crosshair Cursor'
      TabOrder = 1
      OnKeyDown = CrosshairCursor_RadioButtonKeyDown
    end
  end
  object RefPtOptions_GroupBox: TGroupBox
    Left = 16
    Top = 104
    Width = 585
    Height = 209
    Hint = 
      'As mouse is moved into shadow area beyond reference point, displ' +
      'ay height of the Sun'#39's rays relative to the reference point heig' +
      'ht'
    Caption = 'Reference Point Readout'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object CurrentReferencePoint_Label: TLabel
      Left = 16
      Top = 24
      Width = 355
      Height = 13
      Caption = 
        'Desired readout based mouse point position with respect to refer' +
        'ence point:'
    end
    object DistanceAndBearingFromRefPt_RadioButton: TRadioButton
      Left = 32
      Top = 72
      Width = 409
      Height = 17
      Hint = 
        'The distance (in both kilometers and degrees) and azimuth (CW fr' +
        'om north) from the reference point to the mouse point along a gr' +
        'eat circle'
      Caption = 'Display distance and azimuth from reference point to mouse point'
      TabOrder = 1
      OnKeyDown = DistanceAndBearingFromRefPt_RadioButtonKeyDown
    end
    object NoRefPtReadout_RadioButton: TRadioButton
      Left = 32
      Top = 48
      Width = 393
      Height = 17
      Hint = 'Display nothing'
      Caption = 'Blank  (do not display anything related to the  reference point)'
      TabOrder = 0
      OnKeyDown = NoRefPtReadout_RadioButtonKeyDown
    end
    object ShadowLengthRefPtReadout_RadioButton: TRadioButton
      Left = 32
      Top = 104
      Width = 441
      Height = 17
      Hint = 
        'After setting the reference point, point the mouse along red lin' +
        'e to tip of shadow cast by that feature -- the difference in ele' +
        'vation between the two points will be displayed'
      Caption = 
        'Display elevation difference based on distance from reference po' +
        'int to tip of shadow'
      TabOrder = 2
      OnKeyDown = ShadowLengthRefPtReadout_RadioButtonKeyDown
    end
    object PointOfLightRefPtReadout_RadioButton: TRadioButton
      Left = 32
      Top = 168
      Width = 505
      Height = 17
      Hint = 
        'Set reference point on a peak -- move mouse along red line repre' +
        'senting sunlight grazing over peak -- display will show ray heig' +
        'hts measured radially, relative to ref. pt.'
      Caption = 
        'Display relative elevation of sun rays in shadowed area beyond a' +
        ' feature (set as reference point)'
      TabOrder = 4
      OnKeyDown = PointOfLightRefPtReadout_RadioButtonKeyDown
    end
    object InverseShadowLengthRefPtReadout_RadioButton: TRadioButton
      Left = 32
      Top = 136
      Width = 545
      Height = 17
      Hint = 
        'This is the same as the preceding mode, except that the referenc' +
        'e point is set at the tip of the shadow, rather than at the shad' +
        'ow-casting peak.'
      Caption = 
        'Inverse shadow length mode -- set reference point at tip of shad' +
        'ow and read elevation at shadow casting peak'
      TabOrder = 3
      OnKeyDown = InverseShadowLengthRefPtReadout_RadioButtonKeyDown
    end
  end
  object OK_Button: TButton
    Left = 464
    Top = 336
    Width = 49
    Height = 25
    Hint = 'Close form and make changes'
    Caption = 'OK'
    TabOrder = 4
    OnClick = OK_ButtonClick
    OnKeyDown = OK_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 528
    Top = 336
    Width = 65
    Height = 25
    Hint = 'Close form without making any changes'
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
  object Save_Button: TButton
    Left = 16
    Top = 337
    Width = 89
    Height = 25
    Hint = 'Save these settings as the new defaults'
    Caption = 'Save as Default'
    TabOrder = 2
    OnClick = Save_ButtonClick
    OnKeyDown = Save_ButtonKeyDown
  end
  object Restore_Button: TButton
    Left = 112
    Top = 337
    Width = 89
    Height = 25
    Hint = 'Restore the last saved settings'
    Caption = 'Restore Defaults'
    TabOrder = 3
    OnClick = Restore_ButtonClick
    OnKeyDown = Restore_ButtonKeyDown
  end
end
