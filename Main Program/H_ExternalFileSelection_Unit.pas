unit H_ExternalFileSelection_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, ExtDlgs, LabeledNumericEdit;

type
  TExternalFileSelection_Form = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Texture1Description_Edit: TEdit;
    Texture1Filename_Label: TLabel;
    Label3: TLabel;
    ChangeTexture1_Button: TButton;
    OK_Button: TButton;
    Cancel_Button: TButton;
    OpenDialog1: TOpenDialog;
    OpenPictureDialog1: TOpenPictureDialog;
    GraphicalBrowser_CheckBox: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    Texture2Description_Edit: TEdit;
    Texture2Filename_Label: TLabel;
    Label7: TLabel;
    ChangeTexture2_Button: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Texture3Description_Edit: TEdit;
    Texture3Filename_Label: TLabel;
    Label11: TLabel;
    ChangeTexture3_Button: TButton;
    Textures_GroupBox: TGroupBox;
    Others_GroupBox: TGroupBox;
    ChangeEphemerisFile_Button: TButton;
    EphemerisFilename_Label: TLabel;
    ChangeDotFile_Button: TButton;
    ChangeTAIFile_Button: TButton;
    DotFilename_Label: TLabel;
    TAIFilename_Label: TLabel;
    PhotoSessionsFile_Button: TButton;
    PhotoSessionsFilename_Label: TLabel;
    Save_Button: TButton;
    Restore_Button: TButton;
    CalibratedPhotos_Button: TButton;
    CalibratedPhotosFilename_Label: TLabel;
    ObservatoryList_Button: TButton;
    ObservatoryListFilename_Label: TLabel;
    WineCompatibility_CheckBox: TCheckBox;
    Tex3MinLon_LabeledNumericEdit: TLabeledNumericEdit;
    Tex3MaxLon_LabeledNumericEdit: TLabeledNumericEdit;
    Tex3MinLat_LabeledNumericEdit: TLabeledNumericEdit;
    Tex3MaxLat_LabeledNumericEdit: TLabeledNumericEdit;
    Label6: TLabel;
    Label10: TLabel;
    EarthTextureFilename_Label: TLabel;
    ChangeEarthTexture_Button: TButton;
    Texture1Planetographic_CheckBox: TCheckBox;
    Texture2Planetographic_CheckBox: TCheckBox;
    Texture3Planetographic_CheckBox: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure OK_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure ChangeTexture1_ButtonClick(Sender: TObject);
    procedure ChangeTexture2_ButtonClick(Sender: TObject);
    procedure ChangeTexture3_ButtonClick(Sender: TObject);
    procedure ChangeDotFile_ButtonClick(Sender: TObject);
    procedure ChangeEphemerisFile_ButtonClick(Sender: TObject);
    procedure ChangeTAIFile_ButtonClick(Sender: TObject);
    procedure PhotoSessionsFile_ButtonClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Restore_ButtonClick(Sender: TObject);
    procedure CalibratedPhotos_ButtonClick(Sender: TObject);
    procedure ObservatoryList_ButtonClick(Sender: TObject);
    procedure ChangeEarthTexture_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
// Set if a change is requested
    ChangeFileNames : boolean;

    TempTexture1Name, TempTexture2Name, TempTexture3Name, TempEarthTextureName,
//    TempTex3MinLonText, TempTex3MaxLonText, TempTex3MinLatText, TempTex3MaxLatText,
    TempEphemerisFilename, TempDotFilename, TempTAIFilename,
    TempNormalPhotoSessionsFilename, TempCalibratedPhotosFilename,
    TempObservatoryListFilename : string;

    procedure RefreshLabels;

  end;

var
  ExternalFileSelection_Form: TExternalFileSelection_Form;

implementation

uses MoonPosition {Radius_a, Radius_b}, LTVT_Unit;

{$R *.dfm}

procedure TExternalFileSelection_Form.RefreshLabels;
begin
  Texture1Filename_Label.Caption := MinimizeName(TempTexture1Name,Texture1Filename_Label.Canvas,Texture1Filename_Label.Width);
  Texture2Filename_Label.Caption := MinimizeName(TempTexture2Name,Texture2Filename_Label.Canvas,Texture2Filename_Label.Width);
  Texture3Filename_Label.Caption := MinimizeName(TempTexture3Name,Texture3Filename_Label.Canvas,Texture3Filename_Label.Width);
  EarthTextureFilename_Label.Caption := MinimizeName(TempEarthTextureName,EarthTextureFilename_Label.Canvas,EarthTextureFilename_Label.Width);
  if Radius_a=Radius_b then
    begin // no flattening
      Texture1Planetographic_CheckBox.Visible := False;
      Texture2Planetographic_CheckBox.Visible := False;
      Texture3Planetographic_CheckBox.Visible := False;
    end
  else
    begin
      Texture1Planetographic_CheckBox.Visible := True;
      Texture2Planetographic_CheckBox.Visible := True;
      Texture3Planetographic_CheckBox.Visible := True;
    end;

  DotFilename_Label.Caption := MinimizeName(TempDotFilename,DotFilename_Label.Canvas,DotFilename_Label.Width);
  PhotoSessionsFilename_Label.Caption := MinimizeName(TempNormalPhotoSessionsFilename,PhotoSessionsFilename_Label.Canvas,PhotoSessionsFilename_Label.Width);
  CalibratedPhotosFilename_Label.Caption := MinimizeName(TempCalibratedPhotosFilename,CalibratedPhotosFilename_Label.Canvas,CalibratedPhotosFilename_Label.Width);
  ObservatoryListFilename_Label.Caption := MinimizeName(TempObservatoryListFilename,ObservatoryListFilename_Label.Canvas,ObservatoryListFilename_Label.Width);
  EphemerisFilename_Label.Caption := MinimizeName(TempEphemerisFilename,EphemerisFilename_Label.Canvas,EphemerisFilename_Label.Width);
  TAIFilename_Label.Caption := MinimizeName(TempTAIFilename,TAIFilename_Label.Canvas,TAIFilename_Label.Width);
end;

procedure TExternalFileSelection_Form.FormShow(Sender: TObject);
begin
  RefreshLabels;
end;

procedure TExternalFileSelection_Form.OK_ButtonClick(Sender: TObject);
begin
  ChangeFileNames := True;
  Close;
end;

procedure TExternalFileSelection_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TExternalFileSelection_Form.ChangeTexture1_ButtonClick(Sender: TObject);
begin

  if GraphicalBrowser_CheckBox.Checked then with OpenPictureDialog1 do
    begin
      Title := 'Select Texture 1 reference image';
      FileName := TempTexture1Name;
      if Execute then
        begin
          TempTexture1Name := FileName;
          Texture1Filename_Label.Caption := MinimizeName(TempTexture1Name,Texture1Filename_Label.Canvas,Texture1Filename_Label.Width);
        end;
    end
  else with OpenDialog1 do
    begin
      Title := 'Select Texture 1 reference image';
      FileName := TempTexture1Name;
      Filter := OpenPictureDialog1.Filter;
      if Execute then
        begin
          TempTexture1Name := FileName;
          Texture1Filename_Label.Caption := MinimizeName(TempTexture1Name,Texture1Filename_Label.Canvas,Texture1Filename_Label.Width);
        end;
    end;

end;

procedure TExternalFileSelection_Form.ChangeTexture2_ButtonClick(Sender: TObject);
begin

  if GraphicalBrowser_CheckBox.Checked then with OpenPictureDialog1 do
    begin
      Title := 'Select Texture 2 reference image';
      FileName := TempTexture2Name;
      if Execute then
        begin
          TempTexture2Name := FileName;
          Texture2Filename_Label.Caption := MinimizeName(TempTexture2Name,Texture2Filename_Label.Canvas,Texture2Filename_Label.Width);
        end;
    end
  else with OpenDialog1 do
    begin
      Title := 'Select Texture 2 reference image';
      FileName := TempTexture2Name;
      Filter := OpenPictureDialog1.Filter;
      if Execute then
        begin
          TempTexture2Name := FileName;
          Texture2Filename_Label.Caption := MinimizeName(TempTexture2Name,Texture2Filename_Label.Canvas,Texture2Filename_Label.Width);
        end;
    end;

end;

procedure TExternalFileSelection_Form.ChangeTexture3_ButtonClick(Sender: TObject);
begin
  if GraphicalBrowser_CheckBox.Checked then with OpenPictureDialog1 do
    begin
      Title := 'Select Texture 3 reference image';
      FileName := TempTexture3Name;
      if Execute then
        begin
          TempTexture3Name := FileName;
          Texture3Filename_Label.Caption := MinimizeName(TempTexture3Name,Texture3Filename_Label.Canvas,Texture3Filename_Label.Width);
        end;
    end
  else with OpenDialog1 do
    begin
      Title := 'Select Texture 3 reference image';
      FileName := TempTexture3Name;
      Filter := OpenPictureDialog1.Filter;
      if Execute then
        begin
          TempTexture3Name := FileName;
          Texture3Filename_Label.Caption := MinimizeName(TempTexture3Name,Texture3Filename_Label.Canvas,Texture3Filename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.ChangeEarthTexture_ButtonClick(Sender: TObject);
begin
  if GraphicalBrowser_CheckBox.Checked then with OpenPictureDialog1 do
    begin
      Title := 'Select Earth Texture reference image';
      FileName := TempEarthTextureName;
      if Execute then
        begin
          TempEarthTextureName := FileName;
          EarthTextureFilename_Label.Caption := MinimizeName(TempEarthTextureName,EarthTextureFilename_Label.Canvas,EarthTextureFilename_Label.Width);
        end;
    end
  else with OpenDialog1 do
    begin
      Title := 'Select Earth Texture reference image';
      FileName := TempEarthTextureName;
      Filter := OpenPictureDialog1.Filter;
      if Execute then
        begin
          TempEarthTextureName := FileName;
          EarthTextureFilename_Label.Caption := MinimizeName(TempEarthTextureName,EarthTextureFilename_Label.Canvas,EarthTextureFilename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.ChangeEphemerisFile_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select JPL ephemeris file';
      FileName := TempEphemerisFilename;
      Filter := 'JPL DE405 Ephemeris Files (*.405)|*.405|All Files|*.*';
      if Execute then
        begin
          TempEphemerisFilename := FileName;
          EphemerisFilename_Label.Caption := MinimizeName(TempEphemerisFilename,EphemerisFilename_Label.Canvas,EphemerisFilename_Label.Width);
        end;
    end;

end;

procedure TExternalFileSelection_Form.ChangeDotFile_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select Named Lunar Features file';
      FileName := TempDotFilename;
      Filter := 'Comma-separated values files (*.csv)|*.csv|Text files (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          TempDotFilename := FileName;
          DotFilename_Label.Caption := MinimizeName(TempDotFilename,DotFilename_Label.Canvas,DotFilename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.ChangeTAIFile_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select TAI Offsets file';
      if TempTAIFilename='' then
        FileName := LTVT_Form.FullFilename('TAI_Offset_Data.txt')
      else
        FileName := TempTAIFilename;
      Filter := 'Text files (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          TempTAIFilename := FileName;
          TAIFilename_Label.Caption := MinimizeName(TempTAIFilename,TAIFilename_Label.Canvas,TAIFilename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.PhotoSessionsFile_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select Photo Search list';
      FileName := TempNormalPhotoSessionsFilename;
      Filter := 'Comma-separated values files (*.csv)|*.csv|Text files (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          TempNormalPhotoSessionsFilename := FileName;
          PhotoSessionsFilename_Label.Caption := MinimizeName(TempNormalPhotoSessionsFilename,PhotoSessionsFilename_Label.Canvas,PhotoSessionsFilename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.CalibratedPhotos_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select Calibrated Photo Database list';
      FileName := TempCalibratedPhotosFilename;
      Filter := 'Text file in comma separated format (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          TempCalibratedPhotosFilename := FileName;
          CalibratedPhotosFilename_Label.Caption := MinimizeName(TempCalibratedPhotosFilename,CalibratedPhotosFilename_Label.Canvas,CalibratedPhotosFilename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.ObservatoryList_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select list of observer locations';
      FileName := TempObservatoryListFilename;
      Filter := 'Text file in comma separated format (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          TempObservatoryListFilename := FileName;
          ObservatoryListFilename_Label.Caption := MinimizeName(TempObservatoryListFilename,ObservatoryListFilename_Label.Canvas,ObservatoryListFilename_Label.Width);
        end;
    end;
end;

procedure TExternalFileSelection_Form.Save_ButtonClick(Sender: TObject);
begin
  with LTVT_Form do
    begin
      ReadFileOptionsFromForm;
      SaveFileOptions;
    end;
end;

procedure TExternalFileSelection_Form.Restore_ButtonClick(Sender: TObject);
begin
  with LTVT_Form do
    begin
      RestoreFileOptions;
      WriteFileOptionsToForm;
    end;
  RefreshLabels;
end;

procedure TExternalFileSelection_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'ChangingFilenames.htm');
end;

end.
