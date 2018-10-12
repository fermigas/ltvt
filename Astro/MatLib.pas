(*-----------------------------------------------------------------------*)
(* Unit MATLIB : mathematical functions and subroutines                  *)
(*-----------------------------------------------------------------------*)

UNIT MATLIB;

INTERFACE

  uses Constnts;

  type REAL = extended;

  (* vectors and matrices *)

  TYPE INDEX  = (X,Y,Z);
       VECTOR = ARRAY[INDEX] OF REAL;
       REAL3  = ARRAY[1.. 3] OF REAL;
       REAL33 = ARRAY[1.. 3] OF REAL3;
       MAT3X  = ARRAY[1.. 3] OF VECTOR;

  (* Chebyshev polynomials *)

  CONST MAX_TP_DEG  = 13;                        (* maximum degree       *)
  TYPE  TPOLYNOM = RECORD                        (* Chebyshev polynomial *)
                     M  : INTEGER;                       (* degree       *)
                     A,B: REAL;                          (* interval     *)
                     C  : ARRAY [0..MAX_TP_DEG] OF REAL; (* coefficients *)
                   END;

  (* Vector and matrix for least squares systems:                    *)
  (* minimum dimensions for use with program FOTO are given below;   *)
  (* they may be increased as needed by the user.                    *)

  TYPE  LSQVEC =  ARRAY[1..3] OF REAL;
        LSQMAT =  ARRAY[1..30,1..5] OF REAL;


  (* functions and procedures *)

  FUNCTION  ACS    ( X: REAL ): REAL;
  FUNCTION  ASN    ( X: REAL ): REAL;
  FUNCTION  ATN    ( X: REAL ): REAL;
  FUNCTION  ATN2   ( Y,X: REAL ): REAL;
  PROCEDURE CART   ( R,THETA,PHI: REAL; VAR X,Y,Z: REAL );
  PROCEDURE CROSS  ( A,B: VECTOR; VAR C: VECTOR );
  FUNCTION  CS     ( X: REAL ): REAL;
  FUNCTION  CUBR   ( X: REAL ): REAL;
  FUNCTION  DOT    ( A,B: VECTOR ): REAL;
  PROCEDURE DDD    ( D,M: INTEGER;S: REAL;VAR DD: REAL );
  PROCEDURE DMS    ( DD: REAL;VAR D,M: INTEGER;VAR S: REAL );
  PROCEDURE LSQFIT ( A: LSQMAT; N,M: INTEGER; VAR S: LSQVEC );
  FUNCTION  NORM   ( A: VECTOR ): REAL;
  PROCEDURE POLAR  ( X,Y,Z: REAL; VAR R,THETA,PHI: REAL );
  PROCEDURE QUAD   ( Y_MINUS,Y_0,Y_PLUS:  REAL;
                     VAR XE,YE,ZERO1,ZERO2: REAL; VAR NZ: INTEGER );
  FUNCTION  SN     ( X: REAL ): REAL;
  FUNCTION  T_EVAL ( F:  TPOLYNOM; X:  REAL ):  REAL;
  FUNCTION  TN     ( X: REAL ): REAL;

IMPLEMENTATION

(*-----------------------------------------------------------------------*)
(* ACS: arccosine function (degrees)                                     *)
(*-----------------------------------------------------------------------*)
FUNCTION ACS(X:REAL):REAL;
  CONST EPS=1E-9; C=90.0;   {was EPS=1E-7}
  BEGIN
    IF ABS(X)=1.0
     THEN ACS:=C-X*C
     ELSE IF (ABS(X)>EPS) THEN ACS:=C-ARCTAN(X/SQRT((1.0-X)*(1.0+X)))/RAD
                           ELSE ACS:=C-X/RAD;
  END;
(*-----------------------------------------------------------------------*)
(* ASN: arcsine function (degrees)                                       *)
(*-----------------------------------------------------------------------*)
FUNCTION ASN(X:REAL):REAL;
  CONST EPS=1E-9;     {was EPS=1E-7}
  BEGIN
    IF ABS(X)>=1.0 {Note: inserted > to correct hangups on values close to 1}
      THEN ASN:=90.0*X
      ELSE IF (ABS(X)>EPS) THEN ASN:=ARCTAN(X/SQRT((1.0-X)*(1.0+X)))/RAD
                           ELSE ASN:=X/RAD;
  END;
(*-----------------------------------------------------------------------*)
(* ATN: arctangent function (degrees)                                    *)
(*-----------------------------------------------------------------------*)
FUNCTION ATN(X:REAL):REAL;
  BEGIN
    ATN:=ARCTAN(X)/RAD
  END;
(*-----------------------------------------------------------------------*)
(* ATN2: arctangent of y/x for two arguments                             *)
(*       (correct quadrant; -180 deg <= ATN2 <= +180 deg)                *)
(*-----------------------------------------------------------------------*)
FUNCTION ATN2(Y,X:REAL):REAL;
  VAR   AX,AY,PHI: REAL;
  BEGIN
    IF (X=0.0) AND (Y=0.0) 
      THEN ATN2:=0.0
      ELSE
        BEGIN
          AX:=ABS(X); AY:=ABS(Y); 
          IF (AX>AY) 
            THEN PHI:=ARCTAN(AY/AX)/RAD 
            ELSE PHI:=90.0-ARCTAN(AX/AY)/RAD;
          IF (X<0.0) THEN PHI:=180.0-PHI;
          IF (Y<0.0) THEN PHI:=-PHI;
          ATN2:=PHI;
        END;
  END;
(*-----------------------------------------------------------------------*)
(* CART: conversion of polar coordinates (r,theta,phi)                   *)
(*       into cartesian coordinates (x,y,z)                              *)
(*       (theta in [-90 deg,+90 deg]; phi in [-360 deg,+360 deg])        *)
(*-----------------------------------------------------------------------*)
PROCEDURE CART(R,THETA,PHI: REAL; VAR X,Y,Z: REAL);
  VAR RCST : REAL;
  BEGIN
    RCST := R*CS(THETA);
    X    := RCST*CS(PHI); Y := RCST*SN(PHI); Z := R*SN(THETA)
  END;
(*-----------------------------------------------------------------------*)
(* CROSS: cross product of two vectors                                   *)
(*-----------------------------------------------------------------------*)
PROCEDURE CROSS(A,B:VECTOR;VAR C:VECTOR);
  BEGIN
    C[X] := A[Y]*B[Z]-A[Z]*B[Y];
    C[Y] := A[Z]*B[X]-A[X]*B[Z];
    C[Z] := A[X]*B[Y]-A[Y]*B[X];
  END;

(*-----------------------------------------------------------------------*)
(* CS: cosine function (degrees)                                         *)
(*-----------------------------------------------------------------------*)
FUNCTION CS(X:REAL):REAL;
  BEGIN
    CS:=COS(X*RAD) 
  END;
(*-----------------------------------------------------------------------*)
(* CUBR: cube root                                                       *)
(*-----------------------------------------------------------------------*)
FUNCTION CUBR(X:REAL):REAL;
  BEGIN
    IF (X=0.0)  THEN CUBR:=0.0  ELSE CUBR:=EXP(LN(X)/3.0)
  END;
(*-----------------------------------------------------------------------*)
(* DOT: dot product of two vectors                                       *)
(*-----------------------------------------------------------------------*)
FUNCTION DOT(A,B:VECTOR):REAL;
  BEGIN
    DOT := A[X]*B[X]+A[Y]*B[Y]+A[Z]*B[Z];
  END;

(*-----------------------------------------------------------------------*)
(* DDD: conversion of degrees, minutes and seconds into                  *)
(*      degrees and fractions of a degree                                *)
(*-----------------------------------------------------------------------*)
PROCEDURE DDD(D,M:INTEGER;S:REAL;VAR DD:REAL);
 VAR SIGN: REAL;
  BEGIN
    IF ( (D<0) OR (M<0) OR (S<0) ) THEN SIGN:=-1.0 ELSE SIGN:=1.0;
    DD:=SIGN*(ABS(D)+ABS(M)/60.0+ABS(S)/3600.0);
  END;
(*-----------------------------------------------------------------------*)
(* DMS: conversion of degrees and fractions of a degree                  *)
(*      into degrees, minutes and seconds                                *)
(*-----------------------------------------------------------------------*)
PROCEDURE DMS(DD:REAL;VAR D,M:INTEGER;VAR S:REAL);
  VAR D1:REAL; 
  BEGIN
    D1:=ABS(DD);  D:=TRUNC(D1);  
    D1:=(D1-D)*60.0;  M:=TRUNC(D1);  S:=(D1-M)*60.0;
    IF (DD<0) THEN 
      IF (D>0) THEN D:=-D ELSE IF (M<>0) THEN M:=-M ELSE S:=-S;
  END;
(*-----------------------------------------------------------------------*)
(* LSQFIT:                                                               *)
(*   solution of an overdetermined system of linear equations            *)
(*   A[i,1]*s[1]+...A[i,m]*s[m] - A[i,m+1] = 0   (i=1,..,n)              *)
(*   according to the method of least squares using Givens rotations     *)
(*   A: matrix of coefficients                                           *)
(*   N: number of equations  (rows of A)                                 *)
(*   M: number of unknowns   (columns of A, elemnts of S)                *)
(*   S: solution vector                                                  *)
(*-----------------------------------------------------------------------*)
PROCEDURE LSQFIT ( A: LSQMAT; N, M: INTEGER; VAR S: LSQVEC );

  CONST EPS = 1.0E-10;  (* machine accuracy *)

  VAR I,J,K: INTEGER;
      P,Q,H: REAL;

  BEGIN

    FOR J:=1 TO M DO  (* loop over columns 1...M of A *)

      (* eliminate matrix elements A[i,j] with i>j from column j *)

      FOR I:=J+1 TO N DO
        IF A[I,J]<>0.0 THEN
          BEGIN
            (* calculate p, q and new A[j,j]; set A[i,j]=0 *)
            IF ( ABS(A[J,J])<EPS*ABS(A[I,J]) )
              THEN
                BEGIN
                  P:=0.0; Q:=1.0; A[J,J]:=-A[I,J]; A[I,J]:=0.0;
                END
              ELSE
                BEGIN
                  H:=SQRT(A[J,J]*A[J,J]+A[I,J]*A[I,J]);
                  IF A[J,J]<0.0 THEN H:=-H;
                  P:=A[J,J]/H; Q:=-A[I,J]/H; A[J,J]:=H; A[I,J]:=0.0;
                END;
            (*  calculate rest of the line *)
            FOR K:=J+1 TO M+1 DO
              BEGIN
                H      := P*A[J,K] - Q*A[I,K];
                A[I,K] := Q*A[J,K] + P*A[I,K];
                A[J,K] := H;
              END;
          END;

    (* backsubstitution *)

    FOR I:=M DOWNTO 1 DO
      BEGIN
        H:=A[I,M+1];
        FOR K:=I+1 TO M DO H:=H+A[I,K]*S[K];
        S[I] := -H/A[I,I];
      END;

  END;  (* LSQFIT *)

(*-----------------------------------------------------------------------*)
(* NORM: magnitude of a vector                                           *)
(*-----------------------------------------------------------------------*)
FUNCTION NORM(A:VECTOR):REAL;
  BEGIN 
    NORM := SQRT(DOT(A,A));
  END;

(*-----------------------------------------------------------------------*)
(* POLAR: conversion of cartesian coordinates (x,y,z)                    *)
(*        into polar coordinates (r,theta,phi)                           *)
(*        (theta in [-90 deg,+90 deg]; phi in [-180 deg,+180 deg])       *)
(*-----------------------------------------------------------------------*)
PROCEDURE POLAR(X,Y,Z:REAL;VAR R,THETA,PHI:REAL);
  VAR RHO: REAL;
  BEGIN
    RHO:=X*X+Y*Y;  R:=SQRT(RHO+Z*Z);  
    PHI:=ATN2(Y,X); IF PHI<0 THEN PHI:=PHI+360.0;
    RHO:=SQRT(RHO); THETA:=ATN2(Z,RHO);
  END;
(*-----------------------------------------------------------------------*)
(* QUAD: finds a parabola through 3 points                               *)
(*       (-1,Y_MINUS), (0,Y_0) und (1,Y_PLUS),                           *)
(*       that do not lie on a straight line.                             *)
(*                                                                       *)
(*      Y_MINUS,Y_0,Y_PLUS: three y-values                               *)
(*      XE,YE   : x and y of the extreme value of the parabola           *)
(*      ZERO1   : first root within [-1,+1] (for NZ=1,2)                 *)
(*      ZERO2   : second root within [-1,+1] (only for NZ=2)             *)
(*      NZ      : number of roots within the interval [-1,+1]            *)
(*-----------------------------------------------------------------------*)
PROCEDURE QUAD(Y_MINUS,Y_0,Y_PLUS: REAL; 
               VAR XE,YE,ZERO1,ZERO2: REAL; VAR NZ: INTEGER);
  VAR A,B,C,DIS,DX: REAL;
  BEGIN
    NZ := 0;
    A  := 0.5*(Y_MINUS+Y_PLUS)-Y_0; B := 0.5*(Y_PLUS-Y_MINUS); C := Y_0;
    XE := -B/(2.0*A); YE := (A*XE + B) * XE + C;
    DIS := B*B - 4.0*A*C; (* discriminant of y = axx+bx+c *)
    IF (DIS >= 0) THEN    (* parabola intersects x-axis   *)
      BEGIN
        DX := 0.5*SQRT(DIS)/ABS(A); ZERO1 := XE-DX; ZERO2 := XE+DX;
        IF (ABS(ZERO1) <= +1.0) THEN NZ := NZ + 1;  
        IF (ABS(ZERO2) <= +1.0) THEN NZ := NZ + 1;
        IF (ZERO1<-1.0) THEN ZERO1:=ZERO2;
      END;
    END;
(*-----------------------------------------------------------------------*)
(* SN: sine function (degrees)                                           *)
(*-----------------------------------------------------------------------*)
FUNCTION SN(X:REAL):REAL;
  BEGIN
    SN:=SIN(X*RAD)
  END;
(*-----------------------------------------------------------------------*)
(* T_EVAL: evaluates the approximation of a function by Chebyshev        *)
(*         polynomials of maximum order F.M over the interval [F.A,F.B]  *)
(*  F : record containing the Chebyshev coefficients                     *)  
(*  X : argument                                                         *)
(*-----------------------------------------------------------------------*)
 FUNCTION T_EVAL(F: TPOLYNOM; X: REAL): REAL;
  VAR F1,F2,OLD_F1,XX,XX2 : REAL;
      I                : INTEGER;
  BEGIN
    IF ( (X<F.A) OR (F.B<X) ) THEN
      BEGIN WRITELN(' T_EVAL : x not within [a,b]'); END;
    F1 := 0.0;  F2 := 0.0;
    XX := (2.0*X-F.A-F.B)/(F.B-F.A);  XX2 := 2.0*XX;
    FOR I := F.M DOWNTO 1 DO
      BEGIN OLD_F1 := F1; F1 := XX2*F1-F2+F.C[I];  F2 := OLD_F1;  END;
    T_EVAL := XX*F1-F2+0.5*F.C[0]
  END;

(*-----------------------------------------------------------------------*)
(* TN: tangent function (degrees)                                        *)
(*-----------------------------------------------------------------------*)
FUNCTION TN(X:REAL):REAL;
  VAR XX: REAL;
  BEGIN
    XX:=X*RAD; TN:=SIN(XX)/COS(XX);
  END;

END.

