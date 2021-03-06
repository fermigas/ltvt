unit H_PhotosessionSearch_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, StdCtrls, ComCtrls, Math, DateUtils, ExtCtrls,
  H_JPL_Ephemeris, MoonPosition, Constnts, {TimLib,} MP_Defs, Win_Ops, FileCtrl,
  MPVectors;

type
  TPhotosessionSearch_Form = class(TForm)
    Label1: TLabel;
    Date_DateTimePicker: TDateTimePicker;
    Time_DateTimePicker: TDateTimePicker;
    CalculateCircumstances_Button: TButton;
    Crater_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    Crater_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    SunAngle_LabeledNumericEdit: TLabeledNumericEdit;
    Colongitude_LabeledNumericEdit: TLabeledNumericEdit;
    ColongitudeMode_RadioButton: TRadioButton;
    SunAngleMode_RadioButton: TRadioButton;
    Memo1: TRichEdit;
    ClearMemo_Button: TButton;
    Tabulate_Button: TButton;
    Font_Button: TButton;
    FontDialog1: TFontDialog;
    ColongitudeTolerance_LabeledNumericEdit: TLabeledNumericEdit;
    SunAzimuth_LabeledNumericEdit: TLabeledNumericEdit;
    SunElevationTolerance_LabeledNumericEdit: TLabeledNumericEdit;
    ColongitudeMode_GroupBox: TGroupBox;
    SunAltitudeMode_GroupBox: TGroupBox;
    ObserverLocation_GroupBox: TGroupBox;
    ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit;
    GeocentricObserver_CheckBox: TCheckBox;
    PhotoFilename_Label: TLabel;
    ChangeFile_Button: TButton;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    Abort_Button: TButton;
    ObservatoryList_ComboBox: TComboBox;
    AddLocation_Button: TButton;
    SunAzimuthTolerance_LabeledNumericEdit: TLabeledNumericEdit;
    procedure CalculateCircumstances_ButtonClick(Sender: TObject);
    procedure ClearMemo_ButtonClick(Sender: TObject);
    procedure Tabulate_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Font_ButtonClick(Sender: TObject);
    procedure ColongitudeMode_RadioButtonClick(Sender: TObject);
    procedure SunAngleMode_RadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GeocentricObserver_CheckBoxClick(Sender: TObject);
    procedure Date_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Time_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CalculateCircumstances_ButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure ColongitudeMode_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure SunAngleMode_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Colongitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SolarLatitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ColongitudeTolerance_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Crater_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Crater_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SunAngle_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SunAzimuth_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SunElevationTolerance_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GeocentricObserver_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ObserverElevation_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Tabulate_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Font_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClearMemo_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChangeFile_ButtonClick(Sender: TObject);
    procedure ChangeFile_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Abort_ButtonClick(Sender: TObject);
    procedure Abort_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObservatoryList_ComboBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure ObservatoryList_ComboBoxSelect(Sender: TObject);
    procedure ObserverLongitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverLatitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverElevation_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure AddLocation_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddLocation_ButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SunAzimuthTolerance_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ObsNameList, ObsLatList, ObsLonList, ObsElevList : TStrings;

    AbortTabulation : Boolean;

    PSS_JPL_Filename, PSS_JPL_Path, PhotoSessionsFilename : string;

    SubSolarPoint : TPolarCoordinates;
    SolarColongitude : extended;  {in rad}

    function JPL_File_Valid(const Desired_MJD : extended) : boolean;
    {returns true if Desired_MJD falls within range of current ephemeris file;
      if not attempts to load the appropriate file}

    procedure CalculateSolarColongitude(const MJD_for_CL :extended);  {UT MJD}

    procedure RefreshSelection;

  end;

var
  PhotosessionSearch_Form: TPhotosessionSearch_Form;

implementation

uses NumericEdit, LTVT_Unit, H_Terminator_SetYear_Unit, ObserverLocationName_Unit;

{$R *.dfm}

var
  SelectingItem : Boolean;   // flag to avoid refreshing Combo-box selection during a new selection

procedure TPhotosessionSearch_Form.FormCreate(Sender: TObject);
begin
//  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:nn:ss';
  ThousandSeparator := #0;
  DecimalSeparator := '.';

//  PSS_JPL_Filename := 'UNXP2000.405'; // overwritten by calling program
//  PSS_JPL_Path := '';
  PhotoSessionsFilename := '';

  if not LTVT_Form.LinuxCompatibilityMode then Date_DateTimePicker.MinDate := EncodeDateDay(1601,1);

  ObsNameList := TStringList.Create;
  ObsLatList := TStringList.Create;
  ObsLonList := TStringList.Create;
  ObsElevList := TStringList.Create;

  SelectingItem := False;
end;

procedure TPhotosessionSearch_Form.FormDestroy(Sender: TObject);
begin
  ObsNameList.Free;
  ObsLatList.Free;;
  ObsLonList.Free;;
  ObsElevList.Free;;
end;

procedure TPhotosessionSearch_Form.FormActivate(Sender: TObject);
begin
  if CurrentTargetPlanet=Moon then
    begin
      ColongitudeMode_RadioButton.Caption := 'Colongitude Mode';
      Colongitude_LabeledNumericEdit.Item_Label.Caption := 'Colongitude:';
      Colongitude_LabeledNumericEdit.Hint := 'Desired selenographic colongitude of Sun in decimal degrees (DD.ddd format)'
    end
  else
    begin
      ColongitudeMode_RadioButton.Caption := 'Central Meridian Mode';
      Colongitude_LabeledNumericEdit.Item_Label.Caption := '        CM :';
      Colongitude_LabeledNumericEdit.Hint := 'Desired central meridian longitude in decimal degrees (DD.ddd format; East=+/West=-)'
    end;
end;

procedure TPhotosessionSearch_Form.RefreshSelection;
var
  i : Integer;
begin
  if ObservatoryList_ComboBox.Visible and not SelectingItem then
    begin
      i := 0;
      while (i<ObsNameList.Count) and
        (    (ObserverLongitude_LabeledNumericEdit.NumericEdit.Text<>ObsLonList[i])
          or (ObserverLatitude_LabeledNumericEdit.NumericEdit.Text<>ObsLatList[i])
          or (ObserverElevation_LabeledNumericEdit.NumericEdit.Text<>ObsElevList[i])
        ) do Inc(i);

      if i<ObservatoryList_ComboBox.Items.Count then
        ObservatoryList_ComboBox.ItemIndex := i
      else
        begin
          if FileExists(LTVT_Form.ObservatoryListFilename) then
            begin
              ObservatoryList_ComboBox.ItemIndex := -1;
              ObservatoryList_ComboBox.Text := LTVT_Form.ObservatoryComboBoxDefaultText;
            end
          else
            begin
              ObservatoryList_ComboBox.ItemIndex := -1;
              ObservatoryList_ComboBox.Text := LTVT_Form.ObservatoryNoFileText;
            end
        end;
    end;
end;

procedure TPhotosessionSearch_Form.ObservatoryList_ComboBoxSelect(Sender: TObject);
begin
  with ObservatoryList_ComboBox do if ItemIndex>=0 then
    begin
      SelectingItem := True;
      ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObsLonList[ItemIndex];
      ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObsLatList[ItemIndex];
      ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObsElevList[ItemIndex];
      SelectingItem := False;
    end
  else
    ShowMessage('Please try again:  you must click on an item in the list');
end;

procedure TPhotosessionSearch_Form.ObserverLongitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TPhotosessionSearch_Form.ObserverLatitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TPhotosessionSearch_Form.ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TPhotosessionSearch_Form.AddLocation_ButtonClick(Sender: TObject);
var
  ObsListFile : TextFile;
  NameToAdd : String;
begin
  with ObserverLocationName_Form do
    begin
      ShowModal;
      if CancelAction then Exit;

      NameToAdd := Trim(Name_Edit.Text);
    end;

  AssignFile(ObsListFile,LTVT_Form.ObservatoryListFilename);

  if FileExists(LTVT_Form.ObservatoryListFilename) then
    begin
      Append(ObsListFile);
    end
  else
    begin
      Rewrite(ObsListFile);
      Writeln(ObsListFile,'* List of observatory locations for use by LTVT');
      Writeln(ObsListFile,'*   (blank lines and lines with ''*'' in the first column are ignored)');
      Writeln(ObsListFile,'');
      Writeln(ObsListFile,'*   The observatory name can include any characters -- including commas');
      Writeln(ObsListFile,'*   Longitudes and latitudes must be in decimal degrees (NOT degrees-minutes-seconds)');
      Writeln(ObsListFile,'*   Important: you must use ''.'' (period) for for the decimal point');
      Writeln(ObsListFile,'');
      Writeln(ObsListFile,'* List items in this format (using commas to separate items):');
      Writeln(ObsListFile,'* ObservatoryEastLongitude_degrees, ObservatoryNorthLatitude_degrees, ObservatoryElevation_meters, ObservatoryName');
      Writeln(ObsListFile,'');
    end;

  Writeln(ObsListFile,
    Trim(ObserverLongitude_LabeledNumericEdit.NumericEdit.Text)+', '+
    Trim(ObserverLatitude_LabeledNumericEdit.NumericEdit.Text)+', '+
    Trim(ObserverElevation_LabeledNumericEdit.NumericEdit.Text)+', '+
    CSV_formatted_string(NameToAdd));
  CloseFile(ObsListFile);

  ObsLonList.Add(Trim(ObserverLongitude_LabeledNumericEdit.NumericEdit.Text));
  ObsLatList.Add(Trim(ObserverLatitude_LabeledNumericEdit.NumericEdit.Text));
  ObsElevList.Add(Trim(ObserverElevation_LabeledNumericEdit.NumericEdit.Text));
  ObsNameList.Add(NameToAdd);

  ObservatoryList_ComboBox.Items.Add(NameToAdd);

//  ShowMessage('Location added to '+LTVT_Form.ObservatoryListFilename);
  RefreshSelection;
end;

function TPhotosessionSearch_Form.JPL_File_Valid(const Desired_MJD : extended) : boolean;
{returns true if Desired_MJD falls within range of current ephemeris file;
  if not attempts to load the appropriate file}
var
  JED : extended;

  procedure LookForJPLFile;
    var
      JPL_Year : integer;
    begin  // try to silently load another file
      JPL_Year := Round(YearOf(ModifiedJulianDateToDateTime(Desired_MJD)));
      LoadJPL_File(PSS_JPL_Path+'UNXP'+IntToStr(50*(JPL_Year div 50))+'.405');
    end;

begin
  JED := Desired_MJD + MJDOffset;

  if not EphemerisFileLoaded then
    begin
      LoadJPL_File(PSS_JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          PSS_JPL_Filename := EphemerisFilname; // save as default if something was selected
          PSS_JPL_Path := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if EphemerisFileLoaded and ((JED<SS[1]) or (JED>SS[2])) then
    begin // ask for assistance only if necessary
      LookForJPLFile;
      if EphemerisFileLoaded then
        begin
          PSS_JPL_Filename := EphemerisFilname; // save as default if something was selected
          PSS_JPL_Path := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if (not EphemerisFileLoaded) or ((JED<SS[1]) or (JED>SS[2])) then
    begin
      ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
      Result := False;
    end
  else
    Result := True;

end;

procedure TPhotosessionSearch_Form.CalculateCircumstances_ButtonClick(Sender: TObject);
var
  UT_MJD, CraterLat, CraterLon, SunLat, SunLon, AngleToSun, SunAzimuth : extended;
begin {CalculateCircumstances_ButtonClick}
  UT_MJD := DateTimeToModifiedJulianDate(DateOf(Date_DateTimePicker.Date) + TimeOf(Time_DateTimePicker.Time));

  if JPL_File_Valid(UT_MJD) then
    begin
      CalculateSolarColongitude(UT_MJD);

      Memo1.Lines.Add('');
      if CurrentTargetPlanet=Moon then
        begin
          Memo1.Lines.Add('Lunar lighting conditions calculated for:  '+
            LTVT_Form.CorrectedDateTimeToStr(ModifiedJulianDateToDateTime(UT_MJD))+' UT');
          Colongitude_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(SolarColongitude)]);
        end
      else
        begin
          Memo1.Lines.Add('Conditions calculated for '+CurrentPlanetName+' :  '+
            LTVT_Form.CorrectedDateTimeToStr(ModifiedJulianDateToDateTime(UT_MJD))+' UT');
          Colongitude_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[LTVT_Form.PosNegDegrees(RadToDeg(SolarColongitude),LTVT_Form.PlanetaryLongitudeConvention)]);
        end;

//      SolarLatitude_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubSolarPoint.Latitude)]);

      CraterLon := DegToRad(Crater_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
      CraterLat := DegToRad(Crater_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);
      SunLon := SubSolarPoint.Longitude;
      SunLat := SubSolarPoint.Latitude;

      ComputeDistanceAndBearing(CraterLon, CraterLat, SunLon, SunLat, AngleToSun, SunAzimuth);
    //  SunAngle := PiByTwo - ArcCos(Sin(CraterLat)*Sin(SunLat) + Cos(CraterLat)*Cos(SunLat)*Cos(SunLon - CraterLon));

      SunAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(PiByTwo - AngleToSun)]);
      SunAzimuth_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(SunAzimuth)]);
    end;
end;  {CalculateCircumstances_ButtonClick}

procedure TPhotosessionSearch_Form.ClearMemo_ButtonClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TPhotosessionSearch_Form.CalculateSolarColongitude(const MJD_for_CL :extended);
  var
    SubObserverPoint : TPolarCoordinates;
  begin
    if not JPL_File_Valid(MJD_for_CL) then exit;

    SubSolarPoint := SubSolarPointOnMoon(MJD_for_CL);

    if CurrentTargetPlanet=Moon then
      begin
        SolarColongitude := PiByTwo - SubSolarPoint.Longitude;
        while SolarColongitude>TwoPi do SolarColongitude := SolarColongitude - TwoPi;
        while SolarColongitude<0     do SolarColongitude := SolarColongitude + TwoPi;
      end
    else
      begin
        SubObserverPoint := SubEarthPointOnMoon(MJD_for_CL);
        SolarColongitude := SubObserverPoint.Longitude;
      end;

//    ShowMessage(Format('Calculating for MJD = %0.3f  CL= %0.3f',[MJD_for_CL,RadToDeg(SolarColongitude)]));
  end;

procedure TPhotosessionSearch_Form.Tabulate_ButtonClick(Sender: TObject);
const
  WithinToleranceSymbol = '+';
  MoonUpSunDownSymbol = '%';
  TargetVisibleSymbol = '*';

var
  DataLine, TrialFilename,
  PhotoDateString, PhotoTimeString, FileDescription : string;
  PhotoFile : TextFile;
  PhotoDate, PhotoTime : TDateTime;

  OldGeocentricMode : boolean;

  LinesPrinted : integer;

  MJD, TargetSolarElevation, TargetSolarAzimuth, {angles in rad}
  TargetCL, CraterLonDeg, CraterLatDeg, SunAngleDeg, SunAzimuthDeg,
  AllowableColongitudeErrorDegrees, AllowableSunElevationErrorDegrees,
  AllowableSunAzimuthErrorDegrees : Extended;

procedure ConvertSemicolonsToCommas(var StringToConvert : string);
  var
    SemicolonPos : integer;
  begin
    SemicolonPos := Pos(';',StringToConvert);
    while SemicolonPos<>0 do
      begin
        StringToConvert := Copy(StringToConvert,0,SemicolonPos-1)+','+Copy(StringToConvert,SemicolonPos+1,MaxInt);
        SemicolonPos := Pos(';',StringToConvert);
      end;
  end;

procedure PrintHeader;
  begin
    if GeocentricSubEarthMode then
      Memo1.Lines.Add('Librations calculated for a geocentric observer')
    else
      Memo1.Lines.Add(Format('Librations calculated for observer at %s  %s  %0.0f m',
        [LTVT_Form.EarthLongitudeString(-ObserverLongitude,4),LTVT_Form.LatitudeString(ObserverLatitude,4),ObserverElevation]));
    Memo1.Lines.Add('');
    if ColongitudeMode_RadioButton.Checked then
      begin
        if CurrentTargetPlanet=Moon then
          begin
            Memo1.Lines.Add('                          Terminators      Sub-Solar Point      Librations');
            Memo1.Lines.Add('   Date      Time UT   Morning   Evening    Colong    Lat.     Long.   Lat.    Photo Name');
          end
        else
          begin
            Memo1.Lines.Add('                          Terminators                Solar   Sub-Earth Point');
            Memo1.Lines.Add('   Date      Time UT   Morning   Evening      CM      Lat.     Long.   Lat.    Photo Name');
          end;
      end
    else
      begin
        if CurrentTargetPlanet=Moon then
          begin
            Memo1.Lines.Add('                           Sun Angle       Sub-Solar Point      Librations ');
            Memo1.Lines.Add('   Date      Time UT   Altitude  Azimuth    Colong    Lat.     Long.   Lat.     Photo Name');
          end
        else
          begin
            Memo1.Lines.Add('                           Sun Angle       Sub-Solar Point   Sub-Earth Point ');
            Memo1.Lines.Add('   Date      Time UT   Altitude  Azimuth     Long     Lat.     Long.   Lat.     Photo Name');
          end;
      end;
  end;

procedure PrintData;
  var
    SunPosition, MoonPosition : PositionResultRecord;
    MoonUpSunDownCode, TargetVisibleCode : String;
    CraterLat, CraterLon, SunLat, SunLon, AngleToSun, SolarElevation, SolarAzimuth : Extended;
    TargetDistance, TargetAzimuth, AzimuthError : Extended;
    CL, MT, ET, CL_SearchResult, CL_SearchResult_Error : Extended; // [deg]
    PrintDateTime : TDateTime;
    SubEarthPoint : TPolarCoordinates;

  begin {PrintData}
  if JPL_File_Valid(MJD) then
    begin
      CalculateSolarColongitude(MJD); // returns SubSolarPoint and "SolarColongitude" which may be Colongitude or Central Meridian

      CL := PiByTwo - SubSolarPoint.Longitude;
      while CL>TwoPi do CL := CL - TwoPi;
      while CL<0     do CL := CL + TwoPi;
      CL := RadToDeg(CL);
      ET := 180 - CL;
      MT := -CL;
      if CurrentTargetPlanet<>Moon then CL := LTVT_Form.PosNegDegrees(CL,LTVT_Form.PlanetaryLongitudeConvention);

      CL_SearchResult := RadToDeg(SolarColongitude);
      if CurrentTargetPlanet<>Moon then CL_SearchResult := LTVT_Form.PosNegDegrees(CL_SearchResult,LTVT_Form.PlanetaryLongitudeConvention);

      CL_SearchResult_Error := TargetCL - SolarColongitude;
      while CL_SearchResult_Error>Pi  do CL_SearchResult_Error := CL_SearchResult_Error - TwoPi;
      while CL_SearchResult_Error<-Pi do CL_SearchResult_Error := CL_SearchResult_Error + TwoPi;

      SubEarthPoint := SubEarthPointOnMoon(MJD);
      while SubEarthPoint.Longitude>Pi do SubEarthPoint.Longitude := SubEarthPoint.Longitude - TwoPi;

      CalculatePosition(MJD,CurrentTargetPlanet,BlankStarDataRecord,MoonPosition);
      CalculatePosition(MJD,Sun, BlankStarDataRecord,SunPosition);

      if (MoonPosition.TopocentricAlt>0) and (SunPosition.TopocentricAlt<0) and not GeocentricSubEarthMode then
        MoonUpSunDownCode := MoonUpSunDownSymbol
      else
        MoonUpSunDownCode := ' ';

      PrintDateTime := ModifiedJulianDateToDateTime(MJD);
      while Length(FileDescription)<30 do FileDescription := FileDescription + ' ';

      if SunAngleMode_RadioButton.Checked then
        begin
          CraterLon := DegToRad(Crater_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
          CraterLat := DegToRad(Crater_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);
          SunLat := SubSolarPoint.Latitude;
          SunLon := SubSolarPoint.Longitude;

          ComputeDistanceAndBearing(CraterLon, CraterLat, SunLon, SunLat, AngleToSun, SolarAzimuth);
          SolarElevation := PiByTwo - AngleToSun;
          AzimuthError := SolarAzimuth - TargetSolarAzimuth;
          while AzimuthError<Pi do AzimuthError := AzimuthError + TwoPi;
          while AzimuthError>Pi do AzimuthError := AzimuthError - TwoPi;

          if (Abs(RadToDeg(SolarElevation-TargetSolarElevation))<AllowableSunElevationErrorDegrees)
            and (Abs(RadToDeg(AzimuthError))<AllowableSunAzimuthErrorDegrees) then
            begin
              ComputeDistanceAndBearing(SubEarthPoint.Longitude, SubEarthPoint.Latitude, CraterLon, CraterLat, TargetDistance, TargetAzimuth);
              if TargetDistance<PiByTwo then
                TargetVisibleCode := TargetVisibleSymbol
              else
                TargetVisibleCode := ' ';

              Memo1.Lines.Add(Format('%10s%10s%10.4f%10.4f%10.3f%8.3f%9.3f%8.3f %1s%1s  %30.30s',
                [DateToStr(PrintDateTime),TimeToStr(PrintDateTime),RadToDeg(SolarElevation),
                RadToDeg(SolarAzimuth),CL,
                RadToDeg(SubSolarPoint.Latitude),
                LTVT_Form.PosNegDegrees(RadToDeg(SubEarthPoint.Longitude),LTVT_Form.PlanetaryLongitudeConvention),
                RadToDeg(SubEarthPoint.Latitude),
                TargetVisibleCode,MoonUpSunDownCode,FileDescription]));
              Inc(LinesPrinted);
            end;
        end
      else // ColongitudeMode
        begin
          if Abs(RadToDeg(CL_SearchResult_Error))<AllowableColongitudeErrorDegrees then
            begin
              Memo1.Lines.Add(Format('%10s%10s%10s%10s%10.3f%8.3f%9.3f%8.3f %1s  %30.30s',
                [DateToStr(PrintDateTime),TimeToStr(PrintDateTime),LTVT_Form.PlanetaryLongitudeString(MT,3),
                LTVT_Form.PlanetaryLongitudeString(ET,3),CL_SearchResult,
                RadToDeg(SubSolarPoint.Latitude),
                LTVT_Form.PosNegDegrees(RadToDeg(SubEarthPoint.Longitude),LTVT_Form.PlanetaryLongitudeConvention),
                RadToDeg(SubEarthPoint.Latitude),
                MoonUpSunDownCode,FileDescription]));

              Inc(LinesPrinted);
            end;
        end;
    end
  else // JPL data invalid
    begin
      if MessageDlg('Ephemris data not found -- abort tabulation?',mtConfirmation,[mbYes,mbNo],0)=mrYes then AbortTabulation := true;
    end;

  end;  {PrintData}

begin {Tabulate_ButtonClick}
  Memo1.SetFocus;  // this forces scroll bars to move down as text is added

  Memo1.Lines.Add('');
  CurrentObserver := Special;

  Memo1.SelAttributes.Color := clBlack;

  OldGeocentricMode := GeocentricSubEarthMode; // record status of calling program
  GeocentricSubEarthMode := GeocentricObserver_Checkbox.Checked;  // note: observer position does not affect subsolar point/colongitude/sun angle calculations

  ObserverLongitude := -ObserverLongitude_LabeledNumericEdit.NumericEdit.ExtendedValue;
  ObserverLatitude := ObserverLatitude_LabeledNumericEdit.NumericEdit.ExtendedValue;
  ObserverElevation := ObserverElevation_LabeledNumericEdit.NumericEdit.ExtendedValue;

  if ColongitudeMode_RadioButton.Checked then
    begin
      TargetCL := DegToRad(Colongitude_LabeledNumericEdit.NumericEdit.ExtendedValue);
      AllowableColongitudeErrorDegrees := Abs(ColongitudeTolerance_LabeledNumericEdit.NumericEdit.ExtendedValue);

      if CurrentTargetPlanet=Moon then
        Memo1.Lines.Add(Format('Searching for Colong = %0.3f +/- %0.3f�',
          [RadToDeg(TargetCL),AllowableColongitudeErrorDegrees]))
      else
        Memo1.Lines.Add(Format('Searching for Central Meridian = %0.3f +/- %0.3f�',
          [RadToDeg(TargetCL),AllowableColongitudeErrorDegrees]));
    end
  else {Altitude mode}
    begin
      CraterLonDeg := Crater_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue;
      CraterLatDeg := Crater_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue;
      SunAngleDeg  := SunAngle_LabeledNumericEdit.NumericEdit.ExtendedValue;
      SunAzimuthDeg  := SunAzimuth_LabeledNumericEdit.NumericEdit.ExtendedValue;

      TargetSolarElevation := DegToRad(SunAngleDeg);
      TargetSolarAzimuth   := DegToRad(SunAzimuthDeg);
      AllowableSunElevationErrorDegrees := Abs(SunElevationTolerance_LabeledNumericEdit.NumericEdit.ExtendedValue);
      AllowableSunAzimuthErrorDegrees := Abs(SunAzimuthTolerance_LabeledNumericEdit.NumericEdit.ExtendedValue);

      Memo1.Lines.Add(Format('Searching for Sun Angle = %0.4f+/-%0.3f� with Azimuth = %0.4f+/-%0.3f� over feature at %s   %s',
        [SunAngleDeg,AllowableSunElevationErrorDegrees,SunAzimuthDeg,AllowableSunAzimuthErrorDegrees,
        LTVT_Form.PlanetaryLongitudeString(CraterLonDeg,3),LTVT_Form.LatitudeString(CraterLatDeg,3)]));
    end;

  LinesPrinted := 0;

  TrialFilename := PhotosessionsFilename;

  if not FileFound('Photosessions file',TrialFilename,PhotosessionsFilename) then
    begin
      Memo1.Lines.Add('File "'+PhotosessionsFilename+'" not found!');
    end
  else
    begin
      if PhotosessionsFilename<>TrialFilename then
        PhotoFilename_Label.Caption := MinimizeName(PhotoSessionsFilename,PhotoFilename_Label.Canvas,PhotoFilename_Label.Width);

      Memo1.Lines.Add('Using times in: '+PhotoSessionsFilename);
      PrintHeader;

      AbortTabulation := False;
      AssignFile(PhotoFile,PhotosessionsFilename);
      Reset(PhotoFile);
      while (not EOF(PhotoFile)) and not (AbortTabulation) do
        begin
          Readln(PhotoFile,DataLine);
          DataLine := Trim(DataLine);
          if (Length(DataLine)>0) and (DataLine[1]<>'*') then
          begin
            ConvertSemicolonsToCommas(DataLine);
            PhotoDateString := LeadingElement(DataLine,',');
            PhotoTimeString := LeadingElement(DataLine,',');
            FileDescription := ExtractFileName(DataLine);
            if PhotoDateString='' then
              PhotoDate := 0
            else
              PhotoDate := StrToDate(PhotoDateString);
            if PhotoTimeString='' then
              PhotoTime := 0
            else
              PhotoTime := StrToTime(PhotoTimeString);
            if PhotoDateString<>'' then
              begin
                MJD := DateTimeToModifiedJulianDate(PhotoDate + PhotoTime);
                PrintData;
              end;
          end;
          Application.ProcessMessages;
        end;
      CloseFile(PhotoFile);
    end;

  if LinesPrinted>0 then
    begin
      Memo1.Lines.Add('');

      if SunAngleMode_RadioButton.Checked then
          Memo1.Lines.Add(Format('  %s = Target feature on visible disk',[TargetVisibleSymbol]));

      if not GeocentricSubEarthMode then Memo1.Lines.Add(Format('  %s = '+CurrentPlanetName+' above horizon/Sun below horizon',[MoonUpSunDownSymbol]));
      Memo1.Lines.Add('');
      if AbortTabulation then
        Memo1.Lines.Add('                     *** tabulation aborted ***')
      else
        Memo1.Lines.Add('                      *** search completed ***');
    end
  else
    begin
      Memo1.Lines.Add('');
      if AbortTabulation then
        Memo1.Lines.Add('                     *** tabulation aborted ***')
      else
        Memo1.Lines.Add('            *** no photos found within requested range ***');
    end;

  GeocentricSubEarthMode := OldGeocentricMode; // restore status of calling program

end;  {Tabulate_ButtonClick}

procedure TPhotosessionSearch_Form.Font_ButtonClick(Sender: TObject);
begin
  if FontDialog1.Execute then Memo1.Font := FontDialog1.Font;
end;

procedure TPhotosessionSearch_Form.ColongitudeMode_RadioButtonClick(Sender: TObject);
begin
  ColongitudeMode_GroupBox.Show;
  SunAltitudeMode_GroupBox.Hide;
end;

procedure TPhotosessionSearch_Form.SunAngleMode_RadioButtonClick(Sender: TObject);
begin
  ColongitudeMode_GroupBox.Hide;
  SunAltitudeMode_GroupBox.Show;
end;

procedure TPhotosessionSearch_Form.FormShow(Sender: TObject);
var
  ObsListFile : TextFile;
  DataLine : String;
begin
  ObsNameList.Clear;
  ObsLatList.Clear;
  ObsLonList.Clear;
  ObsElevList.Clear;
  if FileExists(LTVT_Form.ObservatoryListFilename) then
    begin
      AssignFile(ObsListFile,LTVT_Form.ObservatoryListFilename);
      Reset(ObsListFile);
      while (not EOF(ObsListFile)) {and (Length(FeatureList)<100)} do
        begin
          Readln(ObsListFile,DataLine);
          DataLine := Trim(DataLine);
          if (DataLine<>'') and (Substring(DataLine,1,1)<>'*') then
            begin
              ObsLonList.Add(LeadingElement(DataLine,','));
              ObsLatList.Add(LeadingElement(DataLine,','));
              ObsElevList.Add(LeadingElement(DataLine,','));
              ObsNameList.Add(ExtractCSV_item(DataLine));
            end;
        end;
      CloseFile(ObsListFile);
    end;

  ObservatoryList_ComboBox.Items.Clear;
  ObservatoryList_ComboBox.Items.AddStrings(ObsNameList);
  RefreshSelection;

  ObserverLocation_GroupBox.Visible := not GeocentricObserver_CheckBox.Checked;
  PhotoFilename_Label.Caption := MinimizeName(PhotoSessionsFilename,PhotoFilename_Label.Canvas,PhotoFilename_Label.Width);
end;

procedure TPhotosessionSearch_Form.GeocentricObserver_CheckBoxClick(Sender: TObject);
begin
  ObserverLocation_GroupBox.Visible := not GeocentricObserver_CheckBox.Checked;
end;

procedure TPhotosessionSearch_Form.ChangeFile_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select Photo Search list';
      FileName := PhotoSessionsFilename;
      Filter := 'Comma-separated values files (*.csv)|*.csv|Text files (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          PhotoSessionsFilename := FileName;
          PhotoFilename_Label.Caption := MinimizeName(PhotoSessionsFilename,PhotoFilename_Label.Canvas,PhotoFilename_Label.Width);
        end;
    end;
end;

procedure TPhotosessionSearch_Form.Abort_ButtonClick(Sender: TObject);
begin
  AbortTabulation := True;
end;

procedure TPhotosessionSearch_Form.Date_DateTimePickerKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=27 then with Terminator_SetYear_Form do
    begin
      ShowModal;
      if SetYearRequested then
        Date_DateTimePicker.DateTime :=
          EncodeDate(DesiredYear_LabeledNumericEdit.NumericEdit.IntegerValue,
            MonthOf(Date_DateTimePicker.DateTime),DayOf(Date_DateTimePicker.DateTime));
    end
  else
    LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Time_DateTimePickerKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.CalculateCircumstances_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ColongitudeMode_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAngleMode_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Colongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SolarLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ColongitudeTolerance_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Crater_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Crater_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAngle_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAzimuth_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunElevationTolerance_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.GeocentricObserver_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObserverElevation_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Tabulate_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Memo1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Font_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ClearMemo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ChangeFile_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Abort_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObservatoryList_ComboBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.AddLocation_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAzimuthTolerance_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

end.
