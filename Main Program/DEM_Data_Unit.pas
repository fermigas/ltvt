unit DEM_Data_Unit;
{reads DEM data in several formats}

interface

type
  TDemData = class(TObject)
  private
    Stored_DEM_data : array of array of Single;  // in [km] as deviation from RefHeightKm
    ValidNoDataValue : Boolean;
    NoDataValue : Single;
    NumLons, NumLats : Integer;
  public
    FileOpen, DisplayTimings : Boolean;
    InputFilename : String;
    RefHeightKm,
    LonStepRad, LatStepRad,  {[rad]}
    FirstLonRad, FirstLatRad, // *center* of first sample in first line (upper left of image) in [rad]
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

uses MoonPosition {MoonRadius}, LTVT_Unit, Constnts, Math, Dialogs, Controls {mrOK}, SysUtils, Win_Ops,
  PopupMemo;

constructor TDemData.Create;     { this goes after implementation }
begin
  inherited;
{start custom stuff}
  FileOpen := False;
  InputFilename := '';
  DisplayTimings := False;
end;

destructor TDemData.Destroy;
begin
  ClearStorage;
  inherited;
end;

procedure TDemData.ClearStorage;
begin
  SetLength(Stored_DEM_data,0,0);
end;

function TDemData.SelectFile(const DesiredFilename : String) : Boolean;
const
  DummyDataValue = -999999;
var
  NameOfFileToRead : String;
  Mission : (Kaguya, Apollo, Unknown);
  RawDataType : (ReversedDoubleData, SingleData, WordData, ReversedSmallIntData, ReversedLongIntData, ByteData);
  TestFile : file of Char;
  TestChar : Char;
  ByteFile : file;  // untyped
  ByteRow : array of Byte; // unsigned 8-bit integers
  WordRow : array of Word; // unsigned 16-bit integers
  ReversedSmallIntRow : array of array[1..2] of Byte;  // signed integers
  ReversedLongIntRow : array of array[1..4] of Byte;   // signed integers
  ReversedDoubleRow : array of array[1..8] of Byte;
  TwoByteArray : array[1..2] of Byte;
  FourByteArray : array[1..4] of Byte;
  EightByteArray : array[1..8] of Byte;
  CharsRead, NumHeaderBytes, BytesPerDataItem, NumDataBytes, NumBytes,
  LatNum, LonNum, NumRead,
  MinHtLonNum, MinHtLatNum, MaxHtLonNum, MaxHtLatNum : Integer;
  DataValue, NoRawDataValue, MinRawDataValue, MaxRawDataValue : Single;
  LastLonRad, LastLatRad,
  LeftLonDeg, RightLonDeg, // for ShowDemInfo display
  RawDataOffset,
  RawDataToKmMultiplier : Extended;
  ItemString : String;
  StartTime : TDateTime;
  ASCII_file_detected : Boolean;
  BytesNeeded : Currency;

function ReadPDS_Header : Boolean;
  var
    MissionName : String;
    StepsPerRadian, MapStep : Extended;

  function FindItem(const SearchString : String; var DataString : String; const DisplayWarning : Boolean) : Boolean;
  // reads Infile until identifier field = SearchString
    var
      Infile : TextFile;
      DataLine : String;
      EndFound : Boolean;
    begin {FindItem}
//      ShowMessage('Looking for '+SearchString);

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
        end
      else if DisplayWarning then
        ShowMessage('"'+SearchString+'" not found');

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
        NameOfFileToRead := ChangeFileExt(DesiredFilename,'.lbl');
        if not FileExists(NameOfFileToRead) then
          begin
            ShowMessage('Unable to find PDS label information');
            Exit;
          end;
      end;

    if FindItem('MISSION_NAME',MissionName,False) and (MissionName='SELENE') then
      Mission := Kaguya
    else
      Mission := Unknown;

    case Mission of
      Kaguya:
        begin  // items unique to Kaguya records
          if not FindItem('^IMAGE',ItemString,True) then Exit;
          NumHeaderBytes := IntegerValue(ItemString) - 1;
          if not FindItem('DUMMY_DATA',ItemString,True) then Exit;
          NoRawDataValue := ExtendedValue(ItemString);
        end;
      else
        begin
          if ASCII_file_detected then
            begin
              if not FindItem('RECORD_BYTES',ItemString,True) then Exit;
              NumHeaderBytes := IntegerValue(ItemString);
              if not FindItem('^IMAGE',ItemString,True) then Exit;
              NumHeaderBytes := NumHeaderBytes*(IntegerValue(ItemString) - 1);
            end
          else
            begin
              NumHeaderBytes := 0;
              if not FindItem('^IMAGE',ItemString,True) then Exit;
              if (ItemString<>UpperCase(ExtractFileName(DesiredFilename))) and (ItemString<>'"'+UpperCase(ExtractFileName(DesiredFilename))+'"') then
                begin
                  ShowMessage('Image name in PDS label ('+ItemString+') does not match requested file name ('+ExtractFileName(DesiredFilename)+')' );
                  Exit;
                end;
            end;
          if FindItem('NULL',ItemString,False) then
            NoRawDataValue := ExtendedValue(ItemString)
          else if FindItem('MISSING_CONSTANT',ItemString,False) and (ItemString='16#FF7FFFFB#') then
            NoRawDataValue := -3.40282265508890445E38;
        end;
      end;

 // Default unit in calling routine is METER
    if Mission=Kaguya then
      RawDataToKmMultiplier := 1
    else if FindItem('UNIT',ItemString,False) then
      begin
        if (ItemString='KILOMETER') then
          RawDataToKmMultiplier := 1
        else if (ItemString='MILLIMETER') then
          RawDataToKmMultiplier := 0.000001;
      end;

    if FindItem('SCALING_FACTOR',ItemString,False) then RawDataToKmMultiplier := ExtendedValue(ItemString)*RawDataToKmMultiplier;

// note: 'OFFSET' handled below after reading A_AXIS

    if FindItem('MINIMUM',ItemString,False) then
      MinRawDataValue := ExtendedValue(ItemString)
    else if FindItem('VALID_MINIMUM',ItemString,False) then
      MinRawDataValue := ExtendedValue(ItemString);
    if FindItem('MAXIMUM',ItemString,False) then
      MaxRawDataValue := ExtendedValue(ItemString)
    else if FindItem('VALID_MAXIMUM',ItemString,False) then
      MaxRawDataValue := ExtendedValue(ItemString);

  //  ShowMessage('Header bytes: '+IntToStr(NumHeaderBytes));

    if not FindItem('LINE_SAMPLES',ItemString,True) then Exit;
    NumLons := IntegerValue(ItemString);
    if not FindItem('LINES',ItemString,True) then Exit;
    NumLats := IntegerValue(ItemString);
    if not FindItem('SAMPLE_BITS',ItemString,True) then Exit;
    BytesPerDataItem := IntegerValue(ItemString) div 8;

    if not FindItem('SAMPLE_TYPE',ItemString,True) then Exit;
    if ((ItemString='"IEEE REAL"') or (ItemString='IEEE_REAL')) and (BytesPerDataItem=8) then
      RawDataType := ReversedDoubleData
    else if ((ItemString='4BYTE_FLOAT') or (ItemString='PC_REAL')) and (BytesPerDataItem=4) then
      RawDataType := SingleData
    else if (ItemString='MSB_INTEGER') and (BytesPerDataItem=2) then
      RawDataType := ReversedSmallIntData
    else if (ItemString='MSB_INTEGER') and (BytesPerDataItem=4) then
      RawDataType := ReversedLongIntData
    else if BytesPerDataItem=1 then
      RawDataType := ByteData
    else
      begin
        ShowMessage(Format('Unsupported data type "%s", %d bytes',[ItemString,BytesPerDataItem]));
        Exit;
      end;

    if FindItem('A_AXIS_RADIUS',ItemString,True) then
      RefHeightKm := Round(100*ExtendedValue(ItemString))/100; // discard least significant digits in single format

    if (not (Mission=Kaguya)) and FindItem('OFFSET',ItemString,False) then
      begin
        RawDataOffset := RawDataToKmMultiplier*ExtendedValue(ItemString);
//        ShowMessage(Format('Processing OFFSET = %0.3f km vs. RefHt = %0.3f km',[RawDataOffset,RefHeightKm]));
        if RawDataOffset>(0.5*RefHeightKm) then
          RefHeightKm := RawDataOffset  // MOLA and LOLA give raw data base height as "OFFSET", probably ignoring A_AXIS_RADIUS
        else // Kaguya/SELENE gives "OFFSET=0" apparently meaning deviations are referenced to A_AXIS_RADIUS
          RefHeightKm := RefHeightKm + RawDataOffset;  // meaning of a small offset is unclear, but might mean this
      end;

  // Note: FirstLon, FirstLat and LonStep, LatStep are used to locate data in array
  //  FirstLon and FirstLat refer to *center* longitude, latitude of first element in array

  // LastLon and Last Lat are not used except for consistency checking.
  // If they are also centers, then they are separated by 1 step length less than the number of rows or columns

    if not FindItem('EASTERNMOST_LONGITUDE',ItemString,True) then Exit;
    LastLonRad := OneDegree*ExtendedValue(ItemString);
    if not FindItem('WESTERNMOST_LONGITUDE',ItemString,True) then Exit;
    FirstLonRad := OneDegree*ExtendedValue(ItemString);
    if not FindItem('MAXIMUM_LATITUDE',ItemString,True) then Exit;
    FirstLatRad := OneDegree*ExtendedValue(ItemString);
    if not FindItem('MINIMUM_LATITUDE',ItemString,True) then Exit;
    LastLatRad := OneDegree*ExtendedValue(ItemString);

    if FindItem('MAP_RESOLUTION',ItemString,False) then
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

// following information (not in attached PDS headers) found in Lunar Consortium *.lab files prepared by ??
    if ExtractFileName(DesiredFilename)='apo_far.img' then
      begin
        RefHeightKm := 1738;  // actually Wu 1984 datum which deviates around this mean?
        RawDataToKmMultiplier := 0.001;  // *.lab file says "1"
        NoRawDataValue := -32768;
      end
    else if ExtractFileName(DesiredFilename)='apo_near.img' then
      begin
        RefHeightKm := 1738;  // actually Wu 1984 datum which deviates around this mean?
        RawDataToKmMultiplier := 0.001;  // *.lab file says "1"
        NoRawDataValue := -32768;
      end
    else if ExtractFileName(DesiredFilename)='apo_lalt.img' then
      begin
        RefHeightKm := 1730;
        RawDataToKmMultiplier := 0.0627;
        NoRawDataValue := 0;
      end
    else if ExtractFileName(DesiredFilename)='comb_alt.img' then
      begin
        RefHeightKm := 1720;
        RawDataToKmMultiplier := 0.001;
        NoRawDataValue := -32768;
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
      end
    else if (ExtractFileName(DesiredFilename)='hdrl_dem.bil') or (ExtractFileName(DesiredFilename)='litt_dem.bil') then
      NoRawDataValue := 0;

    Result := True;
  end;  {ReadBIL_Header}

begin {TDemData.SelectFile}
  Result := False;
  FileOpen := False;
  InputFilename := '';
  ClearStorage;

// the following information if not supplied in the data file may or may not be correct
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

  if LTVT_Form.ShowDemInfo then with LTVT_Form.PopupMemo do
    begin
      Caption := 'Details of DEM file';
      ClearMemoArea;
      Memo.Lines.Add('File name: '+DesiredFilename);
      Memo.Lines.Add('');
      if DisplayTimings then Memo.Lines.Add(Format('Time to read header : %0.3f sec',[(Now - StartTime)*OneDay]));
    end;

  AssignFile(ByteFile,DesiredFilename);
  Reset(ByteFile,1);  // set record size to 1 byte

  NumBytes := FileSize(ByteFile);
  NumDataBytes := NumBytes - NumHeaderBytes;
  if NumDataBytes<(BytesPerDataItem*NumLons*NumLats) then
    begin
      ShowMessage(Format('File size error: %d data bytes found vs. %d expected',[NumDataBytes,Round(NumLons*NumLats)]));
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

  BytesNeeded := 1.0*NumLons*NumLats*SizeOf(Stored_DEM_data[0,0]); // without 1.0, computation range limited to Integer

  if MemoryAvailable(BytesNeeded) or (mrOK=MessageDlg('Memory allocation may fail; proceed anyway?',mtConfirmation,mbOKCancel,0)) then
    try
      SetLength(Stored_DEM_data,NumLats,NumLons);
    except
      ClearStorage;
      NumLons := 0;
      NumLats := 0;
      ShowMessage(Format('Unable to allocate %0.3f MB memory for DEM',[BytesNeeded/OneMB]));
      CloseFile(ByteFile);
      Exit;
    end
  else
    begin
      ClearStorage;
      NumLons := 0;
      NumLats := 0;
      CloseFile(ByteFile);
      Exit;
    end;

  if DisplayTimings and LTVT_Form.ShowDemInfo then
    LTVT_Form.PopupMemo.Memo.Lines.Add(Format('Time to allocate %0.3f MB memory : %0.3f sec',[BytesNeeded/OneMB,(Now - StartTime)*OneDay]));

  StartTime := Now;

  LTVT_Form.StatusLine_Label.Caption := 'Reading DEM file                ';
  LTVT_Form.StatusLine_Label.Repaint;

  try
    case RawDataType of
      SingleData :
        for LatNum := 1 to NumLats do
          begin
            Blockread(ByteFile,Stored_DEM_data[LatNum-1,0],NumLons*BytesPerDataItem,NumRead);
            if RawDataToKmMultiplier<>1 then for LonNum := 1 to NumLons do
              begin
                Stored_DEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Stored_DEM_data[LatNum-1,LonNum-1];  // convert to [km]
              end;
          end;
      WordData :
        begin
          SetLength(WordRow,NumLons);
          for LatNum := 1 to NumLats do
            begin
              Blockread(ByteFile,WordRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  Stored_DEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*WordRow[LonNum-1];  // convert to [km]
                end;
            end;
          SetLength(WordRow,0);
        end;
      ReversedSmallIntData :
        begin
          SetLength(ReversedSmallIntRow,NumLons);
          for LatNum := 1 to NumLats do
            begin
              Blockread(ByteFile,ReversedSmallIntRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  TwoByteArray[1] := ReversedSmallIntRow[LonNum-1,2];
                  TwoByteArray[2] := ReversedSmallIntRow[LonNum-1,1];
                  Stored_DEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Smallint(TwoByteArray);  // convert to [km]
                end;
            end;
          SetLength(ReversedSmallIntRow,0);
        end;
      ReversedLongIntData :
        begin
          SetLength(ReversedLongIntRow,NumLons);
          for LatNum := 1 to NumLats do
            begin
              Blockread(ByteFile,ReversedLongIntRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  FourByteArray[1] := ReversedLongIntRow[LonNum-1,4];
                  FourByteArray[2] := ReversedLongIntRow[LonNum-1,3];
                  FourByteArray[3] := ReversedLongIntRow[LonNum-1,2];
                  FourByteArray[4] := ReversedLongIntRow[LonNum-1,1];
                  Stored_DEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Longint(FourByteArray);  // convert to [km]
                end;
            end;
          SetLength(ReversedLongIntRow,0);
        end;
      ReversedDoubleData :
        begin
          SetLength(ReversedDoubleRow,NumLons);
          for LatNum := 1 to NumLats do
            begin
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
                  Stored_DEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*Double(EightByteArray);  // convert to [km]
                end;
            end;
          SetLength(ReversedDoubleRow,0);
        end;
      ByteData :
        begin
          SetLength(ByteRow,NumLons);
          for LatNum := 1 to NumLats do
            begin
              Blockread(ByteFile,ByteRow[0],NumLons*BytesPerDataItem,NumRead);
              for LonNum := 1 to NumLons do
                begin
                  Stored_DEM_data[LatNum-1,LonNum-1] := RawDataToKmMultiplier*ByteRow[LonNum-1];  // convert to [km]
                end;
            end;
          SetLength(ByteRow,0);
        end;
      else
      end;

  except
    ClearStorage;
    CloseFile(ByteFile);
    Exit;
  end;

  CloseFile(ByteFile);

  if DisplayTimings and LTVT_Form.ShowDemInfo then
    LTVT_Form.PopupMemo.Memo.Lines.Add(Format('Time to read DEM : %0.3f sec',[(Now - StartTime)*OneDay]));

  FileOpen := True;
  InputFilename := DesiredFilename;
  Result := True;

  ValidNoDataValue := NoRawDataValue<>DummyDataValue;

  NoDataValue := RawDataToKmMultiplier*NoRawDataValue;

  MinHtLonNum := -1;
  MinHtLatNum := -1;
  MaxHtLonNum := -1;
  MaxHtLatNum := -1;

  if (MinRawDataValue=DummyDataValue) or (MaxRawDataValue=DummyDataValue) then
    begin
      StartTime := Now;

      LTVT_Form.StatusLine_Label.Caption := 'Searching for maximum elevation...';;
      LTVT_Form.StatusLine_Label.Repaint;

      MinHtDeviationKm := 999999;
      MaxHtDeviationKm := -999999;
      for LatNum := 0 to (NumLats - 1) do
        for LonNum := 0 to (NumLons - 1) do
          begin
            DataValue := Stored_DEM_data[LatNum,LonNum];
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
                    Stored_DEM_data[0,LonNum] := Stored_DEM_data[1,LonNum]
                  else if LatNum=(NumLats - 1) then
                    Stored_DEM_data[LatNum,LonNum] := Stored_DEM_data[LatNum-1,LonNum];
                end;
              // otherwise ignore non-data value in evaluating min and max
          end;

    // after this clean-up there are no missing data

      if DisplayTimings and LTVT_Form.ShowDemInfo then
        LTVT_Form.PopupMemo.Memo.Lines.Add(Format('Time to find maximum height deviation : %0.3f sec',[(Now - StartTime)*OneDay]));

    end
  else
    begin
      MinHtDeviationKm := RawDataToKmMultiplier*MinRawDataValue;
      MaxHtDeviationKm := RawDataToKmMultiplier*MaxRawDataValue;
    end;

  if LTVT_Form.ShowDemInfo then with LTVT_Form.PopupMemo do
    begin
      with Memo.Lines do
        begin
          if DisplayTimings then Add('');
          Add(Format('Number of lines (latitudes) : %d in steps of %0.6f°',[NumLats,LatStepRad/OneDegree]));
          Add(Format('Number of samples per line (longitudes) : %d in steps of %0.6f°',[NumLons,LonStepRad/OneDegree]));
          Add('');
          LeftLonDeg := LTVT_Form.PosNegDegrees((FirstLonRad-0.5*LonStepRad)/OneDegree,LTVT_Form.PlanetaryLongitudeConvention);
          RightLonDeg := LeftLonDeg + (NumLons*LonStepRad)/OneDegree; // insures RightLonDeg numerically larger than LeftLonDeg
          Add(Format('Longitude range (edge to edge) : %0.6f° left to %0.6f° right',[LeftLonDeg,RightLonDeg]));
          Add(Format('Latitude range (edge to edge) : %0.6f° top to %0.6f° bottom',
            [(FirstLatRad-0.5*LatStepRad)/OneDegree,(FirstLatRad+(NumLats - 0.5)*LatStepRad)/OneDegree]));
          Add('');
          Add(Format('Base height : %0.3f km',[RefHeightKm]));
          Add(Format('Scale factor (raw height deviation data to kilometers) : %0.3f',[RawDataToKmMultiplier]));
          Add(Format('Scaled no data value : %0.3f',[NoDataValue]));
          Add('');
          if MinHtLonNum>=0 then
            Add(Format('Minimum height deviation: %0.3f km; found at Line %d, Sample %d',[MinHtDeviationKm,MinHtLatNum+1,MinHtLonNum+1]))
          else
            Add(Format('Minimum height deviation: %0.3f km (as listed in file header)',[MinHtDeviationKm]));
          if MaxHtLonNum>=0 then
            Add(Format('Maximum height deviation: %0.3f km; found at Line %d, Sample %d',[MaxHtDeviationKm,MaxHtLatNum+1,MaxHtLonNum+1]))
          else
            Add(Format('Maximum height deviation: %0.3f km (as listed in file header)',[MaxHtDeviationKm]));
        end;
      Show;
    end;
end;  {TDemData.SelectFile}

function TDemData.ReadHeight(const LonRad, LatRad : Extended; var Height : Extended) : Boolean;
var
  LatNum, LonNum : Integer;
  AdjustedLon, HeightData : Single;
begin
  Result := False;
  Height := 0;

  if not FileOpen then Exit;

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

  HeightData := Stored_DEM_data[LatNum,LonNum];

  if ValidNoDataValue and (HeightData=NoDataValue) then
    Exit
  else
    begin
      Height := RefHeightKm + HeightData;
      Result := True;
    end;
end;


end.
