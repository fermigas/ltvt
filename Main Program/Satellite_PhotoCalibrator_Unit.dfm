object SatellitePhotoCalibrator_Form: TSatellitePhotoCalibrator_Form
  Left = 6
  Top = 16
  Width = 1016
  Height = 714
  Caption = 'Satellite Photo Calibrator  v0.3'
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
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Filename_Label: TLabel
    Left = 88
    Top = 8
    Width = 889
    Height = 13
    Hint = 'This is the name of the currently loaded file'
    AutoSize = False
    Caption = 'Filename_Label'
  end
  object MousePosition_Label: TLabel
    Left = 288
    Top = 56
    Width = 101
    Height = 13
    Caption = 'MousePosition_Label'
  end
  object PhotoCalibrated_Label: TLabel
    Left = 8
    Top = 616
    Width = 107
    Height = 13
    Caption = 'PhotoCalibrated_Label'
  end
  object RotationAndZoom_Label: TLabel
    Left = 8
    Top = 592
    Width = 118
    Height = 13
    Hint = 
      'Clockwise rotation of raw image with respect to a north-up Moon ' +
      'and zoom necessary to generate an LTVT image  at the scale of th' +
      'e raw image'
    Caption = 'RotationAndZoom_Label'
  end
  object CurrentMag_Label: TLabel
    Left = 664
    Top = 32
    Width = 87
    Height = 13
    Hint = 
      'Magnifcation of present image compared to pixel scale of origina' +
      'l'
    Caption = 'CurrentMag_Label'
  end
  object Zoom_Label: TLabel
    Left = 424
    Top = 32
    Width = 30
    Height = 13
    Caption = 'Zoom:'
  end
  object Label7: TLabel
    Left = 824
    Top = 32
    Width = 173
    Height = 13
    Caption = '(use CTRL-TAB to  switch  windows)'
  end
  object ScrollBox1: TScrollBox
    Left = 272
    Top = 80
    Width = 729
    Height = 585
    TabOrder = 13
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
    Top = 8
    Width = 65
    Height = 25
    Hint = 'Open a photo for calibration'
    Caption = 'Open'
    TabOrder = 0
    OnClick = LoadPhoto_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Save_Button: TButton
    Left = 136
    Top = 648
    Width = 57
    Height = 25
    Hint = 'Save calibration to database of personal photos'
    Caption = 'Save'
    TabOrder = 11
    OnClick = Save_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object SetGeometry_RadioButton: TRadioButton
    Left = 8
    Top = 40
    Width = 201
    Height = 17
    Caption = 'Step 1:  Identify Geometry'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnClick = SetGeometry_RadioButtonClick
    OnKeyDown = FormKeyDown
  end
  object RefPt1_RadioButton: TRadioButton
    Left = 8
    Top = 256
    Width = 209
    Height = 17
    Hint = 
      'After selecting this option, click on the image point correspond' +
      'ing to the specified selenographic longitude and latitude'
    Caption = 'Step 2:  Identify Reference Point 1'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    OnClick = RefPt1_RadioButtonClick
    OnKeyDown = FormKeyDown
  end
  object RefPt1_GroupBox: TGroupBox
    Left = 8
    Top = 272
    Width = 233
    Height = 121
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 14
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
    inline RefPt1_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 6
      Top = 86
      Width = 123
      Height = 19
      Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 2
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
        OnKeyDown = FormKeyDown
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
      TabOrder = 1
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
        OnKeyDown = FormKeyDown
      end
    end
    inline RefPt1_XPix_LabeledNumericEdit: TLabeledNumericEdit
      Left = 150
      Top = 52
      Width = 75
      Height = 19
      Hint = 'X-pixel -- set by clicking mouse on point'
      AutoSize = True
      TabOrder = 3
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
        OnKeyDown = FormKeyDown
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
      TabOrder = 4
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
        OnKeyDown = FormKeyDown
        InputType = tInteger
      end
    end
    object RefPt1_Copy_Button: TButton
      Left = 8
      Top = 16
      Width = 121
      Height = 25
      Hint = 'Copy longitude and latitude of REF PT in main LTVTwindow'
      Caption = 'Copy from Main Screen'
      TabOrder = 0
      OnClick = RefPt1_Copy_ButtonClick
      OnKeyDown = FormKeyDown
    end
  end
  object RefPt2_RadioButton: TRadioButton
    Left = 8
    Top = 408
    Width = 209
    Height = 17
    Hint = 
      'After selecting this option, click on the image point correspond' +
      'ing to the specified selenographic longitude and latitude'
    Caption = 'Step 3:  Identify Reference Point 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = RefPt2_RadioButtonClick
    OnKeyDown = FormKeyDown
  end
  object RefPt2_GroupBox: TGroupBox
    Left = 8
    Top = 432
    Width = 233
    Height = 121
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 15
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
    inline RefPt2_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 6
      Top = 86
      Width = 123
      Height = 19
      Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 2
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
        OnKeyDown = FormKeyDown
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
      TabOrder = 1
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
        OnKeyDown = FormKeyDown
      end
    end
    inline RefPt2_XPix_LabeledNumericEdit: TLabeledNumericEdit
      Left = 150
      Top = 52
      Width = 75
      Height = 19
      Hint = 'X-pixel -- set by clicking mouse on point'
      AutoSize = True
      TabOrder = 3
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
        OnKeyDown = FormKeyDown
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
      TabOrder = 4
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
        OnKeyDown = FormKeyDown
        InputType = tInteger
      end
    end
    object RefPt2_Copy_Button: TButton
      Left = 8
      Top = 16
      Width = 121
      Height = 25
      Hint = 'Copy longitude and latitude of REF PT in main LTVTwindow'
      Caption = 'Copy from Main Screen'
      TabOrder = 0
      OnClick = RefPt2_Copy_ButtonClick
      OnKeyDown = FormKeyDown
    end
  end
  object Geometry_GroupBox: TGroupBox
    Left = 8
    Top = 56
    Width = 257
    Height = 185
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 16
    object Label6: TLabel
      Left = 15
      Top = 16
      Width = 209
      Height = 13
      Caption = '-------------------- Time of Observation ----------------'
    end
    object Label1: TLabel
      Left = 15
      Top = 60
      Width = 210
      Height = 13
      Hint = 
        'Enter the lunar longitude and latitude of the point directly bel' +
        'ow the satellite (the "nadir") and the elevation of the satellit' +
        'e above the lunar surface'
      Caption = '---------------------- Satellite Location -------------------'
    end
    object Label8: TLabel
      Left = 15
      Top = 140
      Width = 210
      Height = 13
      Hint = 
        'Enter the longitude and latitude of the point on the lunar surfa' +
        'ce at which the camera is pointed'
      Caption = '----------------- Principal Ground Point ----------------'
    end
    object Date_DateTimePicker: TDateTimePicker
      Left = 16
      Top = 32
      Width = 89
      Height = 21
      Hint = 'Enter UT date in your national date format'
      CalAlignment = dtaLeft
      Date = 39082
      Time = 39082
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      MaxDate = 401769
      MinDate = -182619
      ParseInput = False
      TabOrder = 0
      OnKeyDown = FormKeyDown
    end
    object Time_DateTimePicker: TDateTimePicker
      Left = 128
      Top = 32
      Width = 89
      Height = 21
      Hint = 'Enter Universal Time in  HH:MM:SS format'
      CalAlignment = dtaLeft
      Date = 38718.7916666667
      Format = 'HH:mm:ss  UT'
      Time = 38718.7916666667
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 1
      OnKeyDown = FormKeyDown
    end
    inline SatelliteLonDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 8
      Top = 81
      Width = 117
      Height = 19
      Hint = 
        'Enter lunar longitude in decimal degrees (E=+  W=-) of point dir' +
        'ectly (radially) below satellite'
      AutoSize = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 21
        Caption = 'Lon:'
      end
      inherited Units_Label: TLabel
        Left = 99
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 73
        Height = 19
        Text = '0.000'
        OnKeyDown = FormKeyDown
      end
    end
    inline SatelliteLatDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 137
      Top = 81
      Width = 110
      Height = 19
      Hint = 
        'Enter lunar latitude in decimal degrees (N=+  S=-) of point dire' +
        'ctly (radially) below satellite'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 18
        Caption = 'Lat:'
      end
      inherited Units_Label: TLabel
        Left = 92
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 65
        Height = 19
        Text = '0.000'
        OnKeyDown = FormKeyDown
      end
    end
    inline SatelliteElevation_LabeledNumericEdit: TLabeledNumericEdit
      Left = 65
      Top = 110
      Width = 118
      Height = 19
      Hint = 
        'Enter elevation of satellite above Moon'#39's surface  in kilometers' +
        ' using NN.nnn format'
      AutoSize = True
      TabOrder = 4
      inherited Item_Label: TLabel
        Width = 24
        Caption = 'Elev:'
      end
      inherited Units_Label: TLabel
        Left = 104
        Width = 14
        Caption = 'km'
      end
      inherited NumericEdit: TNumericEdit
        Left = 32
        Width = 65
        Height = 19
        Text = '0.0'
        OnKeyDown = FormKeyDown
      end
    end
    inline GroundPointLonDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 8
      Top = 161
      Width = 117
      Height = 19
      Hint = 
        'Enter lunar longitude in decimal degrees (E=+  W=-) of point dir' +
        'ectly (radially) below satellite'
      AutoSize = True
      Color = clBtnFace
      ParentColor = False
      TabOrder = 5
      inherited Item_Label: TLabel
        Width = 21
        Caption = 'Lon:'
      end
      inherited Units_Label: TLabel
        Left = 99
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 73
        Height = 19
        Text = '0.000'
        OnKeyDown = FormKeyDown
      end
    end
    inline GroundPointLatDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 139
      Top = 161
      Width = 110
      Height = 19
      Hint = 
        'Enter lunar latitude in decimal degrees (N=+  S=-) of point dire' +
        'ctly (radially) below satellite'
      AutoSize = True
      TabOrder = 6
      inherited Item_Label: TLabel
        Width = 18
        Caption = 'Lat:'
      end
      inherited Units_Label: TLabel
        Left = 92
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 65
        Height = 19
        Text = '0.000'
        OnKeyDown = FormKeyDown
      end
    end
  end
  object InversionCode_RadioButton: TRadioButton
    Left = 8
    Top = 568
    Width = 97
    Height = 17
    Hint = 
      'In Step 4 you will see a readout of lunar longitude and latitude' +
      ' as the mouse is moved over the image -- check that the calibrat' +
      'ion makes sense'
    Caption = 'Step 4:  Check'
    TabOrder = 7
    OnClick = InversionCode_RadioButtonClick
    OnKeyDown = FormKeyDown
  end
  object InvertedImage_CheckBox: TCheckBox
    Left = 104
    Top = 568
    Width = 137
    Height = 17
    Caption = 'if this is a mirror image'
    TabOrder = 8
    Visible = False
    OnClick = InvertedImage_CheckBoxClick
    OnKeyDown = FormKeyDown
  end
  object Cancel_Button: TButton
    Left = 208
    Top = 648
    Width = 49
    Height = 25
    Hint = 'Close form without saving calibration data'
    Caption = 'Close'
    TabOrder = 12
    OnClick = Cancel_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Clear_Button: TButton
    Left = 8
    Top = 648
    Width = 41
    Height = 25
    Hint = 'Erase all marks from photo being calibrated'
    Caption = 'Clear'
    TabOrder = 9
    OnClick = Clear_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object ZoomIn_Button: TButton
    Left = 600
    Top = 30
    Width = 41
    Height = 20
    Hint = 'Zoom in: double the size of the current image'
    Caption = '2 X'
    TabOrder = 3
    OnClick = ZoomIn_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object ZoomOut_Button: TButton
    Left = 472
    Top = 30
    Width = 49
    Height = 20
    Hint = 'Zoom out: halve the size of the current image'
    Caption = '0.5 X'
    TabOrder = 1
    OnClick = ZoomOut_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object OneToOne_Button: TButton
    Left = 544
    Top = 30
    Width = 33
    Height = 20
    Hint = 'Restore image to original pixel scale'
    Caption = '1:1'
    TabOrder = 2
    OnClick = OneToOne_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object AutoCopy_Button: TButton
    Left = 192
    Top = 38
    Width = 57
    Height = 20
    Hint = 
      'Automatically copy Clementine support data from *.LBL file, if p' +
      'resent'
    Caption = 'Look Up'
    TabOrder = 17
    OnClick = AutoCopy_ButtonClick
    OnKeyDown = AutoCopy_ButtonKeyDown
  end
  object AddNote_Button: TButton
    Left = 64
    Top = 648
    Width = 59
    Height = 25
    Hint = 
      'Click to enter a note to be appended to the calibration data whe' +
      'n you click SAVE'
    Caption = 'Add Note'
    TabOrder = 10
    OnClick = AddNote_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 768
  end
end
