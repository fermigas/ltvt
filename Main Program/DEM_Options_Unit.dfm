object DEM_Options_Form: TDEM_Options_Form
  Left = 187
  Top = 115
  Width = 724
  Height = 370
  ActiveControl = Cancel_Button
  Caption = 'DEM Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 184
    Top = 104
    Width = 90
    Height = 13
    Caption = 'Cast shadow color:'
  end
  object Label4: TLabel
    Left = 176
    Top = 64
    Width = 92
    Height = 13
    Caption = 'for slope evaluation'
  end
  object DEMFilename_Label: TLabel
    Left = 100
    Top = 20
    Width = 589
    Height = 13
    Hint = 'Choose a new file by clicking button at left'
    AutoSize = False
    Caption = 'DEMFilename_Label'
  end
  object Label1: TLabel
    Left = 488
    Top = 160
    Width = 101
    Height = 13
    Caption = 'Undefined intensities:'
  end
  inline MultipliedDemGammaBoost_LabeledNumericEdit: TLabeledNumericEdit
    Left = 40
    Top = 160
    Width = 139
    Height = 21
    Hint = 'Increase overall image gamma by this factor'
    AutoSize = True
    TabOrder = 6
    inherited Item_Label: TLabel
      Width = 81
      Caption = 'Boost gamma by:'
    end
    inherited Units_Label: TLabel
      Left = 136
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 88
      Width = 41
      Hint = 'The gamma in the main screen will be multiplied by this number'
      Text = '1.0'
      OnKeyDown = FormKeyDown
    end
  end
  object DisplayComputationTimes_CheckBox: TCheckBox
    Left = 320
    Top = 192
    Width = 153
    Height = 17
    Hint = 'Show how long it takes to load DEM and compute simulations'
    Caption = 'Display computation times'
    TabOrder = 9
    OnKeyDown = FormKeyDown
  end
  object OK_Button: TButton
    Left = 304
    Top = 280
    Width = 49
    Height = 25
    Hint = 'Close form and make changes'
    Caption = 'OK'
    TabOrder = 15
    OnClick = OK_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Cancel_Button: TButton
    Left = 368
    Top = 280
    Width = 65
    Height = 25
    Hint = 'Close form without making any changes'
    Caption = 'Cancel'
    TabOrder = 16
    OnClick = Cancel_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object ComputeCastShadows_CheckBox: TCheckBox
    Left = 16
    Top = 104
    Width = 137
    Height = 17
    Hint = 
      'Determine, at each pixel, if the Sun is blocked by a distant fea' +
      'ture'
    Caption = 'Compute cast shadows'
    TabOrder = 2
    OnKeyDown = FormKeyDown
  end
  object CastShadow_ColorBox: TColorBox
    Left = 280
    Top = 104
    Width = 97
    Height = 22
    Hint = 
      'Color for shadowed areas tipped strongly enough to be in sunligh' +
      't if not blocked by an intervening feature (normally black)'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 3
    OnKeyDown = FormKeyDown
  end
  object Save_Button: TButton
    Left = 8
    Top = 281
    Width = 89
    Height = 25
    Hint = 'Save these settings as the new defaults'
    Caption = 'Save as Default'
    TabOrder = 13
    OnClick = Save_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object Restore_Button: TButton
    Left = 104
    Top = 281
    Width = 89
    Height = 25
    Hint = 'Restore the last saved settings'
    Caption = 'Restore Defaults'
    TabOrder = 14
    OnClick = Restore_ButtonClick
    OnKeyDown = FormKeyDown
  end
  inline GridStepMultiplier_LabeledNumericEdit: TLabeledNumericEdit
    Left = 16
    Top = 64
    Width = 155
    Height = 21
    Hint = 'Number of DEM grid steps over which local slope is evaluated'
    AutoSize = True
    TabOrder = 1
    inherited Item_Label: TLabel
      Width = 88
      Caption = 'Grid step multiplier:'
    end
    inherited Units_Label: TLabel
      Left = 152
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 96
      Hint = 
        'Slopes will be evaluated, and shadow points searched for, using ' +
        'this number of grid steps in the DEM'
      Text = '1.0'
      OnKeyDown = FormKeyDown
    end
  end
  object MultiplyByAlbedoCheckBox: TCheckBox
    Left = 16
    Top = 136
    Width = 145
    Height = 17
    Hint = 
      'Texture 3 can be used for an albedo map; its intensities will be' +
      ' multiplied by that computed from the DEM'
    Caption = 'Multiply by last texture'
    TabOrder = 5
    OnClick = MultiplyByAlbedoCheckBoxClick
    OnKeyDown = FormKeyDown
  end
  object RecalculateDEMonRecenter_CheckBox: TCheckBox
    Left = 16
    Top = 224
    Width = 233
    Height = 17
    Hint = 
      'If not rechecked, reverts to Texture mode when one clicks on the' +
      ' image to recenter it'
    Caption = 'Stay in DEM mode when image refreshed'
    TabOrder = 11
    OnKeyDown = FormKeyDown
  end
  object DrawTerminatorOnDEM_CheckBox: TCheckBox
    Left = 16
    Top = 192
    Width = 169
    Height = 17
    Hint = 
      'Check to include lines on DEM rendering; otherwise they are not ' +
      'drawn'
    Caption = 'Draw red-blue terminator lines'
    TabOrder = 8
    OnKeyDown = FormKeyDown
  end
  object ChangeDEM_Button: TButton
    Left = 16
    Top = 16
    Width = 73
    Height = 25
    Hint = 'Change file used for digital heights/topography'
    Caption = 'DEM file'
    TabOrder = 0
    OnClick = ChangeDEM_ButtonClick
    OnKeyDown = FormKeyDown
  end
  object PhotometricModel_GroupBox: TGroupBox
    Left = 472
    Top = 56
    Width = 153
    Height = 81
    Hint = 'Select way of determining brightness based on surface slope'
    Caption = 'Photometric Model'
    TabOrder = 4
    object Lambertian_RadioButton: TRadioButton
      Left = 16
      Top = 18
      Width = 113
      Height = 17
      Hint = 
        'Brightness depends on angle at which Sun strikes surface; indepe' +
        'ndent of tilt of surface relative to observer'
      Caption = 'Lambertian'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnKeyDown = FormKeyDown
    end
    object LommelSeeliger_RadioButton: TRadioButton
      Left = 16
      Top = 38
      Width = 113
      Height = 17
      Hint = 
        'Brightness depends on tilt of surface relative to Sun and observ' +
        'er; variations vanish at Full Moon phase'
      Caption = 'Lommel-Seeliger'
      TabOrder = 1
      OnKeyDown = FormKeyDown
    end
    object LunarLambert_RadioButton: TRadioButton
      Left = 16
      Top = 56
      Width = 113
      Height = 17
      Hint = 
        'Combination of Lommel-Seeliger at Full Moon and Lambertian at mo' +
        're distant phases'
      Caption = 'Lunar-Lambert'
      TabOrder = 2
      OnKeyDown = FormKeyDown
    end
  end
  object LommelSeeligerNoDataColor_ColorBox: TColorBox
    Left = 544
    Top = 184
    Width = 97
    Height = 22
    Hint = 
      'Color used for pixels with indeterminant intensities in Lommel-S' +
      'eeliger and Lunar-Lambert models'
    Selected = clWhite
    Style = [cbStandardColors, cbExtendedColors, cbCustomColor, cbPrettyNames]
    ItemHeight = 16
    TabOrder = 10
    OnKeyDown = FormKeyDown
  end
  object ShowDemInfo_CheckBox: TCheckBox
    Left = 320
    Top = 224
    Width = 169
    Height = 17
    Hint = 
      'On first loading, display pop-up box with detailed information a' +
      'bout DEM'
    Caption = 'Show DEM file info on opening'
    TabOrder = 12
    OnKeyDown = FormKeyDown
  end
  inline MultipliedDemIntensitiesBoost_LabeledNumericEdit: TLabeledNumericEdit
    Left = 200
    Top = 160
    Width = 155
    Height = 21
    Hint = 
      'Multiply computed DEM instensities (normally 0..1) by this facto' +
      'r'
    AutoSize = True
    TabOrder = 7
    inherited Item_Label: TLabel
      Width = 93
      Caption = 'Boost intensities by:'
    end
    inherited Units_Label: TLabel
      Left = 152
      Width = 3
      Caption = ''
    end
    inherited NumericEdit: TNumericEdit
      Left = 104
      Width = 41
      Hint = 'DEM intensities will be multiplied by this number'
      Text = '1.0'
      OnKeyDown = FormKeyDown
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 632
    Top = 8
  end
end
