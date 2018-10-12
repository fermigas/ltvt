object CalibratedPhotoLoader_Form: TCalibratedPhotoLoader_Form
  Left = 136
  Top = 17
  Width = 815
  Height = 718
  Caption = 'Calibrated Photo Selector  v0.5'
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
  object Image1: TImage
    Left = 536
    Top = 48
    Width = 265
    Height = 153
    Hint = 'This is a preview of the currently selected image'
    IncrementalDisplay = True
    Proportional = True
  end
  object Label2: TLabel
    Left = 559
    Top = 336
    Width = 207
    Height = 13
    Caption = '-------------------    Calibration Points  -----------------'
  end
  object DateTime_Label: TLabel
    Left = 536
    Top = 208
    Width = 78
    Height = 13
    Hint = 'Universal date and time from calibration data file'
    Caption = 'DateTime_Label'
  end
  object ObsLocation_Label: TLabel
    Left = 536
    Top = 232
    Width = 92
    Height = 13
    Hint = 'Location from which photo was taken (per calibration data file)'
    Caption = 'ObsLocation_Label'
  end
  object SubObsPt_Label: TLabel
    Left = 536
    Top = 280
    Width = 80
    Height = 13
    Hint = 
      'Selenographic longitude/latitude of center point on Moon calcula' +
      'ted from preceding data (also called librations)'
    Caption = 'SubObsPt_Label'
  end
  object SubSolPt_Label: TLabel
    Left = 536
    Top = 304
    Width = 76
    Height = 13
    Hint = 
      'Selenographic longitude/latitude of point on Moon directly benea' +
      'th Sun (calculated from preceding data)'
    Caption = 'SubSolPt_Label'
  end
  object PhotoSize_Label: TLabel
    Left = 536
    Top = 256
    Width = 80
    Height = 13
    Hint = 'Size of raw photo in pixels (Width x Height)'
    Caption = 'PhotoSize_Label'
  end
  object Filename_Label: TLabel
    Left = 136
    Top = 4
    Width = 657
    Height = 13
    Hint = 'Name of file containing calibration data'
    AutoSize = False
    Caption = 'Filename_Label'
  end
  object ImageFilename_Label: TLabel
    Left = 10
    Top = 28
    Width = 729
    Height = 13
    Hint = 'Full name of currently selected image file'
    AutoSize = False
    Caption = 'ImageFilename_Label'
  end
  object Label1: TLabel
    Left = 536
    Top = 615
    Width = 110
    Height = 13
    Hint = 
      'When you click SELECT, the following parameters in the main wind' +
      'ow can be replaced with those appropriate to the image being sel' +
      'ected'
    Caption = 'Overwrite the following:'
  end
  object Label3: TLabel
    Left = 80
    Top = 4
    Width = 47
    Height = 13
    Caption = 'Image list:'
  end
  object ListBox1: TListBox
    Left = 24
    Top = 80
    Width = 497
    Height = 609
    Hint = 'Click on a photo name or use keyboard to move through list'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'QuickType Mono'
    Font.Pitch = fpFixed
    Font.Style = []
    ItemHeight = 12
    ParentFont = False
    TabOrder = 6
    OnClick = ListBox1Click
    OnKeyDown = ListBox1KeyDown
  end
  object SelectPhoto_Button: TButton
    Left = 544
    Top = 552
    Width = 65
    Height = 25
    Hint = 'Click to select highlighted photo and close form'
    Caption = 'Select'
    TabOrder = 16
    OnClick = SelectPhoto_ButtonClick
    OnKeyDown = SelectPhoto_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 712
    Top = 552
    Width = 57
    Height = 25
    Hint = 'Close form without selecting a photo'
    Caption = 'Cancel'
    TabOrder = 17
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
  inline X1_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 672
    Top = 368
    Width = 107
    Height = 21
    Hint = 
      'Horizontal position of point in image (in pixels measured left t' +
      'o right)'
    AutoSize = True
    TabOrder = 9
    inherited Item_Label: TLabel
      Width = 30
      Caption = 'XPix1:'
    end
    inherited Units_Label: TLabel
      Left = 104
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 40
      Width = 55
      OnKeyDown = X1_Pix_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
  inline Y1_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 672
    Top = 392
    Width = 107
    Height = 21
    Hint = 
      'Vertical position of point in image (in pixels measured top to b' +
      'ottom)'
    AutoSize = True
    TabOrder = 10
    inherited Item_Label: TLabel
      Width = 30
      Caption = 'YPix1:'
    end
    inherited Units_Label: TLabel
      Left = 104
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 40
      Width = 55
      OnKeyDown = Y1_Pix_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
  inline Lon1_LabeledNumericEdit: TLabeledNumericEdit
    Left = 534
    Top = 368
    Width = 99
    Height = 21
    Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
    AutoSize = True
    TabOrder = 7
    inherited Item_Label: TLabel
      Width = 27
      Caption = 'Lon1:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 65
      Text = '0.000'
      OnKeyDown = Lon1_LabeledNumericEditNumericEditKeyDown
    end
  end
  inline Lat1_LabeledNumericEdit: TLabeledNumericEdit
    Left = 534
    Top = 392
    Width = 99
    Height = 21
    Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
    AutoSize = True
    TabOrder = 8
    inherited Item_Label: TLabel
      Width = 24
      Caption = 'Lat1:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 65
      Text = '0.000'
      OnKeyDown = Lat1_LabeledNumericEditNumericEditKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  inline InversionCode_LabeledNumericEdit: TLabeledNumericEdit
    Left = 648
    Top = 504
    Width = 123
    Height = 21
    Hint = 
      '+1 indicates a normal image; -1 indicates the disk file is a mir' +
      'ror image of the naked eye Moon'
    AutoSize = True
    TabOrder = 15
    inherited Item_Label: TLabel
      Width = 56
      Caption = 'Mirror code:'
    end
    inherited Units_Label: TLabel
      Left = 120
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 64
      Width = 33
      OnKeyDown = InversionCode_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
  inline X2_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 672
    Top = 440
    Width = 107
    Height = 21
    Hint = 
      'Horizontal position of point in image (in pixels measured left t' +
      'o right)'
    AutoSize = True
    TabOrder = 13
    inherited Item_Label: TLabel
      Width = 30
      Caption = 'XPix2:'
    end
    inherited Units_Label: TLabel
      Left = 104
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 40
      Width = 55
      OnKeyDown = X2_Pix_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
  inline Y2_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 672
    Top = 464
    Width = 107
    Height = 21
    Hint = 
      'Vertical position of point in image (in pixels measured top to b' +
      'ottom)'
    AutoSize = True
    TabOrder = 14
    inherited Item_Label: TLabel
      Width = 30
      Caption = 'YPix2:'
    end
    inherited Units_Label: TLabel
      Left = 104
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 40
      Width = 55
      OnKeyDown = Y2_Pix_LabeledNumericEditNumericEditKeyDown
      InputType = tInteger
    end
  end
  inline Lon2_LabeledNumericEdit: TLabeledNumericEdit
    Left = 534
    Top = 440
    Width = 99
    Height = 21
    Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
    AutoSize = True
    TabOrder = 11
    inherited Item_Label: TLabel
      Width = 27
      Caption = 'Lon2:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 65
      Text = '0.000'
      OnKeyDown = Lon2_LabeledNumericEditNumericEditKeyDown
    end
  end
  inline Lat2_LabeledNumericEdit: TLabeledNumericEdit
    Left = 534
    Top = 464
    Width = 99
    Height = 21
    Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
    AutoSize = True
    TabOrder = 12
    inherited Item_Label: TLabel
      Width = 24
      Caption = 'Lat2:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 65
      Text = '0.000'
      OnKeyDown = Lat2_LabeledNumericEditNumericEditKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  object OverwriteNone_RadioButton: TRadioButton
    Left = 536
    Top = 592
    Width = 249
    Height = 17
    Hint = 
      'The selected photo will be re-mapped into the geometry of the cu' +
      'rrent view in the main window (note: sun angle readouts and shad' +
      'ow lengths will NOT be valid)'
    Caption = 'Load without altering main window parameters'
    TabOrder = 18
    OnKeyDown = OverwriteNone_RadioButtonKeyDown
  end
  object OverwriteGeometry_RadioButton: TRadioButton
    Left = 528
    Top = 638
    Width = 145
    Height = 17
    Hint = 
      'Sets Sub-observer and Sub-solar points in main window to those o' +
      'f this image -- image will be seen from original viewpoint, but ' +
      'will probably be rotated and/or enlarged/compressed'
    Caption = 'Sun and observer angles'
    TabOrder = 19
    OnKeyDown = OverwriteGeometry_RadioButtonKeyDown
  end
  object OverwriteDateTime_RadioButton: TRadioButton
    Left = 680
    Top = 638
    Width = 121
    Height = 17
    Hint = 
      'Replaces date, time and observer location in the main window wit' +
      'h those of this image and recomputes Sub-observer and Sub-solar ' +
      'points based on them'
    Caption = 'Date/Time/Location'
    TabOrder = 20
    OnKeyDown = OverwriteDateTime_RadioButtonKeyDown
  end
  object OverwriteAll_RadioButton: TRadioButton
    Left = 528
    Top = 661
    Width = 209
    Height = 17
    Hint = 
      'Replaces date, time, location, and in addition, selects cartogra' +
      'phic display mode with zoom and optional rotation angle set to m' +
      'atch original image'
    Caption = 'Display at original scale and orientation'
    TabOrder = 21
    OnKeyDown = OverwriteAll_RadioButtonKeyDown
  end
  inline TargetLon_LabeledNumericEdit: TLabeledNumericEdit
    Left = 286
    Top = 52
    Width = 99
    Height = 21
    Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
    AutoSize = True
    TabOrder = 4
    inherited Item_Label: TLabel
      Width = 21
      Caption = 'Lon:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 65
      Text = '0.000'
      OnKeyDown = TargetLon_LabeledNumericEditNumericEditKeyDown
    end
  end
  inline TargetLat_LabeledNumericEdit: TLabeledNumericEdit
    Left = 398
    Top = 52
    Width = 99
    Height = 21
    Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
    AutoSize = True
    TabOrder = 5
    inherited Item_Label: TLabel
      Width = 18
      Caption = 'Lat:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 65
      Text = '0.000'
      OnKeyDown = TargetLat_LabeledNumericEditNumericEditKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  object ListPhotos_Button: TButton
    Left = 16
    Top = 48
    Width = 73
    Height = 25
    Hint = 'List photos in current file (applying filter if requested)'
    Caption = 'List Photos'
    TabOrder = 1
    OnClick = ListPhotos_ButtonClick
    OnKeyDown = ListPhotos_ButtonKeyDown
  end
  object FilterPhotos_CheckBox: TCheckBox
    Left = 200
    Top = 52
    Width = 73
    Height = 17
    Hint = 
      'Show only photos including feature at specified lon/lat next tim' +
      'e you click "List Photos"'
    Caption = 'Filter List'
    TabOrder = 3
    OnClick = FilterPhotos_CheckBoxClick
    OnKeyDown = FilterPhotos_CheckBoxKeyDown
  end
  object ChangeFile_Button: TButton
    Left = 8
    Top = 0
    Width = 57
    Height = 25
    Hint = 'Choose a different file to search for calibrated photos'
    Caption = 'Change'
    TabOrder = 0
    OnClick = ChangeFile_ButtonClick
    OnKeyDown = ChangeFile_ButtonKeyDown
  end
  object Sort_CheckBox: TCheckBox
    Left = 112
    Top = 52
    Width = 57
    Height = 17
    Hint = 
      'If checked, entries in box will be "alphabetical" next time you ' +
      'click "List Photos"'
    Caption = 'Sort'
    TabOrder = 2
  end
  object SunAngleOnly_RadioButton: TRadioButton
    Left = 680
    Top = 616
    Width = 73
    Height = 17
    Hint = 
      'Overwrite sub-solar point coordinates only -- selected image wil' +
      'l be remapped into current main window geometry, but sun angles ' +
      'and shadow length measurements will be correct'
    Caption = 'Sun angle'
    Checked = True
    TabOrder = 22
    TabStop = True
  end
  object OpenDialog1: TOpenDialog
    Left = 184
  end
end
