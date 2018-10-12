object CalibratedPhotoLoader_Form: TCalibratedPhotoLoader_Form
  Left = 46
  Top = 9
  Width = 942
  Height = 726
  Caption = 'Calibrated Photo Selector  v0.9'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Thumbnail_Image: TImage
    Left = 640
    Top = 48
    Width = 265
    Height = 153
    Hint = 'This is a preview of the currently selected image'
    IncrementalDisplay = True
    Proportional = True
  end
  object Label2: TLabel
    Left = 663
    Top = 336
    Width = 207
    Height = 13
    Caption = '-------------------    Calibration Points  -----------------'
  end
  object DateTime_Label: TLabel
    Left = 640
    Top = 208
    Width = 78
    Height = 13
    Hint = 'Universal date and time from calibration data file'
    Caption = 'DateTime_Label'
  end
  object ObsLocation_Label: TLabel
    Left = 640
    Top = 232
    Width = 92
    Height = 13
    Hint = 'Location from which photo was taken (per calibration data file)'
    Caption = 'ObsLocation_Label'
  end
  object SubObsPt_Label: TLabel
    Left = 640
    Top = 280
    Width = 80
    Height = 13
    Hint = 
      'Selenographic longitude/latitude of center point on Moon calcula' +
      'ted from preceding data (also called librations)'
    Caption = 'SubObsPt_Label'
  end
  object SubSolPt_Label: TLabel
    Left = 640
    Top = 304
    Width = 76
    Height = 13
    Hint = 
      'Selenographic longitude/latitude of point on Moon directly benea' +
      'th Sun (calculated from preceding data)'
    Caption = 'SubSolPt_Label'
  end
  object PhotoSize_Label: TLabel
    Left = 640
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
    Left = 640
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
  object PhotoListHeaders_Label: TLabel
    Left = 16
    Top = 80
    Width = 116
    Height = 13
    Hint = 'Identity of columns in list box'
    Caption = 'PhotoListHeaders_Label'
  end
  object FeaturePos_Part1_Label: TLabel
    Left = 264
    Top = 80
    Width = 117
    Height = 13
    Hint = 'Sun angle in main window'
    Caption = 'FeaturePos_Part1_Label'
  end
  object Overlay_Image: TImage
    Left = 640
    Top = 48
    Width = 265
    Height = 153
    Hint = 'This is a preview of the currently selected image'
    IncrementalDisplay = True
    Proportional = True
    Transparent = True
  end
  object FeaturePos_Part2_Label: TLabel
    Left = 464
    Top = 80
    Width = 86
    Height = 13
    Hint = 
      'Where feature is in requested photo as fraction of width (from l' +
      'eft) and height (from top)'
    Caption = 'FeaturePos_Label'
  end
  object ListBox1: TListBox
    Left = 16
    Top = 96
    Width = 609
    Height = 585
    Hint = 'Click on a photo name or use keyboard to move through list'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'QuickType Mono'
    Font.Pitch = fpFixed
    Font.Style = []
    ItemHeight = 12
    ParentFont = False
    TabOrder = 8
    OnClick = ListBox1Click
    OnKeyDown = ListBox1KeyDown
  end
  object SelectPhoto_Button: TButton
    Left = 648
    Top = 552
    Width = 65
    Height = 25
    Hint = 'Click to select highlighted photo and close form'
    Caption = 'Select'
    TabOrder = 20
    OnClick = SelectPhoto_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Cancel_Button: TButton
    Left = 816
    Top = 552
    Width = 57
    Height = 25
    Hint = 'Close form without selecting a photo'
    Caption = 'Cancel'
    TabOrder = 21
    OnClick = Cancel_ButtonClick
    OnKeyDown = FormKeyDown
  end
  inline X1_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 776
    Top = 368
    Width = 107
    Height = 21
    Hint = 
      'Horizontal position of point in image (in pixels measured left t' +
      'o right)'
    AutoSize = True
    TabOrder = 11
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
      OnKeyDown = FormKeyDown
      InputType = tInteger
    end
  end
  inline Y1_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 776
    Top = 392
    Width = 107
    Height = 21
    Hint = 
      'Vertical position of point in image (in pixels measured top to b' +
      'ottom)'
    AutoSize = True
    TabOrder = 12
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
      OnKeyDown = FormKeyDown
      InputType = tInteger
    end
  end
  inline Lon1_LabeledNumericEdit: TLabeledNumericEdit
    Left = 638
    Top = 368
    Width = 99
    Height = 21
    Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
    AutoSize = True
    TabOrder = 9
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
      OnKeyDown = FormKeyDown
    end
  end
  inline Lat1_LabeledNumericEdit: TLabeledNumericEdit
    Left = 638
    Top = 392
    Width = 99
    Height = 21
    Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
    AutoSize = True
    TabOrder = 10
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
      OnKeyDown = FormKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  inline InversionCode_LabeledNumericEdit: TLabeledNumericEdit
    Left = 808
    Top = 504
    Width = 99
    Height = 21
    Hint = 
      '+1 indicates a normal image; -1 indicates the disk file is a mir' +
      'ror image of the naked eye Moon'
    AutoSize = True
    TabOrder = 19
    inherited Item_Label: TLabel
      Width = 56
      Caption = 'Mirror code:'
    end
    inherited Units_Label: TLabel
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 64
      Width = 33
      OnKeyDown = FormKeyDown
      InputType = tInteger
    end
  end
  inline X2_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 776
    Top = 440
    Width = 107
    Height = 21
    Hint = 
      'Horizontal position of point in image (in pixels measured left t' +
      'o right)'
    AutoSize = True
    TabOrder = 15
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
      OnKeyDown = FormKeyDown
      InputType = tInteger
    end
  end
  inline Y2_Pix_LabeledNumericEdit: TLabeledNumericEdit
    Left = 776
    Top = 464
    Width = 107
    Height = 21
    Hint = 
      'Vertical position of point in image (in pixels measured top to b' +
      'ottom)'
    AutoSize = True
    TabOrder = 16
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
      InputType = tInteger
    end
  end
  inline Lon2_LabeledNumericEdit: TLabeledNumericEdit
    Left = 638
    Top = 440
    Width = 99
    Height = 21
    Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
    AutoSize = True
    TabOrder = 13
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
      OnKeyDown = FormKeyDown
    end
  end
  inline Lat2_LabeledNumericEdit: TLabeledNumericEdit
    Left = 638
    Top = 464
    Width = 99
    Height = 21
    Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
    AutoSize = True
    TabOrder = 14
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
      OnKeyDown = FormKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  object OverwriteNone_RadioButton: TRadioButton
    Left = 640
    Top = 592
    Width = 249
    Height = 17
    Hint = 
      'The selected photo will be re-mapped into the geometry of the cu' +
      'rrent view in the main window (note: sun angle readouts and shad' +
      'ow lengths will NOT be valid)'
    Caption = 'Load without altering main window parameters'
    TabOrder = 22
    OnKeyDown = FormKeyDown
  end
  object OverwriteGeometry_RadioButton: TRadioButton
    Left = 632
    Top = 638
    Width = 145
    Height = 17
    Hint = 
      'Sets Sub-observer and Sub-solar points in main window to those o' +
      'f this image -- image will be seen from original viewpoint, but ' +
      'will probably be rotated and/or enlarged/compressed'
    Caption = 'Sun and observer angles'
    TabOrder = 24
    OnKeyDown = FormKeyDown
  end
  object OverwriteDateTime_RadioButton: TRadioButton
    Left = 784
    Top = 638
    Width = 121
    Height = 17
    Hint = 
      'Replaces date, time and observer location in the main window wit' +
      'h those of this image and recomputes Sub-observer and Sub-solar ' +
      'points based on them'
    Caption = 'Date/Time/Location'
    TabOrder = 25
    OnKeyDown = FormKeyDown
  end
  object OverwriteAll_RadioButton: TRadioButton
    Left = 632
    Top = 661
    Width = 209
    Height = 17
    Hint = 
      'Replaces date, time, location, and in addition, selects cartogra' +
      'phic display mode with zoom and optional rotation angle set to m' +
      'atch original image'
    Caption = 'Display at original scale and orientation'
    TabOrder = 26
    OnKeyDown = FormKeyDown
  end
  inline TargetLat_LabeledNumericEdit: TLabeledNumericEdit
    Left = 438
    Top = 53
    Width = 99
    Height = 21
    Hint = 'Selenographic latitude in decimal degrees (N=+  S=-)'
    AutoSize = True
    TabOrder = 6
    inherited Units_Label: TLabel [0]
      Left = 96
      Width = 3
      Caption = ''
    end
    inherited Item_Label: TLabel [1]
      Width = 18
      Caption = 'Lat:'
    end
    inherited NumericEdit: TNumericEdit
      Left = 32
      Width = 41
      Text = '0.000'
      OnKeyDown = FormKeyDown
      InputMin = '-90'
      InputMax = '90'
    end
  end
  object ListPhotos_Button: TButton
    Left = 16
    Top = 48
    Width = 73
    Height = 25
    Hint = 'Click to refresh list if any options have been changed'
    Caption = 'List Photos'
    TabOrder = 1
    OnClick = ListPhotos_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object FilterPhotos_CheckBox: TCheckBox
    Left = 264
    Top = 53
    Width = 65
    Height = 17
    Hint = 
      'Show only photos including feature at specified lon/lat; display' +
      ' and sort by solar altitude unless "colongitude" is checked'
    Caption = 'Filter List'
    TabOrder = 4
    OnClick = FilterPhotos_CheckBoxClick
    OnKeyDown = FormKeyDown
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
    OnKeyDown = FormKeyDown
  end
  object Sort_CheckBox: TCheckBox
    Left = 104
    Top = 53
    Width = 41
    Height = 17
    Hint = 
      'If checked, entries in box will be "alphabetical" next time you ' +
      'click "List Photos"'
    Caption = 'Sort'
    TabOrder = 2
    OnKeyDown = FormKeyDown
  end
  object SunAngleOnly_RadioButton: TRadioButton
    Left = 784
    Top = 616
    Width = 73
    Height = 17
    Hint = 
      'Overwrite sub-solar point coordinates only -- selected image wil' +
      'l be remapped into current main window geometry, but sun angles ' +
      'and shadow length measurements will be correct'
    Caption = 'Sun angle'
    Checked = True
    TabOrder = 23
    TabStop = True
    OnKeyDown = FormKeyDown
  end
  object ListLibrations_CheckBox: TCheckBox
    Left = 536
    Top = 53
    Width = 81
    Height = 17
    Hint = 
      'List the longitude and latitude of the Sub-Observer point of eac' +
      'h photo in selection list'
    Caption = 'List librations'
    TabOrder = 7
    OnKeyDown = FormKeyDown
  end
  inline TargetLon_LabeledNumericEdit: TLabeledNumericEdit
    Left = 334
    Top = 53
    Width = 99
    Height = 21
    Hint = 'Selenographic longitude in decimal degrees (E=+  W=-)'
    AutoSize = True
    TabOrder = 5
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
      Width = 49
      Text = '0.000'
      OnKeyDown = FormKeyDown
    end
  end
  object CopyInfo_Button: TButton
    Left = 648
    Top = 504
    Width = 59
    Height = 25
    Hint = 'Copy selected photo information to clipboard'
    Caption = 'Copy Info'
    TabOrder = 17
    OnClick = CopyInfo_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Colongitude_CheckBox: TCheckBox
    Left = 160
    Top = 53
    Width = 97
    Height = 17
    Hint = 'Display and sort by colongitude'
    Caption = 'By colongitude'
    TabOrder = 3
    OnKeyDown = FormKeyDown
  end
  object ShowNote_Button: TButton
    Left = 736
    Top = 504
    Width = 49
    Height = 25
    Hint = 'Display note found in data file'
    Caption = 'Note'
    TabOrder = 18
    OnClick = ShowNote_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object OpenDialog1: TOpenDialog
    Left = 184
  end
end
