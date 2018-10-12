unit Win_Ops;
{performs non-CRT related operations formerly implemented in CRT_Ops

Changes:
  9/13/2006--
    1. Change HaltOnError so it gives a ShowMessage, rather than Exit(ing)
       program.
    2. Added a PictureFileFound function.

  9/26/2006--
    1. Add code to ExtendedValue() to replace commas with decimal points.

                                                                     }

 interface
   const
     Tab = char(9);
     CR = char(13);
     LF = char(10);
     CtrlZ = char(26);
     Escape = char(27);


   function Int2Str(L : LongInt; FieldWidth : integer) : string;
   function Real2Str(E : extended; FieldWidth, DecPlaces : integer) : string;
{Converts real number to string for use with OutText or OutTextXY.
 If FieldWidth<0 the result is in format '-n.dddE+pppp' with DecPlaces
 specifying the number of d's and abs(FieldWidth) the (minimum) number of p's.
 For compatability with an older version DecPlaces<0 generates '-n.dddE+pp'
 with the value of DecPlaces being ignored and d's being added to pad the
 string to total length = FieldWidth.}

   function ThousandsStringToExtended(InputString : string): extended;
{returns value of a Delphi 'f*.*n' formatted number with ThousandSeparator --
 the Delphi 'val()' and 'StrToFloat()' functions cannot handle them, reading just
 the number up to the first ','}

   function Floor(X : extended): longint;
   function Ceiling(X : extended): longint;
   function RoundUp(X, XInt : extended): extended;
   function RoundDown(X, XInt : extended): extended;
   function Log10(X: extended): extended;
   function AntiLog10(X: extended): extended;
   function DecimalInterval(XMin, XMax : extended): extended;
    {returns "even" decimal fraction of an interval -- eg. 1.0 for 53-57;
      100 for 5300-5700;  and 0.01 for 0.53-0.57}

   procedure Swap(var A, B; NumBytes: word);

   function DateString : string;
   function TimeString : string;

   procedure ClearVariable(var VarToClear; const Size: word);

   function NonBlankString(S: string): boolean;
   procedure ConvertToUpperCase(var S: string);
   function UpperCaseString(S: string) : string;
   function Substring(const S: string; const StartCol, EndCol : integer): string;
   procedure RemoveTrailingBlanks(var InputString: string);
   procedure RemoveBlanks(var S: string);  {removes ALL blanks, including internal}
   function StrippedString(S: string): string;
     {returns string stripped of leading and trailing blanks and tabs}
   function FixedLengthString(S:string; const DesiredLength: integer):string;
     {truncates or adds trailing blanks to bring length to DesiredLength}
   function LeadingElement(var StringToProcess: string; const DividingChars: string): string;
     {LeadingElement = first segment up to DividingChars and stripped of
      leading blanks and tabs;  StringToProcess = remainder of string beyond
      DividingChars stripped of trailing blanks
      Note: if DividingChars is NOT found, full string is returned and
      StringToProcess is set to null}
   function LeadingTabbedElement(var StringToProcess: string): string;
     {same except it uses the Tab character as the DividingChars}
   function IntegerValue(StringToConvert: string): integer;
   function LongIntValue(StringToConvert: string): longint;
   function ExtendedValue(StringToConvert: string): extended;

   function ExtendedToReal(const V: extended): real;
   function ExtendedToSingle(const V: extended): single;

   function FileFound(const Description, TrialFilename : string; var CorrectFilename : string): boolean;
     {checks to see if TrialFilename exists; if not, launches OpenDialog window
     with Description as heading allowing user to find file.  Returns TRUE with
     CorrectFilename = TrialFilename or file selected by user; otherwise false}

   function PictureFileFound(const Description, TrialFilename : string; var CorrectFilename : string): boolean;
     {same as FileFound, but with OpenDialog declared as TOpenPictureDialog, which gives a
     graphic preview, and the default choice of photo extensions allowed}

   procedure HaltForError(ErrorMessage, UnitID : string);

   procedure Pause;


implementation
uses Windows, Dialogs, ExtDlgs, SysUtils, DateUtils;

{Note: functions "Floor" .. "RoundDown" were formerly in GRAPHOPS unit}

function Floor(X : extended): longint;
{returns 1st integer <= X;  due to rounding errors it is possible that, e.g.,
 Floor(1.000..) = 0.  Depending on use, application should adjust X or
 check that it is not already sufficiently close to an integer before
 calling Floor(X)}
  begin
    Floor := round(X - 0.5)
  end;

function Ceiling(X : extended): longint;
{returns 1st integer >= X;  due to rounding errors it is possible that, e.g.,
 Ceiling(1.000..) = 2.  Depending on use, application should adjust X or
 check that it is not already sufficiently close to an integer before
 calling Ceiling(X)}

  begin
    Ceiling := round(X + 0.5)
  end;

function Int2Str(L : LongInt; FieldWidth : integer) : string;
{converts integer to string for use with OutText or OutTextXY}
  var
    S : string;
  begin
    str(L:FieldWidth, S);
    Int2Str := S
  end;

function Real2Str(E : extended; FieldWidth, DecPlaces : integer) : string;
{Converts real number to string for use with OutText or OutTextXY.
 If FieldWidth<0 the result is in format '-n.dddE+pppp' with DecPlaces
 specifying the number of d's and abs(FieldWidth) the (minimum) number of p's.
 For compatability with an older version DecPlaces<0 generates '-n.dddE+pp'
 with the value of DecPlaces being ignored and d's being added to pad the
 string to total length = FieldWidth.}
  var
    S : string;
    EPos, NumExponents : integer;
  begin
    if DecPlaces<0 then {old exponential format}
      begin
        {Note: per the Turbo manual, a negative argument for DecPlaces
         is treated the same as if the parameter were omitted yielding
         the minimum format '-n.dE+pppp' with up to 16 more decimals 'd'
         added, and then leading blanks, if necessary to fill the field.
         FieldWidth is specified in anticipation of 2-digit exponent,
         but system will generate 4, so request wider-than-desired
         field from which 2 digits will almost certainly be dropped}
        FieldWidth := FieldWidth + 2;
        str(E:FieldWidth:DecPlaces, S);
        {delete up to 2 leading zeros from 4-digit default exponent}
        EPos := Pos('E', S);
        if S[EPos+2] = '0' then delete(S,EPos+2,1);
        if S[EPos+2] = '0' then delete(S,EPos+2,1)
      end
    else
      if FieldWidth>=0 then {non-exponential format}
        str(E:FieldWidth:DecPlaces, S)
      else  {FieldWidth<0}
        begin {new exponential format}
          NumExponents := -FieldWidth;
          str(E:DecPlaces + 9, S); {generates '-n.dddE+pppp' with at least 1 d}
          EPos := Pos('E', S);
          if (NumExponents<4) and (S[EPos+2]='0') then delete(S,EPos+2,1);
          if (NumExponents<3) and (S[EPos+2]='0') then delete(S,EPos+2,1);
          if (NumExponents<2) and (S[EPos+2]='0') then delete(S,EPos+2,1);
        end;
    Real2Str := S
  end;

function ThousandsStringToExtended(InputString : string): extended;
  var
    ThousandsPos, ErrorCode : integer;
    X : extended;
  begin
    ThousandsPos := pos(ThousandSeparator,InputString);
    while ThousandsPos<>0 do
      begin
        InputString := Substring(InputString,1,ThousandsPos-1) + Substring(InputString,ThousandsPos+1,255);
        ThousandsPos := pos(ThousandSeparator,InputString);
      end;
    val(InputString,X,ErrorCode);
    ThousandsStringToExtended := X;
  end;

function RoundUp(X, XInt : extended): extended;
{used in setting axes, returns first number >= X on an "even" XInt interval}
  const
    Epsilon = 1e-10;
  var
    N, Residual : extended;
  begin
    N := X/Xint;
    {unless N is far from an exact integer, no adjustment of X is needed}
    Residual := abs(frac(N));
    if (Residual>Epsilon) and (abs(Residual-1)>Epsilon) then
      RoundUp := XInt*Ceiling(N)
    else
      RoundUp := X
  end;

function RoundDown(X, XInt : extended): extended;
{used in setting axes, returns first number <= X on an "even" XInt interval}
  const
    Epsilon = 1e-10;
  var
    N, Residual : extended;
  begin
    N := X/Xint;
    {unless N is far from an exact integer, no adjustment of X is needed}
    Residual := abs(frac(N));
    if (Residual>Epsilon) and (abs(Residual-1)>Epsilon) then
      RoundDown := XInt*Floor(N)
    else
      RoundDown := X
  end;

function Log10(X: extended): extended;
  begin
    Log10 := ln(X)/ln(10);
  end;

function AntiLog10(X: extended): extended;
  begin
    AntiLog10 := exp(ln(10)*X);
  end;

function DecimalInterval(XMin, XMax : extended): extended;
  {returns "even" decimal fraction of an interval -- eg. 1.0 for 53-57;
    100 for 5300-5700;  and 0.01 for 0.53-0.57}
  begin
    DecimalInterval := AntiLog10(RoundDown(Log10(XMax - XMin),1) - 1);
  end;

procedure Swap(var A, B; NumBytes: word);
{exchanges contents of two variables of specified length}
  const
    NMax = 10;
  var
    Temp : array[1..NMax] of byte;

  begin
    if NumBytes>NMax then
      HaltForError('Unable to Swap variables of length greater than '
        +Int2Str(NMax,0),'Win_Ops')
    else
      begin
        move(B,Temp,NumBytes);
        move(A,B,NumBytes);
        move(Temp,A,NumBytes);
      end;
  end;


  function DateString : string;
  {returns date in format  "9/3/95", etc.}
    begin
      DateString := Int2Str(MonthOf(Time),0)+'/'+Int2Str(DayOf(Time),0)+'/'+Int2Str(YearOf(Time)-1900,0);
    end;

  function TimeString : string;
  {returns time in "1:03p", etc. format}
    var
      Hr,Min : word;
      MinString : string;
      TagChar : char;
    begin
      Hr := HourOf(Time);
      Min := MinuteOf(Time);
      if Hr<12 then
        TagChar := 'a'
      else
        begin
          TagChar := 'p';
          if Hr>12 then dec(Hr,12);
        end;
      MinString := Int2Str(Min,0);
      if length(MinString)=1 then MinString := '0' + MinString;
      TimeString := Int2Str(Hr,0) + ':' + MinString + TagChar
    end;

procedure ClearVariable(var VarToClear; const Size: word);
{zeros a variable of any type, provided the Size in bytes is passed, e.g.
 via:   ClearVariable(TestVar,SizeOf(TestVar))   }
  begin
    FillChar(VarToClear, Size, 0);
  end;

function StrippedString(S: string): string;
{returns string stripped of leading and trailing blanks and tabs}
  begin
{Note: "S" is passed by reference, and it is local copy only that is affected
 by the following operations:}
    while (length(S)>0) and ((S[length(S)]=' ') or (S[length(S)]=Tab)) do
      SetLength(S,length(S)-1);
    while (length(S)>1) and ((S[1]=' ') or (S[1]=Tab)) do S := copy(S,2,MaxInt);
    StrippedString := S;
  end;

function FixedLengthString(S:string; const DesiredLength: integer):string;
  begin
    if length(S)>DesiredLength then
      S := copy(S,1,DesiredLength)
    else
      while length(S)<DesiredLength do S := S + ' ';
    FixedLengthString := S;
  end;


procedure ConvertToUpperCase(var S: string);
  var
    Position : Integer;
  begin
    for Position := 1 to length(S) do S[Position] := Upcase(S[Position]);
  end;

function UpperCaseString(S: string) : string;
  begin
    ConvertToUpperCase(S);  {modify local copy passed by reference}
    UpperCaseString := S;
  end;

  function Substring(const S: string; const StartCol, EndCol : integer): string;
    begin
      Substring := copy(S,StartCol,EndCol-StartCol+1);
    end;

  procedure RemoveTrailingBlanks(var InputString: string);
  {the val(string,real,error_code) procedure seems to stumble on trailing
   blanks}
    begin
      while (length(InputString)>0) and (InputString[Length(InputString)]=' ') do
        SetLength(InputString,length(InputString)-1)
    end;

  procedure RemoveBlanks(var S: string);
    var
      BlankPos : integer;
    begin
      BlankPos := pos(' ',S);
      while BlankPos<>0 do
        begin
          S := copy(S,1,BlankPos-1)+copy(S,BlankPos+1,MaxInt);
          BlankPos := pos(' ',S);
        end;
    end;

  function LeadingElement(var StringToProcess: string; const DividingChars: string): string;
    var
      CharPos : integer;
    begin
    {Note:  Delphi "Trim" function removes control characters as well as spaces,
      so if substituted for StrippedString function will not work if DividingChars
      is a control character}
      StringToProcess := StrippedString(StringToProcess);
      CharPos := pos(DividingChars,StringToProcess);
      if CharPos<>0 then
        begin
          LeadingElement := Substring(StringToProcess,1,CharPos-1);
          StringToProcess := Substring(StringToProcess,CharPos+Length(DividingChars),MaxInt);
        end
      else {character not found - return full string}
        begin
          LeadingElement := StringToProcess;
          StringToProcess := '';
        end;
    end;

  function LeadingTabbedElement(var StringToProcess: string): string;
    var
      CharPos : integer;

    function DeBlankedString(S: string): string;
    {returns string stripped of leading and trailing blanks and tabs}
      begin
    {Note: "S" is passed by reference, and it is local copy only that is affected
     by the following operations:}
        while (length(S)>0) and (S[length(S)]=' ') do
          SetLength(S,length(S)-1);
        while (length(S)>1) and (S[1]=' ') do S := copy(S,2,MaxInt);
        Result := S;
      end;

    begin
    {Note:  Delphi "Trim" function removes control characters as well as spaces,
      so if substituted for StrippedString function will not work if DividingChars
      is a control character}
      StringToProcess := DeBlankedString(StringToProcess);
      CharPos := pos(Tab,StringToProcess);
      if CharPos<>0 then
        begin
          LeadingTabbedElement := Substring(StringToProcess,1,CharPos-1);
          StringToProcess := Substring(StringToProcess,CharPos+1,MaxInt);
        end
      else {character not found - return full string}
        begin
          LeadingTabbedElement := StringToProcess;
          StringToProcess := '';
        end;
    end;

   function NonBlankString(S: string): boolean;
     begin
       RemoveTrailingBlanks(S);
       NonBlankString := S<>'';
     end;

  function IntegerValue(StringToConvert: string): integer;
    var
      MyResult : integer;
      ErrorCode : integer;
    begin
      RemoveBlanks(StringToConvert);
      val(StringToConvert, MyResult, ErrorCode);
      if ErrorCode=0 then
        IntegerValue := MyResult
      else
        begin
          IntegerValue := 0;
          HaltForError('Unable to convert string "'+StringToConvert
           +'" to integer, ErrorCode = '+Int2str(ErrorCode,0),'Win_Ops');
        end;
    end;

  function LongIntValue(StringToConvert: string): longint;
    var
      MyResult : LongInt;
      ErrorCode : integer;
    begin
      RemoveBlanks(StringToConvert);
      val(StringToConvert, MyResult, ErrorCode);
      if ErrorCode=0 then
        LongIntValue := MyResult
      else
        begin
          LongIntValue := 0;
          HaltForError('Unable to convert string "'+StringToConvert
           +'" to integer, ErrorCode = '+Int2str(ErrorCode,0),'Win_Ops');
        end;
    end;

  function ExtendedValue(StringToConvert: string): extended;
    var
      MyResult : extended;
      ErrorCode, CommaPos : integer;
      CorrectedText : string;
    begin
      RemoveBlanks(StringToConvert);

// for European applications, replace commas with periods before trying to evaluate
      CorrectedText := StringToConvert;
      CommaPos := Pos(',',CorrectedText);
      while CommaPos<>0 do
        begin
          CorrectedText := Copy(CorrectedText,0,CommaPos-1)+'.'+Copy(CorrectedText,CommaPos+1,MaxInt);
          CommaPos := Pos(',',CorrectedText);
        end;

      val(CorrectedText, MyResult, ErrorCode);
      if ErrorCode=0 then
        ExtendedValue := MyResult
      else
        begin
          ExtendedValue := 0;
          HaltForError('Unable to convert string "'+StringToConvert
           +'" to extended, ErrorCode = '+Int2str(ErrorCode,0),'Win_Ops');
        end;
    end;

  function ExtendedToReal(const V: extended): real;
    var
      S : string;
      MyResult : real;
      ErrorCode : integer;
    begin
      str(V,S);
      val(S, MyResult, ErrorCode);
      if ErrorCode=0 then
        ExtendedToReal := MyResult
      else
        begin
          ExtendedToReal := 0;
          HaltForError('Unable to convert string "'+S
           +'" to real, ErrorCode = '+Int2str(ErrorCode,0),'Win_Ops');
        end;
    end;

  function ExtendedToSingle(const V: extended): single;
    var
      S : string;
      MyResult : single;
      ErrorCode : integer;
    begin
      str(V,S);
      val(S, MyResult, ErrorCode);
      if ErrorCode=0 then
        ExtendedToSingle := MyResult
      else
        begin
          ExtendedToSingle := 0;
          HaltForError('Unable to convert string "'+S
           +'" to single, ErrorCode = '+Int2str(ErrorCode,0),'Win_Ops');
        end;
    end;

function FileFound(const Description, TrialFilename : string; var CorrectFilename : string): boolean;
 {checks to see if TrialFilename exists; if not, launches OpenDialog window
 with Description as heading allowing user to find file.  Returns TRUE with
 CorrectFilename = (TrialFilename or file selected by user);
 otherwise returns FALSE with CorrectFilename = TrialFilename}
  const
    LastDirectory : string = '';
  var
    OpenDialog : TOpenDialog;
    ExpectedFilename, ExpectedPath, ExpectedExtension : string;
  begin
    CorrectFilename := TrialFilename;
//    ShowMessage('Looking for "'+TrialFilename+'"');

    if FileExists(CorrectFilename) then
      begin {check if requested file exists}
        Result := True;
        Exit;
      end;

    ExpectedFilename := ExtractFileName(TrialFilename);
    ExpectedPath := ExtractFilePath(TrialFilename);
    if ExpectedPath='' then ExpectedPath := '.\';

    CorrectFilename := ExpectedPath+ExpectedFilename;

    if FileExists(CorrectFilename) then
      begin {check if requested file exists in current directory}
        Result := True;
//        ShowMessage(CorrectFilename+' found in current directory');
        Exit;
      end;

    if LastDirectory<>'' then
      begin
        CorrectFilename := LastDirectory+ExpectedFilename;

        if FileExists(CorrectFilename) then
          begin {check if requested file exists in directory from which last file was loaded}
            Result := True;
//            ShowMessage(ExpectedFilename+' found in last directory');
            Exit;
          end;

       end;

    OpenDialog := TOpenDialog.Create(nil);
    try
      with OpenDialog do
        begin
          SetSubComponent(True);
          Title := Description+' needed: '+ExpectedFilename;
          FileName := ExpectedFilename;
          InitialDir := ExpectedPath;
          ExpectedExtension := ExtractFileExt(TrialFilename);
          Filter := '*'+ExpectedExtension+'|*'+ExpectedExtension+'|All Files|*.*';
          Options := Options + [ofNoChangeDir];
          if Execute and FileExists(FileName) then
            begin
              CorrectFilename := FileName;
              LastDirectory := ExtractFilePath(Filename);
              Result := True;
            end
          else
            begin
              CorrectFilename := TrialFilename;
              Result := False;
//            ShowMessage('Error: unable to find '+Description);
//              ShowMessage('Dialog cancelled');
            end;
        end;
    finally
      OpenDialog.Free;
    end;
  end;

function PictureFileFound(const Description, TrialFilename : string; var CorrectFilename : string): boolean;
 {same as FileFound, but with OpenDialog declared as TOpenPictureDialog, which gives a
 graphic preview, and the default choice of photo extensions allowed}
  const
    LastDirectory : string = '';
  var
    OpenDialog : TOpenPictureDialog;
    ExpectedFilename, ExpectedPath{, ExpectedExtension} : string;
  begin
    CorrectFilename := TrialFilename;
//    ShowMessage('Looking for "'+TrialFilename+'"');

    if FileExists(CorrectFilename) then
      begin {check if requested file exists}
        Result := True;
        Exit;
      end;

    ExpectedFilename := ExtractFileName(TrialFilename);
    ExpectedPath := ExtractFilePath(TrialFilename);
    if ExpectedPath='' then ExpectedPath := '.\';

    CorrectFilename := ExpectedPath+ExpectedFilename;

    if FileExists(CorrectFilename) then
      begin {check if requested file exists in current directory}
        Result := True;
//        ShowMessage(CorrectFilename+' found in current directory');
        Exit;
      end;

    if LastDirectory<>'' then
      begin
        CorrectFilename := LastDirectory+ExpectedFilename;

        if FileExists(CorrectFilename) then
          begin {check if requested file exists in directory from which last file was loaded}
            Result := True;
//            ShowMessage(ExpectedFilename+' found in last directory');
            Exit;
          end;

       end;

    OpenDialog := TOpenPictureDialog.Create(nil);
    try
      with OpenDialog do
        begin
          SetSubComponent(True);
          Title := Description+' needed: '+ExpectedFilename;
          FileName := ExpectedFilename;
          InitialDir := ExpectedPath;
//          ExpectedExtension := ExtractFileExt(TrialFilename);
//          Filter := '*'+ExpectedExtension+'|*'+ExpectedExtension+'|All Files|*.*';
          Options := Options + [ofNoChangeDir];
          if Execute and FileExists(FileName) then
            begin
              CorrectFilename := FileName;
              LastDirectory := ExtractFilePath(Filename);
              Result := True;
            end
          else
            begin
              CorrectFilename := TrialFilename;
              Result := False;
//            ShowMessage('Error: unable to find '+Description);
//              ShowMessage('Dialog cancelled');
            end;
        end;
    finally
      OpenDialog.Free;
    end;
  end;

procedure HaltForError(ErrorMessage, UnitID : string);
{calling program can use this directly, or write its own error messages
 following a "PrepareToHalt", then call this to Halt}
  var
    Result : integer;
    CaptionText : string;
  begin
    CaptionText := 'Program has encountered a serious error';
    if length(UnitID)>0 then
      CaptionText := CaptionText + ' in Unit '+UnitID;
    Beep;
    Result := MessageDlg(CaptionText+char(13)+ErrorMessage,mtError,mbOKCancel,0);
//    Halt;
  end;

procedure Pause;
  begin
{    MessageDlg('Progam paused',mtWarning,mbOKCancel,0);}
    ShowMessage('Progam paused');
  end;

end.

