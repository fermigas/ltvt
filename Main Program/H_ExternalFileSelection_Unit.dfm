object ExternalFileSelection_Form: TExternalFileSelection_Form
  Left = 134
  Top = 2
  Width = 777
  Height = 724
  Caption = 'LTVT External File Selector'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OK_Button: TButton
    Left = 592
    Top = 648
    Width = 49
    Height = 25
    Hint = 'Exit form setting file names as shown'
    Caption = 'OK'
    TabOrder = 4
    OnClick = OK_ButtonClick
    OnKeyDown = OK_ButtonKeyDown
  end
  object Cancel_Button: TButton
    Left = 656
    Top = 648
    Width = 59
    Height = 25
    Hint = 'Exit form without saving changes'
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = Cancel_ButtonClick
    OnKeyDown = Cancel_ButtonKeyDown
  end
  object Textures_GroupBox: TGroupBox
    Left = 8
    Top = 8
    Width = 721
    Height = 329
    Caption = 'Textures'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Texture1Filename_Label: TLabel
      Left = 128
      Top = 80
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking "Change"'
      AutoSize = False
      Caption = 'Texture1Filename_Label'
    end
    object Texture2Filename_Label: TLabel
      Left = 128
      Top = 144
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking "Change"'
      AutoSize = False
      Caption = 'Texture2Filename_Label'
    end
    object Texture3Filename_Label: TLabel
      Left = 128
      Top = 209
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking "Change"'
      AutoSize = False
      Caption = 'Texture3Filename_Label'
    end
    object Label9: TLabel
      Left = 96
      Top = 176
      Width = 62
      Height = 13
      Caption = 'Description:  '
    end
    object Label8: TLabel
      Left = 8
      Top = 176
      Width = 55
      Height = 13
      Hint = 
        'Texture 1 file will be used when you ask for a Texture map with ' +
        'the first radio button selected on the main form'
      Caption = 'Texture 3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 96
      Top = 144
      Width = 19
      Height = 13
      Caption = 'File:'
    end
    object Label5: TLabel
      Left = 96
      Top = 112
      Width = 62
      Height = 13
      Caption = 'Description:  '
    end
    object Label4: TLabel
      Left = 8
      Top = 112
      Width = 55
      Height = 13
      Hint = 
        'Texture 1 file will be used when you ask for a Texture map with ' +
        'the first radio button selected on the main form'
      Caption = 'Texture 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 96
      Top = 80
      Width = 19
      Height = 13
      Caption = 'File:'
    end
    object Label2: TLabel
      Left = 96
      Top = 48
      Width = 62
      Height = 13
      Caption = 'Description:  '
    end
    object Label11: TLabel
      Left = 96
      Top = 209
      Width = 19
      Height = 13
      Caption = 'File:'
    end
    object Label1: TLabel
      Left = 8
      Top = 48
      Width = 55
      Height = 13
      Hint = 
        'Texture 1 file will be used when you ask for a Texture map with ' +
        'the first radio button selected on the main form'
      Caption = 'Texture 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 272
      Width = 78
      Height = 13
      Hint = 
        'Texture 1 file will be used when you ask for a Texture map with ' +
        'the first radio button selected on the main form'
      Caption = 'Earth Texture'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 96
      Top = 300
      Width = 19
      Height = 13
      Caption = 'File:'
    end
    object EarthTextureFilename_Label: TLabel
      Left = 128
      Top = 300
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking "Change"'
      AutoSize = False
      Caption = 'EarthTextureFilename_Label'
    end
    object Texture1Description_Edit: TEdit
      Left = 168
      Top = 48
      Width = 225
      Height = 19
      Hint = 'Enter text you want to appear next to radio button on main form'
      TabOrder = 3
      Text = 'Texture1Description_Edit'
      OnKeyDown = Texture1Description_EditKeyDown
    end
    object Texture2Description_Edit: TEdit
      Left = 168
      Top = 112
      Width = 225
      Height = 19
      Hint = 'Enter text you want to appear next to radio button on main form'
      TabOrder = 5
      Text = 'Texture2Description_Edit'
      OnKeyDown = Texture2Description_EditKeyDown
    end
    object Texture3Description_Edit: TEdit
      Left = 168
      Top = 176
      Width = 225
      Height = 19
      Hint = 'Enter text you want to appear next to radio button on main form'
      TabOrder = 7
      Text = 'Texture3Description_Edit'
      OnKeyDown = Texture3Description_EditKeyDown
    end
    object ChangeTexture3_Button: TButton
      Left = 24
      Top = 200
      Width = 57
      Height = 25
      Hint = 
        'Associate a new reference map with the third simulation texture ' +
        'radio button'
      Caption = 'Change'
      TabOrder = 6
      OnClick = ChangeTexture3_ButtonClick
      OnKeyDown = ChangeTexture3_ButtonKeyDown
    end
    object ChangeTexture2_Button: TButton
      Left = 24
      Top = 136
      Width = 57
      Height = 25
      Hint = 
        'Associate a new reference map with the second simulation texture' +
        ' radio button'
      Caption = 'Change'
      TabOrder = 4
      OnClick = ChangeTexture2_ButtonClick
      OnKeyDown = ChangeTexture2_ButtonKeyDown
    end
    object ChangeTexture1_Button: TButton
      Left = 24
      Top = 72
      Width = 57
      Height = 25
      Hint = 
        'Associate a new reference map with the first simulation texture ' +
        'radio button'
      Caption = 'Change'
      TabOrder = 2
      OnClick = ChangeTexture1_ButtonClick
      OnKeyDown = ChangeTexture1_ButtonKeyDown
    end
    object GraphicalBrowser_CheckBox: TCheckBox
      Left = 24
      Top = 16
      Width = 137
      Height = 17
      Hint = 
        'Use file opening dialog with preview thumbnail image -- may be s' +
        'low for large files!'
      Caption = 'Use graphic file browser'
      TabOrder = 0
      OnKeyDown = GraphicalBrowser_CheckBoxKeyDown
    end
    object WineCompatibility_CheckBox: TCheckBox
      Left = 200
      Top = 16
      Width = 377
      Height = 17
      Hint = 'Try this if you are unable to see texture simulations'
      Caption = 
        'Load textures using Windows-emulator compatible rendering method' +
        's'
      TabOrder = 1
      OnKeyDown = WineCompatibility_CheckBoxKeyDown
    end
    inline Tex3MinLon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 32
      Top = 240
      Width = 130
      Height = 19
      Hint = 'Enter lunar longitude along left margin of Texture 3 map'
      AutoSize = True
      TabOrder = 8
      inherited Item_Label: TLabel
        Width = 48
        Caption = 'Left. Lon.:'
      end
      inherited Units_Label: TLabel
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Height = 19
        Text = '-180'
        OnKeyDown = Tex3MinLon_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline Tex3MaxLon_LabeledNumericEdit: TLabeledNumericEdit
      Left = 192
      Top = 240
      Width = 138
      Height = 19
      Hint = 'Enter lunar longitude along right margin of Texture 3 map'
      AutoSize = True
      TabOrder = 9
      inherited Item_Label: TLabel
        Width = 55
        Caption = 'Right. Lon.:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Height = 19
        Text = '180'
        OnKeyDown = Tex3MaxLon_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline Tex3MinLat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 544
      Top = 240
      Width = 138
      Height = 19
      Hint = 'Enter lunar laitude along bottom margin of Texture 3 map'
      AutoSize = True
      TabOrder = 10
      inherited Item_Label: TLabel
        Width = 57
        Caption = 'Bottom Lat.:'
      end
      inherited Units_Label: TLabel
        Left = 120
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Left = 64
        Height = 19
        Text = '-90'
        OnKeyDown = Tex3MinLat_LabeledNumericEditNumericEditKeyDown
      end
    end
    inline Tex3MaxLat_LabeledNumericEdit: TLabeledNumericEdit
      Left = 384
      Top = 240
      Width = 130
      Height = 19
      Hint = 'Enter lunar laitude along bottom margin of Texture 3 map'
      AutoSize = True
      TabOrder = 11
      inherited Item_Label: TLabel
        Width = 43
        Caption = 'Top Lat.:'
      end
      inherited Units_Label: TLabel
        Width = 18
        Caption = 'deg'
      end
      inherited NumericEdit: TNumericEdit
        Height = 19
        Text = '90'
        OnKeyDown = Tex3MaxLat_LabeledNumericEditNumericEditKeyDown
      end
    end
    object ChangeEarthTexture_Button: TButton
      Left = 24
      Top = 294
      Width = 57
      Height = 25
      Hint = 
        'Choose a new texture map for drawing the Earth as viewed from th' +
        'e Moon'
      Caption = 'Change'
      TabOrder = 12
      OnClick = ChangeEarthTexture_ButtonClick
      OnKeyDown = ChangeEarthTexture_ButtonKeyDown
    end
  end
  object Others_GroupBox: TGroupBox
    Left = 8
    Top = 352
    Width = 721
    Height = 281
    Caption = 'Other External Files'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object EphemerisFilename_Label: TLabel
      Left = 120
      Top = 196
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking button at left'
      AutoSize = False
      Caption = 'EphemerisFilename_Label'
    end
    object DotFilename_Label: TLabel
      Left = 120
      Top = 36
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking button at left'
      AutoSize = False
      Caption = 'DotFilename_Label'
    end
    object TAIFilename_Label: TLabel
      Left = 120
      Top = 236
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking button at left'
      AutoSize = False
      Caption = 'TAIFilename_Label'
    end
    object PhotoSessionsFilename_Label: TLabel
      Left = 120
      Top = 76
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking button at left'
      AutoSize = False
      Caption = 'PhotoSessionsFilename_Label'
    end
    object CalibratedPhotosFilename_Label: TLabel
      Left = 120
      Top = 116
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking button at left'
      AutoSize = False
      Caption = 'CalibratedPhotosFilename_Label'
    end
    object ObservatoryListFilename_Label: TLabel
      Left = 120
      Top = 156
      Width = 585
      Height = 13
      Hint = 'Choose a new file by clicking button at left'
      AutoSize = False
      Caption = 'ObservatoryListFilename_Label'
    end
    object ChangeEphemerisFile_Button: TButton
      Left = 24
      Top = 192
      Width = 89
      Height = 25
      Hint = 
        'Change ephemeris file -- JPL files covering other dates will be ' +
        'automatically accessed if they are in the same directory as this' +
        ' one'
      Caption = 'JPL Ephemeris'
      TabOrder = 4
      OnClick = ChangeEphemerisFile_ButtonClick
      OnKeyDown = ChangeEphemerisFile_ButtonKeyDown
    end
    object ChangeDotFile_Button: TButton
      Left = 24
      Top = 32
      Width = 89
      Height = 25
      Hint = 
        'Change file with coordinates and descriptions of dots -- differe' +
        'nt files allow display of Named Lunar Features, Unified Control ' +
        'Network, Clementine Altimeter points, etc.'
      Caption = 'Dots/Names'
      TabOrder = 0
      OnClick = ChangeDotFile_ButtonClick
      OnKeyDown = ChangeDotFile_ButtonKeyDown
    end
    object ChangeTAIFile_Button: TButton
      Left = 24
      Top = 232
      Width = 89
      Height = 25
      Hint = 
        'Change TAI Offsets file -- this optional file is used for conver' +
        'ting UTC to ephemeris time -- if no file is specified a fixed of' +
        'fset of 65.184 sec will be used'
      Caption = 'TAI Offsets'
      TabOrder = 5
      OnClick = ChangeTAIFile_ButtonClick
      OnKeyDown = ChangeTAIFile_ButtonKeyDown
    end
    object PhotoSessionsFile_Button: TButton
      Left = 24
      Top = 72
      Width = 89
      Height = 25
      Hint = 
        'Change photo sessions search file -- this file is read by the Se' +
        'arch for Photos button in the main window'
      Caption = 'Photo Search'
      TabOrder = 1
      OnClick = PhotoSessionsFile_ButtonClick
      OnKeyDown = PhotoSessionsFile_ButtonKeyDown
    end
    object CalibratedPhotos_Button: TButton
      Left = 24
      Top = 112
      Width = 89
      Height = 25
      Hint = 
        'Change file used for read/writing data related to the Tools...Ca' +
        'librate a Photo and Load a Calibrated Photo functions'
      Caption = 'Calibrated Photos'
      TabOrder = 2
      OnClick = CalibratedPhotos_ButtonClick
      OnKeyDown = CalibratedPhotos_ButtonKeyDown
    end
    object ObservatoryList_Button: TButton
      Left = 24
      Top = 152
      Width = 89
      Height = 25
      Hint = 
        'Change file with list of observer locations -- if this file exis' +
        'ts, a drop-down list of the locations will appear in the Set Loc' +
        'ation menu'
      Caption = 'Obs. Locations'
      TabOrder = 3
      OnClick = ObservatoryList_ButtonClick
      OnKeyDown = ObservatoryList_ButtonKeyDown
    end
  end
  object Save_Button: TButton
    Left = 24
    Top = 649
    Width = 89
    Height = 25
    Hint = 'Save these settings as the new defaults'
    Caption = 'Save as Default'
    TabOrder = 2
    OnClick = Save_ButtonClick
    OnKeyDown = Save_ButtonKeyDown
  end
  object Restore_Button: TButton
    Left = 120
    Top = 649
    Width = 89
    Height = 25
    Hint = 'Restore the last saved settings'
    Caption = 'Restore Defaults'
    TabOrder = 3
    OnClick = Restore_ButtonClick
    OnKeyDown = Restore_ButtonKeyDown
  end
  object OpenDialog1: TOpenDialog
    Left = 632
    Top = 8
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 672
    Top = 8
  end
end
