unit H_CalibratedPhotoSelector_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LabeledNumericEdit, ComCtrls;

type
  TPhotoCalData = record
    PhotoCalCode : string;
    PhotoDate : TDateTime;
    PhotoTime : TDateTime;
    PhotoObsELonDeg,
    PhotoObsNLatDeg,
    PhotoObsHt,
    PhotoWidth, PhotoHeight,
    SubObsLon, SubObsLat,
    SubSolLon, SubSolLat,
    Ref1XPix,  Ref1YPix,
    Ref1Lon,   Ref1Lat,
    Ref2XPix,  Ref2YPix,
    Ref2Lon,   Ref2Lat,
    InversionCode,
    PhotoFilename,
    Comment : String;
    end;

  TPhotoListData = record
    PhotoCalData : TPhotoCalData;
    SunAlt, SunAz : Extended;  // in degrees, calculated only if list is filtered
    end;

type
  TCalibratedPhotoLoader_Form = class(TForm)
    ListBox1: TListBox;
    Thumbnail_Image: TImage;
    SelectPhoto_Button: TButton;
    Cancel_Button: TButton;
    Label2: TLabel;
    X1_Pix_LabeledNumericEdit: TLabeledNumericEdit;
    Y1_Pix_LabeledNumericEdit: TLabeledNumericEdit;
    Lon1_LabeledNumericEdit: TLabeledNumericEdit;
    Lat1_LabeledNumericEdit: TLabeledNumericEdit;
    InversionCode_LabeledNumericEdit: TLabeledNumericEdit;
    X2_Pix_LabeledNumericEdit: TLabeledNumericEdit;
    Y2_Pix_LabeledNumericEdit: TLabeledNumericEdit;
    Lon2_LabeledNumericEdit: TLabeledNumericEdit;
    Lat2_LabeledNumericEdit: TLabeledNumericEdit;
    DateTime_Label: TLabel;
    ObsLocation_Label: TLabel;
    SubObsPt_Label: TLabel;
    SubSolPt_Label: TLabel;
    PhotoSize_Label: TLabel;
    Filename_Label: TLabel;
    ImageFilename_Label: TLabel;
    OverwriteNone_RadioButton: TRadioButton;
    OverwriteGeometry_RadioButton: TRadioButton;
    OverwriteDateTime_RadioButton: TRadioButton;
    OverwriteAll_RadioButton: TRadioButton;
    Label1: TLabel;
    TargetLon_LabeledNumericEdit: TLabeledNumericEdit;
    TargetLat_LabeledNumericEdit: TLabeledNumericEdit;
    ListPhotos_Button: TButton;
    FilterPhotos_CheckBox: TCheckBox;
    ChangeFile_Button: TButton;
    OpenDialog1: TOpenDialog;
    Sort_CheckBox: TCheckBox;
    Label3: TLabel;
    SunAngleOnly_RadioButton: TRadioButton;
    ListLibrations_CheckBox: TCheckBox;
    PhotoListHeaders_Label: TLabel;
    FeaturePos_Part1_Label: TLabel;
    Overlay_Image: TImage;
    CopyInfo_Button: TButton;
    Colongitude_CheckBox: TCheckBox;
    FeaturePos_Part2_Label: TLabel;
    ShowNote_Button: TButton;
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure SelectPhoto_ButtonClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FilterPhotos_CheckBoxClick(Sender: TObject);
    procedure ListPhotos_ButtonClick(Sender: TObject);
    procedure ChangeFile_ButtonClick(Sender: TObject);
    procedure CopyInfo_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShowNote_ButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ObserverElevation_Text : String; // replaces control formerly on page

    LastSelectedPhotoName : String;   // index in PhotoListData

    PhotoSelected : Boolean;
    PhotoListData : array of TPhotoListData;
    SortedListIndex : array of Integer;

    SelectedPhotoData : TPhotoCalData;

    function FeatureInPhoto(const CurrentPhotoData : TPhotoCalData; const LonDeg, LatDeg : Extended;
      var SunAltDeg, SunAzDeg : Extended; var FeatureXPix, FeatureYPix : Integer) : Boolean;
    {determines if stated feature would be on visible disk and at a pixel position within limits of calibrated image}
  end;

var
  CalibratedPhotoLoader_Form: TCalibratedPhotoLoader_Form;

implementation

uses MP_Defs, Constnts, LTVT_Unit, MoonPosition, Win_Ops, FileCtrl, Math, MPVectors,
  IniFiles, Clipbrd, LTVT_PopupMemo;

{$R *.dfm}

procedure TCalibratedPhotoLoader_Form.SelectPhoto_ButtonClick(Sender: TObject);
begin
  if ListBox1.ItemIndex>=0 then
    begin
      PhotoSelected := True;

      if ListBox1.ItemIndex<Length(SortedListIndex) then     // remember last photo so it can be highlighted next time
        LastSelectedPhotoName := PhotoListData[SortedListIndex[ListBox1.ItemIndex]].PhotoCalData.PhotoFilename
      else
        LastSelectedPhotoName := '';

      with SelectedPhotoData do
        begin
          Ref1Lon := Lon1_LabeledNumericEdit.NumericEdit.Text;
          Ref1Lat := Lat1_LabeledNumericEdit.NumericEdit.Text;
          Ref1XPix := X1_Pix_LabeledNumericEdit.NumericEdit.Text;
          Ref1YPix := Y1_Pix_LabeledNumericEdit.NumericEdit.Text;
          Ref2Lon := Lon2_LabeledNumericEdit.NumericEdit.Text;
          Ref2Lat := Lat2_LabeledNumericEdit.NumericEdit.Text;
          Ref2XPix := X2_Pix_LabeledNumericEdit.NumericEdit.Text;
          Ref2YPix := Y2_Pix_LabeledNumericEdit.NumericEdit.Text;
          InversionCode := InversionCode_LabeledNumericEdit.NumericEdit.Text;
        end;
      Close;
    end
  else
    ShowMessage('No photo selected -- please click on the desired photo name');
end;

procedure TCalibratedPhotoLoader_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TCalibratedPhotoLoader_Form.ListBox1Click(Sender: TObject);
var
  OriginalWidth, OriginalHeight, OriginalXPix, OriginalYPix,
  ThumbnailXPix, ThumbnailYPix, CrossSize : Integer;
  TargetLonDeg, TargetLatDeg, SunAltDeg, SunAzDeg,
  SunAngle,SunBearing, Colongitude, Ratio, ThumbnailMagnification : Extended;
begin
  SelectedPhotoData := PhotoListData[SortedListIndex[ListBox1.ItemIndex]].PhotoCalData;
  with SelectedPhotoData do
    begin
      try
        Thumbnail_Image.Picture.LoadFromFile(PhotoFilename);
      except
        ShowMessage('Unable to load "'+PhotoFilename+'"');
        Exit;
      end;

      FeaturePos_Part1_Label.Caption := '';
      FeaturePos_Part2_Label.Caption := '';

      if Colongitude_CheckBox.Checked then
        begin
          if CurrentTargetPlanet=Moon then
            begin
              Colongitude := (Pi/2) - LTVT_Form.SubSolarPoint.Longitude;
              while Colongitude>TwoPi do Colongitude := Colongitude - TwoPi;
              while Colongitude<0 do Colongitude := Colongitude + TwoPi;

              FeaturePos_Part1_Label.Caption := Format('In current: Colon= %0.2f, Lat= %0.2f',
                [Colongitude/OneDegree, LTVT_Form.SubSolarPoint.Latitude/OneDegree]);
            end
          else
            begin
              Colongitude := LTVT_Form.SubObserverPoint.Longitude;

              FeaturePos_Part1_Label.Caption := Format('In current: CM = %0.2f, Lat= %0.2f',
                [LTVT_Form.PosNegDegrees(Colongitude/OneDegree,LTVT_Form.PlanetaryLongitudeConvention), LTVT_Form.SubSolarPoint.Latitude/OneDegree]);
            end;
        end;

      if (FilterPhotos_CheckBox.Checked) then
        begin
          TargetLonDeg := TargetLon_LabeledNumericEdit.NumericEdit.ExtendedValue;
          TargetLatDeg := TargetLat_LabeledNumericEdit.NumericEdit.ExtendedValue;

          if FeatureInPhoto(SelectedPhotoData, TargetLonDeg, TargetLatDeg, SunAltDeg, SunAzDeg, OriginalXPix, OriginalYPix) then
            begin
              OriginalWidth := IntegerValue(PhotoWidth);
              if OriginalWidth=0 then OriginalWidth := 1;

              OriginalHeight := IntegerValue(PhotoHeight);
              if OriginalHeight=0 then OriginalHeight := 1;

              if not Colongitude_CheckBox.Checked then
                begin
                  ComputeDistanceAndBearing(TargetLonDeg*OneDegree,TargetLatDeg*OneDegree,
                    LTVT_Form.SubSolarPoint.Longitude,LTVT_Form.SubSolarPoint.Latitude,
                    SunAngle,SunBearing);
                  SunAngle := (Pi/2) - SunAngle;

                  FeaturePos_Part1_Label.Caption := Format('In current: Alt= %0.2f, Az= %0.1f',
                    [SunAngle/OneDegree, SunBearing/OneDegree]);
                end;

              FeaturePos_Part2_Label.Caption := Format('In selected at: X= %0.2f, Y= %0.2f',
                [OriginalXPix/OriginalWidth, OriginalYPix/OriginalHeight]);

              Ratio := Thumbnail_Image.Width/OriginalWidth;
              ThumbnailMagnification := Ratio;
              Ratio := Thumbnail_Image.Height/OriginalHeight;
              if Ratio<ThumbnailMagnification then ThumbnailMagnification := Ratio;

              ThumbnailXPix := Round(ThumbnailMagnification*OriginalXPix);
              ThumbnailYPix := Round(ThumbnailMagnification*OriginalYPix);

              with Overlay_Image.Canvas do   // note: Overlay_Image is transparent
                begin
                  FillRect(ClipRect);  // clear previous image
                  Pen.Color := LTVT_Form.ReferencePointColor;
                  CrossSize := LTVT_Form.DotSize + 1;
                  MoveTo(ThumbnailXPix-CrossSize,ThumbnailYPix);
                  LineTo(ThumbnailXPix+CrossSize+1,ThumbnailYPix);
                  MoveTo(ThumbnailXPix,ThumbnailYPix-CrossSize);
                  LineTo(ThumbnailXPix,ThumbnailYPix+CrossSize+1);
                end;

              Overlay_Image.Show;
            end;
        end
      else
        begin
          Overlay_Image.Hide;
        end;

      ImageFilename_Label.Caption := 'Current image at:  '+
        MinimizeName(PhotoFilename,ImageFilename_Label.Canvas,ImageFilename_Label.Width);

      DateTime_Label.Caption := 'Photo date : '+DateToStr(PhotoDate)+' at '+TimeToStr(PhotoTime)+' UT';

      if PhotoCalCode='U1' then
        begin
          ObsLocation_Label.Caption := 'Satellite : '
            +LTVT_Form.PlanetaryLongitudeString(ExtendedValue(PhotoObsELonDeg),4)+' / '
            +LTVT_Form.LatitudeString(ExtendedValue(PhotoObsNLatDeg),4)+' at '
            +Format('%0.0f',[ExtendedValue(PhotoObsHt)])+' km';
          SubObsPt_Label.Caption := 'Ground pt lon/lat : '+SubObsLon+'/'+SubObsLat;
        end
      else // Code 'U0'
        begin
          if ExtendedValue(PhotoObsHt)=-999 then
            ObsLocation_Label.Caption := 'Site : (manually set sub-observer lon/lat)'
          else
            ObsLocation_Label.Caption := 'Site : '
              +LTVT_Form.EarthLongitudeString(ExtendedValue(PhotoObsELonDeg),4)+' / '
              +LTVT_Form.LatitudeString(ExtendedValue(PhotoObsNLatDeg),4)+' at '
              +Format('%0.0f',[ExtendedValue(PhotoObsHt)])+' m';
          SubObsPt_Label.Caption := 'Sub-observer lon/lat : '+SubObsLon+'/'+SubObsLat;
        end;

      SubSolPt_Label.Caption := 'Sub-solar lon/lat : '+SubSolLon+'/'+SubSolLat;
      PhotoSize_Label.Caption := 'Size:  '+PhotoWidth+' x '+PhotoHeight+' pixels';
      Lon1_LabeledNumericEdit.NumericEdit.Text := Ref1Lon;
      Lat1_LabeledNumericEdit.NumericEdit.Text := Ref1Lat;
      X1_Pix_LabeledNumericEdit.NumericEdit.Text := Ref1XPix;
      Y1_Pix_LabeledNumericEdit.NumericEdit.Text := Ref1YPix;
      Lon2_LabeledNumericEdit.NumericEdit.Text := Ref2Lon;
      Lat2_LabeledNumericEdit.NumericEdit.Text := Ref2Lat;
      X2_Pix_LabeledNumericEdit.NumericEdit.Text := Ref2XPix;
      Y2_Pix_LabeledNumericEdit.NumericEdit.Text := Ref2YPix;
      InversionCode_LabeledNumericEdit.NumericEdit.Text  := InversionCode;

      ShowNote_Button.Visible := Comment<>'';
    end;
end;

function TCalibratedPhotoLoader_Form.FeatureInPhoto(const CurrentPhotoData : TPhotoCalData; const LonDeg, LatDeg : Extended;
      var SunAltDeg, SunAzDeg : Extended; var FeatureXPix, FeatureYPix : Integer) : Boolean;
var
  UserPhotoType : (EarthBased, Satellite);

  UserPhoto_SubObsVector,
  SatelliteVector, // for satellite photos this is the position of the camera relative to the Moon's center in selenodetic system
// for EarthBased photos, the following is a system pointing from the Sub-observer point to the Moon's center
// for Satellite photos the Z-axis points from the camera position (SatelliteVector) to the principal ground point
  UserPhoto_XPrime_Unit_Vector, UserPhoto_YPrime_Unit_Vector, UserPhoto_ZPrime_Unit_Vector : TVector;
  UserPhoto_StartXPix, UserPhoto_StartYPix, UserPhoto_InversionCode,
  UserPhoto_Width, UserPhoto_Height : Integer;
  UserPhoto_StartX, UserPhoto_StartY, UserPhoto_PixelsPerXYUnit,
  UserPhotoSinTheta, UserPhotoCosTheta : Extended;

  ErrorCode, Ref2XPixel, Ref2YPixel : Integer;
  SubObsLonDeg, SubObsLatDeg, SubSolLonDeg, SubSolLatDeg, Ref1LonDeg, Ref1LatDeg,
  Ref2LonDeg, Ref2LatDeg, Ref2X, Ref2Y,
//  PhotoCenterX, PhotoCenterY,
  PixelDistSqrd, XYDistSqrd,
  RotationAngle,
  SatelliteNLatDeg, SatelliteELonDeg, SatelliteElevKm : Extended;
  GroundPointVector : TVector;
  ReadSuccessful : Boolean;

  SunAlt, SunAz : Extended;

  function ConvertUserPhotoLonLatToXY(const Lon, Lat : extended; var UserX, UserY : extended) : Boolean;
  var
    CosTheta : Extended;
    FeatureVector, LineOfSight : TVector;
  begin
    if UserPhotoType=Satellite then
      begin
        Result := False;

        PolarToVector(Lon, Lat, MoonRadius, FeatureVector);

        VectorDifference(FeatureVector,SatelliteVector,LineOfSight);

        if VectorMagnitude(LineOfSight)=0 then
          begin
  //          ShowMessage('Feature of interest is in film plane!');
            Exit
          end;

        NormalizeVector(LineOfSight);

        CosTheta := DotProduct(LineOfSight,UserPhoto_ZPrime_Unit_Vector);
        if CosTheta<=0 then
          begin
  //          ShowMessage('Feature of interest is behind film plane!');
            Exit
          end;

        if DotProduct(FeatureVector,LineOfSight)>0 then
          begin
  //          ShowMessage('Feature of interest is beyond limb as seen by satellite!');
            Exit
          end;

        UserX := DotProduct(LineOfSight,UserPhoto_XPrime_Unit_Vector)/CosTheta;  // nominal Camera_Ux is to right, Uy down, like screen pixels
        UserY := -DotProduct(LineOfSight,UserPhoto_YPrime_Unit_Vector)/CosTheta; // reverse sign to make consistent with xi-eta (x= right; y= up) system

        Result := True;
      end
    else // Earthbased photo
      begin
        PolarToVector(Lon,Lat,1,FeatureVector);
        if DotProduct(FeatureVector,UserPhoto_SubObsVector)>0 then
          begin
            UserX := DotProduct(FeatureVector,UserPhoto_XPrime_Unit_Vector);
            UserY := DotProduct(FeatureVector,UserPhoto_YPrime_Unit_Vector);
            Result := True;
          end
        else
          begin
            Result := False;
          end;
      end;
  end;

  function ConvertUserPhotoLonLatToXPixYPix(const Lon, Lat : extended; var UserPhotoXPix, UserPhotoYPix : integer) : Boolean;
  var
    FeatureX, FeatureY, TempXPix, TempYPix : Extended;
  begin
    if ConvertUserPhotoLonLatToXY(Lon,Lat,FeatureX, FeatureY ) then
      begin
      // calculate distance from origin
        TempXPix := (FeatureX - UserPhoto_StartX)*UserPhoto_PixelsPerXYUnit;
        TempYPix := -(FeatureY - UserPhoto_StartY)*UserPhoto_PixelsPerXYUnit;  // Y Pixels run backwards to Y coordinate on Moon.
      // rotate and add to origin position
        UserPhotoXPix := UserPhoto_StartXPix + Round(TempXPix*UserPhotoCosTheta - TempYPix*UserPhotoSinTheta);
        UserPhotoYPix := UserPhoto_StartYPix + Round(TempXPix*UserPhotoSinTheta + TempYPix*UserPhotoCosTheta);
        Result := True;
      end
    else
      begin
        Result := False;
      end;
  end;

begin {TCalibratedPhotoLoader_Form.FeatureInPhoto}
  Result := False;
  ReadSuccessful := True;

  Val(CurrentPhotoData.PhotoWidth,UserPhoto_Width,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.PhotoHeight,UserPhoto_Height,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  if CurrentPhotoData.PhotoCalCode='U1' then
    UserPhotoType := Satellite
  else
    UserPhotoType := EarthBased;

  Val(CurrentPhotoData.InversionCode,UserPhoto_InversionCode,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.SubObsLon,SubObsLonDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.SubObsLat,SubObsLatDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.SubSolLon,SubSolLonDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.SubSolLat,SubSolLatDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  if UserPhotoType=Satellite then with CurrentPhotoData do
    begin
      Val(PhotoObsNLatDeg,SatelliteNLatDeg,ErrorCode);
      ReadSuccessful := ReadSuccessful and (ErrorCode=0);

      Val(PhotoObsELonDeg,SatelliteElonDeg,ErrorCode);
      ReadSuccessful := ReadSuccessful and (ErrorCode=0);

      Val(PhotoObsHt,SatelliteElevKm,ErrorCode);
      ReadSuccessful := ReadSuccessful and (ErrorCode=0);

      if not ReadSuccessful then
        begin
    //      ShowMessage('An error occurred reading the calibration data -- please load a different photo');
          Exit;
        end;

      PolarToVector(DegToRad(SatelliteElonDeg), DegToRad(SatelliteNLatDeg),
        MoonRadius + SatelliteElevKm, SatelliteVector);

      PolarToVector(DegToRad(SubObsLonDeg), DegToRad(SubObsLatDeg),
        MoonRadius, GroundPointVector);

      VectorDifference(GroundPointVector,SatelliteVector,UserPhoto_ZPrime_Unit_Vector);

      if VectorMagnitude(UserPhoto_ZPrime_Unit_Vector)=0 then
        begin
//          ShowMessage('Satellite and Ground Point must be at different positions!');
          Exit;
        end;

      NormalizeVector(UserPhoto_ZPrime_Unit_Vector);

      CrossProduct(UserPhoto_ZPrime_Unit_Vector, Uy, UserPhoto_XPrime_Unit_Vector);
      if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then
        begin
          CrossProduct(UserPhoto_ZPrime_Unit_Vector, Ux, UserPhoto_XPrime_Unit_Vector);
        end;

      if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then
        begin // this should never happen
//          ShowMessage('Internal error: unable to establish camera axis');
          Exit
        end;

      NormalizeVector(UserPhoto_XPrime_Unit_Vector);

      CrossProduct(UserPhoto_ZPrime_Unit_Vector, UserPhoto_XPrime_Unit_Vector, UserPhoto_YPrime_Unit_Vector);

      SubObsLatDeg := RadToDeg(ArcSin(-UserPhoto_ZPrime_Unit_Vector[y]));   // results in radians
      SubObsLonDeg := RadToDeg(ArcTan2(-UserPhoto_ZPrime_Unit_Vector[x],-UserPhoto_ZPrime_Unit_Vector[z]));

    end;

  if not ReadSuccessful then
    begin
//      ShowMessage('An error occurred reading the calibration data -- please load a different photo');
      Exit;
    end;

  PolarToVector(DegToRad(SubObsLonDeg),DegToRad(SubObsLatDeg),1,UserPhoto_SubObsVector);
  NormalizeVector(UserPhoto_SubObsVector);

  if UserPhotoType=Earthbased then
    begin
      CrossProduct(Uy,UserPhoto_SubObsVector,UserPhoto_XPrime_Unit_Vector);
      if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then UserPhoto_XPrime_Unit_Vector := Ux;  //UserPhoto_SubObsVector parallel to Uy (looking from over north or south pole)
      NormalizeVector(UserPhoto_XPrime_Unit_Vector);
      CrossProduct(UserPhoto_SubObsVector,UserPhoto_XPrime_Unit_Vector,UserPhoto_YPrime_Unit_Vector);
      MultiplyVector(UserPhoto_InversionCode,UserPhoto_XPrime_Unit_Vector);
    end;

  Val(CurrentPhotoData.Ref1XPix,UserPhoto_StartXPix,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.Ref1YPix,UserPhoto_StartYPix,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.Ref1Lon,Ref1LonDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.Ref1Lat,Ref1LatDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  ReadSuccessful := ReadSuccessful and ConvertUserPhotoLonLatToXY(DegToRad(Ref1LonDeg),DegToRad(Ref1LatDeg),
    UserPhoto_StartX,UserPhoto_StartY);

  Val(CurrentPhotoData.Ref2XPix,Ref2XPixel,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.Ref2YPix,Ref2YPixel,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.Ref2Lon,Ref2LonDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  Val(CurrentPhotoData.Ref2Lat,Ref2LatDeg,ErrorCode);
  ReadSuccessful := ReadSuccessful and (ErrorCode=0);

  ReadSuccessful := ReadSuccessful and ConvertUserPhotoLonLatToXY(DegToRad(Ref2LonDeg),DegToRad(Ref2LatDeg),
    Ref2X,Ref2Y);

  if not ReadSuccessful then
    begin
//      ShowMessage('An error occurred reading the calibration data -- please load a different photo');
      Exit;
    end;

  PixelDistSqrd := Sqr(Ref2XPixel - UserPhoto_StartXPix) + Sqr(Ref2YPixel - UserPhoto_StartYPix);
  XYDistSqrd := Sqr(Ref2X - UserPhoto_StartX) + Sqr(Ref2Y - UserPhoto_StartY);
  ReadSuccessful := ReadSuccessful and  (PixelDistSqrd>0) and (XYDistSqrd>0);

  if not ReadSuccessful then
    begin
//      ShowMessage('An error occurred reading the calibration data -- please load a different photo');
      Exit;
    end;

  UserPhoto_PixelsPerXYUnit := Sqrt(PixelDistSqrd/XYDistSqrd);

//Note: Y pixels run backwards to Y coordinate on Moon
  RotationAngle :=
    ArcTan2(Ref2Y - UserPhoto_StartY,Ref2X - UserPhoto_StartX)
    - ArcTan2(UserPhoto_StartYPix - Ref2YPixel,Ref2XPixel - UserPhoto_StartXPix);

//          ShowMessage('Rotation = '+FloatToStr(RadToDeg(RotationAngle)));

  UserPhotoSinTheta := Sin(RotationAngle);
  UserPhotoCosTheta := Cos(RotationAngle);

  ComputeDistanceAndBearing(DegToRad(LonDeg),DegToRad(LatDeg),DegToRad(SubSolLonDeg),DegToRad(SubSolLatDeg),SunAlt,SunAz);
  SunAlt := Pi/2 - SunAlt;


  SunAltDeg := RadToDeg(SunAlt);
  SunAzDeg  := RadToDeg(SunAz);

  Result := ConvertUserPhotoLonLatToXPixYPix(DegToRad(LonDeg),DegToRad(LatDeg),FeatureXPix,FeatureYPix)
    and (FeatureXPix>=0) and (FeatureXPix<=UserPhoto_Width)
    and (FeatureYPix>=0) and (FeatureYPix<=UserPhoto_Height);

end;  {TCalibratedPhotoLoader_Form.FeatureInPhoto}

procedure TCalibratedPhotoLoader_Form.FormCreate(Sender: TObject);
begin
  SetLength(PhotoListData,0);   // make sure these arrays exist -- probably not necessary
  SetLength(SortedListIndex,0);
  LastSelectedPhotoName := '';  // form is not shown unless it contains at least one item
  TargetLon_LabeledNumericEdit.Hide;
  TargetLat_LabeledNumericEdit.Hide;
//  Colongitude_CheckBox.Hide;
end;

procedure TCalibratedPhotoLoader_Form.ChangeFile_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select Calibrated Photo Database list';
      FileName := LTVT_Form.CalibratedPhotosFilename;
      Filter := 'Text file in comma separated format (*.txt)|*.txt|All files|*.*';
      if Execute then
        begin
          LTVT_Form.FileSettingsChanged := FileName <> LTVT_Form.CalibratedPhotosFilename ;
          LTVT_Form.CalibratedPhotosFilename := FileName;
          Filename_Label.Caption := 'Searching in:  '+MinimizeName(LTVT_Form.BriefName(LTVT_Form.CalibratedPhotosFilename),Filename_Label.Canvas,Filename_Label.Width);
        end;
    end;
end;

procedure TCalibratedPhotoLoader_Form.ListPhotos_ButtonClick(Sender: TObject);
var
  IniFile : TIniFile;
  i, MaxI, StyleNum, X_pix, Y_pix, ErrorCode : Integer;

  CalFile : TextFile;
  DataLine, DateString, YearString, MonthString, DayString,
  TimeString, TempFilename, CalCode : String;
  TempPhotoData : TPhotoCalData;

  TargetLonDeg, TargetLatDeg, SunAltDeg, SunAzDeg, LibrationLonDeg : Extended;
  AltAzString, LibrationString, HeaderString : String;

function GreaterThan(const ItemIndex1, ItemIndex2 : Integer) : Boolean;
  begin
    if FilterPhotos_CheckBox.Checked then
      Result := (PhotoListData[ItemIndex1].SunAlt)>(PhotoListData[ItemIndex2].SunAlt)
    else
      Result := ExtractFileName(PhotoListData[ItemIndex1].PhotoCalData.PhotoFilename)>ExtractFileName(PhotoListData[ItemIndex2].PhotoCalData.PhotoFilename);
  end;

procedure SortSunAltitudes;
  procedure Sort(l, r: Integer);
  var
    i, j{, k}: integer;
    x : Extended;
    y : Integer;
  begin {Sort}
    i := l; j := r;
    x := -(PhotoListData[SortedListIndex[(l+r) DIV 2]].SunAlt);   // sort of -SunAngle to get descending list of altitudes
    repeat
      while -(PhotoListData[SortedListIndex[i]].SunAlt) < x do i := i + 1;
      while x < -(PhotoListData[SortedListIndex[j]].SunAlt) do j := j - 1;
      if i <= j then
      begin
        y := SortedListIndex[i]; {k := SI[i];}
        SortedListIndex[i] := SortedListIndex[j]; {SI[i] := SI[j];}
        SortedListIndex[j] := y;  {SI[j] := k;}
        i := i + 1; j := j - 1;
      end;
    until i > j;
    if l < j then Sort(l, j);
    if i < r then Sort(i, r);
  end; {Sort}

begin {SortSunAltitudes}
  Sort(Low(SortedListIndex),High(SortedListIndex));
end;  {SortSunAltitudes}

procedure SortColongitudes;
  procedure Sort(l, r: Integer);
  var
    i, j{, k}: integer;
    x : Extended;
    y : Integer;
  begin {Sort}
    i := l; j := r;
    x := (PhotoListData[SortedListIndex[(l+r) DIV 2]].SunAlt);
    repeat
      while (PhotoListData[SortedListIndex[i]].SunAlt) < x do i := i + 1;
      while x < (PhotoListData[SortedListIndex[j]].SunAlt) do j := j - 1;
      if i <= j then
      begin
        y := SortedListIndex[i]; {k := SI[i];}
        SortedListIndex[i] := SortedListIndex[j]; {SI[i] := SI[j];}
        SortedListIndex[j] := y;  {SI[j] := k;}
        i := i + 1; j := j - 1;
      end;
    until i > j;
    if l < j then Sort(l, j);
    if i < r then Sort(i, r);
  end; {Sort}

begin {SortColongitudes}
  Sort(Low(SortedListIndex),High(SortedListIndex));
end;  {SortColongitudes}

procedure SortFilenames;
  procedure Sort(l, r: Integer);
  var
    i, j{, k}: integer;
    x : String;
    y : Integer;
  begin {Sort}
    i := l; j := r; x := UpperCase(ExtractFileName(PhotoListData[SortedListIndex[(l+r) DIV 2]].PhotoCalData.PhotoFilename));
    repeat
      while UpperCase(ExtractFileName(PhotoListData[SortedListIndex[i]].PhotoCalData.PhotoFilename)) < x do i := i + 1;
      while x < UpperCase(ExtractFileName(PhotoListData[SortedListIndex[j]].PhotoCalData.PhotoFilename)) do j := j - 1;
      if i <= j then
      begin
        y := SortedListIndex[i]; {k := SI[i];}
        SortedListIndex[i] := SortedListIndex[j]; {SI[i] := SI[j];}
        SortedListIndex[j] := y;  {SI[j] := k;}
        i := i + 1; j := j - 1;
      end;
    until i > j;
    if l < j then Sort(l, j);
    if i < r then Sort(i, r);
  end; {Sort}

begin {SortFilenames}
  Sort(Low(SortedListIndex),High(SortedListIndex));
end;  {SortFilenames}

begin {TCalibratedPhotoLoader_Form.ListPhotos_ButtonClick}
  HeaderString := '';
  if Colongitude_CheckBox.Checked then
    begin
      if CurrentTargetPlanet=Moon then
        HeaderString := ' Colongitude  Latitude'
      else
        HeaderString := '     CM       Latitude'
    end
  else if FilterPhotos_CheckBox.Checked then
    HeaderString := '  Altitude     Azimuth';

  if ListLibrations_CheckBox.Checked then HeaderString := HeaderString + '       Lon.       Lat.';

  if (not (FilterPhotos_CheckBox.Checked or Colongitude_CheckBox.Checked)) or (Length(HeaderString)<25) then
    HeaderString := HeaderString + '      File name';

  PhotoListHeaders_Label.Caption := HeaderString;

  if FileFound('LTVT user photo calibration data file',LTVT_Form.CalibratedPhotosFilename,TempFilename) then
    begin
      Screen.Cursor := crHourGlass;

      TargetLonDeg := TargetLon_LabeledNumericEdit.NumericEdit.ExtendedValue;
      TargetLatDeg := TargetLat_LabeledNumericEdit.NumericEdit.ExtendedValue;

      IniFile := TIniFile.Create(LTVT_Form.IniFileName);
      with ListBox1.Font do
        begin
          Name := IniFile.ReadString('LTVT Defaults','CalibratedPhotosFont_Name','QuickType Mono');
          CharSet := IniFile.ReadInteger('LTVT Defaults','CalibratedPhotosFont_CharSet',0);
          StyleNum := IniFile.ReadInteger('LTVT Defaults','CalibratedPhotosFont_Style',0);
          Style := [];
          if (StyleNum and 1)<>0 then Style := Style + [fsBold];
          if (StyleNum and 2)<>0 then Style := Style + [fsItalic];
          if (StyleNum and 4)<>0 then Style := Style + [fsUnderline];
          if (StyleNum and 8)<>0 then Style := Style + [fsStrikeOut];
          Size := IniFile.ReadInteger('LTVT Defaults','CalibratedPhotosFont_Size',8);
          try
            Color := StrToInt(IniFile.ReadString('LTVT Defaults','CalibratedPhotosFont_Color',IntToStr(clBlack)));
          except
            Color := clBlack;
          end;
        end;
      IniFile.Free;

      LTVT_Form.CalibratedPhotosFilename := TempFilename;
      AssignFile(CalFile,LTVT_Form.CalibratedPhotosFilename);
      Reset(CalFile);
      SetLength(PhotoListData,0);

      while not EOF(CalFile) do
        begin
          ReadLn(CalFile,DataLine);
          if (Pos(',',DataLine)>0) then
            begin
              CalCode := UpperCase(LeadingElement(DataLine,','));
              if (CalCode='U0') or (CalCode='U1') then
                begin
                  with TempPhotoData do
                    begin
                      PhotoCalCode := CalCode;
                      DateString  := LeadingElement(DataLine,',');
                      YearString  := LeadingElement(DateString,'/');
                      MonthString := LeadingElement(DateString,'/');
                      DayString   := DateString;
                      try
                        PhotoDate := EncodeDate(IntegerValue(YearString),IntegerValue(MonthString),IntegerValue(DayString));
                      except
                        ShowMessage('Error: "'+YearString+'/'+MonthString+'/'+DayString+'" is not a valid date.');
                        PhotoDate := 0;    // give up
                      end;

                      TimeString := LeadingElement(DataLine,',');
                      try
                        PhotoTime := StrToTime(TimeString);
                      except
                        ShowMessage('Error: "'+TimeString+'" is not a valid date.');
                        PhotoTime := 0;
                      end;

                      PhotoObsELonDeg := LeadingElement(DataLine,',');
                      PhotoObsNLatDeg := LeadingElement(DataLine,',');
                      PhotoObsHt  := LeadingElement(DataLine,',');
                      PhotoWidth  := LeadingElement(DataLine,',');
                      PhotoHeight  := LeadingElement(DataLine,',');
                      SubObsLon := LeadingElement(DataLine,',');
                      SubObsLat := LeadingElement(DataLine,',');
                      SubSolLon := LeadingElement(DataLine,',');
                      SubSolLat := LeadingElement(DataLine,',');
                      Ref1XPix  := LeadingElement(DataLine,',');
                      Ref1YPix  := LeadingElement(DataLine,',');
                      Ref1Lon := LeadingElement(DataLine,',');
                      Ref1Lat  := LeadingElement(DataLine,',');
                      Ref2XPix  := LeadingElement(DataLine,',');
                      Ref2YPix  := LeadingElement(DataLine,',');
                      Ref2Lon  := LeadingElement(DataLine,',');
                      Ref2Lat  := LeadingElement(DataLine,',');
                      InversionCode  := LeadingElement(DataLine,',');
                      PhotoFilename  := ExtractCSV_item(DataLine);
                      Comment  := ExtractCSV_item(DataLine);
                    end;

                  if (not FilterPhotos_CheckBox.Checked) or FeatureInPhoto(TempPhotoData, TargetLonDeg, TargetLatDeg, SunAltDeg, SunAzDeg, X_pix, Y_pix) then
                    begin
                      SetLength(PhotoListData,Length(PhotoListData)+1);
                      with PhotoListData[Length(PhotoListData)-1] do
                        begin
                          PhotoCalData := TempPhotoData;
                          if FilterPhotos_CheckBox.Checked or Colongitude_CheckBox.Checked then
                            begin
                              if Colongitude_CheckBox.Checked then
                                begin
                                  if PhotoCalData.PhotoObsHt='-999' then
                                    begin
                                      SunAlt := -99.99;
                                      SunAz := 0;
                                    end
                                  else
                                    begin
                                      if CurrentTargetPlanet=Moon then
                                        begin
                                          Val(TempPhotoData.SubSolLon,SunAlt,ErrorCode);
                                          if ErrorCode<>0 then
                                            SunAlt := -99.99
                                          else
                                            begin
                                              SunAlt := 90 - SunAlt;  // colongitude
                                              while SunAlt>360 do SunAlt := SunAlt - 360;
                                              while SunAlt<0 do SunAlt := SunAlt + 360;
                                            end;
                                          Val(TempPhotoData.SubSolLat,SunAz,ErrorCode);
                                          if ErrorCode<>0 then SunAz := 0;
                                        end
                                      else
                                        begin
                                          Val(TempPhotoData.SubObsLon,SunAlt,ErrorCode);
                                          if ErrorCode<>0 then
                                            SunAlt := -99.99
                                          else
                                            begin
                                              SunAlt := LTVT_Form.PosNegDegrees(SunAlt,LTVT_Form.PlanetaryLongitudeConvention); // Central Meridian longitude
                                            end;
                                          Val(TempPhotoData.SubSolLat,SunAz,ErrorCode);
                                          if ErrorCode<>0 then SunAz := 0;
                                        end
                                    end;
                                end
                              else
                                begin
                                  if PhotoCalData.PhotoObsHt='-999' then
                                    begin
                                      SunAlt := 90;
                                      SunAz := 0;
                                    end
                                  else
                                    begin
                                      SunAlt := SunAltDeg;
                                      SunAz := SunAzDeg;
                                    end;
                                end;
                            end
                          else
                            begin
                              SunAlt := -999;
                              SunAz := -999;
                            end;
                        end;
                    end;
                end;
            end;
        end;
      CloseFile(CalFile);

      SetLength(SortedListIndex,Length(PhotoListData));
      for i := 0 to (Length(SortedListIndex)-1) do SortedListIndex[i] := i;

      if (Sort_CheckBox.Checked) and (Length(PhotoListData)>1) then
        begin
          if Colongitude_CheckBox.Checked then
            SortColongitudes
          else if FilterPhotos_CheckBox.Checked then
            SortSunAltitudes
          else
            SortFilenames;
        end;

      ListBox1.Items.Clear;

      for i := 0 to (Length(SortedListIndex)-1) do with PhotoListData[SortedListIndex[i]] do
        begin
          if FilterPhotos_CheckBox.Checked or Colongitude_CheckBox.Checked then
            AltAzString := Format('%6.2f %6.1f ',[SunAlt, SunAz])
          else
            AltAzString := '';

          if ListLibrations_CheckBox.Checked then
            begin
              LibrationLonDeg := ExtendedValue(PhotoCalData.SubObsLon);
              while LibrationLonDeg<-180 do LibrationLonDeg := LibrationLonDeg + 360;
              while LibrationLonDeg>180  do LibrationLonDeg := LibrationLonDeg - 360;
              LibrationString := Format('%6.1f %5.1f ',
                [LibrationLonDeg, ExtendedValue(PhotoCalData.SubObsLat)])
            end
          else
            LibrationString := '';

          ListBox1.Items.Add(AltAzString+LibrationString+ExtractFileName(PhotoCalData.PhotoFilename));
        end;

      Filename_Label.Caption := MinimizeName(LTVT_Form.BriefName(LTVT_Form.CalibratedPhotosFilename),Filename_Label.Canvas,Filename_Label.Width);

      Screen.Cursor := LTVT_Form.DefaultCursor;

      with ListBox1 do
        begin
          if Count<=0 then
            begin
              if FilterPhotos_CheckBox.Checked then
                ShowMessage('Sorry - there are no calibrated photos showing the feature at the requested lon/lat in "'+LTVT_Form.CalibratedPhotosFilename+'"')
              else
                ShowMessage('Sorry - there are no calibrated photos listed in "'+LTVT_Form.CalibratedPhotosFilename+'"');
            end
          else
            begin

            // search list to see if last photo displayed is in it
              MaxI := Length(SortedListIndex) - 1;
              i := 0;
              while (i<MaxI) and (PhotoListData[SortedListIndex[i]].PhotoCalData.PhotoFilename<>LastSelectedPhotoName) do Inc(i);

              if (i<Count) and (PhotoListData[SortedListIndex[i]].PhotoCalData.PhotoFilename=LastSelectedPhotoName) then
                ItemIndex := i
              else
                ItemIndex := 0;

              ListBox1Click(Self);
            end;
        end;
    end
  else
    begin
      ShowMessage('Unable to find '+LTVT_Form.CalibratedPhotosFilename);
    end;

end;  {TCalibratedPhotoLoader_Form.ListPhotos_ButtonClick}

procedure TCalibratedPhotoLoader_Form.FilterPhotos_CheckBoxClick(Sender: TObject);
begin
  if FilterPhotos_CheckBox.Checked then
    begin
      TargetLon_LabeledNumericEdit.Show;
      TargetLat_LabeledNumericEdit.Show;
//      Colongitude_CheckBox.Show;
    end
  else
    begin
      TargetLon_LabeledNumericEdit.Hide;
      TargetLat_LabeledNumericEdit.Hide;
//      Colongitude_CheckBox.Hide;
    end;
end;

procedure TCalibratedPhotoLoader_Form.CopyInfo_ButtonClick(Sender: TObject);
var
  SavedShortDateFormat, SavedLongTimeFormat : String;
begin
  SavedShortDateFormat := ShortDateFormat;
  SavedLongTimeFormat := LongTimeFormat;

  ShortDateFormat := 'yyyy mmm dd';
  LongTimeFormat := 'hh:nn';

  with PhotoListData[SortedListIndex[ListBox1.ItemIndex]].PhotoCalData do
    begin
      Clipboard.AsText := Format('|| %s || || %s - %s UT ||',
        [ExtractFileName(PhotoFilename), DateToStr(PhotoDate), TimeToStr(PhotoTime)]);
    end;

  ShortDateFormat := SavedShortDateFormat;
  LongTimeFormat := SavedLongTimeFormat;

end;

procedure TCalibratedPhotoLoader_Form.ShowNote_ButtonClick(Sender: TObject);
begin
  with LTVT_Form.PopupMemo do
    begin
      Caption := 'Note related to "'+ExtractFileName(SelectedPhotoData.PhotoFilename)+'"';
      ClearMemoArea;
      Memo.Lines.Add(SelectedPhotoData.Comment);
      ShowModal;
    end;
end;

procedure TCalibratedPhotoLoader_Form.ListBox1KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then
    SelectPhoto_Button.Click
  else
    LTVT_Form.DisplayF1Help(Key,Shift,'CalibratedPhotoSelection_Form.htm');
end;

procedure TCalibratedPhotoLoader_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'CalibratedPhotoSelection_Form.htm');
end;

procedure TCalibratedPhotoLoader_Form.FormShow(Sender: TObject);
begin
  if CurrentTargetPlanet=Moon then
    begin
      Colongitude_CheckBox.Caption := 'By colongitude';
      Colongitude_CheckBox.Hint := 'Display and sort by colongitude';
      SubObsPt_Label.Hint := 'Selenographic longitude/latitude of center point on Moon (also called librations)';
      SubSolPt_Label.Hint := 'Selenographic longitude/latitude of point on Moon directly beneath Sun';
    end
  else
    begin
      Colongitude_CheckBox.Caption := 'By CM';
      Colongitude_CheckBox.Hint := 'Display and sort by Central Meridian longitude';
      SubObsPt_Label.Hint := 'Longitude/latitude of center point on '+CurrentPlanetName;
      SubSolPt_Label.Hint := 'Longitude/latitude of point on '+CurrentPlanetName+' directly beneath Sun';
    end;
end;

end.
