object LibrationTabulator_Form: TLibrationTabulator_Form
  Left = 93
  Top = 35
  Width = 925
  Height = 690
  ActiveControl = Tabulate_Button
  Caption = 'LTVT Libration Tabulator v0.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 8
    Top = 168
    Width = 51
    Height = 13
    Hint = 'Begin making predictions on this date'
    Caption = 'Start Date:'
  end
  object Label4: TLabel
    Left = 176
    Top = 168
    Width = 51
    Height = 13
    Hint = 'Stop making predictions on this date'
    Caption = 'End Date: '
  end
  object Label2: TLabel
    Left = 512
    Top = 136
    Width = 215
    Height = 13
    Caption = 'Hint: use CTRL-TAB to return to main window'
  end
  object TargetParameters_GroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 225
    Height = 129
    Caption = 'Target Parameters'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    TabStop = True
    inline Crater_Lon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 32
      Top = 24
      Width = 162
      Height = 19
      Hint = 
        'Selenographic longitude of feature for which librations are to b' +
        'e tabulated  -- DD.ddd format'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 63
        Caption = 'Feature Lon.:'
      end
      inherited Units_Label: TLabel
        Left = 144
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 72
        Width = 65
        Height = 19
        Text = '0.00'
        OnKeyDown = Crater_Lon_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline Crater_Lat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 31
      Top = 48
      Width = 162
      Height = 19
      Hint = 
        'Selenographic latitude of feature for which librations are to be' +
        ' tabulated  -- DD.ddd format'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 60
        Hint = 'Latitude of subsolar point'
        Caption = 'Feature Lat.:'
      end
      inherited Units_Label: TLabel
        Left = 144
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 72
        Width = 65
        Height = 19
        Text = '0.00'
        OnKeyDown = Crater_Lat_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline MinSunAngleDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 7
      Top = 80
      Width = 162
      Height = 19
      Hint = 
        'Ignore times when Sun angle (on feature on Moon)  is less than t' +
        'his -- DD.ddd format'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 78
        Caption = 'Min. Sun Angle :'
      end
      inherited Units_Label: TLabel
        Left = 144
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 96
        Width = 41
        Height = 19
        Hint = 'Enter a positive decimal value'
        Text = '0.0'
        OnKeyDown = MinSunAngleDeg_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline MaxSunAngleDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 7
      Top = 104
      Width = 162
      Height = 19
      Hint = 
        'Ignore times when Sun angle (on feature on Moon)  is greater tha' +
        'n this -- DD.ddd format'
      AutoSize = True
      TabOrder = 3
      inherited Item_Label: TLabel
        Width = 81
        Caption = 'Max. Sun Angle :'
      end
      inherited Units_Label: TLabel
        Left = 144
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 96
        Width = 41
        Height = 19
        Hint = 'Enter a positive decimal value'
        Text = '90.0'
        OnKeyDown = MaxSunAngleDeg_LabeledNumericEditNumericEditKeyDown
      end
    end
  end
  object Constraints_GroupBox: TGroupBox
    Left = 256
    Top = 8
    Width = 233
    Height = 129
    Caption = 'Constraints'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    TabStop = True
    inline MinMoonElevDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 8
      Top = 20
      Width = 170
      Height = 19
      Hint = 
        'Lower limit on angle of sun above (+) or below (-) observer'#39's lo' +
        'cal horizon  -- DD.ddd format'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 80
        Caption = 'Min. Moon Elev.:'
      end
      inherited Units_Label: TLabel
        Left = 152
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 88
        Width = 57
        Height = 19
        Text = '0.00'
        OnKeyDown = MinMoonElevDeg_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline MaxSunElevDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 8
      Top = 52
      Width = 170
      Height = 19
      Hint = 
        'Upper limit on angle of sun above (+) or below (-) observer'#39's lo' +
        'cal horizon  -- DD.ddd format'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 75
        Caption = 'Max. Sun Elev.:'
      end
      inherited Units_Label: TLabel
        Left = 152
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 88
        Width = 57
        Height = 19
        Text = '0.00'
        OnKeyDown = MaxSunElevDeg_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline MaxCenterAngleDeg_LabeledNumericEdit: TLabeledNumericEdit
      Left = 15
      Top = 84
      Width = 202
      Height = 19
      Hint = 
        'Ignore events when requested feature is not closer than this dis' +
        'tance to the Moon'#39's center -- DD.ddd format'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 105
        Caption = 'Max. Center Distance:'
      end
      inherited Units_Label: TLabel
        Left = 184
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 120
        Width = 57
        Height = 19
        Text = '90.00'
        OnKeyDown = MaxCenterAngleDeg_LabeledNumericEditNumericEditKeyDown
      end
    end
  end
  object Memo1: TRichEdit
    Left = 7
    Top = 208
    Width = 882
    Height = 409
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 9
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
    TabOrder = 12
    OnClick = ClearMemo_ButtonClick
    OnKeyDown = ClearMemo_ButtonKeyDown
  end
  object Tabulate_Button: TButton
    Left = 816
    Top = 104
    Width = 67
    Height = 25
    Hint = 
      'List date/time and libration for events meeting criteria in requ' +
      'ested range of dates'
    Caption = 'Tabulate'
    TabOrder = 13
    OnClick = Tabulate_ButtonClick
    OnKeyDown = Tabulate_ButtonKeyDown
  end
  object StartDate_DateTimePicker: TDateTimePicker
    Left = 64
    Top = 168
    Width = 89
    Height = 21
    Hint = 'Enter UT date'
    CalAlignment = dtaLeft
    Date = 39448.641527141
    Time = 39448.641527141
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 4
    OnKeyDown = StartDate_DateTimePickerKeyDown
  end
  object EndDate_DateTimePicker: TDateTimePicker
    Left = 232
    Top = 168
    Width = 89
    Height = 21
    Hint = 'Enter UT date'
    CalAlignment = dtaLeft
    Date = 39814.641527141
    Time = 39814.641527141
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = False
    TabOrder = 5
    OnKeyDown = EndDate_DateTimePickerKeyDown
  end
  object Font_Button: TButton
    Left = 32
    Top = 624
    Width = 65
    Height = 25
    Hint = 'Change font used in Memo area'
    Caption = 'Font'
    TabOrder = 10
    OnClick = Font_ButtonClick
    OnKeyDown = Font_ButtonKeyDown
  end
  object ObserverLocation_GroupBox: TGroupBox
    Left = 520
    Top = 8
    Width = 185
    Height = 121
    Caption = 'Observer Location'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    TabStop = True
    inline ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 15
      Top = 24
      Width = 146
      Height = 19
      Hint = 'Observer'#39's longitude in decimal degrees (E=+  W=-)'
      AutoSize = True
      TabOrder = 0
      inherited Item_Label: TLabel
        Width = 50
        Caption = 'Longitude:'
      end
      inherited Units_Label: TLabel
        Left = 128
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Width = 65
        Height = 19
        Hint = 'Enter value in decimal degrees'
        Text = '11.79127'
        OnKeyDown = ObserverLongitude_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit
      Left = 23
      Top = 56
      Width = 138
      Height = 19
      Hint = 'Observer'#39's latitude in decimal degrees (N=+  S=-)'
      AutoSize = True
      TabOrder = 1
      inherited Item_Label: TLabel
        Width = 41
        Caption = 'Latitude:'
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
        Hint = 'Enter value in decimal degrees'
        Text = '55.28568'
        OnKeyDown = ObserverLatitude_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit
      Left = 17
      Top = 86
      Width = 136
      Height = 19
      Hint = 'Observer'#39's elevation above sea level (in meters)'
      AutoSize = True
      TabOrder = 2
      inherited Item_Label: TLabel
        Width = 47
        Caption = 'Elevation:'
      end
      inherited Units_Label: TLabel
        Left = 128
        Width = 8
        Caption = 'm'
      end
      inherited NumericEdit: TNumericEdit
        Width = 63
        Height = 19
        Text = '0.0'
        OnKeyDown = ObserverElevation_LabeledNumericEditNumericEditKeyDown
      end
    end
  end
  object GeocentricObserver_CheckBox: TCheckBox
    Left = 728
    Top = 32
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
    Left = 352
    Top = 624
    Width = 67
    Height = 25
    Hint = 'Click to halt tabulation '
    Caption = 'Abort'
    TabOrder = 11
    OnClick = Abort_ButtonClick
    OnKeyDown = Abort_ButtonKeyDown
  end
  object ShowAll_CheckBox: TCheckBox
    Left = 776
    Top = 168
    Width = 97
    Height = 17
    Hint = 'List every sample, whether it meets constraints or not'
    Caption = 'Show All'
    TabOrder = 8
    OnKeyDown = ShowAll_CheckBoxKeyDown
  end
  inline SearchTimeStepMin_LabeledNumericEdit: TLabeledNumericEdit
    Left = 337
    Top = 166
    Width = 148
    Height = 21
    Hint = 'Interval between times at which conditions are checked'
    AutoSize = True
    TabOrder = 6
    inherited Item_Label: TLabel
      Width = 60
      Caption = 'Search step:'
    end
    inherited Units_Label: TLabel
      Width = 36
      Caption = 'minutes'
    end
    inherited NumericEdit: TNumericEdit
      Left = 64
      Text = '5.0'
    end
  end
  object StartEnd_CheckBox: TCheckBox
    Left = 616
    Top = 168
    Width = 97
    Height = 17
    Hint = 'Tabulate start and end times of each interval meeting criteria'
    Caption = 'List start/end '
    TabOrder = 7
    OnKeyDown = StartEnd_CheckBoxKeyDown
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
