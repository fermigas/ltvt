unit LibrationTabulator_Unit;
{
v0.0:
  1. Copy from Moon Event Predictor
                                                          10/13/07}

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
    Label2: TLabel;
    MaxCenterAngleDeg_LabeledNumericEdit: TLabeledNumericEdit;
    MaxSunAngleDeg_LabeledNumericEdit: TLabeledNumericEdit;
    Abort_Button: TButton;
    ShowAll_CheckBox: TCheckBox;
    SearchTimeStepMin_LabeledNumericEdit: TLabeledNumericEdit;
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
  private
    { Private declarations }
  public
    { Public declarations }
    AbortTabulation : Boolean;

    MEP_JPL_Filename, MEP_JPL_Path : string;

    function JPL_File_Valid(const Desired_MJD : extended) : boolean;
    {returns true if Desired_MJD falls within range of current ephemeris file;
      if not attempts to load the appropriate file}


  end;

var
  LibrationTabulator_Form: TLibrationTabulator_Form;

implementation

uses NumericEdit, LTVT_Unit, H_Terminator_SetYear_Unit;

{$R *.dfm}

procedure TLibrationTabulator_Form.FormCreate(Sender: TObject);
begin
  MEP_JPL_Filename := 'UNXP2000.405'; //overwritten by calling program
  MEP_JPL_Path := '';

  if not Terminator_Form.LinuxCompatibilityMode then
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

end;

procedure TLibrationTabulator_Form.FormShow(Sender: TObject);
begin
//  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:nn:ss';
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  ObserverLocation_GroupBox.Visible := not GeocentricObserver_CheckBox.Checked;
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
  StartMJD, EndMJD, MJDStep, CurrentMJD, MinMJD, MinCenterAngle,
  CraterLat, CraterLon, MinSunAngle, MaxSunAngle, MinMoonElevDeg, MaxSunElevDeg,  // all in radians
  CenterAngle, CenterAngleAz, SunAngle, SunAngleAz, MaxCenterAngle : Extended;

procedure CalculateCircumstances(const MJD: Extended);
  begin
    SubSolarPoint := SubSolarPointOnMoon(MJD);
    ComputeDistanceAndBearing(CraterLon, CraterLat, SubSolarPoint.Longitude, SubSolarPoint.Latitude, SunAngle, SunAngleAz);
    SunAngle := PiByTwo - SunAngle;

    SubEarthPoint := SubEarthPointOnMoon(MJD);
    ComputeDistanceAndBearing(SubEarthPoint.Longitude, SubEarthPoint.Latitude, CraterLon, CraterLat, CenterAngle, CenterAngleAz);

    CalculatePosition(MJD,Moon,BlankStarDataRecord,MoonPosition);
    CalculatePosition(MJD,Sun, BlankStarDataRecord,SunPosition);

    CriteriaValid := (SunAngle>=MinSunAngle)
                 and (SunAngle<=MaxSunAngle)
                 and (MoonPosition.TopocentricAlt>=MinMoonElevDeg)
                 and (SunPosition.TopocentricAlt<MaxSunElevDeg)
                 and (CenterAngle<=MaxCenterAngle);
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
      Memo1.Lines.Add(Format('Librations and Moon/Sun positions calculated for observer at %0.4f %s  %0.4f %s  %0.0f m',
        [Abs(-ObserverLongitude),EW_Tag(-ObserverLongitude),Abs(ObserverLatitude),NS_Tag(ObserverLatitude),ObserverElevation]));
    Memo1.Lines.Add(Format('Center Distance and Sun Angle calculated for feature at %0.4f %s  %0.4f %s',
      [Abs(RadToDeg(CraterLon)),EW_Tag(RadToDeg(CraterLon)),Abs(RadToDeg(CraterLat)),NS_Tag(RadToDeg(CraterLat))]));
    Memo1.Lines.Add('');
    if GeocentricSubEarthMode then
      begin
        Memo1.Lines.Add('                        Center        Sun Angle          Librations');
        Memo1.Lines.Add('   Date      Time UT   Distance   Altitude  Azimuth     Long.   Lat.');
      end
    else
      begin
        Memo1.Lines.Add('                        Center        Sun Angle          Librations      Center of Moon      Center of Sun');
        Memo1.Lines.Add('   Date      Time UT   Distance   Altitude  Azimuth     Long.   Lat.      Alt.     Azi.       Alt.     Azi');
      end;
  end;  {PrintHeader}

procedure PrintData;
  var
    PrintDateTime : TDateTime;

  begin {PrintData}
    PrintDateTime := ModifiedJulianDateToDateTime(MinMJD);

    while SubEarthPoint.Longitude>Pi do SubEarthPoint.Longitude := SubEarthPoint.Longitude - TwoPi;

    if GeocentricSubEarthMode then
      Memo1.Lines.Add(Format('%10s%10s%11.4f%11.4f%8.3f%10.3f%8.3f',
        [DateToStr(PrintDateTime),TimeToStr(PrintDateTime), RadToDeg(CenterAngle),
        RadToDeg(SunAngle), RadToDeg(SunAngleAz),
        RadToDeg(SubEarthPoint.Longitude),RadToDeg(SubEarthPoint.Latitude)]))
    else
      Memo1.Lines.Add(Format('%10s%10s%11.4f%11.4f%8.3f%10.3f%8.3f%10.3f%10.3f%10.3f%10.3f',
        [DateToStr(PrintDateTime),TimeToStr(PrintDateTime), RadToDeg(CenterAngle),
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

  LinesPrinted := 0;

  PrintHeader;

  CurrentMJD := StartMJD;
  AbortTabulation := False;

  while (CurrentMJD<=EndMJD) and not AbortTabulation do
    begin
      CalculateCircumstances(CurrentMJD);

      if ShowAll_CheckBox.Checked then
        begin
          MinMJD := CurrentMJD;
          PrintData;
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
              CalculateCircumstances(MinMJD);
              if CriteriaValid then PrintData;
            end;
        end;

      Application.ProcessMessages;   // check for Abort request
    end;

  if LinesPrinted>0 then
    begin
      Memo1.Lines.Add('');
    end
  else
    begin
      Memo1.Lines.Add('');
      Memo1.Lines.Add('               *** no events found ***');
    end;

  if AbortTabulation then
      Memo1.Lines.Add('                (tabulation aborted)');

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
end;

procedure TLibrationTabulator_Form.GeocentricObserver_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Crater_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Crater_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
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
    Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
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
    Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Tabulate_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Memo1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Font_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ClearMemo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ObserverElevation_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.Abort_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.ShowAll_CheckBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MinMoonElevDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxSunElevDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxCenterAngleDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.SearchTimeStepMin_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MinSunAngleDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

procedure TLibrationTabulator_Form.MaxSunAngleDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'LibrationTabulatorForm.htm');
end;

end.
