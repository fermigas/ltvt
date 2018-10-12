unit MP_Defs;
{collects definitions of various items contain in Montenbruck & Pfleger units
 and changes definition of "REAL" (used extensively throughout M&P) to mean
 extended precision data, which should be not only more accurate, but also
 faster                                                             4/27/97}

//{$J+}  {permit TP7 style typed constant}
 
interface
  uses Constnts, CRT_Ops;

  type
    REAL = extended;

    Planet =
      ( Sun     , Mercury , Venus   , Earth   , Mars    , Jupiter ,
        Saturn  , Uranus  , Neptune , Pluto   , Moon    , Star  );

    Observer =
      ( Jim, Cliff83, CDM, PierPkg, SignalPeak, Spyglass, Pelican, Tom, Becky, Henrik, Padua, Geocentric, Special);

    TObserverLocation = record
      Latitude,
      Longitude,
      Elevation : extended;
      end;

{Note 1: the definition of StarDataRecord was formerly in unit StarData}
{Note 2:  the current data file 'C:\PROJ\ASTRON\STARCAT\MASTER.DAT', consisting
  of a series of StarDataRecord,  was created under Turbo Pascal 7 and certain
  changes are required for Delphi 6 to be able to read it}

{$A-} {turn off record alignment -- otherwise Delphi will assume the StarDataRecords
        have been padded to fit on quad-word boundaries and look for the components
        in the wrong places}
{$H-} {use short strings by default}

    StarDataRecord = record
      HRNumber : SmallInt;  {catalog number in Yale Bright Star Catalog}
    {following are set to -999 if not available:}
      FKNumber : SmallInt;  {catalog number in FK5 Catalog}
      RA2000,              {Right Acension [decimal hours]}
      Dec2000  : Real48;     {Declination [decimal degrees]}
      PM_RA,               {Proper motion in RA [hours/century]}
      PM_Dec,              {Proper motion in Dec [degrees/century]}
      Parallax,            {[arc-sec]}
      Vmag,                {visual magnitude}
      Dmag,                {difference in magnitude, if multiple}
      Separation : single; {[arc-sec]}
    {following are blank if not available:}
      StandardName : String[10];  {e.g. "  9Alp CMa"}
      CommonName : String[30];    {e.g., "Sirius"}
      ObsCount : byte;     {number of times observed rising}
      end;
{$A+}
{$H+}


  const
    P2 = TwoPi;
    Pi2 = TwoPi;
    Deg = 180.0/pi;       {deg per radian}
    Arc = 60.0*60.0*Deg;  {arc-sec per radian}
    PlanetName : array[Sun..Star] of string =
      ('Sun'    ,'Mercury','Venus'  ,'Earth'  ,'Mars'   ,'Jupiter',
       'Saturn' ,'Uranus' ,'Neptune','Pluto'  ,'Moon'   ,'Star' );
    PlanetRadius : array[Sun..Star] of extended =
     {radii in [m] from Physics Vade Mecum, pp. 71 (Sun, Earth), 75-Table 3.07 (Mercury-Pluto),
      and JPL Horizons/IAU (Moon) and MGCWG paper by Duxbury et al. (Mars)
     ( RSun,     2439e3,   6052e3,   REarth,   3389.5e3, 71398e3,
        60000e3,  25400e3, 24300e3,   2000e3,   1737.4e3, 0 );   }
 // updated with mean radii from  Seidelmann et al. 2007 :
// Report of the IAU/IAGWorking Group on cartographic coordinates and rotational elements: 2006
     ( RSun,     2439.7e3,   6051.8e3,   REarth,   3389.5e3, 69911e3,
        58232e3,  25362e3, 24622e3,   1195e3,   1737.4e3, 0 );
    ObserverDescription : array [Jim..Special] of string =
      ('Private Road',
       'Ensign View Park',
       'Lookout Point - CDM',
       'Newport Pier Pkg',
       'Signal Peak Cairn DX4482',
       'Spyglass Hill',
       'Pelican Hill',
       'Tom Pope Driveway',
       'Becky''s House',
       'Henrik Bondo House',
       'Padua, Italy',
       'Geocentric',
       'User Defined Location');

  var
    SharedFilePath : string;

    ObserverLatitude,  {e.g. =  33.643889; [deg] north latitude of observer}
    ObserverLongitude, {e.g. = 117.893611; [deg] west longitude of observer}
    ObserverElevation  : extended {e.g. = 20.0; [m] geodetic elevation};

    StandardLocation : array[Jim..Special] of TObserverLocation;

    CurrentObserver : Observer;

{Note : formerly defined in StarData}
    BlankStarDataRecord : StarDataRecord;


  procedure SelectObserverLocation(const SelectedObserver: Observer);

  procedure UpdateObserverLocation;

{Note: the following function has been moved to unit StarData}
//  procedure UpdatePlanetSelection(var SelectedPlanet : planet;
//    var CurrentStarData : StarDataRecord);

implementation

uses MatLib, SysUtils;

procedure SelectObserverLocation(const SelectedObserver: Observer);
  begin
    if SelectedObserver=Special then
      begin
        writeln;
        UpdateExtendedVariable(ObserverLatitude,6,'N Latitude [deg]');
        UpdateExtendedVariable(ObserverLongitude,6,'W Longitude [deg]');
        UpdateExtendedVariable(ObserverElevation,3,'Elevation [m]');
        writeln;
      end
    else
      begin
        ObserverLatitude  := StandardLocation[SelectedObserver].Latitude;
        ObserverLongitude := StandardLocation[SelectedObserver].Longitude;
        ObserverElevation := StandardLocation[SelectedObserver].Elevation;
      end;

    CurrentObserver := SelectedObserver;
  end;

procedure UpdateObserverLocation;
  var
    MenuSelection, MenuItem : integer;
  begin
    writeln('Available observer locations are:');
    MenuItem := 0;
    writeln(format('%4u',[MenuItem])+'   '+'Quit');
    for MenuItem := ord(Jim)+1 to ord(Special)+1 do
      writeln(format('%4u',[MenuItem])+'   '+ObserverDescription[Observer(MenuItem-1)]);
    writeln;
    MenuSelection := ord(CurrentObserver)+1;
    SelectFromMenu(MenuSelection,0,MenuItem,'Desired observer location');
    if MenuSelection=0 then Halt;
    CurrentObserver := Observer(MenuSelection-1);
    SelectObserverLocation(CurrentObserver);
  end;


initialization
  SharedFilePath := 'C:\Proj\Astron\Shared\';

  {following moved from StarData}
    with BlankStarDataRecord do
    begin
    {following are set to -999 if not available:}
      HRNumber := -999;
      FKNumber := -999;  {catalog number in FK5 Catalog}
      RA2000   := -999;  {Right Acension [decimal hours]}
      Dec2000  := -999;  {Declination [decimal degrees]}
      PM_RA    := -999;  {Proper motion in RA [hours/century]}
      PM_Dec   := -999;  {Proper motion in Dec [degrees/century]}
      Parallax := -999;  {[arc-sec]}
      Vmag     := -999;  {visual magnitude}
      Dmag     := -999;  {difference in magnitude, if multiple}
      Separation := -999; {[arc-sec]}
    {following are blank if not available:}
      StandardName := '';  {e.g. "  9Alp CMa"}
      CommonName   := '';    {e.g., "Sirius"}
    {following are initialized to 0:}
      ObsCount := 0;
    end;



  with StandardLocation[Jim] do
    begin
      DDD(33,38,37.96310,Latitude);   {based on window screen as measured by}
      DDD(117,53,38.68260,Longitude); {Ken Kasbohm of Coast Surveying}
      Elevation := 22.590;
    end;
  with StandardLocation[Tom] do
    begin
      DDD(45,38,02.0,Latitude);   {per Terraserver Photo}
      DDD(122,30,23.7,Longitude); {NAD83 coords converted to NAD27 by MicroDEM}
      Elevation := 96.0;          {94.5 per Topo + 1.5 to telescope}
    end;
  with StandardLocation[Becky] do
    begin
      DDD(33,52,54,Latitude);  {from AAA map}
      DDD(117,52,6,Longitude);
      Elevation := 100; {?}
    end;
  with StandardLocation[Cliff83] do
    begin
      DDD(33,37,13.61273,Latitude);   {per Newport Beach TBM as tied to OCS GPS network}
      DDD(117,55,13.79268,Longitude); {NAD83 coords}
      Elevation := 23.2;          {adding 24 cm to TBM elevation of 22.959 m}
    end;
  with StandardLocation[CDM] do
    begin
      DDD(33,35,44.5,Latitude);   {per Terraserver Photo}
      DDD(117,52,39.7,Longitude); {NAD83 coords converted to NAD27 by MicroDEM}
      Elevation := 22.5;          {DX1962/NB 4 36 benchmark on curb = 20.46 (+/-2cm)}
    end;
  with StandardLocation[PierPkg] do
    begin
      DDD(33,36,35,Latitude);   {NAD27 coords from USCGS navigation chart}
      DDD(117,55,47.5,Longitude);
      Elevation := 3.5;
    end;
  with StandardLocation[SignalPeak] do
    begin
      DDD(33, 36, 21.07833,Latitude);   {NGS data sheet for DX4482}
      DDD(117, 48, 43.05532,Longitude);
      Elevation := 356;
    end;
  with StandardLocation[Spyglass] do
    begin
      Latitude  :=  33.60738;   {highest point estimated with Microdem}
      Longitude := 117.83670;
      Elevation := 217.3;
    end;
  with StandardLocation[Pelican] do
    begin
      Latitude  :=  33.59639;   {north peak estimated with Microdem}
      Longitude := 117.83142;
      Elevation := 229.8;
    end;
  with StandardLocation[Henrik] do
    begin
      Latitude  :=  55.2857;   {from Henrik Bondo's Denmark topo map}
      Longitude := -11.7913;
      Elevation := 40;
    end;
  with StandardLocation[Padua] do
    begin
      Latitude  :=  45.4003;   {from JPL Horizons}
      Longitude := -11.8715;
      Elevation := 49;
    end;

  with StandardLocation[Geocentric] do
    begin
      Latitude  := 0;
      Longitude := 0;
      Elevation := -6378140;  {erad = equatorial radius of Earth in NOVAS}
    end;

  StandardLocation[Special] := StandardLocation[Jim];

  SelectObserverLocation(CurrentObserver);

end.
