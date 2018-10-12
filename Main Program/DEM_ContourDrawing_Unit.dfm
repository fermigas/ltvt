object DEM_ContourDrawing_Form: TDEM_ContourDrawing_Form
  Left = 551
  Top = 228
  Width = 402
  Height = 163
  Caption = 'Draw DEM-based height contours'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  inline ContourIntervalMeters_LabeledNumericEdit: TLabeledNumericEdit
    Left = 8
    Top = 40
    Width = 166
    Height = 21
    Hint = 'Contours will be drawn at  integral multiples of this height'
    AutoSize = True
    TabOrder = 1
    inherited Item_Label: TLabel
      Width = 77
      Caption = 'Contour interval:'
    end
    inherited Units_Label: TLabel
      Left = 152
      Width = 14
      Caption = 'km'
    end
    inherited NumericEdit: TNumericEdit
      Left = 88
      Width = 55
      Hint = 'Enter contour spacing in meters'
      Text = '1.000'
      OnKeyDown = FormKeyDown
    end
  end
  object Contour_ColorBox: TColorBox
    Left = 248
    Top = 16
    Width = 97
    Height = 22
    Hint = 'Select the color to be used for drawing the contours'
    Selected = clRed
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 2
    OnKeyDown = FormKeyDown
  end
  object Close_Button: TButton
    Left = 288
    Top = 88
    Width = 51
    Height = 25
    Hint = 'Close tool leaving image in current state'
    Caption = 'Close'
    TabOrder = 5
    OnClick = Close_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object DrawContours_Button: TButton
    Left = 64
    Top = 88
    Width = 57
    Height = 25
    Hint = 'Draw contours on present map based on last DEM loaded'
    Caption = 'Draw'
    TabOrder = 3
    OnClick = DrawContours_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object ClearContours_Button: TButton
    Left = 160
    Top = 88
    Width = 57
    Height = 25
    Hint = 
      'Erase contours by reverting to state of map when dialog was invo' +
      'ked'
    Caption = 'Clear'
    TabOrder = 4
    OnClick = ClearContours_ButtonClick
    OnKeyDown = FormKeyDown
  end
  inline BaseLevel_LabeledNumericEdit: TLabeledNumericEdit
    Left = 32
    Top = 8
    Width = 142
    Height = 21
    Hint = 'Contours will be drawn at  integral multiples of this height'
    AutoSize = True
    TabOrder = 0
    inherited Item_Label: TLabel
      Caption = 'Base level:'
    end
    inherited Units_Label: TLabel
      Left = 128
      Width = 14
      Caption = 'km'
    end
    inherited NumericEdit: TNumericEdit
      Left = 64
      Width = 55
      Hint = 'Enter contour spacing in meters'
      Text = '0.0'
      OnKeyDown = FormKeyDown
    end
  end
end
