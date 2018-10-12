object MouseOptions_Form: TMouseOptions_Form
  Left = 191
  Top = 89
  Width = 643
  Height = 487
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
    Height = 57
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
      Checked = True
      TabOrder = 0
      TabStop = True
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
    Top = 168
    Width = 585
    Height = 217
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
      Top = 96
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
      Caption = 'Display elevation at mouse point as read from current DEM'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnKeyDown = NoRefPtReadout_RadioButtonKeyDown
    end
    object ShadowLengthRefPtReadout_RadioButton: TRadioButton
      Left = 32
      Top = 128
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
      Top = 176
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
      Top = 152
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
    object PixelDataReadout_RadioButton: TRadioButton
      Left = 32
      Top = 72
      Width = 425
      Height = 17
      Hint = 
        'ShowRGB intensities ofcurrent pixel  or of pixel used for drawin' +
        'g it'
      Caption = 
        'Display mouse point pixel location and intensity value(s) in sou' +
        'rce or displayed image'
      TabOrder = 5
      OnKeyDown = PixelDataReadout_RadioButtonKeyDown
    end
  end
  object OK_Button: TButton
    Left = 464
    Top = 408
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
    Top = 408
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
    Top = 409
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
    Top = 409
    Width = 89
    Height = 25
    Hint = 'Restore the last saved settings'
    Caption = 'Restore Defaults'
    TabOrder = 3
    OnClick = Restore_ButtonClick
    OnKeyDown = Restore_ButtonKeyDown
  end
  object LongitudeReadout_GroupBox: TGroupBox
    Left = 16
    Top = 88
    Width = 585
    Height = 57
    Caption = 'Longitude Convention'
    TabOrder = 6
    object WestLongitudes_RadioButton: TRadioButton
      Left = 16
      Top = 24
      Width = 153
      Height = 17
      Caption = '-360'#176' to 0'#176' West Longitudes'
      TabOrder = 0
    end
    object EastLongitudes_RadioButton: TRadioButton
      Left = 392
      Top = 24
      Width = 153
      Height = 17
      Caption = '0 to +360'#176' East Longitudes'
      TabOrder = 1
    end
    object CenteredLongitudes_RadioButton: TRadioButton
      Left = 192
      Top = 24
      Width = 169
      Height = 17
      Caption = '-180'#176' to +180'#176' W/E Longitudes'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
  end
end
