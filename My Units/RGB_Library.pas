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

  PROCEDURE RGBtoHSV (CONST r,g,b:  INTEGER;   {0..255}
                      VAR   h,s,v:  INTEGER);  {h IN 0..359; s,v IN 0..255}

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

END.
