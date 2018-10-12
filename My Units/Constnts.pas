unit Constnts;
{contains physical constants and some transformation rules from Physics
 Vade Mecum (1981 ed)                                          4/12/97}

interface
  const
  {Turbo Pascal 7.0 constants:}
    MaxExpArgument = 11300.0;  {larger values cause overflow of exp(x)>(max. extended)}

  {math}
    TwoPi = 2.0*pi;
    PiByTwo = Pi/2;

  {angle}
    Rad = pi/180.0;
    RPD = pi/180;  {radians per degree}
    DPR = 180/pi;  {degrees per radian}
    OneRadian = 1;
    OneDegree = RPD; {[rad]}
    OneArcMinute = OneDegree/60; {[rad]}
    OneArcSec = OneArcMinute/60; {[rad]}
    OneArcSecond = OneArcSec; {[rad]}

  {fundamental physical}
    c = 2.99792458e8; {speed of light [m/s]}
    e = 1.6021892e-19; {elementary charge [C]}
    h = 6.626176e-34; {Plank's constant [J-s]}
    Me = 0.9109534e-30; {electron mass [kg]}
    Na = 6.022045e23;  {Avogadro's number}
    k = 1.380662e-23; {Boltzmann's constant [J/K]}
    Rgas = Na*k;  {molar gas constant R [J/mol-K]}
    G = 6.6720e-11; {gravitational constant [N-m^2/kg^2]}
    hBar = h/TwoPi;
  {Sigma = Stefan-Boltzmann [W/m^2/K^4]}
    Sigma = (pi*pi/60.0)*(k*k*k*k)/hBar/hBar/hBar/c/c;

  {heat}
    OneCalorie = 4.184; {[J]}

  {temperature}
    ZeroC = 273.15; {[K]}

  {time}
    OneMillisecond = 0.001;  {[s]}
    OneSecond = 1;
    OneMinute = 60*OneSecond;  {[s]}
    OneHour = 60*OneMinute;  {[s]}
    OneSiderealHour = OneHour*365.25/366.25; {in civil [s]}
    OneDay  = 24*OneHour;  {[s]}

    JD2000    = 2451545.0;  {Julian Date of epoch J2000.0}
    MJDOffset = 2400000.5;  {number of days subtracted from Julian Date to obtain Modified Julian Date}
    MJD2000    = JD2000 - MJDOffset;  {Modified Julian Date of epoch J2000.0}
    DaysPerCentury = 36525;

  {distance}
    OneMeter = 1;
    OneKm = 1.0e3;  {[m]}
    OneMM = 1.0e-3; {[m]}
    OneMicron = 1.0e-6; {[m]}
    OneNanometer = 1.0e-9; {[m]}
    OneAngstrom = 1.0e-10; {[m]}
    OneAU = 1.49597870e11; {[m]}
    OneInch = 0.0254; {[m]}
    OneFoot = 12.0*OneInch;
    OneMile = 5280.0*OneFoot;

  {pressure}
    StandardAtmosphere = 101325; {[Pa]}
    OneAtmosphere = StandardAtmosphere;
    OneTorr = StandardAtmosphere/760; {[Pa] = 1 mm Hg}
    OneMillibar = 100; {[Pa] = 1 hPa}
    OnehPa = OneMillibar;
    OneMillimeterHg = OneTorr;
    OneInchHg = OneMillimeterHg*OneInch/OneMM;

  {planetary}
    Mearth = 5.9742e24; {[kg]}
    Rearth = 6378.164e3; {equatorial radius [m]}
    Rearth_ave = 6371e3; {ave. radius from Wolf & Brinker, Surveying}
    Rsun = 6.9599e8; {[m]}

  function TK(TC: extended): extended;

  function TC(TK: extended): extended;

implementation
  function TK(TC: extended): extended;
    begin
      TK := ZeroC + TC;
    end;

  function TC(TK: extended): extended;
    begin
      TC := TK - ZeroC;
    end;

begin
end.