unit MoonPosition;
{This is a complete rewrite of the old M&P-based Position.PAS unit returning
positions of the sun, moon, planets and stars based on G.H. Kaplan's NOVAS
astrometric routines, which, in turn use the JPL_Ephemeris for solar-system
positions.
                                                                     9/4/04}

{This version stripped down to routines needed for Henrik Bondo H_MoonEventPredictor_Unit. 6/27/06}

{9/13/06 : added ComputeDistanceAndBearing function}

{$J+} {use assignable constants}
{$H-} {use short strings by default}

interface

uses MP_Defs, Classes, MPVectors, Constnts;

type
  PositionResultRecord = record
      SiderealHr, {local mean sidereal time at observer's position}
  {Note:  DUT and EUT are returned by the ClockERR unit which uses files that need
    to be updated periodically with data from the IERS}
      DUT,      {seconds added to current UTC to obtain UT1 --> sidereal time}
      EUT,      {seconds added to current UTC to obtain TDT  --> ~TBT = JPL ephemeris time}
  {Note:  all position results are now topocentric and uncorrected for refraction}
      HA,       {hour angle = distance TO meridian 0 - 360 [deg] -- now topocentric}
      RA,       {topocentric right ascension [hrs] -- formerly geocentric}
      Dec,      {topoocentric declination [deg] -- formerly geocentric}
      Distance, {topocentric [AU]}
      Azimuth,  {[deg]}
      GeocentricAlt,  {altitude [deg] -- SET TO ZERO IN CURRENT VERSION}
      TopocentricAlt, {altitude [deg]}
      ObjectRadiusDeg, {in degrees to limb as viewed from topocentric position
                       using JPL/NOVAS distance and MP_Defs radius}
    {new solar illumination parameters; set only when ObjectRadiusDeg>0}
      CuspsPositionAngle,   {angle [radians] to line of cusps CCW from +X-axis in alt-az system, 90 deg = vertical up}
      SubSunAngle   {angle [radians] from sub-earth point to sub-sun point measured CCW about cusp axis; always in range [0..pi]}
      : extended;

    {set only when ObjectRadiusDeg>0}
      AltAzCoordinateSystem : TCoordinateSystem;
    end;

  TPolarCoordinates = record
      Longitude, {[rad]}
      Latitude,  {[rad]}
      Radius     {[AU]}
        : extended;
    end;

const
  GeocentricSubEarthMode : boolean = False;  {if True, ignores corrections for observer position on Earth in SubEarthPointOnMoon}

  AdjustToMeanEarthSystem : boolean = True;  {if False, returns SelenographicCoordinateSystem in native JPL principal axis system;
                                              if True, applies a fixed rotation based on p1, p2 and tau}

{offset angles from J. Chapront, M. Chapront-Touze, and G. Francou, "Determination
of the lunar orbital and rotational parameters and of the ecliptic reference system
orientation from LLR measurements and IERS data," Astron. Astrophys. 343, 624–633 (1999)
used to ComputeMeanEarthSystemOffsetMatix used to AdjustToMeanEarthSystem}
  p1 : extended = -78.9316*OneArcSec;
  p2 : extended = 0.2902*OneArcSec;
  tau : extended = 66.1898*OneArcSec;

var
  DaviesMatrix : array[1..3,1..3] of extended;  // Merton Davies matrix to transform Mean-Earth vectors to Prinicpal Axis vectors

  SelenographicCoordinateSystem : TCoordinateSystem;  {set by SetSelenographicSystem;
    used by SelenographicCoordinates}

  MoonToSunAU : extended;  // from center of Moon to center of Sun at moment of observation -- set by SubSolarPointOnMoon
  ObserverToMoonAU : extended;  // from observer to center of Moon at moment of observation -- set by SubEarthPointOnMoon

  EarthAxisVector, ObserverZenithVector : TVector;  // set by CalculatePosition

procedure ComputeMeanEarthSystemOffsetMatix;

procedure ComputeDistanceAndBearing(const Lon1, Lat1, Lon2, Lat2 : extended; var AngleBetween, Bearing : extended);
{all arguments in radians}

procedure CalculatePosition(const UTC_MJD : extended; const SelectedPlanet : Planet;
  const SelectedStarData: StarDataRecord; var PositionResults: PositionResultRecord);
{The argument UTC_MJD is the desired UTC Modified Julian Date.  It will be internally
corrected for the IERS values of DUT and EUT (see above) before returning a topocentric
position for the observer location defined in MP_Defs}


procedure SetSelenographicSystem(const TDB: extended);
{note: this previously took as input the UT_MJD}

function SelenographicCoordinates(const ICRF_Vector: TVector) : TPolarCoordinates;

{The following are topocentric positions for an observer at the location defined
in MP_Defs.}

function SubEarthPointOnMoon(const UTC_MJD: extended) : TPolarCoordinates;

function SubSolarPointOnMoon(const UTC_MJD: extended) : TPolarCoordinates;

implementation

uses Zeroes, TimLib, Trig_fns,
     Win_Ops, SysUtils, H_ClockError, H_NOVAS, H_JPL_Ephemeris, Dialogs;

procedure ComputeMeanEarthSystemOffsetMatix;
  var
    sinp1, cosp1, sinp2, cosp2, sintau, costau : extended; 
  begin
  {matrix from M.E. Davies, T.R. Colvin and D.L. Meyer,
  "A Unified Lunar Control Network -- The Near Side," (A Rand Note) N-2664-NASA
  (October 1987) --  this matrix transforms the components of a vector in the
  lunar mean Earth/rotation axis into the components in the principal axis system.
  Direction 1 (x) is towards the Earth, direction 2 (y) is towards Mare Crisium,
  direction 3 (z) is northwards.}
    sinp1 := Sin(p1);
    cosp1 := Cos(p1);
    sinp2 := Sin(p2);
    cosp2 := Cos(p2);
    sintau := Sin(tau);
    costau := Cos(tau);

    DaviesMatrix[1,1] := cosp1*costau;
    DaviesMatrix[1,2] := cosp1*sintau;
    DaviesMatrix[1,3] := sinp1;
    DaviesMatrix[2,1] := -sinp1*sinp2*costau - cosp2*sintau;
    DaviesMatrix[2,2] := -sinp1*sinp2*sintau + cosp2*costau;
    DaviesMatrix[2,3] := sinp2*cosp1;
    DaviesMatrix[3,1] := -sinp1*cosp2*costau + sinp2*sintau;
    DaviesMatrix[3,2] := -sinp1*cosp2*sintau - sinp2*costau;
    DaviesMatrix[3,3] := cosp2*cosp1;
  end;


{Note: the following two routines are normally in ClockErr}
{
function IERS_DUT(const UTC_MJD: extended): extended;
  begin
    Result := 0;
  end;

function TDT_Offset(const UTC_MJD: extended): extended;
  var
    LeapSecs : integer;
  begin
    if UTC_MJD<53736 then
      LeapSecs := 32
    else
      LeapSecs := 33;

    Result := 32.184 + LeapSecs;
  end;
}

procedure ComputeDistanceAndBearing(const Lon1, Lat1, Lon2, Lat2 : extended; var AngleBetween, Bearing : extended);
var
  SinLat1, CosLat1, SinLat2, CosLat2, CosTheta, SinTheta,
  CosThetaSqrd, Denom, PolarAngle, CosAz, SinAz : extended;
begin
    PolarAngle := Lon2 - Lon1;
    SinLat1 := Sin(Lat1);
    CosLat1 := Cos(Lat1);
    SinLat2 := Sin(Lat2);
    CosLat2 := Cos(Lat2);
    CosTheta := SinLat1*SinLat2 + CosLat1*CosLat2*Cos(PolarAngle);
    CosThetaSqrd := Sqr(CosTheta);
    if CosThetaSqrd>=1 then // note: can only be >1 due to round-off error
      begin
        AngleBetween := 0;
        Bearing := 0;
      end
    else
      begin
        AngleBetween := ACos(CosTheta);

        SinTheta := Sqrt(1-CosThetaSqrd);
        Denom := CosLat1*SinTheta;
        if Denom=0 then
          Bearing := 0
        else
          begin
            CosAz := (SinLat1*CosTheta - SinLat2)/Denom;
            SinAz := Sin(PolarAngle)*CosLat2/SinTheta;
            Bearing := Pi - ATan2(SinAz,CosAz);
          end;
      end;
end;

procedure CalculatePosition;
  var
    JD, UT1_Offset_secs, TDT_Offset_secs, UT1_JD, TDT_JD,
    drdt, zd, rar, decr, Cusps_X_component, Cusps_Y_component : extended;
    pout,vout : TVector;
    lplan : TTargetOptions;

  begin {CalculatePosition}  with PositionResults do begin

    UT1_Offset_secs := IERS_DUT(UTC_MJD);
    TDT_Offset_secs := TDT_Offset(UTC_MJD);

    DUT := UT1_Offset_secs;
    EUT := TDT_Offset_secs;
//    ShowMessage(format('DUT = %0.3f  EUT = %0.3f',[DUT,EUT]));

    JD := UTC_MJD + MJDOffset;

    UT1_JD := JD + UT1_Offset_secs*OneSecond/OneDay;
    TDT_JD := JD + TDT_Offset_secs*OneSecond/OneDay;

    if SelectedPlanet=Star then with SelectedStarData do
      begin
(*
        apstar (TDT_JD, Earth, RA2000, Dec2000, PM_RA*OneHour/OneSecond,
          PM_Dec*OneDegree/OneArcSecond, Parallax, 0{radial velocity},
          ra, dec);
*)
        tpstar (TDT_JD, RA2000, Dec2000, PM_RA*OneHour/OneSecond,
          PM_Dec*OneDegree/OneArcSecond, Parallax, 0{radial velocity},
          UT1_JD, -ObserverLongitude, ObserverLatitude, ObserverElevation,
          RA, Dec);
      end
    else
     begin
       case SelectedPlanet of
         MP_Defs.Sun:     lplan :=  H_JPL_Ephemeris.Sun;
         MP_Defs.Mercury: lplan :=  H_JPL_Ephemeris.Mercury;
         MP_Defs.Venus:   lplan :=  H_JPL_Ephemeris.Venus;
         MP_Defs.Earth:   lplan :=  H_JPL_Ephemeris.Earth;
         MP_Defs.Mars:    lplan :=  H_JPL_Ephemeris.Mars;
         MP_Defs.Jupiter: lplan :=  H_JPL_Ephemeris.Jupiter;
         MP_Defs.Saturn:  lplan :=  H_JPL_Ephemeris.Saturn;
         MP_Defs.Uranus:  lplan :=  H_JPL_Ephemeris.Uranus;
         MP_Defs.Neptune: lplan :=  H_JPL_Ephemeris.Neptune;
         MP_Defs.Pluto:   lplan :=  H_JPL_Ephemeris.Pluto;
         MP_Defs.Moon:    lplan :=  H_JPL_Ephemeris.Moon;
         else
           ShowMessage('Calculate position:  unknown planet selection requested');
           exit;
       end; {case}
{       applan(TDT_JD, lplan, Earth, pout, vout, ra, dec, dis, drdt);}
       tpplan(TDT_JD, UT1_JD, -ObserverLongitude, ObserverLatitude, ObserverElevation,
         lplan,  pout, vout, RA, Dec, Distance, drdt);
     end;

//    SiderealHr := LMST(UTC_MJD,ObserverLongitude);

    sidtim(UT1_JD,0,0,SiderealHr);  {this calculates GMST}
    SiderealHr := SiderealHr - ObserverLongitude/15;
    while SiderealHr>=24 do SiderealHr := SiderealHr - 24;
    while SiderealHr<0 do SiderealHr := SiderealHr + 24;

    HA := (RA - SiderealHr)*15;  {[deg]}
    while HA<0 do HA := HA + 360;

    zdaz(UT1_JD,0{Pole_x},0{Pole_y}, -ObserverLongitude, ObserverLatitude, ObserverElevation,
          RA, Dec, 0{irefr}, zd, Azimuth, rar, decr);

    ObserverZenithVector := ObserverVertical;
    pnsw(TDT_JD,0,0,0,Uz,EarthAxisVector);      

    TopocentricAlt := 90 - zd;

    if SelectedPlanet=Star then
      begin
        ObjectRadiusDeg := 0;
        CuspsPositionAngle := 0;
        SubSunAngle := 0;
      end
    else  {not a star}
      begin
        ObjectRadiusDeg := DPR*Asin(PlanetRadius[SelectedPlanet]/(Distance*OneAU));
        SubSunAngle := SubSolarAngle;

      {following are the basis vectors of the topocentric alt-az system centered
      on the target planet with X = azimuth, Y = elevation, pout = direction to planet = -Z axis}
        with AltAzCoordinateSystem do
          begin
            UnitZ := pout;
            MultiplyVector(-1,UnitZ);
            NormalizeVector(UnitZ);
            CrossProduct(pout,ObserverVertical,UnitX);
            NormalizeVector(UnitX);
            CrossProduct(UnitX,pout,UnitY);
            NormalizeVector(UnitY);
            Cusps_X_component := DotProduct(CuspDirection,UnitX);
            Cusps_Y_component := DotProduct(CuspDirection,UnitY);
          end;

        CuspsPositionAngle := FullAtan(Cusps_X_component,Cusps_Y_component);
      end;
  end; {with PositionResults}
  end; {CalculatePosition}


procedure SetSelenographicSystem(const TDB: extended);
{note: this previously took as input the UT_MJD}
  var
    JPL_Data : TEphemerisOutput;
    Angle3 : extended;
    PA_System, Dummy_Vectors : TCoordinateSystem;
  begin {SetSelenographicSystem}
    ReadEphemeris(TDB,Librations,DontCare,PositionsAndVelocities,AU_day,JPL_Data);

  {JPL ephemeris expresses offset from ICRF to Selenographic system by three
   Euler angles}

  {JPL Angle3 tends to be very large plus or minus-- it is total lunar
   rotations wrt. ICRF from some reference date --
   Doesn't seem to be necessary, but bring it into range 0..2pi before
   computing signs and cosines}
    Angle3 := JPL_Data.Angle3;
    while Angle3>TwoPi do Angle3 := Angle3 - TwoPi;
    while Angle3<0     do Angle3 := Angle3 + TwoPi;

    with SelenographicCoordinateSystem do
      begin
        UnitX := Ux;
        UnitY := Uy;
        UnitZ := Uz;
      end;

    RotateCoordinateSystem(SelenographicCoordinateSystem,JPL_Data.Angle1,JPL_Data.Angle2,Angle3);

    if AdjustToMeanEarthSystem then
      begin
        PA_System := SelenographicCoordinateSystem;

      // from DaviesMatrix we know components of MeanEarth system UnitX on PrincipalAxis system unit vectors.
        Dummy_Vectors := PA_System;
        MultiplyVector(DaviesMatrix[1,1],Dummy_Vectors.UnitX);
        MultiplyVector(DaviesMatrix[2,1],Dummy_Vectors.UnitY);
        MultiplyVector(DaviesMatrix[3,1],Dummy_Vectors.UnitZ);
      // add the three parts together to get the direction of the MeanEarth vector in the Principal Axis system.
        SelenographicCoordinateSystem.UnitX := Dummy_Vectors.UnitX;
        VectorSum(SelenographicCoordinateSystem.UnitX,Dummy_Vectors.UnitY,SelenographicCoordinateSystem.UnitX);
        VectorSum(SelenographicCoordinateSystem.UnitX,Dummy_Vectors.UnitZ,SelenographicCoordinateSystem.UnitX);

      // repeat for MeanEarth system UnitY
        Dummy_Vectors := PA_System;
        MultiplyVector(DaviesMatrix[1,2],Dummy_Vectors.UnitX);
        MultiplyVector(DaviesMatrix[2,2],Dummy_Vectors.UnitY);
        MultiplyVector(DaviesMatrix[3,2],Dummy_Vectors.UnitZ);
        SelenographicCoordinateSystem.UnitY := Dummy_Vectors.UnitX;
        VectorSum(SelenographicCoordinateSystem.UnitY,Dummy_Vectors.UnitY,SelenographicCoordinateSystem.UnitY);
        VectorSum(SelenographicCoordinateSystem.UnitY,Dummy_Vectors.UnitZ,SelenographicCoordinateSystem.UnitY);

      // repeat for MeanEarth system UnitZ
        Dummy_Vectors := PA_System;
        MultiplyVector(DaviesMatrix[1,3],Dummy_Vectors.UnitX);
        MultiplyVector(DaviesMatrix[2,3],Dummy_Vectors.UnitY);
        MultiplyVector(DaviesMatrix[3,3],Dummy_Vectors.UnitZ);
        SelenographicCoordinateSystem.UnitZ := Dummy_Vectors.UnitX;
        VectorSum(SelenographicCoordinateSystem.UnitZ,Dummy_Vectors.UnitY,SelenographicCoordinateSystem.UnitZ);
        VectorSum(SelenographicCoordinateSystem.UnitZ,Dummy_Vectors.UnitZ,SelenographicCoordinateSystem.UnitZ);
      end;


  end;  {SetSelenographicSystem}

function SelenographicCoordinates(const ICRF_Vector: TVector) : TPolarCoordinates;
  var
    SelenographicVector : TVector;
  begin {SelenographicCoordinates}
    with SelenographicCoordinateSystem do
      begin
        SelenographicVector[X] := DotProduct(ICRF_Vector,UnitX);
        SelenographicVector[Y] := DotProduct(ICRF_Vector,UnitY);
        SelenographicVector[Z] := DotProduct(ICRF_Vector,UnitZ);
      end;

//    SelenographicVector := SelenographicCoordinateSystem.UnitY;
    Result.Radius := VectorMagnitude(SelenographicVector);
    Result.Latitude := ASin(SelenographicVector[Z]/Result.Radius);
    Result.Longitude := ATan2(SelenographicVector[Y],SelenographicVector[X]);
  {Note: selenographic longitudes are usually expressed in a 0..360 degree system}
    if Result.Longitude<0 then Result.Longitude := Result.Longitude + TwoPi;
  end;  {SelenographicCoordinates}

function SubSolarPointOnMoon(const UTC_MJD: extended) : TPolarCoordinates;
  var
    Moon_Data, Sun_Data : TEphemerisOutput;
    T0, T1, LT1, T2, LT2 : extended;
    RayDirection : TVector;
  begin {SubSolarPointOnMoon}
    T0 := MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay; {correct from UTC or UT1 to Ephemeris Time JD}

    ReadEphemeris(T0,Moon,Earth,PositionsOnly,AU_day,Moon_Data);
    LT1 := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {we see Moon where and as it was at this moment}


    ReadEphemeris(T1,Sun,Moon,PositionsOnly,AU_day,Sun_Data);
    LT2 := (OneAU*VectorMagnitude(Sun_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 the Moon was illuminated by light radiated from the Sun at T2}


    ReadEphemeris(T2,Moon,SolarSystemBarycenter,PositionsOnly,AU_day,Moon_Data);
    ReadEphemeris(T2,Sun,SolarSystemBarycenter,PositionsOnly,AU_day,Sun_Data);

    VectorDifference(Sun_Data.R,Moon_Data.R,RayDirection);
    MoonToSunAU := VectorMagnitude(RayDirection);

    SetSelenographicSystem(T1);
    Result := SelenographicCoordinates(RayDirection);
  end;  {SubSolarPointOnMoon}

function SubEarthPointOnMoon(const UTC_MJD: extended) : TPolarCoordinates;
  var
    Moon_Data, Earth_Data : TEphemerisOutput;
    GAST,
    T0, T1, T2, LT1, LT2 : extended;
    RayDirection, ObsLocation, ObsVelocity : TVector;
  begin {SubEarthPointOnMoon}
    T0 :=  MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay;

    ReadEphemeris(T0,Moon,Earth,PositionsOnly,AU_day,Moon_Data);
    LT1 := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {observer on Moon sees Earth where and as it was at this moment}

    ReadEphemeris(T1,Earth,Moon,PositionsOnly,AU_day,Earth_Data);
    LT2 := (OneAU*VectorMagnitude(Earth_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 an observer on the Moon saw light radiated from the Earth at T2}

    ReadEphemeris(T2,Moon,SolarSystemBarycenter,PositionsOnly,AU_day,Moon_Data);
    ReadEphemeris(T2,Earth,SolarSystemBarycenter,PositionsOnly,AU_day,Earth_Data);

    if GeocentricSubEarthMode then
      VectorDifference(Earth_Data.R,Moon_Data.R,RayDirection)
    else
      begin
    {determine where observer was at T2}
        sidtim(0,MJDOffset + UTC_MJD + IERS_DUT(UTC_MJD)*OneSecond/OneDay - LT1 - LT2,1,GAST);
        {Notes:
          2nd parameter: input is supposed to represent UT1 at T1
          3rd parameter:  1 gives Greenwich apparent sidereal time (which is called for by TERRA;
                          0 gives Greenwich mean sidereal time, which may be more appropriate
                          Empirically, there doesn't seem to be any detectable difference}

        Terra(-ObserverLongitude,ObserverLatitude,ObserverElevation,GAST,ObsLocation,ObsVelocity);
        {gives coordinates wrt equinox of date -- should use GMST for fixed ICRF equinox?}

        VectorSum(Earth_Data.R,ObsLocation,ObsLocation);

        VectorDifference(ObsLocation,Moon_Data.R,RayDirection);
      end;

    ObserverToMoonAU := VectorMagnitude(RayDirection);

    SetSelenographicSystem(T1);
    Result := SelenographicCoordinates(RayDirection);
  end;  {SubEarthPointOnMoon}

(* old routines
function SubSolarPointOnMoon(const UTC_MJD: extended) : TPolarCoordinates;
  var
    Moon_Data, Sun_Data : TEphemerisOutput;
    T0, T1, LT1, T2, LT2 : extended;
    RayDirection : TVector;
  begin {SubSolarPointOnMoon}
    T0 := MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay; {correct from UTC or UT1 to Ephemeris Time JD}

    ReadEphemeris(T0,Moon,Earth,PositionsOnly,AU_day,Moon_Data);
    LT1 := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {we see Moon where and as it was at this moment}


    ReadEphemeris(T0,Sun,Moon,PositionsOnly,AU_day,Sun_Data);
    LT2 := (OneAU*VectorMagnitude(Sun_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 the Moon was illuminated by light radiated from the Sun at T2}


    ReadEphemeris(T1,Moon,SolarSystemBarycenter,PositionsOnly,AU_day,Moon_Data);
    ReadEphemeris(T2,Sun,SolarSystemBarycenter,PositionsOnly,AU_day,Sun_Data);

    VectorDifference(Sun_Data.R,Moon_Data.R,RayDirection);

    SetSelenographicSystem(UTC_MJD - LT1);
    Result := SelenographicCoordinates(RayDirection);
  end;  {SubSolarPointOnMoon}

function SubEarthPointOnMoon(const UTC_MJD: extended) : TPolarCoordinates;
  var
    JPL_Data : TEphemerisOutput;
    GAST,
    TDB, LT1, T1 : extended;
    MoonEarthVector, ObsLocation, ObsVelocity, MoonObserverVector : TVector;
  begin {SubEarthPointOnMoon}
    TDB :=  MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay;
    ReadEphemeris(TDB,Earth,Moon,PositionsOnly,AU_day,JPL_Data);
    LT1 := (OneAU*VectorMagnitude(JPL_Data.R)/c)/OneDay; {light time}
    T1 := TDB - LT1; {Moon is seen as it was at this time}

    sidtim(0,MJDOffset + UTC_MJD + IERS_DUT(UTC_MJD)*OneSecond/OneDay,1,GAST); {Note:
      3rd parameter:  1 gives Greenwich apparent sidereal time (which is called for by TERRA;
      0 gives Greenwich mean sidereal time, which may be more appropriate}

    Terra(-ObserverLongitude,ObserverLatitude,ObserverElevation,GAST,ObsLocation,ObsVelocity);
    {gives coordinates wrt equinox of date -- should use GMST for fixed ICRF equinox?}

    ReadEphemeris(T1,Earth,Moon,PositionsOnly,AU_day,JPL_Data);
    MoonEarthVector := JPL_Data.R;
    VectorSum(MoonEarthVector,ObsLocation,MoonObserverVector);

    SetSelenographicSystem(T1 - MJDOffset);
    Result := SelenographicCoordinates(MoonObserverVector);
  end;  {SubEarthPointOnMoon}
*)

initialization

ComputeMeanEarthSystemOffsetMatix;

END.
