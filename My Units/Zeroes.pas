unit Zeroes;
{Provides procedures for zeroes, maxima and minima of a generic real function.
                                                                    9/18/95;
Rev. 5/28/03:
  Added:  FindMethodFunctionZero

    This calls an exact copy of FindZero, except the SimpleFunction referenced
    is an object method.  The Object Pascal reference says that regular function
    types and method function types are always incompatible even though they
    accept the same arguments and return the same result.  The compiler will
    accept the typecast SimpleFunction(f) where "f" is a SimpleMethodFunction,
    but it results in a runtime error.
}

{$J+}  {permit TP7 style typed constant}

interface

uses
//  SysUtils, {these units needed for debugging with ShowMessage}
//  Dialogs,
  Win_Ops;

type
  SimpleFunction = function(const X: extended): extended;
  SimpleMethodFunction = function(const X: extended): extended of object;
  GlobalFunction = function: extended;
  GlobalProcedure = procedure;

const
  ExpandSearchInterval : boolean = true;

procedure FindZero(const f: SimpleFunction; const a, b, XError: extended; var X: extended);
{Searches for a zero of the function in the interval from a to b, returning
 a result of precision XError in X.  The function pointed to must be compiled
 far accept a single extended parameter and return an extended result.  The
 points a and b may be in any order, but XError is assumed to be positive.}

procedure FindMethodFunctionZero(const f: SimpleMethodFunction; const a, b, XError: extended; var X: extended);

procedure FindMinimum(const f: SimpleFunction; const a, b, XError: extended; var X: extended);
{Searches for a zero in the derivative of the requested function in the
 interval from a to b, returning a result of precision XError in X.  This may
 be a maximum or a minimum.  The function pointed to must be compiled far,
 accept a single extended parameter and return an extended result.  The
 points a and b may be in any order, but XError is assumed to be positive.
 The interval used for differentiation is XError/2.}

procedure OptimizeGlobalFunction(var Outfile: text; const f: GlobalFunction;
  var V: extended; const VariableID: string; const a, b, XError: extended);
{Searches for a zero in the derivative of "f" produced by varying the
 global variable "V"}

procedure SilentOptimizeGlobalFunction(const f: GlobalFunction;
  var V: extended; const a, b, XError: extended);
{same but without file output}

procedure OptimizeGlobalProcedure(var Outfile: text; const p: GlobalProcedure;
  var V1, V2: extended; const Variable1ID, Variable2ID: string;
  const a, b, XError: extended);
{Searches for a zero in the derivative of global variable "V2" produced by
 executing procedure "p" while varying the global variable "V1"}

implementation

type
  VariablePtr = ^extended;
var
  Epsilon : extended;  {interval for calculating derivative of "g"}
  g : SimpleFunction;
  TestVariablePtr, ResultVariablePtr : VariablePtr;
  FunctionToOptimize : GlobalFunction;
  ProcedureToOptimize : GlobalProcedure;
  ErrorIdentifier : string;
  WriteDummyGFResultOnScreen : boolean;

procedure ReallyFindZero(const f: SimpleFunction; a, b: extended;
  const XError: extended; var X: extended);
{both FindZero and FindMinimum will use this same procedure with different
 ErrorIdentifier's in the event of failure}
  var
    ExpansionCount : longint;
    L, HiX, LoX, HiF, LoF, FofX, FofA, FofB, LastAbsF :  extended;
    UseNewtonRaphson : boolean;

  begin  {ReallyFindZero}
    X := a;
    FofA := f(X);
    if FofA=0 then exit; {X = an exact zero}
    X := b;
    FofB := f(X);
    if FofB=0 then exit; {X = an exact zero}

    if ExpandSearchInterval then
      begin
        ExpansionCount := 0;
        while ((FofA<0) and (FofB<0)) or ((FofA>0) and (FofB>0)) do
          begin
            inc(ExpansionCount);
            if (a<-1e1000) or (b>+1e1000) then
              begin
{
                writeln;
                writeln('  Unit ZEROES has been looking for a zero in ',ErrorIdentifier);
                writeln('  The originally requested search interval has been expanded ',ExpansionCount);
                writeln('  times in an effort to find points of opposite sign.');
                writeln;
                writeln('  The current limits are:');
                writeln('     a = ',a:12,'    ---->    ',ErrorIdentifier,' = ',FofA:12);
                writeln('     b = ',b:12,'    ---->    ',ErrorIdentifier,' = ',FofB:12);
                writeln;
}
                HaltForError('The search is being terminated','ZEROES');
              end;
{
            if KeyPressed then
              begin
                writeln('Status report:');
                writeln('  Unit ZEROES is looking for a zero in ',ErrorIdentifier);
                writeln('  The originally requested search interval has been expanded ',ExpansionCount);
                writeln('  times in an effort to find points of opposite sign.');
                writeln;
                writeln('  The current limits are:');
                writeln('     a = ',a:12,'    ---->    ',ErrorIdentifier,' = ',FofA:12);
                writeln('     b = ',b:12,'    ---->    ',ErrorIdentifier,' = ',FofB:12);
                writeln;
                writeln('  the search is continuing....');
                writeln;
                ClearKey;
              end;
}
            L := b - a;
            if abs(FofA)<abs(FofB) then
              begin
                a := a - L;
                X := a;
                FofA := f(X);
                if FofA=0 then exit; {X = an exact zero}
              end
            else
              begin
                b := b + L;
                X := b;
                FofB := f(X);
                if FofB=0 then exit; {X = an exact zero}
              end;
          end;
      end;

    if FofB>0 then
      begin
        if FofA>0 then
          HaltForError(ErrorIdentifier+' is positive at both '
            +Real2Str(a,0,6)+' and '+Real2Str(b,0,6),'ZEROES')
        else
          begin
            LoX := a;
            LoF := FofA;
            HiX := b;
            HiF := FofB
          end;
      end
    else {FofB<0}
      begin
        if FofA<0 then
          HaltForError(ErrorIdentifier+' is negative at both '
            +Real2Str(a,0,6)+' and '+Real2Str(b,0,6),'ZEROES')
        else
          begin
            LoX := b;
            LoF := FofB;
            HiX := a;
            HiF := FofA
          end;
      end;

    if abs(LoF)<HiF then
      LastAbsF :=  abs(LoF)
    else
      LastAbsF :=  HiF;

    UseNewtonRaphson := true;

    {The invariant of the following loop is LoF<0<HiF.  HiX and LoX are
     necessarily different, but no assumption may be made about their relative
     magnitudes (i.e. whether HiX>LoX or HiX<LoX -- this may even change during
     execution of the loop if the function has multiple zeroes).  The loop
     terminates because the width of the interval is progressively reduced by
     a finite amount -- at least equal to XError/2 -- on each repetition.  The
     goal of XError/2 is selected because an interval of length XError or
     greater can always be reduced by at least this amount by evaluating the
     midpoint.}

    while (abs(HiX-LoX)>XError) {and not KeyPressed} do
    {each repetition of the loop will replace either HiX or LoX with a new X}
      begin

        {The zero point must fall between HiX and LoX, an interval of
        length > XError .  Usually the best estimate of that point is the
        weighted average (Newton-Raphson method), but if that method has not
        been succeeding in reducing the magnitude of the function, bisecting
        the interval is sure to reduce the remaining length by at least a
        factor of 2: }

        if UseNewtonRaphson then
          begin
            X := (LoX*HiF - HiX*LoF)/(HiF - LoF);
        {since this estimate may lie close to one of the existing endpoints,
         one cannot be sure that the replacement of HiX or LowX by this new
         value will result in a reduction of the length of the interval
         between them equal or greater than the goal of XError/2.
         The following additional steps ensure that this happens without
         overriding the better estimate unless necessary.}
            if abs(X-LoX)<(XError/2) then
              begin
                if LoX<HiX then
                  X := LoX + XError/2
                else
                  X := LoX - XError/2
              end
            else if abs(X-HiX)<(XError/2) then
              begin
                if HiX<LoX then
                  X := HiX + XError/2
                else
                  X := HiX - XError/2
              end;
          end
        else {bisect interval}
          X := (LoX + HiX)/2;


        FofX := f(x);
        if FofX=0 then exit;
        if FofX>0 then
          begin
            HiX := X;
            HiF := FofX
          end
        else {FofX<0}
          begin
            LoX := X;
            LoF := FofX
          end;

      {Note:  following goal of a 4X reduction in abs(F) in order to continue
        using the Newton-Raphson technique is arbitrary }
        UseNewtonRaphson := (not UseNewtonRaphson) or (LastAbsF>4*abs(FofX));
        LastAbsF := abs(FofX);
      end;

  {Note: during execution of the preceding loop HiF is always >0 and LoF<0,
    so the following division is always possible: }

    X := (LoX*HiF - HiX*LoF)/(HiF - LoF);

  end;   {ReallyFindZero}

procedure FindZero(const f: SimpleFunction; const a, b, XError: extended; var X: extended);
  begin  {FindZero}
    ErrorIdentifier := 'Requested function';
    ReallyFindZero(f,a,b,XError,X);
  end;   {FindZero}

procedure ReallyFindMethodFunctionZero(const f: SimpleMethodFunction; a, b: extended;
  const XError: extended; var X: extended);
{both FindZero and FindMinimum will use this same procedure with different
 ErrorIdentifier's in the event of failure}
  var
    ExpansionCount : longint;
    L, HiX, LoX, HiF, LoF, FofX, FofA, FofB, LastAbsF :  extended;
    UseNewtonRaphson : boolean;

  begin  {ReallyFindMethodFunctionZero}
    X := a;
    FofA := f(X);
    if FofA=0 then exit; {X = an exact zero}
    X := b;
    FofB := f(X);
    if FofB=0 then exit; {X = an exact zero}

    if ExpandSearchInterval then
      begin
        ExpansionCount := 0;
        while ((FofA<0) and (FofB<0)) or ((FofA>0) and (FofB>0)) do
          begin
            inc(ExpansionCount);
            if (a<-1e1000) or (b>+1e1000) then
              begin
{
                writeln;
                writeln('  Unit ZEROES has been looking for a zero in ',ErrorIdentifier);
                writeln('  The originally requested search interval has been expanded ',ExpansionCount);
                writeln('  times in an effort to find points of opposite sign.');
                writeln;
                writeln('  The current limits are:');
                writeln('     a = ',a:12,'    ---->    ',ErrorIdentifier,' = ',FofA:12);
                writeln('     b = ',b:12,'    ---->    ',ErrorIdentifier,' = ',FofB:12);
                writeln;
}
                HaltForError('The search is being terminated','ZEROES');
              end;
{
            if KeyPressed then
              begin
                writeln('Status report:');
                writeln('  Unit ZEROES is looking for a zero in ',ErrorIdentifier);
                writeln('  The originally requested search interval has been expanded ',ExpansionCount);
                writeln('  times in an effort to find points of opposite sign.');
                writeln;
                writeln('  The current limits are:');
                writeln('     a = ',a:12,'    ---->    ',ErrorIdentifier,' = ',FofA:12);
                writeln('     b = ',b:12,'    ---->    ',ErrorIdentifier,' = ',FofB:12);
                writeln;
                writeln('  the search is continuing....');
                writeln;
                ClearKey;
              end;
}
            L := b - a;
            if abs(FofA)<abs(FofB) then
              begin
                a := a - L;
                X := a;
                FofA := f(X);
                if FofA=0 then exit; {X = an exact zero}
              end
            else
              begin
                b := b + L;
                X := b;
                FofB := f(X);
                if FofB=0 then exit; {X = an exact zero}
              end;
          end;
      end;

    if FofB>0 then
      begin
        if FofA>0 then
          HaltForError(ErrorIdentifier+' is positive at both '
            +Real2Str(a,0,6)+' and '+Real2Str(b,0,6),'ZEROES')
        else
          begin
            LoX := a;
            LoF := FofA;
            HiX := b;
            HiF := FofB
          end;
      end
    else {FofB<0}
      begin
        if FofA<0 then
          HaltForError(ErrorIdentifier+' is negative at both '
            +Real2Str(a,0,6)+' and '+Real2Str(b,0,6),'ZEROES')
        else
          begin
            LoX := b;
            LoF := FofB;
            HiX := a;
            HiF := FofA
          end;
      end;

    if abs(LoF)<HiF then
      LastAbsF :=  abs(LoF)
    else
      LastAbsF :=  HiF;

    UseNewtonRaphson := true;

    {The invariant of the following loop is LoF<0<HiF.  HiX and LoX are
     necessarily different, but no assumption may be made about their relative
     magnitudes (i.e. whether HiX>LoX or HiX<LoX -- this may even change during
     execution of the loop if the function has multiple zeroes).  The loop
     terminates because the width of the interval is progressively reduced by
     a finite amount -- at least equal to XError/2 -- on each repetition.  The
     goal of XError/2 is selected because an interval of length XError or
     greater can always be reduced by at least this amount by evaluating the
     midpoint.}

    while (abs(HiX-LoX)>XError) {and not KeyPressed} do
    {each repetition of the loop will replace either HiX or LoX with a new X}
      begin

        {The zero point must fall between HiX and LoX, an interval of
        length > XError .  Usually the best estimate of that point is the
        weighted average (Newton-Raphson method), but if that method has not
        been succeeding in reducing the magnitude of the function, bisecting
        the interval is sure to reduce the remaining length by at least a
        factor of 2: }

        if UseNewtonRaphson then
          begin
            X := (LoX*HiF - HiX*LoF)/(HiF - LoF);
        {since this estimate may lie close to one of the existing endpoints,
         one cannot be sure that the replacement of HiX or LowX by this new
         value will result in a reduction of the length of the interval
         between them equal or greater than the goal of XError/2.
         The following additional steps ensure that this happens without
         overriding the better estimate unless necessary.}
            if abs(X-LoX)<(XError/2) then
              begin
                if LoX<HiX then
                  X := LoX + XError/2
                else
                  X := LoX - XError/2
              end
            else if abs(X-HiX)<(XError/2) then
              begin
                if HiX<LoX then
                  X := HiX + XError/2
                else
                  X := HiX - XError/2
              end;
          end
        else {bisect interval}
          X := (LoX + HiX)/2;


        FofX := f(x);
        if FofX=0 then exit;
        if FofX>0 then
          begin
            HiX := X;
            HiF := FofX
          end
        else {FofX<0}
          begin
            LoX := X;
            LoF := FofX
          end;

      {Note:  following goal of a 4X reduction in abs(F) in order to continue
        using the Newton-Raphson technique is arbitrary }
        UseNewtonRaphson := (not UseNewtonRaphson) or (LastAbsF>4*abs(FofX));
        LastAbsF := abs(FofX);
      end;

  {Note: during execution of the preceding loop HiF is always >0 and LoF<0,
    so the following division is always possible: }

    X := (LoX*HiF - HiX*LoF)/(HiF - LoF);

  end;   {ReallyFindMethodFunctionZero}

procedure FindMethodFunctionZero(const f: SimpleMethodFunction; const a, b, XError: extended; var X: extended);
  begin  {FindZero}
    ErrorIdentifier := 'Requested function';
    ReallyFindMethodFunctionZero(f,a,b,XError,X);
  end;   {FindZero}

function DerivativeOfG(const X: extended) : extended; far;
{Note: FindMinimum works by setting the identity of "g" and the desired
  value of "Epsilon" then searching for the zero of this new SimpleFunction.
  Division by the interval length, Epsilon, is not necessary, since the
  result only needs to be proportional to the derivative}
  var
    F1, F2 : extended;
  begin {DerivativeOfG}
//    ShowMessage(Format('Testing X = %0.6f',[X]));
    F1 := g(X - Epsilon);
    F2 := g(X);
    DerivativeOfG := F2 - F1;
  end;  {DerivativeOfG}

procedure FindMinimum(const f: SimpleFunction; const a, b, XError: extended;
  var X: extended);
  var
    OldG : SimpleFunction;
    OldEpsilon : extended;
  begin  {FindMinimum}
    OldG := g;
    OldEpsilon := Epsilon;
    Epsilon := XError/10;
    g := f;
    ErrorIdentifier := 'Deriv. of requested fn.';
    ReallyFindZero(DerivativeOfG,a,b,XError,X);
    Epsilon := OldEpsilon;
    g := OldG;
  end;   {FindMinimum}

function DummyFunctionForGF(const X : extended): extended; far;
  var
    MyResult : extended;
  begin
    TestVariablePtr^ := X;   {load global variable}
    MyResult := FunctionToOptimize; {execute global function}
    if WriteDummyGFResultOnScreen then writeln('   ',X:0:9,' ---> ',Result:0:9);
    DummyFunctionForGF := MyResult;
  end;

procedure OptimizeGlobalFunction(var Outfile: text; const f: GlobalFunction;
  var V: extended; const VariableID: string; const a, b, XError: extended);
{Searches for a zero in the derivative of "f" produced by varying the
 global variable "V"}
  var
    OldFunctionToOptimize : GlobalFunction;
    OldTestVariablePtr : VariablePtr;
    OldWriteStatus : boolean;

  begin
    OldFunctionToOptimize := FunctionToOptimize;
    OldTestVariablePtr := TestVariablePtr;
    OldWriteStatus := WriteDummyGFResultOnScreen;
    WriteDummyGFResultOnScreen := (@Outfile=@Output);
    writeln(Outfile,'Searching for optimum ',VariableID,
      ' with an accuracy of ',XError:0:9,' ...');
    FunctionToOptimize := f;
    TestVariablePtr := @V;
    FindMinimum(DummyFunctionForGF,a,b,XError,V);
{    if KeyPressed then
      writeln(Outfile,'Terminated by request.')
    else  }
      writeln(Outfile,'The optimized value of ',VariableID,' is: ',V:0:6);
    TestVariablePtr := OldTestVariablePtr;
    FunctionToOptimize := OldFunctionToOptimize;
    WriteDummyGFResultOnScreen := OldWriteStatus;
  end;

procedure SilentOptimizeGlobalFunction(const f: GlobalFunction;
  var V: extended; const a, b, XError: extended);
{same but without file output}
  var
    OldFunctionToOptimize : GlobalFunction;
    OldTestVariablePtr : VariablePtr;

  begin
    OldFunctionToOptimize := FunctionToOptimize;
    OldTestVariablePtr := TestVariablePtr;
    FunctionToOptimize := f;
    TestVariablePtr := @V;
    FindMinimum(DummyFunctionForGF,a,b,XError,V);
    TestVariablePtr := OldTestVariablePtr;
    FunctionToOptimize := OldFunctionToOptimize;
  end;

function DummyFunctionForGP(const X : extended): extended; far;
  begin
    TestVariablePtr^ := X;   {load global variable}
    ProcedureToOptimize;     {execute global procedure}
    DummyFunctionForGP := ResultVariablePtr^; {retrieve result}
  end;

procedure OptimizeGlobalProcedure(var Outfile: text; const p: GlobalProcedure;
  var V1, V2: extended; const Variable1ID, Variable2ID: string;
  const a, b, XError: extended);
{Searches for a zero in the derivative of global variable "V2" produced by
 executing procedure "p" while varying the global variable "V1"}
  var
    OldProcedureToOptimize : GlobalProcedure;
    OldTestVariablePtr, OldResultVariablePtr : VariablePtr;
  begin
    OldProcedureToOptimize := ProcedureToOptimize;
    OldTestVariablePtr := TestVariablePtr;
    OldResultVariablePtr := ResultVariablePtr;
    writeln(Outfile,'Optimizing ',Variable1ID,' for zero in derivative of ',
      Variable2ID,' with an accuracy of ',XError:0:9,' ...');
    ProcedureToOptimize := p;
    TestVariablePtr := @V1;
    ResultVariablePtr := @V2;
    FindMinimum(DummyFunctionForGP,a,b,XError,V1);
{    if KeyPressed then
      writeln(Outfile,'Terminated by request.')
    else}
      writeln(Outfile,'The optimized value of ',Variable1ID,' is: ',V1:0:6,
        ' giving ',Variable2ID,' = ',V2:0:6);
    ResultVariablePtr := OldResultVariablePtr;
    TestVariablePtr := OldTestVariablePtr;
    ProcedureToOptimize := OldProcedureToOptimize;
  end;


begin
end.