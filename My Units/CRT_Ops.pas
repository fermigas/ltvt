unit CRT_Ops;
{7/5/04: removed references to ToneGen which was used to generate a Beep sound.
 Old programs that used this feature still work in .exe form, but fail to function
 and turn off all .wav sounds when recompiled by Delphi 6 under Windows XP.}

{$H-} {use short strings by default}

interface

procedure Writeln; overload;
procedure Writeln(S : string); overload;
procedure Writeln(var F: Text;  S : string ); overload;
procedure Write(S : string); overload;
procedure Write(var F: Text;  S : string ); overload;
function Keypressed : boolean;
procedure ClearKey;  {clears keyboard buffer}
function ReadKey : char;
procedure ReadLn(var S : ShortString);

procedure MarkCursorPosition;
procedure GoToMarkedCursorPosition;
procedure ClrEOL;
procedure HideCRT_OpsWindow;

   var
     Key : Char;  {contains character used to respond to WaitForKey}
     KeyCode : Byte; {contains ordinal value of 2nd char. iff Key = chr(0)}
     ParameterChanged : Boolean; {set by UpdateVariable routines}

     AlarmDelay : Integer; {seconds before alarm sounds on WaitForKey}

   function I2(n: word): word;
   function D2(n: extended): extended;
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
   function CurrentSec : extended;

   function FileExists(const Filename: string): boolean;

   procedure ClrScr;
   procedure ClearScreen;

   procedure ClearVariable(var VarToClear; const Size: word);

   procedure UpdateBooleanVariable(var V: boolean; Prompt : string);

   procedure UpdateByteVariable(var V: byte; Prompt : string);
   procedure UpdateShortIntVariable(var V: shortint; Prompt : string);
   procedure UpdateWordVariable(var V: word; Prompt : string);
   procedure UpdateIntegerVariable(var V: integer; Prompt : string);
   procedure UpdateLongIntVariable(var V: longint; Prompt : string);
   procedure UpdateIntegerInRange(var V: integer; Nmin, Nmax: integer; Prompt : string);
   procedure SelectFromMenu(var V: integer; Nmin, Nmax: integer; Prompt : string);
     {same as UpdateIntegerInRange}

   procedure UpdateRealVariable(var V: real; NumDec: byte; Prompt : string);
   procedure UpdateExtendedVariable(var V: extended; NumDec: byte; Prompt : string);
   procedure UpdateExtendedInRange(var V: extended; NumDec: byte;
     Min,Max : extended; Prompt, Units : string);

   procedure UpdateCharVariable(var V: char; Prompt : string);
   procedure UpdateStringVariable(var V: string; Prompt : string);
   procedure UpdateLongString(var V: string; Prompt : string);

   function NonBlankString(S: string): boolean;
   procedure ConvertToUpperCase(var S: string);
   function UpperCaseString(S: string) : string;
   function Substring(const S: string; const StartCol, EndCol : integer): string;
   procedure RemoveTrailingBlanks(var InputString: string);
   procedure RemoveBlanks(var S: string); {removes ALL blanks, including internal}
   function StrippedString(S: string): string;
     {returns string stripped of leading and trailing blanks}
   function FixedLengthString(S:string; const DesiredLength: integer):string;
     {truncates or adds trailing blanks to bring length to DesiredLength}
   function LeadingElement(var StringToProcess: string; const DividingChar: char): string;
     {LeadingElement = first segment up to DividingChar and stripped of
      leading blanks;  StringToProcess = remainder of string beyond
      DividingChar stripped of trailing blanks
      Note: if DividingChar is NOT found, full string is returned and
      StringToProcess is set to null}
   function IntegerValue(StringToConvert: string): integer;
   function LongIntValue(StringToConvert: string): longint;
   function ExtendedValue(StringToConvert: string): extended;

   function ExtendedToReal(const V: extended): real;
   function ExtendedToSingle(const V: extended): single;

   procedure Beep;       {880 Hz for 250 msec}
   procedure WaitForKey;  {no screen dialog}
   procedure Pause;  {writes "Press any key to continue (or Q to Quit)..."}
   procedure AlarmOn(const DelaySec : word);  {sets AlarmDelay=DelaySec}
   procedure AlarmOff;  {sets AlarmDelay=MaxInt}
   procedure SoundAlarm; {BEEP until a key (which is discarded) is pressed}

   procedure PrepareToHalt;
   procedure HaltForError(ErrorMessage, UnitID : string);
   procedure HoldOutput;



implementation

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DateUtils, MMSystem;

var
  KeyHasBeenPressed : boolean;
  LastKeyPressed : char;
  MarkedCursorPosition : integer;
  AtNewLine : boolean;


type
  TCRT_OpsIOForm = class(TForm)
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CRT_OpsIOForm: TCRT_OpsIOForm;

{$R *.dfm}

procedure Writeln;
begin
  if AtNewLine then CRT_OpsIOForm.Memo1.Lines.Add('');
  CRT_OpsIOForm.Show;
  AtNewLine := true;
end;

procedure Writeln(S : string);
begin
  if AtNewLine then
    CRT_OpsIOForm.Memo1.Lines.Add(S)
  else
    begin
      Write(S);
      CRT_OpsIOForm.Memo1.Lines.Add('');
    end;
  CRT_OpsIOForm.Show;
  AtNewLine := true;
end;

procedure Writeln(var F: Text;  S : string ); overload;
begin
  System.Writeln(F,S);
end;

procedure Write(S : string);
begin
  if AtNewLine then
    begin
      CRT_OpsIOForm.Memo1.Lines.Add(S);
      CRT_OpsIOForm.Memo1.SelStart := CRT_OpsIOForm.Memo1.SelStart - 2; {correct for MarkCursorPosition}
    end
  else
    CRT_OpsIOForm.Memo1.Lines[CRT_OpsIOForm.Memo1.Lines.Count-1] := CRT_OpsIOForm.Memo1.Lines[CRT_OpsIOForm.Memo1.Lines.Count-1] + S;
  CRT_OpsIOForm.Show;
  AtNewLine := false;
end;

procedure Write(var F: Text;  S : string ); overload;
begin
  System.Write(F,S);
end;

function Keypressed : boolean;
begin
  CRT_OpsIOForm.ActiveControl := CRT_OpsIOForm.Memo1;
  Keypressed := KeyHasBeenPressed;
end;

function ReadKey : char;
begin
  ReadKey := LastKeyPressed;
  KeyHasBeenPressed := false;
  LastKeyPressed := chr(0);
end;

procedure ClearKey;
{clears Keyboard buffer}
  var
    ch : char;

  begin
    while KeyPressed do
      begin
        Application.ProcessMessages;
        ch := ReadKey;
      end;
{    LastKeyPressed := chr(0);}
  end;


procedure ReadLn(var S : ShortString);
var
  SavedLength : integer;

begin
  MarkCursorPosition;
  ClearKey;
  repeat Application.ProcessMessages until LastKeyPressed = chr(13);
  with CRT_OpsIOForm.Memo1 do
    begin
{      SetFocus;}
{      ShowMessage('SelStart='+IntToStr(SelStart));}
      SavedLength := (SelStart - 2) - MarkedCursorPosition;
      SelStart := MarkedCursorPosition; {this seems to reset SelLength to 0}
      SelLength := SavedLength;
      S := SelText;
{     ShowMessage('SelStart ='+IntToStr(SelStart)+'; length = '+IntToStr(SelLength)+' : "'+S+'"');}
    end;
  AtNewLine := true;  
end;


procedure MarkCursorPosition;
begin
  MarkedCursorPosition := CRT_OpsIOForm.Memo1.SelStart;
end;

procedure GoToMarkedCursorPosition;
begin
  CRT_OpsIOForm.Memo1.SelStart := MarkedCursorPosition;
  AtNewLine := false;
end;

procedure ClrEOL;
begin
  CRT_OpsIOForm.Memo1.SelLength := 255;
  CRT_OpsIOForm.Memo1.ClearSelection;
end;

procedure HideCRT_OpsWindow;
begin
  CRT_OpsIOForm.Hide;
end;

procedure TCRT_OpsIOForm.FormActivate(Sender: TObject);
begin
  KeyHasBeenPressed := false;
  LastKeyPressed := char(0);
end;

procedure TCRT_OpsIOForm.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  KeyHasBeenPressed := true;
  LastKeyPressed := Key;
{  if LastKeyPressed=chr(13) then Beep;}
end;


  const
    IgnoreLimits = true;

  var
    SavedColors :  Word;

  function FileExists(const Filename: string): boolean;
    begin
      FileExists := SysUtils.FileExists(Filename);
    end;


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

function I2(n: word): word;
  {from Tom Swan's book, p. 560 -- inserts leading '0' when printing n<10}
    begin
      if n<10 then write('0');
      I2 := n;
    end;

function D2(n: extended): extended;
  {same for floating point}
    begin
      if n<10 then write('0');
      D2 := n;
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
        +Int2Str(NMax,0),'CRT_OPS')
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

  function CurrentSec : extended;
  {returns current second by reading BIOS clock}
    const
      ClockRate = 18.206481; {clicks per second}
    begin
      CurrentSec := 0{MemL[0:$46C]/ClockRate};
    end;

  procedure ClrScr;
    begin
      CRT_OpsIOForm.Memo1.Lines.Clear;
    end;

  procedure ClearScreen;
    begin
      ClrScr
    end;


procedure ClearVariable(var VarToClear; const Size: word);
{zeros a variable of any type, provided the Size in bytes is passed, e.g.
 via:   ClearVariable(TestVar,SizeOf(TestVar))   }
  begin
    FillChar(VarToClear, Size, 0);
  end;

procedure UpdateBooleanVariable(var V: boolean; Prompt : string);
  var
    Response : string;
    X : integer;
    OldValue, NoError : boolean;
  begin
    OldValue := V;
    write(Prompt+' [Y or N] (def. = ');
    if V=true then write ('Y') else write('N');
    write(') :  ');
    MarkCursorPosition{X := WhereX};
    repeat
      readln(Response);
      NoError := true;
      if Response<>'' then
        case upcase(Response[1]) of
          'Y' : V := true;
          'N' : V := false;
          else
            begin
              NoError := false;
              Beep;
              {GotoXY(X,WhereY-1);}
              ClrEOL;
              GotoMarkedCursorPosition;
            end
        end;
    until NoError;
    ParameterChanged := (V<>OldValue)
  end;

type
  NumberType = (ByteType, ShortIntType, WordType, IntegerType, LongIntType);

procedure UpdateIntegerNumber(TypeIdentifier: NumberType;
  var V: longint; Nmin, Nmax: integer; Prompt: string; IgnoreLimits: boolean);
{generic routine for handling integer format numbers with possible limits --
  types byte, word and integer have to be type converted to longint
  before calling}

  var
    Response : string;
    X, ErrorCode : integer;
    OldValue, TrialValue : longint;

  begin {UpdateIntegerNumber}
    OldValue := V;
    ErrorCode := 1;
    write(Prompt+' (');
    if not IgnoreLimits then
      write(IntToStr(Nmin)+'..'+IntToStr(Nmax)+'; ');
    write('def. = '+IntToStr(V)+') :   ');
    MarkCursorPosition;
    repeat
      readln(Response);
      if Response='' then
        ErrorCode := 0
      else
        begin

          val(Response,TrialValue,ErrorCode);

{note: it appears that TrialValue must be a longint type to properly set
  ErrorCode and continue if the result is outside the allowable limits.
  If TrialValue is a smaller integer type, and the result exceeds the
  appropriate limits a fatal "range check error" is issued before ErrorCode
  can be checked -- so it prevent that, it appears necessary to use a longint
  variable and check the tighter limits by hand}

          case TypeIdentifier of
            LongIntType : {no action required};
            IntegerType :
              if (TrialValue<-32768) or (TrialValue>32767) then ErrorCode := 1;
            WordType :
              if (TrialValue<0) or (TrialValue>65535) then ErrorCode := 1;
            ByteType :
              if (TrialValue<0) or (TrialValue>255) then ErrorCode := 1;
            ShortIntType :
              if (TrialValue<-128) or (TrialValue>127) then ErrorCode := 1;
            else
              HaltForError('Attempting to update integer variable of unrecognized type',
                'CRT_Ops');
            end;

          if (ErrorCode=0) and
            (IgnoreLimits or ((TrialValue>=Nmin) and (TrialValue<=Nmax))) then
            V := TrialValue
          else
            begin
              Beep;
              ErrorCode := 1;

              ClrEOL;
              GotoMarkedCursorPosition;
            end;
        end;
    until ErrorCode=0;
    ParameterChanged := (V<>OldValue)
  end;  {UpdateIntegerNumber}

procedure UpdateIntegerVariable(var V: integer; Prompt : string);
  var
    DummyV : longint;
  begin
    DummyV := V;
    UpdateIntegerNumber(IntegerType,DummyV,0,0,Prompt,IgnoreLimits);
    V := DummyV;
  end;

procedure UpdateWordVariable(var V: word; Prompt : string);
  var
    DummyV : longint;
  begin
    DummyV := V;
    UpdateIntegerNumber(WordType,DummyV,0,0,Prompt,IgnoreLimits);
    V := DummyV;
  end;

procedure UpdateByteVariable(var V: byte; Prompt : string);
  var
    DummyV : longint;
  begin
    DummyV := V;
    UpdateIntegerNumber(ByteType,DummyV,0,0,Prompt,IgnoreLimits);
    V := DummyV;
  end;

procedure UpdateShortIntVariable(var V: ShortInt; Prompt : string);
  var
    DummyV : longint;
  begin
    DummyV := V;
    UpdateIntegerNumber(ShortIntType,DummyV,0,0,Prompt,IgnoreLimits);
    V := DummyV;
  end;

procedure UpdateLongintVariable(var V: longint; Prompt : string);
  begin
    UpdateIntegerNumber(LongIntType,V,0,0,Prompt,IgnoreLimits);
  end;

procedure UpdateIntegerInRange(var V: integer; Nmin, Nmax: integer; Prompt : string);
  var
    DummyV : longint;
  begin
    DummyV := V;
    UpdateIntegerNumber(IntegerType,DummyV,Nmin,Nmax,Prompt,not IgnoreLimits);
    V := DummyV
  end;

procedure SelectFromMenu(var V: integer; Nmin, Nmax: integer; Prompt : string);
{synonymous with UpdateIntegerInRange}
  begin
    UpdateIntegerInRange(V,Nmin,Nmax,Prompt);
  end;

procedure UpdateRealNumber(Size: word; var V: extended; NumDec: byte;
  Min,Max : extended; Prompt, Units : string; IgnoreLimits: boolean);
{generic routine for handling real format numbers with possible limits --
  types single, double and real have to be type converted to extended
  before calling}

  var
    Response : string;
    X, ErrorCode, PatternPos : integer;
    OldValue, TrialValue : extended;
    TrialReal : real;

  function DecimalString(V: extended; NumDec: byte): string;
  {determines if the value V is such that exponential notation is needed in
   order to display a sensible value}
    var
      Exponent : integer;
    begin
      if V<>0 then
        Exponent := Floor(ln(abs(V))/ln(10))
      else
        Exponent := 0;
      if (Exponent<-NumDec) or (Exponent>6) then
          DecimalString := Real2Str(V,-1,NumDec)
        else
          DecimalString := Real2Str(V,0,NumDec)
     end;

  begin {UpdateRealNumber}
    OldValue := V;
    write(Prompt);
    if not IgnoreLimits then
      begin
        write(' ['+DecimalString(Min,NumDec)+'..'+DecimalString(Max,NumDec));
        if Units<>'' then write(' '+Units);
        write(']');
      end;
    write(' (def. = '+DecimalString(V,NumDec)+') :  ');
    MarkCursorPosition;
    ErrorCode := 1;
    repeat
      readln(Response);
      if Response='' then
        ErrorCode := 0
      else
        begin

        {correct for possible omission of leading 0 before decimal point:}
          if Response[1]='.' then Response := '0'+Response;
          PatternPos :=  pos(' .',Response);
          if PatternPos<>0 then Response[PatternPos] := '0';
          PatternPos :=  pos('-.',Response);
          if PatternPos<>0 then Response := copy(Response,1,PatternPos-1) +
            '-0.' + copy(Response,PatternPos+2,MaxInt);

          case Size of
             6 : {real}
               begin
                 val(Response,TrialReal,ErrorCode);
                 TrialValue := TrialReal;
               end;
            10 :
              val(Response,TrialValue,ErrorCode);
            else
              HaltForError('Attempting to update real variable of unrecognized size (= '+
                Int2Str(Size,0)+' bytes','CRT_Ops');
            end;

          if (ErrorCode=0) and
            (IgnoreLimits or ((TrialValue>=Min) and (TrialValue<=Max))) then
            V := TrialValue
          else
            begin
              Beep;
              ErrorCode := 1;

              ClrEOL;
              GoToMarkedCursorPosition;
            end;
        end;
    until ErrorCode=0;
    ParameterChanged := (V<>OldValue)
  end; {UpdateRealNumber}

procedure UpdateRealVariable(var V: real; NumDec: byte; Prompt : string);
  var
    DummyV : extended;
  begin
    DummyV := V;
    UpdateRealNumber(SizeOf(Real), DummyV, NumDec, 0, 0, Prompt, '', IgnoreLimits);
    V := DummyV
  end;

procedure UpdateExtendedVariable(var V: extended; NumDec: byte; Prompt : string);
  begin
    UpdateRealNumber(SizeOf(Extended), V, NumDec, 0, 0, Prompt, '', IgnoreLimits);
  end;

procedure UpdateExtendedInRange(var V: extended; NumDec: byte;
  Min,Max : extended; Prompt, Units : string);
  begin
    UpdateRealNumber(SizeOf(Extended),V,NumDec,Min,Max,Prompt,Units,not IgnoreLimits);
  end;

procedure UpdateCharVariable(var V: char; Prompt : string);
  var
    OldValue, Response : string;
  begin
    OldValue := V;
    write(Prompt+' (def. = '+V+') :  ');
    readln(Response);
    if length(Response)>0 then V := upcase(Response[1]);
    ParameterChanged := (V<>OldValue)
  end;

procedure UpdateStringVariable(var V: string; Prompt : string);
  var
    OldValue, Response : string;
  begin
    OldValue := V;
    write(Prompt+' (def. = '+V+') :  ');
    readln(Response);
    if length(Response)>0 then V := Response;
    ParameterChanged := (V<>OldValue)
  end;

procedure UpdateLongString(var V: string; Prompt : string);
  var
    OldValue, Response : string;
  begin
    OldValue := V;
    writeln(Prompt+'; default =');
    writeln(V);
    readln(Response);
    if length(Response)>0 then V := Response;
    ParameterChanged := (V<>OldValue)
  end;

function StrippedString(S: string): string;
{returns string stripped of leading and trailing blanks}
  begin
{Note: "S" is passed by reference, and it is local copy only that is affected
 by the following operations:}
    while (length(S)>0) and (S[length(S)]=' ') do SetLength(S,length(S)-1);
    while (length(S)>1) and (S[1]=' ') do S := copy(S,2,MaxInt);
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

  function LeadingElement(var StringToProcess: string; const DividingChar: char): string;
    var
      CharPos : integer;
    begin
    {Note:  Delphi "Trim" function removes control characters as well as spaces,
      so if substituted for StrippedString function will not work if DividingChar
      is a control character}
      StringToProcess := StrippedString(StringToProcess);
      CharPos := pos(DividingChar,StringToProcess);
      if CharPos<>0 then
        begin
          LeadingElement := Substring(StringToProcess,1,CharPos-1);
          StringToProcess := Substring(StringToProcess,CharPos+1,MaxInt);
        end
      else {character not found - return full string}
        begin
          LeadingElement := StringToProcess;
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
        HaltForError('Unable to convert string "'+StringToConvert
         +'" to integer, ErrorCode = '+Int2str(ErrorCode,0),'CRT_Ops');
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
        HaltForError('Unable to convert string "'+StringToConvert
         +'" to integer, ErrorCode = '+Int2str(ErrorCode,0),'CRT_Ops');
    end;

  function ExtendedValue(StringToConvert: string): extended;
    var
      MyResult : extended;
      ErrorCode : integer;
    begin
      RemoveBlanks(StringToConvert);
      val(StringToConvert, MyResult, ErrorCode);
      if ErrorCode=0 then
        ExtendedValue := MyResult
      else
        HaltForError('Unable to convert string "'+StringToConvert
         +'" to extended, ErrorCode = '+Int2str(ErrorCode,0),'CRT_Ops');
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
        HaltForError('Unable to convert string "'+S
         +'" to real, ErrorCode = '+Int2str(ErrorCode,0),'CRT_Ops');
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
        HaltForError('Unable to convert string "'+S
         +'" to single, ErrorCode = '+Int2str(ErrorCode,0),'CRT_Ops');
    end;


procedure Beep;
  begin
    {to be implemented}
    sndPlaySound('C:\WINDOWS\MEDIA\DING.WAV', SND_ASYNC);
  end;

procedure WaitForKey;
{waits for a one-character response from keyboard, returned as "Key"
 (and possibly "KeyCode").  Alarm sounds if there is no response for
 more than AlarmDelay seconds (which can be set in external program).
 If the alarm has started, it can be silenced (with no other action) by
 pressing ESC.  In that one case, WaitForKey continues to wait until an
 additional key has been pressed}
  var
    DelayCount : LongInt;  {# of 0.001 sec delays before sounding alarm}
    AlarmStarted : boolean;

  begin
    ClearKey;
    DelayCount := 0;
    AlarmStarted := FALSE;
    {Note : following factor of 718 rather than 1000 to convert seconds to
       milliseconds accounts for loop overhead:  using 1000, AlarmDelay = 300
       gave a 418 sec delay}
    while (DelayCount<718*longint(AlarmDelay)) and not KeyPressed do
      begin
        Application.ProcessMessages;
        Sleep(1); {1 msec delay}
        inc(DelayCount);
      end;
    if not KeyPressed then
      begin
        AlarmStarted := TRUE;
        SoundAlarm
      end;
    if (not AlarmStarted) OR ((AlarmStarted) and (Key=chr(27))) then
      begin
        Key := ReadKey;
        if Key = chr(0) then
          KeyCode := ord(ReadKey)   {special key with 2-char code}
        else
          KeyCode := 0
      end;
    ClearKey;
(* {alternative code without alarm}
    ClearKey;
    while not KeyPressed do Application.ProcessMessages;
    Key := ReadKey;
*)
  end;

procedure Pause;
  begin
    write('Press any key to continue (or Q to Quit)...');
    WaitForKey;
{    ShowMessage('Key pressed = "'+Key+'"');}
    writeln;
    if upcase(Key)='Q' then Halt;
  end;

procedure SoundAlarm;
{produces periodic beep until a key is pressed.  Key and KeyCode
 are passed through to the calling program}
  const
    BeepSpacing = 300; {# milliseconds between beeps}
    BeepsPerPattern = 3;
    PatternSpacing = 500; {additional milliseconds between repeat of beep patterns}
  var
    BeepCount,
    DelayCount : word;

  begin
    ClearKey;
    repeat
      BeepCount := 0;
      while (BeepCount<BeepsPerPattern) and not KeyPressed do
        begin
          Application.ProcessMessages;
          Beep;
          inc(BeepCount);
          DelayCount := 0;
          while (DelayCount<BeepSpacing) and not KeyPressed do
            begin
              Application.ProcessMessages;
              Sleep(1);
              inc(DelayCount)
            end
        end;
      DelayCount := 0;
      while (DelayCount<PatternSpacing) and not KeyPressed do
        begin
          Application.ProcessMessages;
          Sleep(1);
          inc(DelayCount)
        end
    until KeyPressed;
    Key := ReadKey;
    if Key = chr(0) then
      KeyCode := ord(ReadKey)   {special key with 2-char code}
    else
      KeyCode := 0;
  end;

procedure PrepareToHalt;
  begin
    {CloseGraph;}
  end;

(*
procedure HaltForError(ErrorMessage, UnitID : string);
{calling program can use this directly, or write its own error messages
 following a "PrepareToHalt", then call this to Halt}
  begin
    PrepareToHalt;
    if length(ErrorMessage)>0 then
      begin
        writeln;
        writeln('*** ',ErrorMessage,' ***');
        writeln;
      end;
    write('---- Program being halted due to this error');
    if length(UnitID)>0 then write(' in unit ',UnitID);
    writeln(' ----');
    writeln;
    HoldOutput
  end;
*)

procedure HoldOutput;
  begin
    write('Press any key to end program...');
    WaitForKey;
    writeln;
    halt
  end;

procedure AlarmOn(const DelaySec : word);
  begin
    AlarmDelay := DelaySec;
  end;


procedure AlarmOff;
  begin
    AlarmDelay := 32000{MaxInt};
  end;

procedure HaltForError(ErrorMessage, UnitID : string);
{calling program can use this directly, or write its own error messages
 following a "PrepareToHalt", then call this to Halt}
  var
    Result : integer;
    CaptionText : string;
  begin
    CaptionText := 'Program Being Halted due to Error';
    if length(UnitID)>0 then
      CaptionText := CaptionText + ' in Unit '+UnitID;
    Result := MessageDlg(CaptionText+char(13)+ErrorMessage,mtError,mbOKCancel,0);
    Beep;
    Halt;
  end;


initialization

  AlarmOff;

{  Application.CreateForm(TCRT_OpsIOForm, CRT_OpsIOForm);}
  CRT_OpsIOForm := TCRT_OpsIOForm.Create(Application);
  CRT_OpsIOForm.Memo1.Lines.Clear;
  AtNewLine := true;
end.
