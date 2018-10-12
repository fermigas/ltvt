(*-----------------------------------------------------------------------*)
(* Unit TIMLIB: time and calendar calculations                           *)
(*-----------------------------------------------------------------------*)
UNIT TIMLIB;

{$H-} {use short strings by default}

INTERFACE
  uses MP_Defs, CRT_Ops, Constnts;

  const
    NormalUTCOffset : integer = 8;
    TwoDigitYear : boolean = False;  {forces yyyy format in DecodeMJD, unless set to TRUE}

  function CurrentSec: extended;
  {returns a seconds value based on the Delphi "Now" function * SecondsPerDay}

  function Str2JD(DateString: string): extended;
    {converts string in format 'mm/dd/yyyy' or 'mm/dd/yy' to Julian date;
      2-digit years are assumed to be in range 1950..2049, all others
      (1 or 3+ digits) are taken at face value}

  function Str2DecHr(const TimeString: string): extended;
    {converts string in format 'hhmm:ss.ss' to decimal hour [0..24)}

  function DecHr2Str(const DecimalHr : extended; const DecPlaces : byte) : string;
  {returns time in HHMM:SS.sss format with specified # DecPlaces in seconds}

  function Hp2DecHr(const HPFormatHour: extended): extended;
    {converts from HP 49G  HH.MMSSSSS format to decimal hour}

  procedure UpdateDecimalHour(var Hour : extended; const DecPlaces : byte;
    const Prompt : string);
  {Note:  negative entry is passed through as Hour and can be used as an
          abort flag}

  PROCEDURE DMS(DD:REAL;VAR D,M:INTEGER;VAR S:REAL);
  {converts decimal degrees (or hours) to degrees (or hours), minutes, seconds}

  PROCEDURE CALDAT  ( MJD: REAL; VAR DAY,MONTH,YEAR: INTEGER;
                      VAR HOUR: REAL );
  PROCEDURE ETMINUT ( T:  REAL; VAR DTSEC:  REAL; VAR VALID:  BOOLEAN );
  FUNCTION LMST     ( MJD,LAMBDA: REAL ): REAL;
  FUNCTION MJD      ( DAY,MONTH,YEAR: INTEGER; HOUR: REAL ): REAL;
  FUNCTION JD      ( DAY,MONTH,YEAR: INTEGER; HOUR: REAL ): REAL;

  function MJD2JD(MJD: real): real;
  {converts modified julian date to full julian date}

  function JD2MJD(JD: real): real;
  {converts full julian date to modified julian date}

  function UTCOffset(const MJD : extended): integer;
  {gives offset which must be added to local time to get UTC,
   based on local MJD (depending on daylight savings)}

  function DaylightSavings(const Day, Month, Year : integer): boolean;

procedure DecodeMJD(const MJD : real; const DecPlaces : integer;
    var DateString, TimeString : string);
{returns DateString in format bm/zd/YY or bm/zd/yyyy, where m and d are preceded,
  if necessary to give a 2-character unit, by blank and zero.  If the global variable
  TwoDigitYear is set to TRUE, then when the year is 19yy or 20yy, YY is last two
  digits, otherwise it is the full year.
  TimeString is in the format HHMM:SS.ddd  with the specified number of decimal places
  in the second}

procedure DecodeJD(const JD : real; const DecPlaces : integer;
    var DateString, TimeString : string);

function MJD_String(const MJD : real; const DecPlaces : integer): string;
{returns full string in  bm/zd/yyyy HHMM:SS.ddd format}

IMPLEMENTATION

uses Windows,  //"GetTickCount"
     SysUtils; //"Now"

function CurrentSec: extended;
{there seems little difference between these two methods}
  begin
    Result := Now*OneDay
   {Result := GetTickCount*OneMillisecond};
  end;


function Str2JD(DateString: string): extended;
  var
    Day,Month,Year,
    DividingPoint : integer;
    FirstPart, SecondPart : string;
    ShortYearFormat : boolean;

  begin {Str2JD}
    DateString := StrippedString(DateString);
    DividingPoint := pos('/',DateString);
    if DividingPoint=0 then
      HaltForError('Unable to locate first "/" in date string "'+DateString
         +'"','TIMLIB');
    FirstPart := Substring(DateString,1,DividingPoint-1);
    SecondPart := Substring(DateString,DividingPoint+1,255);
{ writeln('irst part = "',FirstPart,'"');
 writeln('second part = "',SecondPart,'"');}
    Month := IntegerValue(FirstPart);
    DividingPoint := pos('/',SecondPart);
    if DividingPoint=0 then
      HaltForError('Unable to locate second "/" in date string "'+DateString
         +'"','TIMLIB');
    FirstPart := Substring(SecondPart,1,DividingPoint-1);
    SecondPart := Substring(SecondPart,DividingPoint+1,255);
    ShortYearFormat := length(SecondPart)=2;
{ writeln('Next first part = "',FirstPart,'"');
 writeln('second part = "',SecondPart,'"');}

    Day := IntegerValue(FirstPart);
    Year := IntegerValue(SecondPart);
    if ShortYearFormat then
      begin
        if Year<50 then {2000..2049}
          Year := Year + 2000
        else {1950..1999}
          Year := Year + 1900;
      end;
{    writeln('Month = ',Month,'  Day = ',Day,'  Year = ',Year);
    pause;}
    Str2JD := JD(Day,Month,Year,0);
  end;  {Str2JD}

function Str2DecHr(const TimeString: string): extended;
  var
    FixedString : string;
    ColonPosition, i,
    Hour, Minute : integer;
    Second : extended;

    begin {Str2DecHr}
    FixedString := StrippedString(TimeString);
    ColonPosition := pos(':',FixedString);

  {allow times with no seconds part by effectively appending a colon}
    if ColonPosition=0 then  ColonPosition := length(FixedString)+1;

    for i := 1 to 5-ColonPosition do  {insert leading 0's to insure HHMM: format}
      FixedString := '0' + FixedString;
    Hour := IntegerValue(Substring(FixedString,1,2));
    Minute := IntegerValue(Substring(FixedString,3,4));
    if length(FixedString)=4 then {original string had no colon}
      Second := 0
    else
      Second := ExtendedValue(Substring(FixedString,6,255));
    Str2DecHr := Hour + (Minute + Second/60)/60;
  end;  {Str2DecHr}

function DecHr2Str(const DecimalHr : extended; const DecPlaces : byte) : string;
  var
    Secs : extended;
    Hr, Min : integer;
    S, SecString : string;
  begin
    DMS(DecimalHr+1e-10,Hr,Min,Secs); {add a small amount to insure rounding}
    S := Int2Str(Hr,0);
    if Hr<10 then S := '0'+ S;
    if Min<10 then S := S + '0';
    S := S + Int2Str(Min,0) + ':';
    SecString := Real2Str(Secs,0,DecPlaces);
    if DecPlaces=0 then
      while length(SecString)<2 do SecString := '0' + SecString
    else
      while length(SecString)<(DecPlaces+3) do SecString := '0' + SecString;
    DecHr2Str := S + SecString;
  end;

procedure UpdateDecimalHour(var Hour : extended; const DecPlaces : byte; const Prompt : string);
  var
    TimeStr : string;
    Hr, Min, DividerPos : byte;
    Secs : extended;
    HrMin, ErrorCode1, ErrorCode2 : integer;
    DividerFound : boolean;
    SecsStr: string;

  procedure LocateDividerPos;
  {entering HHMM:SS has proved inconvenient, this routine looks for
   any non-digit character as a separator between HHMM and SS}
    begin
      {DividerPos := pos(':',TimeStr);
       DividerFound := DividerPos<>0}    {old routine}
      DividerFound := false;
      TimeStr := StrippedString(TimeStr);
    {Note:  stripped string must contain at least 3 char to have a divider}
      DividerPos := 2;
      while DividerPos<length(TimeStr) do
        begin
          if (TimeStr[DividerPos]<'0') or (TimeStr[DividerPos]>'9') then
            begin
              DividerFound := true;
              exit;
            end;
          inc(DividerPos);
        end;
    end;

  begin {UpdateDecimalHour}
  repeat
    ErrorCode1 := 0;
    ErrorCode2 := 0;
    TimeStr := DecHr2Str(Hour,DecPlaces);
    UpdateStringVariable(TimeStr,Prompt+' [ . for secs only]');
    if ParameterChanged then
      begin
        LocateDividerPos;
        if DividerFound then
          begin
            val(copy(TimeStr,1,DividerPos-1),HrMin,ErrorCode1);
            val(copy(TimeStr,DividerPos+1,MaxInt),Secs,ErrorCode2);
          end
        else
	  begin

            if StrippedString(TimeStr)='.' then
        {user has entered '.' indicating he wants to update seconds only,
	  so strip HHMM part from default string}
              TimeStr := Substring(DecHr2Str(Hour,DecPlaces),1,4);

            val(TimeStr,HrMin,ErrorCode1);
            if ErrorCode1=0 then
          {User has entered a value with no seconds. He has either entered a
           negative value to abort the entry, or he may want Secs = 0,
           but check to see if he wants to input secs on a 2nd line}

              begin
                if HrMin<0 then
                  begin
                    Hour := HrMin;
                    exit;
                  end;
                Secs := 0;
                SecsStr := '0';
                UpdateStringVariable(SecsStr,'  secs');
                if ParameterChanged then
                  val(StrippedString(SecsStr),Secs,ErrorCode2);
              end;
          end;
        if (ErrorCode1=0) and (ErrorCode2=0) then
          begin
            Hr := HrMin div 100;
            Min := HrMin - 100*Hr;
            Hour := Hr + (Min*OneMinute + Secs)/OneHour;
          end
        else
          CRT_Ops.Beep; {Note:  Windows has a Beep function as well}
      end;
  until (ErrorCode1=0) and (ErrorCode2=0);
  end; {UpdateDecimalHour}

(*-----------------------------------------------------------------------*)
(* DMS: conversion of degrees and fractions of a degree                  *)
(*      into degrees, minutes and seconds                                *)
(*-----------------------------------------------------------------------*)
{this is copied from MP MATLIB unit}
PROCEDURE DMS(DD:REAL;VAR D,M:INTEGER;VAR S:REAL);
  VAR D1:REAL; 
  BEGIN
    D1:=ABS(DD);  D:=TRUNC(D1);  
    D1:=(D1-D)*60.0;  M:=TRUNC(D1);  S:=(D1-M)*60.0;
    IF (DD<0) THEN 
      IF (D>0) THEN D:=-D ELSE IF (M<>0) THEN M:=-M ELSE S:=-S;
  END;

(*----------------------------------------------------------------------*)
(* CALDAT: Finds the civil calendar date for a given value              *)
(*         of the Modified Julian Date (MJD).                           *)
(*         Julian calendar is used up to 1582 October 4,                *)
(*         Gregorian calendar is used from 1582 October 15 onwards.     *)
(*----------------------------------------------------------------------*)
PROCEDURE CALDAT(MJD:REAL; VAR DAY,MONTH,YEAR:INTEGER;VAR HOUR:REAL);
  VAR B,D,F     : INTEGER;
      JD,JD0,C,E: REAL;
  BEGIN
    JD  := MJD + 2400000.5;
       JD0 := INT(JD+0.5);              (* TURBO Pascal     *)
    IF (JD0<2299161.0)                            (* calendar:    *)
      THEN BEGIN B:=0; C:=JD0+1524.0 END          (* -> Julian    *)
      ELSE BEGIN                                  (* -> Gregorian *)
             B:=TRUNC((JD0-1867216.25)/36524.25);
             C:=JD0+(B-TRUNC(B/4))+1525.0
           END;
    D    := TRUNC((C-122.1)/365.25);          E     := 365.0*D+TRUNC(D/4);
    F    := TRUNC((C-E)/30.6001);
    DAY  := TRUNC(C-E+0.5)-TRUNC(30.6001*F);  MONTH := F-1-12*TRUNC(F/14);
    YEAR := D-4715-TRUNC((7+MONTH)/10);       HOUR  := 24.0*(JD+0.5-JD0);
  END;

(*-----------------------------------------------------------------------*)
(* ETMINUT: Difference of Ephemeris Time and Universal Time              *)
(*          (polynomial approximation valid from 1900 to 1985)           *)
(*          T:     time in Julian centuries since J2000                  *)
(*                 ( = (JD-2451545.0)/36525.0 )                          *)
(*                            |---  = JD of 12 h on 1/1/2000             *)
(*          DTSEC: DT=ET-UT in sec (only if VALID=TRUE)                  *)
(*          VALID: TRUE for times between 1900 and 1985, FALSE otherwise *)
(*                  (range extended 2/27/97)                             *)
(*-----------------------------------------------------------------------*)
PROCEDURE ETMINUT(T: REAL; VAR DTSEC: REAL; VAR VALID: BOOLEAN);
  BEGIN
    VALID := ( (-1.0<T) AND (T<1.0) );
    IF VALID THEN
      begin
        if T>-0.08 then
          DTSEC := 66.0 + 100.0*T
        else if T>-0.17 then
          DTSEC := (58.0 + 5.0*8.0/9.0) + (5.0/0.09)*T
        else {use Montenbruck and Pfleger polynomial}
          DTSEC := ((((-339.84*T-516.52)*T-160.22)*T)+92.23)*T+71.28;
      end;
  END;

(*-----------------------------------------------------------------------*)
(* LMST: local mean sidereal time                                        *)
(*-----------------------------------------------------------------------*)
FUNCTION LMST(MJD,LAMBDA:REAL):REAL;
  VAR MJD0,T,UT,GMST: REAL;
  FUNCTION FRAC(X:REAL):REAL;
    BEGIN  X:=X-TRUNC(X); IF (X<0) THEN X:=X+1; FRAC:=X  END;
  BEGIN
    MJD0:=INT(MJD);               (* TURBO Pascal     *)
    UT:=(MJD-MJD0)*24; T:=(MJD0-51544.5)/36525.0;
    GMST:=6.697374558 + 1.0027379093*UT
            +(8640184.812866+(0.093104-6.2E-6*T)*T)*T/3600.0;
    LMST:=24.0*FRAC( (GMST-LAMBDA/15.0) / 24.0 );
  END;

(*-----------------------------------------------------------------------*)
(* MJD: Modified Julian Date                                             *)
(*      The routine is valid for any date since 4713 BC.                 *)
(*      Julian calendar is used up to 1582 October 4,                    *)
(*      Gregorian calendar is used from 1582 October 15 onwards.         *)
(*-----------------------------------------------------------------------*)
FUNCTION MJD(DAY,MONTH,YEAR:INTEGER;HOUR:REAL):REAL;
  VAR A: REAL; B: INTEGER;
  BEGIN
    A:=10000.0*YEAR+100.0*MONTH+DAY;
    IF (MONTH<=2) THEN BEGIN MONTH:=MONTH+12; YEAR:=YEAR-1 END;
    IF (A<=15821004.1)
      THEN B:=-2+TRUNC((YEAR+4716)/4)-1179
      ELSE B:=TRUNC(YEAR/400)-TRUNC(YEAR/100)+TRUNC(YEAR/4);
    A:=365.0*YEAR-679004.0;
    MJD:=A+B+TRUNC(30.6001*(MONTH+1))+DAY+HOUR/24.0;
  END;

  function MJD2JD(MJD: real): real;
    begin
      MJD2JD  := MJD + MJDOffset;
    end;

  function JD2MJD(JD: real): real;
    begin
      JD2MJD  := JD - MJDOffset;
    end;

  FUNCTION JD      ( DAY,MONTH,YEAR: INTEGER; HOUR: REAL ): REAL;
    begin
      JD := MJD(DAY,MONTH,YEAR,HOUR) + MJDOffset;
    end;

procedure DecodeMJD(const MJD : real; const DecPlaces : integer;
    var DateString, TimeString : string);
  var
    M,D,Y : integer;
    Hr : real;
    MStr, DStr, YStr : string;
  begin
    CalDat(MJD,D,M,Y,Hr);
    str(M,MStr);
    if M<10 then MStr := ' ' + MStr;
    str(D,DStr);
    if D<10 then DStr := '0' + DStr;
    str(Y,YStr);
    if TwoDigitYear then
      begin
        if (copy(YStr,1,2)='19') or (copy(YStr,1,2)='20') then YStr := copy(YStr,length(YStr)-1,2);
      end;
    DateString := MStr + '/' + DStr + '/' + YStr;
    TimeString := DecHr2Str(Hr,DecPlaces);
  end;

function MJD_String(const MJD : real; const DecPlaces : integer): string;
  var
    DateString, TimeString : string;
  begin
    DecodeMJD(MJD, DecPlaces, DateString, TimeString);
    Result := DateString+' '+TimeString;
  end;

procedure DecodeJD(const JD : real; const DecPlaces : integer;
    var DateString, TimeString : string);
  var
    DesiredMJD : real;
  begin
    DesiredMJD := JD2MJD(JD);
    DecodeMJD(DesiredMJD,DecPlaces, DateString,TimeString);
  end;

function UTCOffset(const MJD : extended): integer;
  {gives offset which must be added to local time to get UTC,
   based on local MJD}
  var
    Day, Month, Year : integer;
    Hour : extended;
  begin
    CalDat(MJD,Day,Month,Year,Hour);
    if DaylightSavings(Day,Month,Year) then
      UTCOffset := NormalUTCOffset - 1
    else
      UTCOffset := NormalUTCOffset;
  end;

function DaylightSavings(const Day, Month, Year : integer): boolean;
{Daylight Savings begins on first Sunday in April and ends on last Sunday
 in October}
  function FirstSundayMJD(const Month : integer): longint;
    var
      StartMJD : longint;
      StartDayOfWeek : integer;
    begin
      StartMJD := round(MJD(1,Month,Year,0));
    {following returns 0..6 for Sun..Sat}
      StartDayOfWeek := (StartMJD + 3) mod 7;
      if StartDayOfWeek=0 then
        FirstSundayMJD := StartMJD
      else
        FirstSundayMJD  := StartMJD + (7 - StartDayOfWeek);
    end;

  begin {DaylightSavings}
    if Year<2007 then
      case Month of
        1..3, 11..12 : DaylightSavings := false;
        5..9 : DaylightSavings := true;
        4 : DaylightSavings := (round(MJD(Day,Month,Year,0)) - FirstSundayMJD(4)) >= 0;
        10 : DaylightSavings := (round(MJD(Day,Month,Year,0)) - (FirstSundayMJD(11) - 7)) < 0;
        else
          HaltForError('Illegal month = '+Int2Str(Month,0)+' in DaylightSavings routine','TIMLIB');
      end
    else  // added Mar 12, 2007 for new daylight savings rules that started Mar 11
      case Month of
        1..2, 12 : DaylightSavings := false;
        4..10 : DaylightSavings := true;
        3 : DaylightSavings := (round(MJD(Day,Month,Year,0)) - (FirstSundayMJD(3)+7)) >= 0;
        11 : DaylightSavings := (round(MJD(Day,Month,Year,0)) - (FirstSundayMJD(11))) < 0;
        else
          HaltForError('Illegal month = '+Int2Str(Month,0)+' in DaylightSavings routine','TIMLIB');
      end;
  end;  {DaylightSavings}

function Hp2DecHr(const HPFormatHour: extended): extended;
{converts from HP 49G  HH.MMSSSSS format to decimal hour}
  var
    Hour, Minute, Secs : extended;
  begin
    Hour := int(HPFormatHour);
    Minute := int(100*frac(HPFormatHour));
    Secs := 100*(frac(100*HPFormatHour));
    Hp2DecHr := Hour + (Minute + Secs/60)/60;
  end;

END.


