object LTVT_Form: TLTVT_Form
  Left = 11
  Top = 0
  Width = 994
  Height = 744
  Caption = 'Lunar Terminator Visualization Tool'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 112
    Top = 0
    Width = 194
    Height = 13
    Caption = '------------------ Time of Observation -------------'
  end
  object Image1: TImage
    Left = 0
    Top = 50
    Width = 641
    Height = 641
    Align = alCustom
    Anchors = []
    PopupMenu = Image_PopupMenu
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
  end
  object ImageSize_Label: TLabel
    Left = 424
    Top = 16
    Width = 81
    Height = 13
    Caption = 'ImageSize_Label'
  end
  object Geometry_GroupBox: TGroupBox
    Left = 648
    Top = 0
    Width = 313
    Height = 257
    Caption = 'Geometry'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    object EstimatedData_Label: TLabel
      Left = 12
      Top = 21
      Width = 117
      Height = 13
      Hint = 'Location on Earth used to compute geometry'
      Caption = 'From observer'#39's location:'
    end
    object MoonElev_Label: TLabel
      Left = 10
      Top = 42
      Width = 103
      Height = 13
      Hint = 
        'Altitude (above horizontal) and azimuth (CW from north) of Moon ' +
        'and Sun from observation site at requested time '
      Caption = 'MoonElevation_Label'
    end
    object GeometryType_Label: TLabel
      Left = 4
      Top = 82
      Width = 101
      Height = 13
      Caption = 'GeometryType_Label'
    end
    object SubObsPtHeading_Label: TLabel
      Left = 23
      Top = 104
      Width = 90
      Height = 13
      Hint = 
        'Lon/lat of point on planet directly beneath observer -- data may' +
        ' be input manually or retrieved from JPL file by "Compute Geomet' +
        'ry"'
      Caption = 'Sub-observer Point'
    end
    object SubSolPtHeading_Label: TLabel
      Left = 178
      Top = 104
      Width = 71
      Height = 13
      Hint = 
        'Lon/lat of point on planet directly beneath Sun -- data may be i' +
        'nput manually or retrieved from JPL file by "Compute Geometry"'
      Caption = 'Sub-solar Point'
    end
    object Colongitude_Label: TLabel
      Left = 73
      Top = 208
      Width = 88
      Height = 13
      Hint = '90'#176' - Selenographic longitude of Subsolar Point'
      Caption = 'Colongitude_Label'
    end
    object PercentIlluminated_Label: TLabel
      Left = 162
      Top = 208
      Width = 119
      Height = 13
      Hint = 'Fraction of visible disk in sunlight'
      Caption = 'PercentIlluminated_Label'
    end
    object MT_Label: TLabel
      Left = 41
      Top = 232
      Width = 48
      Height = 13
      Hint = 'Longitude of Morning Terminator'
      Caption = 'MT_Label'
    end
    object ET_Label: TLabel
      Left = 179
      Top = 232
      Width = 46
      Height = 13
      Hint = 'Longitude of Evening Terminator'
      Caption = 'ET_Label'
    end
    object MoonDiameter_Label: TLabel
      Left = 10
      Top = 62
      Width = 101
      Height = 13
      Hint = 
        'Angular size of an idealized 1737.4 km radius Moon as seen from ' +
        'the observation site at the requested time '
      Caption = 'MoonDiameter_Label'
    end
    object ColonIdentifier_Label: TLabel
      Left = 24
      Top = 208
      Width = 45
      Height = 13
      Caption = 'Colong = '
    end
    inline SubSol_Lon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 182
      Top = 136
      Width = 123
      Height = 19
      Hint = 'Longitude of sub-solar point in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Longitude:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Width = 65
        Height = 19
        Text = '90.000'
        OnKeyDown = SubSol_Lon_LabeledNumericEditNumericEditKeyDown
        OnKeyPress = SubSol_Lon_LabeledNumericEditNumericEditKeyPress
      end
    end
    inline SubSol_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 182
      Top = 168
      Width = 123
      Height = 19
      Hint = 
        'Latitude (on sphere) of sub-solar point in decimal degrees (N=+ ' +
        ' S=-)'
      AutoSize = True
      TabOrder = 3
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
        OnKeyDown = SubSol_Lat_LabeledNumericEditNumericEditKeyDown
        OnKeyPress = SubSol_Lat_LabeledNumericEditNumericEditKeyPress
        InputMin = '-90'
        InputMax = '90'
      end
    end
    inline SubObs_Lon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 22
      Top = 136
      Width = 123
      Height = 19
      Hint = 'Longitude of sub-observer point in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Longitude:'
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
        OnKeyDown = SubObs_Lon_LabeledNumericEditNumericEditKeyDown
        OnKeyPress = SubObs_Lon_LabeledNumericEditNumericEditKeyPress
      end
    end
    inline SubObs_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 22
      Top = 168
      Width = 123
      Height = 19
      Hint = 
        'Latitude (on sphere) of sub-observer point in decimal degrees (N' +
        '=+  S=-)'
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
        OnKeyDown = SubObs_Lat_LabeledNumericEditNumericEditKeyDown
        OnKeyPress = SubObs_Lat_LabeledNumericEditNumericEditKeyPress
        InputMin = '-90'
        InputMax = '90'
      end
    end
  end
  object MousePosition_GroupBox: TGroupBox
    Left = 648
    Top = 536
    Width = 313
    Height = 113
    Hint = 
      'Information related to current mouse position; in top caption, "' +
      'Map" is IAU format LTO zone number; "Rnn" is R'#252'kl sheet number'
    Caption = 'Mouse Position'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 7
    object SunAngle_Label: TLabel
      Left = 11
      Top = 44
      Width = 78
      Height = 13
      Hint = 
        'Information related to mouse distance from current reference poi' +
        'nt'
      Caption = 'SunAngle_Label'
    end
    object RefPtDistance_Label: TLabel
      Left = 12
      Top = 68
      Width = 101
      Height = 13
      Caption = 'RefPtDistance_Label'
    end
    object CraterName_Label: TLabel
      Left = 9
      Top = 92
      Width = 88
      Height = 13
      Hint = 'Information about dot closest to current mouse point'
      Caption = 'CraterName_Label'
    end
    object MouseLonLat_Label: TLabel
      Left = 8
      Top = 20
      Width = 97
      Height = 13
      Hint = 'Longitude and latitude of current mouse point'
      Caption = 'MouseLonLat_Label'
    end
  end
  object Date_DateTimePicker: TDateTimePicker
    Left = 112
    Top = 16
    Width = 89
    Height = 21
    Hint = 
      'Enter UT date in your national date format; press ESC to set yea' +
      'r <1752'
    CalAlignment = dtaLeft
    Date = 39447
    Time = 39447
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 1
    OnChange = Date_DateTimePickerChange
    OnKeyDown = Date_DateTimePickerKeyDown
  end
  object Time_DateTimePicker: TDateTimePicker
    Left = 216
    Top = 16
    Width = 89
    Height = 21
    Hint = 'Enter Universal Time in HH:MM:SS format'
    CalAlignment = dtaLeft
    Date = 38718.7916666667
    Format = 'HH:mm:ss  UT'
    Time = 38718.7916666667
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 2
    OnChange = Time_DateTimePickerChange
    OnEnter = Time_DateTimePickerEnter
    OnKeyDown = Time_DateTimePickerKeyDown
  end
  object Now_Button: TButton
    Left = 15
    Top = 8
    Width = 82
    Height = 30
    Hint = 'Set boxes to current Universal Date/Time and refresh map'
    Caption = 'Current UT'
    TabOrder = 0
    OnClick = Now_ButtonClick
    OnKeyDown = Now_ButtonKeyDown
  end
  object MoonDisplay_GroupBox: TGroupBox
    Left = 648
    Top = 264
    Width = 313
    Height = 265
    Caption = 'Moon Display'
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 6
    object DrawingMap_Label: TLabel
      Left = 111
      Top = 14
      Width = 106
      Height = 13
      Caption = 'Drawing texture map...'
    end
    object StatusLine_Label: TLabel
      Left = 31
      Top = 56
      Width = 82
      Height = 13
      Caption = 'StatusLine_Label'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ThreeD_CheckBox: TCheckBox
      Left = 120
      Top = 54
      Width = 113
      Height = 17
      Hint = 'In drawing from DEMs, display points at correct projected height'
      Caption = 'Display DEM in 3D'
      TabOrder = 19
      OnKeyDown = ThreeD_CheckBoxKeyDown
    end
    object DrawCircles_CheckBox: TCheckBox
      Left = 120
      Top = 17
      Width = 97
      Height = 17
      Hint = 'Draw circles around dots, indicating feature size'
      Caption = 'Draw circles'
      TabOrder = 15
      OnKeyDown = DrawCircles_CheckBoxKeyDown
    end
    inline CraterThreshold_LabeledNumericEdit: TLabeledNumericEdit
      Left = 12
      Top = 28
      Width = 95
      Height = 19
      Hint = 
        'Enter -1 to plot flagged features only; enter 0 or greater to pl' +
        'ot all features exceeding the specified size'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 40
        Caption = 'Min Size'
      end
      inherited Units_Label: TLabel
        Left = 88
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 48
        Height = 19
        Text = '-1'
        OnKeyDown = CraterThreshold_LabeledNumericEditNumericEditKeyDown
      end
    end
    object ProgressBar1: TProgressBar
      Left = 131
      Top = 33
      Width = 150
      Height = 16
      Min = 0
      Max = 100
      TabOrder = 0
      Visible = False
    end
    object DrawDots_Button: TButton
      Left = 8
      Top = 80
      Width = 45
      Height = 25
      Hint = 
        'Draw fresh dot diagram based on current geometry; identify dots ' +
        'by pointing to them with mouse'
      Caption = 'Dots'
      TabOrder = 2
      OnClick = DrawDots_ButtonClick
      OnKeyDown = DrawDots_ButtonKeyDown
    end
    object DrawTexture_Button: TButton
      Left = 64
      Top = 80
      Width = 55
      Height = 25
      Hint = 
        'Draw fresh surface relief simulation using current geometry and ' +
        'reference texture indicated by radio buttons below'
      Caption = 'Texture'
      TabOrder = 3
      OnClick = DrawTexture_ButtonClick
      OnKeyDown = DrawTexture_ButtonKeyDown
    end
    object OverlayDots_Button: TButton
      Left = 176
      Top = 80
      Width = 73
      Height = 25
      Hint = 
        'Add dots to texture map;  identify dots by pointing to them with' +
        ' mouse'
      Caption = 'Overlay Dots'
      TabOrder = 4
      OnClick = OverlayDots_ButtonClick
      OnKeyDown = OverlayDots_ButtonKeyDown
    end
    object Texture1_RadioButton: TRadioButton
      Left = 24
      Top = 117
      Width = 257
      Height = 17
      Hint = 'Draw textures with this reference map (default)'
      Caption = 'LoRes USGS'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      TabStop = True
      OnKeyDown = Texture1_RadioButtonKeyDown
    end
    object Texture2_RadioButton: TRadioButton
      Left = 24
      Top = 137
      Width = 273
      Height = 17
      Hint = 'Draw textures with this reference map'
      Caption = 'HiRes USGS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      TabStop = True
      OnKeyDown = Texture2_RadioButtonKeyDown
    end
    object Texture3_RadioButton: TRadioButton
      Left = 24
      Top = 157
      Width = 265
      Height = 17
      Hint = 'Draw textures with this reference map'
      Caption = 'Clementine'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      TabStop = True
      OnKeyDown = Texture3_RadioButtonKeyDown
    end
    inline Zoom_LabeledNumericEdit: TLabeledNumericEdit
      Left = 88
      Top = 233
      Width = 73
      Height = 19
      AutoSize = True
      TabOrder = 12
      inherited Item_Label: TLabel
        Width = 30
        Caption = 'Zoom:'
      end
      inherited Units_Label: TLabel
        Left = 64
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 32
        Width = 41
        Height = 19
        Hint = 
          'Enter any numeric value in n.nnn format;  on next "Dots" or "Tex' +
          'ture", image will be this much larger or smaller than normal siz' +
          'e'
        Text = '1.0'
        OnKeyDown = Zoom_LabeledNumericEditNumericEditKeyDown
      end
    end
    object ResetZoom_Button: TButton
      Left = 264
      Top = 80
      Width = 41
      Height = 25
      Hint = 
        'Reset center to (0,0) , zoom to 1, rotation angle to 0, feature ' +
        'threshold to -1 and gamma to 1'
      Caption = 'Reset'
      TabOrder = 13
      OnClick = ResetZoom_ButtonClick
      OnKeyDown = ResetZoom_ButtonKeyDown
    end
    object LabelDots_Button: TButton
      Left = 256
      Top = 24
      Width = 49
      Height = 25
      Hint = 'Label all features currently represented by dots'
      Caption = 'Label'
      TabOrder = 5
      Visible = False
      OnClick = LabelDots_ButtonClick
      OnKeyDown = LabelDots_ButtonKeyDown
    end
    object UserPhoto_RadioButton: TRadioButton
      Left = 24
      Top = 176
      Width = 265
      Height = 17
      Hint = 'Draw texture with user-supplied photo'
      Caption = 'UserPhoto_RadioButton'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      TabStop = True
      OnKeyDown = UserPhoto_RadioButtonKeyDown
    end
    inline Gamma_LabeledNumericEdit: TLabeledNumericEdit
      Left = 8
      Top = 233
      Width = 73
      Height = 19
      Hint = 
        'Modify contrast of image -- a high gamma correction brings out t' +
        'he terminator'
      AutoSize = True
      TabOrder = 11
      inherited Item_Label: TLabel
        Width = 39
        Caption = 'Gamma:'
      end
      inherited Units_Label: TLabel
        Left = 40
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 40
        Width = 33
        Height = 19
        Text = '1.0'
        OnKeyDown = Gamma_LabeledNumericEditNumericEditKeyDown
      end
    end
    object LTO_RadioButton: TRadioButton
      Left = 24
      Top = 195
      Width = 265
      Height = 17
      Hint = 'Draw texture with Lunar Topo Orthophoto map'
      Caption = 'LTO_RadioButton'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      TabStop = True
      OnKeyDown = LTO_RadioButtonKeyDown
    end
    inline GridSpacing_LabeledNumericEdit: TLabeledNumericEdit
      Left = 248
      Top = 233
      Width = 59
      Height = 19
      AutoSize = True
      TabOrder = 14
      inherited Item_Label: TLabel
        Width = 22
        Caption = 'Grid:'
      end
      inherited Units_Label: TLabel
        Left = 56
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 33
        Height = 19
        Hint = 
          'Grid spacing in decimal degrees; no grid will be drawn if set = ' +
          '0'
        OnKeyDown = GridSpacing_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline RotationAngle_LabeledNumericEdit: TLabeledNumericEdit
      Left = 168
      Top = 233
      Width = 75
      Height = 19
      Hint = 
        'Enter additional rotation to be applied to Moon image after angl' +
        'e normally determined by program'
      AutoSize = True
      TabOrder = 16
      inherited Item_Label: TLabel
        Width = 20
        Caption = 'Rot:'
      end
      inherited Units_Label: TLabel
        Left = 72
        Width = 3
        Caption = ''
      end
      inherited NumericEdit: TNumericEdit
        Left = 24
        Width = 49
        Height = 19
        Hint = 'Enter clockwise rotation angle in +/-DDD.ddd decimal formal'
        OnKeyDown = RotationAngle_LabeledNumericEditNumericEditKeyDown
      end
    end
    object MarkCenter_CheckBox: TCheckBox
      Left = 120
      Top = 35
      Width = 97
      Height = 17
      Hint = 
        'Place a plus mark at the center of image each time it is refresh' +
        'ed'
      Caption = 'Mark center'
      TabOrder = 17
      OnKeyDown = MarkCenter_CheckBoxKeyDown
    end
    object DrawDEM_Button: TButton
      Left = 128
      Top = 80
      Width = 41
      Height = 25
      Hint = 'Create simulated image based on Digital Elevation Model'
      Caption = 'DEM'
      TabOrder = 18
      OnClick = DrawDEM_ButtonClick
      OnKeyDown = DrawDEM_ButtonKeyDown
    end
    object Abort_Button: TButton
      Left = 264
      Top = 11
      Width = 41
      Height = 20
      Hint = 'Halt current drawing'
      Caption = 'Abort'
      TabOrder = 20
      Visible = False
      OnClick = Abort_ButtonClick
    end
  end
  object SearchPhotoSessions_Button: TButton
    Left = 872
    Top = 660
    Width = 81
    Height = 28
    Hint = 
      'Searches list of user-calibrated photos for ones containing cent' +
      'er point of current image at various lightings'
    Caption = 'Find Photos'
    TabOrder = 10
    OnClick = SearchPhotoSessions_ButtonClick
    OnKeyDown = SearchPhotoSessions_ButtonKeyDown
  end
  object SaveImage_Button: TButton
    Left = 656
    Top = 660
    Width = 81
    Height = 28
    Hint = 
      'Save annotated copy of current view as .jpg or .bmp file (.bmp s' +
      'uggested!)'
    Caption = 'Save Image'
    TabOrder = 8
    OnClick = SaveImage_ButtonClick
    OnKeyDown = SaveImage_ButtonKeyDown
  end
  object Predict_Button: TButton
    Left = 776
    Top = 659
    Width = 65
    Height = 28
    Hint = 'Find other dates/times with similar colongitude or sun angle'
    Caption = 'Predict'
    TabOrder = 9
    OnClick = Predict_ButtonClick
    OnKeyDown = Predict_ButtonKeyDown
  end
  object EstimateData_Button: TButton
    Left = 512
    Top = 8
    Width = 113
    Height = 30
    Hint = 
      'Estimate observing geometry from specified location at indicated' +
      ' date/time'
    Caption = 'Compute Geometry'
    TabOrder = 4
    OnClick = EstimateData_ButtonClick
    OnKeyDown = EstimateData_ButtonKeyDown
  end
  object SetLocation_Button: TButton
    Left = 336
    Top = 8
    Width = 65
    Height = 30
    Hint = 'Specify a new observer location and refresh map'
    Caption = 'Location'
    ModalResult = 3
    TabOrder = 3
    OnClick = SetLocation_ButtonClick
    OnKeyDown = SetLocation_ButtonKeyDown
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text Files (*.txt)|*.txt|All Files|*.*'
    InitialDir = '.'
    Left = 176
    Top = 96
  end
  object SavePictureDialog1: TSavePictureDialog
    DefaultExt = 'bmp'
    Filter = 
      'Bitmaps (*.bmp)|*.bmp|JPEG Image File (*.jpg)|*.jpg|JPEG Image F' +
      'ile (*.jpeg)|*.jpeg|All (*.bmp;*.jpg;*.jpeg)|*.bmp;*.jpg;*.jpeg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 216
    Top = 96
  end
  object MainMenu1: TMainMenu
    Left = 328
    Top = 96
    object Files1: TMenuItem
      Caption = '&Files'
      object ChangeExternalFiles_MainMenuItem: TMenuItem
        Caption = 'Change external &file associations...'
        OnClick = ChangeExternalFiles_MainMenuItemClick
      end
      object OpenAnLTOchart1: TMenuItem
        Caption = '&Open an LTO/LAC chart...'
        OnClick = OpenAnLTOchart1Click
      end
      object CalibratePhoto_MainMenuItem: TMenuItem
        Caption = '&Calibrate a user photo...'
        OnClick = CalibratePhoto_MainMenuItemClick
      end
      object Calibrateasatellitephoto1: TMenuItem
        Caption = 'Calibrate a satellite &photo...'
        OnClick = Calibrateasatellitephoto1Click
      end
      object LoadCalibratedPhoto_MainMenuItem: TMenuItem
        Caption = '&Load a calibrated photo...'
        OnClick = LoadCalibratedPhoto_MainMenuItemClick
      end
      object SearchUncalibratedPhotos_MainMenuItem: TMenuItem
        Caption = 'Search a photo &times list...'
        OnClick = SearchUncalibratedPhotos_MainMenuItemClick
      end
      object Saveoptions_MainMenuItem: TMenuItem
        Caption = 'S&ave all options...'
        Hint = 
          'Save current observer location, etc. as defaults for next start ' +
          'up'
        OnClick = Saveoptions_MainMenuItemClick
      end
      object ChangeIniFile_MainMenuItem: TMenuItem
        Caption = 'Change *.&ini file...'
        OnClick = ChangeIniFile_MainMenuItemClick
      end
      object SaveImage_MainMenuItem: TMenuItem
        Caption = '&Save image...'
        OnClick = SaveImage_MainMenuItemClick
      end
      object ExportTexture_MainMenuItem: TMenuItem
        Caption = '&Export texture...'
        OnClick = ExportTexture_MainMenuItemClick
      end
      object Exit_MainMenuItem: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit_MainMenuItemClick
      end
    end
    object Tools1: TMenuItem
      Caption = '&Tools'
      object GoTo_MainMenuItem: TMenuItem
        Caption = '&Go to named feature or lon/lat...'
        Hint = 'Re-center present plot on a specified feature'
        OnClick = GoTo_MainMenuItemClick
      end
      object DrawCircle_MainMenuItem: TMenuItem
        Caption = '&Draw circle...'
        OnClick = DrawCircle_MainMenuItemClick
      end
      object DrawLimb_MainMenuItem: TMenuItem
        Caption = 'Draw observer'#39's &limb'
        OnClick = DrawLimb_MainMenuItemClick
      end
      object Changelabelpreferences_MainMenuItem: TMenuItem
        Caption = 'Change dot/label &preferences...'
        Hint = 'Change font or positioning of labels'
        OnClick = Changelabelpreferences_MainMenuItemClick
      end
      object ChangeCartographicOptions_MainMenuItem: TMenuItem
        Caption = 'Change &cartographic options...'
        OnClick = ChangeCartographicOptions_MainMenuItemClick
      end
      object ChangeTargetPlanet_MainMenuItem: TMenuItem
        Caption = 'Ch&ange target planet...'
        OnClick = ChangeTargetPlanet_MainMenuItemClick
      end
      object ChangeDemOptions_MainMenuItem: TMenuItem
        Caption = 'Change DEM &options...'
        OnClick = ChangeDemOptions_MainMenuItemClick
      end
      object DrawDEMheightcontours_MainMenuItem: TMenuItem
        Caption = 'Draw DEM &height contours...'
        OnClick = DrawDEMheightcontours_MainMenuItemClick
      end
      object ChangeMouseOptions_MainMenuItem: TMenuItem
        Caption = 'Change &mouse options...'
        OnClick = ChangeMouseOptions_MainMenuItemClick
      end
      object TabulateLibrations_MainMenuItem: TMenuItem
        Caption = '&Tabulate librations...'
        OnClick = TabulateLibrations_MainMenuItemClick
      end
      object ShowEarth_MainMenuItem: TMenuItem
        Caption = 'Show &Earth viewed from Moon'
        OnClick = ShowEarth_MainMenuItemClick
      end
      object DrawRuklGrid_MainMenuItem: TMenuItem
        Caption = 'Draw &R'#252'kl grid'
        OnClick = DrawRuklGrid_MainMenuItemClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object HelpContents_MenuItem: TMenuItem
        Caption = 
          '&User'#39's Guide (also available by pressing F1 when a button is hi' +
          'ghlighted)'
        OnClick = HelpContents_MenuItemClick
      end
      object FindJPLfile_MenuItem: TMenuItem
        Caption = 'Obtaining &JPL ephemeris files...'
        OnClick = FindJPLfile_MenuItemClick
      end
      object Changetexturefile_MenuItem: TMenuItem
        Caption = 'Obtaining &texture files...'
        OnClick = Changetexturefile_MenuItemClick
      end
      object About_MainMenuItem: TMenuItem
        Caption = '&About LTVT...'
        Hint = 'Display information about this program'
        OnClick = About_MainMenuItemClick
      end
    end
  end
  object Image_PopupMenu: TPopupMenu
    OnPopup = Image_PopupMenuPopup
    Left = 376
    Top = 96
    object MouseOptions_RightClickMenuItem: TMenuItem
      Caption = 'Mouse options...'
      OnClick = MouseOptions_RightClickMenuItemClick
    end
    object DrawLinesToPoleAndSun_RightClickMenuItem: TMenuItem
      Caption = 
        'Draw lines towards sub-solar point (red) and Moon'#39's north pole (' +
        'blue)'
      OnClick = DrawLinesToPoleAndSun_RightClickMenuItemClick
    end
    object Goto_RightClickMenuItem: TMenuItem
      Caption = 'Go to location, mark or create aerial view...'
      OnClick = Goto_RightClickMenuItemClick
    end
    object IdentifyNearestFeature_RightClickMenuItem: TMenuItem
      Caption = 'Identify and label nearest named feature'
      OnClick = IdentifyNearestFeature_RightClickMenuItemClick
    end
    object LabelFeatureAndSatellites_RightClickMenuItem: TMenuItem
      Caption = 'Identify nearest named feature and all features sharing name'
      OnClick = LabelFeatureAndSatellites_RightClickMenuItemClick
    end
    object LabelNearestDot_RightClickMenuItem: TMenuItem
      Caption = 'Label nearest dot'
      OnClick = LabelNearestDot_RightClickMenuItemClick
    end
    object NearestDotAdditionalInfo_RightClickMenuItem: TMenuItem
      Caption = 'Additional information regarding nearest dot'
      OnClick = NearestDotAdditionalInfo_RightClickMenuItemClick
    end
    object CountDots_RightClickMenuItem: TMenuItem
      Caption = 'Count dots'
      Hint = 'Display number of feature dots in current display'
      OnClick = CountDots_RightClickMenuItemClick
    end
    object AddLabel_RightClickMenuItem: TMenuItem
      Caption = 'Add label...'
      OnClick = AddLabel_RightClickMenuItemClick
    end
    object DrawCircle_RightClickMenuItem: TMenuItem
      Caption = 'Draw circle...'
      OnClick = DrawCircle_RightClickMenuItemClick
    end
    object DrawContours_RightClickMenuItem: TMenuItem
      Caption = 'Draw contours...'
      OnClick = DrawDEMheightcontours_MainMenuItemClick
    end
    object SetRefPt_RightClickMenuItem: TMenuItem
      Caption = 'Set reference point'
      OnClick = SetRefPt_RightClickMenuItemClick
    end
    object NearestDotToReferencePoint_RightClickMenuItem: TMenuItem
      Caption = 'Nearest dot --> reference point'
      OnClick = NearestDotToReferencePoint_RightClickMenuItemClick
    end
    object Recordshadowmeasurement_RightClickMenuItem: TMenuItem
      Caption = 'Record shadow measurement'
      OnClick = Recordshadowmeasurement_RightClickMenuItemClick
    end
    object Help_RightClickMenuItem: TMenuItem
      Caption = 'Help'
      OnClick = Help_RightClickMenuItemClick
    end
    object ESCkeytocancel_RightClickMenuItem: TMenuItem
      Caption = 'Cancel (click here or press ESC key)'
    end
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 136
    Top = 96
  end
end
