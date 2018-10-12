unit LTO_Viewer_Unit;
{This form calibrates maps from the Lunar and Planetary Institute website.

A calibration consists of developing a formula relating x-y pixel locations to
the lunar longitudes and latitudes indicated on the maps.

The LTO and Topophotomaps cover small areas near the equator.  Because further
details of the Transverse Mercator Projection are not well understood by me,
they are calibrated in a purely empirical fashion.

The LAC charts are in Mercator and Lambert Conformal Projections, for which the
formulas should be well known.  However, as discovered with the LTO's, the images
on the website are slightly rotated and slightly compressed in the vertical
direction.

The first problem is to transform the measured pixel x-y into a system of
corrected x-y values which have expected directions and proportions. 


                                                                 2/19/2007}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, ComCtrls, LabeledNumericEdit, PopupMemo;

type
  TLTO_Viewer_Form = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    LoadPhoto_Button: TButton;
    Filename_Label: TLabel;
    RefPt1_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt1_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    MousePosition_Label: TLabel;
    RefPt1_XPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt1_YPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt1_RadioButton: TRadioButton;
    RefPt1_GroupBox: TGroupBox;
    RefPt2_RadioButton: TRadioButton;
    RefPt2_GroupBox: TGroupBox;
    RefPt2_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_XPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_YPix_LabeledNumericEdit: TLabeledNumericEdit;
    Clear_Button: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    ZoomIn_Button: TButton;
    ZoomOut_Button: TButton;
    OneToOne_Button: TButton;
    CurrentMag_Label: TLabel;
    Zoom_Label: TLabel;
    OpenDialog1: TOpenDialog;
    ImageCalibrated_RadioButton: TRadioButton;
    Label1: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LonLat_Label: TLabel;
    TransferData_Button: TButton;
    MapType_GroupBox: TGroupBox;
    LTO_RadioButton: TRadioButton;
    Mercator_RadioButton: TRadioButton;
    Lambert_RadioButton: TRadioButton;
    VertCompression_LabeledNumericEdit: TLabeledNumericEdit;
    MapType_RadioButton: TRadioButton;
    LambertParallels_Label: TLabel;
    procedure LoadPhoto_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RefPt1_RadioButtonClick(Sender: TObject);
    procedure RefPt2_RadioButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Clear_ButtonClick(Sender: TObject);
    procedure OneToOne_ButtonClick(Sender: TObject);
    procedure ZoomOut_ButtonClick(Sender: TObject);
    procedure ZoomIn_ButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ImageCalibrated_RadioButtonClick(Sender: TObject);
    procedure TransferData_ButtonClick(Sender: TObject);
    procedure LoadPhoto_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ZoomOut_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OneToOne_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ZoomIn_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt1_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt1_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_XPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_YPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt2_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_XPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_YPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ImageCalibrated_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Clear_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TransferData_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LTO_RadioButtonClick(Sender: TObject);
    procedure Mercator_RadioButtonClick(Sender: TObject);
    procedure Lambert_RadioButtonClick(Sender: TObject);
    procedure MapType_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LTO_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Mercator_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Lambert_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Lambert2_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VertCompression_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    MapMode : (LTO, Mercator, Lambert);

    TempPicture : TPicture;
    ImageLoaded : Boolean;
    OriginalWidth, OriginalHeight : Integer;
    WidthMagnification, HeightMagnification, MapWidthDeg : Extended;

// Set by UpdateGeometry
    SinTheta, CosTheta,  // rotation angle
    CenterLonDeg, CenterLatDeg, CenterXPix, CenterYPix,
    VertCorrection,
    HorzPixPerDeg, VertPixPerDeg,
    DegLonPerXPixel, DegLatPerYPixel,
    MercatorScaleFactor, MercatorStartX, MercatorStartY, MercatorStartLonRad,
    Lambert_ScaleFactor, Lambert_Lat1, Lambert_Lat2, Lambert_n, Lambert_F, Lambert_Rho_zero
     : Extended;

    function PixelToX(const Pixel, Width : Integer) : Extended;
    {expresses current position in image on scale of 0..1 based on center of current pixel}

    function XtoPixel(const X : Extended; const Width : Integer) : Integer;
    {converts current position in image on scale of 0..1 to nearest pixel}

    function OrigXPix(const XPix : Integer) : Integer;
    {returns original X pixel location based on XPix at current magnification}

    function OrigYPix(const YPix : Integer) : Integer;
    {returns original Y pixel location based on YPix at current magnification}

    function NewScrollPos(const ControlWidth, StartingScrollPos, StartingImageWidth, NewImageWidth : Integer) : Integer;
    {determines new setting for scroll bar to maintain centering}

    function UpdateGeometry : Boolean;

    procedure DrawCross(const CenterX, CenterY : Integer; const CrossColor : TColor);

    procedure UpdateMagnification(const NewWidth, NewHeight : Integer);

    procedure CorrectXY(var CorrectedXPix, CorrectedYPix : Extended);
    {corrects mouse x-y to values corrected for rotation and vertical compression - works only
     after a successful call to UpdateGeometry}

    procedure UpdateLambertParameters;
    {guesses MapWidthDeg, Lambert_Lat1, and Lambert_Lat2 on basis of specified RefPt1 latitude and y-pixel}

  public
    { Public declarations }
  end;

var
  LTO_Viewer_Form: TLTO_Viewer_Form;

implementation

uses
  FileCtrl, Math, Win_Ops, JPEG, LTVT_Unit, Constnts;

{$R *.dfm}

procedure TLTO_Viewer_Form.FormCreate(Sender: TObject);
begin
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  Filename_Label.Caption := '';
  CurrentMag_Label.Caption := '';
  MousePosition_Label.Caption := '';
  LonLat_Label.Caption := '';
  TransferData_Button.Hide;
  LambertParallels_Label.Hide;


  LTO_RadioButtonClick(Sender);  // make sure a default type has been selected
  MapType_RadioButton.Checked := True;  // selecting a type normally advances to Step 2; correct this to Step 1

  TempPicture := TPicture.Create;
end;

procedure TLTO_Viewer_Form.FormDestroy(Sender: TObject);
begin
  TempPicture.Free;
end;

procedure TLTO_Viewer_Form.UpdateMagnification(const NewWidth, NewHeight : Integer);
var
  OldWidth, OldHeight, OldScrollHorz, OldScrollVert : Integer;
begin
  OldWidth  := Image1.Width;
  OldHeight := Image1.Height;
  OldScrollHorz := ScrollBox1.HorzScrollBar.Position;
  OldScrollVert := ScrollBox1.VertScrollBar.Position;
  Image1.Width  := NewWidth;
  Image1.Height := NewHeight;
  ScrollBox1.HorzScrollBar.Position := NewScrollPos(ScrollBox1.Width,OldScrollHorz,OldWidth,NewWidth);
  ScrollBox1.VertScrollBar.Position := NewScrollPos(ScrollBox1.Height,OldScrollVert,OldHeight,NewHeight);
  WidthMagnification := NewWidth/OriginalWidth;
  HeightMagnification := NewHeight/OriginalHeight;
  CurrentMag_Label.Caption := Format('Current magnification = %0.2f',[WidthMagnification]);
//  Label7.Caption := 'H: '+IntToStr(ScrollBox1.HorzScrollBar.Position)+'   V: '+IntToStr(ScrollBox1.VertScrollBar.Position);
end;

function TLTO_Viewer_Form.PixelToX(const Pixel, Width : Integer) : Extended;
{expresses current position in image on scale of 0..1 based on center of current pixel}
begin
  Result := (Pixel + 0.5)/Width;
end;

function TLTO_Viewer_Form.XtoPixel(const X : Extended; const Width : Integer) : Integer;
{converts current position in image on scale of 0..1 to nearest pixel}
begin
  Result := Trunc(X*Width);
end;

function TLTO_Viewer_Form.OrigXPix(const XPix : Integer) : Integer;
{returns original X pixel location based on XPix at current magnification}
begin
  Result := XtoPixel(PixelToX(XPix,Image1.Width),OriginalWidth);
end;

function TLTO_Viewer_Form.OrigYPix(const YPix : Integer) : Integer;
{returns original Y pixel location based on YPix at current magnification}
begin
  Result := XtoPixel(PixelToX(YPix,Image1.Height),OriginalHeight);
end;

function TLTO_Viewer_Form.NewScrollPos(const ControlWidth, StartingScrollPos, StartingImageWidth, NewImageWidth : Integer) : Integer;
{determines new setting for scroll bar to maintain centering}
var
  ControlHalfWidth : Integer;
  CenterX : Extended;
begin
  if (StartingImageWidth<=ControlWidth) or (NewImageWidth<=ControlWidth) then
    Result := 0
  else
    begin
      ControlHalfWidth := ControlWidth div 2;
      CenterX := PixelToX(StartingScrollPos + ControlHalfWidth,StartingImageWidth);
      Result := XtoPixel(CenterX,NewImageWidth) - ControlHalfWidth;
    end;
end;

procedure TLTO_Viewer_Form.LoadPhoto_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do if Execute then
    begin
      ImageLoaded := False;
      MapType_RadioButton.Checked := True;
      LambertParallels_Label.Hide;

      Screen.Cursor := crHourGlass;
      TRY
        TempPicture.LoadFromFile(FileName);

  // alternative loading procedure from ScreenPixelProfile
        OriginalWidth  := TempPicture.Graphic.Width;
        OriginalHeight := TempPicture.Graphic.Height;
        Image1.Picture.Bitmap.Width  := OriginalWidth;
        Image1.Picture.Bitmap.Height := OriginalHeight;
        Image1.Picture.Bitmap.PixelFormat := pf24bit;
        Image1.Width  := OriginalWidth;
        Image1.Height := OriginalHeight;
        ImageLoaded := True;
      EXCEPT
        OriginalWidth  := 1;
        OriginalHeight := 2;
        ShowMessage('Unable to load "'+FileName+'"');
      END;

      if ImageLoaded then
        begin
//          ShowMessage('Labels visible');
          Clear_Button.Click;
          Filename_Label.Caption := MinimizeName(FileName,Filename_Label.Canvas,Filename_Label.Width);
          UpdateMagnification(OriginalWidth,OriginalHeight);
{
          RefPt1_RadioButton.Show;
          Zoom_Label.Show;
          ZoomOut_Button.Show;
          OneToOne_Button.Show;
          ZoomIn_Button.Show;
          CurrentMag_Label.Show;
}
          TransferData_Button.Hide;
        end;
      Screen.Cursor := crDefault;
    end
  else
    ShowMessage('Action cancelled - no photo loaded');
end;

procedure TLTO_Viewer_Form.CorrectXY(var CorrectedXPix, CorrectedYPix : Extended);
var
  RawXPix, RawYPix : Extended;
begin
  RawXPix := CorrectedXPix;
  RawYPix := CorrectedYPix*VertCorrection;
  CorrectedXPix :=  RawXPix*CosTheta + RawYPix*SinTheta;
  CorrectedYPix := -RawXPix*SinTheta + RawYPix*CosTheta;
end;

procedure TLTO_Viewer_Form.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  RawXPix, RawYPix,
  Rho, LambertTheta, ScaledX, ScaledY,
  Lon, Lat, DelXObs, DelYObs, DelX, DelY : Extended;
begin
  RawXPix := OrigXPix(X);
  RawYPix := OrigYPix(Y);

  MousePosition_Label.Caption := Format('Mouse is at pixel (%0.0f, %0.0f)',[RawXPix, RawYPix]);
  if ImageCalibrated_RadioButton.Checked then
    begin
      case MapMode of
        LTO :
          begin
            DelXObs := RawXPix - CenterXPix;
            DelYObs := RawYPix - CenterYPix;
            DelX :=  DelXObs*CosTheta + DelYObs*SinTheta;
            DelY := -DelXObs*SinTheta + DelYObs*CosTheta;
            Lat := CenterLatDeg + DelY/VertPixPerDeg;
            Lon := CenterLonDeg + DelX/HorzPixPerDeg/Cos(DegToRad(Lat));
            Lat := Lat - LTVT_Form.LTO_SagCorrectionDeg(Lon - CenterLonDeg,Lat);
          end;
        Mercator :
          begin
            CorrectXY(RawXPix,RawYPix);
            Lon := RadToDeg(MercatorStartLonRad + (RawXPix - MercatorStartX)/MercatorScaleFactor);
            Lat := RadToDeg(2*ArcTan(Exp((MercatorStartY - RawYPix)/MercatorScaleFactor)) - PiByTwo);
          end;
        Lambert :
          begin
            CorrectXY(RawXPix,RawYPix);
            ScaledX :=  (RawXPix - CenterXPix)/Lambert_ScaleFactor;
            ScaledY := -(RawYPix - CenterYPix)/Lambert_ScaleFactor;

            Rho := Sign(Lambert_n)*Sqrt(Sqr(ScaledX) + Sqr(Lambert_Rho_zero - ScaledY));
            LambertTheta := ArcTan(ScaledX/(Lambert_Rho_zero - ScaledY));

            Lon := CenterLonDeg + RadToDeg(LambertTheta)/Lambert_n;
            Lat := RadToDeg(2*ArcTan(Power(Lambert_F/Rho,1/Lambert_n)) - PiByTwo);
          end;
        else  // MapMode not implemented
          begin
            Lon := 0;
            Lat := 0;
          end;
        end; {case}
      LonLat_Label.Caption := Format('Lon = %s     Lat = %s',
        [LTVT_Form.LongitudeString(Lon,3),LTVT_Form.LatitudeString(Lat,3)])
    end
  else
    LonLat_Label.Caption := '';
end;

procedure TLTO_Viewer_Form.DrawCross(const CenterX, CenterY : integer; const CrossColor : TColor);
const
  CrossSize = 4;
begin
  with Image1.Canvas do
    begin
      Pen.Color := CrossColor;
      MoveTo(CenterX,CenterY+CrossSize);
      LineTo(CenterX,CenterY-CrossSize);
      MoveTo(CenterX+CrossSize,CenterY);
      LineTo(CenterX-CrossSize,CenterY);
    end;
end;

procedure TLTO_Viewer_Form.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  XPix, YPix : Integer;
begin
  XPix := OrigXPix(X);
  YPix := OrigYPix(Y);
  if RefPt1_RadioButton.Checked then
    begin
      RefPt1_XPix_LabeledNumericEdit.NumericEdit.Text := IntToStr(XPix);
      RefPt1_YPix_LabeledNumericEdit.NumericEdit.Text := IntToStr(YPix);
      DrawCross(XPix,YPix,clRed);

      if MapMode=Lambert then UpdateLambertParameters;  // determine proper MapWidthDeg

      RefPt2_Lon_LabeledNumericEdit.NumericEdit.Text :=
        Format('%0.0f',[RefPt1_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue + MapWidthDeg]);
      RefPt2_Lat_LabeledNumericEdit.NumericEdit.Text := RefPt1_Lat_LabeledNumericEdit.NumericEdit.Text;
      ScrollBox1.HorzScrollBar.Position := Image1.Width;

      RefPt2_RadioButton.Checked := True;
      RefPt2_RadioButton.Show;
    end
  else if RefPt2_RadioButton.Checked then
    begin
      RefPt2_XPix_LabeledNumericEdit.NumericEdit.Text := IntToStr(XPix);
      RefPt2_YPix_LabeledNumericEdit.NumericEdit.Text := IntToStr(YPix);
      DrawCross(XPix,YPix,clAqua);
      ImageCalibrated_RadioButtonClick(Sender);
    end
  else
    ShowMessage('If you are trying to record the pixel location of a reference point, please be sure you have the Step 2 or Step 3 radio button checked');

end;

procedure TLTO_Viewer_Form.RefPt1_RadioButtonClick(Sender: TObject);
begin
  RefPt1_RadioButton.Checked := True;
end;

procedure TLTO_Viewer_Form.RefPt2_RadioButtonClick(Sender: TObject);
begin
  RefPt2_RadioButton.Checked := True;
end;

procedure TLTO_Viewer_Form.UpdateLambertParameters;
{guesses MapWidthDeg, Lambert_Lat1, and Lambert_Lat2 on basis of specified RefPt1 latitude and y-pixel}
var
  Ref1LatDeg, Ref1YPix : Extended;
begin
  Ref1LatDeg := RefPt1_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue;
  Ref1YPix   := RefPt1_YPix_LabeledNumericEdit.NumericEdit.IntegerValue;

  if Ref1YPix<(OriginalHeight/2) then
    Ref1LatDeg := Ref1LatDeg - 1    // RefPt1 in upper part of chart, move down into body
  else
    Ref1LatDeg := Ref1LatDeg + 1;   // RefPt1 in lower part of chart, move down into body

  if Abs(Ref1LatDeg)<48 then
    begin
      Lambert_Lat1 := Sign(Ref1LatDeg)*DegToRad(21 + (20/60)); // place standard parallels in proper hemisphere
      Lambert_Lat2 := Sign(Ref1LatDeg)*DegToRad(42 + (40/60));
    end
  else
    begin
      Lambert_Lat1 := Sign(Ref1LatDeg)*DegToRad(53 + (20/60)); // place standard parallels in proper hemisphere
      Lambert_Lat2 := Sign(Ref1LatDeg)*DegToRad(74 + (40/60));
    end;

  if Abs(Ref1LatDeg)<32 then
    MapWidthDeg := 20
  else if Abs(Ref1LatDeg)<48 then
    MapWidthDeg := 24
  else
    MapWidthDeg := 30;

  LambertParallels_Label.Caption := Format('Lat1 = %0.2f  Lat2 =%0.2f',[RadToDeg(Lambert_Lat1),RadToDeg(Lambert_Lat2)]);
  LambertParallels_Label.Show;
end;

function TLTO_Viewer_Form.UpdateGeometry : Boolean;
var
  Ref1XPix, Ref1YPix, Ref2XPix, Ref2YPix,
  Ref1LonDeg, Ref1LatDeg, Ref2LonDeg, Ref2LatDeg,
  CWThetaRad, VertCompression : Extended;

  function LambertRho(const LatDeg : Extended) : Extended;
    begin
      Result := Lambert_F/Power(Tan((PiByTwo + DegToRad(LatDeg))/2),Lambert_n);
    end;

begin
  Result := False;

  LambertParallels_Label.Hide;

  VertCompression := VertCompression_LabeledNumericEdit.NumericEdit.ExtendedValue;
  if VertCompression<>0 then
    VertCorrection := 1/VertCompression
  else
    VertCorrection := 1;

  Ref1XPix := RefPt1_XPix_LabeledNumericEdit.NumericEdit.IntegerValue;
  Ref1YPix := RefPt1_YPix_LabeledNumericEdit.NumericEdit.IntegerValue;

  Ref2XPix := RefPt2_XPix_LabeledNumericEdit.NumericEdit.IntegerValue;
  Ref2YPix := RefPt2_YPix_LabeledNumericEdit.NumericEdit.IntegerValue;

  Ref1LonDeg := RefPt1_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue;
  Ref1LatDeg := RefPt1_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue;

  Ref2LonDeg := RefPt2_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue;
  Ref2LatDeg := RefPt2_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue;

  if Ref1LatDeg<>Ref2LatDeg then
    begin
      ShowMessage('The two calibration points must have the same latitude');
      RefPt2_RadioButtonClick(Self);
      Exit;
    end;

  if Ref1LonDeg=Ref2LonDeg then
    begin
      ShowMessage('The two calibration points must have different longitudes');
      RefPt2_RadioButtonClick(Self);
      Exit;
    end;

  if Ref1XPix=Ref2XPix then
    begin
      ShowMessage('The two calibration points must have different X-pixel positions');
      RefPt2_RadioButtonClick(Self);
      Exit;
    end;

  CWThetaRad := ArcTan(VertCorrection*(Ref2YPix - Ref1YPix)/(Ref2XPix - Ref1XPix));  // should correct for difference in sag

  SinTheta := Sin(CWThetaRad);
  CosTheta := Cos(CWThetaRad);

  case MapMode of
    LTO :
      begin
        CenterXPix := (Ref1XPix + Ref2XPix)/2;
        CenterYPix := (Ref1YPix + Ref2YPix)/2;

        CenterLonDeg := (Ref1LonDeg + Ref2LonDeg)/2;

        HorzPixPerDeg := (Ref2XPix - Ref1XPix)/(Ref2LonDeg - Ref1LonDeg)/Cos(DegToRad(Ref1LatDeg));
        VertPixPerDeg := -HorzPixPerDeg*VertCorrection;  // minus sign because pixels increase down screen; latitudes decrease down screen

        CenterLatDeg := Ref1LatDeg + LTVT_Form.LTO_SagCorrectionDeg(Ref2LonDeg - CenterLonDeg,Ref1LatDeg);
      end;
    Mercator :
      begin
        CorrectXY(Ref1XPix,Ref1YPix);
        CorrectXY(Ref2XPix,Ref2YPix);
        MercatorScaleFactor := (Ref2XPix - Ref1XPix)/DegToRad((Ref2LonDeg - Ref1LonDeg));
  //      ShowMessage(Format('Scale factor = %0.3f',[MercatorScaleFactor]));
        MercatorStartX := (Ref1XPix + Ref2XPix)/2;
        MercatorStartY := (Ref1YPix + Ref2YPix)/2 + MercatorScaleFactor*Ln(Tan( (PiByTwo + DegToRad(Ref1LatDeg))/2 ));
        MercatorStartLonRad := DegToRad((Ref1LonDeg + Ref2LonDeg)/2);
      end;
    Lambert :
      begin
        CenterLonDeg := (Ref1LonDeg + Ref2LonDeg)/2; // note: this is in degrees!
        CenterLatDeg := 0;   // note: this is in degrees!
        UpdateLambertParameters;
        Lambert_n := Ln(Cos(Lambert_Lat1)/Cos(Lambert_Lat2))/Ln(Tan((PiByTwo + Lambert_Lat2)/2)/Tan((PiByTwo + Lambert_Lat1)/2));
        Lambert_F := Cos(Lambert_Lat1)*Power(Tan((PiByTwo + Lambert_Lat1)/2),Lambert_n)/Lambert_n;
        Lambert_Rho_zero := LambertRho(CenterLatDeg);
        CorrectXY(Ref1XPix,Ref1YPix);
        CorrectXY(Ref2XPix,Ref2YPix);
        Lambert_ScaleFactor := (Ref2XPix - Ref1XPix)/(2*LambertRho(Ref1LatDeg)*Sin(Lambert_n*DegToRad(Ref2LonDeg - Ref1LonDeg)/2));
        CenterXPix := (Ref1XPix + Ref2XPix)/2;
        CenterYPix := Ref2YPix +
          Lambert_ScaleFactor*(Lambert_Rho_zero - LambertRho(Ref2LatDeg)*Cos(Lambert_n*DegToRad(Ref2LonDeg - CenterLonDeg)));
      end;
    else
      begin
        Result := False;
        Exit;
      end;
    end;

  Result := True;
end;

procedure TLTO_Viewer_Form.Clear_ButtonClick(Sender: TObject);
begin
  Image1.Picture.Bitmap.Canvas.Draw(0,0, TempPicture.Graphic);
end;

procedure TLTO_Viewer_Form.OneToOne_ButtonClick(Sender: TObject);
begin
  UpdateMagnification(OriginalWidth,OriginalHeight);
end;

procedure TLTO_Viewer_Form.ZoomOut_ButtonClick(Sender: TObject);
begin
  UpdateMagnification(Image1.Width div 2, Image1.Height div 2);
end;

procedure TLTO_Viewer_Form.ZoomIn_ButtonClick(Sender: TObject);
begin
  UpdateMagnification(2*Image1.Width, 2*Image1.Height);
end;

procedure TLTO_Viewer_Form.FormResize(Sender: TObject);
begin
  ScrollBox1.Width     := Width  - 15 - ScrollBox1.Left ;
  Filename_Label.Width := Width  - 15 - Filename_Label.Left;
  ScrollBox1.Height    := Height - 30 - ScrollBox1.Top;
end;

procedure TLTO_Viewer_Form.ImageCalibrated_RadioButtonClick(Sender: TObject);
begin
  if UpdateGeometry then
    begin
      ImageCalibrated_RadioButton.Checked := True;
      TransferData_Button.Visible := True;
    end;
end;

procedure TLTO_Viewer_Form.TransferData_ButtonClick(Sender: TObject);
begin
  case MapMode of
    LTO, Mercator, Lambert : ;   // do nothing (proceed)
    else
      begin
        ShowMessage('Transfer of this map type not yet implemented');
        Exit;
      end;
    end;

  Screen.Cursor := crHourGlass;
  LTVT_Form.LTO_Filename        := LTO_Viewer_Form.OpenDialog1.FileName;
  LTVT_Form.LTO_SinTheta        := LTO_Viewer_Form.SinTheta;
  LTVT_Form.LTO_CosTheta        := LTO_Viewer_Form.CosTheta;  // rotation angle
  case MapMode of
    LTO :
      begin
        LTVT_Form.LTO_MapMode         := LTO_map;
        LTVT_Form.LTO_CenterLon       := CenterLonDeg;
        LTVT_Form.LTO_CenterLat       := CenterLatDeg;
        LTVT_Form.LTO_CenterXPix      := CenterXPix;
        LTVT_Form.LTO_CenterYPix      := CenterYPix;
        LTVT_Form.LTO_HorzPixPerDeg   := HorzPixPerDeg;
        LTVT_Form.LTO_VertPixPerDeg   := VertPixPerDeg;
        LTVT_Form.LTO_DegLonPerXPixel := DegLonPerXPixel;
        LTVT_Form.LTO_DegLatPerYPixel := DegLatPerYPixel;
      end;
    Mercator :
      begin
        LTVT_Form.LTO_MapMode         := Mercator_map;
        LTVT_Form.LTO_VertCorrection  := 1/VertCorrection;  // note: used for inverse correction in main form
        LTVT_Form.LTO_CenterLon       := RadToDeg(MercatorStartLonRad);
        LTVT_Form.LTO_CenterLat       := 0;
        LTVT_Form.LTO_CenterXPix      := MercatorStartX;
        LTVT_Form.LTO_CenterYPix      := MercatorStartY;
        LTVT_Form.LTO_MercatorScaleFactor := MercatorScaleFactor;
      end;
    Lambert :
      begin
        LTVT_Form.LTO_MapMode         := Lambert_map;
        LTVT_Form.LTO_VertCorrection  := 1/VertCorrection;  // note: used for inverse correction in main form
        LTVT_Form.LTO_CenterLon       := CenterLonDeg;
        LTVT_Form.LTO_CenterLat       := CenterLatDeg;
        LTVT_Form.LTO_CenterXPix      := CenterXPix;
        LTVT_Form.LTO_CenterYPix      := CenterYPix;
        LTVT_Form.LTO_Lambert_ScaleFactor := Lambert_ScaleFactor;
        LTVT_Form.LTO_Lambert_Lat1        := Lambert_Lat1;
        LTVT_Form.LTO_Lambert_Lat2        := Lambert_Lat2;
        LTVT_Form.LTO_Lambert_n           := Lambert_n;
        LTVT_Form.LTO_Lambert_F           := Lambert_F;
        LTVT_Form.LTO_Lambert_Rho_zero    := Lambert_Rho_zero;
      end;
    else
      begin // this should have been checked earlier!
        ShowMessage('Transfer of this map type not yet implemented');
        Exit;
      end;
    end;

  LTVT_Form.LTO_Image.Width  := OriginalWidth;
  LTVT_Form.LTO_Image.Height := OriginalHeight;
  LTVT_Form.LTO_Image.PixelFormat := pf24bit;
  LTVT_Form.LTO_Image.Canvas.Draw(0,0, TempPicture.Graphic);
  Screen.Cursor := crDefault;

  LTVT_Form.LTO_RadioButton.Caption := ExtractFileName(LTVT_Form.LTO_Filename);
  LTVT_Form.LTO_RadioButton.Show;
  LTVT_Form.LTO_RadioButton.Checked := True;

  LTVT_Form.DrawTexture_Button.Click;

  Close;
end;

procedure TLTO_Viewer_Form.LTO_RadioButtonClick(Sender: TObject);
begin
  LTO_RadioButton.Checked := True;
  MapMode := LTO;
  MapWidthDeg := 5;
  RefPt1_RadioButtonClick(Sender);
end;

procedure TLTO_Viewer_Form.Mercator_RadioButtonClick(Sender: TObject);
begin
  Mercator_RadioButton.Checked := True;
  MapMode := Mercator;
  MapWidthDeg := 20;
  RefPt1_RadioButtonClick(Sender);
end;

procedure TLTO_Viewer_Form.Lambert_RadioButtonClick(Sender: TObject);
begin
  Lambert_RadioButton.Checked := True;
  MapMode := Lambert;
  MapWidthDeg := 25;
  RefPt1_RadioButtonClick(Sender);
end;

procedure TLTO_Viewer_Form.LoadPhoto_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.ZoomOut_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.OneToOne_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.ZoomIn_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt1_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt1_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt1_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt1_XPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt1_YPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt2_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt2_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt2_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt2_XPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.RefPt2_YPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.ImageCalibrated_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.Clear_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.TransferData_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.MapType_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.LTO_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.Mercator_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.Lambert_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.Lambert2_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#Using');
end;

procedure TLTO_Viewer_Form.VertCompression_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'LTO_Viewer.htm#VerticalCompression_1');
end;

end.
