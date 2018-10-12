unit H_NOVAS;
{Delphi implementation of routines Astronomical Ephemeris group at Naval Observatory
 as explained by Kaplan et. al.  (AJ97, 1197).    3/10/04}

{$J+} {allow assignable typed constants}

interface
uses
  Classes,
  MPVectors,
  H_JPL_Ephemeris;  {source of data for nutations}

var
  CalculationDetails : TStringList;

{The following parameters were added by JMM on 10/5/04.
They define the target planet's solar illumination geometry as viewed from the Earth.
The CuspDirection is a vector in the NOVAS equatorial system pointing along the line
of cusps -- that is, perpendicular to the earth-planet-sun plane.  The SubSolarAngle
is the angular distance from the SubEarth point to the SubSolar point measured CCW
around the CuspDirection vector.  Its value is always in the range 0..2*pi radians.
The ObserverVertical, also in the NOVAS equatorial system, permits the CuspDirection
to be projected into the local Altitude-Azimuth system.

These parameters are sufficient to determine the orientation and appearance
of the planet's terminator as see from Earth, but the routines used to calculate
them were invented by JMM and may not be as rigorous as the rest of the NOVAS code.

CuspDirection and SubSolarAngle are set by the last call to "tpplan"
ObserverVertical is set by the last call to "zdaz"}

{The following parameters were added by JMM on 8/26/05.
  SubSolarDirection : vector in ICRF system from planet center to subsolar point
  SubEarthDirection : vector in ICRF system from planet center to subearth point
SubSolarDirection and SubEarthDirection are set by the last call to "tpplan"
They are used for determining if a lunar crater is
  (1) in the illuminated hemisphere
  (2) in the visible hemisphere }

{  SubSolarDirection, SubEarthDirection,}
  CuspDirection, ObserverVertical : TVector;
  SubSolarAngle : extended;

procedure tpplan (const tjd, ujd,glon,glat,ht : extended; const lplan : TJPL_TargetOptions;
  var pout,vout : TVector; var ra,dec,dis,drdt : extended);
//   this entry computes the topocentric place of a planet,
//   given the geodetic location of the observer.  Kaplan assumes applan
//   was previously called with an equivalent ephemeris time, but the
//   Delphi implementation incorporates the applan "call" inline.

//        tjd  := TDT julian date (in)
//        ujd  := UT1 julian date (in)

       {note: Kaplan specifies a single parameter  ujd = "UT1 time," but assumes
         that 'applan' has previously been called with the corresponding ephemeris
         time 'tjd'  and planet number "l".  Since the present implementation
         "calls" applan internally I have added these parameters to the call
         sequence, since they cannot be determined from the other information
         supplied.

         Kaplan's code also interprets "ujd" as hours of sidereal time for the
         topocentric place if the value is less than 100 -- this feature is not
         implemented here since the full TDT cannot be deduced from local sidereal
         time}

//        glon   := geodetic longitude (east +) of observer
//                 in degrees (in)
//        glat   := geodetic latitude (north +) of observer
//                 in degrees (in)
//        ht     := height of observer in meters (in)
//        lpan   := body ID number for desired planet (in)  [added JMM]
//        pout   := position vector in au, referred to
//                 true equator and equinox of date (out)
//        vout   := velocity vector in au/day, referred to
//                 true equator and equinox of date (out)
//        ra     := topocentric right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := topocentric declination in degrees, referred to
//                 true equator and equinox of date (out)
//        dis    := true distance from observer to planet in au (out)
//        drst   := true radial velocity from earth to planet in au/day (out)


procedure applan (const tjd : extended; const l,n : TJPL_TargetOptions; var pout,vout : TVector;
  var ra,dec,dis,drdt : extended);
//   this subroutine computes the apparent place of a planet or other
//   solar system body.  rectangular coordinates of solar system bodies
//   are obtained from subroutine solsys.  see kaplan, et al. (1989)
//   astronomical journal 97, 1197-1210.

//        tjd    := tt julian date for apparent place (in)
{note: body ID 1 = Mercury .. 9 = Pluto; 10 = Sun;  11 = Moon}
//        l      := body identification number for desired planet (in)
//        n      := body identification number for {desired center, typically = } the earth (in)
//        pout   := position vector in au, referred to
//                 true equator and equinox of date (out)
//        vout   := velocity vector in au/day, referred to
//                 true equator and equinox of date (out)
//        ra     := apparent right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := apparent declination in degrees, referred to
//                 true equator and equinox of date (out)
//        dis    := true distance from earth to planet in au (out)
//        drst   := true radial velocity from earth to planet in au/day (out)

procedure tpstar (const tjd : extended; const ram,decm,pmra,pmdec,parlax,radvel :extended;
  const ujd,glon,glat,ht : extended; var ra,dec : extended);
//   Computes the topocentric place of a star, given the location of the observer.

//   Kaplan calls this routine with the second line of parameters only after
//     a previous call to apstar at the corresponding TDT.
//   In the present implementation, a single call to this routine is made with
//     the added parameters on the first line (which the same as those supplied
//     to 'apstar' with the exception of  'n' (center body ID number), since
//     'n' must = 3 (Earth) in the preent context.

//        ujd    := ut1 julian date (in)
//            Note:  Kaplan interprets ujd as sidereal time if its magnitude is
//                   less than 100.  This feature is not implemented here.
//        glon   := geodetic longitude (east +) of observer
//                 in degrees (in)
//        glat   := geodetic latitude (north +) of observer
//                 in degrees (in)
//        ht     := height of observer in meters (in)
//        ra     := topocentric right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := topocentric declination in degrees, referred to
//                 true equator and equinox of date (out)


procedure apstar (const tjd : extended; const n : TJPL_TargetOptions;
  const ram,decm,pmra,pmdec,parlax,radvel :extended; var ra,dec : extended);
//   this subroutine computes the apparent place of a star,
//   given its mean place, proper motion, parallax, and radial
//   velocity for j2000.0.  see kaplan, et al. (1989) astronomical
//   journal 97, 1197-1210.

//        tjd    := tt julian date for apparent place (in)
//        n      := body identification number for the earth (in)
//        ram    := mean right ascension j2000.0 in hours (in)
//        decm   := mean declination j2000.0 in degrees (in)
//        pmra   := proper motion in ra in time seconds per julian
//                 century (in)
//        pmdec  := proper motion in dec in arcseconds per julian
//                 century (in)
//        parlax := parallax in arcseconds (in)
//        radvel := radial velocity in kilometers per second (in)
//        ra     := apparent right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := apparent declination in degrees, referred to
//                 true equator and equinox of date (out)

procedure propmo (const tjd1 : extended; const pos1,vel1 : TVector;
  const tjd2 :extended; var pos2 : TVector);

//   this subroutine applies proper motion, including foreshortening
//   effects, to a star's position.

//        tjd1 := tdb julian date of first epoch (in)
//        pos1 := position vector at first epoch (in)
//        vel1 := velocity vector at first epoch (in)
//        tjd2 := tdb julian date of second epoch (in)
//        pos2 := position vector at second epoch (out)

procedure vectrs (const ra,dec,pmra,pmdec,parllx,rv : extended; var pos,vel :TVector);

//   this subroutine converts angular quantities to vectors.

//        ra     := right ascension in hours (in)
//        dec    := declination in degrees (in)
//        pmra   := proper motion in ra in time seconds per
//                 julian century (in)
//        pmdec  := proper motion in dec in arcseconds per
//                 julian century (in)
//        parllx := parallax in arcseconds (in)
//        rv     := radial velocity in kilometers per second (in)
//        pos    := position vector, equatorial rectangular coordinates,
//                 components in au (out)
//        vel    := velocity vector, equatorial rectangular coordinates,
//                 components in au/day (out)

procedure Angles(const PositionVector : TVector; var RA_hrs, Dec_degs : extended);
//   this subroutine converts a vector to angular quantities.

//        pos := position vector, equatorial rectangular
//              coordinates (in)
//        ra  := right ascension in hours (out)
//        dec := declination in degrees (out)

procedure Polar(const X,Y,Z : extended; var R,ThetaDegrees,PhiDegrees : extended);
//        conversion of cartesian coordinates (x,y,z)
//        into polar coordinates (r,theta,phi)
//        (theta in [-90 deg,+90 deg]; phi in [-180 deg,+180 deg])

procedure Cartesian(const R,ThetaDegrees,PhiDegrees: extended; VAR X,Y,Z: extended);
//       conversion of polar coordinates (r,theta,phi)
//       into cartesian coordinates (x,y,z)
//       (theta in [-90 deg,+90 deg]; phi in [-360 deg,+360 deg])

procedure DMStoDecDeg(D,M :integer; S : extended; var DecDeg : extended);
//      conversion of degrees, minutes and seconds into
//      degrees and fractions of a degree -- also works for time (DecHrs)

procedure DecDegToDMS(DecDeg :extended; VAR D,M : integer; VAR S : extended);
//      conversion of degrees and fractions of a degree
//      into degrees, minutes and seconds -- also works for time (DecHrs)

procedure FunargOmega(const t : extended; var Omega : extended);
{this is extracted from Kaplan's funarg subroutine, which calculates a number
 of other polynomials even when only Omega is desired}

//        t      := tdb time in julian centuries since j2000.0 (in)
//        omega  := mean longitude of the moon's ascending node
//                 in radians at date tjd (out)

procedure nod (const tjd : extended; var DelPsi, DelEps : extended);
{Note: Kaplan passes "t" in centuries and evaluates using a long series;
  this version reads values from JPL ephemeris}
//        tjd    := tdb time in julian days (in)
//        DelPsi := nutation in longitude in arcseconds (out)
//        DelEps := nutation in obliquity in arcseconds (out)

procedure nod1 (const t : extended; var dpsi,deps : extended);

//   subroutine nod version 1.
//   this subroutine evaluates the nutation series and returns the
//   values for nutation in longitude and nutation in obliquity.
//   wahr nutation series for axis b for gilbert & dziewonski earth
//   model 1066a.  see seidelmann (1982) celestial mechanics 27,
//   79-106.  1980 iau theory of nutation.

//        t    := tdb time in julian centuries since j2000.0 (in)
//        dpsi := nutation in longitude in arcseconds (out)
//        deps := nutation in obliquity in arcseconds (out)

procedure nod2 (const t : extended; var dpsi,deps : extended);
{this is the same as Kaplan's nod1 but it uses the table of coefficients from the IAU}

procedure celpol (const ddpsi,ddeps : extended);
//   this entry allows for the specification of celestial pole
//   offsets for high-precision applications.  these are added
//   to the nutation parameters delta psi and delta epsilon.
//   daily values of the offsets are published, for example,
//   in iers bulletins a and b.  this entry, if used, should
//   be called before any other routines for a given date.
//   values of the pole offsets specified via a call to this
//   entry will be used until explicitly changed.

//        ddpsi  := value of offset in delta psi (dpsi)
//                 in arcseconds (in)
//        ddeps  := value of offset in delta epsilon (deps)
//                 in arcseconds (in)

procedure etilt (const tjd : extended; var oblm,oblt,eqeq,dpsi,deps : extended);

//   this subroutine computes quantities related to the orientation
//   of the earth's rotation axis at julian date tjd.
//   implements equation of the equinoxes definition as per
//   iau resolution c7 of 1994.

//        tjd    := tdb julian date for orientation parameters (in)
//        oblm   := mean obliquity of the ecliptic in degrees at
//                 date tjd (out)
//        oblt   := true obliquity of the ecliptic in degrees at
//                 date tjd (out)
//        eqeq   := equation of the equinoxes in time seconds at
//                 date tjd (out)
//        dpsi   := nutation in longitude in arcseconds at
//                 date tjd (out)
//        deps   := nutation in obliquity in arcseconds at
//                 date tjd (out)

procedure sidtim (const tjdh,tjdl : extended; const k : integer; var gst : extended);

//   this subroutine computes the greenwich sidereal time
//   (either mean or apparent) at julian date tjdh + tjdl.
//   see aoki, et al. (1982) astronomy and astropysics 105, 359-361.

//        tjdh   := julian date, high-order part (in)
//        tjdl   := julian date, low-order part (in)
//                 julian date may be split at any point, but
//                 for highest precision, set tjdh to be the integral
//                 part of the julian date, and set tjdl to be the
//                 fractional part
//        k      := time selection code (in)
//                 set k:=0 for greenwich mean sidereal time
//                 set k:=1 for greenwich apparent sidereal time
//        gst    := greenwich (mean or apparent) sidereal time
//                 in hours (out)

//   note:  for most applications, basis for input julian date should
//   be ut1, which results in ordinary sidereal time output in gst.
//   use of input julian date based on tdb results in 'dynamical
//   sidereal time'.

procedure times (const tdbjd : extended; var ttjd,secdif :extended);

//   this subroutine computes the terrestrial time (tt) julian date
//   corresponding to a barycentric dynamical time (tdb) julian date.
//   expressions used in this version are approximations resulting
//   in accuracies of about 20 microseconds.  see explanatory
//   supplement to the astronomical almanac, pp. 42-44 and 316.

//        tdbjd  := tdb julian date (in)
//        ttjd   := tt julian date (out)
//        secdif := difference tdbjd-ttjd, in seconds (out)

procedure geocen (const pos1,pe : TVector; var pos2 : TVector; var tlight : extended);

//   this subroutine moves the origin of coordinates from the
//   barycenter of the solar system to the center of mass of the
//   earth, i.e., this subroutine corrects for parallax.

//        pos1   := position vector, referred to origin at solar system
//                 barycenter, components in au (in)
//        pe     := position vector of center of mass of the earth,
//                 referred to origin at solar system barycenter,
//                 components in au (in)
//        pos2   := position vector, referred to origin at center of
//                 mass of the earth, components in au (out)
//        tlight := light time from body to earth in days (out)

procedure sunfld (const pos1,pe : TVector; var pos2 : TVector);

//   subroutine sunfld version 1.
//   this subroutine corrects position vector for the deflection
//   of light in the gravitational field of the sun.  see misner,
//   thorne, and wheeler (1973), gravitation, pp. 184-185.  this
//   subroutine valid for bodies within the solar system as well as
//   for stars.

//        pos1 := position vector, referred to origin at center of mass
//               of the earth, components in au (in)
//        pe   := position vector of center of mass of the earth,
//               referred to origin at center of mass of
//               the sun, components in au (in)
//        pos2 := position vector, referred to origin at center of mass
//               of the earth, corrected for gravitational deflec-
//               tion, components in au (out)

procedure aberat (const pos1,ve : TVector; const tlight : extended; var pos2 : TVector);

//   this subroutine corrects position vector for aberration of light.
//   algorithm includes relativistic terms.  see murray (1981)
//   mon. notices royal ast. society 195, 639-648.

//        pos1   := position vector, referred to origin at center of
//                 mass of the earth, components in au (in)
//        ve     := velocity vector of center of mass of the earth,
//                 referred to origin at solar system barycenter,
//                 components in au/day (in)
//        tlight := light time from body to earth in days (in)
//                 if tlight := 0.0, this subroutine will compute
//        pos2   := position vector, referred to origin at center of
//                 mass of the earth, corrected for aberration,
//                 components in au (out)

procedure preces (const tjd1 : extended; const pos1 : TVector; const tjd2 : extended;
  var pos2 : TVector);

//   this subroutine precesses equatorial rectangular coordinates from
//   one epoch to another.  the coordinates are referred to the mean
//   equator and equinox of the two respective epochs.  see
//   explanatory supplement to the astronomical almanac, pp. 103-104,
//   lieske, et al. (1977) astronomy and astrophysics 58, 1-16, and
//   lieske (1979) astronomy and astrophysics 73, 282-284.

//        tjd1 := tdb julian date of first epoch (in)
//        pos1 := position vector, geocentric equatorial rectangular
//               coordinates, referred to mean equator and equinox of
//               first epoch (in)
//        tjd2 := tdb julian date of second epoch (in)
//        pos2 := position vector, geocentric equatorial rectangular
//               coordinates, referred to mean equator and equinox of
//               second epoch (out)

procedure nutate (const tjd : extended; const pos1 : TVector; var pos2 : TVector);

//   this subroutine nutates equatorial rectangular coordinates from
//   mean equator and equinox of epoch to true equator and equinox of
//   epoch.  see explanatory supplement to the astronomical almanac,
//   pp. 114-115.

//        tjd    := tdb julian date of epoch (in)
//        pos1   := position vector, geocentric equatorial rectangular
//                 coordinates, referred to mean equator and equinox
//                 of epoch (in)
//        pos2   := position vector, geocentric equatorial rectangular
//                 coordinates, referred to true equator and equinox
//                 of epoch (out)

//   note:  if tjd is negative, inverse nutation (true to mean)
//   is applied.

procedure spin (const st : extended; const pos1 : TVector; var pos2 : TVector);

//   this subroutine transforms geocentric rectangular coordinates
//   from rotating system based on rotational equator and orthogonal
//   reference meridian to non-rotating system based on true equator
//   and equinox of date.

//        st     := local apparent sidereal time at reference meridian
//                 in hours (in)
//        pos1   := vector in geocentric rectangular
//                 rotating system, referred to rotational equator
//                 and orthogonal reference meridian (in)
//        pos2   := vector in geocentric rectangular
//                 non-rotating system, referred to true equator
//                 and equinox of date (out)

procedure wobble (const Pole_x,Pole_y : extended; const pos1 : TVector; var pos2 : TVector);

//   this subroutine corrects earth-fixed geocentric rectangular
//   coordinates for polar motion.  it transforms a vector from
//   earth-fixed geographic system to rotating system based on
//   rotational equator and orthogonal greenwich meridian through
//   axis of rotation.

//        Pole_x      := conventionally-defined x coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        Pole_y      := conventionally-defined y coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        pos1   := vector in geocentric rectangular
//                 earth-fixed system, referred to geographic
//                 equator and greenwich meridian (in)
//        pos2   := vector in geocentric rectangular
//                 rotating system, referred to rotational equator
//                 and orthogonal greenwich meridian (out)

procedure pnsw (const tjd,gast,Pole_x,Pole_y : extended; const vece : TVector; var vecs : TVector);

//   transforms a vector from earth-fixed system to space-fixed system
//   by applying rotations for wobble, spin, nutation, and precession.
//   (combined rotation is symbolized  p n s w .)   specifically,
//   it transforms a vector from earth-fixed geographic system to
//   space-fixed system based on mean equator and equinox of j2000.0.

//        tjd    := tt julian date (in)
//        gast   := greenwich apparent sidereal time, in hours (in)
//        Pole_x      := conventionally-defined x coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        Pole_y      := conventionally-defined y coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        vece   := vector in geocentric rectangular
//                 earth-fixed system, referred to geographic
//                 equator and greenwich meridian (in)
//        vecs   := vector in geocentric rectangular
//                 space-fixed system, referred to mean equator
//                 and equinox of j2000.0 (out)

//   note:  tjd:=0. means no precession/nutation transformation,
//   gast:=0. means no spin transformation, x:=y:=0. means no
//   wobble transformation.

procedure Terra(const glon,glat,ht,st : extended; var pos,vel : TVector);

//    this subroutine computes the position and velocity vectors of
//    a terrestrial observer with respect to the center of the earth.

//         glon   = longitude of observer with respect to reference
//                  meridian (east +) in degrees (in)
//         glat   = geodetic latitude (north +) of observer
//                  in degrees (in)
//         ht     = height of observer in meters (in)
//         st     = local apparent sidereal time at reference meridian
//                  in hours (in)
//         pos    = position vector of observer with respect to center
//                  of earth, equatorial rectangular coordinates,
//                  referred to true equator and equinox of date,
//                  components in au (out)
//         vel    = velocity vector of observer with respect to center
//                  of earth, equatorial rectangular coordinates,
//                  referred to true equator and equinox of date,
//                  components in au/day (out)

//    note:  if reference meridian is greenwich and st=0.d0, pos
//    is effectively referred to equator and greenwich.


procedure zdaz (const ujd,Pole_x,Pole_y,glon,glat,ht,ra,dec : extended; const irefr : integer;
   var zd,az,rar,decr : extended);

//   this subroutine transforms topocentric right ascension and
//   declination to zenith distance and azimuth.  this routine uses
//   a method that properly accounts for polar motion, which is
//   significant at the sub-arcsecond level.  this subroutine
//   can also adjust coordinates for atmospheric refraction.

//        ujd    := UT1 julian date (in)
//        Pole_x      := conventionally-defined x coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        Pole_y      := conventionally-defined y coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        glon   := geodetic longitude (east +) of observer
//                 in degrees (in)
//        glat   := geodetic latitude (north +) of observer
//                 in degrees (in)
//        ht     := height of observer in meters (in)
//        ra     := topocentric right ascension of object of interest,
//                 in hours, referred to true equator and equinox
//                 of date (in)
//        dec    := topocentric declination of object of interest,
//                 in degrees, referred to true equator and equinox
//                 of date (in)
//        irefr  := atmospheric refraction option (in):
//                 set irefr:=0  for no refraction
//                 set irefr:=1  to include refraction
//        zd     := topocentric zenith distance in degrees,
//                 affected by refraction if irefr:=1 (out)
//        az     := topocentric azimuth (measured east from north)
//                 in degrees (out)
//        rar    := topocentric right ascension of object of interest,
//                 in hours, referred to true equator and equinox
//                 of date, affected by refraction if irefr:=1 (out)
//        decr   := topocentric declination of object of interest,
//                 in degrees, referred to true equator and equinox
//                 of date, affected by refraction if irefr:=1 (out)

//   note 1:  ujd may be specified either as a ut1 julian date
//   (e.g., 2451251.823) or an hour and fraction of greenwich
//   apparent sidereal time (e.g., 19.1846). [NOT implemented here]
//   x and y can be set to zero if sub-arcsecond accuracy is not needed.
//   ht is used only for refraction, if irefr:=1.  ra and dec can
//   be obtained from tpstar or tpplan.

//   note 2:  the directons zd:=0 (zenith) and az:=0 (north) are
//   here considered fixed in the terrestrial frame.  specifically,
//   the zenith is along the geodetic normal, and north is toward
//   the iers reference pole.

//   note 3:  if irefr:=0, then rar:=ra and decr:=dec.

implementation
uses
  SysUtils,
  Dialogs,
  Math,           {Floor}
  Matrices,
  Trig_Fns,       {Atn2}
  Constnts;       {definition of arc-sec}

type
  TRotationMatrix = array[1..3,1..3] of extended;

const
  seccon = 206264.8062470964;

{the following two globals represent corrections to the conventional nutation
  angles DelPsi and DelEps [arcseconds] as provided by the IERS in their bulletins.
  They may be set by a call to "celpol(ddpsi,ddeps)".}
  psicor : extended = 0.0;
  epscor : extended = 0.0;

procedure propmo (const tjd1 : extended; const pos1,vel1 : TVector;
  const tjd2 :extended; var pos2 : TVector);

//   this subroutine applies proper motion, including foreshortening
//   effects, to a star's position.

//        tjd1 := tdb julian date of first epoch (in)
//        pos1 := position vector at first epoch (in)
//        vel1 := velocity vector at first epoch (in)
//        tjd2 := tdb julian date of second epoch (in)
//        pos2 := position vector at second epoch (out)
var
  j : TVectorIndex;

begin
      for j:= X to Z do
         pos2[j] := pos1[j] + vel1[j] * (tjd2 - tjd1)
end;

procedure apstar (const tjd : extended; const n : TJPL_TargetOptions;
  const ram,decm,pmra,pmdec,parlax,radvel :extended; var ra,dec : extended);
//   this subroutine computes the apparent place of a star,
//   given its mean place, proper motion, parallax, and radial
//   velocity for j2000.0.  see kaplan, et al. (1989) astronomical
//   journal 97, 1197-1210.

//        tjd    := tt julian date for apparent place (in)
//        n      := body identification number for the earth (in)
//        ram    := mean right ascension j2000.0 in hours (in)
//        decm   := mean declination j2000.0 in degrees (in)
//        pmra   := proper motion in ra in time seconds per julian
//                 century (in)
//        pmdec  := proper motion in dec in arcseconds per julian
//                 century (in)
//        parlax := parallax in arcseconds (in)
//        radvel := radial velocity in kilometers per second (in)
//        ra     := apparent right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := apparent declination in degrees, referred to
//                 true equator and equinox of date (out)

const
  t0 = JD2000;  {julian date of epoch j2000.0}
  tlast : extended = 0.0;
  peb : TVector = (0, 0, 0);
  veb : TVector = (0, 0, 0);
  pes : TVector = (0, 0, 0);
  ves : TVector = (0, 0, 0);

var
  t1,xx,secdif,rm,dm,pmr,pmd,pi,rv,tlight,r,d : extended;
  pb,vb,ps,pos1,vel1,pos2,pos3,pos4,pos5,pos6,pos7 : TVector;
  EphemerisResults : TEphemerisOutput;

begin
//  set return values in case of error
  ra := 0.0;
  dec := 0.0;

//   compute t1, the tdb julian date corresponding to tjd
  times (tjd,xx,secdif);
  t1 := tjd + secdif / 86400.0;
  if (abs(tjd-tlast)>=1.0e-8) then
    begin
      tlast := 0;  {in event of error}
//   get position and velocity of the earth wrt barycenter of
//   solar system and wrt center of sun
      ReadEphemeris(t1,JPL_Earth,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      peb := EphemerisResults.R;
      veb := EphemerisResults.R_dot;
      ReadEphemeris(t1,JPL_Earth,JPL_Sun,PositionsOnly,AU_day,EphemerisResults);
      pes := EphemerisResults.R;
      tlast := tjd;
    end;

  pb := peb;
  vb := veb;
  ps := pes;

  rm := ram;
  dm := decm;
  pmr := pmra;
  pmd := pmdec;
  pi := parlax;
  rv := radvel;

//   compute apparent place
  vectrs (rm,dm,pmr,pmd,pi,rv,pos1,vel1);
  propmo (t0,pos1,vel1,t1,pos2);
  geocen (pos2,pb,pos3,tlight);
  sunfld (pos3,ps,pos4);
  aberat (pos4,vb,tlight,pos5);
  preces (t0,pos5,t1,pos6);
  nutate (t1,pos6,pos7);
  angles (pos7,r,d);

  ra := r;
  dec := d;
end;

procedure tpstar (const tjd : extended; const ram,decm,pmra,pmdec,parlax,radvel :extended;
  const ujd,glon,glat,ht : extended; var ra,dec : extended);
//   Computes the topocentric place of a star, given the location of the observer.

//   Kaplan calls this routine with the second line of parameters only after
//     a previous call to apstar at the corresponding TDT.
//   In the present implementation, a single call to this routine is made with
//     the added parameters on the first line (which the same as those supplied
//     to 'apstar' with the exception of  'n' (center body ID number), since
//     'n' must = 3 (Earth) in the preent context.

//        ujd    := ut1 julian date (in)
//            Note:  Kaplan interprets ujd as sidereal time if its magnitude is
//                   less than 100.  This feature is not implemented here.
//        glon   := geodetic longitude (east +) of observer
//                 in degrees (in)
//        glat   := geodetic latitude (north +) of observer
//                 in degrees (in)
//        ht     := height of observer in meters (in)
//        ra     := topocentric right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := topocentric declination in degrees, referred to
//                 true equator and equinox of date (out)


const
  t0 = JD2000;  {julian date of epoch j2000.0}
  n = 3;  {body number for Earth}
  tlast : extended = 0.0;
  peb : TVector = (0, 0, 0);
  veb : TVector = (0, 0, 0);
  pes : TVector = (0, 0, 0);
  ves : TVector = (0, 0, 0);

var
  t1,xx,secdif,eqeq,st,gast,rm,dm,pmr,pmd,pi,rv,tlight,r,d : extended;
  pog,vog,pb,vb,ps,pos1,vel1,pos2,vel2,pos3,pos4,pos5,pos6,pos7 : TVector;
  EphemerisResults : TEphemerisOutput;

begin

{----------  the following is equivalent to a call to APSTAR ------------}
//  set return values in case of error
  ra := 0.0;
  dec := 0.0;

//   compute t1, the tdb julian date corresponding to tjd
  times (tjd,xx,secdif);
  t1 := tjd + secdif / 86400.0;
  if (abs(tjd-tlast)>=1.0e-8) then
    begin
      tlast := 0;  {in event of error}
//   get position and velocity of the earth wrt barycenter of
//   solar system and wrt center of sun
      ReadEphemeris(t1,JPL_Earth,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      peb := EphemerisResults.R;
      veb := EphemerisResults.R_dot;
      ReadEphemeris(t1,JPL_Earth,JPL_Sun,PositionsOnly,AU_day,EphemerisResults);
      pes := EphemerisResults.R;
      tlast := tjd;
    end;

  pb := peb;
  vb := veb;
  ps := pes;

  rm := ram;
  dm := decm;
  pmr := pmra;
  pmd := pmdec;
  pi := parlax;
  rv := radvel;

(*
{the following calculates a geocentric apparent place -- it is unnecessary since
 the results will be superseded with those using the correct observing locations}
//   compute apparent place
  vectrs (rm,dm,pmr,pmd,pi,rv,pos1,vel1);
  propmo (t0,pos1,vel1,t1,pos2);
  geocen (pos2,pb,pos3,tlight);
  sunfld (pos3,ps,pos4);
  aberat (pos4,vb,tlight,pos5);
  preces (t0,pos5,t1,pos6);
  nutate (t1,pos6,pos7);
  angles (pos7,r,d);

  ra := r;
  dec := d;
*)
{----------  end of intiial call to APSTAR ------------}

//   get position and velocity of observer wrt center of earth
  sidtim (ujd,0.0,0,st);
  etilt (t1,xx,xx,eqeq,xx,xx);
  gast := st + eqeq/3600.0;
  terra (glon,glat,ht,gast,pos1,vel1);
  nutate (-t1,pos1,pos2);
  preces (t1,pos2,t0,pog);
  nutate (-t1,vel1,vel2);
  preces (t1,vel2,t0,vog);

//   compute position and velocity of observer wrt barycenter of
//   solar system and position wrt center of sun
  VectorSum(peb, pog, pb);
  VectorSum(veb, vog, vb);
  VectorSum(pes, pog, ps);

{---  the following is equivalent to Kaplan's entry to the last part of APSTAR ------------}

//   recompute apparent place using position and velocity of observer
  vectrs (rm,dm,pmr,pmd,pi,rv,pos1,vel1);
  propmo (t0,pos1,vel1,t1,pos2);
  geocen (pos2,pb,pos3,tlight);
  sunfld (pos3,ps,pos4);
  aberat (pos4,vb,tlight,pos5);
  preces (t0,pos5,t1,pos6);
  nutate (t1,pos6,pos7);
  angles (pos7,r,d);

  ra := r;
  dec := d;

end;


procedure vectrs (const ra,dec,pmra,pmdec,parllx,rv : extended; var pos,vel :TVector);

//   this subroutine converts angular quantities to vectors.

//        ra     := right ascension in hours (in)
//        dec    := declination in degrees (in)
//        pmra   := proper motion in ra in time seconds per
//                 julian century (in)
//        pmdec  := proper motion in dec in arcseconds per
//                 julian century (in)
//        parllx := parallax in arcseconds (in)
//        rv     := radial velocity in kilometers per second (in)
//        pos    := position vector, equatorial rectangular coordinates,
//                 components in au (out)
//        vel    := velocity vector, equatorial rectangular coordinates,
//                 components in au/day (out)

const
  seccon = 206264.8062470964;
  kmau   =  1.49597870e8;
var
  paralx,dist,r,d,cra,sra,cdc,sdc,pmr,pmd,rvl : extended;

begin
//   if parallax is unknown, undetermined, or zero, set it to 1e-7
//   arcsecond, corresponding to a distance of 10 megaparsecs
      paralx := parllx;
      if (paralx<=0.0) then paralx := 1.0e-7;

//   convert right ascension, declination, and parallax to position
//   vector in equatorial system with units of au
      dist := seccon / paralx;
      r := ra * 54000.0 / seccon;
      d := dec * 3600.0 / seccon;
      cra := cos(r);
      sra := sin(r);
      cdc := cos(d);
      sdc := sin(d);
      pos[X] := dist * cdc * cra;
      pos[Y] := dist * cdc * sra;
      pos[Z] := dist * sdc;

//   convert proper motion and radial velocity to orthogonal components
//   of motion with units of au/day
      pmr := pmra * 15.0 * cdc / (paralx * 36525.0);
      pmd := pmdec / (paralx * 36525.0);
      rvl := rv * 86400.0 / kmau;

//   transform motion vector to equatorial system
      vel[X] := - pmr * sra   - pmd * sdc * cra   + rvl * cdc * cra;
      vel[Y] :=   pmr * cra   - pmd * sdc * sra   + rvl * cdc * sra;
      vel[Z] :=                 pmd * cdc         + rvl * sdc;

end;


procedure Angles(const PositionVector : TVector; var RA_hrs, Dec_degs : extended);
//   this subroutine converts a vector to angular quantities.

//        pos := position vector, equatorial rectangular
//              coordinates (in)
//        ra  := right ascension in hours (out)
//        dec := declination in degrees (out)

var
  r, d : extended;
begin
{Note: Atan2 is from my Trig_Fns unit as Delphi help says their Math.ArcTan2
  can't handle X = 0}
  r := Atan2(PositionVector[Y],PositionVector[X]);
  d := Atan2(PositionVector[Z],Sqrt(Sqr(PositionVector[X]) + Sqr(PositionVector[Y])));
  RA_hrs := r * 12/pi;  {24 hours = 2pi radians}
  if (RA_hrs<0.0) then RA_hrs := RA_hrs + 24;
  if (RA_hrs>=24) then RA_hrs := RA_hrs - 24;
  Dec_degs := d/OneDegree;
end;

PROCEDURE Polar(const X,Y,Z : extended; var R,ThetaDegrees,PhiDegrees : extended);
(*-----------------------------------------------------------------------*)
(* POLAR: conversion of cartesian coordinates (x,y,z)                    *)
(*        into polar coordinates (r,theta,phi)                           *)
(*        (theta in [-90 deg,+90 deg]; phi in [-180 deg,+180 deg])       *)
(*-----------------------------------------------------------------------*)
  VAR RHO: extended;
  BEGIN
    RHO:=X*X+Y*Y;  R:=SQRT(RHO+Z*Z);
    PhiDegrees:=Atan2(Y,X)/OneDegree; IF PhiDegrees<0 THEN PhiDegrees:=PhiDegrees+360.0;
    RHO:=SQRT(RHO); ThetaDegrees:=Atan2(Z,RHO)/OneDegree;
  END;

PROCEDURE Cartesian(const R,ThetaDegrees,PhiDegrees: extended; VAR X,Y,Z: extended);
(*-----------------------------------------------------------------------*)
(* CART: conversion of polar coordinates (r,theta,phi)                   *)
(*       into cartesian coordinates (x,y,z)                              *)
(*       (theta in [-90 deg,+90 deg]; phi in [-360 deg,+360 deg])        *)
(*-----------------------------------------------------------------------*)
  VAR RCST, ThetaRad, PhiRad : extended;
  BEGIN
    ThetaRad := ThetaDegrees*OneDegree;
    PhiRad   := PhiDegrees*OneDegree;
    RCST := R*cos(ThetaRad);
    X    := RCST*cos(PhiRad); Y := RCST*sin(PhiRad); Z := R*sin(ThetaRad)
  END;

PROCEDURE DMStoDecDeg(D,M:integer;S:extended;VAR DecDeg:extended);
(*-----------------------------------------------------------------------*)
(*      conversion of degrees, minutes and seconds into                  *)
(*      degrees and fractions of a degree                                *)
(*-----------------------------------------------------------------------*)
 VAR SIGN: extended;
  BEGIN
    IF ( (D<0) OR (M<0) OR (S<0) ) THEN SIGN:=-1.0 ELSE SIGN:=1.0;
    DecDeg:=SIGN*(ABS(D)+ABS(M)/60.0+ABS(S)/3600.0);
  END;

PROCEDURE DecDegToDMS(DecDeg:extended;VAR D,M:integer;VAR S:extended);
(*-----------------------------------------------------------------------*)
(*      conversion of degrees and fractions of a degree                  *)
(*      into degrees, minutes and seconds                                *)
(*-----------------------------------------------------------------------*)
  VAR D1: extended;
  BEGIN
    D1:=ABS(DecDeg);  D:=TRUNC(D1);
    D1:=(D1-D)*60.0;  M:=TRUNC(D1);  S:=(D1-M)*60.0;
    IF (DecDeg<0) THEN
      IF (D>0) THEN D:=-D ELSE IF (M<>0) THEN M:=-M ELSE S:=-S;
  END;

function Dmod(const x, y : extended) : extended;
{Fortran function:  floating point MOD (remainder)}
var
  quotient : extended;
begin
  quotient := x / y;
  if (quotient >= 0) then
    quotient := floor(quotient)
  else
    quotient := -floor(-quotient);
  Result := x - y * quotient;
end;

procedure funarg (const t : extended; var el,elprim,f,d,omega : extended);

//   this subroutine computes fundamental arguments (mean elements)
//   of the sun and moon.  see seidelmann (1982) celestial
//   mechanics 27, 79-106 (1980 iau theory of nutation).

//        t      := tdb time in julian centuries since j2000.0 (in)
//        el     := mean anomaly of the moon in radians
//                 at date tjd (out)
//        elprim := mean anomaly of the sun in radians
//                 at date tjd (out)
//        f      := mean longitude of the moon minus mean longitude
//                 of the moon's ascending node in radians
//                 at date tjd (out)
//        d      := mean elongation of the moon from the sun in
//                 radians at date tjd (out)
//        omega  := mean longitude of the moon's ascending node
//                 in radians at date tjd (out)

const
  rev = 1296000;
  tlast : extended = 0.0;
  arg : array [1..5] of extended = (0, 0, 0, 0, 0);

var
   i : integer;

begin
      if (abs(t-tlast)>1.0e-12) then
        begin

//   compute fundamental arguments in arcseconds

          arg[1] := ((+0.064 * t + 31.310) * t + 715922.633) * t
            + 485866.733 + dmod(1325.0*t,1.0) * rev;
          arg[1] := dmod(arg[1],rev);

          arg[2] := ((-0.012 * t - 0.577) * t + 1292581.224) * t
              + 1287099.8040 + dmod(99.0*t,1.0) * rev;
          arg[2] := dmod(arg[2],rev);

          arg[3] := ((+0.011 * t - 13.257) * t + 295263.137) * t
              + 335778.877 + dmod(1342.0*t,1.0) * rev;
          arg[3] := dmod(arg[3],rev);

          arg[4] := ((+0.019 * t - 6.891) * t + 1105601.328) * t
              + 1072261.307 + dmod(1236.0*t,1.0) * rev;
          arg[4] := dmod(arg[4],rev);

          arg[5] := ((0.008 * t + 7.455) * t - 482890.539) * t
              + 450160.280  - dmod(5.0*t,1.0) * rev;
          arg[5] := dmod(arg[5],rev);

    //   convert arguments to radians
          for i :=1 to 5 do
            begin
              arg[i] := dmod(arg[i],rev);
              if (arg[i]<0) then arg[i] := arg[i] + rev;
              arg[i] := arg[i]*OneArcSec;
            end;

          tlast := t

        end;

      el     := arg[1];
      elprim := arg[2];
      f      := arg[3];
      d      := arg[4];
      omega  := arg[5];


end;

procedure FunargOmega(const t : extended; var Omega : extended);
{this is extracted from Kaplan's funarg subroutine, which calculates a number
 of other polynomials even when only Omega is desired}

//        t      := tdb time in julian centuries since j2000.0 (in)
//        omega  := mean longitude of the moon's ascending node
//                 in radians at date tjd (out)

const
    rev = 1296000;
    SavedOmega : extended = 0.0;
    tlast : extended = 0.0;

begin
  if (abs(t-tlast)>1.0e-12) then
    begin

//   compute fundamental arguments in arcseconds

      SavedOmega := ((0.008 * t + 7.455) * t - 482890.539) * t
          + 450160.280  - dmod(5.0*t,1.0) * rev;

//   convert arguments to radians
      SavedOmega := dmod(SavedOmega,rev);
      if (SavedOmega<0) then SavedOmega := SavedOmega + rev;
      SavedOmega := SavedOmega*OneArcSec;

      tlast := t

    end;

  Omega  := SavedOmega;

end;

procedure nod (const tjd : extended; var DelPsi, DelEps : extended);
{Note: Kaplan passes "t" in centuries and evaluates using a long series}
//        tjd    := tdb time in julian days (in)
//        DelPsi := nutation in longitude in arcseconds (out)
//        DelEps := nutation in obliquity in arcseconds (out)
var
  JPL_Result : TEphemerisOutput;

begin
  ReadEphemeris(tjd,Nutations,DontCare,PositionsOnly,KM_sec,JPL_Result);
  DelEps := JPL_Result.d_eps/OneArcSec;
  DelPsi := JPL_Result.d_psi/OneArcSec;
end;

procedure nod1 (const t : extended; var dpsi,deps : extended);

//   subroutine nod version 1.
//   this subroutine evaluates the nutation series and returns the
//   values for nutation in longitude and nutation in obliquity.
//   wahr nutation series for axis b for gilbert & dziewonski earth
//   model 1066a.  see seidelmann (1982) celestial mechanics 27,
//   79-106.  1980 iau theory of nutation.

//        t    := tdb time in julian centuries since j2000.0 (in)
//        dpsi := nutation in longitude in arcseconds (out)
//        deps := nutation in obliquity in arcseconds (out)

var
  l,lp,f,d,om,arg : extended;
  i, j : integer;
  x : array[1..9,1..106] of extended;

//***********************************************************************

const
//   table of multiples of arguments and coefficients
{each of the 9 columns is a list of 106 coefficients, reading from top to bottom}
{the values in this table are the same as in the official IAU routine, but they
 have been sorted by descending magnitude in column 6.  The exact order of summation
 appears not to matter}
//                 multiple of            longitude        obliquity
//            l    l'   f    d  omega   coeff. of sin    coeff. of cos
  x1 : array[1..90] of extended =
             ( 0.,  0.,  0.,  0.,  1., -171996., -174.2,  92025.,  8.9,
               0.,  0.,  2., -2.,  2.,  -13187.,   -1.6,   5736., -3.1,
               0.,  0.,  2.,  0.,  2.,   -2274.,   -0.2,    977., -0.5,
               0.,  0.,  0.,  0.,  2.,    2062.,    0.2,   -895.,  0.5,
               0.,  1.,  0.,  0.,  0.,    1426.,   -3.4,     54., -0.1,
               1.,  0.,  0.,  0.,  0.,     712.,    0.1,     -7.,  0.0,
               0.,  1.,  2., -2.,  2.,    -517.,    1.2,    224., -0.6,
               0.,  0.,  2.,  0.,  1.,    -386.,   -0.4,    200.,  0.0,
               1.,  0.,  2.,  0.,  2.,    -301.,    0.0,    129., -0.1,
               0., -1.,  2., -2.,  2.,     217.,   -0.5,    -95.,  0.3);
  x2 : array[1..90] of extended =
             ( 1.,  0.,  0., -2.,  0.,    -158.,    0.0,     -1.,  0.0,
               0.,  0.,  2., -2.,  1.,     129.,    0.1,    -70.,  0.0,
              -1.,  0.,  2.,  0.,  2.,     123.,    0.0,    -53.,  0.0,
               1.,  0.,  0.,  0.,  1.,      63.,    0.1,    -33.,  0.0,
               0.,  0.,  0.,  2.,  0.,      63.,    0.0,     -2.,  0.0,
              -1.,  0.,  2.,  2.,  2.,     -59.,    0.0,     26.,  0.0,
              -1.,  0.,  0.,  0.,  1.,     -58.,   -0.1,     32.,  0.0,
               1.,  0.,  2.,  0.,  1.,     -51.,    0.0,     27.,  0.0,
               2.,  0.,  0., -2.,  0.,      48.,    0.0,      1.,  0.0,
              -2.,  0.,  2.,  0.,  1.,      46.,    0.0,    -24.,  0.0);
  x3 : array[1..90] of extended =
             ( 0.,  0.,  2.,  2.,  2.,     -38.,    0.0,     16.,  0.0,
               2.,  0.,  2.,  0.,  2.,     -31.,    0.0,     13.,  0.0,
               2.,  0.,  0.,  0.,  0.,      29.,    0.0,     -1.,  0.0,
               1.,  0.,  2., -2.,  2.,      29.,    0.0,    -12.,  0.0,
               0.,  0.,  2.,  0.,  0.,      26.,    0.0,     -1.,  0.0,
               0.,  0.,  2., -2.,  0.,     -22.,    0.0,      0.,  0.0,
              -1.,  0.,  2.,  0.,  1.,      21.,    0.0,    -10.,  0.0,
               0.,  2.,  0.,  0.,  0.,      17.,   -0.1,      0.,  0.0,
               0.,  2.,  2., -2.,  2.,     -16.,    0.1,      7.,  0.0,
              -1.,  0.,  0.,  2.,  1.,      16.,    0.0,     -8.,  0.0);
  x4 : array[1..90] of extended =
             ( 0.,  1.,  0.,  0.,  1.,     -15.,    0.0,      9.,  0.0,
               1.,  0.,  0., -2.,  1.,     -13.,    0.0,      7.,  0.0,
               0., -1.,  0.,  0.,  1.,     -12.,    0.0,      6.,  0.0,
               2.,  0., -2.,  0.,  0.,      11.,    0.0,      0.,  0.0,
              -1.,  0.,  2.,  2.,  1.,     -10.,    0.0,      5.,  0.0,
               1.,  0.,  2.,  2.,  2.,      -8.,    0.0,      3.,  0.0,
               0., -1.,  2.,  0.,  2.,      -7.,    0.0,      3.,  0.0,
               0.,  0.,  2.,  2.,  1.,      -7.,    0.0,      3.,  0.0,
               1.,  1.,  0., -2.,  0.,      -7.,    0.0,      0.,  0.0,
               0.,  1.,  2.,  0.,  2.,       7.,    0.0,     -3.,  0.0);
  x5 : array[1..90] of extended =
             (-2.,  0.,  0.,  2.,  1.,      -6.,    0.0,      3.,  0.0,
               0.,  0.,  0.,  2.,  1.,      -6.,    0.0,      3.,  0.0,
               2.,  0.,  2., -2.,  2.,       6.,    0.0,     -3.,  0.0,
               1.,  0.,  0.,  2.,  0.,       6.,    0.0,      0.,  0.0,
               1.,  0.,  2., -2.,  1.,       6.,    0.0,     -3.,  0.0,
               0.,  0.,  0., -2.,  1.,      -5.,    0.0,      3.,  0.0,
               0., -1.,  2., -2.,  1.,      -5.,    0.0,      3.,  0.0,
               2.,  0.,  2.,  0.,  1.,      -5.,    0.0,      3.,  0.0,
               1., -1.,  0.,  0.,  0.,       5.,    0.0,      0.,  0.0,
               1.,  0.,  0., -1.,  0.,      -4.,    0.0,      0.,  0.0);
  x6 : array[1..90] of extended =
             ( 0.,  0.,  0.,  1.,  0.,      -4.,    0.0,      0.,  0.0,
               0.,  1.,  0., -2.,  0.,      -4.,    0.0,      0.,  0.0,
               1.,  0., -2.,  0.,  0.,       4.,    0.0,      0.,  0.0,
               2.,  0.,  0., -2.,  1.,       4.,    0.0,     -2.,  0.0,
               0.,  1.,  2., -2.,  1.,       4.,    0.0,     -2.,  0.0,
               1.,  1.,  0.,  0.,  0.,      -3.,    0.0,      0.,  0.0,
               1., -1.,  0., -1.,  0.,      -3.,    0.0,      0.,  0.0,
              -1., -1.,  2.,  2.,  2.,      -3.,    0.0,      1.,  0.0,
               0., -1.,  2.,  2.,  2.,      -3.,    0.0,      1.,  0.0,
               1., -1.,  2.,  0.,  2.,      -3.,    0.0,      1.,  0.0);
  x7 : array[1..90] of extended =
             ( 3.,  0.,  2.,  0.,  2.,      -3.,    0.0,      1.,  0.0,
              -2.,  0.,  2.,  0.,  2.,      -3.,    0.0,      1.,  0.0,
               1.,  0.,  2.,  0.,  0.,       3.,    0.0,      0.,  0.0,
              -1.,  0.,  2.,  4.,  2.,      -2.,    0.0,      1.,  0.0,
               1.,  0.,  0.,  0.,  2.,      -2.,    0.0,      1.,  0.0,
              -1.,  0.,  2., -2.,  1.,      -2.,    0.0,      1.,  0.0,
               0., -2.,  2., -2.,  1.,      -2.,    0.0,      1.,  0.0,
              -2.,  0.,  0.,  0.,  1.,      -2.,    0.0,      1.,  0.0,
               2.,  0.,  0.,  0.,  1.,       2.,    0.0,     -1.,  0.0,
               3.,  0.,  0.,  0.,  0.,       2.,    0.0,      0.,  0.0);
  x8 : array[1..90] of extended =
             ( 1.,  1.,  2.,  0.,  2.,       2.,    0.0,     -1.,  0.0,
               0.,  0.,  2.,  1.,  2.,       2.,    0.0,     -1.,  0.0,
               1.,  0.,  0.,  2.,  1.,      -1.,    0.0,      0.,  0.0,
               1.,  0.,  2.,  2.,  1.,      -1.,    0.0,      1.,  0.0,
               1.,  1.,  0., -2.,  1.,      -1.,    0.0,      0.,  0.0,
               0.,  1.,  0.,  2.,  0.,      -1.,    0.0,      0.,  0.0,
               0.,  1.,  2., -2.,  0.,      -1.,    0.0,      0.,  0.0,
               0.,  1., -2.,  2.,  0.,      -1.,    0.0,      0.,  0.0,
               1.,  0., -2.,  2.,  0.,      -1.,    0.0,      0.,  0.0,
               1.,  0., -2., -2.,  0.,      -1.,    0.0,      0.,  0.0);
  x9 : array[1..90] of extended =
             ( 1.,  0.,  2., -2.,  0.,      -1.,    0.0,      0.,  0.0,
               1.,  0.,  0., -4.,  0.,      -1.,    0.0,      0.,  0.0,
               2.,  0.,  0., -4.,  0.,      -1.,    0.0,      0.,  0.0,
               0.,  0.,  2.,  4.,  2.,      -1.,    0.0,      0.,  0.0,
               0.,  0.,  2., -1.,  2.,      -1.,    0.0,      0.,  0.0,
              -2.,  0.,  2.,  4.,  2.,      -1.,    0.0,      1.,  0.0,
               2.,  0.,  2.,  2.,  2.,      -1.,    0.0,      0.,  0.0,
               0., -1.,  2.,  0.,  1.,      -1.,    0.0,      0.,  0.0,
               0.,  0., -2.,  0.,  1.,      -1.,    0.0,      0.,  0.0,
               0.,  0.,  4., -2.,  2.,       1.,    0.0,      0.,  0.0);
  xa : array[1..90] of extended =
             ( 0.,  1.,  0.,  0.,  2.,       1.,    0.0,      0.,  0.0,
               1.,  1.,  2., -2.,  2.,       1.,    0.0,     -1.,  0.0,
               3.,  0.,  2., -2.,  2.,       1.,    0.0,      0.,  0.0,
              -2.,  0.,  2.,  2.,  2.,       1.,    0.0,     -1.,  0.0,
              -1.,  0.,  0.,  0.,  2.,       1.,    0.0,     -1.,  0.0,
               0.,  0., -2.,  2.,  1.,       1.,    0.0,      0.,  0.0,
               0.,  1.,  2.,  0.,  1.,       1.,    0.0,      0.,  0.0,
              -1.,  0.,  4.,  0.,  2.,       1.,    0.0,      0.,  0.0,
               2.,  1.,  0., -2.,  0.,       1.,    0.0,      0.,  0.0,
               2.,  0.,  0.,  2.,  0.,       1.,    0.0,      0.,  0.0);
  xb : array[1..54] of extended =
             ( 2.,  0.,  2., -2.,  1.,       1.,    0.0,     -1.,  0.0,
               2.,  0., -2.,  0.,  1.,       1.,    0.0,      0.,  0.0,
               1., -1.,  0., -2.,  0.,       1.,    0.0,      0.,  0.0,
              -1.,  0.,  0.,  1.,  1.,       1.,    0.0,      0.,  0.0,
              -1., -1.,  0.,  2.,  1.,       1.,    0.0,      0.,  0.0,
               0.,  1.,  0.,  1.,  0.,       1.,    0.0,      0.,  0.0);

//***********************************************************************

begin
//   get fundamental arguments

      funarg (t,l,lp,f,d,om);

//   sum nutation series terms, from smallest to largest

      dpsi := 0.;
      deps := 0.;

      for i := 1 to 9 do
        begin {collect 106 values}
          for j := 1 to 10 do
            begin {take 10 values each from x1 .. xa}
              x[i,j]    := x1[(j-1)*9+i];
              x[i,j+10] := x2[(j-1)*9+i];
              x[i,j+20] := x3[(j-1)*9+i];
              x[i,j+30] := x4[(j-1)*9+i];
              x[i,j+40] := x5[(j-1)*9+i];
              x[i,j+50] := x6[(j-1)*9+i];
              x[i,j+60] := x7[(j-1)*9+i];
              x[i,j+70] := x8[(j-1)*9+i];
              x[i,j+80] := x9[(j-1)*9+i];
              x[i,j+90] := xa[(j-1)*9+i];
            end;
          for j := 1 to 6 do
            begin {take 6 values from xb}
              x[i,j+100]    := xb[(j-1)*9+i];
            end;
        end;

      for j:=1 to 106 do
        begin
          i := 107 - j;
    //   formation of multiples of arguments
          arg := x[1,i] * l
               + x[2,i] * lp
               + x[3,i] * f
               + x[4,i] * d
               + x[5,i] * om;
    //   evaluate nutation
          dpsi := (x[6,i] + x[7,i]*t) * sin(arg) + dpsi;
          deps := (x[8,i] + x[9,i]*t) * cos(arg) + deps;
        end;


      dpsi := dpsi * 1.0e-4;
      deps := deps * 1.0e-4;

//***********************************************************************

end;

procedure nod2 (const t : extended; var dpsi,deps : extended);
{this is the same as Kaplan's nod1 but it uses the table of coefficients from the IAU,
 which Kaplan apparently sorted}
//   subroutine nod version 2.
//   this subroutine evaluates the nutation series and returns the
//   values for nutation in longitude and nutation in obliquity.
//   wahr nutation series for axis b for gilbert & dziewonski earth
//   model 1066a.  see seidelmann (1982) celestial mechanics 27,
//   79-106.  1980 iau theory of nutation.

//        t    := tdb time in julian centuries since j2000.0 (in)
//        dpsi := nutation in longitude in arcseconds (out)
//        deps := nutation in obliquity in arcseconds (out)

var
  l,lp,f,d,om,arg, tm : extended;
  i, j : integer;
  x : array[1..9,1..106] of extended;

//***********************************************************************

const
//   table of multiples of arguments and coefficients
{each of the 9 columns is a list of 106 coefficients, reading from top to bottom}
{the values in columns 7 and 9 are a factor of ten larger than Kaplan's because
 the time argument by which they will be multiplied is reduced by the same factor}

//                 multiple of            longitude        obliquity
//            l    l'   f    d  omega   coeff. of sin    coeff. of cos
  x1 : array[1..90] of extended =
          ( 0.,  0.,  0.,  0.,  1., -171996., -1742.,  92025.,  89.,
            0.,  0.,  0.,  0.,  2.,    2062.,     2.,   -895.,   5.,
           -2.,  0.,  2.,  0.,  1.,      46.,     0.,    -24.,   0.,
            2.,  0., -2.,  0.,  0.,      11.,     0.,      0.,   0.,
           -2.,  0.,  2.,  0.,  2.,      -3.,     0.,      1.,   0.,
            1., -1.,  0., -1.,  0.,      -3.,     0.,      0.,   0.,
            0., -2.,  2., -2.,  1.,      -2.,     0.,      1.,   0.,
            2.,  0., -2.,  0.,  1.,       1.,     0.,      0.,   0.,
            0.,  0.,  2., -2.,  2.,  -13187.,   -16.,   5736., -31.,
            0.,  1.,  0.,  0.,  0.,    1426.,   -34.,     54.,  -1. );
  x2 : array[1..90] of extended =
          ( 0.,  1.,  2., -2.,  2.,    -517.,    12.,    224.,  -6.,
            0., -1.,  2., -2.,  2.,     217.,    -5.,    -95.,   3.,
            0.,  0.,  2., -2.,  1.,     129.,     1.,    -70.,   0.,
            2.,  0.,  0., -2.,  0.,      48.,     0.,      1.,   0.,
            0.,  0.,  2., -2.,  0.,     -22.,     0.,      0.,   0.,
            0.,  2.,  0.,  0.,  0.,      17.,    -1.,      0.,   0.,
            0.,  1.,  0.,  0.,  1.,     -15.,     0.,      9.,   0.,
            0.,  2.,  2., -2.,  2.,     -16.,     1.,      7.,   0.,
            0., -1.,  0.,  0.,  1.,     -12.,     0.,      6.,   0.,
           -2.,  0.,  0.,  2.,  1.,      -6.,     0.,      3.,   0. );
  x3 : array[1..90] of extended =
          ( 0., -1.,  2., -2.,  1.,      -5.,     0.,      3.,   0.,
            2.,  0.,  0., -2.,  1.,       4.,     0.,     -2.,   0.,
            0.,  1.,  2., -2.,  1.,       4.,     0.,     -2.,   0.,
            1.,  0.,  0., -1.,  0.,      -4.,     0.,      0.,   0.,
            2.,  1.,  0., -2.,  0.,       1.,     0.,      0.,   0.,
            0.,  0., -2.,  2.,  1.,       1.,     0.,      0.,   0.,
            0.,  1., -2.,  2.,  0.,      -1.,     0.,      0.,   0.,
            0.,  1.,  0.,  0.,  2.,       1.,     0.,      0.,   0.,
           -1.,  0.,  0.,  1.,  1.,       1.,     0.,      0.,   0.,
            0.,  1.,  2., -2.,  0.,      -1.,     0.,      0.,   0. );
  x4 : array[1..90] of extended =
          ( 0.,  0.,  2.,  0.,  2.,   -2274.,    -2.,    977.,  -5.,
            1.,  0.,  0.,  0.,  0.,     712.,     1.,     -7.,   0.,
            0.,  0.,  2.,  0.,  1.,    -386.,    -4.,    200.,   0.,
            1.,  0.,  2.,  0.,  2.,    -301.,     0.,    129.,  -1.,
            1.,  0.,  0., -2.,  0.,    -158.,     0.,     -1.,   0.,
           -1.,  0.,  2.,  0.,  2.,     123.,     0.,    -53.,   0.,
            0.,  0.,  0.,  2.,  0.,      63.,     0.,     -2.,   0.,
            1.,  0.,  0.,  0.,  1.,      63.,     1.,    -33.,   0.,
           -1.,  0.,  0.,  0.,  1.,     -58.,    -1.,     32.,   0.,
           -1.,  0.,  2.,  2.,  2.,     -59.,     0.,     26.,   0. );
  x5 : array[1..90] of extended =
          ( 1.,  0.,  2.,  0.,  1.,     -51.,     0.,     27.,   0.,
            0.,  0.,  2.,  2.,  2.,     -38.,     0.,     16.,   0.,
            2.,  0.,  0.,  0.,  0.,      29.,     0.,     -1.,   0.,
            1.,  0.,  2., -2.,  2.,      29.,     0.,    -12.,   0.,
            2.,  0.,  2.,  0.,  2.,     -31.,     0.,     13.,   0.,
            0.,  0.,  2.,  0.,  0.,      26.,     0.,     -1.,   0.,
           -1.,  0.,  2.,  0.,  1.,      21.,     0.,    -10.,   0.,
           -1.,  0.,  0.,  2.,  1.,      16.,     0.,     -8.,   0.,
            1.,  0.,  0., -2.,  1.,     -13.,     0.,      7.,   0.,
           -1.,  0.,  2.,  2.,  1.,     -10.,     0.,      5.,   0. );
  x6 : array[1..90] of extended =
          ( 1.,  1.,  0., -2.,  0.,      -7.,     0.,      0.,   0.,
            0.,  1.,  2.,  0.,  2.,       7.,     0.,     -3.,   0.,
            0., -1.,  2.,  0.,  2.,      -7.,     0.,      3.,   0.,
            1.,  0.,  2.,  2.,  2.,      -8.,     0.,      3.,   0.,
            1.,  0.,  0.,  2.,  0.,       6.,     0.,      0.,   0.,
            2.,  0.,  2., -2.,  2.,       6.,     0.,     -3.,   0.,
            0.,  0.,  0.,  2.,  1.,      -6.,     0.,      3.,   0.,
            0.,  0.,  2.,  2.,  1.,      -7.,     0.,      3.,   0.,
            1.,  0.,  2., -2.,  1.,       6.,     0.,     -3.,   0.,
            0.,  0.,  0., -2.,  1.,      -5.,     0.,      3.,   0. );
  x7 : array[1..90] of extended =
          ( 1., -1.,  0.,  0.,  0.,       5.,     0.,      0.,   0.,
            2.,  0.,  2.,  0.,  1.,      -5.,     0.,      3.,   0.,
            0.,  1.,  0., -2.,  0.,      -4.,     0.,      0.,   0.,
            1.,  0., -2.,  0.,  0.,       4.,     0.,      0.,   0.,
            0.,  0.,  0.,  1.,  0.,      -4.,     0.,      0.,   0.,
            1.,  1.,  0.,  0.,  0.,      -3.,     0.,      0.,   0.,
            1.,  0.,  2.,  0.,  0.,       3.,     0.,      0.,   0.,
            1., -1.,  2.,  0.,  2.,      -3.,     0.,      1.,   0.,
           -1., -1.,  2.,  2.,  2.,      -3.,     0.,      1.,   0.,
           -2.,  0.,  0.,  0.,  1.,      -2.,     0.,      1.,   0. );
  x8 : array[1..90] of extended =
          ( 3.,  0.,  2.,  0.,  2.,      -3.,     0.,      1.,   0.,
            0., -1.,  2.,  2.,  2.,      -3.,     0.,      1.,   0.,
            1.,  1.,  2.,  0.,  2.,       2.,     0.,     -1.,   0.,
           -1.,  0.,  2., -2.,  1.,      -2.,     0.,      1.,   0.,
            2.,  0.,  0.,  0.,  1.,       2.,     0.,     -1.,   0.,
            1.,  0.,  0.,  0.,  2.,      -2.,     0.,      1.,   0.,
            3.,  0.,  0.,  0.,  0.,       2.,     0.,      0.,   0.,
            0.,  0.,  2.,  1.,  2.,       2.,     0.,     -1.,   0.,
           -1.,  0.,  0.,  0.,  2.,       1.,     0.,     -1.,   0.,
            1.,  0.,  0., -4.,  0.,      -1.,     0.,      0.,   0. );
  x9 : array[1..90] of extended =
         ( -2.,  0.,  2.,  2.,  2.,       1.,     0.,     -1.,   0.,
           -1.,  0.,  2.,  4.,  2.,      -2.,     0.,      1.,   0.,
            2.,  0.,  0., -4.,  0.,      -1.,     0.,      0.,   0.,
            1.,  1.,  2., -2.,  2.,       1.,     0.,     -1.,   0.,
            1.,  0.,  2.,  2.,  1.,      -1.,     0.,      1.,   0.,
           -2.,  0.,  2.,  4.,  2.,      -1.,     0.,      1.,   0.,
           -1.,  0.,  4.,  0.,  2.,       1.,     0.,      0.,   0.,
            1., -1.,  0., -2.,  0.,       1.,     0.,      0.,   0.,
            2.,  0.,  2., -2.,  1.,       1.,     0.,     -1.,   0.,
            2.,  0.,  2.,  2.,  2.,      -1.,     0.,      0.,   0. );
  xa : array[1..90] of extended =
          ( 1.,  0.,  0.,  2.,  1.,      -1.,     0.,      0.,   0.,
            0.,  0.,  4., -2.,  2.,       1.,     0.,      0.,   0.,
            3.,  0.,  2., -2.,  2.,       1.,     0.,      0.,   0.,
            1.,  0.,  2., -2.,  0.,      -1.,     0.,      0.,   0.,
            0.,  1.,  2.,  0.,  1.,       1.,     0.,      0.,   0.,
           -1., -1.,  0.,  2.,  1.,       1.,     0.,      0.,   0.,
            0.,  0., -2.,  0.,  1.,      -1.,     0.,      0.,   0.,
            0.,  0.,  2., -1.,  2.,      -1.,     0.,      0.,   0.,
            0.,  1.,  0.,  2.,  0.,      -1.,     0.,      0.,   0.,
            1.,  0., -2., -2.,  0.,      -1.,     0.,      0.,   0. );
  xb : array[1..54] of extended =
          ( 0., -1.,  2.,  0.,  1.,      -1.,     0.,      0.,   0.,
            1.,  1.,  0., -2.,  1.,      -1.,     0.,      0.,   0.,
            1.,  0., -2.,  2.,  0.,      -1.,     0.,      0.,   0.,
            2.,  0.,  0.,  2.,  0.,       1.,     0.,      0.,   0.,
            0.,  0.,  2.,  4.,  2.,      -1.,     0.,      0.,   0.,
            0.,  1.,  0.,  1.,  0.,       1.,     0.,      0.,   0. );

//***********************************************************************

begin
//   get fundamental arguments

      funarg (t,l,lp,f,d,om);

//   sum nutation series terms, from smallest to largest

      dpsi := 0.;
      deps := 0.;

      for i := 1 to 9 do
        begin {collect 106 values}
          for j := 1 to 10 do
            begin {take 10 values each from x1 .. xa}
              x[i,j]    := x1[(j-1)*9+i];
              x[i,j+10] := x2[(j-1)*9+i];
              x[i,j+20] := x3[(j-1)*9+i];
              x[i,j+30] := x4[(j-1)*9+i];
              x[i,j+40] := x5[(j-1)*9+i];
              x[i,j+50] := x6[(j-1)*9+i];
              x[i,j+60] := x7[(j-1)*9+i];
              x[i,j+70] := x8[(j-1)*9+i];
              x[i,j+80] := x9[(j-1)*9+i];
              x[i,j+90] := xa[(j-1)*9+i];
            end;
          for j := 1 to 6 do
            begin {take 6 values from xb}
              x[i,j+100]    := xb[(j-1)*9+i];
            end;
        end;

//Change time argument from centuries to millennia.
      tm := t / 10;

      for j:=1 to 106 do
        begin
          i := 107 - j;
    //   formation of multiples of arguments
          arg := x[1,i] * l
               + x[2,i] * lp
               + x[3,i] * f
               + x[4,i] * d
               + x[5,i] * om;
    //   evaluate nutation
          dpsi := (x[6,i] + x[7,i]*tm) * sin(arg) + dpsi;
          deps := (x[8,i] + x[9,i]*tm) * cos(arg) + deps;
        end;


//  Convert results from 0.1 mas units to radians.
      dpsi := dpsi * 1.0e-4;
      deps := deps * 1.0e-4;


//***********************************************************************

end;

procedure celpol (const ddpsi,ddeps : extended);
//   this entry allows for the specification of celestial pole
//   offsets for high-precision applications.  these are added
//   to the nutation parameters delta psi and delta epsilon.
//   daily values of the offsets are published, for example,
//   in iers bulletins a and b.  this entry, if used, should
//   be called before any other routines for a given date.
//   values of the pole offsets specified via a call to this
//   entry will be used until explicitly changed.

//        ddpsi  := value of offset in delta psi (dpsi)
//                 in arcseconds (in)
//        ddeps  := value of offset in delta epsilon (deps)
//                 in arcseconds (in)
begin
  psicor := ddpsi;  {update global constants otherwise initialized to zero}
  epscor := ddeps;
end;

procedure etilt (const tjd : extended; var oblm,oblt,eqeq,dpsi,deps : extended);

//   this subroutine computes quantities related to the orientation
//   of the earth's rotation axis at julian date tjd.
//   implements equation of the equinoxes definition as per
//   iau resolution c7 of 1994.

//        tjd    := tdb julian date for orientation parameters (in)
//        oblm   := mean obliquity of the ecliptic in degrees at
//                 date tjd (out)
//        oblt   := true obliquity of the ecliptic in degrees at
//                 date tjd (out)
//        eqeq   := equation of the equinoxes in time seconds at
//                 date tjd (out)
//        dpsi   := nutation in longitude in arcseconds at
//                 date tjd (out)
//        deps   := nutation in obliquity in arcseconds at
//                 date tjd (out)

const
  t0 = JD2000; {t0 := tdb julian date of epoch j2000.0}
  tlast  : extended = 0.0;
  delpsi : extended = 0.0;
  deleps : extended = 0.0;
  omega  : extended = 0.0;

var
  t,t2,t3,obm,obt,ee,
  psi,eps  : extended;

begin
    t := (tjd - t0) / DaysPerCentury;
    t2 := t * t;
    t3 := t2 * t;

//   obtain nutation parameters in arcseconds
    if (abs(tjd-tlast)>1.0e-8) then
      begin
        FunargOmega(t,omega);    {omega is in radians;  Kaplan evaluates other
          parameters not needed here with call to "funarg"}
     {Note: Kaplan passes parameter "t" [Centuries] to "nod1" for evaluation by
       series}
//        nod1(t,delpsi,deleps);
     {alternative is to pass "tjd" [ephemeris day] for look up in JPL Ephemeris}
        nod(tjd,delpsi,deleps);   {<-- JPL lookup should be faster than long series}
     {in either case delpsi & deleps are in arcseconds}
        tlast := tjd;
      end;
    psi := delpsi + psicor;
    eps := deleps + epscor;

//   compute mean obliquity of the ecliptic in arcseconds
    obm := 84381.4480 - 46.8150*t - 0.00059*t2
        + 0.001813*t3;

//   compute true obliquity of the ecliptic in arcseconds
    obt := obm + eps;

//   compute equation of the equinoxes in arcseconds, time seconds
//   (iau 1994 and iers 1996 definition)
    ee := psi * cos (obm*OneArcSec)
         + 0.00264 * sin(omega) + 0.000063 * sin(2.*omega);
    ee := ee / 15;

//   convert obliquity values to degrees
    obm := obm *OneArcSec/OneDegree;
    obt := obt *OneArcSec/OneDegree;

    oblm := obm;
    oblt := obt;
    eqeq := ee;
    dpsi := psi;
    deps := eps;
end;

procedure sidtim (const tjdh,tjdl : extended; const k : integer; var gst : extended);

//   this subroutine computes the greenwich sidereal time
//   (either mean or apparent) at julian date tjdh + tjdl.
//   see aoki, et al. (1982) astronomy and astropysics 105, 359-361.

//        tjdh   := julian date, high-order part (in)
//        tjdl   := julian date, low-order part (in)
//                 julian date may be split at any point, but
//                 for highest precision, set tjdh to be the integral
//                 part of the julian date, and set tjdl to be the
//                 fractional part
//        k      := time selection code (in)
//                 set k:=0 for greenwich mean sidereal time
//                 set k:=1 for greenwich apparent sidereal time
//        gst    := greenwich (mean or apparent) sidereal time
//                 in hours (out)

//   note:  for most applications, basis for input julian date should
//   be ut1, which results in ordinary sidereal time output in gst.
//   use of input julian date based on tdb results in 'dynamical
//   sidereal time'.

const
  t0 = JD2000;  {tdb julian date of epoch j2000.0}
var
  tjd,th,tl,t,t2,t3,x,eqeq,st : extended;


begin
  tjd := tjdh + tjdl;
  th := (tjdh - t0) / DaysPerCentury;
  tl :=  tjdl       / DaysPerCentury;
  t := th + tl;
  t2 := t * t;
  t3 := t2 * t;

//   for apparent sidereal time, obtain equation of the equinoxes
  eqeq := 0.0;
  if (k=1) then etilt (tjd,x,x,eqeq,x,x);

  st := eqeq - 6.2e-6*t3 + 0.093104*t2 + 67310.54841
     + 8640184.812866 *tl
     + 3155760000.0   *tl
     + 8640184.812866 *th
     + 3155760000.0   *th;

  gst := dmod (st / 3600.0, 24.0);
  if (gst<0.0) then gst := gst + 24.0;

end;

procedure times (const tdbjd : extended; var ttjd,secdif :extended);

//   this subroutine computes the terrestrial time (tt) julian date
//   corresponding to a barycentric dynamical time (tdb) julian date.
//   expressions used in this version are approximations resulting
//   in accuracies of about 20 microseconds.  see explanatory
//   supplement to the astronomical almanac, pp. 42-44 and 316.

//        tdbjd  := tdb julian date (in)
//        ttjd   := tt julian date (out)
//        secdif := difference tdbjd-ttjd, in seconds (out)

const
  rev = 1296000;
  t0 = JD2000;  {t0 := tdb julian date of epoch j2000.0}
  ecc = 0.01671022;  {ecc := eccentricity of earth-moon barycenter orbit}

var
  tdays,m,l,lj,e : extended;

begin
  tdays := tdbjd - t0;
  m  := ( 357.51716 + 0.985599987 * tdays ) * 3600.;
  l  := ( 280.46435 + 0.985609100 * tdays ) * 3600.;
  lj := (  34.40438 + 0.083086762 * tdays ) * 3600.;
  m  := dmod (  m, rev ) / seccon;
  l  := dmod (  l, rev ) / seccon;
  lj := dmod ( lj, rev ) / seccon;
  e  := m + ecc * sin ( m ) + 0.5 * sqr(ecc) * sin ( 2. * m );
  secdif :=   1.658e-3 * sin ( e ) + 20.73e-6 * sin ( l - lj );
  ttjd := tdbjd - secdif / 86400.;
end;


procedure geocen (const pos1,pe : TVector; var pos2 : TVector; var tlight : extended);

//   this subroutine moves the origin of coordinates from the
//   barycenter of the solar system to the center of mass of the
//   earth, i.e., this subroutine corrects for parallax.

//        pos1   := position vector, referred to origin at solar system
//                 barycenter, components in au (in)
//        pe     := position vector of center of mass of the earth,
//                 referred to origin at solar system barycenter,
//                 components in au (in)
//        pos2   := position vector, referred to origin at center of
//                 mass of the earth, components in au (out)
//        tlight := light time from body to earth in days (out)

const
  c = 173.14463348; {c := speed of light in au/day}
begin
  VectorDifference(pos1,pe,pos2);
  tlight := VectorMagnitude(pos2) / c;
end;

procedure sunfld (const pos1,pe : TVector; var pos2 : TVector);

//   subroutine sunfld version 1.
//   this subroutine corrects position vector for the deflection
//   of light in the gravitational field of the sun.  see misner,
//   thorne, and wheeler (1973), gravitation, pp. 184-185.  this
//   subroutine valid for bodies within the solar system as well as
//   for stars.

//        pos1 := position vector, referred to origin at center of mass
//               of the earth, components in au (in)
//        pe   := position vector of center of mass of the earth,
//               referred to origin at center of mass of
//               the sun, components in au (in)
//        pos2 := position vector, referred to origin at center of mass
//               of the earth, corrected for gravitational deflec-
//               tion, components in au (out)

const
  mau = 1.49597870e11;  {number of meters per au}
  gs  = 1.32712438e20;  {heliocentric gravitational constant}
  c   = 299792458.0;    {speed of light}

var
  p1hat,pehat : TVector;
  j : TVectorIndex;
  p1mag,pemag,f,
  cosd,sind,b,bm,pqmag,zfinl,zinit,xifinl,xiinit,
  delphi,delphp,delp : extended;

begin
//   compute vector magnitudes and unit vectors
  p1mag := VectorMagnitude(pos1);
  pemag := VectorMagnitude(pe);
  p1hat := pos1;
  pehat := pe;
  MultiplyVector(1/p1mag,p1hat);
  MultiplyVector(1/pemag,pehat);

//   compute geometrical quantities
//   cosd and sind are cosine and sine of d, the angular separation
//   of the body from the sun as viewed from the earth
  cosd := - DotProduct(pehat,p1hat);
  if (abs(cosd)>0.9999999999) then
    begin
      pos2 := pos1;
    end
  else
    begin
      sind := Sqrt (1.0 - sqr(cosd));
    //   b is the impact parameter for the ray
      b := pemag * sind;
      bm := b * mau;
    //   pqmag is the distance of the body from the sun
      pqmag := Sqrt (sqr(p1mag) + sqr(pemag) - 2.0 * p1mag * pemag * cosd);

    //   compute delphi, the angle of deflection of the ray
      zfinl := pemag * cosd;
      zinit := -p1mag + zfinl;
      xifinl := zfinl / b;
      xiinit := zinit / b;
      delphi := 2.0*gs/(bm*c*c) * (xifinl / Sqrt (1.0 + sqr(xifinl))
                                 - xiinit / Sqrt (1.0 + sqr(xiinit)));

    //   compute delphp, the change in angle as seen at the earth
      delphp := delphi / (1.0 + (pemag / pqmag));

    //   fix up position vector
    //   pos2 is pos1 rotated through angle delphp in plane defined
    //   by pos1 and pe
      f := delphp * p1mag / sind;

      for j := X to Z do
        begin
          delp := f * (cosd * p1hat[j] + pehat[j]);
          pos2[j] := pos1[j] + delp;
       end;

    end;

end;


procedure aberat (const pos1,ve : TVector; const tlight : extended; var pos2 : TVector);

//   this subroutine corrects position vector for aberration of light.
//   algorithm includes relativistic terms.  see murray (1981)
//   mon. notices royal ast. society 195, 639-648.

//        pos1   := position vector, referred to origin at center of
//                 mass of the earth, components in au (in)
//        ve     := velocity vector of center of mass of the earth,
//                 referred to origin at solar system barycenter,
//                 components in au/day (in)
//        tlight := light time from body to earth in days (in)
//                 if tlight := 0.0, this subroutine will compute
//        pos2   := position vector, referred to origin at center of
//                 mass of the earth, corrected for aberration,
//                 components in au (out)

const
  c = 173.14463348;  {speed of light in au/day}
var
  j : TVectorIndex;
  tl,p1mag,vemag,beta,dot,cosd,gammai,p,q,r : extended;

begin
  tl := tlight;
  p1mag := tl * c;
  if (tl=0.0) then
    begin
      p1mag := VectorMagnitude(pos1);
      tl := p1mag / c;
    end;
  vemag := VectorMagnitude(ve);
  beta := vemag / c;
  dot := DotProduct(pos1,ve);
  cosd := dot / (p1mag * vemag);
  gammai := Sqrt(1.0 - sqr(beta));
  p := beta * cosd;
  q := (1.0 + p / (1.0 + gammai)) * tl;
  r := 1.0 + p;

  for j := X to Z do
    pos2[j] := (gammai * pos1[j] + q * ve[j]) / r ;

end;

procedure preces (const tjd1 : extended; const pos1 : TVector; const tjd2 : extended;
  var pos2 : TVector);

//   this subroutine precesses equatorial rectangular coordinates from
//   one epoch to another.  the coordinates are referred to the mean
//   equator and equinox of the two respective epochs.  see
//   explanatory supplement to the astronomical almanac, pp. 103-104,
//   lieske, et al. (1977) astronomy and astrophysics 58, 1-16, and
//   lieske (1979) astronomy and astrophysics 73, 282-284.

//        tjd1 := tdb julian date of first epoch (in)
//        pos1 := position vector, geocentric equatorial rectangular
//               coordinates, referred to mean equator and equinox of
//               first epoch (in)
//        tjd2 := tdb julian date of second epoch (in)
//        pos2 := position vector, geocentric equatorial rectangular
//               coordinates, referred to mean equator and equinox of
//               second epoch (out)

const
  t1last : extended = 0;
  t2last : extended = 0;
  xx : extended = 0;
  yx : extended = 0;
  zx : extended = 0;
  xy : extended = 0;
  yy : extended = 0;
  zy : extended = 0;
  xz : extended = 0;
  yz : extended = 0;
  zz : extended = 0;

var
  t0,t,t02,t2,t3,
  zeta0,zee,theta,czeta0,szeta0,czee,szee,ctheta,stheta : extended;
label  L20, L30;

begin
  if ((abs(tjd1-t2last)<1.0e-8) and (abs(tjd2-t1last)<1.0e-8)) then
    begin
//   perform inverse rotation with existing matrix
      pos2[x] := xx*pos1[x] + xy*pos1[y] + xz*pos1[z];
      pos2[y] := yx*pos1[x] + yy*pos1[y] + yz*pos1[z];
      pos2[z] := zx*pos1[x] + zy*pos1[y] + zz*pos1[z];
      exit;
    end;

  if ((abs(tjd1-t1last)>=1.0e-8) or (abs(tjd2-t2last)>=1.0e-8)) then
    begin {recalculate matrix}
    //   t0 and t below correspond to lieske's big t and little t
    //   time scale is assumed to be tdb
      t0 := (tjd1 - 2451545.00000000) / 36525.0;
      t := (tjd2 - tjd1) / 36525.0;
      t02 := t0 * t0;
      t2 := t * t;
      t3 := t2 * t;
    //   zeta0, zee, and theta below correspond to lieske's zeta-sub-a,
    //   z-sub-a, and theta-sub-a
      zeta0 := (2306.2181 + 1.39656*t0 - 0.000139*t02) * t
           + (0.30188 - 0.000344*t0) * t2
           +  0.017998 * t3;
      zee   := (2306.2181 + 1.39656*t0 - 0.000139*t02) * t
           + (1.09468 + 0.000066*t0) * t2
           +  0.018203 * t3;
      theta := (2004.3109 - 0.85330*t0 - 0.000217*t02) * t
           + (-0.42665 - 0.000217*t0) * t2
           -  0.041833 * t3;
      zeta0 := zeta0 / seccon;
      zee := zee / seccon;
      theta := theta / seccon;
      czeta0 := cos(zeta0);
      szeta0 := sin(zeta0);
      czee := cos(zee);
      szee := sin(zee);
      ctheta := cos(theta);
      stheta := sin(theta);

    //   precession rotation matrix follows
      xx := czeta0*ctheta*czee - szeta0*szee;
      yx := -szeta0*ctheta*czee - czeta0*szee;
      zx := -stheta*czee;
      xy := czeta0*ctheta*szee + szeta0*czee;
      yy := -szeta0*ctheta*szee + czeta0*czee;
      zy := -stheta*szee;
      xz := czeta0*stheta;
      yz := -szeta0*stheta;
      zz := ctheta;
      t1last := tjd1;
      t2last := tjd2;
  end;

//   perform rotation with new or old matrix
  pos2[x] := xx*pos1[x] + yx*pos1[y] + zx*pos1[z];
  pos2[y] := xy*pos1[x] + yy*pos1[y] + zy*pos1[z];
  pos2[z] := xz*pos1[x] + yz*pos1[y] + zz*pos1[z];

end;

procedure nutate (const tjd : extended; const pos1 : TVector; var pos2 : TVector);

//   this subroutine nutates equatorial rectangular coordinates from
//   mean equator and equinox of epoch to true equator and equinox of
//   epoch.  see explanatory supplement to the astronomical almanac,
//   pp. 114-115.

//        tjd    := tdb julian date of epoch (in)
//        pos1   := position vector, geocentric equatorial rectangular
//                 coordinates, referred to mean equator and equinox
//                 of epoch (in)
//        pos2   := position vector, geocentric equatorial rectangular
//                 coordinates, referred to true equator and equinox
//                 of epoch (out)

//   note:  if tjd is negative, inverse nutation (true to mean)
//   is applied.

var
  tjd1,oblm,oblt,eqeq,dpsi,deps,cobm,sobm,cobt,sobt,cpsi,spsi,
  xx,yx,zx,xy,yy,zy,xz,yz,zz : extended;

begin
  tjd1 := abs(tjd);

  etilt(tjd1,oblm,oblt,eqeq,dpsi,deps);
  oblm := oblm * 3600.0 / seccon;
  oblt := oblt * 3600.0 / seccon;
  dpsi := dpsi / seccon;
  deps := deps / seccon;
  cobm := cos(oblm);
  sobm := sin(oblm);
  cobt := cos(oblt);
  sobt := sin(oblt);
  cpsi := cos(dpsi);
  spsi := sin(dpsi);

//   nutation rotation matrix follows
  xx := cpsi;
  yx := -spsi*cobm;
  zx := -spsi*sobm;
  xy := spsi*cobt;
  yy := cpsi*cobm*cobt + sobm*sobt;
  zy := cpsi*sobm*cobt - cobm*sobt;
  xz := spsi*sobt;
  yz := cpsi*cobm*sobt - sobm*cobt;
  zz := cpsi*sobm*sobt + cobm*cobt;

  if (tjd>=0.0) then
    begin
//   perform rotation
      pos2[x] := xx*pos1[x] + yx*pos1[y] + zx*pos1[z];
      pos2[y] := xy*pos1[x] + yy*pos1[y] + zy*pos1[z];
      pos2[z] := xz*pos1[x] + yz*pos1[y] + zz*pos1[z];
    end
  else
    begin
//   perform inverse rotation
      pos2[x] := xx*pos1[x] + xy*pos1[y] + xz*pos1[z];
      pos2[y] := yx*pos1[x] + yy*pos1[y] + yz*pos1[z];
      pos2[z] := zx*pos1[x] + zy*pos1[y] + zz*pos1[z];
    end;
end;

procedure spin (const st : extended; const pos1 : TVector; var pos2 : TVector);

//   this subroutine transforms geocentric rectangular coordinates
//   from rotating system based on rotational equator and orthogonal
//   reference meridian to non-rotating system based on true equator
//   and equinox of date.

//        st     := local apparent sidereal time at reference meridian
//                 in hours (in)
//        pos1   := vector in geocentric rectangular
//                 rotating system, referred to rotational equator
//                 and orthogonal reference meridian (in)
//        pos2   := vector in geocentric rectangular
//                 non-rotating system, referred to true equator
//                 and equinox of date (out)

const
  tlast : extended = -999.0;
  xx : extended = 0;
  yx : extended = 0;
  zx : extended = 0;
  xy : extended = 0;
  yy : extended = 0;
  zy : extended = 0;
  xz : extended = 0;
  yz : extended = 0;
  zz : extended = 0;
var
  str,cosst,sinst : extended;

begin
  if (abs(st-tlast)>=1.0e-12) then
    begin
      str   := st * 15.0 * 3600.0 / seccon;
      cosst := cos(str);
      sinst := sin(str);

//   sidereal time rotation matrix follows
      xx :=  cosst;
      yx := -sinst;
      zx :=  0.0;
      xy :=  sinst;
      yy :=  cosst;
      zy :=  0.0;
      xz :=  0.0;
      yz :=  0.0;
      zz :=  1.0;
      tlast := st;
   end;

//   perform rotation
  pos2[x] := xx*pos1[x] + yx*pos1[y] + zx*pos1[z];
  pos2[y] := xy*pos1[x] + yy*pos1[y] + zy*pos1[z];
  pos2[z] := xz*pos1[x] + yz*pos1[y] + zz*pos1[z];

end;


procedure wobble (const Pole_x,Pole_y : extended; const pos1 : TVector; var pos2 : TVector);

//   this subroutine corrects earth-fixed geocentric rectangular
//   coordinates for polar motion.  it transforms a vector from
//   earth-fixed geographic system to rotating system based on
//   rotational equator and orthogonal greenwich meridian through
//   axis of rotation.

//        Pole_x := conventionally-defined x coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        Pole_y := conventionally-defined y coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        pos1   := vector in geocentric rectangular
//                 earth-fixed system, referred to geographic
//                 equator and greenwich meridian (in)
//        pos2   := vector in geocentric rectangular
//                 rotating system, referred to rotational equator
//                 and orthogonal greenwich meridian (out)

var
  xpole,ypole,xx,yx,zx,xy,yy,zy,xz,yz,zz : extended;

begin

  xpole := Pole_x / seccon;
  ypole := Pole_y / seccon;

//   wobble rotation matrix follows
  xx :=  1.0;
  yx :=  0.0;
  zx := -xpole;
  xy :=  0.0;
  yy :=  1.0;
  zy :=  ypole;
  xz :=  xpole;
  yz := -ypole;
  zz :=  1.0;

//   perform rotation
  pos2[x] := xx*pos1[x] + yx*pos1[y] + zx*pos1[z];
  pos2[y] := xy*pos1[x] + yy*pos1[y] + zy*pos1[z];
  pos2[z] := xz*pos1[x] + yz*pos1[y] + zz*pos1[z];

end;


procedure pnsw (const tjd,gast,Pole_x,Pole_y : extended; const vece : TVector; var vecs : TVector);

//   transforms a vector from earth-fixed system to space-fixed system
//   by applying rotations for wobble, spin, nutation, and precession.
//   (combined rotation is symbolized  p n s w .)   specifically,
//   it transforms a vector from earth-fixed geographic system to
//   space-fixed system based on mean equator and equinox of j2000.0.

//        tjd    := tt julian date (in)
//        gast   := greenwich apparent sidereal time, in hours (in)
//        Pole_x      := conventionally-defined x coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        Pole_y      := conventionally-defined y coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        vece   := vector in geocentric rectangular
//                 earth-fixed system, referred to geographic
//                 equator and greenwich meridian (in)
//        vecs   := vector in geocentric rectangular
//                 space-fixed system, referred to mean equator
//                 and equinox of j2000.0 (out)

//   note:  tjd:=0. means no precession/nutation transformation,
//   gast:=0. means no spin transformation, x:=y:=0. means no
//   wobble transformation.

const
  t0 = JD2000;

var
  t1,z,secdif : extended;
  v1,v2,v3 : TVector;

begin
//   compute t1, the tdb julian date corresponding to tjd
  if (tjd=0.0) then
    begin
      t1 := 0;  {not actually used if tjd=0, but this makes compiler happy}
    end
  else
    begin
      times (tjd,z,secdif);
      t1 := tjd + secdif / 86400.0;
    end;

  if (Pole_x=0) and (Pole_y=0) then
    v1 := vece
  else
    wobble (Pole_x,Pole_y,vece,v1);

  if (gast=0.0) then
    v2 := v1
  else
     spin (gast,v1,v2);

  if (tjd=0.0) then
    vecs := v2
  else
    begin
      nutate (-t1,v2,v3);
      preces (t1,v3,t0,vecs);
    end;

end;

procedure Terra(const glon,glat,ht,st : extended; var pos,vel : TVector);

//    this subroutine computes the position and velocity vectors of
//    a terrestrial observer with respect to the center of the earth.

//         glon   = longitude of observer with respect to reference
//                  meridian (east +) in degrees (in)
//         glat   = geodetic latitude (north +) of observer
//                  in degrees (in)
//         ht     = height of observer in meters (in)
//         st     = local apparent sidereal time at reference meridian
//                  in hours (in)
//         pos    = position vector of observer with respect to center
//                  of earth, equatorial rectangular coordinates,
//                  referred to true equator and equinox of date,
//                  components in au (out)
//         vel    = velocity vector of observer with respect to center
//                  of earth, equatorial rectangular coordinates,
//                  referred to true equator and equinox of date,
//                  components in au/day (out)

//    note:  if reference meridian is greenwich and st=0.d0, pos
//    is effectively referred to equator and greenwich.

const
  erad = 6378.140;   {radius of earth in km}
  f = 0.00335281;    {earth ellipsoid flattening}
  omega = 7.292115e-5;   {rotational angular velocity of earth in radians/sec}

var
  df2,phi,sinphi,cosphi,c,s,ach,ash,stlocl,sinst,cosst : extended;

begin
//    compute parameters relating to geodetic to geocentric conversion
  df2 := Sqr(1.0 - f);
  phi := glat * OneDegree;
  sinphi := sin(phi);
  cosphi := cos(phi);
  c := 1.0 / sqrt ( sqr(cosphi) + df2 * sqr(sinphi) );
  s := df2 * c;
  ach := erad * c + ht/1000.0;
  ash := erad * s + ht/1000.0;

//    compute local sidereal time factors
  stlocl := (st * 54000.0 + glon * 3600.0)*OneArcSec;
  sinst := sin(stlocl);
  cosst := cos(stlocl);

//    compute position vector components in km
  pos[x] := ach * cosphi * cosst;
  pos[y] := ach * cosphi * sinst;
  pos[z] := ash * sinphi;

//    compute velocity vector components in km/sec
  vel[x] := -omega * ach * cosphi * sinst;
  vel[y] :=  omega * ach * cosphi * cosst;
  vel[z] :=  0.0;

//   convert position and velocity components to au and au/day
  MultiplyVector(OneKm/OneAU,Pos);
  MultiplyVector((OneKm/OneAU)*(OneDay/OneSecond),Vel);


end;

procedure zdaz (const ujd,Pole_x,Pole_y,glon,glat,ht,ra,dec : extended; const irefr : integer;
   var zd,az,rar,decr : extended);

//   this subroutine transforms topocentric right ascension and
//   declination to zenith distance and azimuth.  this routine uses
//   a method that properly accounts for polar motion, which is
//   significant at the sub-arcsecond level.  this subroutine
//   can also adjust coordinates for atmospheric refraction.

//        ujd    := UT1 julian date (in)
//        Pole_x      := conventionally-defined x coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        Pole_y      := conventionally-defined y coordinate of celestial
//                 ephemeris pole with respect to iers reference
//                 pole, in arcseconds (in)
//        glon   := geodetic longitude (east +) of observer
//                 in degrees (in)
//        glat   := geodetic latitude (north +) of observer
//                 in degrees (in)
//        ht     := height of observer in meters (in)
//        ra     := topocentric right ascension of object of interest,
//                 in hours, referred to true equator and equinox
//                 of date (in)
//        dec    := topocentric declination of object of interest,
//                 in degrees, referred to true equator and equinox
//                 of date (in)
//        irefr  := atmospheric refraction option (in):
//                 set irefr:=0  for no refraction
//                 set irefr:=1  to include refraction
//        zd     := topocentric zenith distance in degrees,
//                 affected by refraction if irefr:=1 (out)
//        az     := topocentric azimuth (measured east from north)
//                 in degrees (out)
//        rar    := topocentric right ascension of object of interest,
//                 in hours, referred to true equator and equinox
//                 of date, affected by refraction if irefr:=1 (out)
//        decr   := topocentric declination of object of interest,
//                 in degrees, referred to true equator and equinox
//                 of date, affected by refraction if irefr:=1 (out)

//   note 1:  ujd may be specified either as a ut1 julian date
//   (e.g., 2451251.823) or an hour and fraction of greenwich
//   apparent sidereal time (e.g., 19.1846). [NOT implemented here]
//   x and y can be set to zero if sub-arcsecond accuracy is not needed.
//   ht is used only for refraction, if irefr:=1.  ra and dec can
//   be obtained from tpstar or tpplan.

//   note 2:  the directons zd:=0 (zenith) and az:=0 (north) are
//   here considered fixed in the terrestrial frame.  specifically,
//   the zenith is along the geodetic normal, and north is toward
//   the iers reference pole.

//   note 3:  if irefr:=0, then rar:=ra and decr:=dec.

var
  degrad,raddeg,gast, sinlat,coslat,sinlon,coslon,sindc,cosdc,sinra,cosra,
     pz,pn,pw,proj : extended;
  uze, une, uwe, uz, un, uw, p : TVector;

begin
  degrad := pi / 180. ;
  raddeg := 180. / pi ;

  sidtim ( ujd, 0.0, 1,   gast );

  rar    := ra;
  decr   := dec;
  sinlat := sin ( glat * degrad );
  coslat := cos ( glat * degrad );
  sinlon := sin ( glon * degrad );
  coslon := cos ( glon * degrad );
  sindc  := sin ( dec * degrad );
  cosdc  := cos ( dec * degrad );
  sinra  := sin ( ra * 15.0 * degrad );
  cosra  := cos ( ra * 15.0 * degrad );

//--- set up orthonormal basis vectors in local earth-fixed system ----

//   define vector toward local zenith in earth-fixed system (z axis)
  uze[x] :=  coslat * coslon;
  uze[y] :=  coslat * sinlon;
  uze[z] :=  sinlat;

//   define vector toward local north in earth-fixed system (x axis)
  une[x] := -sinlat * coslon;
  une[y] := -sinlat * sinlon;
  une[z] :=  coslat;

//   define vector toward local west in earth-fixed system (y axis)
  uwe[x] :=  sinlon;
  uwe[y] := -coslon;
  uwe[z] :=  0;

//--- obtain vectors in celestial system ------------------------------

//   rotate earth-fixed orthonormal basis vectors to celestial system
//   (wrt equator and equinox of date)
  pnsw ( 0., gast, Pole_x, Pole_y, uze,   uz );
  pnsw ( 0., gast, Pole_x, Pole_y, une,   un );
  pnsw ( 0., gast, Pole_x, Pole_y, uwe,   uw );

  ObserverVertical := uz; {added by JMM for determining illumination geometry}

//   define unit vector p toward object in celestial system
//   (wrt equator and equinox of date)
  p[x] := cosdc * cosra;
  p[y] := cosdc * sinra;
  p[z] := sindc;

//--- compute coordinates of object wrt orthonormal basis -------------

//   compute components of p -- projections of p onto rotated
//   earth-fixed basis vectors
  pz := p[x] * uz[x] + p[y] * uz[y] + p[z] * uz[z];
  pn := p[x] * un[x] + p[y] * un[y] + p[z] * un[z];
  pw := p[x] * uw[x] + p[y] * uw[y] + p[z] * uw[z];

//   compute azimuth and zenith distance
  proj := Sqrt (sqr( pn) + sqr(pw) );
  az := 0.;
  if ( proj > 0. ) then  az := - Atan2( pw, pn ) * raddeg;
  if ( az <   0. ) then az := az + 360;
  if ( az >= 360. ) then az := az - 360;
  zd := atan2 ( proj, pz ) * raddeg;

{omit optional refraction correction triggered by irefr = 1}

end;

procedure applan (const tjd : extended; const l,n : TJPL_TargetOptions; var pout,vout : TVector;
  var ra,dec,dis,drdt : extended);
//   this subroutine computes the apparent place of a planet or other
//   solar system body.  rectangular coordinates of solar system bodies
//   are obtained from subroutine solsys.  see kaplan, et al. (1989)
//   astronomical journal 97, 1197-1210.

//        tjd    := tt julian date for apparent place (in)
//        l      := body identification number for desired planet (in)
//        n      := body identification number for the earth (in)
//        pout   := position vector in au, referred to
//                 true equator and equinox of date (out)
//        vout   := velocity vector in au/day, referred to
//                 true equator and equinox of date (out)
//        ra     := apparent right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := apparent declination in degrees, referred to
//                 true equator and equinox of date (out)
//        dis    := true distance from earth to planet in au (out)
//        drst   := true radial velocity from earth to planet in au/day (out)
const
  c = 173.14463348; {speed of light in au/day}
  t0 = JD2000;  {julian date of epoch j2000.0}
  tlast : extended = 0.0;
  peb : TVector = (0, 0, 0);
  veb : TVector = (0, 0, 0);
  pes : TVector = (0, 0, 0);

var
  t1,t2,t3,
  xx,secdif,tlight,r,d,s,tdum,sdot : extended;
  pb,vb,ps,
  pos1,vel1,pos2,vel2,pos3,pos4,pos5,pos6 : TVector;
  EphemerisResults : TEphemerisOutput;

begin
//  set return values in event of error
  pout := ZeroVector;
  vout := ZeroVector;
  ra    := 0.0;
  dec   := 0.0;
  dis   := 0.0;
  drdt  := 0.0;

  if (l=n) then exit; {rejects calls with target=center}

//   compute t1, the tdb julian date corresponding to tjd
  times (tjd,xx,secdif);
  t1 := tjd + secdif / 86400.0;

  if (abs(tjd-tlast)>=1.0e-8) then
    begin
      tlast := 0;  {in event of error}
//   get position and velocity of the earth wrt barycenter of
//   solar system and wrt center of sun
      ReadEphemeris(t1,n,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      peb := EphemerisResults.R;
      veb := EphemerisResults.R_dot;
      ReadEphemeris(t1,n,JPL_Sun,PositionsOnly,AU_day,EphemerisResults);
      pes := EphemerisResults.R;
      tlast := tjd;
    end;

  pb := peb;
  vb := veb;
  ps := pes;

//   get position of planet wrt barycenter of solar system
  ReadEphemeris (t1,l,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
  pos1 := EphemerisResults.R;
  vel1 := EphemerisResults.R_dot;

  geocen (pos1,pb,pos2,tlight);
  geocen (vel1,vb,vel2,tdum);

  s := tlight * c;
  if (abs(s) < 1.0e-12) then
   sdot := 0.0
  else
   sdot := DotProduct(pos2,vel2)/s;

  t2 := t1;           {last argument to solsys}
  t3 := t1 - tlight;  {next argument to solsys}
  while abs(t3-t2)>1.0e-8 do
    begin
      ReadEphemeris (t3,l,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      pos1 := EphemerisResults.R;
      vel1 := EphemerisResults.R_dot;
      geocen (pos1,pb,pos2,tlight);
      geocen (vel1,vb,vel2,tdum);
      t2 := t3;
      t3 := t1 - tlight;
    end;

  //   finish apparent place computation
  sunfld (pos2,ps,pos3);
  aberat (pos3,vb,tlight,pos4);

{inserted JMM}
  Angles(pos4,RA,Dec);
  CalculationDetails.Add(format('Aberration corrected geo  RA = %0.9f hrs  Dec = %0.9f deg ',[RA,Dec]));

  preces (t0,pos4,t1,pos5);
  nutate (t1,pos5,pos6);

//   form the output
  pout := pos6;
  vout := vel2;
  angles (pout,r,d);
  ra   := r;
  dec  := d;
  dis  := s;
  drdt := sdot;

end;


procedure tpplan (const tjd, ujd,glon,glat,ht : extended; const lplan : TJPL_TargetOptions;
  var pout,vout : TVector; var ra,dec,dis,drdt : extended);
//   this entry computes the topocentric place of a planet,
//   given the geodetic location of the observer.  Kaplan assumes applan
//   was previously called with an equivalent ephemeris time, but the
//   Delphi implementation incorporates the applan "call" inline.

//        tjd  := TDT julian date (in)
//        ujd  := UT1 julian date (in)

       {note: Kaplan specifies a single parameter  ujd = "UT1 time," but assumes
         that 'applan' has previously been called with the corresponding ephemeris
         time 'tjd'  and planet number "l".  Since the present implementation
         "calls" applan internally I have added these parameters to the call
         sequence, since they cannot be determined from the other information
         supplied.

         Kaplan's code also interprets "ujd" as hours of sidereal time for the
         topocentric place if the value is less than 100 -- this feature is not
         implemented here since the full TDT cannot be deduced from local sidereal
         time}

//        glon   := geodetic longitude (east +) of observer
//                 in degrees (in)
//        glat   := geodetic latitude (north +) of observer
//                 in degrees (in)
//        ht     := height of observer in meters (in)
//        lpan   := body ID number for desired planet (in)  [added JMM]
//        pout   := position vector in au, referred to
//                 true equator and equinox of date (out)
//        vout   := velocity vector in au/day, referred to
//                 true equator and equinox of date (out)
//        ra     := topocentric right ascension in hours, referred to
//                 true equator and equinox of date (out)
//        dec    := topocentric declination in degrees, referred to
//                 true equator and equinox of date (out)
//        dis    := true distance from observer to planet in au (out)
//        drst   := true radial velocity from earth to planet in au/day (out)


const
  c = 173.14463348; {speed of light in au/day}
  t0 = JD2000;  {julian date of epoch j2000.0}
  tlast : extended = 0.0;
  peb : TVector = (0, 0, 0);
  veb : TVector = (0, 0, 0);
  pes : TVector = (0, 0, 0);

var
  CosineTheta, {added JMM 10/5/04 for illumination calculation}
  t1,t2,t3,
  xx,secdif,eqeq,st,gast,tlight,r,d,s,tdum,sdot : extended;
  psp, pep, {added JMM 10/5/04:  vectors from sun to target planet and
    earth to target planet for illumination calculation}
  pog,vog,pb,vb,ps,
  pos1,vel1,pos2,vel2,pos3,pos4,pos5,pos6 : TVector;
  EphemerisResults : TEphemerisOutput;


begin
{*******  the following code is equivalent to a call to APPLAN with n=Earth *******}

//  set return values in event of error
  pout := ZeroVector;
  vout := ZeroVector;
  ra    := 0.0;
  dec   := 0.0;
  dis   := 0.0;
  drdt  := 0.0;

//  if (lplan=n) then exit; {rejects calls for topocentric position of Earth -- I don't know why}

//   compute t1, the tdb julian date corresponding to tjd
  times (tjd,xx,secdif);
  t1 := tjd + secdif / 86400.0;

  if (abs(tjd-tlast)>=1.0e-8) then
    begin
      tlast := 0;  {in event of error}
//   get position and velocity of the earth wrt barycenter of
//   solar system and wrt center of sun
      ReadEphemeris(t1,JPL_Earth,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      peb := EphemerisResults.R;
      veb := EphemerisResults.R_dot;
      ReadEphemeris(t1,JPL_Earth,JPL_Sun,PositionsOnly,AU_day,EphemerisResults);
      pes := EphemerisResults.R;
      tlast := tjd;
    end;

(*
{***  the following from APPLAN will be repeated after switching to the observer's position ***}
{ this evaluates the apparent geocentric positon of the requested target -- there is
  no need for any of this information which will all be recalculated using the correct
  observing location }

  pb := peb;
  vb := veb;
  ps := pes;

//   get position of planet wrt barycenter of solar system
  ReadEphemeris (t1,lplan,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
  pos1 := EphemerisResults.R;
  vel1 := EphemerisResults.R_dot;

  geocen (pos1,pb,pos2,tlight);
  geocen (vel1,vb,vel2,tdum);

  s := tlight * c;
  if (abs(s) < 1.0e-12) then
   sdot := 0.0
  else
   sdot := DotProduct(pos2,vel2)/s;

  t2 := t1;           {last argument to solsys}
  t3 := t1 - tlight;  {next argument to solsys}
  while abs(t3-t2)>1.0e-8 do
    begin
      ReadEphemeris (t3,lplan,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      pos1 := EphemerisResults.R;
      vel1 := EphemerisResults.R_dot;
      geocen (pos1,pb,pos2,tlight);
      geocen (vel1,vb,vel2,tdum);
      t2 := t3;
      t3 := t1 - tlight;
    end;

{
  CalculationDetails.Add('Light-time corrected SS barycentric position:');
  CalculationDetails.Add(format('%0.12f %0.12f %0.12f %0.12f %0.12f',[t1, t3, pos1[x],pos1[y],pos1[z]]));
}

  //   finish apparent place computation
  sunfld (pos2,ps,pos3);
  aberat (pos3,vb,tlight,pos4);
  preces (t0,pos4,t1,pos5);
  nutate (t1,pos5,pos6);

//   form the output
  pout := pos6;
  vout := vel2;
  angles (pout,r,d);
  ra   := r;
  dec  := d;
  dis  := s;
  drdt := sdot;

  CalculationDetails.Add(format('Geocentric:  RA = %0.9f hrs  Dec = %0.9f deg  Dist = %0.9f AU',[RA, DEC, DIS]));

{***  end of repeated code ***}
*)
{******* this is the end of the preliminary call to APPLAN *******}


//   get position and velocity of observer wrt center of earth
  sidtim (ujd,0.0,0,st);
  etilt (t1,xx,xx,eqeq,xx,xx);
  gast := st + eqeq/3600.0;
  terra (glon,glat,ht,gast,pos1,vel1);
  nutate (-t1,pos1,pos2);
  preces (t1,pos2,t0,pog);
  nutate (-t1,vel1,vel2);
  preces (t1,vel2,t0,vog);

//   compute position and velocity of observer wrt barycenter of
//   solar system and position wrt center of sun
  VectorSum(peb,pog,pb);
  VectorSum(veb,vog,vb);
  VectorSum(pes,pog,ps);

//   recompute apparent place using position and velocity of observer

{*******  the following code is a repeat of the last part of APPLAN *******}


//   get position of planet wrt barycenter of solar system
  ReadEphemeris (t1,lplan,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
  pos1 := EphemerisResults.R;
  vel1 := EphemerisResults.R_dot;
  geocen (pos1,pb,pos2,tlight);
  geocen (vel1,vb,vel2,tdum);

  s := tlight * c;

  if (abs(s) < 1.0e-12) then
   sdot := 0.0
  else
   sdot := DotProduct(pos2,vel2)/s;

  t2 := t1;           {last argument to solsys}
  t3 := t1 - tlight;  {next argument to solsys}
  while abs(t3-t2)>1.0e-8 do
    begin
      ReadEphemeris (t3,lplan,SolarSystemBarycenter,PositionsAndVelocities,AU_day,EphemerisResults);
      pos1 := EphemerisResults.R;
      vel1 := EphemerisResults.R_dot;
      geocen (pos1,pb,pos2,tlight);
      geocen (vel1,vb,vel2,tdum); {Kaplan had this in loop}
      t2 := t3;
      t3 := t1 - tlight;
    end;

//   finish apparent place computation

  sunfld (pos2,ps,pos3);
  aberat (pos3,vb,tlight,pos4);
  preces (t0,pos4,t1,pos5);
  nutate (t1,pos5,pos6);

{calculation of illumination parameters, inserted JMM 10/5/04}
{It is unclear to me how to handle the various corrections:
   In calculating the SubSolarAngle it would seem we should use pep := pos2
   since that is the actual position of the planet in space at the moment
   of the observation from Earth.  However, in that case it would seem the
   calculated CuspDirection would need some correction for precession, nutation,
   etc.  It is possible that using pep := pos6 might accomplish this.
 }
  pep := pos6;

  if lplan=JPL_Sun then
    begin
      SubSolarAngle := 0;
      CuspDirection := Uz;
{
      SubSolarDirection := Uz;
      SubEarthDirection := pep;
      MultiplyVector(-1,SubEarthDirection);
}      
    end
  else
    begin {determine illumination parameters}
      VectorSum(ps,pep,psp);  {vector from Sun to target planet}
{
      SubSolarDirection := psp;
      MultiplyVector(-1,SubSolarDirection);
      SubEarthDirection := pep;
      MultiplyVector(-1,SubEarthDirection);
}
      CosineTheta := DotProduct(psp,pep)/(VectorMagnitude(psp)*VectorMagnitude(pos6));
      if CosineTheta>1 then {correct possible round-off errors}
        CosineTheta := 1
      else if CosineTheta<-1 then
        CosineTheta := -1;
      SubSolarAngle := ArcCos(CosineTheta); {returns result between 0 and pi,
        measured CCW from sub-earth point about CuspDirection vector}
      CrossProduct(pep,psp,CuspDirection); {vector perpendicular to Sun-Earth-Target plane}
    end;

//   form the output
  pout := pos6;
  vout := vel2;
  angles (pout,r,d);
  ra   := r;
  dec  := d;
  dis  := s;
  drdt := sdot;

end;


initialization
  CalculationDetails := TStringList.Create;

finalization
  CalculationDetails.Free;

end.

