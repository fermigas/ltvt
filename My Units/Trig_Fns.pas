unit Trig_Fns;
{supplements built in  Sin, Cos, and Arctan.  All trig. functions operate
 on arguments in type "Radians" -- use conversion routines to covert from
 or to type "Degrees"}

interface

uses Win_Ops;

type
  Radians = extended;
  Degrees = extended;

function DtoR(const Angle: degrees): radians;
{converts argument in degrees to equivalent angle in radians}

function RtoD(const Angle: radians): degrees;
{converts argument in radians to equivalent angle in degrees}

function Tan(const Angle: radians): extended;

function Asin(const Arg: extended): radians;
{returns result in range -pi/2 to +pi/2}

function Acos(const Arg: extended): radians;
{returns result in range 0 to +pi}

function Atan(const Arg: extended): radians;
{= intrinsic fn. "arctan": returns result in range -pi/2 to +pi/2}

function FullAtan(const X, Y: extended): radians;
{gives result in range [-pi..+pi] placed in unique quadrant based on
 projections X and Y. Computes ArcTan(Y/X).}

function Atan2(const Y, X: extended): radians;
{this is the same as FullAtan, but with the arguments in the reversed order
 to match Delphi Math units ArcTan2 (which doesn't allow X = 0) and Fortran
 ATAN2 or DATAN2}

implementation

uses Constnts;

function DtoR(const Angle: degrees): radians;
  begin
    DtoR := RPD*Angle
  end;

function RtoD(const Angle: radians): degrees;
  begin
    RtoD := DPR*Angle
  end;

function Tan(const Angle: radians): extended;
  var
    Temp : extended;
  begin
    Temp := cos(Angle);
    if Temp = 0 then
      HaltForError('Unable to calculate tangent since cos(Angle)=0','TRIG_FNS')
    else
      Tan := sin(Angle)/Temp
  end;

function Asin(const Arg: extended): radians;
  var
    Temp : extended;
  begin
    Temp := 1 - sqr(Arg);
    if Temp > 0 then
      Asin := arctan(Arg/sqrt(Temp))
    else if Temp = 0 then
      begin
        if Arg>0 then
          Asin := pi/2
        else
          Asin := -pi/2
      end
    else
      HaltForError('Unable to calculate arc-sine: abs(arg)>1','TRIG_FNS')
  end;

function Acos(const Arg: extended): radians;
  var
    Temp : extended;
  begin
    if Arg = 0 then
      Acos := pi/2
    else {Arg<>0}
      begin
        Temp := 1 - sqr(Arg);
        if Temp < 0 then
          HaltForError('Unable to calculate arc-cosine: abs(arg)>1','TRIG_FNS')
        else {Temp>=0}
          begin
            if Arg>0 then
              Acos := arctan((sqrt(Temp))/Arg)
            else {Arg<0}
              Acos := pi + arctan((sqrt(Temp))/Arg)
          end
      end
  end;

function Atan(const Arg: extended): radians;
  begin
    Atan := arctan(Arg)
  end;

function FullAtan(const X, Y: extended): radians;
  begin
    if X>0 then
      FullAtan := arctan(Y/X)
    else if X<0 then
      begin
        if Y<=0 then
          FullAtan := arctan(Y/X) - pi
        else
          FullAtan := pi + arctan(Y/X)
      end
    else {X = 0} if Y<0 then
      FullAtan := -pi/2
    else if Y>0 then
      FullAtan := pi/2
    else
      FullAtan := 0;
  end;

function Atan2(const Y, X: extended): radians;
  begin
    Result := FullAtan(X,Y);
  end;
begin
end.