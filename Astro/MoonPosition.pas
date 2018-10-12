unit MoonPosition;
{This is a complete rewrite of the old M&P-based Position.PAS unit returning
positions of the sun, moon, planets and stars based on G.H. Kaplan's NOVAS
astrometric routines, which, in turn use the JPL_Ephemeris for solar-system
positions.
                                                                     9/4/04}

{This version stripped down to routines needed for Henrik Bondo H_MoonEventPredictor_Unit. 6/27/06}

{9/13/06 : added ComputeDistanceAndBearing function}
{3/23/06 : add LunarAge function}

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

const
  GeocentricSubEarthMode : boolean = False;  {if True, ignores corrections for observer position on Earth in SubEarthPointOnMoon}

  AdjustToMeanEarthSystem : boolean = True;  {applies only to Moon --
                                              if False, returns SelenographicCoordinateSystem in native JPL principal axis system;
                                              if True, applies a fixed rotation based on p1, p2 and tau}

{offset angles from J. Chapront, M. Chapront-Touze, and G. Francou, "Determination
of the lunar orbital and rotational parameters and of the ecliptic reference system
orientation from LLR measurements and IERS data," Astron. Astrophys. 343, 624–633 (1999)
used to ComputeMeanEarthSystemOffsetMatrix used to AdjustToMeanEarthSystem}
  p1 : extended = -78.9316;  //unit : OneArcSec
  p2 : extended = 0.2902;
  tau : extended = 66.1898;

var
  CurrentTargetPlanet : Planet;
  CurrentPlanetName : String;
  MoonRadius : Extended;

  SelenographicCoordinateSystem : TCoordinateSystem;  {set by SetSelenographicSystem;
    used by SelenographicCoordinates}
  TerrestrialCoordinateSystem : TCoordinateSystem;  {set by SetTerrestrialSystem;
    used by TerrestrialCoordinates}

  MoonToSunAU : extended;  // from center of JPL_TargetBody to center of Sun at moment of observation -- set by SubSolarPointOnMoon
  ObserverToMoonAU : extended;  // from observer to center of JPL_TargetBody at moment of observation -- set by SubEarthPointOnMoon

  EarthAxisVector, ObserverZenithVector : TVector;  // set by CalculatePosition

function ChangeTargetPlanet(const DesiredPlanet : Planet) : Boolean;

procedure RefreshCorrectionAngles;

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

{the following are positions on a spherical Earth}

procedure SetTerrestrialSystem(const TDB: extended);
{note: this previously took as input the UT_MJD}

function TerrestrialCoordinates(const ICRF_Vector: TVector) : TPolarCoordinates;

function SubLunarPointOnEarth(const UTC_MJD: extended) : TPolarCoordinates;

function SubSolarPointOnEarth(const UTC_MJD: extended) : TPolarCoordinates;

function LunarAge(const UTC_MJD: extended) : Extended;
{returns number of days since most recent geocentric New Moon}

implementation

uses Zeroes, TimLib, Trig_fns,
     Win_Ops, SysUtils, H_ClockError, H_NOVAS, H_JPL_Ephemeris, Dialogs;

var
  JPL_TargetBody : TJPL_TargetOptions;
  EclipticCoordinateSystem : TCoordinateSystem;
  p1_rad, p2_rad, tau_rad : Extended;

function ChangeTargetPlanet(const DesiredPlanet : Planet) : Boolean;
  begin
    Result := True;
    CurrentTargetPlanet := DesiredPlanet;
    CurrentPlanetName := PlanetName[CurrentTargetPlanet];
    MoonRadius := PlanetRadius[CurrentTargetPlanet]/OneKm;
    case DesiredPlanet of
       Moon :  JPL_TargetBody :=  JPL_Moon;
       Mercury : JPL_TargetBody :=  JPL_Mercury;
       Venus : JPL_TargetBody :=  JPL_Venus;
       Mars : JPL_TargetBody :=  JPL_Mars;
       Jupiter : JPL_TargetBody :=  JPL_Jupiter;
       Saturn : JPL_TargetBody :=  JPL_Saturn;
       Uranus : JPL_TargetBody :=  JPL_Uranus;
       Neptune : JPL_TargetBody :=  JPL_Neptune;
       Pluto : JPL_TargetBody :=  JPL_Pluto;
       else
         ShowMessage('Unable to initialize coordinate system for '+PlanetName[DesiredPlanet]);
         Result := False;
     end; {case}
  end;

procedure RefreshCorrectionAngles;
  begin
    p1_rad  := p1*OneArcSec;
    p2_rad  := p2*OneArcSec;
    tau_rad := tau*OneArcSec;
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

procedure CalculatePosition;
  var
    JD, UT1_Offset_secs, TDT_Offset_secs, UT1_JD, TDT_JD,
    drdt, zd, rar, decr, Cusps_X_component, Cusps_Y_component : extended;
    pout,vout : TVector;
    lplan : TJPL_TargetOptions;

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
         Sun:     lplan :=  JPL_Sun;
         Mercury: lplan :=  JPL_Mercury;
         Venus:   lplan :=  JPL_Venus;
         Earth:   lplan :=  JPL_Earth;
         Mars:    lplan :=  JPL_Mars;
         Jupiter: lplan :=  JPL_Jupiter;
         Saturn:  lplan :=  JPL_Saturn;
         Uranus:  lplan :=  JPL_Uranus;
         Neptune: lplan :=  JPL_Neptune;
         Pluto:   lplan :=  JPL_Pluto;
         Moon:    lplan :=  JPL_Moon;
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
    Angle3 : Extended;
    PA_System : TCoordinateSystem;
//for Targets other than Moon:
    T, d, RA_rad, Dec_rad, W_rad, W_dot {[deg per day]}, CosLat,
    Ja, Jb, Jc, Jd, Je, N : Extended;

  procedure CorrectAxis(const InputVector : TVector; var OutputVector : TVector);
  // this is the procedure for correcting vectors from Mean-axis *to* Principal axis
  // in Williams, Boggs and Folkner (2008): de421_lunar_ephemeris_and_orientation.pdf
    begin
      OutputVector := InputVector;
// rotates vector from Mean Earth to Principal Axis components
// signs reversed from reference to give CW rotations
      RotateVector(OutputVector,-p2_rad,PA_System.UnitX);
      RotateVector(OutputVector,p1_rad,PA_System.UnitY);
      RotateVector(OutputVector,-tau_rad,PA_System.UnitZ);
    end;

  procedure SetPlanetocentricAxes;
    begin
      with SelenographicCoordinateSystem do
        begin
  // locate north pole
          CosLat := Cos(Dec_rad);
          UnitZ[x] := Cos(RA_rad)*CosLat;
          UnitZ[y] := Sin(RA_rad)*CosLat;
          UnitZ[z] := Sin(Dec_rad);

          CrossProduct(Uz,UnitZ,UnitX);  // intersection of planet equator with ICRF equator
          if VectorMagnitude(UnitX)=0 then
            UnitX := Ux
          else
            NormalizeVector(UnitX);

          RotateVector(UnitX,W_rad,UnitZ);
          CrossProduct(UnitZ,UnitX,UnitY);
          NormalizeVector(UnitY);
        end;

    end;

  begin {SetSelenographicSystem}
  case CurrentTargetPlanet of
    Moon :
      begin
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

        with PA_System do
          begin
            UnitX := Ux;
            UnitY := Uy;
            UnitZ := Uz;
          end;

        RotateCoordinateSystem(PA_System,JPL_Data.Angle1,JPL_Data.Angle2,Angle3);

        if AdjustToMeanEarthSystem then
          begin
            CorrectAxis(PA_System.UnitX,SelenographicCoordinateSystem.UnitX);
            CorrectAxis(PA_System.UnitY,SelenographicCoordinateSystem.UnitY);
            CorrectAxis(PA_System.UnitZ,SelenographicCoordinateSystem.UnitZ);
          end
        else
          SelenographicCoordinateSystem := PA_System;

      end;

// following definitions of cartographic axes are from  Seidelmann et al. 2007 :
// Report of the IAU/IAGWorking Group on cartographic coordinates and rotational elements: 2006

    Mercury :
      begin
        d := (TDB - JD2000);
        T := d / DaysPerCentury;
        RA_rad := OneDegree*(281.01 - 0.033*T);
        Dec_rad := OneDegree*(61.45 - 0.005*T);
        W_dot := 6.1385025;
        W_rad := OneDegree*(329.548 + W_dot*d);
        SetPlanetocentricAxes;
      end;
    Venus :
      begin
        d := (TDB - JD2000);
        RA_rad := OneDegree*(272.76);
        Dec_rad := OneDegree*(67.16);
        W_dot := -1.4813688;
        W_rad := OneDegree*(160.20 + W_dot*d);
        SetPlanetocentricAxes;
      end;
    Mars :
      begin
        d := (TDB - JD2000);
        T := d / DaysPerCentury;
        RA_rad := OneDegree*(317.68143 - 0.1061*T);
        Dec_rad := OneDegree*(52.88650 - 0.0609*T);
        W_dot := 350.89198226;
        W_rad := OneDegree*(176.630 + W_dot*d);
        SetPlanetocentricAxes;
      end;
    Jupiter :
      begin
        d := (TDB - JD2000);
        T := d / DaysPerCentury;
        Ja := 99.360714 + 4850.4046*T;
        Jb := 175.895369 + 1191.9605*T;
        Jc := 300.323162 + 262.5475*T;
        Jd := 114.012305 + 6070.2476*T;
        Je := 49.511251 + 64.3000*T;
        RA_rad := OneDegree*(268.056595 - 0.006499*T + 0.000117*sin(Ja) + 0.000938*sin(Jb)
          + 0.001432*sin(Jc) + 0.000030*sin(Jd) + 0.002150*sin(Je));
        Dec_rad := OneDegree*(64.495303 + 0.002413*T + 0.000050*cos(Ja) + 0.000404*cos(Jb)
          + 0.000617*cos(Jc) - 0.000013*cos(Jd) + 0.000926*cos(Je));
//        W_rad := OneDegree*(67.1 + 877.900*d); // System I -- mean atmospheric equatorial rotation
//        W_rad := OneDegree*(43.3 + 870.270*d); // System II -- mean atmospheric rotation north of the south component of the north equatorial belt, and south of the north component of the south equatorial belt
        W_dot := 870.5366420;
        W_rad := OneDegree*(284.95 + W_dot*d); // System III -- magnetic field
        SetPlanetocentricAxes;
      end;
    Saturn :
      begin
        d := (TDB - JD2000);
        T := d / DaysPerCentury;
        RA_rad := OneDegree*(40.589 - 0.036*T);
        Dec_rad := OneDegree*(83.537 - 0.004*T);
        W_dot := 810.7939024;
        W_rad := OneDegree*(38.90 + W_dot*d);
        SetPlanetocentricAxes;
      end;
    Uranus :
      begin
        d := (TDB - JD2000);
        RA_rad := OneDegree*(257.311);
        Dec_rad := OneDegree*(-15.175);
        W_dot := -501.1600928;
        W_rad := OneDegree*(203.81 + W_dot*d);
        SetPlanetocentricAxes;
      end;
    Neptune :
      begin
        d := (TDB - JD2000);
        T := d / DaysPerCentury;
        N := 357.85 + 52.316*T;
        RA_rad := OneDegree*(299.36 + 0.70*sin(N));
        Dec_rad := OneDegree*(43.46 - 0.51*cos(N));
        W_dot := 536.3128492;
        W_rad := OneDegree*(253.18 + W_dot*d - 0.48*sin(N));
        SetPlanetocentricAxes;
      end;
    Pluto :
      begin
        d := (TDB - JD2000);
        RA_rad := OneDegree*(312.993);
        Dec_rad := OneDegree*(6.163);
        W_dot := -56.3625225;
        W_rad := OneDegree*(237.305 + W_dot*d);
        SetPlanetocentricAxes;
      end;
    else
      ShowMessage('Unable to set coordinate system for '+PlanetName[CurrentTargetPlanet]);
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

    ReadEphemeris(T0,JPL_TargetBody,JPL_Earth,PositionsOnly,AU_day,Moon_Data);
    LT1 := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {we see JPL_TargetBody where and as it was at this moment}


    ReadEphemeris(T1,JPL_Sun,JPL_TargetBody,PositionsOnly,AU_day,Sun_Data);
    LT2 := (OneAU*VectorMagnitude(Sun_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 the JPL_TargetBody was illuminated by light radiated from the Sun at T2}


    ReadEphemeris(T2,JPL_TargetBody,SolarSystemBarycenter,PositionsOnly,AU_day,Moon_Data);
    ReadEphemeris(T2,JPL_Sun,SolarSystemBarycenter,PositionsOnly,AU_day,Sun_Data);

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

    ReadEphemeris(T0,JPL_TargetBody,JPL_Earth,PositionsOnly,AU_day,Moon_Data);
    LT1 := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {observer on JPL_TargetBody sees Earth where and as it was at this moment}

    ReadEphemeris(T1,JPL_Earth,JPL_TargetBody,PositionsOnly,AU_day,Earth_Data);
    LT2 := (OneAU*VectorMagnitude(Earth_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 an observer on the JPL_TargetBody saw light radiated from the Earth at T2}

    ReadEphemeris(T2,JPL_TargetBody,SolarSystemBarycenter,PositionsOnly,AU_day,Moon_Data);
    ReadEphemeris(T2,JPL_Earth,SolarSystemBarycenter,PositionsOnly,AU_day,Earth_Data);

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

procedure SetTerrestrialSystem(const TDB: extended);
{note: this previously took as input the UT_MJD}
  var
    GAST : Extended;
  begin {SetTerrestrialSystem}
    sidtim(TDB,0,1,GAST);
    with TerrestrialCoordinateSystem do
      begin
        pnsw(TDB,GAST,0,0,Uz,UnitZ);
        pnsw(TDB,GAST,0,0,Ux,UnitX);
        CrossProduct(UnitZ,UnitX,UnitY);
      end;
  end;  {SetTerrestrialSystem}

function TerrestrialCoordinates(const ICRF_Vector: TVector) : TPolarCoordinates;
  var
    TerrestrialVector : TVector;
  begin {TerrestrialCoordinates}
    with TerrestrialCoordinateSystem do
      begin
        TerrestrialVector[X] := DotProduct(ICRF_Vector,UnitX);
        TerrestrialVector[Y] := DotProduct(ICRF_Vector,UnitY);
        TerrestrialVector[Z] := DotProduct(ICRF_Vector,UnitZ);
      end;

    Result.Radius := VectorMagnitude(TerrestrialVector);
    Result.Latitude := ASin(TerrestrialVector[Z]/Result.Radius);
    Result.Longitude := ATan2(TerrestrialVector[Y],TerrestrialVector[X]);
  {Note: selenographic longitudes are usually expressed in a 0..360 degree system}
//    if Result.Longitude<0 then Result.Longitude := Result.Longitude + TwoPi;
  end;  {TerrestrialCoordinates}

function SubSolarPointOnEarth(const UTC_MJD: extended) : TPolarCoordinates;
  var
    Earth_Data, Sun_Data : TEphemerisOutput;
    T0, T1, LT1, T2, LT2 : extended;
    RayDirection : TVector;
  begin {SubSolarPointOnEarth}
    T0 := MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay; {correct from UTC or UT1 to Ephemeris Time JD}

    ReadEphemeris(T0,JPL_Earth,JPL_TargetBody,PositionsOnly,AU_day,Earth_Data);
    LT1 := (OneAU*VectorMagnitude(Earth_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {observer on JPL_TargetBody sees Earth where and as it was at this moment}


    ReadEphemeris(T1,JPL_Sun,JPL_Earth,PositionsOnly,AU_day,Sun_Data);
    LT2 := (OneAU*VectorMagnitude(Sun_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 the Earth was illuminated by light radiated from the Sun at T2}


    ReadEphemeris(T2,JPL_Earth,SolarSystemBarycenter,PositionsOnly,AU_day,Earth_Data);
    ReadEphemeris(T2,JPL_Sun,SolarSystemBarycenter,PositionsOnly,AU_day,Sun_Data);

    VectorDifference(Sun_Data.R,Earth_Data.R,RayDirection);

    SetTerrestrialSystem(T1);
    Result := TerrestrialCoordinates(RayDirection);
  end;  {SubSolarPointOnEarth}

function SubLunarPointOnEarth(const UTC_MJD: extended) : TPolarCoordinates;
  var
    Moon_Data, Earth_Data : TEphemerisOutput;
    T0, T1, T2, LT1, LT2 : extended;
    RayDirection : TVector;
  begin {SubLunarPointOnEarth}
    T0 :=  MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay;

    ReadEphemeris(T0,JPL_TargetBody,JPL_Earth,PositionsOnly,AU_day,Moon_Data);
    LT1 := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    T1 := T0 - LT1;  {observer on JPL_TargetBody sees Earth where and as it was at this moment}

    ReadEphemeris(T1,JPL_Earth,JPL_TargetBody,PositionsOnly,AU_day,Earth_Data);
    LT2 := (OneAU*VectorMagnitude(Earth_Data.R)/c)/OneDay;
    T2 := T1 - LT2;  {at T1 an observer on the JPL_TargetBody saw light radiated from the Earth at T2}

    ReadEphemeris(T2,JPL_TargetBody,SolarSystemBarycenter,PositionsOnly,AU_day,Moon_Data);
    ReadEphemeris(T2,JPL_Earth,SolarSystemBarycenter,PositionsOnly,AU_day,Earth_Data);

    VectorDifference(Moon_Data.R,Earth_Data.R,RayDirection);

    SetTerrestrialSystem(T1);
    Result := TerrestrialCoordinates(RayDirection);
  end;  {SubLunarPointOnEarth}

procedure SetEclipticCoordinateSystem(const TDT : Extended);
// ecliptic system differs from equatorial system by rotation about vernal equinox (="obliquity")
  var
    PrecessedVector : TVector;
    T, MeanObliquityArcSec : Extended;

  begin {SetEclipticCoordinateSystem}
    with EclipticCoordinateSystem do
      begin
        AssignToVector(UnitX,1,0,0);  // axes of ICRF = mean Earth system J2000
        AssignToVector(UnitY,0,1,0);
        preces(JD2000,UnitX,TDT,PrecessedVector);
        UnitX := PrecessedVector;   // ecliptic shares precessed X-axis = vernal equinox
        preces(JD2000,UnitY,TDT,PrecessedVector);
        UnitY := PrecessedVector;
        CrossProduct(UnitX,UnitY,UnitZ);   // celestial pole
        NormalizeVector(UnitZ);   // should not be necessary
      end;

// compute obliquity in arcseconds per H_NOVAS etilt routine
    T := (TDT - JD2000) / DaysPerCentury;
    MeanObliquityArcSec := ((0.001813*T - 0.00059)*T - 46.8150)*T + 84381.4480;

    RotateCoordinateSystem(EclipticCoordinateSystem,0,MeanObliquityArcSec*OneArcSecond,0);
  end; {SetEclipticCoordinateSystem}

function EclipticCoordinates(const ICRF_Vector: TVector) : TPolarCoordinates;
  var
    EclipticVector : TVector;
  begin {EclipticCoordinates}
    with EclipticCoordinateSystem do
      begin
        EclipticVector[X] := DotProduct(ICRF_Vector,UnitX);
        EclipticVector[Y] := DotProduct(ICRF_Vector,UnitY);
        EclipticVector[Z] := DotProduct(ICRF_Vector,UnitZ);
      end;

    Result.Radius := VectorMagnitude(EclipticVector);
    Result.Latitude := ASin(EclipticVector[Z]/Result.Radius);
    Result.Longitude := ATan2(EclipticVector[Y],EclipticVector[X]);
  {Note: selenographic longitudes are usually expressed in a 0..360 degree system}
//    if Result.Longitude<0 then Result.Longitude := Result.Longitude + TwoPi;
  end;  {EclipticCoordinates}

{$F+}function EclipticLonDifference(const TDT : extended): extended;{$F-}
// for LunarAge -- applies only to Moon
  var
    Moon_Data, Sun_Data : TEphemerisOutput;
    LT, MoonAngle, SunAngle : Extended;
  begin
    ReadEphemeris(TDT,JPL_TargetBody,JPL_Earth,PositionsOnly,AU_day,Moon_Data);
    LT := (OneAU*VectorMagnitude(Moon_Data.R)/c)/OneDay;
    ReadEphemeris(TDT-LT,JPL_TargetBody,JPL_Earth,PositionsOnly,AU_day,Moon_Data);
    MoonAngle := EclipticCoordinates(Moon_Data.R).Longitude;

    ReadEphemeris(TDT,JPL_Sun,JPL_Earth,PositionsOnly,AU_day,Sun_Data);
    LT := (OneAU*VectorMagnitude(Sun_Data.R)/c)/OneDay;
    ReadEphemeris(TDT-LT,JPL_Sun,JPL_Earth,PositionsOnly,AU_day,Sun_Data);
    SunAngle := EclipticCoordinates(Sun_Data.R).Longitude;

    Result := MoonAngle - SunAngle;
    while Result>Pi  do Result := Result - TwoPi;
    while Result<-Pi do Result := Result + TwoPi;

  end;

function LunarAge(const UTC_MJD: extended) : Extended;
  const
    DaysDifference = 1;
  var
    T1, CurrentDifference, T0, EclipticRate : Extended;
  begin  {LunarAge}
    T1 :=  MJDOffset + UTC_MJD + TDT_Offset(UTC_MJD)*OneSecond/OneDay; // current ephemeris time
    CurrentDifference := EclipticLonDifference(T1);
    EclipticRate := EclipticLonDifference(T1 + DaysDifference) - CurrentDifference; // change in 1 day
    while EclipticRate>Pi  do EclipticRate := EclipticRate - TwoPi;
    while EclipticRate<-Pi do EclipticRate := EclipticRate + TwoPi;
    EclipticRate := EclipticRate/DaysDifference;

    if EclipticRate>0 then
      while CurrentDifference<0 do CurrentDifference := CurrentDifference + TwoPi
    else
      while CurrentDifference>0 do CurrentDifference := CurrentDifference - TwoPi;

    if EclipticRate=0 then
      begin
        Result := 0;
        Exit; //Error
      end
    else
      T0 := T1 - CurrentDifference/EclipticRate;  // approx. ephemeris time of most recent New Moon

    SetEclipticCoordinateSystem(T0);

    FindZero(EclipticLonDifference,T0 - 1/24, T0 + 1/24, (1e-5)/24, T0); // exact ephemeris time of most recent New Moon

    Result := T1 - T0;

  end;   {LunarAge}

initialization

ChangeTargetPlanet(Moon);
RefreshCorrectionAngles;
SetEclipticCoordinateSystem(JD2000);

END.
