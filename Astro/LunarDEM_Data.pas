unit LunarDEM_Data;
{Reads the Kaguya Laser Altimeter DEM data in PDS format distributed by JAXA.

                                                               Nov. 24, 2009}

interface

type
  TKaguyaData = class(TObject)
  private
    NoDataValue : Single;
    NumBytes, NumLons, NumLats : Integer;
    DEM_data : array of array of Single;
  public
    FileOpen, DisplayTimings : Boolean;
    InputFilename : String;
    FirstLon, LastLon, FirstLat, LastLat, MinHtData, MaxHtData : Single;  {[deg], [km] deviation from RefHeight}
    RefHeight : Extended;
    LonStep, LatStep : Extended;  {[deg]}

    constructor Create;
    destructor Destroy;   override;
    procedure Clear;
     {release memory}
    function SelectFile(const DesiredFilename : String) : Boolean;
     {Returns true if file successfully opened and data initialized}
    function ReadHeight(const LonDeg, LatDeg : Extended; var Height : Extended) : Boolean;
     {Returns true if able to recover total height, in kilometers, from Center of Mass.  Returns
      false if point is off the grid.}
  end;

implementation

uses Dialogs, SysUtils, Win_Ops;

constructor TKaguyaData.Create;     { this goes after implementation }
begin
  inherited;
{start custom stuff}
  FileOpen := False;
  DisplayTimings := False;
end;

destructor TKaguyaData.Destroy;
begin
  Clear;
  inherited;
end;

procedure TKaguyaData.Clear;
begin
  SetLength(DEM_data,0,0);
end;

function TKaguyaData.SelectFile(const DesiredFilename : String) : Boolean;
var
  ByteFile: file;  // untyped
  NumHeaderBytes,
  NumDataBytes, LatNum, LonNum, NumRead : Integer;
  HeaderBytes, NumLonsData, NumLatsData, RefHeightData, DataValue : Single;
  DataLine : String;
  StartTime, ElapsedTime : TDateTime;

function FindItem(const SearchString : String; var SearchItemValue : Single) : Boolean;
// reads Infile until DataLine contains SearchString
  var
    Infile : TextFile;
    DataString : String;
    EndFound : Boolean;
  begin
    Result := False;
    EndFound := False;

    AssignFile(Infile,InputFilename);
    Reset(Infile);

    while (not EOF(Infile)) and (not EndFound) and (not Result) do
      begin
        Readln(Infile,DataLine);
        EndFound := Trim(DataLine)='END';
        Result := (Pos(SearchString,DataLine)>0);
      end;
    if Result then
      begin
        DataString := LeadingElement(DataLine,'='); // number follows = usually surrounded by spaces
        DataString := LeadingElement(DataLine,'<'); // <xxx> sometimes follows number indicating units
        SearchItemValue := ExtendedToSingle(ExtendedValue(DataString));
      end
    else
      ShowMessage('"'+SearchString+'" not found');

    CloseFile(Infile);

  end;

begin
  Result := False;
  FileOpen := False;
  SetLength(DEM_data,0,0);

  if not FileExists(DesiredFilename) then
    begin
      ShowMessage('Unable to find '+DesiredFilename);
      Exit;
    end;

  InputFilename := DesiredFilename;

  StartTime := Now;

// read PDS header

  if not FindItem('^IMAGE',HeaderBytes) then Exit;
  NumHeaderBytes := Round(HeaderBytes) - 1;
//  ShowMessage('Header bytes: '+IntToStr(NumHeaderBytes));

  if not FindItem('LINE_SAMPLES',NumLonsData) then Exit;
  if not FindItem('LINES',NumLatsData) then Exit;
  if not FindItem('DUMMY_DATA',NoDataValue) then Exit;
  if not FindItem('A_AXIS_RADIUS',RefHeightData) then Exit;
  if not FindItem('EASTERNMOST_LONGITUDE',LastLon) then Exit;
  if not FindItem('WESTERNMOST_LONGITUDE',FirstLon) then Exit;
  if not FindItem('MAXIMUM_LATITUDE',FirstLat) then Exit;
  if not FindItem('MINIMUM_LATITUDE',LastLat) then Exit;

  NumLons := Round(NumLonsData);
  NumLats := Round(NumLatsData);

  LonStep := (LastLon - FirstLon)/(NumLons - 1);
  LatStep := (LastLat - FirstLat)/(NumLats - 1);

  RefHeight := Round(100*RefHeightData)/100; // discard least significant digits in single format

  AssignFile(ByteFile,InputFilename);
  Reset(ByteFile,1);

  NumBytes := FileSize(ByteFile);
  NumDataBytes := NumBytes - NumHeaderBytes;
  if NumDataBytes<>(4*NumLons*NumLats) then
    begin
      ShowMessage(Format('File size error: %d  vs. %d',[NumDataBytes,Round(NumLons*NumLats)]));
      Exit;
    end;

  SetLength(DEM_data,NumLats,NumLons);

  Blockread(ByteFile,DEM_data[0,0],NumHeaderBytes,NumRead);
  for LatNum := 1 to NumLats do Blockread(ByteFile,DEM_data[LatNum-1,0],NumLons*4,NumRead);
  CloseFile(ByteFile);

  if DisplayTimings then
    begin
      ElapsedTime := (Now - StartTime)*86400;
      ShowMessage(Format('Time to load DEM: %0.3f sec',[ElapsedTime]));
    end;

  FileOpen := True;
  Result := True;

  StartTime := Now;
  MinHtData := 999;
  MaxHtData := -999;
  for LatNum := 0 to (NumLats - 1) do
    for LonNum := 0 to (NumLons - 1) do
      begin
        DataValue := DEM_data[LatNum,LonNum];
        if DataValue<>NoDataValue then
          begin
            if DataValue<MinHtData then MinHtData := DataValue;
            if DataValue>MaxHtData then MaxHtData := DataValue;
          end
        else // clean up missing data which occurs only on the first row of the north polar and last row of the south polar DEM
          begin
            if LatNum=0 then
              DEM_data[0,LonNum] := DEM_data[1,LonNum]
            else if LatNum=(NumLats - 1) then
              DEM_data[LatNum,LonNum] := DEM_data[LatNum-1,LonNum];
          end;
      end;

// after this clean-up there are no missing data
  if DisplayTimings then
    begin
      ElapsedTime := (Now - StartTime)*86400;
      ShowMessage(Format('Time to evaluate min/max: %0.3f sec',[ElapsedTime]));
    end;

end;

function TKaguyaData.ReadHeight(const LonDeg, LatDeg : Extended; var Height : Extended) : Boolean;
var
  LatNum, LonNum : Integer;
  HeightData : Single;
begin
  Result := False;
  Height := 0;

  if not FileOpen then Exit;

  LatNum := Round((LatDeg - FirstLat)/LatStep);
  if (LatNum<0) or (LatNum>=NumLats) then Exit;

  LonNum := Round((LonDeg - FirstLon)/LonStep);
// wrap longitudes (lines) around, assuming they span a full circle
  while LonNum<0 do LonNum := LonNum + NumLons;
  while LonNum>=NumLons do LonNum := LonNum - NumLons;

  HeightData := DEM_data[LatNum,LonNum];
  Height := RefHeight + HeightData;

  Result := True;
end;


end.
