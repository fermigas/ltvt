unit H_JPL_Ephemeris;
{This unit provides functions for obtaining interpolated ephemeris data from a
 binary ephemeris file.  It can use files in either Unix or Delphi format depending
 on the compiler directive at the start of the implementation section.  Delphi format
 files should work faster since the data does not have to be translated by reversing
 the byte order.  The penalty for Unix translation seems to be about a 1.5x increase
 in the time required to obtain an interpolation.}

{ for additional documentation see:
"C:\Program Files\Borland\Delphi6\Projects\MyProjects\Astron\JPL Ephemeris\JPL_Notes.txt" }

{10/17/2006:  This unit originally used a single ephemeris file, loaded during the
initialization.  For use with LTVT a capability to change the file at runtime was added.
However the original implementation made certain checks to determine if a new data block
actually had to be read.  This was done with typed constants which could be used to detect
if there was a change in the time or record number required.

In the new scheme, this can lead to confusion with a dates with similar displacements
into the file are requested from different 50 year blocks.  E.g. 1/1/1800 at 0000 UT vs.
1/1/2000 at 0000UT -- the change in filename may go undetected, so that data from the old
file will be assumed useable for the new one, yielding incorrect results.  To prevent this
possibility, the typed constants were moved out of STATE and INTERP.  They are now
global variables and are re-initialized each time a new ephemeris file is loaded.
So the first read of a newly-loaded file is similar to the same as the first read of
the fixed file in the old scheme.}

interface

uses
  MPVectors;

type
  TPV = array[1..6] of extended;  {position-velocity array}

  TTargetOptions = (DontCare, Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus,
    Neptune, Pluto, Moon, Sun, SolarSystemBarycenter, EarthMoonBarycenter, Nutations,
    Librations );  {This sequences maps Ord(TTargetOptions) --> NTARG, NCENT in PLEPH}

  TVelocityOptions = (PositionsOnly, PositionsAndVelocities);

  TUnitsOptions =(AU_day, KM_sec);

  TEphemerisOutput = record
  {this definition defines five alternative formats for reading the results
   returned by PLEPH which always consist of an array of 6 extended values --
   NOTE: when defined as a record the variable is padded at the end to make an
   "even" size -- in this case four bytes of padding give a total storage length
   of 64 bytes.  The "Tag = integer" does not enter into this calculation.}

    case Integer of
      0:  {generic format}
        (  OutputValue : TPV;
        );

      1: {normal case:  NTarg = 1..13;  NCent = 1..13}
         (
           R,                 {distance in AU or km}
           R_dot : TVector;   {velocity in AU/day or km/sec}
         );

     {According to Kaplan et al. (AJ97, 1197), the results for T = solar system
      barycentric time (TDB = "Ephemeris time") are returned in a rectangular system with
      X = mean equinox and Z = mean north pole of epoch Jo = 2451545.0 (= "J2000").
      According to the Readme by Myles Standish, DE200 "is based upon the dynamical
      equator and equinox of J2000" while DE405 "is based upon the International
      Celestial Reference Frame (ICRF)."  The two frames are said to differ by
      less than 0.01 arcseconds.}

{NOTE: this was originally of type Vector from MVectors.pas -- a Record of 3
  extended values --  but they turn out to be stored as an array of 32 bytes,
  and two such records in succession could not be overlaid with the other 60-byte
  definitions.  MPVectors overcomes this problem by defining TVector as an array
  of three extended values}

  {the following are alternative ways of refering to the same six extended values:}

      2: {normal case:  NTarg = 1..13;  NCent = 1..13}
         (
           X, Y, Z,                          {distance in AU or km}
           X_dot, Y_dot, Z_dot : extended;   {velocity in AU/day or km/sec}
         );

      3: {nutations:   NTarg = 14;      NCent = n/a  --  note only 4 values are defined}
         (
           d_psi,                    {longitude [rads]}
           d_eps,                    {obliquity [rads]}
           UnusedValue1,
           d_psi_dot,                {change [rads/day] or [rads/sec]}
           d_eps_dot,                {change [rads/day]}
           UnusedValue2 : extended;
         );

      4:  {librations:   NTarg = 15;      NCent = n/a}
        (
           Angle1,                    {Euler angles [rads]}
           Angle2,
           Angle3,
           Angle1_dot,                {change [rads/day]}
           Angle2_dot,
           Angle3_dot : extended;
         );

    end;

var
{the following global switches are looked at by PLEPH, STATE and/or INTERP. They are
 automatically overwritten and restored to the previous values if the ReadEphemeris
 interface is used.  They function as noted:}

  KM   : boolean = false;   {TRUE = KM AND KM/SEC;   RAD/SEC for Nutations & Librations
                             FALSE = AU AND AU/DAY;  RAD/DAY for Nutations & Librations}
                            {Note: the native format of the data files is KM and DAY}

  WantVelocities : boolean = true;  {TRUE  = PLEPH requests positions and velocities
                                     FALSE = PLEPH requests positions only}

{the following global variables, which may be of interest to a program using the
 ephemeris, are read from HeaderBlock1 in the Intialization section below}
  NUMDE : integer;  {ephemeris Development Number, e.g., 405}
  SS : array[1..3] of extended;  {start JD, end JD and block length in days for whole file read from HeaderRecord1}
  AU  : extended;  {astronomical unit in kilometers}
  EMRAT : extended;  {Earth-Moon mass ratio}
  IPT : array[1..3,1..13] of integer; {pointers to planet, nutation AND libration
    Chebyshev coefficent locations in BUF;  IPT[2,12]<>0 indicates earth polar
    nutations are present;  IPT[2,13]<>0 indicates lunar librations are present}

{the following allow this unit to continue functioning (with error messages) even
 if an Ephemeris file cannot be found}
   EphemerisFileLoaded : boolean;
   EphemerisFilname : string;
   BlankTPV : TPV;  {zero-vector returned when no data available}

procedure LoadJPL_File(const SuggestedName : string);
{Closes current binary file, if one is open, and attempts to open the requested one.
Generates a file-opening dialog if it cannot be found. Check EphemerisFileLoaded
and EphemerisFile name to find what actually happened.}

procedure ReadEphemeris(const TDB : extended; const Target, Center : TTargetOptions;
  const OutputType : TVelocityOptions; const OutputUnits : TUnitsOptions;
  var EphemerisValues : TEphemerisOutput);
{user-friendly interface to JPL function PLEPH}

procedure PLEPH(const ET : extended; const NTARG, NCENT : integer; var RRD : TPV);
{
C     THIS SUBROUTINE READS THE JPL PLANETARY EPHEMERIS
C     AND GIVES THE POSITION AND VELOCITY OF THE POINT 'NTARG'
C     WITH RESPECT TO 'NCENT'.
C
C     CALLING SEQUENCE PARAMETERS:
C
C       ET = D.P. JULIAN EPHEMERIS DATE AT WHICH INTERPOLATION
C            IS WANTED.
C
C     NTARG = INTEGER NUMBER OF 'TARGET' POINT.
C
C     NCENT = INTEGER NUMBER OF CENTER POINT.
C
C            THE NUMBERING CONVENTION FOR 'NTARG' AND 'NCENT' IS:
C
C                1 = MERCURY           8 = NEPTUNE
C                2 = VENUS             9 = PLUTO
C                3 = EARTH            10 = MOON
C                4 = MARS             11 = SUN
C                5 = JUPITER          12 = SOLAR-SYSTEM BARYCENTER
C                6 = SATURN           13 = EARTH-MOON BARYCENTER
C                7 = URANUS           14 = NUTATIONS (LONGITUDE AND OBLIQ)
C                            15 = LIBRATIONS, IF ON EPH FILE
C
C             (IF NUTATIONS ARE WANTED, SET NTARG = 14. FOR LIBRATIONS,
C              SET NTARG = 15. SET NCENT=0. <-- note NCENT is ignored in this case)
C
C      RRD = OUTPUT 6-WORD D.P. ARRAY CONTAINING POSITION AND VELOCITY
C            OF POINT 'NTARG' RELATIVE TO 'NCENT'. THE UNITS ARE AU AND
C            AU/DAY. FOR LIBRATIONS THE UNITS ARE RADIANS AND RADIANS
C            PER DAY. IN THE CASE OF NUTATIONS THE FIRST FOUR WORDS OF
C            RRD WILL BE SET TO NUTATIONS AND RATES, HAVING UNITS OF
C            RADIANS AND RADIANS/DAY.
C
C            The option is available to have the units in km and km/sec.
C            For this, set km=.true. in the STCOMX common block.
C
}

implementation
{set the following directive to

       $DEFINE to request the Unix format binary
  or
       $UNDEF  to use the Delphi format file }

{$DEFINE UnixFormat}

uses
{$IFDEF UnixFormat}
  DE405_EphemerisFile,
{$ELSE}
  DE405d_EphemerisFile,
{$ENDIF}
  Math, Dialogs, SysUtils, Win_Ops, MP_Defs{SharedFilePath};

const
{$IFDEF UnixFormat}
  TempEphemerisFilname = 'Unx_Merge.405';
{$ELSE}
  TempEphemerisFilname = 'Unx_Merge.405d';
{$ENDIF}

type
   TDoubleTime = array[1..2] of extended;

var
  BinaryFile : file of TJPL_DataBlock;
  DataBlock : TJPL_DataBlock;

  i : integer;  {used in intialization}

{the following global specifies results wanted on calls to STATE}
  LIST : array[1..13] of byte;
{
               LIST[I]=0, NO INTERPOLATION FOR BODY I
                      =1, POSITION ONLY
                      =2, POSITION AND VELOCITY

         Where:

                   I = 1: MERCURY
                     = 2: VENUS
                     = 3: EARTH-MOON BARYCENTER
                     = 4: MARS
                     = 5: JUPITER
                     = 6: SATURN
                     = 7: URANUS
                     = 8: NEPTUNE
                     = 9: PLUTO
                     =10: GEOCENTRIC MOON
                     =11: see note
                     =12: NUTATIONS IN LONGITUDE AND OBLIQUITY
                     =13: LUNAR LIBRATIONS (IF ON FILE)

NOTE: I (JMM) have inserted this item expanding the dimension of list from the
 original 12 items to 13, and increasing the index of nutations and librations
 by one.  This was done for consistency with my layout of the PV array which,
 after a call to STATE holds the requested items in the same sequence of positions
 (each position in PV has room for six extended values, typically representing
 the objects position and velocity).  In the present version, STATE always overwrites
 LIST[11] with a value of 2, thereby setting PV[11] to the position and
 velocity of the Solar System barycentric SUN whether it was requested (or needed) or
 not.
}

{the following global variables are updated by calls to STATE:}

  BUF : array[1..NCOEFF] of Double;  {holds data values from data block relevant to time}
    {no improvement in time could be detected by changing the declaration to extended;
     declaration as Double permits direct read from Delphi format data files}

  PV : array[1..13] of TPV; {updated only as requested in LIST}
  {Note:  the JPL code is very confusing on this.  There are two PV's -- a TPV variable
   passed to INTERP, which represents one element of the present PV.
   Calls to STATE use the 13 element PV to store results with PV[1]..PV[10] used
   for LIST items 1..10,  Libration results (LIST[12]) placed in PV[11], and Nutation results
   (LIST[11]) placed in a separate 4-element array (PNUT).  However, if the call to
   PLEPH is for anything other than Nutations or Librations it will overwrite PV[11] as
   well as other elements and use PV[12] and PV[13].  I have modified STATE so that
   LIST[11] results (nutations) are placed in PV[11] and LIST[12] results (librations)
   in PV[12], eliminating the separate array PNUT.  LIST[11] has room for six results,
   of which the third and sixth are not used in this version.  As implemented by JPL,
   PLEPH overwrites PV[11] and PV[12] iff a request is being made for coordinates other
   than nutations or librations, so the overwriting does not affect calls for the latter.}


  const
// from STATE:
    NRL : integer = 0;  {last record number read}
// from INTERP:
    NP : integer = 2;     {number of valid position power series terms -- or next that needs to be computed??}
    NV : integer = 3;     {same for velocity power series terms}
    TWOT : extended = 0;  {= 2*TC}
    PC : array[1..18] of extended = (1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);  {Chebyshev power series in TC}
    VC : array[1..18] of extended = (0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);


procedure STATE(const ET2 : TDoubleTime);
{  This procedure READS AND INTERPOLATES THE JPL PLANETARY EPHEMERIS FILE for the requested time.

   ET2[1]  is either whole Julian Date, or, for more precise results, date of an "epoch" (i.e., ending in 0.5)
   ET2[2]  is the number of Julian days from ET2[1] to the time of interest (= 0 if ET2[1] = whole date)

   JPL ephemeris files consist of Chebyshev coefficients for obtaining by interpolation the
   following 13 items at any requested Julian date lying within the range of the file:

                   1: SSB MERCURY     (SSB = solar system barycentric)
                   2: SSB VENUS
                   3: SSB EARTH-MOON BARYCENTER
                   4: SSB MARS
                   5: SSB JUPITER
                   6: SSB SATURN
                   7: SSB URANUS
                   8: SSB NEPTUNE
                   9: SSB PLUTO
                  10: GEOCENTRIC MOON
                  11: SSB SUN
                  12: NUTATIONS IN LONGITUDE AND OBLIQUITY of Earth's Pole
                  13: LUNAR LIBRATIONS (three Euler angles)

   Interpolated values both for the 13 items and for their rates of change (at
   the requested time) may be obtained, and, if requested, are stored at the
   same-numbered position in the array PV. (All JPL ephemeris files provide
   coefficients for items 1..11;  some provide 1..12;  and still others 1..13).

   The results may be in either RAD-KM-SEC or RAD-AU-DAY units depending on the setting
   of the KM boolean switch.

   Only elements of PV specifically requested in LIST are updated, where
      LIST[Item] = 0  : not requested
                   1  : interpolate item only
                   2  : interpolate item and rate of change

   The original JPL code had a second boolean switch BARY for returning
   Solar System Barycentric or Heliocentric coordinates.  This switch has been
   eliminated.  Results are always solar system barycentric, which is the native
   format of the file.  To obtain heliocentric coordinates, request and subtract
   the coordinates of the solar system barycentric Sun.  Heliocentric coordinates
   are not required to compute relative positions of bodies.
}

(* move this to top in case file is changed
  const
    NRL : integer = 0;  {last record number read}
*)

  var
    i,
    NR  {record number in disk file to use to fill BUF with Chebyshev coefficients}
      : integer;

    AUFAC  {intrinsic units of file seem to be km & days;  output is pre-multiplied by
            this factor (= 1 if output in km;  or = 1/AU if output in AU)}
      : extended;

    T : array[1..2] of extended;
      {T[1] IS FRACTIONAL TIME IN SS[3] INTERVAL AT WHICH INTERPOLATION IS WANTED (0 <= T[1] <= 1).
       T(2) IS DP LENGTH OF WHOLE INTERVAL IN INPUT TIME UNITS (= SS[2] days or 86400*SS[2] sec).}

    PJD : array[1..4] of extended; {this is requested time ultimately expressed as PJD[1] = whole day ending in 0.5 + PJD[4] = fraction of day (<1)}

  procedure  SPLIT(const InputNumber : extended; var IntegerPart, FractionalPart : extended);
    begin
      IntegerPart := Floor(InputNumber);
      FractionalPart := InputNumber - IntegerPart;
      if (InputNumber<0) and (FractionalPart<>0) then
        begin
          IntegerPart := IntegerPart - 1;
          FractionalPart := FractionalPart + 1;
        end;
    end;

  procedure INTERP(const ListIndex : integer);
{
C     THIS SUBROUTINE INTERPOLATES AND DIFFERENTIATES A
C     SET OF CHEBYSHEV COEFFICIENTS TO GIVE POSITION AND VELOCITY
C
C     CALLING SEQUENCE PARAMETERS:
C
C       INPUT:
C
  Note:  I am regarding T[1] and T[2] as globals set by STATE before calling INTERP
         They no longer need to be passed as parameters.
C
C           T   T(1) IS DP FRACTIONAL TIME IN INTERVAL COVERED BY
C               COEFFICIENTS AT WHICH INTERPOLATION IS WANTED
C               (0 .LE. T(1) .LE. 1).  T(2) IS DP LENGTH OF WHOLE
C               INTERVAL IN INPUT TIME UNITS.
C
  Note: the following can be inferred from ListIndex, and hence are not passed as parameters:

C         BUF   1ST LOCATION OF ARRAY OF D.P. CHEBYSHEV COEFFICIENTS OF POSITION
C
C         NCF   # OF COEFFICIENTS PER COMPONENT   (varies)
C
C         NCM   # OF COMPONENTS PER SET OF COEFFICIENTS  (2 for nutations; 3 for all others)
C
C          NA   # OF SETS OF COEFFICIENTS IN FULL ARRAY
C               (I.E., # OF SUB-INTERVALS IN FULL INTERVAL)
C
  Note : the following is the same as LIST[ListIndex], and need not be passed as a parameter:
C          IFL  INTEGER FLAG: =1 FOR POSITIONS ONLY
C                             =2 FOR POS AND VEL
C
C
C       OUTPUT:
C
C          Results consist of up to six extended values which are placed in PV[ListIndex]
C
}

(* move this to top in case file is changed

  const
  {the following variables are declared as typed constants as they may be re-used if INTERP is re-called for same TC}
    NP : integer = 2;     {number of valid position power series terms -- or next that needs to be computed??}
    NV : integer = 3;     {same for velocity power series terms}
    TWOT : extended = 0;  {= 2*TC}
    PC : array[1..18] of extended = (1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);  {Chebyshev power series in TC}
    VC : array[1..18] of extended = (0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
*)

  var
    I,
    J,
    K,
    L,
    BUF_StartPoint, NCF, NCM, NA  {note: in the original JPL code these items
         were passed as parameters, but they are entirely based on ListIndex (see below}
      : integer;

    DT1,
    TEMP,
    VFAC,
    TC
      : extended;

    begin {INTERP}

      if IPT[2,ListIndex]=0 then exit;  {there are no coefficients for this item in the file}

      BUF_StartPoint := IPT[1,ListIndex]; {1-based position in BUF array where coefficients for this item start}

      NA := IPT[3,ListIndex];   {number of sub-intervals for which coefficients are provided}

      if ListIndex=12 then
        NCM := 2   {nutations have 2 "components"}
      else
        NCM := 3;  {all others have 3 -- x,y,z OR three Euler angles}

      NCF := IPT[2,ListIndex];  {number of Chebyshev coefficients used to express each component for one sub-interval}

{
C       ENTRY POINT. GET CORRECT SUB-INTERVAL NUMBER FOR THIS SET
C       OF COEFFICIENTS AND THEN GET NORMALIZED CHEBYSHEV TIME
C       WITHIN THAT SUBINTERVAL.
}
      DT1 := Int(T[1]); {T[1] = fractional time with 0<=T[1]<=1 so this is either 0 or 1}
      TEMP := NA*T[1];  {subinterval number (real) -- if DT1=1 then TEMP=NA}

    {original calls Fortran IDINT which is same as Pascal TRUNC}
      L := Trunc(TEMP - DT1) + 1; {which subinterval to use (integer) -- =NA if DT1=1}
{
C         TC IS THE NORMALIZED CHEBYSHEV TIME (-1 .LE. TC .LE. 1)
}
    {original calls Fortran DMOD(TEMP,1) which is same as Pascal FRAC}
      TC := 2*(DT1 + Frac(TEMP)) - 1;  {Chebyshev "x" (rescaled to range = [-1,1] over subinterval}
{
C       CHECK TO SEE WHETHER CHEBYSHEV TIME HAS CHANGED,
C       AND COMPUTE NEW POLYNOMIAL VALUES IF IT HAS.
C       (THE ELEMENT PC(2) IS THE VALUE OF T1(TC) AND HENCE
C       CONTAINS THE VALUE OF TC ON THE PREVIOUS CALL.)
}
      if(TC<>PC[2]) then
        begin
          NP := 2;
          NV := 3;
          PC[2] := TC;
          TWOT  := TC + TC;
        end;

{
C       BE SURE THAT AT LEAST 'NCF' POLYNOMIALS HAVE BEEN EVALUATED
C       AND ARE STORED IN THE ARRAY 'PC'.
}
      if (NP<NCF) then
        begin
        for I := NP+1 to NCF do PC[I] := TWOT*PC[I-1]-PC[I-2];
        NP := NCF;
        end;
{
C       INTERPOLATE TO GET POSITION FOR EACH COMPONENT
}
      for I := 1 to NCM do
      {NCM is either 2 for nutations or 3 (for all others);  store position results in first 3 slots of PV1 (last unused for nutations)}
        begin
          PV[ListIndex,I] := 0;
          for J := NCF downto 1 do
            begin
              PV[ListIndex,I] := PV[ListIndex,I] + PC[J]*BUF[BUF_StartPoint + ((L-1)*NCM + (I-1))*NCF + (J-1)];
            end;
          if ListIndex<=11 then PV[ListIndex,I] := PV[ListIndex,I]*AUFAC; {scale to KM or AU, as set by STATE}
        end;

      if (List[ListIndex]<=1) then exit;

{
C       IF VELOCITY INTERPOLATION IS WANTED, BE SURE ENOUGH
C       DERIVATIVE POLYNOMIALS HAVE BEEN GENERATED AND STORED.
}
      VFAC := (NA+NA)/T[2];
      if ListIndex<=11 then VFAC := VFAC*AUFAC;  {prepare to scale to sec-KM or day-AU, as set by STATE}

      VC[3] := TWOT+TWOT;

      if (NV<NCF) then
        begin
          for I := (NV+1) to NCF do VC[I] := TWOT*VC[I-1]+PC[I-1]+PC[I-1]-VC[I-2];
          NV := NCF;
        end;
{
C       INTERPOLATE TO GET VELOCITY FOR EACH COMPONENT
}
      for I := 1 to NCM do
        begin
          K := 3 + I;  {store velocity results in second three slots of PV1 (last unused for nutations)}
          PV[ListIndex,K] := 0;
          for J := NCF downto 2 do
            begin
              PV[ListIndex,K] := PV[ListIndex,K] + VC[J]*BUF[BUF_StartPoint + ((L-1)*NCM + (I-1))*NCF + (J-1)];
            end;
          PV[ListIndex,K] := PV[ListIndex,K]*VFAC; {do scaling}
        end;

    end;  {INTERP}

  begin {STATE}
    SPLIT(ET2[1] - 0.5,PJD[1],PJD[2]);  {Divides ET2[1] - 0.5 into integer and fractional parts; if ET2[1] is an "epoch" PJD[1] will be an integer date and PJD[2] = 0}
    SPLIT(ET2[2],PJD[3],PJD[4]); {Divides ET2[2] into integer and fractional parts}
    PJD[1] := PJD[1]+PJD[3]+ 0.5;  {combine integer parts to form epoch of interest}
    PJD[2]:= PJD[2]+PJD[4];        {combine fractional parts = additional Julian days}
    SPLIT(PJD[2],PJD[3],PJD[4]);   {see if the additional days include an integral part}
    PJD[1] := PJD[1]+PJD[3];       {if so, add that to PJD[1].  PJD[1] is now an epoch and PJD[4] a fractional number of additional days}

{      ERROR RETURN FOR EPOCH OUT OF RANGE }

    IF ((PJD[1]+PJD[4])<SS[1]) or ((PJD[1]+PJD[4])>SS[2]) then
      begin  {PJD[1]+PJD[4] = requested Julian date;  SS[1] = start date of file; SS[2] = end date of file}
        ShowMessage(format(' ***  Requested JED, %12.2f, not within ephemeris limits, %12.2f  %12.2f ***',
          [ET2[1]+ET2[2],SS[1],SS[2]]));
        Exit;
      end;

{       CALCULATE RECORD # AND RELATIVE TIME IN INTERVAL }

  {although floating point, the numerator and denominator in the following division should be integral}
    NR := Trunc((PJD[1]-SS[1])/(SS[3])) + 3; {estimate record number for desired date;  SS[3] = number of days per record;  1st data record = 3 in this notation}
    if (PJD[1]=SS[2]) then NR := NR - 1;  {special case of requested time = file end time}

    T[1] := ( (PJD[1] + PJD[4]) - (SS[1]+(NR-3)*SS[3]) )/SS[3];  {requested time expressed as fraction of time into selected record}

{   ShowMessage(format('NR = %d;  T[1] = %0.6f;  PJD[1] = %0.6f;  SS[1] = %0.6f',[NR, T[1], PJD[1], SS[1]]));}

{       READ CORRECT RECORD IF NOT IN CORE }

      if (NR<>NRL) then
        begin
          NRL := NR;
          Seek(BinaryFile,NR-1);  {Pascal numbers the records one less than JPL:  JPL record 1 = Pascal record 0}
{the following is correct only for Delphi format files:}
{$IFDEF UnixFormat}
      {for Unix format files translation is necessary after each read:}
          Read(BinaryFile,DataBlock);
          for i := 1 to NCOEFF do BUF[i] := JPLWordToDouble(DataBlock.DB[i]); {transfer data into buffer}
{$ELSE}
      {if binary file is in Delphi format, data can be read directly into BUF
       without translation}
          Read(BinaryFile,TJPL_DataBlock(BUF));
{$ENDIF}
        {done with DataBlock -- all future references are to BUF}
        end;

    if KM then
      begin
        T[2] := SS[3]*86400; {length of block in seconds}
        AUFAC := 1;
      end
    else
      begin
        T[2] := SS[3];   {length of block in days}
        AUFAC := 1/AU;
      end;

{ Calculate and scale requested Position-Velocity items }

    for I := 1 to 13 do if LIST[I]<>0 then INTERP(I);

 {NOTE : original JPL code had separate sections for I := 1 to 11 (positions),
   12 (nutations) and 13 (librations).  The positions sections did scaling by
   AUFAC -- I have moved this into INTERP.  The sections for I := 12 and 13 did
   checks to see if there were any coefficients stored IPT[2,I]>0 before calling
   INTERP.  I have also moved this to INTERP, although in the present application,
   the calling program, PLEPH, also checks this before asking for nutations or
   librations.}

  end;  {STATE}

procedure PLEPH(const ET : extended; const NTARG, NCENT : integer; var RRD : TPV);

  var
    I, K,
    VelocityCode,  {parameter passed to STATE by setting LIST[ItemIndex] if computation
      is desired :  1 = Positions only;  2 = Positions and Velocities}
    NumResults     { = 3 for Positions only;  = 6 for Positions and Velocities}
      : integer;
    ET2  {subroutine STATE requires a two-part time input}
      : TDoubleTime;

  begin {PLEPH}
    if not EphemerisFileLoaded then
      begin
        ShowMessage('Cannot return planetary data:  no JPL ephemeris file loaded');
        RRD := BlankTPV;
        Exit;
      end;

    if WantVelocities then
      begin
        VelocityCode := 2;
        NumResults   := 6;
      end
    else
      begin
        VelocityCode := 1;
        NumResults   := 3;
      end;

    ET2[1] := ET;
    ET2[2] := 0;

    for I := 1 to 6 do RRD[I] := 0;

{omit JPL FIRST call to STATE with ET2 = zips --
  pointers and constants were already initialized in INITIALIZATION section of this unit}

    if NTARG=NCENT then exit;  {returns all zeroes}

    for I := 1 to 13 do LIST[I] := 0; {start with fresh slate -- request nothing
      unless need for item is determined in following code}

{     CHECK FOR NUTATION CALL }

    if (NTARG=14) then
      begin
        IF (IPT[2,12]>0) THEN
          begin
            LIST[12] := VelocityCode;
            STATE(ET2);
          {note: only 4 nutation values are returned -- OutputValue[3] and OutputValue[6] are not computed}
            for i := 1 to NumResults do RRD[I] := PV[12,i];
          end
        else
          ShowMessage(' *****  NO NUTATIONS ON THE EPHEMERIS FILE  *****');
        exit;
      end;

{     CHECK FOR LIBRATIONS }

    if (NTARG=15) then
      begin
        IF (IPT[2,13]>0) THEN
          begin
            LIST[13] := VelocityCode;
            STATE(ET2);
            for i := 1 to NumResults do RRD[I] := PV[13,i];
          end
        else
          ShowMessage(' *****  NO LIBRATIONS ON THE EPHEMERIS FILE  *****');
        exit;
      end;

{ Process calls other than Nutations or Librations -- i.e., for relative PV }

{       SET UP PROPER ENTRIES IN 'LIST' ARRAY FOR STATE CALL }

{ The numbering scheme is as follows :

      for NTARG & NCENT :                  corresponding item in LIST / PV :
             1 = MERCURY                          1
             2 = VENUS                            2
             3 = EARTH                           ---
             4 = MARS                             4
             5 = JUPITER                          5
             6 = SATURN                           6
             7 = URANUS                           7
             8 = NEPTUNE                          8
             9 = PLUTO                            9
            10 = MOON                            10 (geocentric)
            11 = SUN                             11
            12 = SOLAR-SYSTEM BARYCENTER         ---
            13 = EARTH-MOON BARYCENTER            3
            14 = NUTATIONS                       12
            15 = LIBRATIONS                      13

  To produce relative positions and velocities a consistent coordinate system is
  required.  All the possible target/center bodies listed (1-13) will automatically
  be returned in solar system barycentric form (item 12 is = (0, 0, 0) by definition)
  with the exception of the Earth and the Moon.  Their SSB coordinates can be
  obtained by simple computation based on EMRAT after requesting LIST items 10 and 13.
  However in the one case where a 3-10 target/center combination is requested, the
  conversion to SSB coordinates is not required since the relative coordinates of
  Earth vs. Moon are given directly in list item 10.
}

      for I := 1 to 2 do
        begin
          if I=1 then
            K := NTARG
          else
            K := NCENT;  {process NTARG on 1st pass; NCENT on 2nd}

          if (K<=11) then LIST[K]  := VelocityCode;  {request PV for target and center items}
          if (K=10)  then LIST[3]  := VelocityCode;  {if Moon is involved compute EM barycenter as well}
          if (K=3)   then LIST[10] := VelocityCode;  {if Earth is involved compute geocentric Moon as well}
          if (K=13)  then LIST[3]  := VelocityCode;  {if Earth-Moon barycenter is requested, compute that only -- i.e., ignore Moon}
        end;

{       MAKE CALL TO STATE }

      STATE(ET2);

      if (NTARG=12) or (NCENT=12) then for I := 1 to NumResults do PV[12,I] := 0;  {set data for SS barycenter, which is origin of coordinate data}

      if (NTARG=13) or (NCENT=13) then   for I := 1 to NumResults do PV[13,I] := PV[3,I]; {transfer EM barycenter data}

      if ((NTARG=10) and (NCENT=3)) or ((NTARG=3) and (NCENT=10)) then
{      if (NTARG*NCENT=30) and ((NTARG+NCENT)=13) then } {<--- original JPL line}
        begin {requesting Earth relative to Moon}
          for I := 1 to NumResults do PV[3,I] := 0  {set "Earth" (= EM barycenter) to zero as PV[10] is already geocentric Moon}
        end
      else
        begin
          if (LIST[3]<>0) then for I := 1 to NumResults do PV[3,I] := PV[3,I]-PV[10,I]/(1+EMRAT); {shift "Earth" from EM barycenter to Earth center}

          if (LIST[10]<>0) then for I := 1 to NumResults do PV[10,I] := PV[3,I]+PV[10,I];  {shift Moon from geocentric to SS barycentric}
        end;

{return relative position-velocities based on amended entries in PV array}

      for I := 1 to NumResults do
        begin
          RRD[I] := PV[NTARG,I]-PV[NCENT,I];
        end;

  end;  {PLEPH}

procedure ReadEphemeris(const TDB : extended; const Target, Center : TTargetOptions;
  const OutputType : TVelocityOptions; const OutputUnits : TUnitsOptions;
  var EphemerisValues : TEphemerisOutput);
{user-friendly interface to JPL function PLEPH}
  var
    Answer : TPV;
    KM_save, WantVelocities_save : boolean;
  begin
    if not EphemerisFileLoaded then
      begin
        ShowMessage('Cannot return planetary data:  no JPL ephemeris file loaded');
        EphemerisValues.OutputValue := BlankTPV;
        Exit;
      end;

  {save current options}
    KM_save := KM;
    WantVelocities_save := WantVelocities;
  {set requested options}
    KM := (OutputUnits=KM_sec);
    WantVelocities := (OutputType=PositionsAndVelocities);

    PLEPH(TDB,Ord(Target),Ord(Center),Answer);

    EphemerisValues.OutputValue := Answer;

  {restore previous options}
    KM := KM_save;
    WantVelocities := WantVelocities_save;
  end;

procedure LoadJPL_File(const SuggestedName : string);
{Closes current binary file, if one is open, and attempts to open the requested one.
Generates a file-opening dialog if it cannot be found}
  var
    i, j : integer;
  begin
    if FileFound('JPL Ephemeris File',SuggestedName,EphemerisFilname) then
      begin
        if EphemerisFileLoaded then CloseFile(BinaryFile);

        SharedFilePath := ExtractFilePath(EphemerisFilname);
        AssignFile(BinaryFile,EphemerisFilname);
        Reset(BinaryFile);
        Read(BinaryFile,DataBlock); {read first header record}
        {Note:  order of words in binary file array for IPT is transposed from that expected
          by Pascal;  also, data regarding the libration coefficients is included in
          the current IPT even though they are stored as a separate array in the binary file}

      {$IFDEF UnixFormat}
      {  ShowMessage('Using Unix format binary');}
        for i := 1 to 3 do
          begin
            SS[i] := JPLWordToDouble(DataBlock.SS[i]);
            for j := 1 to 12 do IPT[i,j] := JPLIntegerToInteger(DataBlock.IPT[j,i]);
            IPT[i,13] := JPLIntegerToInteger(DataBlock.LPT[i]);
          end;
        AU    := JPLWordToDouble(DataBlock.AU);
        EMRAT := JPLWordToDouble(DataBlock.EMRAT);
        NUMDE := JPLIntegerToInteger(DataBlock.NUMDE);
      {$ELSE}
      {  ShowMessage('Using Delphi format binary');}
        for i := 1 to 3 do
          begin
            SS[i] := DataBlock.SS[i];
            for j := 1 to 12 do IPT[i,j] := DataBlock.IPT[j,i];
            IPT[i,13] := DataBlock.LPT[i];
          end;
        AU    := DataBlock.AU;
        EMRAT := DataBlock.EMRAT;
        NUMDE := DataBlock.NUMDE;
      {$ENDIF}
        {done with header blocks -- no other information from them is used}

// The following were formerly typed constants in STATE and INTERP -- they are now global variables
// They need to be reinitialized each time a new ephemeris file is loaded
        NRL := 0;  {last record number read}
        NP := 2;     {number of valid position power series terms -- or next that needs to be computed??}
        NV := 3;     {same for velocity power series terms}
        TWOT := 0;  {= 2*TC}
        for i := 1 to 18 do PC[i] := 0;  {Chebyshev power series in TC}
        PC[1] := 1;
        for i := 1 to 18 do VC[i] := 0;
        VC[2] := 1;

        EphemerisFileLoaded := True;
      end;

  end;

initialization
  KM   := False;
  WantVelocities := True;
  EphemerisFileLoaded := False;
  EphemerisFilname := '';

  for i := 1 to 6 do BlankTPV[i] := 0;
  for i := 1 to 3 do SS[i] := 0;

finalization
  if EphemerisFileLoaded then CloseFile(BinaryFile);

end.
