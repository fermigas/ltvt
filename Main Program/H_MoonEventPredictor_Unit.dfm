object MoonEventPredictor_Form: TMoonEventPredictor_Form
  Left = 60
  Top = 37
  Width = 945
  Height = 696
  ActiveControl = Tabulate_Button
  Caption = 'LTVT Moon Event Predictor v0.8'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 62
    Height = 13
    Hint = 
      'Can be used to update parameters based on lighting at this momen' +
      't'
    Caption = 'Target Event'
  end
  object Label3: TLabel
    Left = 8
    Top = 184
    Width = 51
    Height = 13
    Hint = 'Begin making predictions on this date'
    Caption = 'Start Date:'
  end
  object Label4: TLabel
    Left = 192
    Top = 184
    Width = 51
    Height = 13
    Hint = 'Stop making predictions on this date'
    Caption = 'End Date: '
  end
  object Label2: TLabel
    Left = 640
    Top = 192
    Width = 215
    Height = 13
    Caption = 'Hint: use CTRL-TAB to return to main window'
  end
  object ColongitudeMode_GroupBox: TGroupBox
    Left = 16
    Top = 72
    Width = 585
    Height = 49
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 6
    TabStop = True
    inline Colongitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 8
      Top = 16
      Width = 154
      Height = 19
      Hint = 'Desired selenographic colongitude of Sun -- DD.ddd format'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 59
        Caption = 'Colongitude:'
      end
      inherited Units_Label: TLabel
        Left = 136
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Width = 65
        Height = 19
        Text = '0.00'
        OnKeyDown = Colongitude_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline SolarLatitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 183
      Top = 16
      Width = 138
      Height = 19
      Hint = 'Sun'#39's selenographic colongitude -- DD.ddd format'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 45
        Hint = 'Latitude of subsolar point'
        Caption = 'Solar Lat:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 48
        Width = 65
        Height = 19
        Text = '0.00'
        OnKeyDown = SolarLatitude_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline IncTolerance_LabeledNumericEdit: TLabeledNumericEdit
      Left = 351
      Top = 16
      Width = 194
      Height = 19
      Hint = 
        'Flag cases where Solar Inclination is this close to target event' +
        ' -- DD.ddd format'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 114
        Caption = 'Allowable Latitude Error:'
      end
      inherited Units_Label: TLabel
        Left = 176
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 128
        Width = 41
        Height = 19
        Hint = 'Enter a positive decimal value'
        Text = '0.5'
        OnKeyDown = IncTolerance_LabeledNumericEditNumericEditKeyDown
      end
    end
  end
  object SunAltitudeMode_GroupBox: TGroupBox
    Left = 16
    Top = 72
    Width = 585
    Height = 81
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 7
    TabStop = True
    Visible = False
    inline Crater_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 13
      Top = 52
      Width = 123
      Height = 19
      Hint = 
        'Selenographic North Latitude  of Target Point in Degrees -- DD.d' +
        'dd format'
      AutoSize = True
      TabOrder = 0
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
        Text = '0.00'
        OnKeyDown = Crater_Lat_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline Crater_Lon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 13
      Top = 20
      Width = 123
      Height = 19
      Hint = 
        'Selenographic East Longitude of Target Point in Degrees  -- DD.d' +
        'dd format'
      AutoSize = True
      TabOrder = 1
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
        Text = '0.00'
        OnKeyDown = Crater_Lon_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline SunAngle_LabeledNumericEdit: TLabeledNumericEdit
      Left = 152
      Top = 20
      Width = 162
      Height = 19
      Hint = 
        'Desired angle of sun above (+) or below (-) horizon  in DD.ddd f' +
        'ormat'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 68
        Caption = 'Sun elevation:'
      end
      inherited Units_Label: TLabel
        Left = 144
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 80
        Width = 57
        Height = 19
        Text = '0.00'
        OnKeyDown = SunAngle_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline AzTolerance_LabeledNumericEdit: TLabeledNumericEdit
      Left = 359
      Top = 52
      Width = 194
      Height = 19
      Hint = 
        'Flag cases where solar azimuth is this close to target event -- ' +
        'DD.ddd format'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 113
        Caption = 'Allowable Azimuth Error:'
      end
      inherited Units_Label: TLabel
        Left = 176
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 128
        Width = 41
        Height = 19
        Hint = 'Enter a positive decimal value'
        Text = '5.0'
        OnKeyDown = AzTolerance_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline SunAzimuth_LabeledNumericEdit: TLabeledNumericEdit
      Left = 152
      Top = 52
      Width = 162
      Height = 19
      Hint = 'Angle to sun, clockwise from north, in DD.ddd format'
      AutoSize = True
      TabOrder = 4
      inherited Item_Label: TLabel
        Width = 61
        Caption = 'Sun azimuth:'
      end
      inherited Units_Label: TLabel
        Left = 144
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 80
        Width = 57
        Height = 19
        Text = '0.00'
        OnKeyDown = SunAzimuth_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline SunAngleTimeStep_LabeledNumericEdit: TLabeledNumericEdit
      Left = 417
      Top = 22
      Width = 156
      Height = 19
      Hint = 
        'MEP seaches for instances of the requested sun angle in interval' +
        's of this length.'
      AutoSize = True
      TabOrder = 5
      inherited Item_Label: TLabel
        Width = 60
        Caption = 'Search step:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 36
        Caption = 'minutes'
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Height = 19
        Text = '60.0'
        OnKeyDown = SunAngleTimeStep_LabeledNumericEditNumericEditKeyDown
      end
    end
  end
  object Date_DateTimePicker: TDateTimePicker
    Left = 80
    Top = 8
    Width = 89
    Height = 21
    Hint = 'Enter UT date for target event; press ESC to set year <1752'
    CalAlignment = dtaLeft
    Date = 39082.641527141
    Time = 39082.641527141
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 0
    OnKeyDown = Date_DateTimePickerKeyDown
  end
  object Time_DateTimePicker: TDateTimePicker
    Left = 184
    Top = 8
    Width = 89
    Height = 21
    Hint = 'Enter UT time for target event'
    CalAlignment = dtaLeft
    Date = 38405.7916666667
    Format = 'HH:mm:ss  UT'
    Time = 38405.7916666667
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkTime
    ParseInput = False
    TabOrder = 1
    OnKeyDown = Time_DateTimePickerKeyDown
  end
  object CalculateCircumstances_Button: TButton
    Left = 288
    Top = 8
    Width = 65
    Height = 25
    Hint = 
      'Compute/update colongitude and sun elevation at Target Event dat' +
      'e/time'
    Caption = 'Calculate'
    TabOrder = 2
    OnClick = CalculateCircumstances_ButtonClick
    OnKeyDown = CalculateCircumstances_ButtonKeyDown
  end
  object ColongitudeMode_RadioButton: TRadioButton
    Left = 16
    Top = 48
    Width = 113
    Height = 17
    Hint = 'Select events with specified colongitude'
    Caption = 'Colongitude Mode'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnClick = ColongitudeMode_RadioButtonClick
    OnKeyDown = ColongitudeMode_RadioButtonKeyDown
  end
  object SunAngleMode_RadioButton: TRadioButton
    Left = 168
    Top = 48
    Width = 113
    Height = 17
    Hint = 
      'Select events when sun has specified altitude over specified lun' +
      'ar location'
    Caption = 'Sun Altitude Mode'
    TabOrder = 5
    TabStop = True
    OnClick = SunAngleMode_RadioButtonClick
    OnKeyDown = SunAngleMode_RadioButtonKeyDown
  end
  object Memo1: TRichEdit
    Left = 15
    Top = 224
    Width = 906
    Height = 393
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 13
    WordWrap = False
    OnKeyDown = Memo1KeyDown
  end
  object ClearMemo_Button: TButton
    Left = 631
    Top = 627
    Width = 49
    Height = 25
    Hint = 'Clear Memo area'
    Caption = 'Clear'
    TabOrder = 16
    OnClick = ClearMemo_ButtonClick
    OnKeyDown = ClearMemo_ButtonKeyDown
  end
  object Tabulate_Button: TButton
    Left = 512
    Top = 184
    Width = 67
    Height = 25
    Hint = 
      'List date/time of all events having specified lighting within re' +
      'quested range of dates'
    Caption = 'Tabulate'
    TabOrder = 12
    OnClick = Tabulate_ButtonClick
    OnKeyDown = Tabulate_ButtonKeyDown
  end
  object StartDate_DateTimePicker: TDateTimePicker
    Left = 72
    Top = 184
    Width = 89
    Height = 21
    Hint = 'Enter UT date; press ESC to set year <1752'
    CalAlignment = dtaLeft
    Date = 39448.641527141
    Time = 39448.641527141
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 9
    OnKeyDown = StartDate_DateTimePickerKeyDown
  end
  object EndDate_DateTimePicker: TDateTimePicker
    Left = 248
    Top = 184
    Width = 89
    Height = 21
    Hint = 'Enter UT date; press ESC to set year <1752'
    CalAlignment = dtaLeft
    Date = 39814.641527141
    Time = 39814.641527141
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 10
    OnKeyDown = EndDate_DateTimePickerKeyDown
  end
  object Font_Button: TButton
    Left = 32
    Top = 624
    Width = 65
    Height = 25
    Hint = 'Change font used in Memo area'
    Caption = 'Font'
    TabOrder = 14
    OnClick = Font_ButtonClick
    OnKeyDown = Font_ButtonKeyDown
  end
  object ObserverLocation_GroupBox: TGroupBox
    Left = 608
    Top = 16
    Width = 313
    Height = 137
    Caption = 'Observer Location'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 8
    TabStop = True
    inline ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 7
      Top = 56
      Width = 154
      Height = 19
      Hint = 'Observer'#39's longitude in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Longitude:'
      end
      inherited Units_Label: TLabel
        Left = 136
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Width = 73
        Height = 19
        Hint = 'Enter value in decimal degrees'
        Text = '11.79127'
        OnChange = ObserverLongitude_LabeledNumericEditNumericEditChange
        OnKeyDown = ObserverLongitude_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 15
      Top = 80
      Width = 146
      Height = 19
      Hint = 'Observer'#39's latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 41
        Caption = 'Latitude:'
      end
      inherited Units_Label: TLabel
        Left = 128
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 48
        Width = 73
        Height = 19
        Hint = 'Enter value in decimal degrees'
        Text = '55.28568'
        OnChange = ObserverLatitude_LabeledNumericEditNumericEditChange
        OnKeyDown = ObserverLatitude_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit
      Left = 9
      Top = 104
      Width = 144
      Height = 19
      Hint = 'Observer'#39's elevation above sea level (in meters)'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 47
        Caption = 'Elevation:'
      end
      inherited Units_Label: TLabel
        Left = 136
        Width = 8
        Caption = 'm'
      end
      inherited NumericEdit: TNumericEdit
        Left = 55
        Width = 73
        Height = 19
        Text = '0.0'
        OnChange = ObserverElevation_LabeledNumericEditNumericEditChange
        OnKeyDown = ObserverElevation_LabeledNumericEditNumericEditKeyDown
      end
    end
    object ObservatoryList_ComboBox: TComboBox
      Left = 8
      Top = 24
      Width = 297
      Height = 21
      Hint = 
        'Click on any item in this list to copy its location from the Obs' +
        'ervatory List disk file'
      AutoDropDown = True
      ItemHeight = 13
      TabOrder = 0
      OnKeyDown = ObservatoryList_ComboBoxKeyDown
      OnSelect = ObservatoryList_ComboBoxSelect
    end
    object AddLocation_Button: TButton
      Left = 200
      Top = 56
      Width = 49
      Height = 25
      Hint = 'Add current location to end of list on disk'
      Caption = 'Add'
      TabOrder = 4
      OnClick = AddLocation_ButtonClick
      OnKeyDown = AddLocation_ButtonKeyDown
    end
  end
  object FilterOutput_CheckBox: TCheckBox
    Left = 376
    Top = 184
    Width = 97
    Height = 17
    Hint = 'Tabulate ONLY those events within the allowable error'
    Caption = 'Filter Output'
    TabOrder = 11
    OnKeyDown = FilterOutput_CheckBoxKeyDown
  end
  object GeocentricObserver_CheckBox: TCheckBox
    Left = 792
    Top = 120
    Width = 121
    Height = 17
    Hint = 
      'Calculate librations for a geocentric observer; uncheck to speci' +
      'fy a location'
    Caption = 'Geocentric Observer'
    TabOrder = 3
    OnClick = GeocentricObserver_CheckBoxClick
    OnKeyDown = GeocentricObserver_CheckBoxKeyDown
  end
  object Abort_Button: TButton
    Left = 336
    Top = 627
    Width = 67
    Height = 25
    Hint = 'Click to halt tabulation '
    Caption = 'Abort'
    TabOrder = 15
    OnClick = Abort_ButtonClick
    OnKeyDown = Abort_ButtonKeyDown
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdFixedPitchOnly]
    Left = 112
    Top = 624
  end
end
