unit H_PhotosessionSearch_Unit;
{
v1.4:
  1. Added box for observer elevation.
  2. Reduce tabulation to two shades of gray (Moon up or Moon down).

v0.0: (= v1.5 renamed)
  1. Corrected JPL routine so it can silently cross 50-year boundaries.
  2. Corrected Sub-observer point lon/lat display (librations) which was reversed!

v0.3
  1. Allow comment lines in .csv file

v0.4  
  1. Improved longitude/latitude tooltips to indicate E=+ W=- N=+ S = -.

v0.5
  1. In tabulation an ExtractFilename() is now applied to the File Description
     to make this more compatible with the Photo Calibration data file.

v0.6
  1. Add Abort button and "search completed" messages.

                                                                   3/6/09}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, StdCtrls, ComCtrls, Math, DateUtils, ExtCtrls,
  H_JPL_Ephemeris, MoonPosition, Constnts, {TimLib,} MP_Defs, Win_Ops, FileCtrl;

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
    SolarLatitude_LabeledNumericEdit: TLabeledNumericEdit;
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
  private
    { Private declarations }
  public
    { Public declarations }
    ObsNameList, ObsLatList, ObsLonList, ObsElevList : TStrings;

    AbortTabulation : Boolean;

    PSS_JPL_Filename, PSS_JPL_Path, PhotoSessionsFilename : string;

    SubSolarPoint : TPolarCoordinates;
    SolarColongitude : extended;  {in rad}

    function EW_Tag(const Longitude : extended): string;
    {returns 'E' or 'W'}

    function NS_Tag(const Latitude : extended): string;
    {returns 'N' or 'S'}

    function JPL_File_Valid(const Desired_MJD : extended) : boolean;
    {returns true if Desired_MJD falls within range of current ephemeris file;
      if not attempts to load the appropriate file}

    procedure CalculateSolarColongitude(const MJD_for_CL :extended);  {UT MJD}

    procedure RefreshSelection;

  end;

var
  PhotosessionSearch_Form: TPhotosessionSearch_Form;

implementation

uses NumericEdit, LTVT_Unit, H_Terminator_SetYear_Unit;

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

  if not Terminator_Form.LinuxCompatibilityMode then Date_DateTimePicker.MinDate := EncodeDateDay(1601,1);

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
          if FileExists(Terminator_Form.ObservatoryListFilename) then
            begin
              ObservatoryList_ComboBox.ItemIndex := -1;
              ObservatoryList_ComboBox.Text := Terminator_Form.ObservatoryComboBoxDefaultText;
            end
          else
            begin
              ObservatoryList_ComboBox.ItemIndex := -1;
              ObservatoryList_ComboBox.Text := Terminator_Form.ObservatoryNoFileText;
            end
        end;
    end;
end;

procedure TPhotosessionSearch_Form.ObservatoryList_ComboBoxSelect(
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
begin
  if (ObservatoryList_ComboBox.Text=Terminator_Form.ObservatoryNoFileText) or
     (ObservatoryList_ComboBox.Text=Terminator_Form.ObservatoryComboBoxDefaultText) then
    begin
      ShowMessage('Please enter a name for the site in the drop-down box');
      Exit;
    end;

  AssignFile(ObsListFile,Terminator_Form.ObservatoryListFilename);

  if FileExists(Terminator_Form.ObservatoryListFilename) then
    begin
      Append(ObsListFile);
    end
  else
    begin
      Rewrite(ObsListFile);
      Writeln(ObsListFile,'* List of observatory locations for LTVT');
      Writeln(ObsListFile,'*   Important:  use ''.'' (period) for decimal point');
      Writeln(ObsListFile,'*   (blank lines and lines with ''*'' in first column are ignored)');
      Writeln(ObsListFile,'*   The observatory name can include any characters, including commas');
      Writeln(ObsListFile,'');
      Writeln(ObsListFile,'* List items in this format (using commas to separate items):');
      Writeln(ObsListFile,'* ObservatoryEastLongitude, ObservatoryNorthLatitude, ObservatoryElevation_meters, ObservatoryName');
      Writeln(ObsListFile,'');
    end;

  Writeln(ObsListFile,
    ObserverLongitude_LabeledNumericEdit.NumericEdit.Text+', '+
    ObserverLatitude_LabeledNumericEdit.NumericEdit.Text+', '+
    ObserverElevation_LabeledNumericEdit.NumericEdit.Text+', '+
    ObservatoryList_ComboBox.Text);
  CloseFile(ObsListFile);

  ObsLonList.Add(ObserverLongitude_LabeledNumericEdit.NumericEdit.Text);
  ObsLatList.Add(ObserverLatitude_LabeledNumericEdit.NumericEdit.Text);
  ObsElevList.Add(ObserverElevation_LabeledNumericEdit.NumericEdit.Text);
  ObsNameList.Add(Trim(ObservatoryList_ComboBox.Text));
  ObservatoryList_ComboBox.Items.Add(Trim(ObservatoryList_ComboBox.Text));

  ShowMessage('Location added to '+Terminator_Form.ObservatoryListFilename);
end;

function TPhotosessionSearch_Form.EW_Tag(const Longitude : extended): string;
  begin
    if Longitude>=0 then
      Result := 'E'
    else
      Result := 'W';
  end;

function TPhotosessionSearch_Form.NS_Tag(const Latitude : extended): string;
  begin
    if Latitude>=0 then
      Result := 'N'
    else
      Result := 'S';
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
      Memo1.Lines.Add('Lunar lighting conditions calculated for:  '+
        Terminator_Form.CorrectedDateTimeToStr(ModifiedJulianDateToDateTime(UT_MJD))+' UT');

      Colongitude_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(SolarColongitude)]);
      SolarLatitude_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubSolarPoint.Latitude)]);

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
  begin
    SubSolarPoint := SubSolarPointOnMoon(MJD_for_CL);

    SolarColongitude := PiByTwo - SubSolarPoint.Longitude;
    while SolarColongitude>TwoPi do SolarColongitude := SolarColongitude - TwoPi;
    while SolarColongitude<0     do SolarColongitude := SolarColongitude + TwoPi;

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

  MJD, TargetSolarElevation, {angles in rad}
  TargetCL, CL_Error,
  CraterLonDeg, CraterLatDeg, SunAngleDeg,
  AllowableColongitudeErrorDegrees, AllowableSunElevationErrorDegrees : Extended;

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
      Memo1.Lines.Add(Format('Librations calculated for observer at %0.4f %s  %0.4f %s  %0.0f m',
        [Abs(-ObserverLongitude),EW_Tag(-ObserverLongitude),Abs(ObserverLatitude),NS_Tag(ObserverLatitude),
         ObserverElevation]));
    Memo1.Lines.Add('');
    if ColongitudeMode_RadioButton.Checked then
      begin
        Memo1.Lines.Add('                          Terminators      Sub-Solar Point     Librations');
        Memo1.Lines.Add('   Date      Time UT   Morning   Evening    Colong    Lat.    Long.   Lat.    Photo Name');
      end
    else
      begin
        Memo1.Lines.Add('                           Sun Angle       Sub-Solar Point     Librations ');
        Memo1.Lines.Add('   Date      Time UT   Altitude  Azimuth    Colong    Lat.    Long.   Lat.     Photo Name');
      end;
  end;

procedure PrintData;
  var
    SunPosition, MoonPosition : PositionResultRecord;
    MoonUpSunDownCode, TargetVisibleCode : String;
    CraterLat, CraterLon, SunLat, SunLon, AngleToSun, SolarElevation, SolarAzimuth : Extended;
    TargetDistance, TargetAzimuth : Extended;
    CL, MT, ET : extended;
    PrintDateTime : TDateTime;
    SubEarthPoint : TPolarCoordinates;

  begin {PrintData}
  if JPL_File_Valid(MJD) then
    begin
      CalculateSolarColongitude(MJD);

      CL_Error := TargetCL - SolarColongitude;
      while CL_Error>Pi  do CL_Error := CL_Error - TwoPi;
      while CL_Error<-Pi do CL_Error := CL_Error + TwoPi;

      SubEarthPoint := SubEarthPointOnMoon(MJD);
      while SubEarthPoint.Longitude>Pi do SubEarthPoint.Longitude := SubEarthPoint.Longitude - TwoPi;

      CalculatePosition(MJD,Moon,BlankStarDataRecord,MoonPosition);
      CalculatePosition(MJD,Sun, BlankStarDataRecord,SunPosition);

      if (MoonPosition.TopocentricAlt>0) and (SunPosition.TopocentricAlt<0) and not GeocentricSubEarthMode then
        MoonUpSunDownCode := MoonUpSunDownSymbol
      else
        MoonUpSunDownCode := ' ';

      CL := RadToDeg(SolarColongitude);

      ET := 180 - CL;
      MT := -CL;
      if MT<-180 then MT := MT + 360;

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

          ComputeDistanceAndBearing(SubEarthPoint.Longitude, SubEarthPoint.Latitude, CraterLon, CraterLat, TargetDistance, TargetAzimuth);
          if TargetDistance<PiByTwo then
            TargetVisibleCode := TargetVisibleSymbol
          else
            TargetVisibleCode := ' ';

          if Abs(RadToDeg(SolarElevation-TargetSolarElevation))<AllowableSunElevationErrorDegrees then
            begin
              Memo1.Lines.Add(Format('%10s%10s%10.4f%10.4f%10.3f%8.3f%8.3f%8.3f %1s%1s  %30.30s',
                [DateToStr(PrintDateTime),TimeToStr(PrintDateTime),RadToDeg(SolarElevation),
                RadToDeg(SolarAzimuth),CL,RadToDeg(SubSolarPoint.Latitude),
                RadToDeg(SubEarthPoint.Longitude),RadToDeg(SubEarthPoint.Latitude),
                TargetVisibleCode,MoonUpSunDownCode,FileDescription]));
              Inc(LinesPrinted);
            end;
        end
      else
        begin
          if Abs(RadToDeg(CL_Error))<AllowableColongitudeErrorDegrees then
            begin
              Memo1.Lines.Add(Format('%10s%10s%9.3f%1s%9.3f%1s%10.3f%8.3f%8.3f%8.3f %1s  %30.30s',
                [DateToStr(PrintDateTime),TimeToStr(PrintDateTime),Abs(MT),EW_Tag(MT),Abs(ET),EW_Tag(ET),
                CL,RadToDeg(SubSolarPoint.Latitude),
                RadToDeg(SubEarthPoint.Longitude),RadToDeg(SubEarthPoint.Latitude),
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

      Memo1.Lines.Add(Format('Searching for Colong = %0.3f +/- %0.3f deg',
        [RadToDeg(TargetCL),AllowableColongitudeErrorDegrees]));
    end
  else {Altitude mode}
    begin
      CraterLonDeg := Crater_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue;
      CraterLatDeg := Crater_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue;
      SunAngleDeg  := SunAngle_LabeledNumericEdit.NumericEdit.ExtendedValue;

      TargetSolarElevation := DegToRad(SunAngleDeg);
      AllowableSunElevationErrorDegrees := Abs(SunElevationTolerance_LabeledNumericEdit.NumericEdit.ExtendedValue);

      Memo1.Lines.Add(Format('Searching for Sun Angle = %0.4f  +/- %0.3f deg over feature at %0.3f %s   %0.3f %s',
        [SunAngleDeg,AllowableSunElevationErrorDegrees,Abs(CraterLonDeg),EW_Tag(CraterLonDeg),Abs(CraterLatDeg),NS_Tag(CraterLatDeg)]));
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

      Memo1.Lines.Add('In: '+PhotoSessionsFilename);
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

      if not GeocentricSubEarthMode then Memo1.Lines.Add(Format('  %s = Moon above horizon/Sun below horizon',[MoonUpSunDownSymbol]));
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
  if FileExists(Terminator_Form.ObservatoryListFilename) then
    begin
      AssignFile(ObsListFile,Terminator_Form.ObservatoryListFilename);
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
              ObsNameList.Add(Trim(DataLine));
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
    Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Time_DateTimePickerKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.CalculateCircumstances_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ColongitudeMode_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAngleMode_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Colongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SolarLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ColongitudeTolerance_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Crater_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Crater_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAngle_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunAzimuth_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.SunElevationTolerance_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.GeocentricObserver_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObserverElevation_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Tabulate_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Memo1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Font_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ClearMemo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ChangeFile_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.Abort_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.ObservatoryList_ComboBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

procedure TPhotosessionSearch_Form.AddLocation_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'PhotosessionsSearchForm.htm');
end;

end.
