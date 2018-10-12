unit H_ClockError;
{Reduced version for use with H_Terminator.  9/12/06}

interface

type
{Note: a LinearCalFile is a two column text file representing clock calibration data.
 The first column is the Modified Julian Data (MJD) of the calibration and the
 second column is the result (Clock Error). The columns must be separated by at
 least one space or tab character.  Preceeding and trailing blanks are ignored.
 Lines containing a '*' in Column 1 are treated as comments and skipped over without
 processing.

 The listed clock error is assumed to be valid until the next entry, unless
 InterpolateCalFileData = True (in which case an interpolated value is returned.
 A drift rate can also be specified for returning a more accurate estimate of
 the clock error at a time between calibrations.

 Modified 3/11/04:  old convention had been to return -999 as the 'ClockError'
  for times beyond the last calibration.  This has proved cumbersome.  Changed
  convention to returning value based on last calibration, but with added
  ErrorCode = 1, as explained below.  For times before the first calibration a value
  of 0 is returned with ErrorCode = 2.

 Modified 4/18/06:  allow arbitrary number of columns, ignoring those beyond first two.

 11/21/06 :
   1. Initialize Filename to '' (blank string)
   2. Ensure Filename = '' if SetFile fails.
 }

  TLinearCalFile = object
    FileName : string;
    FileLoaded : boolean;
    DataFile : text;
    DriftRate : extended;
    LastRequestedMJD : extended;
    FirstCalMJD : extended;
    OldCalMJD : extended;
    NewCalMJD : extended;
    OldCalCE : extended;
    NewCalCE : extended;
    InterpolateCalFileData : boolean;
    ErrorCode : integer; {0 = valid result; 1 = requested time after last cal;
      2 = requested time before first cal}
    DefaultValue : extended;  // returned if not FileLoaded

    procedure Init(const DefaultReturnValue : extended);
    procedure SetFile(const DataFileName : string);
    function ClockError(const Month,Day,Year: integer; const Hour: extended): extended;
    {original access function -- required translating to desired MJD on each call}
    function MJDClockError(const RequestedMJD : extended) : extended;
    {new access function -- avoids translation}
  end;

var
  WWVCalFile, TAIOffsetFile : TLinearCalFile;

function IERS_DUT(const Month,Day,Year: integer; const Hour: extended): extended; overload;
{returns difference UT1-UTC (in seconds) interpolated from International Earth Rotation Service
 data -- UT1 indicates the current rotation angle of the Earth and is used to
 compute sidereal time}

function IERS_DUT(const UTC_MJD: extended): extended; overload;
{same as preceding}

function TDT_Offset(const UTC_MJD: extended): extended;
{returns number of seconds that need to be added to UTC to obtain Terrestrial
 Dynamic Time = 32.184 + accumulated leap seconds;  TDT is very close to
 TBD = Barycentric Dynamic Time, the time parameter used in the ephemeris.
 The source table has been extended to include estimated fractional leap second
 values for years <1972 based on a table of historic Delta-T values.  In these
 cases, the returned TDT_Offset should be added to the reported UT1 clock time
 to obtain Ephemeris Time (approx. same as TDT).  Since Delta-T changes
 continuously, results are interpolated IFF date is <1972.
 See MyProjects\Astron\UTCtoTAI\HistoricDeltaT_OffsetsFile.dpr , the output from
 which was added to C:\PROJ\ASTRON\TIMER\TAI_Offset_Data.txt.
 By contrast, the >=1972 changes come is discrete 1 sec steps valid until the
 next leap second so they are not interpolated.}

implementation

uses Win_Ops, TimLib, Constnts, SysUtils, Dialogs;

const
  InvalidMJD = -1e9;

procedure TLinearCalFile.Init(const DefaultReturnValue : extended);
  begin
    FileName := '';
    FileLoaded := False;
    DefaultValue := DefaultReturnValue;
    DriftRate := 0;
    LastRequestedMJD := InvalidMJD;
    FirstCalMJD := InvalidMJD;
    OldCalMJD := InvalidMJD;
    NewCalMJD := InvalidMJD;
    OldCalCE := 0;
    NewCalCE := 0;
    InterpolateCalFileData := false;
    ErrorCode := 0;
  end;

procedure TLinearCalFile.SetFile(const DataFileName : string);
  begin
    if FileFound('Time Offsets Calibration File',DataFilename,Filename) then
      begin
        AssignFile(DataFile,Filename);
        Reset(DataFile);
        FileLoaded := True;
      end
    else
      begin
        Filename := '';
        FileLoaded := False;
      end;
  end;

function TLinearCalFile.ClockError(const Month,Day,Year: integer; const Hour: extended): extended;
var
  RequestedMJD : extended;

  begin
    RequestedMJD := MJD(Day,Month,Year,Hour);
    Result := MJDClockError(RequestedMJD);
  end;

function TLinearCalFile.MJDClockError(const RequestedMJD : extended) : extended;
{This routine was originally intended for reading the file created by
 MDRIFT2.PAS, which lists the MJD Time and best guess ClockError at each
 Macintosh reset.  The best guess ClockError after any reset, and up to the
 next reset, is obtained by adding a drift correction to the initial error.
 The ClockError returned by this routine should be SUBTRACTED from the
 recorded time to obtain the best guess WWV (UTC) time at the moment the
 event was recorded.

 The same routine can be used to estimate the <CDEV> of the HP 49G calculator
 based on a similar file which contains a series of MJD times and measured
 <CDEV>'s .  The HP clock is effectively on continuously, and the drift
 between calibrations is generally less than the uncertainty in the
 measurements -- so it will be assumed that a measured <CDEV> applies
 exactly from the time it is made up to the time of the next calibration.}

var
  DataFound : boolean;

function ValidData : boolean;
  begin
    ValidData := ((RequestedMJD>=OldCalMJD) and (RequestedMJD<NewCalMJD))
  end;

procedure ProcessDataFileLine;
  const
    Tab = chr(9);
  var
    DataFileLine : string;
  begin {ProcessDataFileLine}
    DataFound := false;
    system.readln(DataFile,DataFileLine);
{    writeln('Reading: "',Substring(DataFileLine,1,65),'"');}
    if Substring(DataFileLine,1,1)<>'*' then
      begin {process all non-comment lines}
        DataFound := true;
        OldCalMJD := NewCalMJD;
        OldCalCE := NewCalCE;
      {check if item delimiter is space or tab}
        if pos(Tab,DataFileLine)<>0 then
          NewCalMJD := ExtendedValue(LeadingElement(DataFileLine,Tab))
        else
          NewCalMJD := ExtendedValue(LeadingElement(DataFileLine,' '));

//        NewCalCE := ExtendedValue(DataFileLine);

        if pos(Tab,DataFileLine)<>0 then
          NewCalCE := ExtendedValue(LeadingElement(DataFileLine,Tab))
        else
          NewCalCE := ExtendedValue(LeadingElement(DataFileLine,' '));

{        writeln('  CalMJD = ',NewCalMJD:0:6,'   CalCE = ',NewCalCE:0:4);}
{    pause;}
       end
  end;  {ProcessDataFileLine}

begin {MJDClockError}
{  writeln;}

{  writeln('RequestedMJD = ',RequestedMJD:0:5,' OldCalMJD = ',OldCalMJD:0:5,
    ' NewCalMJD = ',NewCalMJD:0:5,'  ValidData = ',ValidData);}

  if not FileLoaded then
    begin
      Result := DefaultValue;
//      ShowMessage('Missing linear cal file: '+FileName);
      Exit;
    end;
  if (LastRequestedMJD=InvalidMJD) or ((not ValidData) and (RequestedMJD<LastRequestedMJD)) then
    begin
 {     writeln('Resetting "',DataFileName,'"');}
      reset(DataFile);
      FirstCalMJD := InvalidMJD;
      NewCalMJD   := InvalidMJD;
      NewCalCE := 0;
      DataFound := false;
      while (not DataFound) and (not EOF(DataFile)) do
        begin
          ProcessDataFileLine;  {1st line}
          if DataFound then
            begin
              FirstCalMJD := NewCalMJD;
              DataFound := false;
              while (not DataFound) and (not EOF(DataFile)) do ProcessDataFileLine;  {2nd line, establishes 1st valid interval}
            end;
        end;
    end;

  LastRequestedMJD := RequestedMJD;

  if (FirstCalMJD=InvalidMJD) or (RequestedMJD<FirstCalMJD) then
    begin
      Result := 0;  {observations prior to Mac are with Timex watch set to WWV}
      ErrorCode := 2;
      exit;
    end;

  while (not ValidData) and (not EOF(DataFile)) do ProcessDataFileLine;

  if ValidData then
    begin {calibrations found before and after requested date -- use the preceding one}
      if InterpolateCalFileData then
        begin
          if NewCalMJD=OldCalMJD then
            Result := (OldCalCE + NewCalCE)/2
          else
            Result := OldCalCE + (NewCalCE - OldCalCE)*(RequestedMJD - OldCalMJD)/(NewCalMJD - OldCalMJD);
        end
      else
        Result := OldCalCE + (RequestedMJD - OldCalMJD)*DriftRate;
      ErrorCode := 0
    end
  else {requested date after last calibration -- use last calibration}
    begin
      Result := NewCalCE + (RequestedMJD - NewCalMJD)*DriftRate;
      ErrorCode := 1;
    end;

end;  {MJDClockError}

function IERS_DUT(const Month,Day,Year: integer; const Hour: extended): extended;
{returns difference UT1-UTC from International Earth Rotation Service data}
  begin
    IERS_DUT := WWVCalFile.ClockError(Month,Day,Year,Hour);
  end;

function IERS_DUT(const UTC_MJD: extended): extended;
  begin
    Result := WWVCalFile.MJDClockError(UTC_MJD);
  end;

function TDT_Offset(const UTC_MJD: extended): extended;
  begin
    if UTC_MJD<41317.0 then
      TAIOffsetFile.InterpolateCalFileData := true
    else
      TAIOffsetFile.InterpolateCalFileData := false;
    Result := TAIOffsetFile.MJDClockError(UTC_MJD) + 32.184;
  end;

begin {ClockERR}
//  WWVDataFileName := 'C:\PROJ\ASTRON\TIMER\IERS_DUT_Data.txt';
//  TAIOffsetDataFileName := 'C:\PROJ\ASTRON\TIMER\TAI_Offset_Data.txt';
  WWVCalFile.Init(0);  {contains DUT values on arbitrary dates, from IERS}
  WWVCalFile.InterpolateCalFileData := true;
  TAIOffsetFile.Init(33);
//  TAIOffsetFile.SetFile('C:\PROJ\ASTRON\TIMER\TAI_Offset_Data.txt');
end.  {ClockERR}

