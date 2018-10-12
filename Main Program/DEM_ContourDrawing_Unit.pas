unit DEM_ContourDrawing_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, StdCtrls, ExtCtrls;

type
  TDEM_ContourDrawing_Form = class(TForm)
    ContourIntervalMeters_LabeledNumericEdit: TLabeledNumericEdit;
    Contour_ColorBox: TColorBox;
    Close_Button: TButton;
    DrawContours_Button: TButton;
    ClearContours_Button: TButton;
    BaseLevel_LabeledNumericEdit: TLabeledNumericEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DrawContours_ButtonClick(Sender: TObject);
    procedure Close_ButtonClick(Sender: TObject);
    procedure ClearContours_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    SavedImage : TBitMap;

  end;

var
  DEM_ContourDrawing_Form: TDEM_ContourDrawing_Form;

implementation

uses Math, MoonPosition {MoonRadius}, LTVT_Unit, Win_Ops;

{$R *.dfm}

procedure TDEM_ContourDrawing_Form.FormActivate(Sender: TObject);
begin
  if SavedImage<>nil then SavedImage.Free;
  SavedImage := TBitmap.Create;
  SavedImage.Assign(LTVT_Form.Image1.Picture.Bitmap);
  ActiveControl := DrawContours_Button;
end;

procedure TDEM_ContourDrawing_Form.FormDeactivate(Sender: TObject);
begin
  if SavedImage<>nil then
    begin
      SavedImage.FreeImage;
      SavedImage := nil;
    end;
end;

procedure TDEM_ContourDrawing_Form.DrawContours_ButtonClick(Sender: TObject);
var
  I, J, CurrentHeightNumber, FollowingHeightNumber, PixelCount : Integer;
  CurrentHeightValid, FollowingHeightValid : Boolean;
  ContourColor : TColor;
  BaseLevel, ContourInterval : Extended; // [km]

function DetermineHeightContour(const X, Y : Integer; var ContourNumber : Integer) : Boolean;
  var
    ProjectedX, ProjectedY, Lon, Lat, DEM_height : Extended;
  begin

  with LTVT_Form do
    begin
      if (DrawingMode=Dem_3D) then
        begin
          DEM_height := MoonRadius+SurfaceData[X,Y].HeightDev_km;
          Result := DEM_height<>SurfaceData_NoDataValue;
        end
      else
        begin
          with Image1 do
            begin
              ProjectedX := XValue(X);
              ProjectedY := YValue(Y);
            end;

          if ConvertXYtoLonLat(ProjectedX,ProjectedY,Lon,Lat) then
            begin
              Result := DEM_data.ReadHeight(Lon,Lat,DEM_height);
            end
          else
            Result := False;
        end;

      if Result then
        ContourNumber := Floor((DEM_height - BaseLevel)/ContourInterval)
      else
        ContourNumber := 0;
    end;
  end;

begin {TDEM_ContourDrawing_Form.DrawContours_ButtonClick}
  if not LTVT_Form.DEM_data.FileOpen then
    begin
      ShowMessage('The Digital Elevation Model has not been opened'+CR+'click the DEM button in the main window to open it');
    end
  else
    begin
      ContourColor := Contour_ColorBox.Selected;
      BaseLevel := BaseLevel_LabeledNumericEdit.NumericEdit.ExtendedValue;
      ContourInterval := ContourIntervalMeters_LabeledNumericEdit.NumericEdit.ExtendedValue;

      PixelCount := 0;

      with LTVT_Form do
        begin
          Screen.Cursor := crHourGlass;
        // scan lines horizontally
          for J := 0 to (Image1.Height-1) do
            begin
              FollowingHeightValid := DetermineHeightContour(0,J,FollowingHeightNumber);
              for I := 0 to (Image1.Width-2) do
                begin
                  CurrentHeightNumber := FollowingHeightNumber;
                  CurrentHeightValid := FollowingHeightValid;
                  FollowingHeightValid := DetermineHeightContour(I+1,J,FollowingHeightNumber);
                  if CurrentHeightValid and FollowingHeightValid and (CurrentHeightNumber<>FollowingHeightNumber) then
                    begin
                      Image1.Canvas.Pixels[I,J] := ContourColor;
                      Inc(PixelCount);
                    end;
                end;
            end;

        // scan lines vertically
          for I := 0 to (Image1.Width-1) do
            begin
              FollowingHeightValid := DetermineHeightContour(I,0,FollowingHeightNumber);
              for J := 0 to (Image1.Height-2) do
                begin
                  CurrentHeightNumber := FollowingHeightNumber;
                  CurrentHeightValid := FollowingHeightValid;
                  FollowingHeightValid := DetermineHeightContour(I,J+1,FollowingHeightNumber);
                  if CurrentHeightValid and FollowingHeightValid and (CurrentHeightNumber<>FollowingHeightNumber) then
                    begin
                      Image1.Canvas.Pixels[I,J] := ContourColor;
                      Inc(PixelCount);
                    end;
                end;
            end;

          Screen.Cursor := DefaultCursor;

          if PixelCount=0 then ShowMessage('No contours found');

        end;
    end;
end;  {TDEM_ContourDrawing_Form.DrawContours_ButtonClick}

procedure TDEM_ContourDrawing_Form.ClearContours_ButtonClick(
  Sender: TObject);
begin
  if SavedImage<>nil then LTVT_Form.Image1.Canvas.Draw(0,0,SavedImage);
end;

procedure TDEM_ContourDrawing_Form.Close_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDEM_ContourDrawing_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    Close
  else
    LTVT_Form.DisplayF1Help(Key,Shift,'ContourDrawingTool.htm');
end;

end.
