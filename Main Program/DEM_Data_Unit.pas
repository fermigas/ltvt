unit DEM_Data_Unit;
{reads DEM data in several formats}

interface

uses Classes;

type
  TDemData = class(TObject)
  private
    Stored_SingleDEM_data : array of array of Single;  // in [km] as deviation from RefHeightKm
    Stored_SmallIntDEM_data : array of array of SmallInt;  // deviation from RefHeightKm (after multiplying by RawDataToKmMultiplier)
    ValidNoDataValue, StereographicProjection, SmallIntStorageFormat : Boolean;
    NoDataValue : Single;
    NumLons, NumLats  : Integer;
    RawDataToKmMultiplier,
    StereoCenterLatRad, StereoCenterIndex, StereoScaleFactor, StereoLamba0Rad,
    LonStepRad,   {[rad]}
    FirstLonRad, FirstLatRad : Extended; // *center* of first sample in first line (upper left of image) in [rad]
  public
    FileOpen, DisplayTimings : Boolean;
    DEM_info : TStringList;
    Filename : String;
    LatStepRad,  // used as basic Grid Step in LTVT computed for both polar and cylindrical projections
    RefHeightKm,
    MinHtDeviationKm, MaxHtDeviationKm : Extended;  {deviation from RefHeightKm}

    constructor Create;
    destructor Destroy;   override;
    procedure ClearStorage;
     {release memory}
    function SelectFile(const DesiredFilename : String) : Boolean;
     {Returns true if file successfully opened and data initialized}
    function ReadHeight(const LonRad, LatRad : Extended; var Height : Extended) : Boolean;
     {Returns true if able to recover total height, in kilometers, from Center of Mass.  Returns
      false if point is off the grid.}
  end;

implementation

uses MoonPosition {MoonRadius}, LTVT_Unit, Constnts, Math, Dialogs, Controls {mrOK}, SysUtils, Win_Ops;

constructor TDemData.Create;     { this goes after implementation }
begin
  inherited;
{start custom stuff}
  FileOpen := False;
  Filename := '';
  DisplayTimings := False;
  ClearStorage;
  DEM_info := TStringList.Create;
end;

destructor TDemData.Destroy;
begin
  DEM_info.Free;
  ClearStorage;
  inherited;
end;

procedure TDemData.ClearStorage;
begin
  SetLength(Stored_SingleDEM_data,0,0);
  SetLength(Stored_SmallIntDEM_data,0,0);
end;

function TDemData.SelectFile(const DesiredFilename : String) : Boolean;
type
  TTwoByteArray = array[1..2] of Byte;
  TFourByteArray = array[1..4] of Byte;
  TEightByteArray = array[1..8] of Byte;
const
  DummyDataValue = -999999;
var
  NameOfFileToRead : String;
  Mission : (Kaguya, Apollo, Unknown);
  RawDataType : (ReversedDoubleData, SingleData, WordData, SmallIntData, LongIntData, ReversedSmallIntData, ReversedLongIntData, ByteData);
  TestFile : file of Char;
  TestChar : Char;
  ByteFile : file;  // untyped
  ByteRow : array of Byte; // unsigned 8-bit integers
  WordRow : array of Word; // unsigned 16-bit integers
//  SmallIntRow : array of SmallInt; // signed 16-bit integers
  LongIntRow : array of LongInt; // signed 32-bit integers
  ReversedSmallIntRow : array of TTwoByteArray;  // signed 16-bit integers
  ReversedLongIntRow : array of TFourByteArray;   // signed 32-bit integers
  ReversedDoubleRow : array of TEightByteArray;
  TwoByteArray : TTwoByteArray;
  FourByteArray : TFourByteArray;
  EightByteArray : TEightByteArray;
  CharsRead, NumHeaderBytes, BytesPerDataItem, NumDataBytes, ExpectedDataBytes, NumBytes,
  LatNum, LonNum, NumRead,
  MinHtLonNum, MinHtLatNum, MaxHtLonNum, MaxHtLatNum : Integer;
  DataValue, NoRawDataValue, MinRawDataValue, MaxRawDataValue : Single;
  LastLonRad, LastLatRad,
  LeftLonDeg, RightLonDeg, // for ShowDemInfo display
  StereoEdgeLatDeg, StereoCornerLatDeg,
  RawDataOffset : Extended;
  ItemString : String;
  StartTime : TDateTime;
  ASCII_file_detected : Boolean;
  BytesNeeded : Currency;

function ReadPDS_Header : Boolean;
  var
    MissionName, MapProjection, UnitString, A_AXIS_RADIUS : String;
    StepsPerRadian, MapStep, KmPerPixel, A_radius : Extended;

  function FindItem(const SearchString : String; var DataString, Units : String; const DisplayWarning : Boolean) : Boolean;
  // reads Infile until identifier field = SearchString
    var
      Infile : TextFile;
      DataLine : String;
      EndFound : Boolean;
    begin {FindItem}
//      ShowMessage('Looking for "'+SearchString+'" in "'+NameOfFileToRead+'"');

      Result := False;
      EndFound := False;

      AssignFile(Infile,NameOfFileToRead);
      Reset(Infile);

      while (not EOF(Infile)) and (not EndFound) and (not Result) do
        begin
          Readln(Infile,DataLine);
          DataLine := UpperCase(DataLine);  // all PDS headers seem to be in uppercase, but do this to be sure
          EndFound := Trim(DataLine)='END';
          DataString := Trim(LeadingElement(DataLine,'='));   // extract identifier field
          Result := DataString=SearchString;
        end;

      if Result then
        begin
  //        DataLine is now part after identifier, following '='
          DataString := LeadingElement(DataLine,'<'); // number sometimes followed by <xxx>  indicating units
          Units := LeadingElement(DataLine,'>');
        end
      else
        begin
          DataString := '';
          Units := '';
          if DisplayWarning then ShowMessage('"'+SearchString+'" not found');
        end;

      CloseFile(Infile);

    end;  {FindItem}

  begin {ReadPDS_Header}
    Result := False;

    ASCII_file_detected := False;
    CharsRead := 0;

    AssignFile(TestFile,DesiredFilename);
    Reset(TestFile);
    while (CharsRead<250) and (not ASCII_file_detected) and  (not EOF(TestFile)) do
      begin
        Read(TestFile,TestChar);
        if (TestChar=CR) and (not EOF(TestFile)) then
          begin
            Read(TestFile,TestChar);
            ASCII_file_detected := (TestChar=LF);
          end;
        Inc(CharsRead);
      end;
    CloseFile(TestFile);

    if ASCII_file_detected then
      NameOfFileToRead := DesiredFilename
    else
      begin
        NameOfFileToRead := ChangeFileExt(DesiredFilename,'.LBL');
        if not FileExists(NameOfFileToRead) then
          begin
            ShowMessage('Unable to find PDS label file: '+NameOfFileToRead);
            Exit;
          end;
      end;

    if FindItem('MISSION_NAME',MissionName,UnitString,False) and (MissionName='SELENE') then
      Mission := Kaguya
    else
      Mission := Unknown;

    case Mission of
      Kaguya:
        begin  // items unique to Kaguya records
          if not FindItem('^IMAGE',ItemString,UnitString,True) then Exit;
          NumHeaderBytes := IntegerValue(ItemString) - 1;
          if not FindItem('DUMMY_DATA',ItemString,UnitString,True) then Exit;
          NoRawDataValue := ExtendedValue(ItemString);
        end;
      else
        begin
          if ASCII_file_detected then
            begin
              if not FindItem('RECORD_BYTES',ItemString,UnitString,True) then Exit;
              NumHeaderBytes := IntegerValue(ItemString);
              if not FindItem('^IMAGE',ItemString,UnitString,True) then Exit;
              NumHeaderBytes := NumHeaderBytes*(IntegerValue(ItemString) - 1);
            end
          else
            begin
              NumHeaderBytes := 0;
              if not FindItem('^IMAGE',ItemString,UnitString,False) then
                FindItem('FILE_NAME',ItemString,UnitString,False);
              if (ItemString<>UpperCase(ExtractFileName(DesiredFilename))) and (ItemString<>'"'+UpperCase(ExtractFileName(DesiredFilename))+'"') then
                begin
                  ShowMessage('Warning: image name in PDS label ('+ItemString+') does not match requested file name ('+ExtractFileName(DesiredFilename)+')' );
                end;
            end;
          if FindItem('NULL',ItemString,UnitString,False) then
            NoRawDataValue := ExtendedValue(ItemString)
          else if FindItem('MISSING_CONSTANT',ItemString,UnitString,False) and (ItemString='16#FF7FFFFB#') then
            NoRawDataValue := -3.40282265508890445E38;
        end;
      end;

 // Default unit in calling routine is METER
    if Mission=Kaguya then
      RawDataToKmMultiplier := 1
    else if FindItem('UNIT',ItemString,UnitString,False) then
      begin
        if (ItemString='KILOMETER') then
          RawDataToKmMultiplier := 1
        else if (ItemString='MILLIMETER') then
          RawDataToKmMultiplier := 0.000001;
      end;

    if FindItem('A_AXIS_RADIUS',A_AXIS_RADIUS,UnitString,True) then
      RefHeightKm := Round(100*ExtendedValue(A_AXIS_RADIUS))/100; // discard least significant digits in single format

    if (not (Mission=Kaguya)) and FindItem('OFFSET',ItemString,UnitString,False) then
      begin
        RawDataOffset := RawDataToKmMultiplier*ExtendedValue(ItemString);
//        ShowMessage(Format('Processing OFFSET = %0.3f km vs. RefHt = %0.3f km',[RawDataOffset,RefHeightKm]));
        if RawDataOffset>(0.5*RefHeightKm) then
          RefHeightKm := RawDataOffset  // MOLA and LOLA give raw data base height as "OFFSET", probably ignoring A_AXIS_RADIUS
        else // Kaguya/SELENE gives "OFFSET=0" apparently meaning deviations are referenced to A_AXIS_RADIUS
          RefHeightKm := RefHeightKm + RawDataOffset;  // meaning of a small offset is unclear, but might mean this
      end;

    if FindItem('SCALING_FACTOR',ItemString,UnitString,False) then
      begin
//        ShowMessage(Format('Processing SCALING_FACTOR = %s with RawDataToKmMultiplier = %0.3f km',[ItemString,RawDataToKmMultiplier]));
//        ShowMessage(Format('Processing SCALING_FACTOR = %0.3f with RawDataToKmMultiplier = %0.3f km',[ExtendedValue(ItemString),RawDataToKmMultiplier]));
        RawDataToKmMultiplier := ExtendedValue(ItemString)*RawDataToKmMultiplier;
//        ShowMessage(Format('RawDataToKmMultiplier : %0.3f',[RawDataToKmMultiplier]));
      end;

    if FindItem('MINIMUM',ItemString,UnitString,False) then
      MinRawDataValue := ExtendedValue(ItemString)
    else if FindItem('VALID_MINIMUM',ItemString,UnitString,False) then
      MinRawDataValue := ExtendedValue(ItemString);
    if FindItem('MAXIMUM',ItemString,UnitString,False) then
      MaxRawDataValue := ExtendedValue(ItemString)
    else if FindItem('VALID_MAXIMUM',ItemString,UnitString,False) then
      MaxRawDataValue := ExtendedValue(ItemString);

  //  ShowMessage('Header bytes: '+IntToStr(NumHeaderBytes));

    if not FindItem('LINE_SAMPLES',ItemString,UnitString,True) then Exit;
    NumLons := IntegerValue(ItemString);
    if not FindItem('LINES',ItemString,UnitString,True) then Exit;
    NumLats := IntegerValue(ItemString);
    if not FindItem('SAMPLE_BITS',ItemString,UnitString,True) then Exit;
    BytesPerDataItem := IntegerValue(ItemString) div 8;

    if not FindItem('SAMPLE_TYPE',ItemString,UnitString,True) then Exit;
    if ((ItemString='"IEEE REAL"') or (ItemString='IEEE_REAL')) and (BytesPerDataItem=8) then
      RawDataType := ReversedDoubleData
    else if ((ItemString='4BYTE_FLOAT') or (ItemString='PC_REAL')) and (BytesPerDataItem=4) then
      RawDataType := SingleData
    else if (ItemString='MSB_INTEGER') and (BytesPerDataItem=2) then
      RawDataType := ReversedSmallIntData
    else if (ItemString='MSB_INTEGER') and (BytesPerDataItem=4) then
      RawDataType := ReversedLongIntData
    else if (ItemString='LSB_UNSIGNED_INTEGER') and (BytesPerDataItem=2) then
      RawDataType := WordData
    else if (ItemString='LSB_INTEGER') and (BytesPerDataItem=2) then
      RawDataType := SmallIntData
    else if (ItemString='LSB_INTEGER') and (BytesPerDataItem=4) then
      RawDataType := LongIntData
    else if BytesPerDataItem=1 then
      RawDataType := ByteData
    else
      begin
        ShowMessage(Format('Unsupported data type "%s", %d bytes',[ItemString,BytesPerDataItem]));
        Exit;
      end;

    if FindItem('MAP_PROJECTION_TYPE',MapProjection,UnitString,False) and (MapProjection='"POLAR STEREOGRAPHIC"') then
      begin
        StereographicProjection := True;

        if (FindItem('B_AXIS_RADIUS',ItemString,UnitString,False)) and (ItemString<>A_AXIS_RADIUS) then
          begin
            ShowMessage('Unsupported polar projection (on ellpsoid)');
            Exit;
          end;

        if NumLons<>NumLats then
          begin
            if FindItem('LINE_LAST_PIXEL',ItemString,UnitString,False) then NumLats := IntegerValue(ItemString);
            if FindItem('SAMPLE_LAST_PIXEL',ItemString,UnitString,False) then NumLons := IntegerValue(ItemString);
          end;

        if NumLons<>NumLats then
          begin
            ShowMessage('Unsupported polar projection (unequal number of horizontal/vertical samples)');
            Exit;
          end;

        if not (FindItem('CENTER_LATITUDE',ItemString,UnitString,False)) then Exit;
        StereoCenterLatRad := ExtendedValue(ItemString);
        if Abs(StereoCenterLatRad)<>90 then
          begin
            ShowMessage('Unsupported polar projection (center latitude other than +90° or -90°)');
            Exit;
          end;
        StereoCenterLatRad := StereoCenterLatRad*OneDegree;

        if not (FindItem('MAP_SCALE',ItemString,UnitString,False)) then Exit;
        KmPerPixel := ExtendedValue(ItemString); 
        if (UpperCase(UnitString)='M') or (UpperCase(UnitString)='M/PIX') or (UpperCase(UnitString)='M/PIXEL') then KmPerPixel := 0.001*KmPerPixel;

        A_radius := ExtendedValue(A_AXIS_RADIUS);
        StereoScaleFactor := 2*A_radius/KmPerPixel;

        LatStepRad := KmPerPixel/A_radius;

        if FindItem('MAP_PROJECTION_ROTATION',ItemString,UnitString,False) then
          StereoLamba0Rad := ExtendedValue(ItemString)*OneDegree  // not sure if this is correct for LOLA DEM's as there are no examples with this <>0
        else
          StereoLamba0Rad := 0;

        StereoCenterIndex := 0.5 + NumLons/2; // index at center of Stored_SingleDEM_data from 0..(NumLons-1)

      // the following are used for the DEM Info display only
        if FindItem('MAXIMUM_LATITUDE',ItemString,UnitString,False) then
          FirstLatRad := OneDegree*ExtendedValue(ItemString)
        else
          FirstLatRad := 0;
        if FindItem('MINIMUM_LATITUDE',ItemString,UnitString,False) then
          LastLatRad := OneDegree*ExtendedValue(ItemString)
        else
          LastLatRad := 0;

      end
    else
      begin  // Simple Cylindrical Projection
      // Note: FirstLon, FirstLat and LonStep, LatStep are used to locate data in array
      //  FirstLon and FirstLat refer to *center* longitude, latitude of first element in array

      // LastLon and Last Lat are not used except for consistency checking.
      // If they are also centers, then they are separated by 1 step length less than the number of rows or columns

        if not FindItem('EASTERNMOST_LONGITUDE',ItemString,UnitString,True) then Exit;
        LastLonRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('WESTERNMOST_LONGITUDE',ItemString,UnitString,True) then Exit;
        FirstLonRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MAXIMUM_LATITUDE',ItemString,UnitString,True) then Exit;
        FirstLatRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MINIMUM_LATITUDE',ItemString,UnitString,True) then Exit;
        LastLatRad := OneDegree*ExtendedValue(ItemString);

        if FindItem('MAP_RESOLUTION',ItemString,UnitString,False) then
          StepsPerRadian := ExtendedValue(ItemString)/OneDegree
        else
          StepsPerRadian := 0;

        if StepsPerRadian>0 then
          begin
            MapStep := 1/StepsPerRadian;
            if Abs(Round((LastLonRad - FirstLonRad)*StepsPerRadian))=NumLons then
              begin // values refer to edges of cells -- adjust to centers
                FirstLonRad := FirstLonRad + 0.5*MapStep*Sign(LastLonRad - FirstLonRad);
                LastLonRad  := LastLonRad  - 0.5*MapStep*Sign(LastLonRad - FirstLonRad);
              end;
            if Abs(Round((LastLatRad - FirstLatRad)*StepsPerRadian))=NumLats then
              begin // values refer to edges of cells -- adjust to centers
                FirstLatRad := FirstLatRad + 0.5*MapStep*Sign(LastLatRad - FirstLatRad);
                LastLatRad  := LastLatRad  - 0.5*MapStep*Sign(LastLatRad - FirstLatRad);
              end;
          end;

        LonStepRad := (LastLonRad - FirstLonRad)/(NumLons - 1);
        LatStepRad := (LastLatRad - FirstLatRad)/(NumLats - 1);
      end;

// following information (not in attached PDS headers) found in Lunar Consortium *.lab files prepared by ??
    if ExtractFileName(DesiredFilename)='apo_far.img' then
      begin
        RefHeightKm := 1738;  // actually Wu 1984 datum which deviates around this mean?
        RawDataToKmMultiplier := 0.001;  // *.lab file says "1"
        NoRawDataValue := -32768;
        DEM_info.Add(Format('Guessing reference ht = %0.3f km, scale factor = %0.3f and raw no data value = %0.3f',[RefHeightKm,RawDataToKmMultiplier,NoRawDataValue]));
      end
    else if ExtractFileName(DesiredFilename)='apo_near.img' then
      begin
        RefHeightKm := 1738;  // actually Wu 1984 datum which deviates around this mean?
        RawDataToKmMultiplier := 0.001;  // *.lab file says "1"
        NoRawDataValue := -32768;
        DEM_info.Add(Format('Guessing reference ht = %0.3f km, scale factor = %0.3f and raw no data value = %0.3f',[RefHeightKm,RawDataToKmMultiplier,NoRawDataValue]));
      end
    else if ExtractFileName(DesiredFilename)='apo_lalt.img' then
      begin
        RefHeightKm := 1730;
        RawDataToKmMultiplier := 0.0627;
        NoRawDataValue := 0;
        DEM_info.Add(Format('Guessing reference ht = %0.3f km, scale factor = %0.3f and raw no data value = %0.3f',[RefHeightKm,RawDataToKmMultiplier,NoRawDataValue]));
      end
    else if ExtractFileName(DesiredFilename)='comb_alt.img' then
      begin
        RefHeightKm := 1720;
        RawDataToKmMultiplier := 0.001;
        NoRawDataValue := -32768;
        DEM_info.Add(Format('Guessing reference ht = %0.3f km, scale factor = %0.3f and raw no data value = %0.3f',[RefHeightKm,RawDataToKmMultiplier,NoRawDataValue]));
      end;

    Result := True;
  end;  {ReadPDS_Header}

function ReadISIS_Header : Boolean;
  var
    StepsPerRadian, MapStep : Extended;

  function FindItem(const SearchString : String; var DataString : String; const DisplayWarning : Boolean) : Boolean;
  // reads Infile until identifier field = SearchString
    var
      Infile : TextFile;
      DataLine, StringToFind : String;
      EndFound : Boolean;
    begin {FindItem}
      Result := False;
      EndFound := False;

      StringToFind := UpperCase(SearchString);

      AssignFile(Infile,NameOfFileToRead);
      Reset(Infile);

      while (not EOF(Infile)) and (not EndFound) and (not Result) do
        begin
          Readln(Infile,DataLine);
          DataLine := UpperCase(DataLine);  // all PDS headers seem to be in uppercase, but do this to be sure
          EndFound := Trim(DataLine)='END';
          DataString := Trim(LeadingElement(DataLine,'='));   // extract identifier field
          Result := DataString=StringToFind;
        end;

      if Result then
        begin
  //        DataLine is now part after identifier, following '='
          DataString := Trim(LeadingElement(DataLine,'<')); // number sometimes followed by <xxx>  indicating units
        end
      else if DisplayWarning then
        ShowMessage('"'+SearchString+'" not found');

      CloseFile(Infile);

    end;  {FindItem}

  begin {ReadISIS_Header}
    Result := False;

    NameOfFileToRead := DesiredFilename;
{
    if FindItem('Object',ItemString,False) then
      ShowMessage('Object = '+ItemString)
    else
      ShowMessage('"Object" not found');
}
    if FindItem('Object',ItemString,False) and (ItemString=UpperCase('IsisCube')) then
      begin // read new format ISIS header
        NoRawDataValue := ExtendedValue('-3.4028226550889045e+038');  // fixed value for ISIS single precision data

        if not FindItem('StartByte',ItemString,True) then Exit;
        NumHeaderBytes := IntegerValue(ItemString) - 1;

        if (FindItem('Format',ItemString,True)) and (ItemString<>UpperCase('BandSequential')) then
          begin
            ShowMessage(ItemString+' storage format not supported');
            Exit;
          end;

  //      if not FindItem('Base',ItemString,True) then Exit;     // "Base" is used for computed height deviation -- it is not the main reference height
        if not FindItem('Multiplier',ItemString,True) then Exit;
        RawDataToKmMultiplier := ExtendedValue(ItemString)/1000;

        if not FindItem('Samples',ItemString,True) then Exit;
        NumLons := IntegerValue(ItemString);
        if not FindItem('Lines',ItemString,True) then Exit;
        NumLats := IntegerValue(ItemString);

        if not FindItem('Type',ItemString,True) then Exit;
        if (ItemString='REAL') then
          begin
            RawDataType := SingleData;
            BytesPerDataItem := 4;
          end
        else
          begin
            ShowMessage(Format('Unsupported data type "%s", %d bytes',[ItemString,BytesPerDataItem]));
            Exit;
          end;

        if not FindItem('EquatorialRadius',ItemString,True) then Exit;
        RefHeightKm := ExtendedValue(ItemString)/1000; // ISIS data in meters

        RawDataToKmMultiplier := 0.001;

      // Note: FirstLon, FirstLat and LonStep, LatStep are used to locate data in array
      //  FirstLon and FirstLat refer to *center* longitude, latitude of first element in array

      // LastLon and Last Lat are not used except for consistency checking.
      // If they are also centers, then they are separated by 1 step length less than the number of rows or columns

        if not FindItem('MinimumLongitude',ItemString,True) then Exit;
        FirstLonRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MaximumLongitude',ItemString,True) then Exit;
        LastLonRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MaximumLatitude',ItemString,True) then Exit;
        FirstLatRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MinimumLatitude',ItemString,True) then Exit;
        LastLatRad := OneDegree*ExtendedValue(ItemString);

        if FindItem('Scale',ItemString,False) then
          StepsPerRadian := ExtendedValue(ItemString)/OneDegree
        else
          StepsPerRadian := 0;
      end   // read new format ISIS header
    else
      begin // read new format ISIS header
        if not FindItem('RECORD_BYTES',ItemString,True) then Exit;
        NumHeaderBytes := IntegerValue(ItemString);
        if not FindItem('^QUBE',ItemString,True) then Exit;
        NumHeaderBytes := NumHeaderBytes*(IntegerValue(ItemString) - 1); // skip over 1 less than ^QUBE records
  //      ShowMessage('Header bytes: '+IntToStr(NumHeaderBytes));

  //      if not FindItem('Base',ItemString,True) then Exit;   // "Base" is used for computed height deviation -- it is not the main reference height
        if not FindItem('CORE_MULTIPLIER',ItemString,True) then Exit;
        RawDataToKmMultiplier := ExtendedValue(ItemString)/1000;

        if not FindItem('CORE_ITEMS',ItemString,True) then Exit;   // ItemString of format "(SAMPLE,LINE,BAND)"
        ItemString := Substring(Trim(ItemString),2,MaxInt);
        NumLons := IntegerValue(LeadingElement(ItemString,','));
        NumLats := IntegerValue(LeadingElement(ItemString,','));

        if not FindItem('CORE_ITEM_BYTES',ItemString,True) then Exit;
        BytesPerDataItem := IntegerValue(ItemString);
        if not FindItem('CORE_ITEM_TYPE',ItemString,True) then Exit;
        if (ItemString='SUN_INTEGER') and (BytesPerDataItem=2) then
          begin
            RawDataType := ReversedSmallIntData;
          end
        else
          begin
            ShowMessage(Format('Unsupported data type "%s", %d bytes',[ItemString,BytesPerDataItem]));
            Exit;
          end;

        if FindItem('CORE_NULL',ItemString,False) then NoRawDataValue := ExtendedValue(ItemString);

        if not FindItem('A_AXIS_RADIUS',ItemString,True) then Exit;
        RefHeightKm := ExtendedValue(ItemString); // generally in km

      // Note: FirstLon, FirstLat and LonStep, LatStep are used to locate data in array
      //  FirstLon and FirstLat refer to *center* longitude, latitude of first element in array

      // LastLon and Last Lat are not used except for consistency checking.
      // If they are also centers, then they are separated by 1 step length less than the number of rows or columns

        if not FindItem('WESTERNMOST_LONGITUDE',ItemString,True) then Exit;
        FirstLonRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('EASTERNMOST_LONGITUDE',ItemString,True) then Exit;
        LastLonRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MAXIMUM_LATITUDE',ItemString,True) then Exit;
        FirstLatRad := OneDegree*ExtendedValue(ItemString);
        if not FindItem('MINIMUM_LATITUDE',ItemString,True) then Exit;
        LastLatRad := OneDegree*ExtendedValue(ItemString);

        if FindItem('MAP_RESOLUTION',ItemString,False) then
          StepsPerRadian := ExtendedValue(ItemString)/OneDegree
        else
          StepsPerRadian := 0;
      end;   // read new format ISIS header

    if StepsPerRadian>0 then
      begin
        MapStep := 1/StepsPerRadian;
        if Abs(Round((LastLonRad - FirstLonRad)*StepsPerRadian))=NumLons then
          begin // values refer to edges of cells -- adjust to centers
            FirstLonRad := FirstLonRad + 0.5*MapStep*Sign(LastLonRad - FirstLonRad);
            LastLonRad  := LastLonRad  - 0.5*MapStep*Sign(LastLonRad - FirstLonRad);
          end;
        if Abs(Round((LastLatRad - FirstLatRad)*StepsPerRadian))=NumLats then
          begin // values refer to edges of cells -- adjust to centers
            FirstLatRad := FirstLatRad + 0.5*MapStep*Sign(LastLatRad - FirstLatRad);
            LastLatRad  := LastLatRad  - 0.5*MapStep*Sign(LastLatRad - FirstLatRad);
          end;
      end;

    LonStepRad := (LastLonRad - FirstLonRad)/(NumLons - 1);
    LatStepRad := (LastLatRad - FirstLatRad)/(NumLats - 1);

    Result := True;
  end;  {ReadISIS_Header}

function ReadBIL_Header : Boolean;
  var
    Text_file : Text;
    DataLine, DataItem : String;

  function FindBIL_Item(const SearchString : String; var DataString : String; const DisplayWarning : Boolean) : Boolean;
  // reads Infile until identifier field = SearchString
    var
      Infile : TextFile;
    begin {FindItem}
      Result := False;

      AssignFile(Infile,NameOfFileToRead);
      Reset(Infile);

      while (not EOF(Infile)) and (not Result) do
        begin
          Readln(Infile,DataLine);
          DataLine := UpperCase(DataLine);  // all PDS headers seem to be in uppercase, but do this to be sure
          DataString := Trim(LeadingElement(DataLine,' '));   // extract identifier field
          Result := DataString=SearchString;
        end;

      if Result then
        DataString := Trim(LeadingElement(DataLine,' ')) // value is sometimes followed by space and "/* comment"
      else if DisplayWarning then
        ShowMessage('"'+SearchString+'" not found');

      CloseFile(Infile);

    end;  {FindItem}

  begin {ReadBIL_Header}
    Result := False;

    NameOfFileToRead := ChangeFileExt(DesiredFilename,'.hdr');
    if not FileExists(NameOfFileToRead) then
      begin
        ShowMessage('Unable to find '+NameOfFileToRead);
        Exit;
      end;
    if not FindBIL_Item('NROWS',ItemString,True) then Exit;
    NumLats := IntegerValue(ItemString);
    if not FindBIL_Item('NCOLS',ItemString,True) then Exit;
    NumLons := IntegerValue(ItemString);
    if not FindBIL_Item('NBITS',ItemString,True) then Exit;
    BytesPerDataItem := IntegerValue(ItemString) div 8;
    if BytesPerDataItem=2 then NoRawDataValue := -32768;  // arbitrary guess, seems to apply to USGS Apollo Historics
    if not FindBIL_Item('BYTEORDER',ItemString,True) then Exit;
    if (ItemString='I') and (BytesPerDataItem=2) then
      RawDataType := WordData
    else if (ItemString='M') and (BytesPerDataItem=2) then
      RawDataType := ReversedSmallIntData
    else
      begin
        ShowMessage(Format('Unsupported data type "%s", %d bytes',[ItemString,BytesPerDataItem]));
        Exit;
      end;
    if FindBIL_Item('SKIPBYTES',ItemString,False) then  NumHeaderBytes := IntegerValue(ItemString);

    NameOfFileToRead := ChangeFileExt(DesiredFilename,'.BLW');
// this optional file consists of anumeric values, one per line, in a fixed sequence
    if not FileExists(NameOfFileToRead) then
      begin
        ShowMessage('Unable to find '+NameOfFileToRead);
        Exit;
      end;
    AssignFile(Text_file,NameOfFileToRead);
    Reset(Text_file);
    Readln(Text_file,DataLine);
    LonStepRad := OneDegree*ExtendedValue(DataLine);
    Readln(Text_file,DataLine);  //Rotation term (always zero)
    Readln(Text_file,DataLine);  //Rotation term (always zero)
    Readln(Text_file,DataLine);
    LatStepRad := OneDegree*ExtendedValue(DataLine);
    Readln(Text_file,DataLine);
    FirstLonRad := OneDegree*ExtendedValue(DataLine);
    Readln(Text_file,DataLine);
    FirstLatRad := OneDegree*ExtendedValue(DataLine);

    LastLonRad := FirstLonRad + (NumLons -1)*LonStepRad;
    LastLatRad := FirstLatRad + (NumLats -1)*LatStepRad;

    CloseFile(Text_file);

    NameOfFileToRead := ChangeFileExt(DesiredFilename,'.STX');
// this optional file consists of a single line with numeric values in a fixed order, separated by spaces
    if FileExists(NameOfFileToRead) then
      begin
        AssignFile(Text_file,NameOfFileToRead);
        Reset(Text_file);
        Readln(Text_file,DataLine);
        DataItem := LeadingElement(DataLine,' ');
        MinRawDataValue := ExtendedValue(LeadingElement(DataLine,' '));
        MaxRawDataValue := ExtendedValue(LeadingElement(DataLine,' '));
        CloseFile(Text_file);
      end;

    if ExtractFileName(DesiredFilename)='Apo_near.bil' then
      begin
        RefHeightKm := 1738;  // actually Wu 1984 datum which deviates around this mean?
        NoRawDataValue := -32768;
        DEM_info.Add(Format('Guessing reference ht = %0.3f km and raw no data value = %0.3f',[RefHeightKm,NoRawDataValue]));
      end
    else if (ExtractFileName(DesiredFilename)='hdrl_dem.bil') or (ExtractFileName(DesiredFilename)='litt_dem.bil') then
      begin
        NoRawDataValue := 0;
        DEM_info.Add(Format('Guessing raw no data value = %0.3f',[NoRawDataValue]));
      end;

    Result := True;
  end;  {ReadBIL_Header}

procedure FinishFileSelection;
  begin
    LTVT_Form.StatusLine_Label.Caption := '';
    LTVT_Form.StatusLine_Label.Repaint;
    LTVT_Form.Abort_Button.Hide;
    LTVT_Form.ProgressBar1.Hide;
    LTVT_Form.DrawCircles_CheckBox.Show;
    LTVT_Form.MarkCenter_CheckBox.Show;

    if LTVT_Form.AbortKeyPressed then
      ClearStorage
    else
      begin
        FileOpen := True;
        Filename := DesiredFilename;
        Result := True;
      end;

  end;

begin {TDemData.SelectFile}
  Result := False;
  FileOpen := False;
//  Filename := '';  // DON'T DO THIS!
  ClearStorage;
  DEM_info.Clear;

// the following information if not supplied in the data file may or may not be correct
  StereographicProjection := False;
  Mission := Unknown;
  NumHeaderBytes := 0;
  NoRawDataValue := DummyDataValue;
  RawDataToKmMultiplier := 0.001;
  RefHeightKm := MoonRadius;
  MinRawDataValue := DummyDataValue;
  MaxRawDataValue := DummyDataValue;

  if not FileExists(DesiredFilename) then
    begin
      ShowMessage('Unable to find '+DesiredFilename);
      Exit;
    end;

  DEM_info.Add('File name: '+DesiredFilename);

  StartTime := Now;

  if UpperCase(ExtractFileExt(DesiredFilename))='.BIL' then
    begin
     if not ReadBIL_Header then Exit;
    end
  else if UpperCase(ExtractFileExt(DesiredFilename))='.CUB' then
    begin
      if not ReadISIS_Header then Exit;
    end
  else
    begin
     if not ReadPDS_Header then Exit;
    end;

//  ShowMessage('DEM Header decoded');

  DEM_info.Add('');
  if DisplayTimings then DEM_info.Add(Format('Time to read header : %0.3f sec',[(Now - StartTime)*OneDay]));

  AssignFile(ByteFile,DesiredFilename);
  Reset(ByteFile,1);  // set record size to 1 byte

  NumBytes := FileSize(ByteFile);
  NumDataBytes := NumBytes - NumHeaderBytes;
  ExpectedDataBytes := BytesPerDataItem*NumLons*NumLats;
  if NumDataBytes<ExpectedDataBytes then
    begin
      ShowMessage(Format('File size error: %d data bytes found vs. %d expected',[NumDataBytes,ExpectedDataBytes]));
      CloseFile(ByteFile);
      Exit;
    end;

//  ShowMessage(Format('Prepared to skip %d header bytes',[NumHeaderBytes]));

  if NumHeaderBytes>0 then
    begin
      SetLength(ByteRow,NumHeaderBytes); // set to exact length needed
      Blockread(ByteFile,ByteRow[0],NumHeaderBytes);
      SetLength(ByteRow,0); // free memory
    end;

//  ShowMessage('Header bytes skipped');

  StartTime := Now;

  LTVT_Form.StatusLine_Label.Caption := 'Allocating memory for DEM';;
  LTVT_Form.StatusLine_Label.Repaint;

  case RawDataType of
    SmallIntData, ReversedSmallIntData :
      begin
        SmallIntStorageFormat := True;
        BytesNeeded := 1.0*NumLons*NumLats*SizeOf(Stored_SmallIntDEM_data[0,0]); // without 1.0, computation range limited to Integer
      end;
    else
      begin
        SmallIntStorageFormat := False;
        BytesNeeded := 1.0*NumLons*NumLats*SizeOf(Stored_SingleDEM_data[0,0]); // without 1.0, computation range limited to Integer
      end;
    end;

  if MemoryAvailable(BytesNeeded) or (mrOK=MessageDlg('Memory allocation may fail; proceed anyway?',mtConfirmation,mbOKCancel,0)) then
    try
      case RawDataType of
        SmallIntData, ReversedSmallIntData :
          SetLength(Stored_SmallIntDEM_data,NumLats,NumLons);
        else
          SetLength(Stored_SingleDEM_data,NumLats,NumLons);
        end;
    except
      ClearStorage;
      NumLons := 0;
      NumLats := 0;
      ShowMessage(Format('Unable to allocate %0.3f MB memory for DEM',[BytesNeeded/OneMB]));
      CloseFile(ByteFile);
      FinishFileSelection;
      Exit;
    end
  else
    begin
      ClearStorage;
      NumLons := 0;
      NumLats := 0;
      CloseFile(ByteFile);
      FinishFileSelection;
      Exit;
    end;

  if DisplayTimings then
    begin
      DEM_info.Add(Format('Time to allocate %0.3f MB memory : %0.3f sec',[BytesNeeded/OneMB,(Now - StartTime)*OneDay]));
      DEM_info.Add('');
    end;

  StartTime := Now;

  LTVT_Form.StatusLine_Label.Caption := 'Reading DEM file                ';
  LTVT_Form.StatusLine_Label.Repaint;
  LTVT_Form.Abort_Button.Show;
  LTVT_Form.DrawCircles_CheckBox.Hide;
  LTVT_Form.MarkCenter_CheckBox.Hide;
  LTVT_Form.AbortKeyPressed := False;
  LTVT_Form.ProgressBar1.Max := NumLats;
  LTVT_Form.ProgressBar1.Position := 0;
  LTVT_Form.ProgressBar1.Show;
  LTVT_Form.ProcessMessages;

  try
    case RawDataType of
      SingleData :
        begin
          DEM_info.Add('Data format: 32-bit reals (LSB first)');
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,Stored_SingleDEM_data[LatNum-1,0],NumLons*BytesPerDataItem,NumRead);
              if RawDataToKmMultiplier<>1 then for LonNum := 1 to NumLons do
                begin
                  Stored_SingleDEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Stored_SingleDEM_data[LatNum-1,LonNum-1];  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
        end;
      WordData :
        begin
          DEM_info.Add('Data format: 16-bit unsigned integers (LSB first)');
          SetLength(WordRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,WordRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  Stored_SingleDEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*WordRow[LonNum-1];  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
          SetLength(WordRow,0);
        end;
      SmallIntData :
        begin
          DEM_info.Add('Data format: 16-bit signed integers (LSB first)');
//          SetLength(SmallIntRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,Stored_SmallIntDEM_data[LatNum-1,0],NumLons*BytesPerDataItem,NumRead);
              LTVT_Form.ProcessMessages;
            end;
//          SetLength(SmallIntRow,0);
        end;
      LongIntData :
        begin
          DEM_info.Add('Data format: 32-bit signed integers (LSB first)');
          SetLength(LongIntRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,LongIntRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  Stored_SingleDEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*LongIntRow[LonNum-1];  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
          SetLength(LongIntRow,0);
        end;
      ReversedSmallIntData :
        begin
          DEM_info.Add('Data format: 16-bit signed integers (MSB first)');
          SetLength(ReversedSmallIntRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,ReversedSmallIntRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  TwoByteArray[1] := ReversedSmallIntRow[LonNum-1,2];
                  TwoByteArray[2] := ReversedSmallIntRow[LonNum-1,1];
                  Stored_SmallIntDEM_data[LatNum-1,LonNum-1] := Smallint(TwoByteArray);  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
          SetLength(ReversedSmallIntRow,0);
        end;
      ReversedLongIntData :
        begin
          DEM_info.Add('Data format: 32-bit signed integers (MSB first)');
          SetLength(ReversedLongIntRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,ReversedLongIntRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  FourByteArray[1] := ReversedLongIntRow[LonNum-1,4];
                  FourByteArray[2] := ReversedLongIntRow[LonNum-1,3];
                  FourByteArray[3] := ReversedLongIntRow[LonNum-1,2];
                  FourByteArray[4] := ReversedLongIntRow[LonNum-1,1];
                  Stored_SingleDEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Longint(FourByteArray);  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
          SetLength(ReversedLongIntRow,0);
        end;
      ReversedDoubleData :
        begin
          DEM_info.Add('Data format: 64-bit reals (MSB first)');
          SetLength(ReversedDoubleRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,ReversedDoubleRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  EightByteArray[1] := ReversedDoubleRow[LonNum-1,8];
                  EightByteArray[2] := ReversedDoubleRow[LonNum-1,7];
                  EightByteArray[3] := ReversedDoubleRow[LonNum-1,6];
                  EightByteArray[4] := ReversedDoubleRow[LonNum-1,5];
                  EightByteArray[5] := ReversedDoubleRow[LonNum-1,4];
                  EightByteArray[6] := ReversedDoubleRow[LonNum-1,3];
                  EightByteArray[7] := ReversedDoubleRow[LonNum-1,2];
                  EightByteArray[8] := ReversedDoubleRow[LonNum-1,1];
                  Stored_SingleDEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Double(EightByteArray);  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
          SetLength(ReversedDoubleRow,0);
        end;
      ByteData :
        begin
          DEM_info.Add('Data format: 8-bit unsigned integers');
          SetLength(ByteRow,NumLons);
          for LatNum := 1 to NumLats do if not LTVT_Form.AbortKeyPressed then
            begin
              LTVT_Form.ProgressBar1.Position := LatNum;
              Blockread(ByteFile,ByteRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  Stored_SingleDEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*ByteRow[LonNum-1];  // convert to [km]
                end;
              LTVT_Form.ProcessMessages;
            end;
          SetLength(ByteRow,0);
        end;
      else
      end;

  except
    ClearStorage;
    CloseFile(ByteFile);
    FinishFileSelection;
    Exit;
  end;

  CloseFile(ByteFile);

  DEM_info.Add('Number of header bytes: '+IntToStr(NumHeaderBytes));
  DEM_info.Add('');

  if DisplayTimings then
    DEM_info.Add(Format('Time to read DEM : %0.3f sec',[(Now - StartTime)*OneDay]));

  ValidNoDataValue := NoRawDataValue<>DummyDataValue;

  NoDataValue := RawDataToKmMultiplier*NoRawDataValue;

  MinHtLonNum := -1;
  MinHtLatNum := -1;
  MaxHtLonNum := -1;
  MaxHtLatNum := -1;

  if (MinRawDataValue=DummyDataValue) or (MaxRawDataValue=DummyDataValue) then
    begin
      StartTime := Now;

      LTVT_Form.StatusLine_Label.Caption := 'Searching for maximum elevation...';
      LTVT_Form.StatusLine_Label.Repaint;
      LTVT_Form.ProgressBar1.Position := 0;

      MinHtDeviationKm := 999999;
      MaxHtDeviationKm := -999999;
      for LatNum := 0 to (NumLats - 1) do if not LTVT_Form.AbortKeyPressed then
        begin
          LTVT_Form.ProgressBar1.Position := LatNum;
          for LonNum := 0 to (NumLons - 1) do
            begin
              if SmallIntStorageFormat then
                DataValue := RawDataToKmMultiplier*Stored_SmallIntDEM_data[LatNum,LonNum]
              else
                DataValue := Stored_SingleDEM_data[LatNum,LonNum];
              if (not ValidNoDataValue) or (DataValue<>NoDataValue) then
                begin
                  if DataValue<MinHtDeviationKm then
                    begin
                      MinHtLonNum := LonNum;
                      MinHtLatNum := LatNum;
                      MinHtDeviationKm := DataValue;
                    end;
                  if DataValue>MaxHtDeviationKm then
                    begin
                      MaxHtLonNum := LonNum;
                      MaxHtLatNum := LatNum;
                      MaxHtDeviationKm := DataValue;
                    end;
                end
              else {ValidNoDataValue AND (DataValue=NoDataValue)}
                if (Mission=Kaguya) then
                // clean up NoDataValue data which occurs only on the first row of the north polar and last row of the south polar Kaguya DEM
                  begin
                    if LatNum=0 then
                      Stored_SingleDEM_data[0,LonNum] := Stored_SingleDEM_data[1,LonNum]
                    else if LatNum=(NumLats - 1) then
                      Stored_SingleDEM_data[LatNum,LonNum] := Stored_SingleDEM_data[LatNum-1,LonNum];
                  end;
                // otherwise ignore non-data value in evaluating min and max
            end;
          LTVT_Form.ProcessMessages;
        end;

    // after this clean-up there are no missing data

      if DisplayTimings then
        DEM_info.Add(Format('Time to find maximum height deviation : %0.3f sec',[(Now - StartTime)*OneDay]));

    end
  else
    begin
      MinHtDeviationKm := RawDataToKmMultiplier*MinRawDataValue;
      MaxHtDeviationKm := RawDataToKmMultiplier*MaxRawDataValue;
    end;

  with DEM_info do
    begin
      if DisplayTimings then Add('');
      if StereographicProjection then
        begin
          Add(Format('Polar stereographic projection: %d x %d array centered on latitude %0.3f°',[NumLons, NumLats, StereoCenterLatRad/OneDegree]));
          StereoEdgeLatDeg := Sign(StereoCenterLatRad)*(PiByTwo - 2*ArcTan((NumLons/2)/StereoScaleFactor))/OneDegree;
          StereoCornerLatDeg := Sign(StereoCenterLatRad)*(PiByTwo - 2*ArcTan(Sqrt(Sqr(NumLons/2)+Sqr(NumLats/2))/StereoScaleFactor))/OneDegree;
          Add(Format('Latitude = %0.3f° at left-right/top-bottom edges; %0.3f° at extreme corners of array',[StereoEdgeLatDeg,StereoCornerLatDeg]));
        end
      else
        begin
          Add(Format('Number of lines (latitudes) : %d in steps of %0.6f°',[NumLats,LatStepRad/OneDegree]));
          Add(Format('Number of samples per line (longitudes) : %d in steps of %0.6f°',[NumLons,LonStepRad/OneDegree]));
          Add('');
          LeftLonDeg := LTVT_Form.PosNegDegrees((FirstLonRad-0.5*LonStepRad)/OneDegree,LTVT_Form.PlanetaryLongitudeConvention);
          RightLonDeg := LeftLonDeg + (NumLons*LonStepRad)/OneDegree; // insures RightLonDeg numerically larger than LeftLonDeg
          Add(Format('Longitude range (edge to edge) : %0.6f° left to %0.6f° right',[LeftLonDeg,RightLonDeg]));
          Add(Format('Latitude range (edge to edge) : %0.6f° top to %0.6f° bottom',
            [(FirstLatRad-0.5*LatStepRad)/OneDegree,(FirstLatRad+(NumLats - 0.5)*LatStepRad)/OneDegree]));
        end;
      Add('');
      Add(Format('Base height : %0.3f km',[RefHeightKm]));
      Add(Format('Scale factor (raw height deviation data to kilometers) : %0.6f',[RawDataToKmMultiplier]));
      if ValidNoDataValue then Add(Format('Scaled no data value : %0.3f',[NoDataValue]));
      Add('');
      if MinHtLonNum>=0 then
        Add(Format('Minimum height deviation: %0.3f km; found at Line %d, Sample %d',[MinHtDeviationKm,MinHtLatNum+1,MinHtLonNum+1]))
      else
        Add(Format('Minimum height deviation: %0.3f km (as listed in file header)',[MinHtDeviationKm]));
      if MaxHtLonNum>=0 then
        Add(Format('Maximum height deviation: %0.3f km; found at Line %d, Sample %d',[MaxHtDeviationKm,MaxHtLatNum+1,MaxHtLonNum+1]))
      else
        Add(Format('Maximum height deviation: %0.3f km (as listed in file header)',[MaxHtDeviationKm]));
      if LTVT_Form.AbortKeyPressed then
        begin
          Add('');
          Add('*** loading of DEM aborted by user ***');
        end;
    end;

  FinishFileSelection;

end;  {TDemData.SelectFile}

function TDemData.ReadHeight(const LonRad, LatRad : Extended; var Height : Extended) : Boolean;
var
  LatNum, LonNum : Integer;
  AdjustedLon, HeightData : Single;
  Rho : Extended;
begin
  Result := False;
  Height := 0;

  if not FileOpen then Exit;

  if StereographicProjection then
    begin
      if Abs(LatRad - StereoCenterLatRad)>PiByTwo then Exit;
      Rho := StereoScaleFactor*Tan((PiByTwo - Abs(LatRad))/2);
      LonNum := Round(StereoCenterIndex + Rho*Sin(LonRad - StereoLamba0Rad));
      if (LonNum<0) or (LonNum>=NumLons) then Exit;
      LatNum := Round(StereoCenterIndex + Sign(StereoCenterLatRad)*Rho*Cos(LonRad - StereoLamba0Rad));
      if (LatNum<0) or (LatNum>=NumLats) then Exit;
    end
  else
    begin
      LatNum := Round((LatRad - FirstLatRad)/LatStepRad);
      if (LatNum<0) or (LatNum>=NumLats) then Exit;

      AdjustedLon := LonRad;

      LonNum := Round((AdjustedLon - FirstLonRad)/LonStepRad);
      if (LonNum<0) then
        begin // check if longitude can be placed in acceptable range by adding 360°
          AdjustedLon := AdjustedLon + Sign(LonStepRad)*TwoPi;
          LonNum := Round((AdjustedLon - FirstLonRad)/LonStepRad);
          if (LonNum<0) or (LonNum>=NumLons) then Exit;
        end
      else if (LonNum>=NumLons) then
        begin  // check if longitude can be placed in acceptable range by subtracting 360°
          AdjustedLon := AdjustedLon - Sign(LonStepRad)*TwoPi;
          LonNum := Round((AdjustedLon - FirstLonRad)/LonStepRad);
          if (LonNum<0) or (LonNum>=NumLons) then Exit;
        end;
    end;

  if SmallIntStorageFormat then
    HeightData := RawDataToKmMultiplier*Stored_SmallIntDEM_data[LatNum,LonNum]
  else
    HeightData := Stored_SingleDEM_data[LatNum,LonNum];

  if ValidNoDataValue and (HeightData=NoDataValue) then
    Exit
  else
    begin
      Height := RefHeightKm + HeightData;
      Result := True;
    end;
end;


end.
