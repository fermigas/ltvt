unit MapFns_Unit;

interface
const
  NumRuklRows = 8;  // Rukl divides Y = +1 to -1 into 8 rows
  NumRuklCols = 11; // and X = -1 to +1 into 11 columns
  RuklRowLength : array[1..NumRuklRows] of Integer = (7, 9, 11, 11, 11, 11, 9, 7);  // Number of zones in each row
  RuklCenterCol : array[1..NumRuklRows] of Integer = (4, 12, 22, 33, 44, 55, 65, 73);  // Map number at center of row
  RuklXiStep  = 2/NumRuklCols;
  RuklEtaStep = 2/NumRuklRows;

  LTOStartCol : array[1..12] of Integer = (1, 2, 10, 22, 37, 55, 73, 91, 109, 124, 136, 144);  // Map number at start of row
  LTOStartLon : array[1..12] of Integer = (0, -80, -80, -86, -90, -90, -90, -90, -86, -80, -80, 0); // longitude at left edge of LTOStartCol
  LTOWidth : array[1..12] of Integer = (360, 45, 30, 24, 20, 20, 20, 20, 24, 30, 45, 360); // width of each block in row

function LTO_MapExists(const MapString : String): Boolean;

function LTO_String(const LonRad, LatRad : Extended) : String;

function Rukl_String(const LonRad, LatRad : Extended) : String;
// returns blank string if requested Lon-Lat is not on Nearside

implementation

uses LTVT_Unit, MPVectors, SysUtils, Math;

function LTO_MapExists(const MapString : String): Boolean;
  const
    NumLTOMaps = 215;
    LTOMapName : array[1..NumLTOMaps] of String =
      (
      '38B1','38B2','38B3','38B4','39A1','39A2','39A3','39A4','39B1','39B2','39B3','39B4','39C1','39C2','40A1','40A2',
      '40A3','40A4','40B1','40B2','40B3','40B4','40C2','40D1','40D2','41A3','41A4','41B3','41B4','41C1','41C2','41C3',
      '41C4','41D1','41D2','42A3','42A4','42B3','42B4','42C1','42C2','42C3','42C4','42D1','42D2','42D3','42D4','43A4',
      '43C1','43C2','43C3','43C4','43D1','43D2','43D3','43D4','44D3','44D4','60A1','60A2','60B1','60B2','60B3','60B4',
      '61A1','61A2','61A3','61A4','61B1','61B2','61B3','61B4','61C1','61C2','61C3','61C4','61D1','61D2','61D3','61D4',
      '62A1','62A2','62A3','62A4','62B1','62B2','62B3','62B4','62C1','62C2','62C3','62C4','62D1','62D2','62D3','62D4',
      '63A2','63A3','63A4','63B1','63B2','63B3','63B4','63C1','63C2','63C3','63C4','63D1','63D2','63D3','63D4','64D1',
      '64D2','64D3','64D4','65A3','65B4','65C1','65C4','65D2','65D3','66A3','66B4','66C1','66D2','75C1','75C2','75D2',
      '76C1','76C2','76D1','76D2','77A3','77B3','77B4','77C1','77C2','77D1','77D2','78A3','78A4','78B3','78B4','78C1',
      '78C2','78D1','78D2','79A2','79A3','79A4','79B1','79B2','79B3','79B4','79D1','79D2','80A1','80A2','80A3','80A4',
      '80B1','80B2','80B3','80B4','80C1','80C2','80D2','81A1','81A2','81A3','81A4','81B1','81B2','81B3','81B4','81C1',
      '81C2','81D1','81D2','82A1','82A2','82A3','82A4','82D1','82D2','83B4','83C1','83C3','83C4','83D2','84B3','84D4',
      '85A4','85C1','85C2','85C3','86D4','100A1','100A2','100C1','101B1','101B2','101B3','101B4','101C1','101C2',
      '102A1','102A4','102B2','102B3','102D1','103A1','103A4','103B2','104A1' );
  var
    i : Integer;
  begin
    Result := False;
    i := 0;
    while (i<NumLTOMaps) and not Result do
      begin
        Inc(i);
        Result := MapString=LTOMapName[i];
      end;
  end;

function LTO_String(const LonRad, LatRad : Extended) : String;
  var
    DegLat, DegLon, SectionLat, SectionLon, CornerLon, CornerLat,
    DummyLon, DummyLat : Extended;
    LTORow, LTONum,
    LTOQuadNum, LTOSubQuadNum,
    SectionWidth, SectionHeight, LonSteps : Integer;

    function PositiveAngle(const AngleDegrees : Extended) : Extended;
    {places angle in range 0..360 degrees}
      begin
        Result := AngleDegrees;
        while Result>360 do Result := Result - 360;
        while Result<0   do Result := Result + 360;

      end;

    function LTO_Quadrant(const Lon, Lat, Lon1, Lat1, LonWidth, LatHeight : Extended; var NewLon1, NewLat1 : Extended) : Integer;
    {LAC zones are divided into quadrants lettered or number clockwise from upper left.
      Lon, Lat = point of interest in degrees
      Lon1, Lat1 = lower right corner of section to be divided
      LonWidth, LatHeight = dimensions of section
      NewLon1, NewLat2 = lower right corner of selected quadrant (dimensions = half of original)
      Result = number in range 1..4}
      var
        W2, H2, LonOffset, LatOffset : Extended;
      begin {LTO_Quadrant}
        W2 := LonWidth/2;
        H2 := LatHeight/2;

        LonOffset := PositiveAngle(Lon - Lon1);
        LatOffset := PositiveAngle(Lat - Lat1);

        if LonOffset<=W2 then
          begin // in right column
            NewLon1 := Lon1;
            if LatOffset<=H2 then
              begin // in bottom row
                NewLat1 := Lat1;
                Result := 4;
              end
            else
              begin // in top row
                NewLat1 := Lat1 + H2;
                Result := 1;
              end;
          end
        else
          begin // on left column
            NewLon1 := Lon1 + W2;
            if LatOffset<=H2 then
              begin // in bottom row
                NewLat1 := Lat1;
                Result := 3;
              end
            else
              begin // in top row
                NewLat1 := Lat1 + H2;
                Result := 2;
              end;
          end;
      end;  {LTO_Quadrant}

  begin {LTO_String}
    DegLon := RadToDeg(LonRad);
    DegLat := RadToDeg(LatRad);
      LTORow := 1;
      SectionHeight := 10;
      SectionLat := 80;
      while DegLat<SectionLat do
        begin
          Inc(LTORow);
          if LTORow<12 then
            SectionHeight := 16
          else
            SectionHeight := 10;
          SectionLat := SectionLat - SectionHeight;
        end;

      if LTORow>12 then LTORow := 12;
      if SectionLat<-90 then SectionLat := -90;

      SectionWidth := LTOWidth[LTORow];

      LonSteps := Trunc(PositiveAngle(DegLon - LTOStartLon[LTORow])/LTOWidth[LTORow]);
      LTONum := LTOStartCol[LTORow] + LonSteps;

      SectionLon := LTOStartLon[LTORow] + LonSteps*SectionWidth;

      LTOQuadNum := LTO_Quadrant(DegLon,DegLat,SectionLon,SectionLat,SectionWidth,SectionHeight,CornerLon,CornerLat);
      LTOSubQuadNum := LTO_Quadrant(DegLon,DegLat,CornerLon,CornerLat,SectionWidth/2,SectionHeight/2,DummyLon,DummyLat);

      LTO_String := IntToStr(LTONum)+Char(Ord('A')+LTOQuadNum-1)+IntToStr(LTOSubQuadNum);

  end;  {LTO_String}

function Rukl_String(const LonRad, LatRad : Extended) : String;
// returns blank string if requested Lon-Lat is not on Nearside
  var
    FeatureVector : TVector;
    RuklRow, RuklColOffset, RuklNum, MaxOffset : Integer;

  begin {Rukl_String}
    LTVT_Form.PolarToVector(LonRad, LatRad, 1, FeatureVector);
    if FeatureVector[Z]<0 then
      Rukl_String := ''
    else
      begin
        RuklRow := Round(((1 - FeatureVector[y])*NumRuklRows + 1)/2);
        if RuklRow<1 then
          RuklRow := 1
        else if RuklRow>NumRuklRows then
          RuklRow := NumRuklRows;

        RuklColOffset := Round(FeatureVector[x]*NumRuklCols/2);
        MaxOffset := RuklRowLength[RuklRow] div 2;

        if RuklColOffset>MaxOffset then
           RuklColOffset := MaxOffset
        else if RuklColOffset<-(MaxOffset) then
           RuklColOffset := -MaxOffset;

        RuklNum := RuklCenterCol[RuklRow] + RuklColOffset;

        Rukl_String := IntToStr(RuklNum);
      end;
  end;  {Rukl_String}


end.
