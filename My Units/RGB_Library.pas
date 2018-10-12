// Combination of Routines from ImageLib & SpectraLibrary
// Copyright (C) 1998, 2001, Earl F. Glynn, Overland Park, KS.

// Useful for manipulating images at RGB & pixel level

UNIT RGB_Library;

INTERFACE

uses
    Windows,  //  TRGBTriple
    Graphics; // TColor, StringToColor -- added JMM

  CONST
    SpeedOfLight {c}   = 2.9979E8 {m/s};
    WavelengthMinimum = 380;  // Nanometers
    WavelengthMaximum = 780;
    MaxPixelCount   =  1000000; // originally 32768 -- seems arbitrary since it
                                // is used only define a data type to point at
    StandardColorNumber : byte = 0;

  TYPE
    NanoMeters = DOUBLE;
    TeraHertz  = DOUBLE;
    TRGBArray  =  ARRAY[0..MaxPixelCount-1] OF TRGBTriple;
    pRGBArray = ^TRGBArray;
    TPixelValue = TRGBTriple;
    TPixelRow = pRGBArray;
{fill with i-th (i = 0..Height-1) row of image using:

         MyPixelRow := Bitmap.ScanLine[i];

 then manipulate pixel in column j (j = 0..Width-1) with:

         MyPixelRow[j].rgbtRed   :=  integer;
         MyPixelRow[j].rgbtGreen :=  integer;
         MyPixelRow[j].rgbtBlue  :=  integer;

       or

         MyPixelRow[j] := MRGBTriple;     }

  function NextStandardColor : TColor; {added JMM}
  {returns a TBrush type color, cycling through a list of standard distinguishable
   colors -- for use in color successive plots on graph, etc.}

  function SpectralColor(const Wavelength:  Nanometers) : TColor;  {added JMM}
  {returns a TBrush type color corresponding to the specified wavelength}

  function RandomWavelength : Nanometers;  {added JMM}
  {returns wavelengths such that the composite of an infinite sum of these will
   produce a neutral gray on the monitor (R = G = B)}

  function RGBtoColor(const R,G,B: BYTE) : TColor;  {added JMM}
  {converts a set of three R, G, B values [0..255] to the corresponding TColor}

  function ColorToRGBTriple(const InputColor : TColor): TRGBTriple; {added JMM 11/3/2006}

  function ColorHexString(const Color: TColor) : String;  {added JMM}
  {converts any TColor into a hex string = '$00rrggbb'}

  function GammaCorrectedGunCount(const Gamma, NormalizedIntensity : extended) : byte; {added JMM}
  {given a real Intensity value on a scale of [0..1], returns the nearest integer
   count on a scale of [0..255] to be used to display that Intensity on a CRT.
   A Gamma of 0.5 will boost low intensities so they display properly on a typical
   CRT with Gamma = 2.0.}

  procedure GammaCorrectPixelValue(var RawPixelValue : TPixelValue; const Gamma : extended);
  {similar to previous function, but simultaneous corrects all three RGB values on scale of [0..255]}

  procedure StretchPixelValue(var RawPixelValue : TPixelValue; const SaturationI : integer);
  {multiplies (and truncates, if necessary) all RGB values so they will saturate (=255) at
   an original value of SaturationI}


  PROCEDURE WavelengthToRGB(CONST Wavelength:  Nanometers; VAR R,G,B:  BYTE);

  PROCEDURE FrequencyToRGB(CONST Frequency:  TeraHertz; VAR R,G,B:  BYTE);

  FUNCTION WavelengthToFrequency(CONST lambda:  NanoMeters):  TeraHertz;

  FUNCTION FrequencyToWavelength(CONST frequency:  TeraHertz):  NanoMeters;

  FUNCTION RGBtoString(CONST R,G,B: BYTE):  STRING;

  FUNCTION RGBtoRGBTriple(CONST red, green, blue:  BYTE):  TRGBTriple;

// Integer Conversion Routines
  PROCEDURE RGBtoHSV (CONST r,g,b:  INTEGER;   {0..255}
                      VAR   h,s,v:  INTEGER);  {h IN 0..359; s,v IN 0..255}

  FUNCTION HSVtoRGBTriple (CONST H,S,V:  INTEGER):  TRGBTriple;
  //  H = 0 to 360 (corresponding to 0..360 degrees around hexcone)
  //      0 (undefined) for S = 0
  //  S = 0 (shade of gray) to 255 (pure color)
  //  V = 0 (black) to 255 (white)

  PROCEDURE RGBTripleToHSV (CONST RGBTriple: TRGBTriple;  {r, g and b IN [0..255]}
                            VAR   H,S,V:  INTEGER);    {h IN 0..359; s,v IN 0..255}


// Floating Point Conversion Routines
  PROCEDURE FloatingHSVtoRGB(CONST H,S,V:  Extended; VAR R,G,B:  Extended);

  PROCEDURE FloatingRGBToHSV(CONST R,G,B:  Extended; VAR H,S,V:  Extended);

IMPLEMENTATION

  USES
    Dialogs,
    SysUtils, // IntToStr
    Math;     // Power

function NextStandardColor : TColor; {added JMM}
  const
    NumStandardColors = 17;
    StandardColor : array[1..NumStandardColors] of TColor =
      (clRed, clBlue, clGreen, clBlack, clFuchsia, clAqua, clLime, clPurple,
       clMaroon, clDkGray, clLtGray, clMedGray, clMoneyGreen, clNavy, clSkyBlue,
       clTeal, clYellow);
  begin
    inc(StandardColorNumber);
    if  StandardColorNumber>NumStandardColors then StandardColorNumber := 1;
    Result := StandardColor[StandardColorNumber];
  end;

function SpectralColor(const Wavelength:  Nanometers) : TColor;  {added JMM}
  var
    R, G, B : byte;
  begin
    WavelengthToRGB(Wavelength, R, G, B);
    Result := RGBtoColor(R,G,B);
  end;

function RandomWavelength : Nanometers;  {added JMM}
var
  MaxFreq, MinFreq : extended;
begin
  MinFreq := 1/696;
  MaxFreq := 1/386;
  Result := 1/(MinFreq + (MaxFreq - MinFreq)*Random);
end;

function RGBtoColor(const R,G,B: BYTE) : TColor;  {added JMM}
  begin
    Result := StringToColor(Format('$00%2.2x%2.2x%2.2x',[B,G,R]));
  end;

function ColorToRGBTriple(const InputColor : TColor): TRGBTriple; {added JMM 11/3/2006}
  begin
    Result.rgbtRed := InputColor and $000000FF;
    Result.rgbtGreen := (InputColor and $0000FF00) div $100;
    Result.rgbtBlue := (InputColor and $00FF0000) div $10000;
  end;

function ColorHexString(const Color: TColor) : String;  {added JMM}
{Note:  TColor is simply a 32-bit integer most easily interpreted in hexadecimal
 format as explained in the Delphi help}
  begin
    Result := Format('$%8.8x',[Color]);
  end;

function GammaCorrectedGunCount(const Gamma, NormalizedIntensity : extended) : byte; {added JMM}
  var
    TempResult : integer;
  begin
    if NormalizedIntensity=0 then
      Result := 0
    else
      begin
        TempResult := round(255*Power(NormalizedIntensity,Gamma));

        if TempResult>255 then
          Result := 255
        else if TempResult<0 then
          Result := 0
        else
          Result := TempResult;
      end;
  end;


procedure GammaCorrectPixelValue(var RawPixelValue : TPixelValue; const Gamma : extended);
  {similar to previous function, but simultaneous corrects all three RGB values on scale of [0..255]}
  begin
    if Gamma<>1 then with RawPixelValue do
      begin
        rgbtRed := GammaCorrectedGunCount(Gamma,rgbtRed/255);
        rgbtGreen := GammaCorrectedGunCount(Gamma,rgbtGreen/255);
        rgbtBlue := GammaCorrectedGunCount(Gamma,rgbtBlue/255);
      end;
  end;

procedure StretchPixelValue(var RawPixelValue : TPixelValue; const SaturationI : integer);
  {multiplies (and truncates, if necessary) all RGB values so they will saturate (=255) at
   an original value of SaturationI}
  procedure BoostValue(var I : byte);
    var
      Temp : integer;
    begin
      Temp := round(255*I/SaturationI);
      if Temp>255 then
        I := 255
      else
        I := Temp;
    end;
  begin {StretchPixelValue}
    with RawPixelValue do
      begin
        BoostValue(rgbtRed);
        BoostValue(rgbtGreen);
        BoostValue(rgbtBlue);
      end;
  end;  {StretchPixelValue}

 // Adapted from www.isc.tamu.edu/~astro/color.html
 PROCEDURE WavelengthToRGB(CONST Wavelength:  Nanometers;
                            VAR R,G,B:  BYTE);

   CONST
     Gamma        =   0.80;
     IntensityMax = 255;

   VAR
     Blue  :  DOUBLE;
     factor:  DOUBLE;
     Green :  DOUBLE;
     Red   :  DOUBLE;

   FUNCTION Adjust(CONST Color, Factor:  DOUBLE):  INTEGER;
   BEGIN
     IF   Color = 0.0
     THEN RESULT := 0     // Don't want 0^x = 1 for x <> 0
     ELSE RESULT := ROUND(IntensityMax * Power(Color * Factor, Gamma))
   END {Adjust};

 BEGIN

   CASE TRUNC(Wavelength) OF
     380..439:
       BEGIN
         Red   := -(Wavelength - 440) / (440 - 380);
         Green := 0.0;
         Blue  := 1.0
       END;

     440..489:
       BEGIN
         Red   := 0.0;
         Green := (Wavelength - 440) / (490 - 440);
         Blue  := 1.0
       END;

     490..509:
       BEGIN
         Red   := 0.0;
         Green := 1.0;
         Blue  := -(Wavelength - 510) / (510 - 490)
       END;

     510..579:
       BEGIN
         Red   := (Wavelength - 510) / (580 - 510);
         Green := 1.0;
         Blue  := 0.0
       END;

     580..644:
       BEGIN
         Red   := 1.0;
         Green := -(Wavelength - 645) / (645 - 580);
         Blue  := 0.0
       END;

     645..780:
       BEGIN
         Red   := 1.0;
         Green := 0.0;
         Blue  := 0.0
       END;

     ELSE
       Red   := 0.0;
       Green := 0.0;
       Blue  := 0.0
   END;

   // Let the intensity fall off near the vision limits
   CASE TRUNC(Wavelength) OF
     380..419:  factor := 0.3 + 0.7*(Wavelength - 380) / (420 - 380);
     420..700:  factor := 1.0;
     701..780:  factor := 0.3 + 0.7*(780 - Wavelength) / (780 - 700)
     ELSE       factor := 0.0
   END;

   R := Adjust(Red,   Factor);
   G := Adjust(Green, Factor);
   B := Adjust(Blue,  Factor)
 END {WavelengthToRGB};


 PROCEDURE FrequencyToRGB(CONST Frequency:  TeraHertz;
                            VAR R,G,B:  BYTE);
 BEGIN
   WavelengthToRGB(FrequencyToWavelength(Frequency), R,G,B)
 END {FrequencyTORGB};


  // frequency * wavelength = SpeedOfLight
  // frequency = c / lambda =
  //             2.9979E8 m/s / [ lambda [nm] * [1 meter / 1E9 nm] ]
  //                          * [1 THz / 1E12 Hz]
  //           = (2.9979E8 m/s / lambda [nm]) * 1E-3  [THz]
  FUNCTION WavelengthToFrequency(CONST lambda:  NanoMeters):  TeraHertz;
  BEGIN
     RESULT := SpeedOfLight * 1E-3 / lambda
  END {WavelengthToFrequency};


  // frequency * wavelength = SpeedOfLight
  // wavelength = c / frequency =
  //             2.9979E8 m/s / [ frequency [THz] * [1E12 Hz / 1 THz] ]
  //                          * [1E9 nm / m]
  //           = (2.9979E8 m/s / f [THz]) * 1E-3
  FUNCTION FrequencyToWavelength(CONST frequency:  TeraHertz):  NanoMeters;
  BEGIN
     RESULT := SpeedOfLight * 1E-3 / frequency
  END {FrequencyToWavelength};


  FUNCTION RGBtoString(CONST R,G,B: BYTE):  STRING;
  BEGIN
    RESULT := 'R=' + IntToStr(R) +
              '  G=' + IntToStr(G) +
              '  B=' + IntToSTr(B);
  END {RGBtoString};

  ////////////////////////////////////////////////////////////////////////////

  // from HSVLibrary in
  //   http://www.efg2.com/Lab/Graphics/Colors/HSV.ZIP
  // at
  //   http://www.efg2.com/Lab/Graphics/Colors/HSV.htm

  // additional Color space conversions available in
  //   http://www.efg2.com/Lab/Graphics/Colors/ColorRange.ZIP
  // at
  //   http://www.efg2.com/Lab/Graphics/Colors/ColorRange.htm

  ////////////////////////////////////////////////////////////////////////////

  FUNCTION RGBtoRGBTriple(CONST red, green, blue:  BYTE):  TRGBTriple;
  BEGIN
    WITH RESULT DO
    BEGIN
      rgbtRed   := red;
      rgbtGreen := green;
      rgbtBlue  := blue
    END
  END {RGBTriple};


  ////////////////////////////////////////////////////////////////////////////
  // Integer Routines

  // Optimize getting min and max for only three values:
  // no loops and minimum comparisons
  PROCEDURE MinMax3(CONST i,j,k:  INTEGER; VAR min, max:  INTEGER);
  BEGIN
    IF   i > j
    THEN BEGIN
      IF   i > k
      THEN max := i
      ELSE max := k;

      IF   j < k
      THEN min := j
      ELSE min := k
    END
    ELSE BEGIN
      IF   j > k
      THEN max := j
      ELSE max := k;

      IF   i < k
      THEN min := i
      ELSE min := k
    END
  END {MinMax3};


  // RGB, each 0 to 255, to HSV.
  //  H = 0 to 359 degrees around color circle
  //  S = 0 (shade of gray) to 255 (pure color)
  //  V = 0 (black) to 255 {white)
  //
  //  Based on C Code in "Computer Graphics -- Principles and Practice,"
  //  Foley et al, 1996, p. 592.  Floating point fractions, 0..1, replaced with
  //  integer values, 0..255.

  PROCEDURE RGBtoHSV (CONST r,g,b:  INTEGER;   {0..255}
                      VAR   h,s,v:  INTEGER);  {h IN 0..359; s,v IN 0..255}
    VAR
      Delta   :  INTEGER;
      MinValue:  INTEGER;
  BEGIN
    MinMax3(R, G, B, MinValue, v);
    Delta := v - MinValue;

    // Calculate saturation:  saturation is 0 if r, g and b are all 0
    IF   v = 0
    THEN s := 0
    ELSE s := (255 * Delta) DIV v;

    IF   s = 0
    THEN h := 0   // Achromatic:  When s = 0, h is undefined but assigned the value 0
    ELSE BEGIN    // Chromatic

      IF   r = v
      THEN h := (60*(g-b)) DIV Delta             // degrees -- between yellow and magenta
      ELSE
        IF   g = v
        THEN h := 120 + (60*(b-r)) DIV Delta     // degrees -- between cyan and yellow
        ELSE
          IF  b = v
          THEN h := 240 + (60*(r-g)) DIV Delta;  // degrees -- between magenta and cyan

      IF   h < 0
      THEN h := h + 360;

    END
  END {RGBtoHSV};


  ////////////////////////////////////////////////////////////////////////////
  // Integer Routines

  // Floating point fractions, 0..1, replaced with integer values, 0..255.
  // Use integer conversion ONLY for one-way, or a single final conversions.
  // Use floating-point for converting reversibly.
  //
  //  H = 0 to 360 (corresponding to 0..360 degrees around hexcone)
  //      0 (undefined) for S = 0
  //  S = 0 (shade of gray) to 255 (pure color)
  //  V = 0 (black) to 255 (white)

  FUNCTION HSVtoRGBTriple (CONST H,S,V:  INTEGER):  TRGBTriple;
    CONST
      divisor:  INTEGER = 255*60;
    VAR
      f    :  INTEGER;
      hTemp:  INTEGER;
      p,q,t:  INTEGER;
      VS   :  INTEGER;
  BEGIN
    IF   S = 0
    THEN RESULT := RGBtoRGBTriple(V, V, V)  // achromatic:  shades of gray
    ELSE BEGIN                              // chromatic color
      IF   H = 360
      THEN hTemp := 0
      ELSE hTemp := H;

      f     := hTemp MOD 60;     // f is IN [0, 59]
      hTemp := hTemp DIV 60;     // h is now IN [0,6)

      VS := V*S;
      p := V - VS DIV 255;                 // p = v * (1 - s)
      q := V - (VS*f) DIV divisor;         // q = v * (1 - s*f)
      t := V - (VS*(60 - f)) DIV divisor;  // t = v * (1 - s * (1 - f))

      CASE hTemp OF
        0:   RESULT := RGBtoRGBTriple(V, t, p);
        1:   RESULT := RGBtoRGBTriple(q, V, p);
        2:   RESULT := RGBtoRGBTriple(p, V, t);
        3:   RESULT := RGBtoRGBTriple(p, q, V);
        4:   RESULT := RGBtoRGBTriple(t, p, V);
        5:   RESULT := RGBtoRGBTriple(V, p, q);
        ELSE RESULT := RGBtoRGBTriple(0,0,0)  // should never happen;
                                              // avoid compiler warning
      END
    END
  END {HSVtoRGBTriple};

   // RGB, each 0 to 255, to HSV.
  //   H = 0 to 360 (corresponding to 0..360 degrees around hexcone)
  //   S = 0 (shade of gray) to 255 (pure color)
  //   V = 0 (black) to 255 {white)

  // Based on C Code in "Computer Graphics -- Principles and Practice,"
  // Foley et al, 1996, p. 592.  Floating point fractions, 0..1, replaced with
  // integer values, 0..255.

  PROCEDURE RGBTripleToHSV (CONST RGBTriple: TRGBTriple;  {r, g and b IN [0..255]}
                            VAR   H,S,V:  INTEGER);    {h IN 0..359; s,v IN 0..255}
    VAR
      Delta:  INTEGER;
      Min  :  INTEGER;
  BEGIN
    WITH RGBTriple DO
    BEGIN
      Min := MinIntValue( [rgbtRed, rgbtGreen, rgbtBlue] );
      V   := MaxIntValue( [rgbtRed, rgbtGreen, rgbtBlue] )
    END;

    Delta := V - Min;

    // Calculate saturation:  saturation is 0 if r, g and b are all 0
    IF   V =  0
    THEN S := 0
    ELSE S := MulDiv(Delta, 255, V);

    IF   S  = 0
    THEN H := 0   // Achromatic:  When s = 0, h is undefined but assigned the value 0
    ELSE BEGIN    // Chromatic

      WITH RGBTriple DO
      BEGIN
        IF   rgbtRed = V
        THEN  // degrees -- between yellow and magenta
              H := MulDiv(rgbtGreen - rgbtBlue, 60, Delta)
        ELSE
          IF   rgbtGreen = V
          THEN // between cyan and yellow
               H := 120 + MulDiv(rgbtBlue-rgbtRed, 60, Delta)
          ELSE
            IF  rgbtBlue = V
            THEN // between magenta and cyan
                 H := 240 + MulDiv(rgbtRed-rgbtGreen, 60, Delta);
      END;

      IF   H < 0
      THEN H := H + 360;

    END
  END {RGBTripleToHSV};


  ///////////////////////////////////////////////////////////////////////////
  // Floating-Point Routines

  // Based on C Code in "Computer Graphics -- Principles and Practice,"
  // Foley et al, 1996, p. 593.
  //
  //  H = 0.0 to 360.0 (corresponding to 0..360 degrees around hexcone)
  //      NaN (undefined) for S = 0
  //  S = 0.0 (shade of gray) to 1.0 (pure color)
  //  V = 0.0 (black)         to 1.0 (white)

  PROCEDURE  FloatingHSVtoRGB (CONST H,S,V:  Extended; VAR R,G,B:  Extended);
    VAR
      f    :  Extended;
      i    :  INTEGER;
      hTemp:  Extended;              // since H is CONST parameter
      p,q,t:  Extended;
  BEGIN
    IF   S = 0.0                  // color is on black-and-white center line
    THEN BEGIN
{      IF   IsNaN(H)
      THEN BEGIN }
        R := V;                   // achromatic:  shades of gray
        G := V;
        B := V
{      END
      ELSE RAISE EColorError.Create('HSVtoRGB:  S = 0 and H has a value');}
    END

    ELSE BEGIN                    // chromatic color
      IF   H = 360.0              // 360 degrees same as 0 degrees
      THEN hTemp := 0.0
      ELSE hTemp := H;

      hTemp := hTemp / 60;        // h is now IN [0,6)
      i := TRUNC(hTemp);          // largest integer <= h
      f := hTemp - i;             // fractional part of h

      p := V * (1.0 - S);
      q := V * (1.0 - (S * f));
      t := V * (1.0 - (S * (1.0 - f)));

      CASE i OF
        0:  BEGIN R := V;  G := t;  B := p  END;
        1:  BEGIN R := q;  G := V;  B := p  END;
        2:  BEGIN R := p;  G := V;  B := t  END;
        3:  BEGIN R := p;  G := q;  B := V  END;
        4:  BEGIN R := t;  G := p;  B := V  END;
        5:  BEGIN R := V;  G := p;  B := q  END
      END
    END
  END {FloatingHSVtoRGB};

  // RGB, each 0 to 255, to HSV.
  //   H = 0.0 to 360.0 (corresponding to 0..360.0 degrees around hexcone)
  //   S = 0.0 (shade of gray) to 1.0 (pure color)
  //   V = 0.0 (black) to 1.0 {white)

  // Based on C Code in "Computer Graphics -- Principles and Practice,"
  // Foley et al, 1996, p. 592.  Floating point fractions, 0..1, replaced with
  // integer values, 0..255.

  PROCEDURE FloatingRGBToHSV (CONST R,G,B:  Extended; VAR H,S,V:  Extended);
    VAR
      Delta:  Extended;
      Min  :  Extended;
  BEGIN
    Min := MinValue( [R, G, B] );
    V   := MaxValue( [R, G, B] );

    Delta := V - Min;

    // Calculate saturation:  saturation is 0 if r, g and b are all 0
    IF   V =  0.0
    THEN S := 0
    ELSE S := Delta / V;

    IF   S  = 0.0
    THEN H := 0.0{NaN} // Achromatic:  When s = 0, h is undefined
    ELSE BEGIN    // Chromatic
      IF   R = V
      THEN  // between yellow and magenta [degrees]
            H := 60.0 * (G - B) / Delta
      ELSE
        IF   G = V
        THEN // between cyan and yellow
             H := 120.0 + 60.0 * (B - R) / Delta
        ELSE
          IF  B = V
          THEN // between magenta and cyan
               H := 240.0 + 60.0 * (R - G) / Delta;

      IF   H < 0.0
      THEN H := H + 360.0
    END
  END {FloatingRGBtoHSV};

END.
