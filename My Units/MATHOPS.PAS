unit MathOps;

interface

function InterpolatedF(a,b,c, x,y,z, d: real): real;
{ estimates value of function at pt. d  based on values x,y,z  at pts.  a,b,c }

function Poly(var PolyCoeffs; Size: integer; X: real): real;
{  returns value of a polynomial at point X, with PolyCoeffs being the array
   of REAL coefficients for the 0th through Nth power of X.  The second
   parameter in the call is the size of this array (in bytes), from which
   the order of the polynomial will be determined.  Thus a typical call is:
           Answer := Poly(UserCoeffs, SizeOf(UserCoeffs), x)         }

function ExtendedPoly(var PolyCoeffs; N: integer; X: extended): extended;
{  returns value of a polynomial at point X, with PolyCoeffs being the array
   of extended coefficients for the 0th through Nth power of X.
   A typical call is:
           Answer := Poly(UserCoeffs, Order, x)         }

procedure SolveQuadratic(a,b,c : extended; var x1, x2 : extended; var NRoots : integer);
{solves quadratic equation of form:
                     0 = ax^2 + bx + c     for real roots, x1 & x2,
  with NRoots = 0 --> no real roots; 1 --> single real root in x1;
  2 --> valid real roots in both x1 & x2 in ascending order}

procedure SolveQuadratic2(const a,b,c : extended; var x1, x2 : extended; var NRoots : integer);
{solves quadratic equation of form:
                     0 = ax^2 + 2bx + c     for real roots, x1 & x2,
  with NRoots = 0 --> no real roots; 1 --> single real root in x1;
  2 --> valid real roots in both x1 & x2 in ascending order.

 Note: the only difference between this and SolveQuadratic is in the assumed
  coefficient of the "b" term, but this simplifies the implementation.}

FUNCTION BesselJ0(x: extended): extended;
{1st order Bessel Function J0(x) from NRPas13}

FUNCTION BesselJ1(x: extended): extended;
{1st order Bessel Function J1(x) from NRPas13}
{ The diffraction pattern from a circular aperture of diameter D at angle Theta is :
     Sqr(2*J1(X)/X  with  X = (pi/Lambda)*D sin(Theta)  .
  The fraction of energy from X = 0 to R is  1 - Sqr(J0(R) - Sqr(J1(R) .}

implementation

function InterpolatedF(a,b,c, x,y,z, d: real): real;
  begin
    InterpolatedF :=
            ((d-b)/(a-b))*((d-c)/(a-c))*x
          + ((d-c)/(b-c))*((d-a)/(b-a))*y
          + ((d-a)/(c-a))*((d-b)/(c-b))*z
  end;

function Poly(var PolyCoeffs; Size: integer; X: real): real;
  var
    Coeff  : array[1..10000] of real absolute PolyCoeffs;
    n      : integer;
    Sum    : real;

  begin
    n := Size div SizeOf(real);   {each real coefficient occupies 6 bytes}
    Sum := Coeff[n];
    for n := (n-1) downto 1 do
      Sum := Sum*X + Coeff[n];
    Poly  := Sum
  end;

function ExtendedPoly(var PolyCoeffs; N: integer; X: extended): extended;
  var
    Coeff : array[0..6400] of extended absolute PolyCoeffs;
    Power : integer;
    Sum    : extended;

  begin
    Sum := Coeff[N];
    for Power := (N-1) downto 0 do
      Sum := Sum*X + Coeff[Power];
    ExtendedPoly  := Sum
  end;

procedure SolveQuadratic(a,b,c : extended; var x1, x2 : extended; var NRoots : integer);
  var
    d, dsqr : extended;
  begin
    if a = 0 then
      begin
        if b = 0 then
          NRoots := 0
        else
          begin
            NRoots := 1;
            x1 := -c/b
          end
      end
    else
      begin
        dsqr := sqr(b) - 4*a*c;
        if dsqr>0 then
          begin
            d := sqrt(dsqr);
            NRoots := 2;
            if a>0 then
              begin
                x1 := (-b - d)/(2*a);
                x2 := (-b + d)/(2*a)
              end
            else {a<0}
              begin
                x1 := (-b + d)/(2*a);
                x2 := (-b - d)/(2*a)
              end
          end
        else if dsqr = 0 then
          begin
            NRoots := 1;
            x1 := -b/(2*a);
          end
        else {dsqr<0}
          NRoots :=0
      end;
  end;

procedure SolveQuadratic2(const a,b,c : extended; var x1, x2 : extended; var NRoots : integer);
  var
    d, dsqr : extended;
  begin
    if a = 0 then
      begin
        if b = 0 then
          NRoots := 0
        else
          begin
            NRoots := 1;
            x1 := -c/b/2
          end
      end
    else
      begin
        dsqr := sqr(b) - a*c;
        if dsqr>0 then
          begin
            d := sqrt(dsqr);
            NRoots := 2;
            if a>0 then
              begin
                x1 := (-b - d)/a;
                x2 := (-b + d)/a
              end
            else {a<0}
              begin
                x1 := (-b + d)/a;
                x2 := (-b - d)/a
              end
          end
        else if dsqr = 0 then
          begin
            NRoots := 1;
            x1 := -b/a;
          end
        else {dsqr<0}
          NRoots :=0
      end;
  end;

FUNCTION BesselJ0(x: extended): extended;
{This is from NRPAS13.zip.  For X<5 it differs from Abramowitz & Stegun by a few
 in the 9th decimal place.  For larger X it is more accurate.}
VAR
   ax,xx,z: extended;  y,ans1,ans2: extended;

BEGIN {BesselJ0}
   IF (abs(x) < 8.0) THEN BEGIN
      y := sqr(x);
      ans1 := 57568490574.0+y*(-13362590354.0+y*(651619640.7
         +y*(-11214424.18+y*(77392.33017+y*(-184.9052456)))));
      ans2 := 57568490411.0+y*(1029532985.0+y*(9494680.718
         +y*(59272.64853+y*(267.8532712+y*1.0))));
      BesselJ0 := ans1/ans2  END
   ELSE BEGIN
      ax := abs(x); z := 8.0/ax; y := sqr(z); xx := ax-0.785398164;
      ans1 := 1.0+y*(-0.1098628627e-2+y*(0.2734510407e-4
         +y*(-0.2073370639e-5+y*0.2093887211e-6)));
      ans2 := -0.1562499995e-1+y*(0.1430488765e-3
         +y*(-0.6911147651e-5+y*(0.7621095161e-6
         -y*0.934945152e-7)));
      BesselJ0 := sqrt(0.636619772/ax)*(cos(xx)*ans1-z*sin(xx)*ans2);
        END
END;  {BesselJ0}

FUNCTION BesselJ1(x: extended): extended;
{This is from NRPAS13.zip.  It agrees with Abramowitz & Stegun to 10 decimal places
 at X = 0 and 15 with errors of a few in the last decimal place at intermediate X.}
VAR
   ax,xx,z: extended;  y,ans1,ans2: extended;

FUNCTION sign(x: extended): extended;
   BEGIN
      IF x >= 0.0 THEN sign := 1.0
      ELSE sign := -1.0;
   END;

BEGIN {BesselJ1}
   IF (abs(x) < 8.0) THEN BEGIN
      y := sqr(x);
      ans1 := x*(72362614232.0+y*(-7895059235.0+y*(242396853.1
         +y*(-2972611.439+y*(15704.48260+y*(-30.16036606))))));
      ans2 := 144725228442.0+y*(2300535178.0+y*(18583304.74
         +y*(99447.43394+y*(376.9991397+y*1.0))));
      BesselJ1 := ans1/ans2  END
   ELSE BEGIN
      ax := abs(x); z := 8.0/ax; y := sqr(z); xx := ax-2.356194491;
      ans1 := 1.0+y*(0.183105e-2+y*(-0.3516396496e-4
         +y*(0.2457520174e-5+y*(-0.240337019e-6))));
      ans2 := 0.04687499995+y*(-0.2002690873e-3
         +y*(0.8449199096e-5+y*(-0.88228987e-6+y*0.105787412e-6)));
      BesselJ1 := sqrt(0.636619772/ax)*(cos(xx)*ans1
         -z*sin(xx)*ans2)*sign(x) END
END;  {BesselJ1}

end.
