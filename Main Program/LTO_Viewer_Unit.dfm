object LTO_Viewer_Form: TLTO_Viewer_Form
  Left = 7
  Top = 31
  Width = 1012
  Height = 685
  Caption = 'Lunar Map Loader'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Filename_Label: TLabel
    Left = 80
    Top = 0
    Width = 74
    Height = 13
    Hint = 'This is the name of the currently loaded file'
    Caption = 'Filename_Label'
  end
  object MousePosition_Label: TLabel
    Left = 8
    Top = 576
    Width = 101
    Height = 13
    Caption = 'MousePosition_Label'
  end
  object CurrentMag_Label: TLabel
    Left = 96
    Top = 64
    Width = 87
    Height = 13
    Hint = 
      'Magnifcation of present image compared to pixel scale of origina' +
      'l'
    Caption = 'CurrentMag_Label'
  end
  object Zoom_Label: TLabel
    Left = 8
    Top = 32
    Width = 30
    Height = 13
    Caption = 'Zoom:'
  end
  object LonLat_Label: TLabel
    Left = 8
    Top = 600
    Width = 65
    Height = 13
    Caption = 'LonLat_Label'
  end
  object ScrollBox1: TScrollBox
    Left = 248
    Top = 24
    Width = 745
    Height = 633
    TabOrder = 14
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      Cursor = crCross
      Stretch = True
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
    end
  end
  object LoadPhoto_Button: TButton
    Left = 8
    Top = 0
    Width = 65
    Height = 25
    Hint = 'Open a photo for calibration'
    Caption = 'Open'
    TabOrder = 0
    OnClick = LoadPhoto_ButtonClick
    OnKeyDown = LoadPhoto_ButtonKeyDown
  end
  object RefPt1_RadioButton: TRadioButton
    Left = 0
    Top = 240
    Width = 209
    Height = 17
    Hint = 
      'After selecting this option, enter a  longitude and latitude and' +
      ' click on the image point corresponding to it'
    Caption = 'Step 2:  Identify  point at left edge'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 7
    OnClick = RefPt1_RadioButtonClick
    OnKeyDown = RefPt1_RadioButtonKeyDown
  end
  object RefPt1_GroupBox: TGroupBox
    Left = 8
    Top = 256
    Width = 233
    Height = 121
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 8
    object Label2: TLabel
      Left = 148
      Top = 16
      Width = 72
      Height = 13
      Caption = 'Set with mouse'
    end
    object Label3: TLabel
      Left = 184
      Top = 32
      Width = 10
      Height = 13
      Caption = '\/'
    end
    object Label1: TLabel
      Left = 56
      Top = 16
      Width = 72
      Height = 13
      Caption = 'Read from map'
    end
    object Label6: TLabel
      Left = 88
      Top = 32
      Width = 10
      Height = 13
      Caption = '\/'
    end
    inline RefPt1_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 6
      Top = 86
      Width = 123
      Height = 19
      Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 41
        Caption = 'Latitude:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Width = 65
        Height = 19
        Text = '0.000'
        OnKeyDown = RefPt1_Lat_LabeledNumericEditNumericEditKeyDown
        InputMin = '-90'
        InputMax = '90'
      end
    end
    inline RefPt1_Lon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 6
      Top = 54
      Width = 121
      Height = 19
      Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Longitude:'
      end
      inherited Units_Label: TLabel
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Width = 65
        Height = 19
        Text = '0.000'
        OnKeyDown = RefPt1_Lon_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline RefPt1_XPix_LabeledNumericEdit: TLabeledNumericEdit
      Left = 150
      Top = 52
      Width = 75
      Height = 19
      Hint = 'X-pixel -- set by clicking mouse on point'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 10
        Caption = 'X:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 16
        Height = 19
        OnKeyDown = RefPt1_XPix_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
    inline RefPt1_YPix_LabeledNumericEdit: TLabeledNumericEdit
      Left = 150
      Top = 84
      Width = 75
      Height = 19
      Hint = 'Y-pixel -- set by clicking mouse on point'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 10
        Caption = 'Y:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 16
        Height = 19
        OnKeyDown = RefPt1_YPix_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
  end
  object RefPt2_RadioButton: TRadioButton
    Left = 0
    Top = 392
    Width = 241
    Height = 17
    Hint = 
      'Click on the image point corresponding to the specified selenogr' +
      'aphic longitude and latitude; the left and right reference point' +
      's should be symmetrically placed about the center line'
    Caption = 'Step 3:  Identify  SAME latitude at right edge'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = RefPt2_RadioButtonClick
    OnKeyDown = RefPt2_RadioButtonKeyDown
  end
  object RefPt2_GroupBox: TGroupBox
    Left = 8
    Top = 416
    Width = 233
    Height = 121
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 10
    object Label4: TLabel
      Left = 148
      Top = 16
      Width = 72
      Height = 13
      Caption = 'Set with mouse'
    end
    object Label5: TLabel
      Left = 184
      Top = 32
      Width = 10
      Height = 13
      Caption = '\/'
    end
    object Label7: TLabel
      Left = 56
      Top = 16
      Width = 72
      Height = 13
      Caption = 'Read from map'
    end
    object Label8: TLabel
      Left = 88
      Top = 32
      Width = 10
      Height = 13
      Caption = '\/'
    end
    inline RefPt2_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 6
      Top = 86
      Width = 123
      Height = 19
      Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 41
        Caption = 'Latitude:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Width = 65
        Height = 19
        Text = '0.000'
        OnKeyDown = RefPt2_Lat_LabeledNumericEditNumericEditKeyDown
        InputMin = '-90'
        InputMax = '90'
      end
    end
    inline RefPt2_Lon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 6
      Top = 54
      Width = 121
      Height = 19
      Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Longitude:'
      end
      inherited Units_Label: TLabel
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Width = 65
        Height = 19
        Text = '0.000'
        OnKeyDown = RefPt2_Lon_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline RefPt2_XPix_LabeledNumericEdit: TLabeledNumericEdit
      Left = 150
      Top = 52
      Width = 75
      Height = 19
      Hint = 'X-pixel -- set by clicking mouse on point'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 10
        Caption = 'X:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 16
        Height = 19
        OnKeyDown = RefPt2_XPix_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
    inline RefPt2_YPix_LabeledNumericEdit: TLabeledNumericEdit
      Left = 150
      Top = 84
      Width = 75
      Height = 19
      Hint = 'Y-pixel -- set by clicking mouse on point'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 10
        Caption = 'Y:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 16
        Height = 19
        OnKeyDown = RefPt2_YPix_LabeledNumericEditNumericEditKeyDown
        InputType = tInteger
      end
    end
  end
  object Clear_Button: TButton
    Left = 176
    Top = 544
    Width = 65
    Height = 25
    Hint = 'Erase all marks from photo being calibrated'
    Caption = 'Clear'
    TabOrder = 12
    OnClick = Clear_ButtonClick
    OnKeyDown = Clear_ButtonKeyDown
  end
  object ZoomIn_Button: TButton
    Left = 176
    Top = 38
    Width = 41
    Height = 20
    Hint = 'Zoom in: double the size of the current image'
    Caption = '2 X'
    TabOrder = 3
    OnClick = ZoomIn_ButtonClick
    OnKeyDown = ZoomIn_ButtonKeyDown
  end
  object ZoomOut_Button: TButton
    Left = 48
    Top = 38
    Width = 49
    Height = 20
    Hint = 'Zoom out: halve the size of the current image'
    Caption = '0.5 X'
    TabOrder = 1
    OnClick = ZoomOut_ButtonClick
    OnKeyDown = ZoomOut_ButtonKeyDown
  end
  object OneToOne_Button: TButton
    Left = 120
    Top = 38
    Width = 33
    Height = 20
    Hint = 'Restore image to original pixel scale'
    Caption = '1:1'
    TabOrder = 2
    OnClick = OneToOne_ButtonClick
    OnKeyDown = OneToOne_ButtonKeyDown
  end
  object ImageCalibrated_RadioButton: TRadioButton
    Left = 0
    Top = 544
    Width = 113
    Height = 17
    Hint = 'Click to re-evaluate the calibration based on the current data'
    Caption = 'Map Calibrated'
    TabOrder = 11
    OnClick = ImageCalibrated_RadioButtonClick
    OnKeyDown = ImageCalibrated_RadioButtonKeyDown
  end
  object TransferData_Button: TButton
    Left = 8
    Top = 632
    Width = 97
    Height = 25
    Hint = 'Open calibrated LTO chart for analysis in main LTVT window'
    Caption = 'Transfer to LTVT'
    TabOrder = 13
    OnClick = TransferData_ButtonClick
    OnKeyDown = TransferData_ButtonKeyDown
  end
  object MapType_GroupBox: TGroupBox
    Left = 8
    Top = 110
    Width = 185
    Height = 83
    Hint = 
      'Use the radio buttons to specify the projection of the map you h' +
      'ave just loaded - only LTO'#39's are recognized at present'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    object LambertParallels_Label: TLabel
      Left = 32
      Top = 64
      Width = 109
      Height = 13
      Hint = 
        'Latitude of standard parallels assumed in calibration of Lambert' +
        ' projection'
      Caption = 'LambertParallels_Label'
    end
    object LTO_RadioButton: TRadioButton
      Left = 8
      Top = 16
      Width = 153
      Height = 17
      Hint = 
        'Select this projection for Topophotomaps and Lunar Topographic O' +
        'rthophotomaps'
      Caption = 'LTO (Transverse Mercator)'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = LTO_RadioButtonClick
      OnKeyDown = LTO_RadioButtonKeyDown
    end
    object Mercator_RadioButton: TRadioButton
      Left = 8
      Top = 32
      Width = 161
      Height = 17
      Hint = 
        'Select this button for maps in Mercator Projection, such as Luna' +
        'r Astronautical Charts with a latitude scale covering the range ' +
        '0-16 degrees'
      Caption = 'LAC :  0-16  deg  (Mercator)'
      TabOrder = 1
      OnClick = Mercator_RadioButtonClick
      OnKeyDown = Mercator_RadioButtonKeyDown
    end
    object Lambert_RadioButton: TRadioButton
      Left = 8
      Top = 48
      Width = 153
      Height = 17
      Hint = 
        'Select this button for maps in Lambert Conformal Conic projectio' +
        'n, such as Lunar Astronautical Charts with a latitude scale cove' +
        'ring the range 16-80 degrees'
      Caption = 'LAC : 16-80 deg  (Lambert)'
      TabOrder = 2
      OnClick = Lambert_RadioButtonClick
      OnKeyDown = Lambert_RadioButtonKeyDown
    end
  end
  inline VertCompression_LabeledNumericEdit: TLabeledNumericEdit
    Left = 8
    Top = 200
    Width = 167
    Height = 21
    Hint = 
      'See help file: this parameter may be used to make the vertical s' +
      'cale agree with the horizontal one'
    AutoSize = True
    TabOrder = 6
    inherited Item_Label: TLabel
      Width = 101
      Caption = 'Vertical Compression:'
    end
    inherited Units_Label: TLabel
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 112
      Width = 55
      Text = '0.997'
      OnKeyDown = VertCompression_LabeledNumericEditNumericEditKeyDown
    end
  end
  object MapType_RadioButton: TRadioButton
    Left = 0
    Top = 88
    Width = 177
    Height = 17
    Hint = 
      'Use the radio buttons to specify the projection of the map you h' +
      'ave just loaded'
    Caption = 'Step 1: Select map type'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnKeyDown = MapType_RadioButtonKeyDown
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'All (*.jpg;*.jpeg;*.bmp;*.ico;*.emf;*.wmf)|*.jpg;*.jpeg;*.bmp;*.' +
      'ico;*.emf;*.wmf|JPEG Image File (*.jpg)|*.jpg|JPEG Image File (*' +
      '.jpeg)|*.jpeg|Bitmaps (*.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced' +
      ' Metafiles (*.emf)|*.emf|Metafiles (*.wmf)|*.wmf'
    Title = 'Select file containing an  image of a LTO map'
    Left = 800
    Top = 32
  end
end
