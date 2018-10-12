unit H_PhotoCalibrator_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, ComCtrls, LabeledNumericEdit, PopupMemo;

type
  TPhotoCalibrator_Form = class(TForm)
    ScrollBox1: TScrollBox;
    Image1: TImage;
    LoadPhoto_Button: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Filename_Label: TLabel;
    RefPt1_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt1_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    MousePosition_Label: TLabel;
    Save_Button: TButton;
    RefPt1_XPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt1_YPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt1_RadioButton: TRadioButton;
    SetGeometry_RadioButton: TRadioButton;
    RefPt1_Copy_Button: TButton;
    RefPt1_GroupBox: TGroupBox;
    RefPt2_RadioButton: TRadioButton;
    RefPt2_GroupBox: TGroupBox;
    RefPt2_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_XPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_YPix_LabeledNumericEdit: TLabeledNumericEdit;
    RefPt2_Copy_Button: TButton;
    PhotoCalibrated_Label: TLabel;
    Geometry_GroupBox: TGroupBox;
    GeometryCopy_Button: TButton;
    InversionCode_RadioButton: TRadioButton;
    InvertedImage_CheckBox: TCheckBox;
    Cancel_Button: TButton;
    Label6: TLabel;
    Date_DateTimePicker: TDateTimePicker;
    Time_DateTimePicker: TDateTimePicker;
    ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit;
    Label1: TLabel;
    ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit;
    Clear_Button: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    RotationAndZoom_Label: TLabel;
    ZoomIn_Button: TButton;
    ZoomOut_Button: TButton;
    OneToOne_Button: TButton;
    CurrentMag_Label: TLabel;
    Zoom_Label: TLabel;
    Label7: TLabel;
    procedure LoadPhoto_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RefPt1_Copy_ButtonClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RefPt2_Copy_ButtonClick(Sender: TObject);
    procedure RefPt1_RadioButtonClick(Sender: TObject);
    procedure RefPt2_RadioButtonClick(Sender: TObject);
    procedure GeometryCopy_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure InversionCode_RadioButtonClick(Sender: TObject);
    procedure SetGeometry_RadioButtonClick(Sender: TObject);
    procedure InvertedImage_CheckBoxClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Clear_ButtonClick(Sender: TObject);
    procedure LoadPhoto_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetGeometry_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure RefPt1_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt2_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InversionCode_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure InvertedImage_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Clear_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Save_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GeometryCopy_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Date_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Time_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OneToOne_ButtonClick(Sender: TObject);
    procedure ZoomOut_ButtonClick(Sender: TObject);
    procedure ZoomIn_ButtonClick(Sender: TObject);
    procedure ZoomOut_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OneToOne_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ZoomIn_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObserverElevation_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_Copy_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt1_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_XPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt1_YPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_Copy_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt2_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_XPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure RefPt2_YPix_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ResultsMemo : TPopupMemo_Form;

    TempPicture : TPicture;
    ImageLoaded : Boolean;
    OriginalWidth, OriginalHeight : Integer;
    WidthMagnification, HeightMagnification : Extended;

// Set by UpdateGeometry
    InversionFactor : Integer;
    Ref1XPix, Ref1YPix,
    Ref1X, Ref1Y,  // in system with Moon center at (0,0), NP vertical, and radius = 1
    PhotoPixelsPerXYUnit, PhotoNP_CW_AngleRad : Extended;

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

    procedure HideRefPtPanels;
    procedure HideSave;
    procedure DrawCross(const CenterX, CenterY : Integer; const CrossColor : TColor);

    function UpdateGeometry : Boolean;
    procedure XY2fromXY1(const XPix1, YPix1, X1, Y1, XPix2, YPix2 : Extended; var X2, Y2 : Extended);      // valid after Update Geometry
    function XYToLonLat(const XProj, YProj : Extended; var PtLon, PtLat : Extended): Boolean;  // valid after Update Geometry
     {returns False if input cannot be converted}

    procedure UpdateMagnification(const NewWidth, NewHeight : Integer);

  end;

var
  PhotoCalibrator_Form: TPhotoCalibrator_Form;

implementation

uses
  FileCtrl, DateUtils, Math, LTVT_Unit, Win_Ops, MoonPosition, MPVectors;

{$R *.dfm}

var
  CalPhotoSubObsPoint, CalPhotoSubSolPoint : TPolarCoordinates;
  CalPhoto_ZPrime_Unit_Vector, CalPhoto_XPrime_Unit_Vector, CalPhoto_YPrime_Unit_Vector : TVector;

procedure TPhotoCalibrator_Form.FormCreate(Sender: TObject);
begin
  ResultsMemo := TPopupMemo_Form.Create(Self);

//  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:nn:ss';
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  Filename_Label.Caption := '';
  MousePosition_Label.Caption := '';
  HideRefPtPanels;
  TempPicture := TPicture.Create;
end;

procedure TPhotoCalibrator_Form.FormDestroy(Sender: TObject);
begin
  ResultsMemo.Free;
  TempPicture.Free;
end;

procedure TPhotoCalibrator_Form.UpdateMagnification(const NewWidth, NewHeight : Integer);
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

function TPhotoCalibrator_Form.PixelToX(const Pixel, Width : Integer) : Extended;
{expresses current position in image on scale of 0..1 based on center of current pixel}
begin
  Result := (Pixel + 0.5)/Width;
end;

function TPhotoCalibrator_Form.XtoPixel(const X : Extended; const Width : Integer) : Integer;
{converts current position in image on scale of 0..1 to nearest pixel}
begin
  Result := Trunc(X*Width);
end;

function TPhotoCalibrator_Form.OrigXPix(const XPix : Integer) : Integer;
{returns original X pixel location based on XPix at current magnification}
begin
  Result := XtoPixel(PixelToX(XPix,Image1.Width),OriginalWidth);
end;

function TPhotoCalibrator_Form.OrigYPix(const YPix : Integer) : Integer;
{returns original Y pixel location based on YPix at current magnification}
begin
  Result := XtoPixel(PixelToX(YPix,Image1.Height),OriginalHeight);
end;

function TPhotoCalibrator_Form.NewScrollPos(const ControlWidth, StartingScrollPos, StartingImageWidth, NewImageWidth : Integer) : Integer;
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

procedure TPhotoCalibrator_Form.HideRefPtPanels;
begin
  SetGeometry_RadioButton.Hide;
  Geometry_GroupBox.Hide;
  RefPt1_RadioButton.Hide;
  RefPt1_GroupBox.Hide;
  RefPt2_RadioButton.Hide;
  RefPt2_GroupBox.Hide;
  InversionCode_RadioButton.Hide;
  InvertedImage_CheckBox.Hide;
  Clear_Button.Hide;
  Zoom_Label.Hide;
  ZoomOut_Button.Hide;
  OneToOne_Button.Hide;
  ZoomIn_Button.Hide;
  CurrentMag_Label.Hide;
  HideSave;
end;

procedure TPhotoCalibrator_Form.HideSave;
begin
  PhotoCalibrated_Label.Hide;
  RotationAndZoom_Label.Hide;
  Save_Button.Hide;
end;

procedure TPhotoCalibrator_Form.LoadPhoto_ButtonClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    begin
      ImageLoaded := False;

      Screen.Cursor := crHourGlass;
      TRY
        TempPicture.LoadFromFile(OpenPictureDialog1.FileName);

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
        ShowMessage('Unable to load "'+OpenPictureDialog1.FileName+'"');
      END;

      if ImageLoaded then
        begin
//          ShowMessage('Labels visible');
          Clear_Button.Click;
          Filename_Label.Caption := MinimizeName(OpenPictureDialog1.FileName,Filename_Label.Canvas,Filename_Label.Width);
          HideRefPtPanels;
          SetGeometry_RadioButton.Checked := True;
          SetGeometry_RadioButton.Show;
          Geometry_GroupBox.Show;
          RefPt1_RadioButton.Show;
          Zoom_Label.Show;
          ZoomOut_Button.Show;
          OneToOne_Button.Show;
          ZoomIn_Button.Show;
          UpdateMagnification(OriginalWidth,OriginalHeight);
          CurrentMag_Label.Show;
        end;
      Screen.Cursor := LTVT_Form.DefaultCursor;
    end
  else
    ShowMessage('Action cancelled - no photo loaded');
end;

procedure TPhotoCalibrator_Form.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  XPix, YPix : Integer;
  PointX, PointY, PointLon, PointLat : Extended;
  OutString : String;
begin
  XPix := OrigXPix(X);
  YPix := OrigYPix(Y);
  OutString := 'Mouse is at pixel ('+IntToStr(XPix)+', '+IntToStr(YPix)+')';
  if Save_Button.Visible then
    begin
      XY2fromXY1(Ref1XPix, Ref1YPix, Ref1X, Ref1Y, {InversionFactor*}XPix, YPix, PointX, PointY);
      OutString := OutString + Format('       North pole up lunar coordinates:  X=%0.3f   Y=%0.3f      ',[PointX, PointY]);
      if (Sqr(PointX) + Sqr(PointY))<1 then
        begin
          XYToLonLat(PointX, PointY, PointLon, PointLat);
          OutString := OutString +
            Format('Lon/Lat = (%s, %s)',[LTVT_Form.LongitudeString(RadToDeg(PointLon),3),
              LTVT_Form.LatitudeString(RadToDeg(PointLat),3)])
        end
      else
        OutString := OutString + '(off disk)';
    end;
  MousePosition_Label.Caption := OutString;
end;

procedure TPhotoCalibrator_Form.GeometryCopy_ButtonClick(Sender: TObject);
begin
  Date_DateTimePicker.DateTime := LTVT_Form.Date_DateTimePicker.DateTime;
  Time_DateTimePicker.DateTime := LTVT_Form.Time_DateTimePicker.DateTime;
  ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := LTVT_Form.ObserverLongitudeText;
  ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := LTVT_Form.ObserverLatitudeText;
  ObserverElevation_LabeledNumericEdit.NumericEdit.Text := LTVT_Form.ObserverElevationText;
  RefPt1_RadioButtonClick(Sender);
end;

procedure TPhotoCalibrator_Form.RefPt1_Copy_ButtonClick(Sender: TObject);
begin
  RefPt1_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(LTVT_Form.RefPtLon)]);
  RefPt1_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(LTVT_Form.RefPtLat)]);
end;

procedure TPhotoCalibrator_Form.DrawCross(const CenterX, CenterY : integer; const CrossColor : TColor);
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

procedure TPhotoCalibrator_Form.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
      RefPt2_RadioButton.Checked := True;
      RefPt2_RadioButton.Show;
    end
  else if RefPt2_RadioButton.Checked then
    begin
      RefPt2_XPix_LabeledNumericEdit.NumericEdit.Text := IntToStr(XPix);
      RefPt2_YPix_LabeledNumericEdit.NumericEdit.Text := IntToStr(YPix);
      DrawCross(XPix,YPix,clAqua);
      InversionCode_RadioButtonClick(Sender);
    end
  else
    ShowMessage('If you are trying to record the pixel location of a reference point, please be sure you have the Step 2 or Step 3 radio button checked');

end;

procedure TPhotoCalibrator_Form.RefPt2_Copy_ButtonClick(Sender: TObject);
begin
  RefPt2_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(LTVT_Form.RefPtLon)]);
  RefPt2_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(LTVT_Form.RefPtLat)]);
end;

procedure TPhotoCalibrator_Form.SetGeometry_RadioButtonClick(Sender: TObject);
begin
  HideSave;
end;

procedure TPhotoCalibrator_Form.RefPt1_RadioButtonClick(Sender: TObject);
begin
  RefPt1_RadioButton.Checked := True;
  RefPt1_GroupBox.Show;
  RefPt2_RadioButton.Show;
  Clear_Button.Show;
  HideSave;
end;

procedure TPhotoCalibrator_Form.RefPt2_RadioButtonClick(Sender: TObject);
begin
  RefPt2_RadioButton.Checked := True;
  RefPt2_GroupBox.Show;
  InversionCode_RadioButton.Show;
  InvertedImage_CheckBox.Show;
  Clear_Button.Show;
  HideSave;
end;

procedure TPhotoCalibrator_Form.InversionCode_RadioButtonClick(Sender: TObject);
begin
  if UpdateGeometry then
  begin
    InversionCode_RadioButton.Checked := True;
    PhotoCalibrated_Label.Caption := 'When finished, click SAVE to store in database';
    PhotoCalibrated_Label.Show;
    RotationAndZoom_Label.Caption := Format('Rotation = %0.3f deg   Zoom = %0.3f',
      [LTVT_Form.PosNegDegrees(RadToDeg(-PhotoNP_CW_AngleRad)),
       PhotoPixelsPerXYUnit/(LTVT_Form.Image1.Width/2)]);
    RotationAndZoom_Label.Show;
    Save_Button.Show;
    Clear_Button.Hide;
  end;
end;

procedure TPhotoCalibrator_Form.InvertedImage_CheckBoxClick(Sender: TObject);
begin  // correct readout whenever this box is checked or unchecked
  UpdateGeometry;
end;

function TPhotoCalibrator_Form.UpdateGeometry : Boolean;
var
  {Ref1XPix, Ref1YPix,} Ref2XPix, Ref2YPix : Integer;
  Ref12PixelDistance, Ref12XYDistance,
  {Ref1X, Ref1Y,} Ref2X, Ref2Y,
  Theta1, Theta2 : Extended;

  SavedGeocentricMode : Boolean;

function ConvertCalPhotoLonLatToXY(const Lon, Lat : extended; var UserX, UserY : extended) : Boolean;
var
  FeatureVector : TVector;
begin
  PolarToVector(Lon,Lat,1,FeatureVector);
  if DotProduct(FeatureVector,CalPhoto_ZPrime_Unit_Vector)>0 then
    begin
      UserX := DotProduct(FeatureVector,CalPhoto_XPrime_Unit_Vector);
      UserY := DotProduct(FeatureVector,CalPhoto_YPrime_Unit_Vector);
      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;


begin
  Result := False; // default value

  if InvertedImage_CheckBox.Checked then
    InversionFactor := -1
  else
    InversionFactor := +1;

  SavedGeocentricMode := GeocentricSubEarthMode;   // remember mode

  GeocentricSubEarthMode := False;

  LTVT_Form.CalculateSubPoints(DateTimeToModifiedJulianDate(DateOf(Date_DateTimePicker.Date) + TimeOf(Time_DateTimePicker.Time)),
    ObserverLongitude_LabeledNumericEdit.NumericEdit.ExtendedValue, ObserverLatitude_LabeledNumericEdit.NumericEdit.ExtendedValue,
    ObserverElevation_LabeledNumericEdit.NumericEdit.ExtendedValue, CalPhotoSubObsPoint, CalPhotoSubSolPoint);

  GeocentricSubEarthMode := SavedGeocentricMode;  // restore mode

  if ObserverElevation_LabeledNumericEdit.NumericEdit.ExtendedValue=-999 then with CalPhotoSubObsPoint do
    begin  // override Sub-earth point with direct input
      Longitude := DegToRad(ObserverLongitude_LabeledNumericEdit.NumericEdit.ExtendedValue);
      Latitude := DegToRad(ObserverLatitude_LabeledNumericEdit.NumericEdit.ExtendedValue);
      Radius  := 1;
    end;

  ResultsMemo.Memo.Lines.Add(Format('Sub-obs lon=%0.3f, lat=%0.3f',[RadToDeg(CalPhotoSubObsPoint.Longitude),RadToDeg(CalPhotoSubObsPoint.Latitude)]));

  PolarToVector(CalPhotoSubObsPoint.Longitude,CalPhotoSubObsPoint.Latitude,1,CalPhoto_ZPrime_Unit_Vector);
  NormalizeVector(CalPhoto_ZPrime_Unit_Vector);

  CrossProduct(Uy,CalPhoto_ZPrime_Unit_Vector,CalPhoto_XPrime_Unit_Vector);
  if VectorMagnitude(CalPhoto_XPrime_Unit_Vector)=0 then CalPhoto_XPrime_Unit_Vector := Ux;  //CalPhoto_ZPrime_Unit_Vector parallel to Uy (looking from over north or south pole)
  NormalizeVector(CalPhoto_XPrime_Unit_Vector);
  CrossProduct(CalPhoto_ZPrime_Unit_Vector,CalPhoto_XPrime_Unit_Vector,CalPhoto_YPrime_Unit_Vector);
//  Multiply(InversionFactor,CalPhoto_XPrime_Unit_Vector);

  if not ConvertCalPhotoLonLatToXY(DegToRad(RefPt1_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue),
    DegToRad(RefPt1_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue),Ref1X,Ref1Y) then
    begin
      ShowMessage('Please recheck the selenographic coordinates of Calibration Point 1:'+CR
                 +'the point listed is not visible in the current geometry.');
      Exit;
    end;

  ResultsMemo.Memo.Lines.Add(Format('RefPt1 X=%0.3f, Y=%0.3f',[Ref1X,Ref1Y]));

  if not ConvertCalPhotoLonLatToXY(DegToRad(RefPt2_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue),
    DegToRad(RefPt2_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue),Ref2X,Ref2Y) then
    begin
      ShowMessage('Please recheck the selenographic coordinates of Calibration Point 2:'+CR
                 +'the point listed is not visible in the current geometry.');
      Exit;
    end;

  ResultsMemo.Memo.Lines.Add(Format('RefPt2 X=%0.3f, Y=%0.3f',[Ref2X,Ref2Y]));

  Ref1XPix := {InversionFactor*}RefPt1_XPix_LabeledNumericEdit.NumericEdit.IntegerValue;
  Ref1YPix := RefPt1_YPix_LabeledNumericEdit.NumericEdit.IntegerValue;

  Ref2XPix := {InversionFactor*}RefPt2_XPix_LabeledNumericEdit.NumericEdit.IntegerValue;
  Ref2YPix := RefPt2_YPix_LabeledNumericEdit.NumericEdit.IntegerValue;

  Ref12PixelDistance := Sqrt(Sqr(Ref2XPix - Ref1XPix) + Sqr(Ref2YPix - Ref1YPix));
  if Ref12PixelDistance=0 then
    begin
      ShowMessage('The two reference points must be at different pixel locations!');
      Exit;
    end;

  Ref12XYDistance := Sqrt(Sqr(Ref2X - Ref1X) + Sqr(Ref2Y - Ref1Y));
  if Ref12XYDistance=0 then
    begin
      ShowMessage('The two reference points must be at different lunar locations!');
      Exit;
    end;

  ResultsMemo.Memo.Lines.Add(Format('Ref12Distance Pixels=%0.3f, XY=%0.3f',[Ref12PixelDistance,Ref12XYDistance]));

  PhotoPixelsPerXYUnit := Ref12PixelDistance/Ref12XYDistance;

  ResultsMemo.Memo.Lines.Add(Format('PhotoPixelsPerXYUnit= %0.3f',[PhotoPixelsPerXYUnit]));

  Theta1 := ArcTan2(Ref1YPix - Ref2YPix,Ref2XPix - Ref1XPix); // Direction from Ref1 to Ref2 on photo.
  Theta1 := InversionFactor*Theta1;

  Theta2 := ArcTan2(Ref2Y - Ref1Y,Ref2X - Ref1X);  // Direction Ref1 to Ref2 on Moon

  ResultsMemo.Memo.Lines.Add(Format('Theta1=%0.3f, Theta2=%0.3f',[RadToDeg(Theta1),RadToDeg(Theta2)]));

  PhotoNP_CW_AngleRad :=  Theta2 - Theta1; // CW rotation angle of photo vertical (-y direction) wrt. Moon's NP

  ResultsMemo.Memo.Lines.Add(Format('PhotoNP_CW_AngleRad=%0.3f',[RadToDeg(PhotoNP_CW_AngleRad)]));

//  ResultsMemo.Show;

  Result := True; // successfully completed
end;

procedure TPhotoCalibrator_Form.XY2fromXY1(const XPix1, YPix1, X1, Y1, XPix2, YPix2 : Extended; var X2, Y2 : Extended);      // valid after Update Geometry
var
  Theta3, Theta4, Nxy : extended;
begin
  Theta3 := ArcTan2(YPix1 - YPix2,XPix2 - XPix1); // Direction from Pt1 to Pt2 on photo.
  Theta3 := InversionFactor*Theta3;

  Theta4 := Theta3 + PhotoNP_CW_AngleRad;  // Direction from Pt1 to Pt2 on Moon

  Nxy := Sqrt(Sqr(XPix2 - XPix1) + Sqr(YPix2 - YPix1))/PhotoPixelsPerXYUnit; // distance from Pt1 to Pt2 in lunar XY units (radius = 1)

  X2 := X1 + Nxy*Cos(Theta4);  // position in lunar X-Y system.
  Y2 := Y1 + Nxy*Sin(Theta4);
end;

function TPhotoCalibrator_Form.XYToLonLat(const XProj, YProj : Extended; var PtLon, PtLat : Extended): Boolean;  // valid after Update Geometry
var
  XYSqrd, ZProj, XX, YY, ZZ : extended;
begin {TPhotoCalibrator_Form.XYToLonLat}

  XYSqrd := Sqr(XProj) + Sqr(YProj);
  if XYSqrd<1 then
    begin
      ZProj := Sqrt(1 - XYSqrd);  // this sets length to 1

      XX := XProj*CalPhoto_XPrime_Unit_Vector[x] + YProj*CalPhoto_YPrime_Unit_Vector[x] + ZProj*CalPhoto_ZPrime_Unit_Vector[x];
      YY := XProj*CalPhoto_XPrime_Unit_Vector[y] + YProj*CalPhoto_YPrime_Unit_Vector[y] + ZProj*CalPhoto_ZPrime_Unit_Vector[y];
      ZZ := XProj*CalPhoto_XPrime_Unit_Vector[z] + YProj*CalPhoto_YPrime_Unit_Vector[z] + ZProj*CalPhoto_ZPrime_Unit_Vector[z];

      PtLat := ArcSin(YY);
      PtLon := ArcTan2(XX,ZZ);
      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;  {TPhotoCalibrator_Form.XYToLonLat}

procedure TPhotoCalibrator_Form.Save_ButtonClick(Sender: TObject);
var
  CalData : TextFile;
  OutString, TempFilename,
//  LocalDateFormat,
  InversionCode : String;

begin {TPhotoCalibrator_Form.Save_ButtonClick}
  if FileExists(LTVT_Form.CalibratedPhotosFilename) then
    begin
      AssignFile(CalData,LTVT_Form.CalibratedPhotosFilename);
      Append(CalData);
    end
  else
    begin
      if MessageDlg('LTVT is unable to find a calibration file to which to add this data.'+Char(13)
        +'Do you want to search for an existing calibration file?'+Char(13)
        +'Choosing "Yes" will let you browse for an existing file; choosing "No" will create a new one.',
        mtConfirmation,[mbYes,mbNo],0)=mrYes then
        begin
          if FileFound('Photo calibration data file',LTVT_Form.CalibratedPhotosFilename,TempFilename) then
            begin
              LTVT_Form.CalibratedPhotosFilename := TempFilename;
              AssignFile(CalData,LTVT_Form.CalibratedPhotosFilename);
              Append(CalData);
            end
          else
            begin
              ShowMessage('Unable to save calibration data -- no destination file selected');
              Exit;
            end;
        end
      else
        begin
          AssignFile(CalData,LTVT_Form.CalibratedPhotosFilename);
          Rewrite(CalData);
          Writeln(CalData,'*LTVT User Photo Calibration Data');
          Writeln(CalData,'*  Please edit this file only with a plain text processor.');
          Writeln(CalData,'*  The first item is a code telling LTVT the expected contents of the subsequent items.');
          Writeln(CalData,'*  In format "U0/U1" (user photo/satellite photo), items up to the file name are separated by commas.');
          Writeln(CalData,'*  File names may contain any characters.');
          Writeln(CalData,'*  Numeric entries *must* use periods (.) to represent the decimal point.');
          Writeln(CalData,'*  Dates *must* be in YYYY/MM/DD format.');
          Writeln(CalData,'*  Blank lines and lines begining with an asterisk (*) are ignored');
          Writeln(CalData,'');
          Writeln(CalData,'*U0, Date, Time, ObsEastLonDeg, ObsNorthLatDeg, ObsElevationMeters, PixelWidth, PixelHeight,   SubObsLon,   SubObsLat, SubSolLon, SubSolLat, Ref1XPix, Ref1YPix, Ref1Lon, Ref1Lat, Ref2XPix, Ref2YPix, Ref2Lon, Ref2Lat, InversionCode, Filename');
          Writeln(CalData,'*U1, Date, Time, SatEastLonDeg, SatNorthLatDeg, SatElevKilometers,  PixelWidth, PixelHeight, GroundPtLon, GroundPtLat, SubSolLon, SubSolLat, Ref1XPix, Ref1YPix, Ref1Lon, Ref1Lat, Ref2XPix, Ref2YPix, Ref2Lon, Ref2Lat, InversionCode, Filename');
          ShowMessage('Your calibration data have been successfully added to a new calibration file: '+Char(13)
                      +LTVT_Form.CalibratedPhotosFilename);
        end;
    end;

//  LocalDateFormat := ShortDateFormat;    // save local format
//  ShortDateFormat := 'yyyy/mm/dd';
  OutString := 'U0, '+IntToStr(YearOf(Date_DateTimePicker.Date))+'/'
    +IntToStr(MonthOf(Date_DateTimePicker.Date))+'/'+IntToStr(DayOf(Date_DateTimePicker.Date))+', ';
//  ShortDateFormat := LocalDateFormat;    // restore local format

  if InvertedImage_CheckBox.Checked then
    InversionCode := '-1'
  else
    InversionCode := '1';

  OutString := OutString
    +TimeToStr(Time_DateTimePicker.Time)+', '
    +ObserverLongitude_LabeledNumericEdit.NumericEdit.Text+', ' // PhotoObsELonDeg,
    +ObserverLatitude_LabeledNumericEdit.NumericEdit.Text+', ' // PhotoObsNLatDeg
    +ObserverElevation_LabeledNumericEdit.NumericEdit.Text+', ' // PhotoObsHt
    +IntToStr(Image1.Picture.Bitmap.Width)+', '
    +IntToStr(Image1.Picture.Bitmap.Height)+', '
    +Format('%0.3f, %0.3f, %0.3f, %0.3f',
     [LTVT_Form.PosNegDegrees(RadToDeg(CalPhotoSubObsPoint.Longitude)), RadToDeg(CalPhotoSubObsPoint.Latitude),
      LTVT_Form.PosNegDegrees(RadToDeg(CalPhotoSubSolPoint.Longitude)), RadToDeg(CalPhotoSubSolPoint.Latitude)])+', '
    +RefPt1_XPix_LabeledNumericEdit.NumericEdit.Text+', '+RefPt1_YPix_LabeledNumericEdit.NumericEdit.Text+', '
    +RefPt1_Lon_LabeledNumericEdit.NumericEdit.Text+', '+RefPt1_Lat_LabeledNumericEdit.NumericEdit.Text+', '
    +RefPt2_XPix_LabeledNumericEdit.NumericEdit.Text+', '+RefPt2_YPix_LabeledNumericEdit.NumericEdit.Text+', '
    +RefPt2_Lon_LabeledNumericEdit.NumericEdit.Text+', '+RefPt2_Lat_LabeledNumericEdit.NumericEdit.Text+', '
    +InversionCode+', '+OpenPictureDialog1.FileName;

  Writeln(CalData,OutString);

  CloseFile(CalData);

//  ShowMessage('Calibration data has been appended to '+LTVT_Form.CalibratedPhotosFilename);
  PhotoCalibrated_Label.Caption := 'Calibration data has been saved to disk';
  ActiveControl := LoadPhoto_Button;

end;  {TPhotoCalibrator_Form.Save_ButtonClick}

procedure TPhotoCalibrator_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TPhotoCalibrator_Form.Clear_ButtonClick(Sender: TObject);
begin
  Image1.Picture.Bitmap.Canvas.Draw(0,0, TempPicture.Graphic);
end;

procedure TPhotoCalibrator_Form.OneToOne_ButtonClick(Sender: TObject);
begin
  UpdateMagnification(OriginalWidth,OriginalHeight);
end;

procedure TPhotoCalibrator_Form.ZoomOut_ButtonClick(Sender: TObject);
begin
  UpdateMagnification(Image1.Width div 2, Image1.Height div 2);
end;

procedure TPhotoCalibrator_Form.ZoomIn_ButtonClick(Sender: TObject);
begin
  UpdateMagnification(2*Image1.Width, 2*Image1.Height);
end;

procedure TPhotoCalibrator_Form.FormResize(Sender: TObject);
begin
  ScrollBox1.Width     := Width  - 15 - ScrollBox1.Left ;
  Filename_Label.Width := Width  - 15 - Filename_Label.Left;
  ScrollBox1.Height    := Height - 30 - ScrollBox1.Top;
end;

procedure TPhotoCalibrator_Form.ZoomOut_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.LoadPhoto_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.SetGeometry_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt1_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt2_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.InversionCode_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.InvertedImage_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.Clear_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.Save_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.GeometryCopy_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.Date_DateTimePickerKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.Time_DateTimePickerKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.ObserverLongitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.OneToOne_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.ZoomIn_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.ObserverElevation_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt1_Copy_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt1_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt1_XPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt1_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt1_YPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt2_Copy_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt2_Lon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt2_Lat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt2_XPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.RefPt2_YPix_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

procedure TPhotoCalibrator_Form.ObserverLatitude_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PhotoCalibration_Form.htm');
end;

end.
