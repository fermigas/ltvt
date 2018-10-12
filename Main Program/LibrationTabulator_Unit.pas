unit LibrationTabulator_Unit;
{
v0.0:
  1. Copy from Moon Event Predictor

v0.1:
  1. Add start/end checkbox. When checked, the listing gives the start and end
     times of the intervals meeting the criteria (as well as the time of
     minimum center distance, if different).
  2. Hide MinMoon and MaxSun elevation input boxes when geocentric mode is
     selected.
  3. Correct operation in geocentric mode so "elevations" of Moon and Sun are
     not checked.
  4. Add list of constraints to printout.

                                                                      6 Mar 2009}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, StdCtrls, ComCtrls, Math, DateUtils, ExtCtrls,
  H_JPL_Ephemeris, MoonPosition, Constnts, {TimLib,} MP_Defs;

type
  TLibrationTabulator_Form = class(TForm)
    ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit;
    MinMoonElevDeg_LabeledNumericEdit: TLabeledNumericEdit;
    Crater_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    Memo1: TRichEdit;
    ClearMemo_Button: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Tabulate_Button: TButton;
    StartDate_DateTimePicker: TDateTimePicker;
    EndDate_DateTimePicker: TDateTimePicker;
    Crater_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    Font_Button: TButton;
    FontDialog1: TFontDialog;
    MinSunAngleDeg_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit;
    MaxSunElevDeg_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverLocation_GroupBox: TGroupBox;
    TargetParameters_GroupBox: TGroupBox;
    Constraints_GroupBox: TGroupBox;
    GeocentricObserver_CheckBox: TCheckBox;
    MaxCenterAngleDeg_LabeledNumericEdit: TLabeledNumericEdit;
    MaxSunAngleDeg_LabeledNumericEdit: TLabeledNumericEdit;
    Abort_Button: TButton;
    ShowAll_CheckBox: TCheckBox;
    SearchTimeStepMin_LabeledNumericEdit: TLabeledNumericEdit;
    StartEnd_CheckBox: TCheckBox;
    ObservatoryList_ComboBox: TComboBox;
    AddLocation_Button: TButton;
    MinLibration_RadioButton: TRadioButton;
    MinLibrationDeg_LabeledNumericEdit: TLabeledNumericEdit;
    MaxCenterAngle_RadioButton: TRadioButton;
    procedure ClearMemo_ButtonClick(Sender: TObject);
    procedure Tabulate_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Font_ButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GeocentricObserver_CheckBoxClick(Sender: TObject);
    procedure GeocentricObserver_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Crater_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Crater_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StartDate_DateTimePickerKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure EndDate_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Tabulate_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Font_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClearMemo_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ObserverElevation_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Abort_ButtonClick(Sender: TObject);
    procedure Abort_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShowAll_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MinMoonElevDeg_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaxSunElevDeg_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaxCenterAngleDeg_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchTimeStepMin_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MinSunAngleDeg_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaxSunAngleDeg_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StartEnd_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObservatoryList_ComboBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure ObservatoryList_ComboBoxSelect(Sender: TObject);
    procedure ObserverLongitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverLatitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverElevation_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddLocation_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddLocation_ButtonClick(Sender: TObject);
    procedure MinLibrationDeg_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MaxCenterAngle_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure MinLibration_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ObsNameList, ObsLatList, ObsLonList, ObsElevList : TStrings;

    AbortTabulation : Boolean;

    MEP_JPL_Filename, MEP_JPL_Path : string;

    function JPL_File_Valid(const Desired_MJD : extended) : boolean;
    {returns true if Desired_MJD falls within range of current ephemeris file;
      if not attempts to load the appropriate file}

    procedure RefreshSelection;

  end;

var
  LibrationTabulator_Form: TLibrationTabulator_Form;

implementation

uses Win_Ops, NumericEdit, LTVT_Unit, H_Terminator_SetYear_Unit,
  MPVectors, ObserverLocationName_Unit;

{$R *.dfm}

var
  SelectingItem : Boolean;   // flag to avoid refreshing Combo-box selection during a new selection

procedure TLibrationTabulator_Form.FormCreate(Sender: TObject);
begin
  MEP_JPL_Filename := 'UNXP2000.405'; //overwritten by calling program
  MEP_JPL_Path := '';

  if not LTVT_Form.LinuxCompatibilityMode then
    begin
      StartDate_DateTimePicker.MinDate := EncodeDateDay(1601,1);
      EndDate_DateTimePicker.MinDate := EncodeDateDay(1601,1);
    end;

  try
    StartDate_DateTimePicker.Date := EncodeDateDay(CurrentYear,1);
  except
  end;

  try
    EndDate_DateTimePicker.Date := EncodeDateDay(CurrentYear+1,1);
  except
  end;

  ObsNameList := TStringList.Create;
  ObsLatList := TStringList.Create;
  ObsLonList := TStringList.Create;
  ObsElevList := TStringList.Create;

  SelectingItem := False;
end;

procedure TLibrationTabulator_Form.FormDestroy(Sender: TObject);
begin
  ObsNameList.Free;
  ObsLatList.Free;;
  ObsLonList.Free;;
  ObsElevList.Free;;
end;

procedure TLibrationTabulator_Form.FormActivate(Sender: TObject);
begin
  MinMoonElevDeg_LabeledNumericEdit.Item_Label.Caption := 'Min. '+PlanetName[CurrentTargetPlanet]+' Elev.:';
end;

procedure TLibrationTabulator_Form.FormShow(Sender: TObject);
var
  ObsListFile : TextFile;
  DataLine : String;
begin
//  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:nn:ss';
  ThousandSeparator := #0;
  DecimalSeparator := '.';

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
  MinMoonElevDeg_LabeledNumericEdit.Visible := not GeocentricObserver_CheckBox.Checked;
  MaxSunElevDeg_LabeledNumericEdit.Visible := not GeocentricObserver_CheckBox.Checked;
end;

procedure TLibrationTabulator_Form.RefreshSelection;
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

procedure TLibrationTabulator_Form.ObservatoryList_ComboBoxSelect(
  Sender: TObject);
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

procedure TLibrationTabulator_Form.ObserverLongitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TLibrationTabulator_Form.ObserverLatitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TLibrationTabulator_Form.ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TLibrationTabulator_Form.AddLocation_ButtonClick(Sender: TObject);
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

function TLibrationTabulator_Form.JPL_File_Valid(const Desired_MJD : extended) : boolean;
{returns true if Desired_MJD falls within range of current ephemeris file;
  if not attempts to load the appropriate file}
var
  JED : extended;

  procedure LookForJPLFile;
    var
      JPL_Year : integer;
    begin  // try to silently load another file
      JPL_Year := Round(YearOf(ModifiedJulianDateToDateTime(Desired_MJD)));
      LoadJPL_File(MEP_JPL_Path+'UNXP'+IntToStr(50*(JPL_Year div 50))+'.405');
    end;

begin
  JED := Desired_MJD + MJDOffset;

  if not EphemerisFileLoaded then
    begin
      LoadJPL_File(MEP_JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          MEP_JPL_Filename := EphemerisFilname; // save as default if something was selected
          MEP_JPL_Path := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if EphemerisFileLoaded and ((JED<SS[1]) or (JED>SS[2])) then
    begin // ask for assistance only if necessary
      LookForJPLFile;
    end;

  if (not EphemerisFileLoaded) or ((JED<SS[1]) or (JED>SS[2])) then
    begin
      ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
      Result := False;
    end
  else
    Result := True;

end;

procedure TLibrationTabulator_Form.ClearMemo_ButtonClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TLibrationTabulator_Form.Tabulate_ButtonClick(Sender: TObject);
var
  LinesPrinted : integer;
  OldGeocentricMode, CriteriaValid : boolean;
  SubSolarPoint, SubEarthPoint : TPolarCoordinates;
  SunPosition, MoonPosition : PositionResultRecord;
  StartMJD, EndMJD, MJDStep, CurrentMJD, IntervalStartMJD, IntervalEndMJD,
  MinMJD, MinCenterAngle,
  CraterLat, CraterLon, MinSunAngle, MaxSunAngle, MinMoonElevDeg, MaxSunElevDeg,  // all in radians
  CenterAngle, CenterAngleAz, SunAngle, SunAngleAz, MaxCenterAngle, MinLibration,
  NominalCenterAngle, PercentIllum, Libration : Extended;

procedure CalculateCircumstances(const MJD: Extended);
  var
    Lat1, Lon1, Lat2, Lon2, CosTheta : Extended;
  begin
    SubSolarPoint := SubSolarPointOnMoon(MJD);
    ComputeDistanceAndBearing(CraterLon, CraterLat, SubSolarPoint.Longitude, SubSolarPoint.Latitude, SunAngle, SunAngleAz);
    SunAngle := PiByTwo - SunAngle;

    SubEarthPoint := SubEarthPointOnMoon(MJD);
    ComputeDistanceAndBearing(SubEarthPoint.Longitude, SubEarthPoint.Latitude, CraterLon, CraterLat, CenterAngle, CenterAngleAz);
    Libration := NominalCenterAngle-CenterAngle;

//    CalculatePosition(MJD,Moon,BlankStarDataRecord,MoonPosition);
    CalculatePosition(MJD,CurrentTargetPlanet,BlankStarDataRecord,MoonPosition);
    CalculatePosition(MJD,Sun, BlankStarDataRecord,SunPosition);

    Lon1 := SubEarthPoint.Longitude;
    Lat1 := SubEarthPoint.Latitude;
    Lon2 := SubSolarPoint.Longitude;
    Lat2 := SubSolarPoint.Latitude;
    CosTheta := Sin(Lat1)*Sin(Lat2) + Cos(Lat1)*Cos(Lat2)*Cos(Lon2 - Lon1);
    PercentIllum := 50*(1 + CosTheta);

  if MinLibration_RadioButton.Checked then
    CriteriaValid := (SunAngle>=MinSunAngle)
                 and (SunAngle<=MaxSunAngle)
                 and (Libration>=MinLibration)
  else
    CriteriaValid := (SunAngle>=MinSunAngle)
                 and (SunAngle<=MaxSunAngle)
                 and (CenterAngle<=MaxCenterAngle);

    if not GeocentricSubEarthMode then
      CriteriaValid := CriteriaValid
                       and (MoonPosition.TopocentricAlt>=MinMoonElevDeg)
                       and (SunPosition.TopocentricAlt<MaxSunElevDeg);
  end;

procedure PrintHeader;
function EW_Tag(const Longitude : extended): string;
  begin
    if Longitude>=0 then
      Result := 'E'
    else
      Result := 'W';
  end;

function NS_Tag(const Latitude : extended): string;
  begin
    if Latitude>=0 then
      Result := 'N'
    else
      Result := 'S';
  end;

  begin {PrintHeader}
    if GeocentricSubEarthMode then
      Memo1.Lines.Add('Librations calculated for a geocentric observer')
    else
      Memo1.Lines.Add(Format('Librations and '+CurrentPlanetName+'/Sun positions calculated for observer at %0.4f°%s  %0.4f°%s  %0.0f m',
        [Abs(-ObserverLongitude),EW_Tag(-ObserverLongitude),Abs(ObserverLatitude),NS_Tag(ObserverLatitude),ObserverElevation]));
    Memo1.Lines.Add(Format('Center Dist(ance) and Sun Angle calculated for feature at %0.4f°%s  %0.4f°%s',
      [Abs(RadToDeg(CraterLon)),EW_Tag(RadToDeg(CraterLon)),Abs(RadToDeg(CraterLat)),NS_Tag(RadToDeg(CraterLat))]));
    Memo1.Lines.Add(Format('  Feature is %0.4f° from disk center at zero libration.',
      [RadToDeg(NominalCenterAngle)]));
    Memo1.Lines.Add('  "Libr(ation)" is how much closer feature is to disk center at time of observation.');
    Memo1.Lines.Add('  "%Illum" is percent illumination of the full lunar disk.');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('Times being searched at interval of '+SearchTimeStepMin_LabeledNumericEdit.NumericEdit.Text+' minutes subject to constraints:');
    Memo1.Lines.Add('  *  Sun angle at feature >'+MinSunAngleDeg_LabeledNumericEdit.NumericEdit.Text+'° and <'
      +MaxSunAngleDeg_LabeledNumericEdit.NumericEdit.Text+'°');
    if MinLibration_RadioButton.Checked then
      Memo1.Lines.Add('  *  Distance of feature from apparent lunar disk center >'+MinLibrationDeg_LabeledNumericEdit.NumericEdit.Text+'° closer than at zero libration')
    else
      Memo1.Lines.Add('  *  Distance of feature from apparent lunar disk center <'+MaxCenterAngleDeg_LabeledNumericEdit.NumericEdit.Text+'°');
    if not GeocentricSubEarthMode then
       Memo1.Lines.Add('  *  Center of '+CurrentPlanetName+' >'+MinMoonElevDeg_LabeledNumericEdit.NumericEdit.Text
         +'° and center of Sun <'+MaxSunElevDeg_LabeledNumericEdit.NumericEdit.Text
         +'° above observer''s horizon');
    Memo1.Lines.Add('');
    if GeocentricSubEarthMode then
      begin
        Memo1.Lines.Add('                      Center                      Sun Angle       Librations');
        Memo1.Lines.Add('   Date      Time UT   Dist.   Libr.  %Illum  Altitude Azimuth   Long.    Lat.');
      end
    else
      begin
        Memo1.Lines.Add('                      Center                      Sun Angle       Librations      Center of '+CurrentPlanetName+'    Center of Sun');
        Memo1.Lines.Add('   Date      Time UT   Dist.   Libr.  %Illum  Altitude Azimuth   Long.    Lat.     Alt.     Azi.     Alt.     Azi');
      end;
  end;  {PrintHeader}

procedure PrintData(const PrintMJD : Extended);
  var
    PrintDateTime : TDateTime;

  begin {PrintData}
    PrintDateTime := ModifiedJulianDateToDateTime(PrintMJD);
    CalculateCircumstances(PrintMJD);

    while SubEarthPoint.Longitude>Pi do SubEarthPoint.Longitude := SubEarthPoint.Longitude - TwoPi;

    if GeocentricSubEarthMode then
      Memo1.Lines.Add(Format('%10s%10s%8.3f%8.3f%8.2f%9.4f%9.3f%8.3f%8.3f',
        [DateToStr(PrintDateTime),TimeToStr(PrintDateTime), RadToDeg(CenterAngle),
        RadToDeg(Libration), PercentIllum,
        RadToDeg(SunAngle), RadToDeg(SunAngleAz),
        RadToDeg(SubEarthPoint.Longitude),RadToDeg(SubEarthPoint.Latitude)]))
    else
      Memo1.Lines.Add(Format('%10s%10s%8.3f%8.3f%8.2f%9.4f%9.3f%8.3f%8.3f%9.2f%9.2f%9.2f%9.2f',
        [DateToStr(PrintDateTime),TimeToStr(PrintDateTime), RadToDeg(CenterAngle),
        RadToDeg(Libration), PercentIllum,
        RadToDeg(SunAngle), RadToDeg(SunAngleAz),
        RadToDeg(SubEarthPoint.Longitude),RadToDeg(SubEarthPoint.Latitude),
        MoonPosition.TopocentricAlt,MoonPosition.Azimuth,
        SunPosition.TopocentricAlt,SunPosition.Azimuth]));

    Memo1.Refresh;

    Inc(LinesPrinted);

  end;  {PrintData}

begin {Tabulate_ButtonClick}
  Memo1.SetFocus;  // this forces scroll bars to move down as text is added

  Memo1.Lines.Add('');
  CurrentObserver := Special;

  OldGeocentricMode := GeocentricSubEarthMode; // record status of calling program
  GeocentricSubEarthMode := GeocentricObserver_Checkbox.Checked;  // note: observer position does not affect subsolar point/colongitude/sun angle calculations

  ObserverLongitude := -ObserverLongitude_LabeledNumericEdit.NumericEdit.ExtendedValue;
  ObserverLatitude := ObserverLatitude_LabeledNumericEdit.NumericEdit.ExtendedValue;
  ObserverElevation := ObserverElevation_LabeledNumericEdit.NumericEdit.ExtendedValue;

  StartMJD := DateTimeToModifiedJulianDate(DateOf(StartDate_DateTimePicker.Date));
  EndMJD   := DateTimeToModifiedJulianDate(DateOf(EndDate_DateTimePicker.Date));
  MJDStep :=  SearchTimeStepMin_LabeledNumericEdit.NumericEdit.ExtendedValue*OneMinute/OneDay;

  EndMJD := EndMJD - MJDStep;

  if not JPL_File_Valid(StartMJD) then
    begin
      ShowMessage('A valid JPL ephemeris data file for this interval could not be found');
      Exit;
    end;

  CraterLon := DegToRad(Crater_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
  CraterLat := DegToRad(Crater_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);

  MinSunAngle := DegToRad(MinSunAngleDeg_LabeledNumericEdit.NumericEdit.ExtendedValue);
  MaxSunAngle := DegToRad(MaxSunAngleDeg_LabeledNumericEdit.NumericEdit.ExtendedValue);
  MinMoonElevDeg := MinMoonElevDeg_LabeledNumericEdit.NumericEdit.ExtendedValue;
  MaxSunElevDeg  := MaxSunElevDeg_LabeledNumericEdit.NumericEdit.ExtendedValue;

  MaxCenterAngle := DegToRad(MaxCenterAngleDeg_LabeledNumericEdit.NumericEdit.ExtendedValue);

  MinLibration := DegToRad(MinLibrationDeg_LabeledNumericEdit.NumericEdit.ExtendedValue);
  ComputeDistanceAndBearing(0, 0, CraterLon, CraterLat, NominalCenterAngle, CenterAngleAz);

  LinesPrinted := 0;

  PrintHeader;

  CurrentMJD := StartMJD;
  AbortTabulation := False;

  while (CurrentMJD<=EndMJD) and not AbortTabulation do
    begin
      CalculateCircumstances(CurrentMJD);

      if ShowAll_CheckBox.Checked then
        begin
          PrintData(CurrentMJD);
          CurrentMJD := CurrentMJD + MJDStep;
        end
      else
        begin
          while (CurrentMJD<=EndMJD) and not CriteriaValid do
            begin
              CurrentMJD := CurrentMJD + MJDStep;
              CalculateCircumstances(CurrentMJD);
            end;

          if CriteriaValid then
            begin
              IntervalStartMJD := CurrentMJD;
              MinMJD := CurrentMJD;
              MinCenterAngle := CenterAngle;
              while (CurrentMJD<=EndMJD) and CriteriaValid do
                begin
                  CurrentMJD := CurrentMJD + MJDStep;
                  CalculateCircumstances(CurrentMJD);
                  if CriteriaValid and (CenterAngle<MinCenterAngle) then
                    begin
                      MinMJD := CurrentMJD;
                      MinCenterAngle := CenterAngle;
                    end;
                end;
              if StartEnd_CheckBox.Checked then
                begin
                  CurrentMJD := CurrentMJD - MJDStep;
                  CalculateCircumstances(CurrentMJD);
                  if CriteriaValid then
                    begin
                      IntervalEndMJD := CurrentMJD;
                      PrintData(IntervalStartMJD);
                      if (MinMJD>IntervalStartMJD) and (MinMJD<IntervalEndMJD)  then
                        PrintData(MinMJD);
                      PrintData(IntervalEndMJD);
                      Memo1.Lines.Add('');
                    end;
                  CurrentMJD := CurrentMJD + MJDStep;
                end
              else
                begin
                  CalculateCircumstances(MinMJD);
                  if CriteriaValid then PrintData(MinMJD);
                end;
            end;
        end;

      Application.ProcessMessages;   // check for Abort request
    end;

  if AbortTabulation then
      Memo1.Lines.Add('                (tabulation aborted)')
  else
    if (LinesPrinted>0) then
      begin
        if not StartEnd_CheckBox.Checked then Memo1.Lines.Add('');
        Memo1.Lines.Add('               *** search completed ***');
      end
    else
      begin
        Memo1.Lines.Add('');
        Memo1.Lines.Add('               *** no events found ***');
      end;


  GeocentricSubEarthMode := OldGeocentricMode; // restore status of calling program

end;  {Tabulate_ButtonClick}

procedure TLibrationTabulator_Form.Abort_ButtonClick(Sender: TObject);
begin
  AbortTabulation := True;
end;

procedure TLibrationTabulator_Form.Font_ButtonClick(Sender: TObject);
begin
  if FontDialog1.Execute then Memo1.Font := FontDialog1.Font;
end;

procedure TLibrationTabulator_Form.GeocentricObserver_CheckBoxClick(Sender: TObject);
begin
  ObserverLocation_GroupBox.Visible := not GeocentricObserver_CheckBox.Checked;
  MinMoonElevDeg_LabeledNumericEdit.Visible := not GeocentricObserver_CheckBox.Checked;
  MaxSunElevDeg_LabeledNumericEdit.Visible := not GeocentricObserver_CheckBox.Checked;
end;

procedure TLibrationTabulator_Form.GeocentricObserver_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Crater_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Crater_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.StartDate_DateTimePickerKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=27 then with Terminator_SetYear_Form do
    begin
      ShowModal;
      if SetYearRequested then
        StartDate_DateTimePicker.DateTime :=
          EncodeDate(DesiredYear_LabeledNumericEdit.NumericEdit.IntegerValue,
            MonthOf(StartDate_DateTimePicker.DateTime),DayOf(StartDate_DateTimePicker.DateTime));
    end
  else
    LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.EndDate_DateTimePickerKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=27 then with Terminator_SetYear_Form do
    begin
      ShowModal;
      if SetYearRequested then
        EndDate_DateTimePicker.DateTime :=
          EncodeDate(DesiredYear_LabeledNumericEdit.NumericEdit.IntegerValue,
            MonthOf(EndDate_DateTimePicker.DateTime),DayOf(EndDate_DateTimePicker.DateTime));
    end
  else
    LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Tabulate_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Memo1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Font_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ClearMemo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObserverElevation_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Abort_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ShowAll_CheckBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MinMoonElevDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxSunElevDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxCenterAngleDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.SearchTimeStepMin_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MinSunAngleDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxSunAngleDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.StartEnd_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObservatoryList_ComboBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.AddLocation_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxCenterAngle_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MinLibration_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MinLibrationDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

end.
