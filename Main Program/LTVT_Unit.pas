unit LTVT_Unit;
{project last changed 2009 Nov 19  --  see:

C:\Program Files\Borland\Delphi6\Projects\MyProjects\Astron\Henrik%20Terminator\LTVT_Revision_History.txt

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, ExtCtrls, StdCtrls, Math, MPVectors, Win_Ops,
  ComCtrls, DateUtils, JPEG, H_JPL_Ephemeris, MoonPosition, H_ClockError,
  MP_Defs, Constnts, ExtDlgs, RGB_Library, IniFiles, Menus,
  H_HTMLHelpViewer, Buttons, PopupMemo, LunarDEM_Data;

type
  TCrater = record
    UserFlag,
    Name,
    LatStr,
    LonStr : string;
    Lon,  {in radians}
    Lat  : extended; {in radians}
    NumericData : string;  {in km}
    USGS_Code : string; {'AL' = albedo feature, 'AA' = crater, 'SF' = satellite feature (lettered crater), 'LF' = landing site, all other types recognizable from name}
    AdditionalInfo1, AdditionalInfo2 : string;
    end;

  TCraterInfo = record  {holds info on all features currently indicated by dots}
    CraterData : TCrater;
    Dot_X, Dot_Y : integer;  {pixel at which feature is plotted}
    end;

  TSurfaceReadout = record
    Lon_rad,
    Lat_rad,
    HeightDev_km : Single;
    end;

type
  TLTVT_Form = class(TForm)
    SubObs_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    Label1: TLabel;
    SubObs_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    SubSol_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    Label2: TLabel;
    SubSol_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    DrawDots_Button: TButton;
    OpenDialog1: TOpenDialog;
    Date_DateTimePicker: TDateTimePicker;
    Time_DateTimePicker: TDateTimePicker;
    CraterThreshold_LabeledNumericEdit: TLabeledNumericEdit;
    DrawTexture_Button: TButton;
    EstimateData_Button: TButton;
    MoonElev_Label: TLabel;
    SavePictureDialog1: TSavePictureDialog;
    Colongitude_Label: TLabel;
    PercentIlluminated_Label: TLabel;
    EstimatedData_Label: TLabel;
    MouseLonLat_Label: TLabel;
    SunAngle_Label: TLabel;
    Zoom_LabeledNumericEdit: TLabeledNumericEdit;
    ResetZoom_Button: TButton;
    ProgressBar1: TProgressBar;
    Label6: TLabel;
    StatusLine_Label: TLabel;
    ET_Label: TLabel;
    MT_Label: TLabel;
    CraterName_Label: TLabel;
    OverlayDots_Button: TButton;
    LoResUSGS_RadioButton: TRadioButton;
    HiResUSGS_RadioButton: TRadioButton;
    Clementine_RadioButton: TRadioButton;
    Now_Button: TButton;
    GeometryType_Label: TLabel;
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    About_MainMenuItem: TMenuItem;
    Tools1: TMenuItem;
    GoTo_MainMenuItem: TMenuItem;
    Image_PopupMenu: TPopupMenu;
    DrawLinesToPoleAndSun_RightClickMenuItem: TMenuItem;
    IdentifyNearestFeature_RightClickMenuItem: TMenuItem;
    RefPtDistance_Label: TLabel;
    SetRefPt_RightClickMenuItem: TMenuItem;
    Goto_RightClickMenuItem: TMenuItem;
    Files1: TMenuItem;
    Exit_MainMenuItem: TMenuItem;
    Saveoptions_MainMenuItem: TMenuItem;
    Geometry_GroupBox: TGroupBox;
    MoonDisplay_GroupBox: TGroupBox;
    MousePosition_GroupBox: TGroupBox;
    Label4: TLabel;
    SearchPhotoSessions_Button: TButton;
    SetLocation_Button: TButton;
    HelpContents_MenuItem: TMenuItem;
    FindJPLfile_MenuItem: TMenuItem;
    Changetexturefile_MenuItem: TMenuItem;
    LabelDots_Button: TButton;
    AddLabel_RightClickMenuItem: TMenuItem;
    ChangeExternalFiles_MainMenuItem: TMenuItem;
    SaveImage_Button: TButton;
    Predict_Button: TButton;
    Changelabelpreferences_MainMenuItem: TMenuItem;
    ChangeCartographicOptions_MainMenuItem: TMenuItem;
    ESCkeytocancel_RightClickMenuItem: TMenuItem;
    ChangeMouseOptions_MainMenuItem: TMenuItem;
    MouseOptions_RightClickMenuItem: TMenuItem;
    CalibratePhoto_MainMenuItem: TMenuItem;
    LoadCalibratedPhoto_MainMenuItem: TMenuItem;
    UserPhoto_RadioButton: TRadioButton;
    Gamma_LabeledNumericEdit: TLabeledNumericEdit;
    MoonDiameter_Label: TLabel;
    LabelNearestDot_RightClickMenuItem: TMenuItem;
    LTO_RadioButton: TRadioButton;
    GridSpacing_LabeledNumericEdit: TLabeledNumericEdit;
    DrawCircles_CheckBox: TCheckBox;
    RotationAngle_LabeledNumericEdit: TLabeledNumericEdit;
    Calibrateasatellitephoto1: TMenuItem;
    NearestDotToReferencePoint_RightClickMenuItem: TMenuItem;
    Help_RightClickMenuItem: TMenuItem;
    DrawCircle_RightClickMenuItem: TMenuItem;
    DrawCircle_MainMenuItem: TMenuItem;
    SaveImage_MainMenuItem: TMenuItem;
    SearchUncalibratedPhotos_MainMenuItem: TMenuItem;
    MarkCenter_CheckBox: TCheckBox;
    TabulateLibrations_MainMenuItem: TMenuItem;
    CountDots_RightClickMenuItem: TMenuItem;
    OpenAnLTOchart1: TMenuItem;
    DrawRuklGrid_MainMenuItem: TMenuItem;
    Recordshadowmeasurement_RightClickMenuItem: TMenuItem;
    LabelFeatureAndSatellites_RightClickMenuItem: TMenuItem;
    ShowEarth_MainMenuItem: TMenuItem;
    DrawLimb_MainMenuItem: TMenuItem;
    Image1: TImage;
    ImageSize_Label: TLabel;
    DrawDEM_Button: TButton;
    ChangeDemOptions_MainMenuItem: TMenuItem;
    ThreeD_CheckBox: TCheckBox;
    DrawingMap_Label: TLabel;
    Abort_Button: TButton;
    procedure DrawDots_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawTexture_ButtonClick(Sender: TObject);
    procedure EstimateData_ButtonClick(Sender: TObject);
    procedure ResetZoom_ButtonClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OverlayDots_ButtonClick(Sender: TObject);
    procedure Now_ButtonClick(Sender: TObject);
    procedure Time_DateTimePickerEnter(Sender: TObject);
    procedure SubObs_Lon_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure SubSol_Lon_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure SubObs_Lat_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure SubSol_Lat_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure Date_DateTimePickerChange(Sender: TObject);
    procedure Time_DateTimePickerChange(Sender: TObject);
    procedure ObserverLongitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverLatitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure Exit_MainMenuItemClick(Sender: TObject);
    procedure About_MainMenuItemClick(Sender: TObject);
    procedure GoTo_MainMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrawLinesToPoleAndSun_RightClickMenuItemClick(Sender: TObject);
    procedure IdentifyNearestFeature_RightClickMenuItemClick(Sender: TObject);
    procedure SetRefPt_RightClickMenuItemClick(Sender: TObject);
    procedure ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
    procedure Saveoptions_MainMenuItemClick(Sender: TObject);
    procedure SaveImage_MainMenuItemClick(Sender: TObject);
    procedure SearchPhotoSessions_ButtonClick(Sender: TObject);
    procedure SetLocation_ButtonClick(Sender: TObject);
    procedure HelpContents_MenuItemClick(Sender: TObject);
    procedure FindJPLfile_MenuItemClick(Sender: TObject);
    procedure Changetexturefile_MenuItemClick(Sender: TObject);
    procedure Goto_RightClickMenuItemClick(Sender: TObject);
    procedure LabelDots_ButtonClick(Sender: TObject);
    procedure AddLabel_RightClickMenuItemClick(Sender: TObject);
    procedure ChangeExternalFiles_MainMenuItemClick(Sender: TObject);
    procedure SaveImage_ButtonClick(Sender: TObject);
    procedure Predict_ButtonClick(Sender: TObject);
    procedure Changelabelpreferences_MainMenuItemClick(Sender: TObject);
    procedure ChangeCartographicOptions_MainMenuItemClick(Sender: TObject);
    procedure ChangeMouseOptions_MainMenuItemClick(Sender: TObject);
    procedure MouseOptions_RightClickMenuItemClick(Sender: TObject);
    procedure CalibratePhoto_MainMenuItemClick(Sender: TObject);
    procedure LoadCalibratedPhoto_MainMenuItemClick(Sender: TObject);
    procedure Now_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Date_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Time_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetLocation_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EstimateData_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SubObs_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SubObs_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SubSol_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SubSol_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CraterThreshold_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DrawDots_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawTexture_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OverlayDots_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabelDots_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoResUSGS_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HiResUSGS_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Clementine_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UserPhoto_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Gamma_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Zoom_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure ResetZoom_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaveImage_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Predict_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchPhotoSessions_ButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure LabelNearestDot_RightClickMenuItemClick(Sender: TObject);
    procedure OpenAnLTOchart1Click(Sender: TObject);
    procedure LTO_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RotationAngle_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridSpacing_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DrawCircles_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Calibrateasatellitephoto1Click(Sender: TObject);
    procedure NearestDotToReferencePoint_RightClickMenuItemClick(Sender: TObject);
    procedure Help_RightClickMenuItemClick(Sender: TObject);
    procedure DrawCircle_RightClickMenuItemClick(Sender: TObject);
    procedure DrawCircle_MainMenuItemClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchUncalibratedPhotos_MainMenuItemClick(Sender: TObject);
    procedure MarkCenter_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabulateLibrations_MainMenuItemClick(Sender: TObject);
    procedure CountDots_RightClickMenuItemClick(Sender: TObject);
    procedure DrawRuklGrid_MainMenuItemClick(Sender: TObject);
    procedure Recordshadowmeasurement_RightClickMenuItemClick(
      Sender: TObject);
    procedure Image_PopupMenuPopup(Sender: TObject);
    procedure LabelFeatureAndSatellites_RightClickMenuItemClick(
      Sender: TObject);
    procedure ShowEarth_MainMenuItemClick(Sender: TObject);
    procedure DrawLimb_MainMenuItemClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DrawDEM_ButtonClick(Sender: TObject);
    procedure ChangeDemOptions_MainMenuItemClick(Sender: TObject);
    procedure DrawDEM_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ThreeD_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Abort_ButtonClick(Sender: TObject);
  private
    { Private declarations }
    fXScale, fXOffset,
    fYScale, fYOffset : extended;      // from JimsGraph1
  public
    { Public declarations }
    IniFileName : string; {file used for saving default parameters}

    BasePath : string;  // path to LTVT.exe

    ProposedFilename : String; // for saving file

    DefaultCursor : TCursor;

    DEM_data : TKaguyaData;
    SurfaceData : array of array of TSurfaceReadout;  // used for mouse readout when DrawingMode=DEM_3D
    SurfaceData_NoDataValue : Single;

    EarthTextureFilename, DEM_Filename,
    CraterFilename, JPL_Filename, JPL_FilePath, LoResFilename,
    HiResFilename, ClementineFilename, NormalPhotoSessionsFilename,
    CalibratedPhotosFilename, ObservatoryListFilename,
    Tex3MinLonText, Tex3MaxLonText, Tex3MinLatText, Tex3MaxLatText,
    ObservatoryComboBoxDefaultText, ObservatoryNoFileText  : string;

    p1Text, p2Text, tauText : string; // arc-sec Mean Earth System offsets -- read from ini file
    ObserverLongitudeText, ObserverLatitudeText, ObserverElevationText : string; // altered via SelectObserverLocation_Form

    DrawingMode : (DotMode, TextureMode, EarthView, DEM_2D, DEM_3D);

    MapPtr : ^TBitmap;  // image used to draw last texture
    MinLon, MaxLon, MinLat, MaxLat,  {of TextureMap}
    XPixPerRad, YPixPerRad : Extended;  {of TextureMap}
    LastImageWidth, LastImageHeight : Integer;

    LastMouseClickPosition : TPoint;

// variables set with Cartographic Options form
    LinuxCompatibilityMode : Boolean;
    StartWithCurrentUT : Boolean;
    OrientationMode : (LineOfCusps, Cartographic, Equatorial, AltAz);
    IncludeLibrationCircle : boolean;
    IncludeTerminatorLines : boolean;
    LibrationCircleColor : TColor;
    NoDataColor : TColor;
    AnnotateSavedImages : Boolean;
    SavedImageUpperLabelsColor : TColor;
    SavedImageLowerLabelsColor : TColor;

// variables set with DEM Options form
    DemIncludesCastShadows : Boolean;
    DemCastShadowColor : TColor;
    MultiplyDemByTexture3 : Boolean;
    DisplayDemComputationTimes : Boolean;
    StayInDemModeOnRefresh : Boolean;
    RigorousDemNormals : Boolean;
    DrawTerminatorOnDem : Boolean;
    DemGridStepMultiplier : Extended;


    MoonRadius : extended;
    Point1Lon, Point1Lat, Point2Lon, Point2Lat : extended;  // set when measuring distance

// set during MouseMove -- used to Record Shadow Measuremt
    CurrentMouseX, CurrentMouseY, CurrentElevationDifference_m : Extended;
    ShadowTipVector : TVector;
// set in FormCreate
    ShadowProfileFilename : String;
// set on file initiation with Circle Drawing Tool
    ShadowProfileCenterVector : TVector; // center of crater being profiled, normalized to unit length
    SnapShadowPointsToPlanView : Boolean; // set from dot/label preferences form

    RefX, RefY, RefPtLon, RefPtLat, RefPtSunAngle, RefPtSunBearing : extended;

    CursorType : (UseDefaultCursor, UseCrosshairCursor);
    RefPtReadoutMode : (NoRefPtReadout, DistanceAndBearingRefPtMode, PixelDataReadoutMode,
      ShadowLengthRefPtMode, InverseShadowLengthRefPtMode, RayHeightsRefPtMode);

    LabelXPix_Offset, LabelYPix_Offset,
    Corrected_LabelXPix_Offset, Corrected_LabelYPix_Offset : Integer; // displacement from dot to label
    // first is as it appears on Label Options form; second is corrected for Font size
    IncludeFeatureName, FullCraterNames, IncludeFeatureSize, IncludeUnits,
    IncludeDiscontinuedNames, RadialDotOffset : Boolean;

    DotSize : integer;
    MediumCraterDiam, LargeCraterDiam : Extended;
    NonCraterColor, SmallCraterColor, MediumCraterColor, LargeCraterColor,
    CraterCircleColor, ReferencePointColor : TColor;

    JPL_Data : TextFile;  {optional source of ephermis info: set by SelectFile; used by RetrieveData}
    LoRes_TextureMap : TBitmap; {set to USGS map on form CREATE -- so always available}
    LoRes_Texture_Loaded : boolean;

    HiRes_TextureMap : TBitmap; {it takes several seconds for the initial load of the hi-res texture from disk,
      it also produces rather grainy full-moon images.  Therefore, although the on-screen images are drawn in
      about the same time, this file is loaded iff specifically requested}
    HiRes_Texture_Loaded : boolean;

    Clementine_TextureMap : TBitmap; {it takes several seconds for the initial load of the hi-res texture from disk,
      it also produces rather grainy full-moon images.  Therefore, although the on-screen images are drawn in
      about the same time, this file is loaded iff specifically requested}
    Clementine_Texture_Loaded : boolean;

    Earth_TextureMap : TBitmap;
    Earth_Texture_Loaded : boolean;

    TextureFilename : String; // identifies source of last background image used by Dots or Texture click

    LTO_Image : TBitmap;

    InvertLR, InvertUD : boolean;  // these are altered with the H_DisplayOptions form
    SkyColor, DotModeSunlitColor, DotModeShadowedColor : TColor;

    ShadowLineLength_pixels : Integer;

  {the following are set by CalculateGeometry}
    SubObsvrVector, SubSolarVector : TVector; {in Selenographic coordinates, based on NumericInput boxes}
//    CosTheta,                        {angle from projected center to sub-solar point}
    Solar_X_Projection : extended;   {projected x-coordinate of sub-solar point}
    XPrime_UnitVector, YPrime_UnitVector, ZPrime_UnitVector : TVector; {basis vectors for projected image
      where z' = towards observer;  y' = towards north terminator cusp;  x' = y' Cross z' = to right ("East")}
  {CalculateGeometry also sets range of Image1 per data specified in orthographic Center X, Center Y
    and Zoom numeric edits}

    ManualRotationDegrees : extended; {[deg]}
    SunRad : extended; {semi-diameter of Sun [radians] -- initialized to 1920/2 arc-sec, re-set by EstimateData_ButtonClick}

    SubSolarPoint : TPolarCoordinates;   {set by CalculateGeometry}
    SinSSLat, CosSSLat : extended;

    CraterList,  {current feature list}
    PrimaryCraterList : array of TCrater; {list of primary craters in list used for current overlay}
    CraterInfo : array of TCraterInfo; {list of craters represented by dots in current overlay}

    CraterListCurrent, GoToListCurrent : Boolean;
    LastCraterListFileRecord : TSearchRec;

    IdentifySatellites : Boolean;

 // following set when red line is drawn in shadow measuring mode on user photo
    RefPtVector,   // full vector at MoonRadius in Selenographic system
    ShadowDirectionVector : TVector;  // unit (1 km) vector parallel or anti-parallel to solar rays, depending on mode
    RefPtUserX, RefPtUserY,   // position of start of red line in X-Y system of original photo
    ShadowDirectionUserDistance : Extended; // amount of travel in photo X-Y system for 1 unit of ShadowDirectionVector

// The following are used for labeling saved images:
    ManualMode : boolean;  // current status of geometry labels

// Set by clicking EstimateData button
    ImageDate, ImageTime : TDateTime;
    ImageGeocentric : boolean;
    ImageObsLon, ImageObsLat, ImageObsElev : extended;

// Set by CalculateGeometry
    ImageManual, ImageIncludesCastShadows : boolean;  // geometry was computed using manual settings
    ImageSubSolLon, ImageSubSolLat, ImageSubObsLon, ImageSubObsLat,
    ImageCenterX, ImageCenterY, ImageZoom, ImageGamma : extended;

// Initially False, set to True if any file names have changed from their defaults.
    FileSettingsChanged : Boolean;
    OldFilename : string;  // not really global but used in many routines to check for change.

    ShowDetails : Boolean;
    PopupMemo : TPopupMemo_Form;
    AbortDrawing : Boolean;

// Set by GoTo when a cross is drawn per data on GoTo form
//    MarkedPtLonText, MarkedPtLatText : string;

// Set by Transfer button in LTO_Viewer
    LTO_MapMode : (LTO_map, Mercator_map, Lambert_map);

    LTO_Filename : String;
    LTO_CenterLon, LTO_CenterLat, LTO_CenterXPix, LTO_CenterYPix,
    LTO_HorzPixPerDeg, LTO_VertPixPerDeg,
    LTO_SinTheta, LTO_CosTheta,  // rotation angle
    LTO_DegLonPerXPixel, LTO_DegLatPerYPixel : Extended;

    LTO_VertCorrection, LTO_MercatorScaleFactor,
    LTO_Lambert_ScaleFactor, LTO_Lambert_Lat1, LTO_Lambert_Lat2,
    LTO_Lambert_n, LTO_Lambert_F, LTO_Lambert_Rho_zero
     : Extended;

    procedure SetRange(const Xmin, Xmax, Ymin, Ymax : extended);

    function XPix(const X : extended) : integer;
    function YPix(const Y : extended) : integer;
    function XValue(const XPix : integer) : extended;
    function YValue(const YPix : integer) : extended;
    procedure MoveToDataPoint(const X,Y : extended);
    procedure LineToDataPoint(const X,Y : extended);
    procedure PlotDataPoint(const X,Y : extended;  const PixelHt : integer;  const BorderColor, FillColor : TColor);

    function EphemerisDataAvailable(const MJD : Extended) : Boolean;

    function CorrectedDateTimeToStr(const DateTimeToPrint : TDateTime) : String;
    {corrects negative DateTimes (prior to 1/1/1900) so they will print properly
     with DateToStr}

    function BooleanToYesNo(const BooleanState: boolean): string;
    {returns 'yes' or 'no' for True and False}

    function YesNoToBoolean(const OptionString : string): boolean;
    {returns True if first letter of string is 'Y' or 'y'; otherwise False}

    function PosNegDegrees(const Angle : extended) : extended;
    {Adjusts Angle (in degrees) to range -180 .. +180}

    function LongitudeString(const LongitudeDegrees : extended; const DecimalPoints : integer): string;
    {returns value in range 180.nnn W to 180.nnn E}

    function LatitudeString(const LatitudeDegrees : extended; const DecimalPoints : integer): string;
    {returns value in range 90.nnn S to 90.nnn N}

    function RefreshCraterList : Boolean;
    {reads feature name list from disk}

    function PositionInCraterInfo(const ScreenX, ScreenY : integer) : boolean;
    {tests if there is already a known dot at the stated pixel position}

    function FullFilename(const ShortName : string): string;
    {adds BasePath to ShortName (filename) if ShortName has none}

    procedure SaveDefaultLabelOptions;
    {saves current map labeling font, position, & other choices to ini file}

    procedure RestoreDefaultLabelOptions;
    {retrieves current map labeling font, position, & other choices from ini file.}

    procedure WriteLabelOptionsToForm;

    procedure ReadLabelOptionsFromForm;

    procedure SaveDemOptions;

    procedure RestoreDemOptions;

    procedure WriteDemOptionsToForm;

    procedure ReadDemOptionsFromForm;

    procedure SaveCartographicOptions;
    {saves items items controlled by Cartographic Options form}

    procedure RestoreCartographicOptions;
    {saves items items controlled by Cartographic Options form}

    procedure WriteCartographicOptionsToForm;

    procedure ReadCartographicOptionsFromForm;

    procedure SaveMouseOptions;

    procedure RestoreMouseOptions;

    procedure WriteMouseOptionsToForm;

    procedure ReadMouseOptionsFromForm;

    procedure SaveFileOptions;

    procedure RestoreFileOptions;

    procedure WriteFileOptionsToForm;

    procedure ReadFileOptionsFromForm;

    procedure SaveLocationOptions;

    procedure RestoreLocationOptions;

    procedure WriteLocationOptionsToForm;

    procedure ReadLocationOptionsFromForm;

    procedure RefreshGoToList;

    procedure ClearImage;
    {clears Graph area and various labels}

    function CalculateGeometry : Boolean;
    {uses Sub-observer and Sub-solar point input boxes to determine parameters cited above; also sets range of plot,
     returns True iff successfully completed}

    function ConvertXYtoVector(const XProj, YProj, MaxRadius : extended;  Var PointUnitVector : TVector) : Boolean;
    {converts from orthographic +/-1.0 system to (X,Y,Z) in selenographic system with radius = 1;
     setting MaxRadius>1 transforms points outside nominal limb (but within that limit) to vector to limb}

    function ConvertXYtoLonLat(const XProj, YProj : extended;  Var Point_Lon, Point_Lat : extended) : Boolean;
    {converts from orthographic +/-1.0 system to longitude and latitude [radians] in selenographic system}

    procedure DrawCircle(const CenterLonDeg, CenterLatDeg, RadiusDeg : Extended; CircleColor : TColor);
    {draws a pixel-wide circle in the requested color and of the requested radius about the center point}

    procedure DrawCross(const CenterXPixel, CenterYPixel, CrossSize : Integer; const CrossColor : TColor);
    {CrossSize determines extension of arms about central point. CrossSize=0 gives single pixel dot.
     Nothing is drawn if CrossSize<0.}

    procedure DrawGrid;

    procedure MarkCenter;

    procedure DrawTerminator;
    {draws segment of ellipse in current Pen color over current Image1}

    procedure ImageLoadProgress(Sender: TObject; Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
      const R: TRect; const Msg: String);

    procedure SetManualGeometryLabels;

    procedure SetEstimatedGeometryLabels;

    procedure GoToLonLat(const Long_Deg, Lat_Deg, NormalizedRadius : extended);
     {attempts to set X-Y center to requested point, draw new texture map, and label point in aqua}

    procedure GoToXY(const X, Y : extended);
     {same except based on xi-eta style input}

    procedure RefreshImage;
     {redraws in Dots or Texture based on current setting}

    procedure HideMouseMoveLabels;

    procedure FindAndLoadJPL_File(const TrialFilename : string);

    function ConvertLonLatToUserPhotoXY(const Lon_radians, Lat_radians, Radius_km : extended; var UserX, UserY : extended) : Boolean;
    {given position on Moon, computes projected position in X-Y system of a calibrated image,
     where calibration is based on sphere of radius MoonRadius}

    function ConvertUserPhotoXYtoLonLat(const UserX, UserY, Radius_km : extended; var  Lon_radians, Lat_radians : extended) : Boolean;
    {inverse of preceding operation, determines longitude and latitude of point that would appear at specified
     position in image X-Y system if it originated on a sphere of radius MoonRadius}

    function ConvertLonLatToUserPhotoXPixYPix(const Lon_radians, Lat_radians, Radius_km : extended; var UserPhotoXPix, UserPhotoYPix : Integer) : Boolean;

//    procedure ConvertUserPhotoXPixYPixToXY(const UserPhotoXPix, UserPhotoYPix : integer; var UserX, UserY : extended);

    procedure LabelDot(const DotInfo : TCraterInfo);

    function FindClosestDot(var DotIndex : Integer) : Boolean;
    {returns index in CraterInfo[] of dot closest to last mouse click}

    procedure MarkXY(const X, Y : extended; const MarkColor : TColor);
    {draws cross at indicated point in "eta-xi" system}

    function  CalculateSubPoints(const MJD, ObsLon, ObsLat, ObsElev : extended; var SubObsPt, SubSunPt : TPolarCoordinates) : Boolean;
    {attempts to calculate sub-observer and sub-solar points on Moon, returns True iff successful}

    function BriefName(const FullName : string) : string;
    {strip off path if it is the same as LTVT.exe}

    function UpperCaseParentName(const FeatureName, FT_Code : String) : String;
    {attempts to extract parent part of FeatureName based on USGS Feature Type code; returns FeatureName if unsuccessful}

    function LabelString(const FeatureToLabel : TCraterInfo;
      const IncludeName, IncludeParent, IncludeSize, IncludeUnits, ShowMore : Boolean) : String;
    {returns string used for adding labels to map}

    function LTO_SagCorrectionDeg(const DelLonDeg, LatDeg : Extended) : Extended;
    {amount to be added to true Latitude to get Latitude as read on central meridian;
     DelLonDeg = displacement in longitude from center of map}

    function ConvertLTOLonLatToXY(const LTO_LonDeg, LTO_LatDeg : Extended; var LTO_XPix, LTO_YPix : Integer) : Boolean;

    function LookUpPixelData(const Lon, Lat : Extended; var RawXPix, RawYPix : Integer; var PixelData : TPixelValue) : Boolean;
    {looks for specified lon/lat in bitmap used for drawing texture; returns false if no data}

    procedure DisplayF1Help(const PressedKey : Word; const ShiftState : TShiftState; const HelpFileName : String);
    {launches .chm help on indicated page if PressedKey=F1}

  end;

var
  LTVT_Form: TLTVT_Form;

implementation

uses FileCtrl, H_Terminator_About_Unit, H_Terminator_Goto_Unit, H_Terminator_SetYear_Unit,
  H_Terminator_SelectObserverLocation_Unit, H_MoonEventPredictor_Unit,
  H_PhotosessionSearch_Unit, H_Terminator_LabelFontSelector_Unit,
  H_ExternalFileSelection_Unit, H_CartographicOptions_Unit, NumericEdit,
  H_MouseOptions_Unit, H_PhotoCalibrator_Unit, H_CalibratedPhotoSelector_Unit,
  LTO_Viewer_Unit, Satellite_PhotoCalibrator_Unit, CircleDrawing_Unit,
  LibrationTabulator_Unit, MapFns_Unit, DEM_Options_Unit;

{$R *.dfm}

const
  ProgramVersion = '0.20.1';

// note: the following constants specify (in degrees) that texture files span
//   the full lunar globe.  They should not be changed.
  Tex3MinLon_DefaultText = '-180';
  Tex3MaxLon_DefaultText = '180';
  Tex3MinLat_DefaultText = '-90';
  Tex3MaxLat_DefaultText = '90';

var
  UserPhotoData : TPhotoCalData;
  UserPhotoLoaded : Boolean;
  UserPhoto : TBitmap;

  UserPhotoType : (EarthBased, Satellite);

  UserPhoto_SubObsVector,
  SatelliteVector, // for satellite photos this is the position of the camera relative to the Moon's center in selenodetic system
// for EarthBased photos, the following is a system pointing from the Sub-observer point to the Moon's center
// for Satellite photos the Z-axis points from the camera position (SatelliteVector) to the principal ground point
  UserPhoto_XPrime_Unit_Vector, UserPhoto_YPrime_Unit_Vector, UserPhoto_ZPrime_Unit_Vector : TVector;
  UserPhoto_StartXPix, UserPhoto_StartYPix, UserPhoto_InversionCode : Integer;
  UserPhoto_StartX, UserPhoto_StartY, UserPhoto_PixelsPerXYUnit,
  UserPhotoSinTheta, UserPhotoCosTheta : Extended;

procedure TLTVT_Form.SetRange(const Xmin, Xmax, Ymin, Ymax : extended);
begin
  fXOffset := Xmin;
  fXScale  := Image1.Width/(Xmax - Xmin);
  fYOffset := Ymax;
  fYScale  := Image1.Height/(Ymin - Ymax);
end;

function RoundToSmallInt(const X : extended) : integer;
begin
  if X>=32767 then
    Result := 32767
  else if X<=-32768 then
    Result := -32768
  else
    Result := Round(X);
end;

function TLTVT_Form.XPix(const X : extended) : integer;
begin
  Result := RoundToSmallInt(fXScale*(X - fXOffset));
end;

function TLTVT_Form.YPix(const Y : extended) : integer;
begin
  Result := RoundToSmallInt(fYScale*(Y - fYOffset));
end;

function TLTVT_Form.XValue(const XPix : integer) : extended;
begin
  Result := XPix/fXScale + fXOffset;
end;

function TLTVT_Form.YValue(const YPix : integer) : extended;
begin
  Result := YPix/fYScale + fYOffset;
end;

procedure TLTVT_Form.MoveToDataPoint(const X,Y : extended);
begin
  Image1.Canvas.MoveTo(XPix(X),YPix(Y))
end;

procedure TLTVT_Form.LineToDataPoint(const X,Y : extended);
begin
  Image1.Canvas.LineTo(XPix(X),YPix(Y))
end;

procedure TLTVT_Form.PlotDataPoint(const X,Y : extended;  const PixelHt : integer;  const BorderColor, FillColor : TColor);
{plots data point with a square of the specified pixel height and width}
var
  OldPen : TPen;
  OldBrush : TBrush;
  HalfSize, CenterXPixel, CenterYPixel : integer;
begin
  with Image1.Canvas do
    begin
      OldPen := TPen.Create;
      OldBrush := TBrush.Create;
      OldPen.Assign(Pen);
      OldBrush.Assign(Brush);

      Pen.Color   := BorderColor;
      Pen.Style   := psSolid;
      Pen.Width   := 1;  {Hardwire for now}

      Brush.Color := FillColor;

      CenterXPixel := XPix(X);
      CenterYPixel := YPix(Y);
      HalfSize := PixelHt div 2;
      Rectangle(CenterXPixel-HalfSize, CenterYPixel-HalfSize, CenterXPixel+HalfSize, CenterYPixel+HalfSize);

      Pen.Assign(OldPen);
      Brush.Assign(OldBrush);
      OldPen.Free;
      OldBrush.Free;
    end;
end;

function TLTVT_Form.ConvertLonLatToUserPhotoXY(const Lon_radians, Lat_radians, Radius_km : extended; var UserX, UserY : extended) : Boolean;
var
  CosTheta : Extended;
  FeatureVector, LineOfSight : TVector;
begin {TLTVT_Form.ConvertLonLatToUserPhotoXY}
  if UserPhotoType=Satellite then
    begin
      Result := False;

      PolarToVector(Lon_radians, Lat_radians, Radius_km, FeatureVector);

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
      PolarToVector(Lon_radians,Lat_radians,Radius_km/MoonRadius,FeatureVector); // vector in selenographic system
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
end;  {TLTVT_Form.ConvertLonLatToUserPhotoXY}

function TLTVT_Form.ConvertUserPhotoXYtoLonLat(const UserX, UserY, Radius_km : extended; var  Lon_radians, Lat_radians : extended) : Boolean;
{inverse of preceding operation, determines longitude and latitude of point that would appear at specified
 position in image X-Y system if it originated on a sphere of radius MoonRadius}
var
  FeatureDirection, ScratchVector : TVector;
  MinusDotProd, Discrim, Distance : Extended;
  XYSqrd, RadiusFactorSqrd, XProj, YProj, ZProj, XX, YY, ZZ : Extended;

begin {TLTVT_Form.ConvertUserPhotoXYtoLonLat}
  Result := False;

  if UserPhotoType=Satellite then  // Satellite photos = sphere seen in finite perspective
    begin
      FeatureDirection := UserPhoto_ZPrime_Unit_Vector;

      ScratchVector := UserPhoto_XPrime_Unit_Vector;
      MultiplyVector(UserX,ScratchVector);
      VectorSum(FeatureDirection, ScratchVector, FeatureDirection);

      ScratchVector := UserPhoto_YPrime_Unit_Vector;
      MultiplyVector(UserY,ScratchVector);
      MultiplyVector(-1,ScratchVector);  // reverse direction to match screen system
      VectorSum(FeatureDirection, ScratchVector, FeatureDirection);

      NormalizeVector(FeatureDirection);  // unit vector from satellite in direction of object imaged

    // determine intercept (if any) of Feature Direction with lunar sphere of radius MoonRadius

      MinusDotProd := -DotProduct(SatelliteVector,FeatureDirection);  // this should be positive if camera is pointed towards Moon

      Discrim := Sqr(MinusDotProd) - (VectorModSqr(SatelliteVector) - Sqr(Radius_km));

      if Discrim<0 then Exit;   // error condition: no intercept of line and sphere

      Discrim := Sqrt(Discrim);

      Distance := MinusDotProd - Discrim;  // shortest solution of quadratic equation should be intercept with near side of Moon

      if Distance<0 then Distance := MinusDotProd + Discrim;  // error condition?: solution is to far side of Moon -- satellite is inside lunar radius?

      if Distance<0 then Exit;  // error condition: no way to get to lunar surface in camera direction.

      MultiplyVector(Distance,FeatureDirection);
      VectorSum(SatelliteVector,FeatureDirection,FeatureDirection);  // full vector from Moon's center to intercept point in selenographic system

      NormalizeVector(FeatureDirection);

      Lat_radians := ArcSin(FeatureDirection[Y]);
      Lon_radians := ArcTan2(FeatureDirection[X],FeatureDirection[Z]);

      Result := True;
    end
  else // Earthbased photo -- orthographic projection
    begin
      XProj := UserX;
      YProj := UserY;

      XYSqrd := Sqr(XProj) + Sqr(YProj);
      RadiusFactorSqrd := Sqr(Radius_km/MoonRadius);  // X-Y system is scaled to MoonRadius = 1
      if XYSqrd<RadiusFactorSqrd then
        begin
          ZProj := Sqrt(RadiusFactorSqrd - XYSqrd);  // this sets length to Radius_km/MoonRadius

          XX := XProj*UserPhoto_XPrime_Unit_Vector[x] + YProj*UserPhoto_YPrime_Unit_Vector[x] + ZProj*UserPhoto_ZPrime_Unit_Vector[x];
          YY := XProj*UserPhoto_XPrime_Unit_Vector[y] + YProj*UserPhoto_YPrime_Unit_Vector[y] + ZProj*UserPhoto_ZPrime_Unit_Vector[y];
          ZZ := XProj*UserPhoto_XPrime_Unit_Vector[z] + YProj*UserPhoto_YPrime_Unit_Vector[z] + ZProj*UserPhoto_ZPrime_Unit_Vector[z];

          Lat_radians := ArcSin(YY);
          Lon_radians := ArcTan2(XX,ZZ);
          Result := True;
        end;
    end;

end;  {TLTVT_Form.ConvertUserPhotoXYtoLonLat}

function TLTVT_Form.ConvertLonLatToUserPhotoXPixYPix(const Lon_radians, Lat_radians, Radius_km : extended; var UserPhotoXPix, UserPhotoYPix : Integer) : Boolean;
var
  FeatureX, FeatureY, TempXPix, TempYPix : Extended;
begin
  if ConvertLonLatToUserPhotoXY(Lon_radians, Lat_radians, Radius_km, FeatureX, FeatureY ) then
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

{
procedure TLTVT_Form.ConvertUserPhotoXPixYPixToXY(const UserPhotoXPix, UserPhotoYPix : integer; var UserX, UserY : extended);
var
  TempX, TempY : Extended;
begin  //this routine is unproven
  TempX := (UserPhotoXPix - UserPhoto_StartXPix)/UserPhoto_PixelsPerXYUnit;
  TempY := (UserPhotoYPix - UserPhoto_StartYPix)/UserPhoto_PixelsPerXYUnit;
  UserX := UserPhoto_StartX + TempX*UserPhotoCosTheta + TempY*UserPhotoSinTheta;
  UserY := UserPhoto_StartY - TempX*UserPhotoSinTheta + TempY*UserPhotoCosTheta;
end;
}

function TLTVT_Form.CorrectedDateTimeToStr(const DateTimeToPrint : TDateTime) : String;
  begin
    if (DateTimeToPrint>=0) or (Frac(DateTimeToPrint)=0) then
      Result := DateTimeToStr(DateTimeToPrint)
    else
      Result := DateTimeToStr(Int(DateTimeToPrint) - 2 - Frac(DateTimeToPrint));
  end;

function TLTVT_Form.YesNoToBoolean(const OptionString : string): boolean;
  begin
    Result := UpperCaseString(Substring(OptionString,1,1))='Y';
  end;

procedure TLTVT_Form.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;

begin {TLTVT_Form.FormCreate}
  CraterListCurrent := False;
  GoToListCurrent := False;
  IdentifySatellites := False;

  DefaultCursor := Screen.Cursor;

  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'LTVT_USERGUIDE.chm';
//  Application.OnHelp := HH;

  BasePath := ExtractFilePath(Application.ExeName);

  ProposedFilename := 'LTVT_Image.bmp';
  ObservatoryComboBoxDefaultText := 'click ADD to assign a name to the current location';
  ObservatoryNoFileText := 'click ADD to start a list on disk';

  IniFileName := BasePath+'LTVT.ini'; //Note: if full path is not specified, file is assumed in C:\WINDOWS
  IniFile := TIniFile.Create(IniFileName);

  if YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Draw_Dots_on_Startup','no')) then
    DrawingMode := DotMode
  else
    DrawingMode := TextureMode;

  CraterThreshold_LabeledNumericEdit.NumericEdit.Text := IniFile.ReadString('LTVT Defaults','Feature_size_threshold','-1');
  IniFile.Free;

  StatusLine_Label.Caption := '';
  LoRes_Texture_Loaded := false;
  HiRes_Texture_Loaded := false;
  Clementine_Texture_Loaded := false;

//  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:nn:ss';
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  try
    Date_DateTimePicker.Date := EncodeDateDay(CurrentYear,1);
  except
  end;

  Application.ShowHint := True;  // unable to get Menus to show hints!!

  HideMouseMoveLabels;   // items shown only if mouse is on lunar disk

  DEM_data := TKaguyaData.Create;

  RefPtLon := 0;
  RefPtLat := 0;

  MoonRadius := 1737.4;  {JPL lunar radius [km] = consistent with IAU mapping diameter?}

  SunRad := 1920*OneArcSec/2;  // this is overridden by Estimate Geometry if a JPL file is available

  with Image1.Canvas do
    begin
      Brush.Color := clWhite;  {used for fill}
      Brush.Style := bsClear;
      Pen.Color := clBlack;    {used for lines}
      Pen.Style := psSolid;
      CopyMode := cmSrcCopy;
    end;

  LastImageWidth := 641;
  LastImageHeight := 641;
  FormResize(Self);
  SetRange(0,1,0,1);

  FileSettingsChanged := False;

  RestoreLocationOptions;
  RestoreFileOptions;
  RestoreDefaultLabelOptions;
  RestoreCartographicOptions;
  RestoreDemOptions;
  RestoreMouseOptions;

  if not LinuxCompatibilityMode then Date_DateTimePicker.MinDate := EncodeDateDay(1601,1);

  if StartWithCurrentUT then
    begin
      Now_Button.Click;
    end
  else
    begin
      SetManualGeometryLabels;
      RefreshImage;
    end;

  ShowDetails := False;
  PopupMemo := TPopupMemo_Form.Create(Application);
  PopupMemo.Caption := 'LTVT Calculation Details';

  ImageCenterX := 0;
  ImageCenterY := 0;

  UserPhoto_RadioButton.Hide;
  UserPhoto := TBitmap.Create;

  LTO_RadioButton.Hide;
  LTO_Image := TBitmap.Create;

  ShadowProfileFilename := BasePath+'ShadowProfile.txt';
  SurfaceData_NoDataValue := -99.99;

end;  {TLTVT_Form.FormCreate}

procedure TLTVT_Form.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Answer : Word;
begin
  if (PhotosessionSearch_Form.PhotoSessionsFilename<>'') and (FullFilename(PhotosessionSearch_Form.PhotoSessionsFilename)<>FullFilename(NormalPhotoSessionsFilename)) then
    begin
      NormalPhotoSessionsFilename := PhotosessionSearch_Form.PhotoSessionsFilename;
      FileSettingsChanged := True;
    end;

  if FileSettingsChanged then
    begin
      Answer := MessageDlg('Some external file locations/names may have been changed from their defaults.'+CR
        +'Do you want to save the current ones as the new defaults?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
      case Answer of
        mrCancel :
          begin
            Action := caNone;  // don't close Main Form after all!
            Exit;  // leave this routine
          end;
        mrYes : SaveFileOptions;
        end;
    end;

  LoRes_TextureMap.Free;
  HiRes_TextureMap.Free;
  Clementine_TextureMap.Free;
  UserPhoto.Free;
  LTO_Image.Free;

  PopupMemo.Free;

  DEM_data.Free;

end;

function TLTVT_Form.LongitudeString(const LongitudeDegrees : extended; const DecimalPoints : integer): string;
{returns value in range 180.nnn W to 180.nnn E}
var
  DisplayLongitude : extended;
  LongitudeTag, FormatString : string;
begin
  DisplayLongitude := PosNegDegrees(LongitudeDegrees);  // put value in range -180 to +180
  FormatString := '%0.'+IntToStr(DecimalPoints)+'f';
  if DisplayLongitude>=0 then
    LongitudeTag := 'E'
  else
    LongitudeTag := 'W';
  Result := Format(FormatString+' %0s',[Abs(DisplayLongitude),LongitudeTag]);
end;

function TLTVT_Form.LatitudeString(const LatitudeDegrees : extended; const DecimalPoints : integer): string;
{returns value in range 180.nnn W to 180.nnn E}
var
  DisplayLatitude : extended;
  LatitudeTag, FormatString : string;
begin
  DisplayLatitude := PosNegDegrees(LatitudeDegrees);  // put value in range -180 to +180
  FormatString := '%0.'+IntToStr(DecimalPoints)+'f';
  if DisplayLatitude>=0 then
    LatitudeTag := 'N'
  else
    LatitudeTag := 'S';
  Result := Format(FormatString+' %0s',[Abs(DisplayLatitude),LatitudeTag]);
end;

function TLTVT_Form.ConvertXYtoVector(const XProj, YProj, MaxRadius : extended;  Var PointUnitVector : TVector) : Boolean;
{converts from orthographic +/-1.0 system to (X,Y,Z) in selenographic system with radius = 1}
var
  XYSqrd, ZProj, NormFactor, XX, YY, ZZ : extended;
begin
  XYSqrd := Sqr(XProj) + Sqr(YProj);
  if XYSqrd<1 then {point is inside circle, want to draw}
    begin
      ZProj := Sqrt(1 - XYSqrd);  // this sets length to 1

      XX := XProj*XPrime_UnitVector[x] + YProj*YPrime_UnitVector[x] + ZProj*ZPrime_UnitVector[x];
      YY := XProj*XPrime_UnitVector[y] + YProj*YPrime_UnitVector[y] + ZProj*ZPrime_UnitVector[y];
      ZZ := XProj*XPrime_UnitVector[z] + YProj*YPrime_UnitVector[z] + ZProj*ZPrime_UnitVector[z];

      AssignToVector(PointUnitVector,XX,YY,ZZ);

      Result := True;
    end
  else if XYSqrd<Sqr(MaxRadius) then {point is outside circle, regard as ZProj =0}
    begin
      NormFactor := 1/Sqrt(XYSqrd);  // <1
      XX := NormFactor*(XProj*XPrime_UnitVector[x] + YProj*YPrime_UnitVector[x]);
      YY := NormFactor*(XProj*XPrime_UnitVector[y] + YProj*YPrime_UnitVector[y]);
      ZZ := NormFactor*(XProj*XPrime_UnitVector[z] + YProj*YPrime_UnitVector[z]);

      AssignToVector(PointUnitVector,XX,YY,ZZ);

      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;

function TLTVT_Form.ConvertXYtoLonLat(const XProj, YProj : extended;  Var Point_Lon, Point_Lat : extended) : Boolean;
var
  Point_Vector : TVector;
begin
  if ConvertXYtoVector(XProj, YProj, 1, Point_Vector) then
    begin
      if Point_Vector[Y]>1 then
        Point_Vector[Y] := 1
      else if Point_Vector[Y]<-1 then
        Point_Vector[Y] := -1;
      Point_Lat := ArcSin(Point_Vector[Y]);

      Point_Lon := ArcTan2(Point_Vector[X],Point_Vector[Z]);
      Result := True;
    end
  else
    Result := False;
end;

function TLTVT_Form.CalculateGeometry : Boolean;
var
  LeftRight_Factor, UpDown_Factor, ErrorCode : Integer;
  Lat1, Lon1, Lat2, Lon2, Colong, RotationAngle,
  CosTheta,  {angle from projected center to sub-solar point}
  CenterX, CenterY, ZoomFactor, AspectRatio, TempVal : Extended;
  InversionTag : String;

//  PolarAngle : Extended;

  ZenithVector, CelestialPoleVector : TVector;

begin {TLTVT_Form.CalculateGeometry}
  Result := False;

  ImageManual := ManualMode;  // current geometry was computed using manual settings

  ImageGamma := Gamma_LabeledNumericEdit.NumericEdit.ExtendedValue;
  if ImageGamma<>0 then
    ImageGamma := 1/ImageGamma
  else
    ImageGamma := 1000;

  ImageIncludesCastShadows := DemIncludesCastShadows;

  Colong := 90 - SubSol_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue;
  while Colong>360 do Colong := Colong - 360;
  while Colong<0   do Colong := Colong + 360;
  Colongitude_Label.Caption := Format('%0.3f',[Colong]);
  MT_Label.Caption := Format('MT = %0s',[LongitudeString(-Colong,3)]);
  ET_Label.Caption := Format('ET = %0s',[LongitudeString(180-Colong,3)]);

  Lon1 := DegToRad(SubObs_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
  Lat1 := DegToRad(SubObs_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);
  ImageSubObsLon := Lon1;
  ImageSubObsLat := Lat1;

// update with current values from form, since these may have been changed by user
  SubSolarPoint.Longitude := DegToRad(SubSol_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
  SubSolarPoint.Latitude := DegToRad(SubSol_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);
  SubSolarPoint.Radius := 1;

  SinSSLat := Sin(SubSolarPoint.Latitude);
  CosSSLat := Cos(SubSolarPoint.Latitude);

  Lon2 := SubSolarPoint.Longitude;
  Lat2 := SubSolarPoint.Latitude;
  ImageSubSolLon := Lon2;
  ImageSubSolLat := Lat2;

  CosTheta := Sin(Lat1)*Sin(Lat2) + Cos(Lat1)*Cos(Lat2)*Cos(Lon2 - Lon1);
  PercentIlluminated_Label.Caption := Format('%% Illuminated = %0.3f',[50*(1 + CosTheta)]);

  PolarToVector(Lon1, Lat1, 1, SubObsvrVector); {sub-observer point}
  PolarToVector(Lon2, Lat2, 1, SubSolarVector); {sub-solar point}

  ZPrime_UnitVector := SubObsvrVector;
  NormalizeVector(ZPrime_UnitVector);

  InversionTag := '';
  if InvertLR then InversionTag := ' (Inverted L-R';
  if InvertUD then
    begin
      if InversionTag='' then
        InversionTag := ' (Inverted U-D'
      else
        InversionTag := InversionTag+' and U-D';
    end;
  if InversionTag<>'' then InversionTag := InversionTag+')';

  case OrientationMode of
    LineOfCusps :
      begin
        MoonDisplay_GroupBox.Caption := 'Moon Display:  Line of Cusps View'+InversionTag;

        CrossProduct(ZPrime_UnitVector,SubSolarVector,YPrime_UnitVector);

        {check if SubObsvrVector and SubSolarVector are parallel; if so, terminator is at limb so rotations relative
          to it are undefined;  arbitrarily use old x-axis to define new y'-axis}
        if VectorMagnitude(YPrime_UnitVector)=0 then
          begin
            CrossProduct(ZPrime_UnitVector,Ux,YPrime_UnitVector);
            if VectorMagnitude(YPrime_UnitVector)=0 then YPrime_UnitVector := Uy; //ZPrime_UnitVector parallel to Ux (looking from east or west)
          end;

        NormalizeVector(YPrime_UnitVector);

        if YPrime_UnitVector[y]<0 then MultiplyVector(-1,YPrime_UnitVector);

        CrossProduct(YPrime_UnitVector,ZPrime_UnitVector,XPrime_UnitVector);
        NormalizeVector(XPrime_UnitVector);
      end;

    Equatorial :
      begin
        if ManualMode then
          begin
            if MessageDlg('A map in Equatorial Orientation has been requested --'+CR+
              'the Earth north polar direction on which it is based may not be current',mtWarning,mbOKCancel,0)=mrCancel then
              Exit
            else
              begin
                with SelenographicCoordinateSystem do if VectorModSqr(UnitZ)=0 then
                  begin
                    UnitX := Ux;
                    UnitY := Uy;
                    UnitZ := Uz;
                  end;
                if VectorModSqr(EarthAxisVector)=0 then EarthAxisVector := Uz;
              end;
          end;

        MoonDisplay_GroupBox.Caption := 'Moon Display:  Equatorial View'+InversionTag;
        with SelenographicCoordinates(EarthAxisVector) do PolarToVector(Longitude,Latitude,1,CelestialPoleVector);
//        ShowMessage('Moon pole at : '+VectorString(SelenographicCoordinateSystem.UnitZ,3)+'  Earth pole in seleno system : '+VectorString(CelestialPoleVector,3)+'  ZPrime : '+VectorString(ZPrime_UnitVector,3));
        CrossProduct(CelestialPoleVector,ZPrime_UnitVector,XPrime_UnitVector);
        if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to zenith vector
        NormalizeVector(XPrime_UnitVector);
        CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);
      end;

    AltAz :
      begin
        if ManualMode then
          begin
            if MessageDlg('A map in Alt-Az Orientation has been requested --'+CR+
              'the observer zenith direction on which it is based may not be current',mtWarning,mbOKCancel,0)=mrCancel then
              Exit
            else
              begin
                with SelenographicCoordinateSystem do if VectorModSqr(UnitZ)=0 then
                  begin
                    UnitX := Ux;
                    UnitY := Uy;
                    UnitZ := Uz;
                  end;
                if VectorModSqr(ObserverZenithVector)=0 then ObserverZenithVector := Uz;
              end;
          end;

        MoonDisplay_GroupBox.Caption := 'Moon Display:  Alt-Az View'+InversionTag;
        with SelenographicCoordinates(ObserverZenithVector) do PolarToVector(Longitude,Latitude,1,ZenithVector);
//        ShowMessage('Moon pole at : '+VectorString(SelenographicCoordinateSystem.UnitZ,3)+'  Zenith direction in seleno system : '+VectorString(ObserverVertical,3)+'  ZPrime : '+VectorString(ZPrime_UnitVector,3));
        CrossProduct(ZenithVector,ZPrime_UnitVector,XPrime_UnitVector);
        if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to zenith vector
        NormalizeVector(XPrime_UnitVector);
        CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);
      end;

    else {Cartographic}
      begin
        MoonDisplay_GroupBox.Caption := 'Moon Display:  Cartographic View'+InversionTag;
        CrossProduct(Uy,ZPrime_UnitVector,XPrime_UnitVector);
        if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to Uy (looking from over north or south pole)
        NormalizeVector(XPrime_UnitVector);
        CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);
      end;

    end; {case}

  ManualRotationDegrees := RotationAngle_LabeledNumericEdit.NumericEdit.ExtendedValue;

  RotationAngle := DegToRad(ManualRotationDegrees);

  RotateVector(XPrime_UnitVector,RotationAngle,ZPrime_UnitVector);
  RotateVector(YPrime_UnitVector,RotationAngle,ZPrime_UnitVector);

{
if PolarAngle_CheckBox.Checked then
  begin
    PolarAngle := DotProduct(Uy,XPrime_UnitVector);
    if PolarAngle<>0 then PolarAngle := PiByTwo - ArcTan2(DotProduct(Uy,YPrime_UnitVector), PolarAngle);
    ShowMessage(Format('Polar angle = %0.3f',[RadToDeg(PolarAngle)]));
  end;
}

  Solar_X_Projection := DotProduct(SubSolarVector,XPrime_UnitVector);

  CenterX := ImageCenterX;
  CenterY := ImageCenterY;

  ZoomFactor := Zoom_LabeledNumericEdit.NumericEdit.ExtendedValue;
  ImageZoom := ZoomFactor;

  if ZoomFactor=0 then
    ZoomFactor := 1
  else
    ZoomFactor := 1/ZoomFactor;

  if InvertLR then
    begin
      LeftRight_Factor := -1;
      CenterX := -CenterX;
    end
  else
    LeftRight_Factor := +1;

  if InvertUD then
    begin
      UpDown_Factor := -1;
      CenterY := -CenterY;
    end
  else
    UpDown_Factor := +1;

  if Image1.Height>=Image1.Width then
    begin
      AspectRatio := Image1.Height/Image1.Width;

      SetRange(LeftRight_Factor*(CenterX - ZoomFactor),LeftRight_Factor*(CenterX + ZoomFactor),
        UpDown_Factor*(CenterY - AspectRatio*ZoomFactor),UpDown_Factor*(CenterY + AspectRatio*ZoomFactor));
    end
  else
    begin
      AspectRatio := Image1.Width/Image1.Height;

      SetRange(LeftRight_Factor*(CenterX - AspectRatio*ZoomFactor),LeftRight_Factor*(CenterX + AspectRatio*ZoomFactor),
        UpDown_Factor*(CenterY - ZoomFactor),UpDown_Factor*(CenterY + ZoomFactor));
    end;

  ComputeDistanceAndBearing(RefPtLon,RefPtLat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,RefPtSunAngle,RefPtSunBearing);
  RefPtSunAngle := Pi/2 - RefPtSunAngle;

// Note: Except for computing PixelsPerRadian of texture files, lon/lat limits are relevant
//  only to the Texture 3 ("Clementine") but are placed here so compiler can see they have
//  been initialized.  These were formerly in DrawTexture

  Val(Tex3MinLon_DefaultText,MinLon,ErrorCode);
  Val(Tex3MaxLon_DefaultText,MaxLon,ErrorCode);
  Val(Tex3MinLat_DefaultText,MinLat,ErrorCode);
  Val(Tex3MaxLat_DefaultText,MaxLat,ErrorCode);

  if Clementine_RadioButton.Checked then
    begin
      Val(Tex3MinLonText,TempVal,ErrorCode);
      if ErrorCode=0 then
        MinLon := TempVal
      else
        ShowMessage('Unable to decode Texture 3 Minimum Longitude; substituting'+Tex3MinLon_DefaultText);

      Val(Tex3MaxLonText,TempVal,ErrorCode);
      if ErrorCode=0 then
        MaxLon := TempVal
      else
        ShowMessage('Unable to decode Texture 3 Maximum Longitude; substituting'+Tex3MaxLon_DefaultText);

      Val(Tex3MinLatText,TempVal,ErrorCode);
      if ErrorCode=0 then
        MinLat := TempVal
      else
        ShowMessage('Unable to decode Texture 3 Minimum Latitude; substituting'+Tex3MinLat_DefaultText);

      Val(Tex3MaxLatText,TempVal,ErrorCode);
      if ErrorCode=0 then
        MaxLat := TempVal
      else
        ShowMessage('Unable to decode Texture 3 Maximum Latitude; substituting'+Tex3MaxLat_DefaultText);

// Note danger of roundoff error in following, since most likely values are MinLon = -Pi and MaxLon = +Pi
      while MinLon<-180  do MinLon := MinLon + 360;
      while MinLon>180   do MinLon := MinLon - 360;
      while MaxLon<-180  do MaxLon := MaxLon + 360;
      while MaxLon>180   do MaxLon := MaxLon - 360;

      if MaxLon<=MinLon then MaxLon := MaxLon + 360;

    end;

  MinLon := DegToRad(MinLon);
  MaxLon := DegToRad(MaxLon);
  MinLat := DegToRad(MinLat);
  MaxLat := DegToRad(MaxLat);

  if MapPtr^<>nil then
    begin
      XPixPerRad := MapPtr^.Width/(MaxLon - MinLon);
      YPixPerRad := MapPtr^.Height/(MaxLat - MinLat);
    end;

//      ShowMessage(Format('Min lon: %0.3f  Max Lon: %0.3f  ppd: %0.3f',[RadToDeg(MinLon),RadToDeg(MaxLon),XPixPerRad*DegToRad(1)]));

  Result := True;
end;  {TLTVT_Form.CalculateGeometry}

procedure TLTVT_Form.ClearImage;
begin
  ProgressBar1.Hide;
  LabelDots_Button.Hide;
  DrawCircles_CheckBox.Show;
  MarkCenter_CheckBox.Show;
  ThreeD_CheckBox.Show;
  StatusLine_Label.Caption := '';
  DrawingMap_Label.Caption := '';
  SetLength(CraterInfo,0);
  CraterName_Label.Caption := '';
end;

procedure TLTVT_Form.DrawCircle(const CenterLonDeg, CenterLatDeg, RadiusDeg : Extended; CircleColor : TColor);
var
  RotationAxis, PerpDirection, CirclePoint : TVector;
  OldMode : TPenMode;
  AngleStep, TotalAngle, TwoPi, X, Y, Z : extended;
begin {TLTVT_Form.DrawCircle}
  PolarToVector(DegToRad(CenterLonDeg),DegToRad(CenterLatDeg),1,RotationAxis);
  CrossProduct(Ux,RotationAxis,PerpDirection);
  if VectorMagnitude(PerpDirection)=0 then CrossProduct(Uy,RotationAxis,PerpDirection);
  CirclePoint := RotationAxis;
  RotateVector(CirclePoint,DegToRad(RadiusDeg),PerpDirection); // moves CirclePoint from RotationAxis (center) to point on cone of circle
  with Image1 do
    begin
      OldMode := Canvas.Pen.Mode;
      Canvas.Pen.Color := CircleColor;
      TwoPi :=  2*Pi;
      AngleStep := DegToRad(1);
      TotalAngle := 0;
      X := DotProduct(CirclePoint,XPrime_UnitVector);
      Y := DotProduct(CirclePoint,YPrime_UnitVector);
      MoveToDataPoint(X,Y);
      while TotalAngle<TwoPi do
        begin
          RotateVector(CirclePoint,AngleStep,RotationAxis);
          X := DotProduct(CirclePoint,XPrime_UnitVector);
          Y := DotProduct(CirclePoint,YPrime_UnitVector);
          Z := DotProduct(CirclePoint,ZPrime_UnitVector);
          if Z>0 then
            Canvas.Pen.Mode := pmCopy
          else
            Canvas.Pen.Mode := pmNop;  // Terminator point is not visible, use invisible ink mode
          LineToDataPoint(X,Y);
          TotalAngle := TotalAngle + AngleStep;
        end;
      Canvas.Pen.Mode := OldMode;
    end;
end;   {TLTVT_Form.DrawCircle}

procedure TLTVT_Form.DrawCross(const CenterXPixel, CenterYPixel, CrossSize : Integer; const CrossColor : TColor);
{CrossSize determines extension of arms about central point. CrossSize=0 gives single pixel dot.
 Nothing is drawn if CrossSize<0.}
begin
  with Image1 do
    begin
      if (CrossSize>=0) then with Canvas do
        begin
          Pen.Color := CrossColor;
          MoveTo(CenterXPixel,CenterYPixel-CrossSize);
          LineTo(CenterXPixel,CenterYPixel+CrossSize+1);    // note: LineTo stops short of destination by 1 pixel
          MoveTo(CenterXPixel-CrossSize,CenterYPixel);
          LineTo(CenterXPixel+CrossSize+1,CenterYPixel);
        end;
    end;
end;

procedure TLTVT_Form.DrawGrid;
{this should be called only after a current CalculateGeometry}
var
  GridStepDeg, GridDeg, MaxLon, MinLon, MaxLat, MinLat : Extended;
  CornersGood : Boolean;

procedure TestCorner(const X, Y : Integer);
  var
    ProjectedX, ProjectedY, Lon, Lat : Extended;
  begin
    with Image1 do
      begin
        ProjectedX := XValue(X);
        ProjectedY := YValue(Y);
      end;

    if ConvertXYtoLonLat(ProjectedX,ProjectedY,Lon,Lat) then
      begin
        Lon := RadToDeg(Lon);
        Lat := RadToDeg(Lat);

        if Lon>MaxLon then MaxLon := Lon;
        if Lon<MinLon then MinLon := Lon;
        if Lat>MaxLat then MaxLat := Lat;
        if Lat<MinLat then MinLat := Lat;
      end
    else
      CornersGood := False;
  end;

begin {TLTVT_Form.DrawGrid}
  MaxLat := -999;
  MinLat := 999;
  MaxLon := -999;
  MinLon := 999;
  CornersGood := True;

  TestCorner(0,0);
  TestCorner(Image1.Width-1,0);
  TestCorner(0,Image1.Height-1);
  TestCorner(Image1.Width-1,Image1.Height-1);

  while MaxLon<0 do MaxLon := MaxLon + 360;
  while MinLon<0 do MinLon := MinLon + 360;

  GridStepDeg := GridSpacing_LabeledNumericEdit.NumericEdit.ExtendedValue;

  if GridStepDeg<>0 then
    begin
      GridDeg := 0;
      while GridDeg<90 do
        begin
//          if (not CornersGood) or ((GridDeg<MaxLat) and (GridDeg>MinLat)) then
            DrawCircle(0,90,90-GridDeg,LibrationCircleColor); // draw little circle at Lat = +GridDeg
//          if (not CornersGood) or ((-GridDeg<MaxLat) and (-GridDeg>MinLat)) then
            DrawCircle(0,90,90+GridDeg,LibrationCircleColor); // draw little circle at Lat = -GridDeg
          GridDeg := GridDeg + GridStepDeg;
        end;
      GridDeg := 0;
      while GridDeg<180 do
        begin
//          if (not CornersGood) or ((GridDeg<MaxLon) and (GridDeg>MinLon))  or (((180+GridDeg)<MaxLon) and ((180+GridDeg)>MinLon))then
            DrawCircle(90+GridDeg,0,90,LibrationCircleColor); // draw great circles at Lon = GridDeg and 180+GridDeg
          GridDeg := GridDeg + GridStepDeg;
        end;
    end;

end;  {TLTVT_Form.DrawGrid}

procedure TLTVT_Form.MarkCenter;
{this should be called only after a current CalculateGeometry}
begin {TLTVT_Form.MarkCenter}
  if MarkCenter_CheckBox.Checked then
    begin
//      ShowMessage('Marking center');
      MarkXY(ImageCenterX,ImageCenterY,ReferencePointColor);
    end;
end;  {TLTVT_Form.DrawTerminator}

procedure TLTVT_Form.DrawTerminator;
{this should be called only after a current CalculateGeometry}
begin {TLTVT_Form.DrawTerminator}
  if IncludeLibrationCircle then DrawCircle(0,0,90,LibrationCircleColor);

  if IncludeTerminatorLines then
    begin
      DrawCircle(RadToDeg(SubSolarPoint.Longitude),RadToDeg(SubSolarPoint.Latitude),RadToDeg(Pi/2-SunRad),clRed); // Evening terminator
      DrawCircle(RadToDeg(SubSolarPoint.Longitude),RadToDeg(SubSolarPoint.Latitude),RadToDeg(Pi/2+SunRad),clBlue); // Morning terminator
    end;

  DrawGrid;

  MarkCenter;

end;  {TLTVT_Form.DrawTerminator}

procedure TLTVT_Form.OverlayDots_ButtonClick(Sender: TObject);

  procedure DrawCraters;
    var
      MaxDiam,   // largest circle to plot
      Diam, MinKm : Extended;
      CurrentCrater : TCrater;
      CraterNum, DotRadius, DotRadiusSqrd, DiamErrorCode
        : Integer;

    procedure PlotCrater;
      var
        CraterVector : TVector;
        CraterColor : TColor;
        CraterCenterX, CraterCenterY, XOffset, YOffset, CraterIndex : Integer;

      begin {PlotCrater}
        with CurrentCrater do
          begin
            PolarToVector(Lon,Lat,1,CraterVector);
            if DotProduct(CraterVector,SubObsvrVector)>=0 then with Image1 do
              begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
                CraterCenterX := XPix(DotProduct(CraterVector,XPrime_UnitVector));
                CraterCenterY := YPix(DotProduct(CraterVector,YPrime_UnitVector));
                {plot if projection falls within viewable area}
                if (CraterCenterX>=0) and (CraterCenterX<Image1.Width)
                  and (CraterCenterY>=0) and (CraterCenterY<Image1.Height) then
                  begin  // Plot this crater
                    if DotSize>0 then // Draw Dot
                      begin
                        if (USGS_Code='AA') or (USGS_Code='SF') or (USGS_Code='CN')
                         or (USGS_Code='CN5') or (USGS_Code='GD') or (USGS_Code='CD') then
                          begin
                            if DiamErrorCode=0 then
                              begin
                                if Diam>=LargeCraterDiam then
                                  CraterColor := LargeCraterColor
                                else if Diam>=MediumCraterDiam then
                                  CraterColor := MediumCraterColor
                                else
                                  CraterColor := SmallCraterColor;
                              end
                            else // unable to decode diameter
                              CraterColor := NonCraterColor;
                          end
                        else
                          CraterColor := NonCraterColor;

                        with Canvas do
                          begin
                            for XOffset := -DotRadius to DotRadius do
                              for YOffset := -DotRadius to DotRadius do
                                if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                                  Pixels[CraterCenterX+XOffset, CraterCenterY+YOffset] := CraterColor;
                          end;
                      end;

                    if DrawCircles_CheckBox.Checked and (DiamErrorCode=0) and (Diam>0) and (Diam<MaxDiam)
                      and (USGS_Code<>'AT') and (USGS_Code<>'CN') and (USGS_Code<>'CN5') and (USGS_Code<>'CD') then
                      DrawCircle(RadToDeg(Lon),RadToDeg(Lat),RadToDeg(Diam/MoonRadius/2),CraterCircleColor);

                    if not PositionInCraterInfo(CraterCenterX, CraterCenterY) then
                      begin
                        CraterIndex := Length(CraterInfo);
                        SetLength(CraterInfo,CraterIndex+1);
                        CraterInfo[CraterIndex].CraterData := CurrentCrater;
                        CraterInfo[CraterIndex].Dot_X := CraterCenterX;
                        CraterInfo[CraterIndex].Dot_Y := CraterCenterY;
                      end;
                  end;
              end;


          end;
      end;  {PlotCrater}

    begin {DrawCraters}
      MaxDiam := MoonRadius*PiByTwo;

      RefreshCraterList;

      MinKm := CraterThreshold_LabeledNumericEdit.NumericEdit.ExtendedValue;

      DotRadius := Round(DotSize/2.0 + 0.5);
      if DotSize<=0 then
        DotRadiusSqrd := -1  // prevents drawing any dots
      else
        DotRadiusSqrd := Round(Sqr(DotSize/2.0));

      DrawingMap_Label.Caption := 'Plotting dots...';
      Application.ProcessMessages;
      ProgressBar1.Max := 9100;  // approx. num. lines in CraterFile
      ProgressBar1.Position := 0;
      ProgressBar1.Show;
      DrawCircles_CheckBox.Hide;
      MarkCenter_CheckBox.Hide;
      ThreeD_CheckBox.Hide;
      Application.ProcessMessages;

      for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
        begin
          if (CraterNum mod 1000)=0 then ProgressBar1.Position := CraterNum; // update periodically

          CurrentCrater := CraterList[CraterNum-1];

          val(NumericData,Diam,DiamErrorCode);
          if MinKm=0 then
            begin  // plot all features
              if IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[') then PlotCrater;
            end
          else if MinKm=-1 then
            begin // plot flagged features
              if UserFlag<>'' then PlotCrater;
            end
          else
            begin // plot all features above threshold
              if (DiamErrorCode=0) and (Diam>=MinKm) and
                (IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[')) then PlotCrater;
            end;

        end;

      ProgressBar1.Hide;
      DrawCircles_CheckBox.Show;
      MarkCenter_CheckBox.Show;
      ThreeD_CheckBox.Show;
      DrawingMap_Label.Caption := '';

    end;  {DrawCraters}

begin {TLTVT_Form.Overlay_ButtonClick}
//  CalculateGeometry;  // do NOT do this -- overlay with geometry of last image drawn
//  SetLength(CraterInfo,0); // do NOT do this -- there may be previous points plotted -- duplicates won't hurt

  Screen.Cursor := crHourGlass;
  LabelDots_Button.Hide;
  DrawCraters;
  if Length(CraterInfo)>0 then LabelDots_Button.Show;
  Screen.Cursor := DefaultCursor;
end;  {TLTVT_Form.Overlay_ButtonClick}

procedure TLTVT_Form.DrawDEM_ButtonClick(Sender: TObject);
var
  i, j, RawTexture3XPixel, RawTexture3YPixel : integer;
  BackgroundPattern : TBitMap;
  BkgRow  :  pRGBArray;
  SkyPixel, BlackPixel, ComputedShadowPixel, NoDataPixel, Texture3Pixel : TRGBTriple;
  PointVector, SurfaceNormal,     // unit vectors
  RotationAxis, TestVector : TVector;
  GunCount : Integer;
  StartTime, ElapsedTime : TDateTime;
  XProj, YProj,
  MaxProjection, AngleStep, DotProd,
  MaxR, ProjectionSqrd,
  Theta1, Theta2, RotationAngle, MaxRotationAngle : Extended;
  PointCoords, TestCoords : TPolarCoordinates;
  Image3D, ShadowFound : Boolean;

function ComputeSurfaceNormal : Boolean;
// determine surface normal : called with PointVector indicating point at which surface normal is desired
  var
    Sample1Vector, Sample2Vector, LonVector, LatVector, RotationAxis2 : TVector;
    Sample1Coords, Sample2Coords : TPolarCoordinates;
    LonStep, CosineLatitude, VectorLength : Extended;
  begin
    Result := False;

    if RigorousDemNormals then
      begin

        if DotProduct(PointVector,XPrime_UnitVector)>DotProduct(PointVector,ZPrime_UnitVector) then
          CrossProduct(PointVector,ZPrime_UnitVector,RotationAxis)
        else
          CrossProduct(PointVector,XPrime_UnitVector,RotationAxis);

        TestVector := PointVector;
        RotateVector(TestVector,AngleStep,RotationAxis);
        Sample1Coords := VectorToPolar(TestVector);
        with Sample1Coords do
          begin
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample1Vector);
          end;

        TestVector := PointVector;
        RotateVector(TestVector,-AngleStep,RotationAxis);
        Sample2Coords := VectorToPolar(TestVector);
        with Sample2Coords do
          begin
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample2Vector);
          end;

        VectorDifference(Sample1Vector,Sample2Vector,LatVector);

        CrossProduct(RotationAxis,PointVector,RotationAxis2);

        TestVector := PointVector;
        RotateVector(TestVector,AngleStep,RotationAxis2);
        Sample1Coords := VectorToPolar(TestVector);
        with Sample1Coords do
          begin
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample1Vector);
          end;

        TestVector := PointVector;
        RotateVector(TestVector,-AngleStep,RotationAxis2);
        Sample2Coords := VectorToPolar(TestVector);
        with Sample2Coords do
          begin
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample2Vector);
          end;

        VectorDifference(Sample1Vector,Sample2Vector,LonVector);

      end
    else
      begin  // less rigorous method dithers longitude and latitude -- may not work well near poles
        CosineLatitude := Cos(PointCoords.Latitude);
        if CosineLatitude>0 then
          LonStep := AngleStep/CosineLatitude
        else
          LonStep := Pi;

        if LonStep>Pi then LonStep := Pi;

        Sample1Coords := PointCoords;
        with Sample1Coords do
          begin
            Longitude := PointCoords.Longitude + LonStep;
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample1Vector);
          end;

        Sample2Coords := PointCoords;
        with Sample2Coords do
          begin
            Longitude := PointCoords.Longitude - LonStep;
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample2Vector);
          end;

        VectorDifference(Sample1Vector,Sample2Vector,LonVector);

        Sample1Coords := PointCoords;
        with Sample1Coords do
          begin
            Latitude := PointCoords.Latitude + AngleStep;
            if Abs(Latitude)>PiByTwo then
              begin // wrap latitudes over pole
                Longitude := Pi + Longitude;
                Latitude  := Pi - Latitude;
              end;
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample1Vector);
          end;

        Sample2Coords := PointCoords;
        with Sample2Coords do
          begin
            Latitude := PointCoords.Latitude - AngleStep;
            if Abs(Latitude)>PiByTwo then
              begin // wrap latitudes over pole
                Longitude := Pi + Longitude;
                Latitude  := Pi - Latitude;
              end;
            if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then Exit;
            PolarToVector(Longitude,Latitude,Radius,Sample2Vector);
          end;

        VectorDifference(Sample1Vector,Sample2Vector,LatVector);
      end;

    CrossProduct(LonVector,LatVector,SurfaceNormal);
    VectorLength := VectorMagnitude(SurfaceNormal);
    if VectorLength=0 then
      Exit
    else
      MultiplyVector(1/VectorLength,SurfaceNormal);  // normalize

//    if DotProduct(SurfaceNormal,PointVector)<0 then MultiplyVector(-1,SurfaceNormal);

    Result := True;
  end;

function SurfaceFound : Boolean;
// entered with PointVector indicating nominal surface point on disk or limb
  var
    Projection : Extended;
  begin
    Result := False;
    ProjectionSqrd := Sqr(MoonRadius)*(Sqr(XProj) + Sqr(YProj));
    Projection := Sqrt(ProjectionSqrd);
    if Projection>MaxR then Exit;  // surface not found, but this test should not be necessary -- tested prior to call

    CrossProduct(SubObsvrVector,PointVector,RotationAxis);

    Theta1 := ArcSin(Projection/MaxR);
    MaxRotationAngle := (Pi - Theta1);
    RotationAngle := Theta1;
    while (RotationAngle<MaxRotationAngle) and (not Result) do
      begin
        RotationAngle := RotationAngle + AngleStep;
        PointVector := SubObsvrVector;
        RotateVector(PointVector,RotationAngle,RotationAxis);
        PointCoords := VectorToPolar(PointVector);
        DotProd := DotProduct(SubObsvrVector,PointVector);
        with PointCoords do if DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then
          begin
//            DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius);
//            ShowMessage(Format('Rot: %0.3f Lon: %0.3f Lat: %0.3f Nom Proj: %0.3f Proj: %0.3f',[RadToDeg(RotationAngle),RadToDeg(Longitude),RadToDeg(Latitude), Sqrt(ProjectionSqrd), Sqrt(Sqr(Radius)*(1 - Sqr(DotProd)))]));
            Result := (Sqr(Radius)*(1 - Sqr(DotProd)))>=ProjectionSqrd;
          end;
      end;
  end;

procedure EvaluateBrigthness;
// entered with PointCoords specifying lon, lat and radius of point to evaluate
  var
    SinArg : Extended;
  begin
   if not ComputeSurfaceNormal then
     BkgRow[i] := NoDataPixel
   else
     begin

       DotProd := DotProduct(SubSolarVector,SurfaceNormal);
       if DotProd<=0 then
         BkgRow[i] := BlackPixel
       else
         begin
           if MultiplyDemByTexture3 then
             begin
               LookUpPixelData(PointCoords.Longitude,PointCoords.Latitude,RawTexture3XPixel,RawTexture3YPixel,Texture3Pixel);
               with BkgRow[i] do
                 begin
                   rgbtRed := Round(Texture3Pixel.rgbtRed*DotProd);
                   rgbtGreen := Round(Texture3Pixel.rgbtGreen*DotProd);
                   rgbtBlue := Round(Texture3Pixel.rgbtBlue*DotProd);
                 end;
               GammaCorrectPixelValue(BkgRow[i],ImageGamma);
             end
           else
             begin
               DotProd := Sqrt(DotProd);  // this is the default Gamma = 2 to correct linear intensities for display
               if ImageGamma<>1 then DotProd := Power(DotProd,ImageGamma);
               GunCount := Round(256*DotProd - 0.5);
               if GunCount>255 then GunCount := 255;
//                   if GunCount<0 then GunCount := 0;
               with BkgRow[i] do
                 begin
                   rgbtRed := GunCount;
                   rgbtGreen := GunCount;
                   rgbtBlue := GunCount;
                 end;
             end;
           if ImageIncludesCastShadows then
             begin
               ShadowFound := False;
               CrossProduct(PointVector,SubSolarVector,RotationAxis);
//                       ShowMessage(VectorString(RotationAxis,3));
               DotProd := DotProduct(SubSolarVector,PointVector);
               Theta1 := ArcCos(DotProd);
               with PointCoords do
                 begin
                   DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius);
                   ProjectionSqrd := Sqr(Radius)*(1 - Sqr(DotProd));
                   SinArg := Sin(Theta1)*Radius/MaxR;
                   if SinArg>1 then
                     Theta2 := PiByTwo
                   else if SinArg<-1 then
                     Theta2 := -PiByTwo
                   else
                     Theta2 := ArcSin(SinArg);  // without argument check, was ocassionaly giving floating point overflow
                 end;
               MaxRotationAngle := (Theta1 - Theta2);
               RotationAngle := 0;
               while (RotationAngle<MaxRotationAngle) and (not ShadowFound) do
                 begin
                   RotationAngle := RotationAngle + AngleStep;
                   TestVector := PointVector;
                   RotateVector(TestVector,RotationAngle,RotationAxis);
                   TestCoords := VectorToPolar(TestVector);
                   DotProd := DotProduct(SubSolarVector,TestVector);
                   with TestCoords do if DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then
                     begin
                       ShadowFound := (Sqr(Radius)*(1 - Sqr(DotProd)))>ProjectionSqrd;
//                               ShowMessage(Format('Rot: %0.3f Lon: %0.3f Lat: %0.3f Elev: %0.3f',[RadToDeg(RotationAngle),RadToDeg(Longitude),RadToDeg(Latitude),Radius]));
                     end;
                 end;
               if ShadowFound then BkgRow[i] := ComputedShadowPixel;
             end;

         end;
       end;
  end;

begin  {TLTVT_Form.DrawDEM_ButtonClick}
  if not CalculateGeometry then Exit;

  if MultiplyDemByTexture3 then
    begin
      if MapPtr^=nil then
        begin
          ShowMessage('Texture map to multiply by has not been loaded');
          Exit;
        end;
//      Clementine_RadioButton.Checked := True;
    end;

  with DEM_data do
    if not FileOpen then
      begin
        DisplayTimings := DisplayDemComputationTimes;
        StatusLine_Label.Caption := 'Reading DEM';
        Application.ProcessMessages;
        if not SelectFile(DEM_Filename) then
          begin
            StatusLine_Label.Caption := '';
            if (MessageDlg('LTVT was unable to open the Digital Elevation Model (DEM) file'+CR
                +'   Do you want help with this topic?', mtWarning,[mbYes,mbNo],0)=mrYes) then
              begin
                HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/DemOptionsForm.htm'),HH_DISPLAY_TOPIC, 0);
              end;
            Exit;
          end;
        StatusLine_Label.Caption := '';
      end;

  StartTime := Now;

  with DEM_data do
    begin
      AngleStep := DemGridStepMultiplier*DegToRad(Abs(LatStep));
      TextureFilename := InputFilename;
      MaxR := RefHeight + MaxHtData;
    end;

  Image3D := ThreeD_CheckBox.Checked;

  if Image3D then
    begin
      DrawingMode := DEM_3D;
      MaxProjection := MaxR/MoonRadius;
      SetLength(SurfaceData,Image1.Width,Image1.Height);  // in mouse readout, first coord (X) = horizontal
    end
  else
    begin
      DrawingMode := DEM_2D;
      MaxProjection := 1;
      SetLength(SurfaceData,0,0);
    end;

  ClearImage;

//--- draw background pattern of light and shadow ---

  SkyPixel := ColorToRGBTriple(SkyColor);
  NoDataPixel := ColorToRGBTriple(NoDataColor);
  BlackPixel := ColorToRGBTriple(clBlack);
  ComputedShadowPixel := ColorToRGBTriple(DemCastShadowColor);

  BackgroundPattern := TBitmap.Create;
  BackgroundPattern.PixelFormat := pf24bit;
  BackgroundPattern.Height := Image1.Height;
  BackgroundPattern.Width := Image1.Width;

  Screen.Cursor := crHourGlass;
  DrawingMap_Label.Caption := 'Computing DEM simulation ...';
  ProgressBar1.Max := Image1.Height-1;
  ProgressBar1.Step := 1;
  ProgressBar1.Show;
  DrawCircles_CheckBox.Hide;
  MarkCenter_CheckBox.Hide;
  ThreeD_CheckBox.Hide;
  Application.ProcessMessages;

  AbortDrawing := False;
  Abort_Button.Show;

  j := 0;
  while (j<BackgroundPattern.Height) and (not AbortDrawing) do
    begin
      ProgressBar1.StepIt;
      BkgRow := BackgroundPattern.ScanLine[j];
      for i := 0 to (BackgroundPattern.Width - 1) do  with Image1 do
        begin
           XProj := XValue(i);
           YProj := YValue(j);
           if Image3D then
             begin
               if ConvertXYtoVector(XProj,YProj,MaxProjection,PointVector) then
                 begin
                   PointCoords := VectorToPolar(PointVector);
                   with PointCoords do if not DEM_data.ReadHeight(RadToDeg(Longitude),RadToDeg(Latitude),Radius) then
                     begin
                       BkgRow[i] := NoDataPixel;  // reject points where DEM has no data at nominal point:
                       with SurfaceData[i,j] do
                         begin
                           Lat_rad := 0;
                           Lon_rad := 0;
                           HeightDev_km := SurfaceData_NoDataValue;
                         end;
                     end
                   else if SurfaceFound then
                     begin
                       EvaluateBrigthness;
                       with SurfaceData[i,j] do
                         begin
                           Lat_rad := Latitude;
                           Lon_rad := Longitude;
                           HeightDev_km := Radius - MoonRadius;
                         end;
                     end
                   else
                     begin
                       BkgRow[i] := SkyPixel;
                       with SurfaceData[i,j] do
                         begin
                           Lat_rad := 0;
                           Lon_rad := 0;
                           HeightDev_km := SurfaceData_NoDataValue;
                         end;
                     end;
                 end
               else
                 begin
                   BkgRow[i] := SkyPixel;
                   with SurfaceData[i,j] do
                     begin
                       Lat_rad := 0;
                       Lon_rad := 0;
                       HeightDev_km := SurfaceData_NoDataValue;
                     end;
                 end;
             end
           else
             begin
               if ConvertXYtoVector(XProj,YProj,MaxProjection,PointVector) then
                 begin
                   PointCoords := VectorToPolar(PointVector);
                   EvaluateBrigthness
                 end
               else
                 BkgRow[i] := SkyPixel;
             end;
        end;
      Inc(j);
      Application.ProcessMessages;
    end;

  Abort_Button.Hide;
  Abort_Button.Repaint;
  Application.ProcessMessages;

  Image1.Canvas.Draw(0,0,BackgroundPattern);

  BackgroundPattern.Free;

  if DrawTerminatorOnDEM then
    DrawTerminator
  else
    begin
      DrawGrid;
      MarkCenter;
    end;

  Screen.Cursor := DefaultCursor;
  ProgressBar1.Hide;
  DrawCircles_CheckBox.Show;
  MarkCenter_CheckBox.Show;
  ThreeD_CheckBox.Show;
  DrawingMap_Label.Caption := '';

  if DisplayDemComputationTimes then
    begin
      ElapsedTime := (Now - StartTime)*OneDay/OneSecond;
      ShowMessage(Format('Simulation drawn in %0.3f sec',[ElapsedTime]));
    end;

end;    {TLTVT_Form.DrawDEM_ButtonClick}

procedure TLTVT_Form.DrawDots_ButtonClick(Sender: TObject);
var
  i, j : integer;
  BackgroundPattern : TBitMap;
  BkgRow  :  pRGBArray;
  SkyPixel, SunlightPixel, ShadowPixel : TRGBTriple;
  PointVector : TVector;
begin
  if not CalculateGeometry then Exit;

  TextureFilename := 'none (Dots Mode)';

  Screen.Cursor := crHourGlass;
  DrawingMode := DotMode;
  ClearImage;

//--- draw background pattern of light and shadow ---

  SkyPixel := ColorToRGBTriple(SkyColor);

  SunlightPixel := ColorToRGBTriple(DotModeSunlitColor);
  ShadowPixel := ColorToRGBTriple(DotModeShadowedColor);

  BackgroundPattern := TBitmap.Create;
  BackgroundPattern.PixelFormat := pf24bit;
  BackgroundPattern.Height := Image1.Height;
  BackgroundPattern.Width := Image1.Width;

  for j := 0 to (BackgroundPattern.Height - 1) do
    begin
      BkgRow := BackgroundPattern.ScanLine[j];
      for i := 0 to (BackgroundPattern.Width - 1) do  with Image1 do
        begin
           if not ConvertXYtoVector(XValue(i),YValue(j),1,PointVector) then
             BkgRow[i] := SkyPixel
           else if DotProduct(SubSolarVector,PointVector)>=0 then
             BkgRow[i] := SunlightPixel
           else
             BkgRow[i] := ShadowPixel;
        end;
    end;

  Image1.Canvas.Draw(0,0,BackgroundPattern);
//  LastImageWidth := Image1.Width;
//  LastImageHeight := Image1.Height;

  BackgroundPattern.Free;

//--- background pattern drawn ---

  with Image1 do with Canvas do
    begin
//--- draw limb ---
      Pen.Color := clBlack;
//      Arc(XPix(-1),YPix(+1),XPix(+1),YPix(-1),XPix(-1),YPix(+1),XPix(-1),YPix(+1));
    end;

  DrawTerminator;

  OverlayDots_ButtonClick(Sender);
  Screen.Cursor := DefaultCursor;
end;

function TLTVT_Form.LookUpPixelData(const Lon, Lat : Extended; var RawXPix, RawYPix : Integer; var PixelData : TPixelValue) : Boolean;
var
  RawRow  :  pRGBArray;
begin
  Result := False;

  if UserPhoto_RadioButton.Checked then
    begin
      if ConvertLonLatToUserPhotoXPixYPix(Lon,Lat,MoonRadius,RawXPix,RawYPix)
        and (RawXPix>=0) and (RawXPix<MapPtr^.Width) and (RawYPix>=0) and (RawYPix<MapPtr^.Height) then
          Result := True;
    end
  else if LTO_RadioButton.Checked then
    begin
      if ConvertLTOLonLatToXY(RadToDeg(Lon),RadToDeg(Lat),RawXPix,RawYPix) and
       (RawXPix>=0) and (RawXPix<MapPtr^.Width) and (RawYPix>=0) and (RawYPix<MapPtr^.Height) then
          Result := True;
    end
  else if Clementine_RadioButton.Checked then // Texture Map 3
    begin
    // Note: MaxLon may exceed Pi if texture spans farside seam
      if (Lat>=MinLat) and (Lat<=MaxLat) then
        begin
          RawYPix := Trunc((MaxLat - Lat)*YPixPerRad);
          if (RawYPix>=0) and (RawYPix<MapPtr^.Height) then
            begin
              RawXPix := -999;  // invalid value by default
              if (Lon>=MinLon) and (Lon<=MaxLon) then
                RawXPix := Trunc((Lon - MinLon)*XPixPerRad)
              else if ((Lon+TwoPi)>=MinLon) and ((Lon+TwoPi)<=MaxLon) then
                RawXPix := Trunc((Lon + TwoPi - MinLon)*XPixPerRad);

              if (RawXPix>=0) and (RawXPix<MapPtr^.Width) then
                begin
                  Result := True;
                end;
            end;
        end;
    end
  else // other Texture Maps cover entire globe, so can dispense with limit checks
    begin
      RawXPix := Trunc((Lon - MinLon)*XPixPerRad);
      RawYPix := Trunc((MaxLat - Lat)*YPixPerRad);

   // wrap around if necessary
      while RawXPix<0 do RawXPix := RawXPix + MapPtr^.Width;
      while RawXPix>(MapPtr^.Width-1) do RawXPix := RawXPix - MapPtr^.Width;
      while RawYPix<0 do RawYPix := RawYPix + MapPtr^.Height;
      while RawYPix>(MapPtr^.Height-1) do RawYPix := RawYPix - MapPtr^.Height;

      Result := True;
    end;

  if Result then
    begin
      RawRow := MapPtr^.ScanLine[RawYPix];
      PixelData := RawRow[RawXPix];
    end;

end;

procedure TLTVT_Form.DrawTexture_ButtonClick(Sender: TObject);
var
  TempPicture : TPicture;
  ScaledMap : TBitMap;

  i, j,                {screen coords}
  RawXPixel, RawYPixel //,   ErrorCode
  : Integer;

  Lat, Lon,            {selenographic latitude, longitude [radians]}
  Y //,   TempVal
  : Extended;

  ScaledRow  :  pRGBArray;

  PixelData, SkyPixel, NoDataPixel : TRGBTriple;

begin {TLTVT_Form.DrawTexture_ButtonClick}
//  ShowMessage('Width = '+IntToStr(Image1.Width));

  DrawingMode := TextureMode;

  ClearImage;

  SkyPixel := ColorToRGBTriple(SkyColor);
  NoDataPixel := ColorToRGBTriple(NoDataColor);

  if LoResUSGS_RadioButton.Checked and not LoRes_Texture_Loaded then
    begin
      OldFilename := LoResFilename;
      LoRes_TextureMap := TBitmap.Create;
//      HiRes_TextureMap.PixelFormat := pf24bit; // doesn't help

      if (not FileExists(LoResFilename)) and (MessageDlg('LTVT cannot find the low resolution USGS texture map'+CR
                        +'   Do you want help with this?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(LoResFilename) or PictureFileFound('USGS Low Resolution Texture File','lores.jpg',LoResFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          ThreeD_CheckBox.Hide;
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TempPicture.OnProgress := ImageLoadProgress;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(LoResFilename);
              if LinuxCompatibilityMode then
                begin
                  LoRes_TextureMap.Width  := TempPicture.Graphic.Width;
                  LoRes_TextureMap.Height := TempPicture.Graphic.Height;
                  LoRes_TextureMap.PixelFormat := pf24bit;
                  LoRes_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  LoRes_TextureMap.Assign(TempPicture.Graphic);
                  LoRes_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              LoRes_Texture_Loaded := true;
              LoResUSGS_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+LoResFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            ThreeD_CheckBox.Show;
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if LoResFilename<>OldFilename then FileSettingsChanged := True;
    end;

  if HiResUSGS_RadioButton.Checked and not HiRes_Texture_Loaded then
    begin
      OldFilename := HiResFilename;
      HiRes_TextureMap := TBitmap.Create;
//      HiRes_TextureMap.PixelFormat := pf24bit; // doesn't help

      if (not FileExists(HiResFilename)) and (MessageDlg('LTVT needs to find a High Resolution USGS texture map'+CR
                        +'   Do you want help with this procedure?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(HiResFilename) or PictureFileFound('USGS High Resolution Texture File','hires.jpg',HiResFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          ThreeD_CheckBox.Hide;
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TempPicture.OnProgress := ImageLoadProgress;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(HiResFilename);
              if LinuxCompatibilityMode then
                begin
// alternative way of copying to bitmap
                  HiRes_TextureMap.Width  := TempPicture.Graphic.Width;
                  HiRes_TextureMap.Height := TempPicture.Graphic.Height;
                  HiRes_TextureMap.PixelFormat := pf24bit;
                  HiRes_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  HiRes_TextureMap.Assign(TempPicture.Graphic);
                  HiRes_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                end;
              HiRes_Texture_Loaded := true;
              HiResUSGS_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+HiResFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            ThreeD_CheckBox.Show;
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if HiResFilename<>OldFilename then FileSettingsChanged := True;
    end;

  if Clementine_RadioButton.Checked and not Clementine_Texture_Loaded then
    begin
      OldFilename := ClementineFilename;
      Clementine_TextureMap := TBitmap.Create;
//      Clementine_TextureMap.PixelFormat := pf24bit; // doesn't help

      if (not FileExists(ClementineFilename)) and (MessageDlg('LTVT needs to find a Clementine texture map'+CR
                        +'   Do you want help with this procedure?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(ClementineFilename) or PictureFileFound('Clementine Texture File','hires_clem.jpg',ClementineFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          ThreeD_CheckBox.Hide;
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(ClementineFilename);
              if LinuxCompatibilityMode then
                begin
// alternative way of copying to bitmap
                  Clementine_TextureMap.Width  := TempPicture.Graphic.Width;
                  Clementine_TextureMap.Height := TempPicture.Graphic.Height;
                  Clementine_TextureMap.PixelFormat := pf24bit;
                  Clementine_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  Clementine_TextureMap.Assign(TempPicture.Graphic);
                  Clementine_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              Clementine_Texture_Loaded := true;
              Clementine_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+ClementineFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            ThreeD_CheckBox.Show;
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if ClementineFilename<>OldFilename then FileSettingsChanged := True;
    end;

  if UserPhoto_RadioButton.Checked and not UserPhotoLoaded then
    begin
      if FileExists(UserPhotoData.PhotoFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          ThreeD_CheckBox.Hide;
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TRY
            TRY
              TempPicture.LoadFromFile(UserPhotoData.PhotoFilename);
              if LinuxCompatibilityMode then
                begin
                  UserPhoto.Width  := TempPicture.Graphic.Width;
                  UserPhoto.Height := TempPicture.Graphic.Height;
                  UserPhoto.PixelFormat := pf24bit;
                  UserPhoto.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  UserPhoto.Assign(TempPicture.Graphic);
                  UserPhoto.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              UserPhotoLoaded := True;
              UserPhoto_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+UserPhotoData.PhotoFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            ThreeD_CheckBox.Show;
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end
      else
        ShowMessage('Unable to find '+UserPhotoData.PhotoFilename);

    end;

  if LTO_RadioButton.Checked then
    begin
      MapPtr := @LTO_Image;
      TextureFilename := LTO_Filename;
    end
  else if Clementine_RadioButton.Checked and Clementine_Texture_Loaded then
    begin
      MapPtr := @Clementine_TextureMap;
      TextureFilename := ClementineFilename
    end
  else if HiResUSGS_RadioButton.Checked and HiRes_Texture_Loaded then
    begin
      MapPtr := @HiRes_TextureMap;
      TextureFilename := HiResFilename;
    end
  else if UserPhoto_RadioButton.Checked and UserPhotoLoaded then
    begin
      MapPtr := @UserPhoto;
      TextureFilename := UserPhotoData.PhotoFilename;
    end
  else if LoRes_Texture_Loaded then
    begin
      MapPtr := @LoRes_TextureMap;
      TextureFilename := LoResFilename;
    end
  else
    begin
      MapPtr := nil;
      TextureFilename := 'unknown';
    end;

  if not CalculateGeometry then Exit;

  if MapPtr=nil then
    begin
      ShowMessage('No texture map loaded -- drawing map in Dots mode');
      DrawDots_Button.Click;
    end
  else
    begin
      if Clementine_RadioButton.Checked and not Clementine_Texture_Loaded then
        ShowMessage(Clementine_RadioButton.Caption+' not loaded -- using '+LoResUSGS_RadioButton.Caption);
      if HiResUSGS_RadioButton.Checked and not HiRes_Texture_Loaded then
        ShowMessage(HiResUSGS_RadioButton.Caption+' not loaded -- using '+LoResUSGS_RadioButton.Caption);

      DrawingMap_Label.Caption := 'Drawing texture map...';
      Screen.Cursor := crHourGlass;
      ProgressBar1.Max := Image1.Height-1;
      ProgressBar1.Step := 1;
      ProgressBar1.Show;
      DrawCircles_CheckBox.Hide;
      MarkCenter_CheckBox.Hide;
      ThreeD_CheckBox.Hide;
      Application.ProcessMessages;

      ScaledMap := TBitmap.Create;
      ScaledMap.PixelFormat := pf24bit;
      ScaledMap.Height := Image1.Height;
      ScaledMap.Width := Image1.Width;

      for j := 0 to Image1.Height-1 do with Image1 do
        begin
    //      Application.ProcessMessages;
          ProgressBar1.StepIt;
          Y := YValue(j);
          ScaledRow := ScaledMap.ScanLine[j];

          for i := 0 to Image1.Width-1 do
            begin
              if ConvertXYtoLonLat(XValue(i),Y,Lon,Lat) then {point is inside circle, want to draw}
                begin
                  if LookUpPixelData(Lon,Lat,RawXPixel,RawYPixel,PixelData) then
                    begin
                      ScaledRow[i] := PixelData;
                      GammaCorrectPixelValue(ScaledRow[i],ImageGamma);
                    end
                  else
                    ScaledRow[i] := NoDataPixel;
                end
              else if SkyColor<>clWhite then
                begin
                  ScaledRow[i] := SkyPixel;  // generates background of specified color outside image area
                end;
            end;

        end;

      Image1.Canvas.Draw(0,0,ScaledMap);
//      LastImageWidth := Image1.Width;
//      LastImageHeight := Image1.Height;

      ScaledMap.Free;

      DrawTerminator;
      ProgressBar1.Hide;
      DrawCircles_CheckBox.Show;
      MarkCenter_CheckBox.Show;
      ThreeD_CheckBox.Show;
      DrawingMap_Label.Caption := '';
      Screen.Cursor := DefaultCursor;
    end;

end;  {TLTVT_Form.DrawTexture_ButtonClick}

function TLTVT_Form.PosNegDegrees(const Angle : extended) : extended;
{Adjusts Angle (in degrees) to range -180 .. +180}
  begin
    Result := Angle;
    while Result<-180 do Result := Result + 360;
    while Result>+180 do Result := Result - 360;
  end;

function  TLTVT_Form.CalculateSubPoints(const MJD, ObsLon, ObsLat, ObsElev : extended; var SubObsPt, SubSunPt : TPolarCoordinates) : Boolean;
var
  SavedObsLon, SavedObsLat, SavedObsElev : Extended;

  begin
    Result := False;

    if not EphemerisDataAvailable(MJD) then
      begin
        ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
        Exit;
      end;

    SavedObsLon := ObserverLongitude;
    SavedObsLat := ObserverLatitude;
    SavedObsElev := ObserverElevation;

    CurrentObserver := Special;
    ObserverLongitude := -ObsLon;
    ObserverLatitude := ObsLat;
    ObserverElevation := ObsElev;

    SubObsPt := SubEarthPointOnMoon(MJD);
    SubSunPt := SubSolarPointOnMoon(MJD);

    ObserverLongitude := SavedObsLon;
    ObserverLatitude := SavedObsLat;
    ObserverElevation := SavedObsElev;

    Result := True;  // calculation successfully completed
  end;

procedure TLTVT_Form.EstimateData_ButtonClick(Sender: TObject);
var
  UT_MJD : extended;
  SunPosition, MoonPosition : PositionResultRecord;
  SubEarthPoint : TPolarCoordinates;

begin {EstimateData_ButtonClick}
//  FocusControl(MousePosition_GroupBox); // need to remove focus or button will remain pictured in a depressed state

  Screen.Cursor := crHourGlass;

  ObserverLongitude := -ExtendedValue(ObserverLongitudeText); {Note: reversing positive West to negative West longitude}
  ObserverLatitude := ExtendedValue(ObserverLatitudeText);
  ObserverElevation := ExtendedValue(ObserverElevationText);
  ImageObsLon := -ObserverLongitude;
  ImageObsLat := ObserverLatitude;
  ImageObsElev := ObserverElevation;

  ImageDate := DateOf(Date_DateTimePicker.Date);
  ImageTime := TimeOf(Time_DateTimePicker.Time);
  ImageGeocentric := GeocentricSubEarthMode;

  UT_MJD := DateTimeToModifiedJulianDate(ImageDate + ImageTime);

  if not CalculateSubPoints(UT_MJD,ImageObsLon,ImageObsLat,ImageObsElev,SubEarthPoint,SubSolarPoint) then exit;

  CalculatePosition(UT_MJD,Moon,BlankStarDataRecord,MoonPosition);
  CalculatePosition(UT_MJD,Sun, BlankStarDataRecord,SunPosition);

//  with MoonPosition do ShowMessage(Format('MJD=%0.2f: DUT=%0.3f;  EUT=%0.3f',[UT_MJD,DUT,EUT]));

//  ShowMessage(Format('Lunar age = %0.3f days',[LunarAge(UT_MJD)]));

  if GeocentricSubEarthMode then
    begin
      EstimatedData_Label.Caption  := '          Imaginary observer is at center of Earth';
      MoonElev_Label.Caption       := '                 (geocentric computation)';
    end
  else
    begin
      EstimatedData_Label.Caption := 'For observer at '+LongitudeString(ImageObsLon,4)+' / '+LatitudeString(ImageObsLat,4);
      MoonElev_Label.Caption := Format('Moon: %0.1f deg at %0.1f az    Sun: %0.1f deg at %0.1f az',
        [MoonPosition.TopocentricAlt,MoonPosition.Azimuth,SunPosition.TopocentricAlt,SunPosition.Azimuth]);
    end;

  MoonDiameter_Label.Caption := Format('Moon''s angular diameter: %0.1f arc-seconds',[7200*RadToDeg(ArcSin(MoonRadius*OneKm/OneAU/ObserverToMoonAU))]);

  SetEstimatedGeometryLabels;

  SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(RadToDeg(SubEarthPoint.Longitude))]);
  SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubEarthPoint.Latitude)]);

  SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(RadToDeg(SubSolarPoint.Longitude))]);
  SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubSolarPoint.Latitude)]);

  SunRad := Rsun/(OneAU*MoonToSunAU);
//  ShowMessage(Format('Radius of Sun =%0.6f',[SunRad]));

  if ShowDetails then with PopupMemo do
    begin
      Show;
      Memo.Lines.Add('Requested date/time: '+DateToStr(ImageDate)+' at '+TimeToStr(ImageTime)+' UTC');
      Memo.Lines.Add(Format(' --> Julian date = %0.9f',[UT_MJD + MJDOffset]));
      with MoonPosition do
        begin
          Memo.Lines.Add(Format('For ephemeris lookup, add %0.3f seconds and read data in:',[EUT]));
          Memo.Lines.Add(' '+JPL_Filename);
          Memo.Lines.Add('giving following results: ');
          Memo.Lines.Add(Format('  Distance from observer to center of Moon: %0.0f m',[ObserverToMoonAU*OneAU]));
          Memo.Lines.Add(Format('  Distance from observer to center of Moon: %0.0f m',[Distance*OneAU]));
          Memo.Lines.Add(Format('  Angular diameter of Sun as seen from center of Moon: %0.6f degrees',[RadToDeg(2*SunRad)]));
        end;
      Memo.Lines.Add('');
    end;

  RefreshImage;
  Screen.Cursor := DefaultCursor;
end;  {EstimateData_ButtonClick}

function TLTVT_Form.RefreshCraterList : Boolean;
var
  CraterFile : TextFile;
  FileRecord : TSearchRec;
  CurrentCrater : TCrater;
  DataLine : String;
  LineNum, CraterCount, PrimaryCraterCount : Integer;

  function DecimalValue(StringToConvert: string): extended;
    var
      ErrorCode : integer;
    begin
      RemoveBlanks(StringToConvert);
      val(StringToConvert, Result, ErrorCode);
      if ErrorCode<>0 then
        begin
          ShowMessage('Unable to convert "'+StringToConvert
           +'" on line '+IntToStr(LineNum)+' to decimal number, error at position '+IntToStr(ErrorCode)+CR
           +'Substituting 0.00');
          Result := 0;
        end;
    end;

begin  {RefreshCraterList}
  Result := False;

  OldFilename := CraterFilename;

  if (not FileExists(OldFilename)) and (MessageDlg('LTVT is looking for the named features file'+CR
                    +'   Do you want help with this topic?',
      mtWarning,[mbYes,mbNo],0)=mrYes) then
        begin
          HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/LunarFeatureFile.htm'),HH_DISPLAY_TOPIC, 0);
        end;

  if not FileFound('Crater file',OldFilename,CraterFilename) then
    begin
//          ShowMessage('Cannot draw dots -- no feature file loaded');
      ShowMessage('Cannot draw dots -- '+CraterFilename+' not loaded');
      Exit;
    end;
  if CraterFilename<>OldFilename then FileSettingsChanged := True;

  if CraterListCurrent then
    begin
      FindFirst(CraterFilename,faAnyFile,FileRecord);
      if FileRecord.Time=LastCraterListFileRecord.Time then
        Exit
      else
        LastCraterListFileRecord := FileRecord;
    end;

  CraterListCurrent := False;
  GoToListCurrent := False;

  AssignFile(CraterFile,CraterFilename);
  Reset(CraterFile);

  if EOF(CraterFile) then
    begin
      ShowMessage('Lunar feature file ['+CraterFilename+'] is empty');
      Exit;
    end;

  Readln(CraterFile,DataLine);
  if Substring(DataLine,1,5)<>'USGS1' then
    begin
      ShowMessage('Lunar feature file ['+CraterFilename+'] is not in USGS1 format');
      Exit;
    end;

  LineNum := 1;

  Screen.Cursor := crHourGlass;
  DrawingMap_Label.Caption := 'Reading feature list...';
  ProgressBar1.Max := 9100;  // approx. num. lines in CraterFile
  ProgressBar1.Position := 0;
  ProgressBar1.Show;
  DrawCircles_CheckBox.Hide;
  MarkCenter_CheckBox.Hide;
  ThreeD_CheckBox.Hide;
  Application.ProcessMessages;

  SetLength(CraterList,300000); // max number to store in list
  CraterCount := 0;

  SetLength(PrimaryCraterList,10000); // max number to store in list
  PrimaryCraterCount := 0;

  while not EOF(CraterFile) do with CurrentCrater do
    begin
      Readln(CraterFile,DataLine);
      Inc(LineNum);
      if (LineNum mod 1000)=0 then ProgressBar1.Position := LineNum; // update periodically
      DataLine := Trim(DataLine);
      if (DataLine<>'') and (Substring(DataLine,1,1)<>'*') then
        begin
          UserFlag := LeadingElement(DataLine,',');
          Name := LeadingElement(DataLine,',');
//          if Name='' then ShowMessage('No name on line '+IntToStr(LineNum)); //Note: this is normal in latter part of 1994 ULCN
          LatStr := LeadingElement(DataLine,',');
          LonStr := LeadingElement(DataLine,',');
          Lat  := DegToRad(DecimalValue(LatStr));
          Lon  := DegToRad(DecimalValue(LonStr));
          NumericData := LeadingElement(DataLine,',');
          USGS_Code := LeadingElement(DataLine,',');  // read first element of remainder -- ignore possible comments at end of line
          if (USGS_Code='CN') or (USGS_Code='CN5')then
            begin
              AdditionalInfo1 := LeadingElement(DataLine,',');
              AdditionalInfo2 := LeadingElement(DataLine,',');
            end
          else
            begin
              AdditionalInfo1 := '';
              AdditionalInfo2 := '';
            end;

          if CraterCount<Length(CraterList) then
            begin
              CraterList[CraterCount] := CurrentCrater;
            end
          else
            begin
              SetLength(CraterList,Length(CraterList)+1);
              CraterList[Length(CraterList)-1] := CurrentCrater;
            end;

          Inc(CraterCount);

          if (UpperCaseString(USGS_Code)='AA') then
            begin
              if (PrimaryCraterCount<Length(PrimaryCraterList)) then
                PrimaryCraterList[PrimaryCraterCount] := CurrentCrater
              else
                begin
                  SetLength(PrimaryCraterList,Length(PrimaryCraterList)+1);
                  PrimaryCraterList[Length(PrimaryCraterList)-1] := CurrentCrater;
                end;

              Inc(PrimaryCraterCount);
            end;

        end;
    end;

  CloseFile(CraterFile);

  SetLength(CraterList,CraterCount);
  SetLength(PrimaryCraterList,PrimaryCraterCount);
  Screen.Cursor := DefaultCursor;

  ProgressBar1.Hide;
  DrawCircles_CheckBox.Show;
  MarkCenter_CheckBox.Show;
  ThreeD_CheckBox.Show;
  DrawingMap_Label.Caption := '';

  CraterListCurrent := True;
  Result := True;
end;   {RefreshCraterList}

procedure TLTVT_Form.ResetZoom_ButtonClick(Sender: TObject);
begin
  ImageCenterX := 0;
  ImageCenterY := 0;
  Zoom_LabeledNumericEdit.NumericEdit.Text := '1.0';
  CraterThreshold_LabeledNumericEdit.NumericEdit.Text := '-1';
  Gamma_LabeledNumericEdit.NumericEdit.Text := '1.0';
  GridSpacing_LabeledNumericEdit.NumericEdit.Text := '0';
  RotationAngle_LabeledNumericEdit.NumericEdit.Text := '0';
  DrawCircles_CheckBox.Checked := False;
  MarkCenter_CheckBox.Checked := False;
  ThreeD_CheckBox.Checked := False;
  RefreshImage;
end;

procedure TLTVT_Form.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{Note: the X, Y returned to this routine are the positions within Image1 relative to upper left corner}
var
  ProjectedX, ProjectedY, Lon, Lat, UT_MJD,
  SunAngle, SunBearing, RefPtAngle, RefPtBearing,
  MagV2, ACosArg,
  Lon1, Lat1, Lon2, Lat2, CosTheta,
  DEM_height : Extended;
  i, MinI, RSqrd, MinRsqrd, RawXPixel, RawYPixel, Hue, Saturation, Value : Integer;
  FeatureDescription, RuklString : string;
  V1, V2, S : TVector;
  SavedGeocentricMode : Boolean;
  SunPosition, MoonPosition : PositionResultRecord;
  EarthViewerSubEarthPoint, EarthViewerSubSolarPoint : TPolarCoordinates;
  PixelData : TPixelValue;

  function RayHeight(const A, B :extended) : extended;
  {A = sun angle [rad] at source of light;  B = distance [rad] for source pt to target pt;
    Result = difference in elevation [m] from source pt to target pt}
    begin
      Result := 1000*MoonRadius*((Cos(A)/Cos(A-B)) - 1);
    end;

  procedure UserPhotoElevationReadout;
  {Interprets difference between reference and mouse points as an elevation difference
   for an Earth- or Satellite-based photo, as opposed to a flattened map.  The mouse must
   be pointed at the red line drawn on the mouse right-click.  The red line plots the
   possible endpoints in the original photo obtained by 3-dimensional extension from the
   starting point in the direction of the ShadowDirectionVector.  The distance from the
   reference point to the current mouse position in the original photo indicates the number
   of units of the ShadowDirectionVector that have to added to the original three dimensional
   position. The height difference is the difference in length of the vectors representing the
   start and endpoints.

   This routine assumes the following global variables were set when the red shadow line was drawn:

    RefPtVector,   // full vector at MoonRadius in Selenographic
    ShadowDirectionVector : TVector;  // unit (1 km) vector parallel or anti-parallel to solar rays, depending on mode
    RefPtUserX, RefPtUserY,   // position of start of red line in X-Y system of original photo
    ShadowDirectionUserDistance : Extended; // amount of travel in photo X-Y system for 1 unit of ShadowDirectionVector

    Note that the length of the RefPtVector is always set to MoonRadius.
}
    var
      MouseUserX, MouseUserY, MouseDistance : Extended;
    begin {UserPhotoElevationReadout}
      V1 := RefPtVector;
      S := ShadowDirectionVector;

      if not ConvertLonLatToUserPhotoXY(Lon,Lat,MoonRadius,MouseUserX, MouseUserY) then Exit;  // locate origin or current pixel in original photo

      MouseDistance := Sqrt(Sqr(MouseUserX - RefPtUserX) + Sqr(MouseUserY - RefPtUserY));

      if ShadowDirectionUserDistance<>0 then
        begin
          MultiplyVector(MouseDistance/ShadowDirectionUserDistance,S);
          VectorSum(V1,S,V2);  // move along Sun vector in three dimensions to point seen in projection at mouse point
          MagV2 := VectorMagnitude(V2);
          ShadowTipVector := V2;  // this is the opposite end from the Ref Pt -- it may be the shadow tip or the shadow-casting point

          ACosArg := DotProduct(V1,V2)/(VectorMagnitude(V1)*MagV2);
          if Abs(ACosArg)>1 then ACosArg := 1;  // avoid possible round off error

          CurrentElevationDifference_m := 1000*(MagV2 - MoonRadius);

          if MagV2<>0 then
            RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
              [RadToDeg(ArcCos(ACosArg)),CurrentElevationDifference_m])
          else
            RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
              [0,CurrentElevationDifference_m]);
        end
      else
        begin
          ShadowTipVector := RefPtVector;   //  dummy value -- three dimensional position cannot be evaluated
          RefPtDistance_Label.Caption := 'Sun direction parallel to line of sight';
        end;
    end;  {UserPhotoElevationReadout}

begin {LTVT_Form.Image1MouseMove}
  with Image1 do
    begin
      ProjectedX := XValue(X);
      ProjectedY := YValue(Y);
    end;

  CurrentMouseX := ProjectedX;
  CurrentMouseY := ProjectedY;


  if not ((DrawingMode=Dem_3D) or ConvertXYtoLonLat(ProjectedX,ProjectedY,Lon,Lat)) then
    begin
      MousePosition_GroupBox.Hint := 'X = horizontal, Y = vertical position on scale of -1 to +1; mouse is outside projected sphere';
      MousePosition_GroupBox.Caption := format('Mouse Position:  X = %0.4f  Y = %0.4f',[ProjectedX,ProjectedY]);
      HideMouseMoveLabels;
    end
  else
    begin
      if DrawingMode=EarthView then
        begin
          MousePosition_GroupBox.Hint := 'Box gives information related to observations of Sun and Moon from sea level at current mouse point on Earth';
          MousePosition_GroupBox.Caption := format('Mouse Position:  Longitude = %0s   Latitude = %0s',
            [LongitudeString(RadToDeg(Lon),2),LatitudeString(RadToDeg(Lat),2)]);

          MouseLonLat_Label.Hint := 'Altitude and azimuth of center of Sun as viewed from sea level at current mouse point';
          SunAngle_Label.Hint := 'Altitude and azimuth of center of Moon as viewed from sea level at current mouse point';
          RefPtDistance_Label.Hint := 'Librations in longitude and latitude and diameter of Moon as viewed from sea level at current mouse point';
          CraterName_Label.Hint := 'Angular separation of Sun and Moon and percent illumination of Moon as viewed from sea level at current mouse point';

          SavedGeocentricMode := GeocentricSubEarthMode;

          GeocentricSubEarthMode := False;

          ObserverLongitude := -RadToDeg(Lon); {Note: reversing positive West to negative West longitude}
          ObserverLatitude := RadToDeg(Lat);
          ObserverElevation := 0;

          UT_MJD := DateTimeToModifiedJulianDate(ImageDate + ImageTime);

          CalculatePosition(UT_MJD,Moon,BlankStarDataRecord,MoonPosition);
          CalculatePosition(UT_MJD,Sun, BlankStarDataRecord,SunPosition);

          MouseLonLat_Label.Caption := Format(' Sun is at :  %0.2f deg altitude and %0.2f deg azimuth',
            [SunPosition.TopocentricAlt,SunPosition.Azimuth]);
          SunAngle_Label.Caption := Format('Moon is at : %0.2f deg altitude and %0.2f deg azimuth',
            [MoonPosition.TopocentricAlt,MoonPosition.Azimuth]);

       {Note: need to correct reversal of positive West to negative West longitude}
          if not CalculateSubPoints(UT_MJD,-ObserverLongitude,ObserverLatitude,0,EarthViewerSubEarthPoint,EarthViewerSubSolarPoint) then
            CraterName_Label.Caption := ''
          else
            begin
              Lon1 := EarthViewerSubEarthPoint.Longitude;
              Lat1 := EarthViewerSubEarthPoint.Latitude;
              Lon2 := EarthViewerSubSolarPoint.Longitude;
              Lat2 := EarthViewerSubSolarPoint.Latitude;

              CosTheta := Sin(Lat1)*Sin(Lat2) + Cos(Lat1)*Cos(Lat2)*Cos(Lon2 - Lon1);

              ComputeDistanceAndBearing(MoonPosition.Azimuth*OneDegree,MoonPosition.TopocentricAlt*OneDegree,SunPosition.Azimuth*OneDegree,SunPosition.TopocentricAlt*OneDegree,SunAngle,SunBearing);

              RefPtDistance_Label.Caption := Format('Librations : %s / %s   Diam = %0.1f arc-sec'   ,
                [LongitudeString(RadToDeg(EarthViewerSubEarthPoint.Longitude),3),LatitudeString(RadToDeg(EarthViewerSubEarthPoint.Latitude),3),
                7200*RadToDeg(ArcSin(MoonRadius*OneKm/OneAU/ObserverToMoonAU))]);
              CraterName_Label.Caption := format(' Elongation = %0.2f deg;  Illumination = %0.3f%s',
                [SunAngle/OneDegree, 50*(1 + CosTheta), '%']);
            end;

          GeocentricSubEarthMode := SavedGeocentricMode;

        end
      else // showing Moon image
        begin
          MousePosition_GroupBox.Hint := 'Box gives information related to current mouse position on Moon; in top caption, "Map" is IAU format LTO zone number; "Rnn" is Rükl sheet number';
          RuklString := Rukl_String(Lon,Lat);
          if RuklString='' then
            MousePosition_GroupBox.Caption := format('Mouse Position:  X = %0.4f  Y = %0.4f  Map: %s',[ProjectedX,ProjectedY,LTO_String(Lon,Lat)])
          else
            MousePosition_GroupBox.Caption := format('Mouse Position:  X = %0.4f  Y = %0.4f  Map: %s / R%s',[ProjectedX,ProjectedY,LTO_String(Lon,Lat),RuklString]);

          MouseLonLat_Label.Hint := 'Selenographic longitude and latitude of current mouse point';
          SunAngle_Label.Hint := 'Altitude and azimuth of center of Sun as viewed from current mouse point on Moon';
          RefPtDistance_Label.Hint := 'Information related to mouse distance from current reference point';
          CraterName_Label.Hint := 'Information about dot closest to current mouse point';

          if (DrawingMode=Dem_3D) then with SurfaceData[X,Y] do
            begin
              if HeightDev_km=SurfaceData_NoDataValue then
                begin
                  HideMouseMoveLabels;
                  Exit;
                end;
              Lon := Lon_rad;
              Lat := Lat_rad;
            end;


          MouseLonLat_Label.Caption := format('Longitude = %0s   Latitude = %0s',
            [LongitudeString(RadToDeg(Lon),2),LatitudeString(RadToDeg(Lat),2)]);

          ComputeDistanceAndBearing(Lon,Lat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,SunAngle,SunBearing);

          SunAngle := (Pi/2) - SunAngle;

          SunAngle_Label.Caption := format('Sun is at = %0.2f deg altitude and %0.2f deg azimuth',
            [SunAngle/OneDegree, SunBearing/OneDegree]);

          case RefPtReadoutMode of
            DistanceAndBearingRefPtMode :
              begin
                ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                RefPtDistance_Label.Hint := 'Distance of current mouse point from reference point and azimuth CW from lunar north';
                RefPtDistance_Label.Caption := Format('From ref. pt. = %0.2f km  (%0.2f deg at %0.2f deg az)',
                  [MoonRadius*RefPtAngle,RadToDeg(RefPtAngle),RadToDeg(RefPtBearing)]);
              end;
            PixelDataReadoutMode :
              if (DrawingMode=TextureMode) then
                begin
                  RefPtDistance_Label.Hint := 'Pixel location and RGB intensities in source image';
                  if LookUpPixelData(Lon,Lat,RawXPixel,RawYPixel,PixelData) then with PixelData do
                    begin
                      RGBtoHSV(rgbtred, rgbtgreen, rgbtblue, Hue, Saturation, Value);
                      Saturation := Round(100*Saturation/255);
                      Value := Round(100*Value/255);
                      RefPtDistance_Label.Caption := Format('Source I,J: %0d,%0d  RGB: %0d/%0d/%0d HSV: %0d/%0d/%0d',
                        [RawXPixel,RawYPixel,rgbtRed,rgbtGreen,rgbtBlue,Hue,Saturation,Value])
                    end
                  else
                    RefPtDistance_Label.Caption := 'Mouse outside source image';
                end
              else
                RefPtDistance_Label.Caption := '(computed image -- no RGB source )';
            ShadowLengthRefPtMode :
              begin
                RefPtDistance_Label.Hint := 'Interpretation of current mouse position based on reference point at start of shadow';
                if UserPhoto_RadioButton.Checked then
                  UserPhotoElevationReadout
                else
                  begin
                    PolarToVector(Lon,Lat,MoonRadius,ShadowTipVector);
                    ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                    CurrentElevationDifference_m := 1000*MoonRadius*(Cos(RefPtAngle-RefPtSunAngle)/Cos(RefPtSunAngle)-1);
                    RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
                      [RadToDeg(RefPtAngle),CurrentElevationDifference_m]);
                  end;
              end;
            InverseShadowLengthRefPtMode :
              begin
                RefPtDistance_Label.Hint := 'Interpretation of current mouse position based on reference point at tip of shadow';
                if UserPhoto_RadioButton.Checked then
                  UserPhotoElevationReadout
                else
                  begin
                    PolarToVector(Lon,Lat,MoonRadius,ShadowTipVector);
                    ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                    CurrentElevationDifference_m := 1000*MoonRadius*(Cos(RefPtAngle-SunAngle)/Cos(SunAngle)-1);
                    RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
                      [RadToDeg(RefPtAngle),CurrentElevationDifference_m]);
                  end;
              end;
            RayHeightsRefPtMode :
              begin
                ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                RefPtDistance_Label.Hint := 'Interpretation of current mouse position based on reference point at start of shadow';
                RefPtDistance_Label.Caption := Format('Distance = %0.2f deg; Min. ray = %0.0f m; Max. = %0.0f m',
                  [RadToDeg(RefPtAngle),RayHeight(RefPtSunAngle+SunRad,RefPtAngle),RayHeight(RefPtSunAngle-SunRad,RefPtAngle)]);
              end;
            else
              begin
                RefPtDistance_Label.Hint := 'Height information from DEM';
                if (DrawingMode=Dem_3D) then
                  begin
                    DEM_height := SurfaceData[X,Y].HeightDev_km;
                    if DEM_height<>SurfaceData_NoDataValue then
                      RefPtDistance_Label.Caption := Format('Height = %0.3f km',[MoonRadius+DEM_height])
                    else
                      RefPtDistance_Label.Caption := 'No DEM data available';
                  end
                else
                  begin
                    if DEM_data.ReadHeight(RadToDeg(Lon),RadToDeg(Lat),DEM_height) then
                      RefPtDistance_Label.Caption := Format('Height = %0.3f km',[DEM_height])
                    else
                      RefPtDistance_Label.Caption := 'No DEM data available';
                  end;
              end;
            end;

          MinI := 0;
          MinRsqrd := MaxInt;

          for i := 0 to (Length(CraterInfo)-1) do with CraterInfo[i] do
            begin
              RSqrd := (X - Dot_X)*(X - Dot_X) + (Y - Dot_Y)*(Y - Dot_Y);
              if RSqrd<MinRsqrd then
                begin
                  MinRsqrd := RSqrd;
                  MinI := i;
                end;
            end;

      // display name iff mouse pointer is within 5 pixel radius of a dot
          if MinRsqrd<Sqr(5) then with CraterInfo[MinI].CraterData do
            begin
              if (USGS_Code='AA') or (USGS_Code='SF') then
                FeatureDescription := 'Crater:  '
              else if USGS_Code='GD' then
                FeatureDescription := 'GLR dome list:  '
              else if USGS_Code='CD' then
                FeatureDescription := 'Crater depth:  '
              else if USGS_Code='LF' then
                FeatureDescription := 'Landing site:  '
              else if (USGS_Code='CN') or (USGS_Code='CN5') then
                FeatureDescription := 'Control pt:  '
              else if USGS_Code='AT' then
                FeatureDescription := 'LIDAR elevation:  '
              else
                FeatureDescription := '';

              CraterName_Label.Caption  := FeatureDescription+LabelString(CraterInfo[MinI],True,True,True,True,True);
    {
              if (USGS_Code='CN') or (USGS_Code='CN5') then
                CraterName_Label.Caption  := Format('%s%s (%s km elev)',[FeatureDescription,Name,NumericData]) // "Diam" is actually Radial Distance
              else if USGS_Code='CD' then
                CraterName_Label.Caption  := Format('%s%s (%s km)',[FeatureDescription,Name,NumericData]) // "Diam" is actually Depth in kilometers
              else if USGS_Code='AT' then
                CraterName_Label.Caption  := Format('%s%s m (Rev. %s)',[FeatureDescription,Name,NumericData]) // "Diam" is actually Revolution Number
              else
                CraterName_Label.Caption  := Format('%s%s  (%s km)',[FeatureDescription,Name,NumericData]);
    }
            end
          else
            begin
              CraterName_Label.Hint  := '';
              CraterName_Label.Caption  := '';
            end;
        end;
    end;
end;  {LTVT_Form.Image1MouseMove}

procedure TLTVT_Form.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LastMouseClickPosition.X := X;
  LastMouseClickPosition.Y := Y;
  if (Button=mbLeft) and (DrawingMode<>EarthView) then
    begin
      ImageCenterX := XValue(X);
      ImageCenterY := YValue(Y);
{change center, but do NOT alter the value on GoTo form}
//      H_Terminator_Goto_Form.CenterX_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[Image1.XValue(X)]);
//      H_Terminator_Goto_Form.CenterY_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[Image1.YValue(Y)]);
      RefreshImage;
    end;
end;

procedure TLTVT_Form.Now_ButtonClick(Sender: TObject);
var
  SystemTime: TSystemTime;  // this is supposed to be maintained in UTC
  SystemDateTime : TDateTime;
begin
//  FocusControl(MousePosition_GroupBox); // need to remove focus or button will remain pictured in a depressed state

  GetSystemTime(SystemTime);
  SystemDateTime := SystemTimeToDateTime(SystemTime);

//round to nearest whole minute
// -- convert from days to minutes, add 0.5, truncate and convert pack to days
//  SystemDateTime := OneMinute*Int(SystemDateTime*OneDay/OneMinute + 0.5)/OneDay;

  Date_DateTimePicker.Date := DateOf(SystemDateTime);
  Time_DateTimePicker.Time := TimeOf(SystemDateTime);
  EstimateData_Button.Click;
end;

procedure TLTVT_Form.Time_DateTimePickerEnter(Sender: TObject);
{Since only the HH:MM are displayed, make sure the seconds are set to zero
-- a Now_ButtonClick enters a complete TDateTime with seconds and milliseconds}
var
  CurrentSetting : TDateTime;
begin
  CurrentSetting := Time_DateTimePicker.Time;
  Time_DateTimePicker.Time := EncodeTime(HourOf(CurrentSetting),MinuteOf(CurrentSetting),0,0);
end;

procedure TLTVT_Form.ImageLoadProgress(Sender: TObject; Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
  const R: TRect; const Msg: String);
begin
  case Stage of
    psStarting:
      begin
        DrawingMap_Label.Caption := 'Progress reading image file...';
        ProgressBar1.Max := 100;
        ProgressBar1.Show;
        DrawCircles_CheckBox.Hide;
        MarkCenter_CheckBox.Hide;
        ThreeD_CheckBox.Hide;
        Application.ProcessMessages;
      end;
    psRunning:
      begin
        ProgressBar1.Position := PercentDone;
        ProgressBar1.Update;
        Application.ProcessMessages;
      end;
    psEnding:
      begin
        ProgressBar1.Hide;
        DrawCircles_CheckBox.Show;
        MarkCenter_CheckBox.Show;
        ThreeD_CheckBox.Show;
        DrawingMap_Label.Caption := '';
        Application.ProcessMessages;
      end;
    end;
end;

procedure TLTVT_Form.SetManualGeometryLabels;
begin
  GeometryType_Label.Caption :=
    '---------------------------  Manually Set Geometry  ----------------------------';
  EstimatedData_Label.Hide;
  MoonElev_Label.Hide;
  MoonDiameter_Label.Hide;
  ManualMode := True;
end;

procedure TLTVT_Form.SetEstimatedGeometryLabels;
begin
  GeometryType_Label.Caption :=
    '---------------------------    Computed Geometry    ----------------------------';
  EstimatedData_Label.Show;
  MoonElev_Label.Show;
  MoonDiameter_Label.Show;
  ManualMode := False;
end;

procedure TLTVT_Form.SubObs_Lon_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.SubSol_Lon_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.SubObs_Lat_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.SubSol_Lat_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.Date_DateTimePickerChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.Time_DateTimePickerChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.ObserverLongitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.ObserverLatitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TLTVT_Form.Exit_MainMenuItemClick(Sender: TObject);
begin
  Close;
end;

procedure TLTVT_Form.About_MainMenuItemClick(Sender: TObject);
begin
  with TerminatorAbout_Form do
    begin
      Version_Label.Caption := 'Version: '+ProgramVersion;
      Copyright_Label.Caption := 'Copyright:  Jim Mosher and Henrik Bondo,  2006 - '+IntToStr(YearOf(Now));
      ShowModal;
    end;
end;

procedure TLTVT_Form.RefreshGoToList;
var
  CraterNum : Integer;
  FeatureName : String;

begin
  RefreshCraterList;
  if GoToListCurrent then Exit;

  with H_Terminator_Goto_Form do
    begin
      Screen.Cursor := crHourGlass;

      FeatureNameList.Clear;
      FeatureLatStringList.Clear;
      FeatureLonStringList.Clear;

      for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
        begin
            begin
              if (not MinimizeGotoList_CheckBox.Checked) or (UserFlag<>'') then
                begin
                  FeatureName := Name;
                  FeatureLatStringList.Add(LatStr);  // read latitude string
                  FeatureLonStringList.Add(LonStr);  // read longitude string
                  if FeatureName='' then
                    begin
                      // in 1994 ULCN, if there is no common name, then AdditionalInfo1 contains a control point number such as P1021
                      if AdditionalInfo1<>'' then
                        FeatureName := AdditionalInfo1
                      else
                        FeatureName := 'no name available';
                    end;
                  FeatureNameList.Add(FeatureName);
                end;
            end;
        end;

      FeatureNames_ComboBox.Items.Clear;
      FeatureNames_ComboBox.Items.AddStrings(FeatureNameList);
      if LastItemSelected<FeatureNames_ComboBox.Items.Count then
        FeatureNames_ComboBox.ItemIndex := LastItemSelected
      else
        FeatureNames_ComboBox.ItemIndex := 0;
    //  ShowMessage('Restoring item '+IntToStr(LastItemSelected));


      Screen.Cursor := DefaultCursor;
      GoToListCurrent := True;

    end;
end;

procedure TLTVT_Form.GoTo_MainMenuItemClick(Sender: TObject);
var
  Rukl_Xi, Rukl_Eta, Rukl_LonDeg, Rukl_LatDeg : Extended;

  procedure ShowLunarControls(const DesiredState : Boolean);
    begin
      with H_Terminator_Goto_Form do
        begin
          RuklZone_RadioButton.Visible := DesiredState;
          GoTo_Button.Visible := DesiredState;
          AerialView_Button.Visible := DesiredState;
          LAC_Label.Visible := DesiredState;
          LTOZone_Label.Visible := DesiredState;
          RuklZone_Label.Visible := DesiredState;
          XY_Redraw_Button.Visible := DesiredState;
        end;
    end;

begin
  RefreshGoToList;
  with H_Terminator_Goto_Form do
    begin
      if DrawingMode=EarthView then
        begin
          SetToLon_LabeledNumericEdit.Hint := 'Geographic longitude in decimal degrees (E=+  W=-)';
          SetToLat_LabeledNumericEdit.Hint := 'Geographic Latitude in decimal degrees (N=+  S=-)';
          CenterX_LabeledNumericEdit.Hint := 'Enter desired horizontal screen position on scale where full Earth ranges from -1.0 (left) to +1.0 (right)';
          CenterY_LabeledNumericEdit.Hint := 'Enter desired vertical screen position on scale where full Earth ranges from +1.0 (top) to -1.0 (bottom)';
          if RuklZone_RadioButton.Checked then LonLat_RadioButton.Checked := True;
          ShowLunarControls(False);
        end
      else
        begin
          SetToLon_LabeledNumericEdit.Hint := 'Selenographic longitude in decimal degrees (E=+  W=-)';
          SetToLat_LabeledNumericEdit.Hint := 'Selenographic Latitude in decimal degrees (N=+  S=-)';
          CenterX_LabeledNumericEdit.Hint := 'Enter desired horizontal screen position on scale where full Moon ranges from -1.0 (left) to +1.0 (right)';
          CenterY_LabeledNumericEdit.Hint := 'Enter desired vertical screen position on scale where full Moon ranges from +1.0 (top) to -1.0 (bottom)';
          ShowLunarControls(True);
        end;

      ShowModal;
      if not (GoToState=Cancel) then
        begin
          if LonLat_RadioButton.Checked then
            begin
              if DrawingMode=Dem_3D then
                GoToLonLat(SetToLon_LabeledNumericEdit.NumericEdit.ExtendedValue,
                  SetToLat_LabeledNumericEdit.NumericEdit.ExtendedValue,
                  SetToRadius_TLabeledNumericEdit.NumericEdit.ExtendedValue/MoonRadius)
              else
                GoToLonLat(SetToLon_LabeledNumericEdit.NumericEdit.ExtendedValue,
                  SetToLat_LabeledNumericEdit.NumericEdit.ExtendedValue,
                  1);
            end
          else if XY_RadioButton.Checked then
            GoToXY(CenterX_LabeledNumericEdit.NumericEdit.ExtendedValue,CenterY_LabeledNumericEdit.NumericEdit.ExtendedValue)
          else //Rukl mode
            begin
              if Center_RadioButton.Checked then
                ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites.bmp'
              else
                begin
                  if NW_RadioButton.Checked then
                    ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_NW.bmp'
                  else
                    if NE_RadioButton.Checked then
                      ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_NE.bmp'
                  else
                    if SW_RadioButton.Checked then
                      ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_SW.bmp'
                  else
                    if SE_RadioButton.Checked then
                      ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_SE.bmp';
                end;

              GoToRuklZone_Center(Rukl_Xi, Rukl_Eta, Rukl_LonDeg, Rukl_LatDeg);
              if (Rukl_LonDeg=-999) or (Rukl_LatDeg=-999) then
                begin
                  ShowMessage('Using Xi-Eta : the requested Rukl zone does not have a well defined lunar lon-lat');
                  GoToXY(Rukl_Xi, Rukl_Eta);
                end
              else
                GoToLonLat(Rukl_LonDeg, Rukl_LatDeg,1);

              if AutoLabel_CheckBox.Checked then
                begin
                  DrawTexture_Button.Click; // erase reference mark at center
                  DrawRuklGrid_MainMenuItemClick(Sender);
                  OverlayDots_Button.Click;
                  LabelDots_Button.Click;
                end;

            end;
        end;
    end;
end;

procedure TLTVT_Form.MarkXY(const X, Y : extended; const MarkColor : TColor);
var
  CraterCenterX, CraterCenterY : integer;
begin
  with Image1 do
    begin
      CraterCenterX := XPix(X);
      CraterCenterY := YPix(Y);
      if (CraterCenterX<0) or (CraterCenterX>Image1.Width) or
      (CraterCenterY<0) or (CraterCenterY>Image1.Height) then
        ShowMessage('Requested feature is not within the current viewing area')
      else
        DrawCross(CraterCenterX,CraterCenterY,DotSize+1,MarkColor);
    end;
end;

procedure TLTVT_Form.GoToXY(const X, Y : extended);
 {similar to GoToLonLat, but for xi-eta style input}
var
  DesiredLon, DesiredLat : Extended;
begin
  case H_Terminator_Goto_Form.GoToState of
    Mark : MarkXY(X,Y,ReferencePointColor);
    Center :
      begin
        ImageCenterX := X;
        ImageCenterY := Y;
        RefreshImage;
        MarkXY(X,Y,ReferencePointColor);
      end;
    AerialView :
      begin
        if not ConvertXYtoLonLat(X,Y,DesiredLon,DesiredLat) then
          begin
            ShowMessage('Unable to create aerial view: the requested X-Y position is not on the lunar disk');
            Exit;
          end
        else
          begin
            SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(RadToDeg(DesiredLon))]);
            SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(DesiredLat)]);
            SetManualGeometryLabels;
            if not CalculateGeometry then Exit;
            ImageCenterX := 0;
            ImageCenterY := 0;
            RefreshImage;
            MarkXY(0,0,ReferencePointColor);
          end;
      end;
    end; // (case)
end;

procedure TLTVT_Form.GoToLonLat(const Long_Deg, Lat_Deg, NormalizedRadius : extended);
 {attempts to set X-Y center to requested point, draw new texture map, and label point in aqua}
var
  CraterVector : TVector;
  X, Y : Extended;
  FarsideFeature : Boolean;
begin
  with H_Terminator_Goto_Form do if GoToState=AerialView then
    begin
        SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(Long_Deg)]);
        SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[Lat_Deg]);
//      SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := SetToLon_LabeledNumericEdit.NumericEdit.Text;
//      SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := SetToLat_LabeledNumericEdit.NumericEdit.Text;
      SetManualGeometryLabels;
    end;
  if DrawingMode<>EarthView then if not CalculateGeometry then Exit;
  PolarToVector(DegToRad(Long_Deg),DegToRad(Lat_Deg),NormalizedRadius,CraterVector);
  FarsideFeature := DotProduct(CraterVector,SubObsvrVector)<0;
  X := DotProduct(CraterVector,XPrime_UnitVector);
  Y := DotProduct(CraterVector,YPrime_UnitVector);
  if FarsideFeature then
    begin
      if DrawingMode=EarthView then
        ShowMessage('In the current viewing geometry, the requested feature is on the Earth''s farside')
      else
        ShowMessage('In the current viewing geometry, the requested feature is on the Moon''s farside');
      if H_Terminator_Goto_Form.GoToState=Mark then MarkXY(X,Y,clRed);
    end
  else
    begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
      if not (H_Terminator_Goto_Form.GoToState=Mark) then
        begin
          ImageCenterX := X;
          ImageCenterY := Y;
          RefreshImage;
        end;
      MarkXY(X,Y,ReferencePointColor);
    end;
end;

procedure TLTVT_Form.RefreshImage;
begin
  case DrawingMode of
    DotMode : DrawDots_Button.Click;
    DEM_2D, DEM_3D :
      begin
        if StayInDemModeOnRefresh then
          DrawDEM_Button.Click
        else
          DrawTexture_Button.Click;
      end;
  else
    DrawTexture_Button.Click;
  end;

{Note: control does not seem to reach this point except on the very first call
  to "Refresh Image" after the program is started. Why is that???}
//   ShowMessage('Image refreshed');
end;

procedure TLTVT_Form.DrawLinesToPoleAndSun_RightClickMenuItemClick(Sender: TObject);
var
  MouseOrthoX, MouseOrthoY, MouseLat, MouseLon, PointLat, PointLon,
  PointX, PointY, PointZ, AngleStep, LineLengthSqrd : extended;
  PointVector, RotationAxis : TVector;
begin {TLTVT_Form.DrawlinestonorthandtowardsSun1Click}
  with Image1 do
    begin
      MouseOrthoX := XValue(LastMouseClickPosition.X);
      MouseOrthoY := YValue(LastMouseClickPosition.Y);

      if ConvertXYtoLonLat(MouseOrthoX,MouseOrthoY,MouseLon,MouseLat) then {mouse is pointed at a location with known longitude and latitude}
        begin
// Draw line to selenographic north by increasing latitude in small steps
          Canvas.Pen.Color := clBlue;
          MoveToDataPoint(MouseOrthoX,MouseOrthoY);
          PointLon := MouseLon;
          PointLat := MouseLat;
          AngleStep := 0.01; // radians

          LineLengthSqrd := 0;
          PointZ := 0;

          while (LineLengthSqrd<4000) and (PointZ>=0) do
            begin
              PointLat := PointLat + AngleStep;
              PolarToVector(PointLon,PointLat,1,PointVector);
              PointX := DotProduct(PointVector,XPrime_UnitVector);
              PointY := DotProduct(PointVector,YPrime_UnitVector);
              PointZ := DotProduct(PointVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere
              if PointZ>=0 then LineToDataPoint(PointX,PointY);
              LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
            end;

// Draw line to SubSolar point by rotating PointVector CCW about (PointVector x SubSolarVector)
          Canvas.Pen.Color := clRed;
          MoveToDataPoint(MouseOrthoX,MouseOrthoY);
          PolarToVector(MouseLon,MouseLat,1,PointVector);
          CrossProduct(PointVector,SubSolarVector,RotationAxis);
          LineLengthSqrd := 0;
          PointZ := 0;

          while (LineLengthSqrd<4000) and (PointZ>=0) do
            begin
              RotateVector(PointVector,AngleStep,RotationAxis);
              PointX := DotProduct(PointVector,XPrime_UnitVector);
              PointY := DotProduct(PointVector,YPrime_UnitVector);
              PointZ := DotProduct(PointVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere
              if PointZ>=0 then LineToDataPoint(PointX,PointY);
              LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
            end;

          PlotDataPoint(MouseOrthoX,MouseOrthoY,3,clGreen,clGreen);
        end;

    end;
end;  {TLTVT_Form.DrawlinestonorthandtowardsSun1Click}

procedure TLTVT_Form.IdentifyNearestFeature_RightClickMenuItemClick(Sender: TObject);
var
  ParentName : string;
  CraterX, CraterY, LastMouseX, LastMouseY, RSqrd, MinRsqrd, ClosestCraterX, ClosestCraterY,
  Diam : extended;
  ClosestCrater, CurrentCrater : TCrater;
  CraterVector : TVector;
  CraterNum, CraterIndex, DiamErrorCode : integer;
  DotRadius, DotRadiusSqrd, XOffset, YOffset  : integer;
  CraterColor : TColor;

begin {TLTVT_Form.IdentifyNearestFeature_RightClickMenuItemClick}
  ClosestCraterX := 0;  // compiler is complaining these may not be initialized
  ClosestCraterY := 0;

  LastMouseX := XValue(LastMouseClickPosition.X);
  LastMouseY := YValue(LastMouseClickPosition.Y);

  RefreshCraterList;
  MinRsqrd := MaxExtended;

  for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
    begin
          if IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[') then
          begin
            PolarToVector(Lon,Lat,1,CraterVector);
            if DotProduct(CraterVector,SubObsvrVector)>=0 then with Image1 do
              begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
                CraterX := DotProduct(CraterVector,XPrime_UnitVector);
                CraterY := DotProduct(CraterVector,YPrime_UnitVector);
                RSqrd := Sqr(CraterX - LastMouseX) + Sqr(CraterY - LastMouseY);
                if RSqrd<MinRsqrd then
                  begin
                    ClosestCrater := CraterList[CraterNum-1];
                    ClosestCraterX := CraterX;
                    ClosestCraterY := CraterY;
                    MinRsqrd := RSqrd;
                  end;
              end;
          end;
    end;

  with Image1 do
    begin
      if DotSize>=0 then
        begin
          DotRadius := Round(DotSize/2.0 + 0.5);
          DotRadiusSqrd := Round(Sqr(DotSize/2.0));
          for XOffset := -DotRadius to DotRadius do
            for YOffset := -DotRadius to DotRadius do
              if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                Canvas.Pixels[XPix(ClosestCraterX)+XOffset, YPix(ClosestCraterY)+YOffset] := ReferencePointColor;
        end;

      val(ClosestCrater.NumericData,Diam,DiamErrorCode);

//      ShowMessage(Format('Diam = %0.3f',[Diam]));
      if DrawCircles_CheckBox.Checked and (DiamErrorCode=0) and (Diam>0) and (Diam<(MoonRadius*PiByTwo)) then
        DrawCircle(RadToDeg(ClosestCrater.Lon),RadToDeg(ClosestCrater.Lat),
          RadToDeg(Diam/MoonRadius/2),CraterCircleColor);
    end;

  if IdentifySatellites then
    begin
      ParentName := UpperCaseParentName(ClosestCrater.Name,ClosestCrater.USGS_Code);
//      ShowMessage('Seeking satellites of '+ParentName);
    end
  else
    ShowMessage(ClosestCrater.Name+' has been plotted');

  if not PositionInCraterInfo(XPix(ClosestCraterX), YPix(ClosestCraterY)) then
    begin
      CraterIndex := Length(CraterInfo);
      SetLength(CraterInfo,CraterIndex+1);
      CraterInfo[CraterIndex].CraterData := ClosestCrater;
      CraterInfo[CraterIndex].Dot_X := XPix(ClosestCraterX);
      CraterInfo[CraterIndex].Dot_Y := YPix(ClosestCraterY);
    end;

  if IdentifySatellites then
    begin
      for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
        begin
              if IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[') then
              begin
                if UpperCaseParentName(Name,USGS_Code)=ParentName then
                  begin
                    PolarToVector(Lon,Lat,1,CraterVector);
                    if DotProduct(CraterVector,SubObsvrVector)>=0 then with Image1 do
                      begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
                        CraterX := DotProduct(CraterVector,XPrime_UnitVector);
                        CraterY := DotProduct(CraterVector,YPrime_UnitVector);

                        with Image1 do
                          begin
                            val(NumericData,Diam,DiamErrorCode);

                            if (USGS_Code='AA') or (USGS_Code='SF') or (USGS_Code='CN')
                             or (USGS_Code='CN5') or (USGS_Code='GD') or (USGS_Code='CD') then
                              begin
                                if DiamErrorCode=0 then
                                  begin
                                    if Diam>=LargeCraterDiam then
                                      CraterColor := LargeCraterColor
                                    else if Diam>=MediumCraterDiam then
                                      CraterColor := MediumCraterColor
                                    else
                                      CraterColor := SmallCraterColor;
                                  end
                                else // unable to decode diameter
                                  CraterColor := NonCraterColor;
                              end
                            else
                              CraterColor := NonCraterColor;

                            if DotSize>=0 then
                              begin
                                DotRadius := Round(DotSize/2.0 + 0.5);
                                DotRadiusSqrd := Round(Sqr(DotSize/2.0));
                                for XOffset := -DotRadius to DotRadius do
                                  for YOffset := -DotRadius to DotRadius do
                                    if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                                      Canvas.Pixels[XPix(CraterX)+XOffset, YPix(CraterY)+YOffset] := CraterColor;
                              end;

                            if DrawCircles_CheckBox.Checked and (DiamErrorCode=0) and (Diam>0) and (Diam<(MoonRadius*PiByTwo)) then
                              DrawCircle(RadToDeg(Lon),RadToDeg(Lat),
                                RadToDeg(Diam/MoonRadius/2),CraterCircleColor);
                          end;

                        if not PositionInCraterInfo(XPix(CraterX), YPix(CraterY)) then
                          begin
                            CurrentCrater := CraterList[CraterNum-1];
                            CraterIndex := Length(CraterInfo);
                            SetLength(CraterInfo,CraterIndex+1);
                            CraterInfo[CraterIndex].CraterData := CurrentCrater;
                            CraterInfo[CraterIndex].Dot_X := XPix(CraterX);
                            CraterInfo[CraterIndex].Dot_Y := YPix(CraterY);
                          end;
                      end;
                  end;
              end;
        end;
    end;

  if Length(CraterInfo)>0 then LabelDots_Button.Show;

end;  {TLTVT_Form.IdentifyNearestFeature_RightClickMenuItemClick}

procedure TLTVT_Form.LabelFeatureAndSatellites_RightClickMenuItemClick(Sender: TObject);
begin
  IdentifySatellites := True;
  IdentifyNearestFeature_RightClickMenuItemClick(Sender);
  LabelDots_Button.Click;
  IdentifySatellites := False;
end;

procedure TLTVT_Form.HideMouseMoveLabels;
begin
  MouseLonLat_Label.Caption := '';
  SunAngle_Label.Caption := '';
  CraterName_Label.Caption := '';
  RefPtDistance_Label.Caption := '';
end;

procedure TLTVT_Form.SetRefPt_RightClickMenuItemClick(Sender: TObject);
var
  UserPhotoSubSolarLon, UserPhotoSubSolarLat,
  SubSolarErrorDistance, SubSolarErrorBearing : Extended;

  procedure DrawLineInShadowDirection;
  var
    MouseLat, MouseLon,
    PixelsPerXY_unit,
    PointX, PointY, PointZ, AngleStep, LineLengthSqrd,
    NewUserX, NewUserY,
    NewLon, NewLat,
    StepMag : Extended;
    PointVector, RotationAxis, StepVector, NewVector : TVector;
    NewPosition : TPolarCoordinates;
    MaxPixelLengthSqrd, StepNum, MaxSteps : Integer;
  begin
    with Image1 do
      begin
        if ConvertXYtoLonLat(RefX,RefY,MouseLon,MouseLat) then {mouse is pointed at a location with known longitude and latitude}
          begin
  // Draw line away SubSolar point by rotating PointVector CW about (PointVector x SubSolarVector)
            Canvas.Pen.Color := clRed;
            MoveToDataPoint(RefX,RefY);

            if ShadowLineLength_pixels<=0 then
              MaxPixelLengthSqrd := 0
            else
              MaxPixelLengthSqrd := Sqr(ShadowLineLength_pixels);

            MaxSteps := 2*ShadowLineLength_pixels;  // set limit on loops if drawing is not accomplished in expected number of 1 pixel steps

            if UserPhoto_RadioButton.Checked then
              begin
{The following global variables need to be set when drawing the shadow line on a user-calibrated photo.
 They are used to generate the readout in the MouseMove routine.
    RefPtVector,   // full vector at MoonRadius in Selenographic
    ShadowDirectionVector : TVector;  // unit (1 km) vector parallel or anti-parallel to solar rays, depending on mode
    RefPtUserX, RefPtUserY,   // position of start of red line in X-Y system of original photo
    ShadowDirectionUserDistance : Extended; // amount of travel in photo X-Y system for 1 unit of ShadowDirectionVector
}
                PixelsPerXY_unit := Abs(Image1.Width/(XValue(Image1.Width) - XValue(0)));   // Abs() necessary because denominator <0 if image inverted left-right

                PolarToVector(MouseLon,MouseLat,MoonRadius,PointVector);  // starting point in selenographic system, corresponding to RefX, RefY
                RefPtVector := PointVector;

                ConvertLonLatToUserPhotoXY(MouseLon,MouseLat,MoonRadius,RefPtUserX, RefPtUserY); // starting point in photo

//                ShowMessage('Start vector = '+VectorString(PointVector,3));

                StepVector := SubSolarVector;  // unit vector corresponds to 1 km step in direction *opposite* to solar rays
                if RefPtReadoutMode<>InverseShadowLengthRefPtMode then MultiplyVector(-1,StepVector); // in same direction as solar rays
                ShadowDirectionVector := StepVector;

                VectorSum(PointVector,StepVector,NewVector);  // end point in selenographic system
//                ShowMessage('End vector = '+VectorString(NewVector,3));

                ShadowDirectionUserDistance := 0;   // default value if following fails
                NewPosition := VectorToPolar(NewVector); // determine selenographic lon/lat
                with NewPosition do
                  if not ConvertLonLatToUserPhotoXY(Longitude,Latitude,Radius,NewUserX,NewUserY) then  // end point in photo
                    begin
                      ShowMessage('Can''t draw line: Sun direction is parallel to line of sight');
                      Exit;
                    end;

                ShadowDirectionUserDistance := Sqrt(Sqr(NewUserX - RefPtUserX) + Sqr(NewUserY - RefPtUserY));

                ConvertUserPhotoXYtoLonLat(NewUserX,NewUserY,MoonRadius,NewLon,NewLat); // where endpoint is plotted on idealized Moon

{
                ShowMessage(Format(
                  'NewPos Lon/Lat = %0.3f,%0.3f; User X/Y = %0.3f,%0.3f; End Lon/Lat = %0.3f,%0.3f',
                  [RadToDeg(NewPosition.Longitude),RadToDeg(NewPosition.Latitude),NewUserX,NewUserY,
                   RadToDeg(NewLon),RadToDeg(NewLat)]));
}

                PolarToVector(NewLon,NewLat,1,NewVector);  // endpoint as plotted in idealized system
                PointX := DotProduct(NewVector,XPrime_UnitVector);
                PointY := DotProduct(NewVector,YPrime_UnitVector);

                StepMag := Sqrt(Sqr(PointX - RefX) + Sqr(PointY - RefY)); // magnitude in Image1 XY units

                if StepMag>0 then
                  begin
                    StepMag := 1/(StepMag*PixelsPerXY_unit);  // scale to 1 pixel
                    MultiplyVector(StepMag,StepVector);

                    LineLengthSqrd := 0;
                    PointZ := 0; // need to set for later conditional test
                    StepNum := 0;

                    while (LineLengthSqrd<MaxPixelLengthSqrd) and (PointZ>=0) and (StepNum<MaxSteps) do
                      begin
                        VectorSum(PointVector,StepVector,PointVector);  // current end point in full selenographic system (including radius)
                        NewPosition := VectorToPolar(PointVector); // determine selenographic lon/lat
                        with NewPosition do
                          if not ConvertLonLatToUserPhotoXY(Longitude,Latitude,Radius,NewUserX,NewUserY) then  // end point in photo
                            begin
//                              ShowMessage('Can''t draw line: unable to trace sunlight direction');  // conversion fails when off disk?
                              Exit;
                            end;

                        if not ConvertUserPhotoXYtoLonLat(NewUserX,NewUserY,MoonRadius,NewLon,NewLat) then Exit; // where endpoint is plotted on idealized Moon

                        PolarToVector(NewLon,NewLat,1,NewVector);  // point as plotted in idealized system
                        PointX := DotProduct(NewVector,XPrime_UnitVector);
                        PointY := DotProduct(NewVector,YPrime_UnitVector);
                        PointZ := DotProduct(NewVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere

                        if PointZ>=0 then
                          begin
                            LineToDataPoint(PointX,PointY);
                            LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
                          end;

                        Inc(StepNum);
                      end;
                  end
                else
                  begin
                    ShowMessage('Can''t draw line: Sun direction is parallel to line of sight');
                    Exit;
                  end;
              end
            else // LTVT image is a flattened map, draw great circle towards (or away from) sub-solar point
              begin
                PolarToVector(MouseLon,MouseLat,MoonRadius,RefPtVector);
                PointVector := RefPtVector;
                NormalizeVector(PointVector);
                CrossProduct(PointVector,SubSolarVector,RotationAxis);
                if RefPtReadoutMode=InverseShadowLengthRefPtMode then
                  AngleStep := +0.01 // radians
                else
                  AngleStep := -0.01; // radians

                LineLengthSqrd := 0;
                PointZ := 0; // need to set for later conditional test

                while (LineLengthSqrd<MaxPixelLengthSqrd) and (PointZ>=0) do
                  begin
                    RotateVector(PointVector,AngleStep,RotationAxis);
                    PointX := DotProduct(PointVector,XPrime_UnitVector);
                    PointY := DotProduct(PointVector,YPrime_UnitVector);
                    PointZ := DotProduct(PointVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere
                    if PointZ>=0 then LineToDataPoint(PointX,PointY);
                    LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
                  end;
              end;

            PlotDataPoint(RefX,RefY,3,clGreen,clGreen);
          end;

      end;
  end;

begin  {TLTVT_Form.SetRefPt_RightClickMenuItemClick}
  case RefPtReadoutMode of
  ShadowLengthRefPtMode, InverseShadowLengthRefPtMode, RayHeightsRefPtMode :
    begin
      if UserPhoto_RadioButton.Checked then
        begin
          UserPhotoSubSolarLon := DegToRad(ExtendedValue(UserPhotoData.SubSolLon));
          UserPhotoSubSolarLat := DegToRad(ExtendedValue(UserPhotoData.SubSolLat));
          ComputeDistanceAndBearing(SubSolarPoint.Longitude, SubSolarPoint.Latitude,
            UserPhotoSubSolarLon, UserPhotoSubSolarLat, SubSolarErrorDistance, SubSolarErrorBearing);
          if SubSolarErrorDistance>DegToRad(0.01) then
            case MessageDlg('Shadow measurements require an accurate SubSolar Point--'+CR+
                '    redraw with value in photo data?',mtConfirmation,[mbYes, mbNo, mbCancel],0) of
               mrYes :
                 begin
                   SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
                   SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
                   DrawTexture_Button.Click;
                 end;
               mrCancel : Exit;
               end;
        end;
    end;
  end;

  with Image1 do
    begin
      RefX := XValue(LastMouseClickPosition.X);
      RefY := YValue(LastMouseClickPosition.Y);
      if not ConvertXYtoLonLat(RefX,RefY,RefPtLon,RefPtLat) then
        begin
          ShowMessage('The mouse click is not on the visible lunar disk!');
          Exit;
        end;
      DrawCross(LastMouseClickPosition.X,LastMouseClickPosition.Y,DotSize+1,ReferencePointColor);
//      PlotDataPoint(RefX,RefY,3,clLime,clLime);
    end;

  ComputeDistanceAndBearing(RefPtLon,RefPtLat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,RefPtSunAngle,RefPtSunBearing);
  RefPtSunAngle := Pi/2 - RefPtSunAngle;

  case RefPtReadoutMode of
    ShadowLengthRefPtMode, InverseShadowLengthRefPtMode, RayHeightsRefPtMode :
      DrawLineInShadowDirection
    else
      RefPtReadoutMode := DistanceAndBearingRefPtMode;
    end;

end;   {TLTVT_Form.SetRefPt_RightClickMenuItemClick}

procedure TLTVT_Form.NearestDotToReferencePoint_RightClickMenuItemClick(Sender: TObject);
var
  ClosestDot : Integer;
  CraterVector : TVector;
begin
  if FindClosestDot(ClosestDot) then with CraterInfo[ClosestDot].CraterData do
    begin
      RefPtLon := Lon;
      RefPtLat := Lat;
      PolarToVector(RefPtLon,RefPtLat,1,CraterVector);
      RefX := DotProduct(CraterVector,XPrime_UnitVector);
      RefY := DotProduct(CraterVector,YPrime_UnitVector);
      ComputeDistanceAndBearing(RefPtLon,RefPtLat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,RefPtSunAngle,RefPtSunBearing);
      RefPtSunAngle := Pi/2 - RefPtSunAngle;

      MarkXY(RefX,RefY,ReferencePointColor);
    end
  else
    ShowMessage('Unable to find a dot');
end;

procedure TLTVT_Form.Recordshadowmeasurement_RightClickMenuItemClick(Sender: TObject);
var
  PlotVector : TVector;
  AngleFromCenter, PlotX, PlotY : Extended;
  PlotXPix, PlotYPix : Integer;
  ShadowFile : TextFile;
  ShadowStart, ShadowEnd : TPolarCoordinates;
begin
// put mark at shadow measurement point
  MarkXY(CurrentMouseX,CurrentMouseY,ReferencePointColor);

// also mark projection of measurement point onto constant radius sphere
  PlotVector := ShadowTipVector;
  if VectorModSqr(PlotVector)>0 then NormalizeVector(PlotVector);

  if SnapShadowPointsToPlanView and UserPhoto_RadioButton.Checked then with Image1 do
    begin
      PlotX := DotProduct(PlotVector,XPrime_UnitVector);
      PlotY := DotProduct(PlotVector,YPrime_UnitVector);
      MarkXY(PlotX,PlotY,ReferencePointColor);

      PlotXPix := XPix(PlotX);
      PlotYPix := YPix(PlotY);
    end
  else
    begin
      PlotXPix := LastMouseClickPosition.X;
      PlotYPix := LastMouseClickPosition.Y;
    end;

  with Image1 do with Canvas do
    begin
      TextOut(PlotXPix+Corrected_LabelXPix_Offset,
        PlotYPix-Corrected_LabelYPix_Offset,Format('%0.0f m',[CurrentElevationDifference_m]));
    end;

  if FileExists(ShadowProfileFilename) and (VectorMagnitude(ShadowProfileCenterVector)>0) then
    begin
      ShadowStart := VectorToPolar(RefPtVector);
      ShadowEnd   := VectorToPolar(ShadowTipVector);
      AngleFromCenter := ArcCos(DotProduct(PlotVector,ShadowProfileCenterVector));
      AssignFile(ShadowFile, ShadowProfileFilename);
      Append(ShadowFile);
      Writeln(ShadowFile,Format('%0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %s',
        [AngleFromCenter*MoonRadius,      CurrentElevationDifference_m/1000,
         ShadowStart.Longitude/OneDegree, ShadowStart.Latitude/OneDegree,
         ShadowEnd.Longitude/OneDegree,   ShadowEnd.Latitude/OneDegree,
         ExtractFileName(TextureFilename)]));
      CloseFile(ShadowFile);
    end;

end;

function TLTVT_Form.BooleanToYesNo(const BooleanState: boolean): string;
  begin
    if BooleanState then
      Result := 'yes'
    else
      Result := 'no';
  end;

procedure TLTVT_Form.SaveImage_MainMenuItemClick(Sender: TObject);
begin  {TLTVT_Form.SaveImage_MainMenuItemClick}
  SaveImage_Button.Click;
end;   {TLTVT_Form.SaveImage_MainMenuItemClick}

procedure TLTVT_Form.SaveImage_ButtonClick(Sender: TObject);
var
  JPEG_Image : TJPEGImage;
  LabeledImage : TBitMap;
  ImageStartRow, TextStartRow : Integer;
  CenterLon, CenterLat : Extended;
  DateTimeString, OutString, DesiredExtension, TextureID,
  DEM_ShadowMode : String;
//  Answer : Word;
begin
  SavePictureDialog1.FileName := ProposedFilename;

  if SavePictureDialog1.Execute then
    begin
      LabeledImage := TBitmap.Create;
      if AnnotateSavedImages then
        begin
          if ImageManual and not((DrawingMode=EarthView) or (OrientationMode=Equatorial) or (OrientationMode=AltAz)) then
            ImageStartRow := 45
          else
            ImageStartRow := 60;
          LabeledImage.Height := Image1.Height + ImageStartRow;
          LabeledImage.Width := Image1.Width;
          with LabeledImage.Canvas do
            begin
              Draw(0,30,Image1.Picture.Graphic);
    //          ShowMessage('The text height is '+IntToStr(Font.Height));
              Font.Color := SavedImageUpperLabelsColor;
              if DrawingMode=EarthView then
                begin
                      TextOut(0,1,Format(' Sub-solar Pt = %s/%s  Center (Sub-Lunar Pt) = %s/%s  Zoom = %0.3f',
                        [LongitudeString(RadToDeg(ImageSubSolLon),3), LatitudeString(RadToDeg(ImageSubSolLat),3),
                         LongitudeString(RadToDeg(ImageSubObsLon),3), LatitudeString(RadToDeg(ImageSubObsLat),3),
                         1.0]));
                  OutString := ' Vertical axis : central meridian';
                end
              else
                begin
                  if not ConvertXYtoLonLat(ImageCenterX,ImageCenterY,CenterLon,CenterLat) then
                    TextOut(0,1,Format(' Sub-solar Pt = %s/%s  Sub-Earth Pt = %s/%s  XY-Center = (%0.4f,%0.4f)  Zoom = %0.3f',
                      [LongitudeString(RadToDeg(ImageSubSolLon),3), LatitudeString(RadToDeg(ImageSubSolLat),3),
                       LongitudeString(RadToDeg(ImageSubObsLon),3), LatitudeString(RadToDeg(ImageSubObsLat),3),
                       ImageCenterX, ImageCenterY, ImageZoom]))
                  else
                    begin
                      TextOut(0,1,Format(' Sub-solar Pt = %s/%s  Sub-Earth Pt = %s/%s  Center = %s/%s  Zoom = %0.3f',
                        [LongitudeString(RadToDeg(ImageSubSolLon),3), LatitudeString(RadToDeg(ImageSubSolLat),3),
                         LongitudeString(RadToDeg(ImageSubObsLon),3), LatitudeString(RadToDeg(ImageSubObsLat),3),
                         LongitudeString(RadToDeg(CenterLon),3), LatitudeString(RadToDeg(CenterLat),3), ImageZoom]));
                    end;

                  OutString := ' Vertical axis : ';
                  case OrientationMode of
                    Cartographic :
                      OutString := OutString + 'central meridian';
                    LineOfCusps :
                      OutString := OutString + 'line of cusps   ';
                    Equatorial :
                      OutString := OutString + 'celestial north ';
                    AltAz :
                      OutString := OutString + 'local zenith    ';
                    else
                      OutString := OutString + 'unknown         ';
                    end; {case}


                  if InvertLR and InvertUD then
                    OutString := OutString + '    Inverted left-right and up-down'
                  else if InvertLR then
                    OutString := OutString + '    Inverted left-right'
                  else if InvertUD then
                    OutString := OutString + '    Inverted up-down';

                  if ManualRotationDegrees<>0 then
                    OutString := OutString + Format('    Additional CW rotation: %0.3f deg',[ManualRotationDegrees]);
                end;

                TextOut(0,16,OutString);

                OutString := '      LTVT v'+ProgramVersion+' ';
                TextOut(LabeledImage.Width-TextWidth(OutString)-2,16,OutString);

                Font.Color := SavedImageLowerLabelsColor;

                if ImageIncludesCastShadows then
                  DEM_ShadowMode := 'with cast shadows'
                else
                  DEM_ShadowMode := 'without cast shadows';

                if DemGridStepMultiplier<>1 then
                  DEM_ShadowMode := Format('%0.2f grid steps, ',[DemGridStepMultiplier]) + DEM_ShadowMode;

                case DrawingMode of
                  DEM_2D: TextureID := '2D DEM simulation ('+DEM_ShadowMode+'): ';
                  DEM_3D: TextureID := '3D DEM simulation ('+DEM_ShadowMode+'): ';
                else
                  TextureID := 'Texture file: ';
                end;
                
                TextureID := TextureID+ExtractFileName(TextureFilename);
                if (DrawingMode<>DotMode) and (ImageGamma<>1) then TextureID := TextureID+Format('    (Gamma = %0.2f)',[1/ImageGamma]);

                if ImageManual and not((DrawingMode=EarthView) or (OrientationMode=Equatorial) or (OrientationMode=AltAz)) then
                  begin
                    TextStartRow := LabeledImage.Height - 15;
                    TextOut(0,TextStartRow,TextureID);
                  end
                else
                  begin
                    TextStartRow := LabeledImage.Height - 30;
                    TextOut(0,TextStartRow,TextureID);

                    DateTimeString := DateToStr(ImageDate)+' at  '+TimeToStr(ImageTime)+' UT';
                    TextStartRow := LabeledImage.Height - 15;
                    if DrawingMode=EarthView then
                      TextOut(0,TextStartRow,Format('Earth viewed from center of Moon on %s',[DateTimeString]))
                    else
                      begin
                        if ImageGeocentric then
                          TextOut(0,TextStartRow,'Geocentric computation for: '+DateTimeString)
                        else
                          begin
                            if ImageManual then
                              begin
                                if OrientationMode=Equatorial then
                                  TextOut(0,TextStartRow,Format('Celestial north polar direction for %s',[DateTimeString]))
                                else
                                  TextOut(0,TextStartRow,Format('Zenith direction for an observer on Earth at %s/%s and %0.0f m elev on %s',
                                    [LongitudeString(ImageObsLon,3),LatitudeString(ImageObsLat,3),ImageObsElev,DateTimeString]));
                              end
                            else
                              TextOut(0,TextStartRow,Format('This view is predicted for an observer on Earth at %s/%s and %0.0f m elev on ',
                                [LongitudeString(ImageObsLon,3),LatitudeString(ImageObsLat,3),ImageObsElev])+DateTimeString);
                          end;
                      end;
                  end;
                end;
              end
            else  // no labels
              begin
                LabeledImage.Height := Image1.Height;
                LabeledImage.Width := Image1.Width;
                LabeledImage.Canvas.Draw(0,0,Image1.Picture.Graphic);
              end;

        DesiredExtension := UpperCase(ExtractFileExt(SavePictureDialog1.FileName));

        if (DesiredExtension='.JPG') or (DesiredExtension='.JPEG') then
          begin
            JPEG_Image := TJPEGImage.Create;
            try
    {          JPEG_Image.PixelFormat := jf24Bit; }    {this is supposed to be true by default}
    {          JPEG_Image.Performance := jpBestQuality; } {this is supposed to apply only to playback}
    {          JPEG_Image.ProgressiveEncoding := False; } {makes no difference}
              JPEG_Image.CompressionQuality := 90;  {highest possible is 100;  90 makes files half the size but indistinguishable}
              JPEG_Image.Assign(LabeledImage);
              JPEG_Image.SaveToFile(SavePictureDialog1.FileName);
            finally
              JPEG_Image.Free;
            end;
          end
        else {.bmp}
          begin
            SavePictureDialog1.FileName := ChangeFileExt(SavePictureDialog1.FileName,'.bmp');
            LabeledImage.SaveToFile(SavePictureDialog1.FileName);
          end;
        LabeledImage.Free;
    end;

end;

procedure TLTVT_Form.FindAndLoadJPL_File(const TrialFilename : string);
{attempts to find JPL file -- suggests help file if there is a problem}
  const
    LastDirectory : string = '';
  var
    JPL_OpenDialog : TOpenDialog;
    CorrectFilename, ExpectedFilename, ExpectedPath, ExpectedExtension : string;
  begin
    CorrectFilename := TrialFilename;
//    ShowMessage('Looking for "'+TrialFilename+'"');

    if FileExists(CorrectFilename) then
      begin {check if requested file exists}
        LoadJPL_File(CorrectFilename);
        Exit;
      end;

    ExpectedFilename := ExtractFileName(TrialFilename);
    ExpectedPath := ExtractFilePath(TrialFilename);
    if ExpectedPath='' then ExpectedPath := '.\';

    CorrectFilename := ExpectedPath+ExpectedFilename;

    if FileExists(CorrectFilename) then
      begin {check if requested file exists in current directory}
        LoadJPL_File(CorrectFilename);
//        ShowMessage(CorrectFilename+' found in current directory');
        Exit;
      end;

    if LastDirectory<>'' then
      begin
        CorrectFilename := LastDirectory+ExpectedFilename;

        if FileExists(CorrectFilename) then
          begin {check if requested file exists in directory from which last file was loaded}
            LoadJPL_File(CorrectFilename);
//            ShowMessage(ExpectedFilename+' found in last directory');
            Exit;
          end;

       end;

    if MessageDlg('You need to locate a JPL ephemeris file before LTVT can compute the geometry'+CR
                    +'   Do you want help with this procedure?',
      mtWarning,[mbYes,mbNo],0)=mrYes then
        begin
          HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/EphemerisFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
        end;

    OldFilename := JPL_FilePath;
    JPL_OpenDialog := TOpenDialog.Create(nil);
    try
      with JPL_OpenDialog do
        begin
          SetSubComponent(True);
          Title := 'JPL ephemeris file needed: '+ExpectedFilename;
          FileName := ExpectedFilename;
          InitialDir := ExpectedPath;
          ExpectedExtension := ExtractFileExt(TrialFilename);
          Filter := '*'+ExpectedExtension+'|*'+ExpectedExtension+'|All Files|*.*';
          Options := Options + [ofNoChangeDir];
          if Execute and FileExists(FileName) then
            begin
              CorrectFilename := FileName;
              LastDirectory := ExtractFilePath(Filename);
              LoadJPL_File(CorrectFilename);
              JPL_Filename := ExtractFileName(Filename);
              JPL_FilePath := ExtractFilePath(Filename);
            end
          else
            begin
              CorrectFilename := TrialFilename;
              ShowMessage('Unable to find JPL ephemeris file: "'+ExpectedFilename+'"');
            end;
        end;
    finally
      JPL_OpenDialog.Free;
    end;

//    ShowMessage(JPL_FilePath+' vs. '+OldFilename);

    if JPL_FilePath<>OldFilename then FileSettingsChanged := True;

  end;


procedure TLTVT_Form.HelpContents_MenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TitlePage.htm'),HH_DISPLAY_TOPIC, 0);
end;

procedure TLTVT_Form.FindJPLfile_MenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/EphemerisFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
end;

procedure TLTVT_Form.Changetexturefile_MenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
end;

procedure TLTVT_Form.Goto_RightClickMenuItemClick(Sender: TObject);
var
 MouseOrthoX, MouseOrthoY, MouseLat, MouseLon : extended;
begin
  with Image1 do
    begin
      MouseOrthoX := XValue(LastMouseClickPosition.X);
      MouseOrthoY := YValue(LastMouseClickPosition.Y);
    end;

  with H_Terminator_Goto_Form do
    begin
      XY_RadioButton.Checked := True;
      if (DrawingMode=Dem_3D) then with SurfaceData[LastMouseClickPosition.X,LastMouseClickPosition.Y] do
        begin
          if HeightDev_km<>SurfaceData_NoDataValue then
            begin
              LonLat_RadioButton.Checked := True;
              SetToLon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(Lon_rad)]);
              SetToLat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(Lat_rad)]);
              SetToRadius_TLabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[MoonRadius+HeightDev_km]);
            end;
        end
      else
        if ConvertXYtoLonLat(MouseOrthoX,MouseOrthoY,MouseLon,MouseLat) then
          begin
            LonLat_RadioButton.Checked := True;
            SetToLon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLon)]);
            SetToLat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLat)]);
          end;
      CenterX_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[MouseOrthoX]);
      CenterY_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[MouseOrthoY]);
    end;

  GoTo_MainMenuItemClick(Sender);
end;

procedure TLTVT_Form.DrawCircle_MainMenuItemClick(Sender: TObject);
begin
  if DrawingMode=EarthView then
    begin
      ShowMessage('This tool is not intended for use with Earth images');
      Exit;
    end;

  CircleDrawing_Form.ShowModal;
end;

procedure TLTVT_Form.DrawCircle_RightClickMenuItemClick(Sender: TObject);
var
 MouseOrthoX, MouseOrthoY, MouseLat, MouseLon : extended;
begin
  with Image1 do
    begin
      MouseOrthoX := XValue(LastMouseClickPosition.X);
      MouseOrthoY := YValue(LastMouseClickPosition.Y);
    end;

  with CircleDrawing_Form do
    begin
      if ConvertXYtoLonLat(MouseOrthoX,MouseOrthoY,MouseLon,MouseLat) then
        begin
          LonDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLon)]);
          LatDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLat)]);
        end;
    end;

  DrawCircle_MainMenuItemClick(Sender);
end;

function TLTVT_Form.LabelString(const FeatureToLabel : TCraterInfo;
  const IncludeName, IncludeParent, IncludeSize, IncludeUnits, ShowMore : Boolean) : String;
{returns string used for adding labels to map}
var
  SpacePos, ErrorCode : Integer;
  EVP : Extended;
  NameText, UnitsText, SizeText, FT_Code, NumericValue : string;
begin
  with FeatureToLabel.CraterData do
    begin
      NameText := Trim(Name);
      if NameText='' then NameText := AdditionalInfo1;
      if NameText='' then NameText := 'Name unknown';

      FT_Code := USGS_Code;

      if (FT_Code='CN') and (Length(AdditionalInfo2)>1) then FT_Code := 'CN5';

      if (not IncludeParent) and ((FT_Code='SF') or (FT_Code='GD') or (FT_Code='CD')) then
        begin // extract final suffix part of feature name
          SpacePos := Length(NameText);
          while (SpacePos>0) and (NameText[SpacePos]<>' ') do Dec(SpacePos);
          if (SpacePos>0) and (NameText[SpacePos]=' ') then NameText := Substring(NameText,SpacePos+1,MaxInt);
          if (Length(NameText)>0) and (NameText[Length(NameText)]=']') then NameText := '['+NameText; // complete bracket around discontinued names
        end;


      if (FT_Code='CN') or (FT_Code='CN5') then
        begin
          // "NumericValue" is actually Radial Distance
          UnitsText := ' km elev';
        end
      else if FT_Code='AT' then
        begin
          // "NumericValue" is actually Revolution Number
          UnitsText := 'Rev. ';
        end
      else
        begin
          UnitsText := ' km';
        end;

      NumericValue := NumericData;

      if ShowMore and (FT_Code='CN5') and (AdditionalInfo2<>'999999') then
        begin
          Val(AdditionalInfo2,EVP,ErrorCode);
          if ErrorCode=0 then
            NumericValue :=  NumericValue + Format(' +/- %0.3f',[EVP/1000]);
        end;

      if IncludeSize then
        begin
          if IncludeUnits and (NumericValue<>'') then
            begin
              if FT_Code='AT' then
                SizeText := UnitsText+NumericValue
              else
                SizeText := NumericValue+UnitsText;
            end
          else
            SizeText := NumericValue;

          if IncludeName then
            begin
              if SizeText<>'' then
                Result := NameText+' ('+SizeText+')'
              else
                Result := NameText;
            end
          else
            Result := SizeText;
        end
      else
        Result := NameText;

     if ShowMore then
       begin
         if FT_Code='CN' then
           Result := Result + ' Set '+AdditionalInfo2
         else if FT_Code='CN5' then
           Result := Result + ' Set '+AdditionalInfo1;
       end;
    end;
end;

function TLTVT_Form.UpperCaseParentName(const FeatureName, FT_Code : String) : String;
{attempts to extract uppercase version of parent part of FeatureName based on USGS Feature Type code; returns FeatureName if unsuccessful}
var
  TrialName, USGS_Code : String;
  SpacePos : Integer;
begin
  Result := FeatureName;

  TrialName := UpperCase(Trim(FeatureName));
  USGS_Code := UpperCase(FT_Code);

  if USGS_Code='LF' then
    Exit // don't process landing site names
  else if USGS_Code='AA' then
    // do nothing : Trial Name = parent name
  else if USGS_Code='SF' then
    begin
      SpacePos := Length(TrialName);
      while (SpacePos>1) and (TrialName[SpacePos]<>' ') do Dec(SpacePos);
      if TrialName[SpacePos]<>' ' then Exit;   // not a satellite feature name
      TrialName := Trim(Substring(TrialName,1,SpacePos-1));
    end
  else // assume name is a one word descriptor followed by parent name plus possible Greek suffix
    begin
      SpacePos := Pos(' ',TrialName);
      if SpacePos=0 then Exit;
      TrialName := Substring(TrialName,SpacePos+1,MaxInt);

      SpacePos := Pos('DELTA',TrialName);   // possible suffix for Mons
      if SpacePos<>0 then TrialName := Trim(Substring(TrialName,1,SpacePos-1));

      SpacePos := Pos('GAMMA',TrialName);
      if SpacePos<>0 then TrialName := Trim(Substring(TrialName,1,SpacePos-1));

      TrialName := Trim(TrialName);
    end;

  if TrialName<>'' then Result := TrialName;

end;

procedure TLTVT_Form.LabelDot(const DotInfo : TCraterInfo);
var
  LabelXPix, LabelYPix, PrimaryIndex,
  FontHeight, FontWidth, RadialPixels : Integer;
  FeatureVector, ParentVector, DirectionVector : TVector;
  DiffSqrd, Diff, XMultiplier, YMultiplier : Extended;

function ParentIndex(const FeatureName : String) : Integer;
// returns index of feature with same primary name in PrimaryFeatureList array
  var
    ParentFeatureName : String;
    I : Integer;
    NameFound : Boolean;
  begin {ParentIndex}
    Result := -999;

    ParentFeatureName := UpperCaseParentName(FeatureName,'SF');
    if ParentFeatureName=FeatureName then Exit;

    NameFound := False;

    I := -1;
    while (I<(Length(PrimaryCraterList)-2)) and not NameFound do
      begin
        Inc(I);
        NameFound := ParentFeatureName=UpperCase(PrimaryCraterList[I].Name);
      end;

    if NameFound then
      begin
        Result := I;
//        ShowMessage(FeatureName+' --> '+PrimaryCraterList[Result].Name);
      end
    else
      begin
//        ShowMessage('Primary not found for "'+FeatureName+'"');
      end;
  end;  {ParentIndex}

begin {LabelDot}
  with DotInfo do
    begin
      LabelXPix := Dot_X+Corrected_LabelXPix_Offset;
      LabelYPix := Dot_Y-Corrected_LabelYPix_Offset;
    end;

  with DotInfo.CraterData do
    begin
      if (not FullCraterNames) and RadialDotOffset and (Length(PrimaryCraterList)>0)
        and (USGS_Code='SF') then
        begin
          XMultiplier := 0;  // if parent can't be located plot name over dot
          YMultiplier := 0;

//          ShowMessage(Name);
//          PrimaryIndex := ParentIndex('Seeliger A');
          PrimaryIndex := ParentIndex(Name);
          if PrimaryIndex<>-999 then
            begin

              PolarToVector(Lon,Lat,1,FeatureVector);
              with PrimaryCraterList[PrimaryIndex] do PolarToVector(Lon,Lat,1,ParentVector);
              VectorDifference(ParentVector,FeatureVector,DirectionVector);   // Vector from Feature to Parent

              XMultiplier := DotProduct(DirectionVector,XPrime_UnitVector);  // Project into X-Y screen plane
              YMultiplier := DotProduct(DirectionVector,YPrime_UnitVector);

//              ShowMessage(Format('%s -> %s  %0.2f %0.2f',[Name,PrimaryCraterList[PrimaryIndex].Name, Lon,Lat]));

              DiffSqrd := Sqr(XMultiplier) + Sqr(YMultiplier);
              if DiffSqrd>0 then
                begin
                  Diff := Sqrt(DiffSqrd);
                  XMultiplier := XMultiplier/Diff;     // normalize to 0..1
                  YMultiplier := YMultiplier/Diff;
                end;

              if InvertLR then XMultiplier := -XMultiplier;
              If InvertUD then YMultiplier := -YMultiplier;

            end;

          FontHeight := Abs(Image1.Canvas.TextHeight('O'));
          FontWidth  := Abs(Image1.Canvas.TextWidth('O'));
//          ShowMessage('Font height = '+IntToStr(FontHeight));
          RadialPixels := (FontHeight div 2) + LabelXPix_Offset;

          LabelXPix := DotInfo.Dot_X + 2 - (FontWidth  div 2) + Round(XMultiplier*RadialPixels);
          LabelYPix := DotInfo.Dot_Y - 0 - (FontHeight div 2) - Round(YMultiplier*RadialPixels);

        end;

      Image1.Canvas.TextOut(LabelXPix,LabelYPix,
        LabelString(DotInfo,IncludeFeatureName,FullCraterNames,IncludeFeatureSize,IncludeUnits,False));
    end;
end;  {LabelDot}

procedure TLTVT_Form.LabelDots_ButtonClick(Sender: TObject);
var
  i : Integer;
begin
  if Length(CraterInfo)=0 then
    begin
      ShowMessage('This function labels all currently visible dots -- '+CR
                 +'   but there are no dots in the current view!');
    end
  else
    begin
      Screen.Cursor := crHourGlass;
      for i := 0 to (Length(CraterInfo)-1) do LabelDot(CraterInfo[i]);
      Screen.Cursor := DefaultCursor;
    end;
end;

function TLTVT_Form.FindClosestDot(var DotIndex : Integer) : Boolean;
{returns index in CraterInfo[] of dot closest to last mouse click}
var
  i, MinI, RSqrd, MinRsqrd : integer;

begin {FindClosestDot}
  if Length(CraterInfo)=0 then
    Result := False
  else
    begin
      MinI := 0;
      MinRsqrd := MaxInt;

      for i := 0 to (Length(CraterInfo)-1) do with CraterInfo[i] do
        begin
          RSqrd := Sqr(LastMouseClickPosition.X - Dot_X) + Sqr(LastMouseClickPosition.Y - Dot_Y);
          if RSqrd<MinRsqrd then
            begin
              MinRsqrd := RSqrd;
              MinI := i;
            end;
        end;

      DotIndex := MinI;
      Result := True;
    end;
end;  {FindClosestDot}

procedure TLTVT_Form.LabelNearestDot_RightClickMenuItemClick(Sender: TObject);
var
  ClosestDot : integer;
begin {TLTVT_Form.LabelNearestDot_RightClickMenuItemClick}
  if FindClosestDot(ClosestDot) then
    LabelDot(CraterInfo[ClosestDot])
  else
    ShowMessage('There are no dots to label');
end;  {TLTVT_Form.LabelNearestDot_RightClickMenuItemClick}

procedure TLTVT_Form.AddLabel_RightClickMenuItemClick(Sender: TObject);
var
  UserLabel : string;
begin
  UserLabel := InputBox('Add Label at Mouse Position',
    'Enter the text for the label you wish to add --'+CR
   +'If you want a special style go to Tools...Change dot/label prefs... before adding it.' ,'');
  if Trim(UserLabel)<>'' then with Image1.Canvas do
    begin
      TextOut(LastMouseClickPosition.X+Corrected_LabelXPix_Offset,
        LastMouseClickPosition.Y-Corrected_LabelYPix_Offset,UserLabel);
    end;
end;

function TLTVT_Form.PositionInCraterInfo(const ScreenX, ScreenY : integer) : boolean;
{tests if there is already a known dot at the stated pixel position}
var
  i : integer;
  ItemFound : boolean;
begin
  ItemFound := false;
  i := 0;
  while (i<Length(CraterInfo)) and not ItemFound do
    begin
      if (CraterInfo[i].Dot_X=ScreenX) and (CraterInfo[i].Dot_Y=ScreenY) then ItemFound := True;
      Inc(i);
    end;

  Result := ItemFound;
end;

function TLTVT_Form.FullFilename(const ShortName : string): string;
  begin
    if ExtractFilePath(ShortName)='' then
      Result := BasePath+ShortName
    else
      Result := ShortName;
  end;

procedure TLTVT_Form.Predict_ButtonClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat, AngleToSun, SunAzimuth : extended;
begin
  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if not EphemerisFileLoaded then
    ShowMessage('The Moon Event Predictor cannot be used without a JPL ephemeris file')
  else
    with MoonEventPredictor_Form do
      begin
        Date_DateTimePicker.DateTime := LTVT_Form.Date_DateTimePicker.DateTime;
        Time_DateTimePicker.DateTime := LTVT_Form.Time_DateTimePicker.DateTime;

        if GeocentricSubEarthMode then
          begin
            GeocentricObserver_CheckBox.Checked := True;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := Format('%0.0f',[-REarth]);;
          end
        else
          begin
            GeocentricObserver_CheckBox.Checked := False;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
          end;

        Colongitude_LabeledNumericEdit.NumericEdit.Text := Colongitude_Label.Caption;
        SolarLatitude_LabeledNumericEdit.NumericEdit.Text := SubSol_Lat_LabeledNumericEdit.NumericEdit.Text;

        if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
          begin
            Crater_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
            Crater_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
            ComputeDistanceAndBearing(ImageCenterLon, ImageCenterLat,
              SubSol_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree,
              SubSol_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree,
              AngleToSun, SunAzimuth);

            SunAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(PiByTwo - AngleToSun)]);
            SunAzimuth_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(SunAzimuth)]);
          end;

//        CalculateCircumstances_Button.Click;

        MoonEventPredictor_Form.Show;
      end;
end;

procedure TLTVT_Form.TabulateLibrations_MainMenuItemClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat : extended;
begin
  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if not EphemerisFileLoaded then
    ShowMessage('The Libration Tabulator cannot be used without a JPL ephemeris file')
  else
    with LibrationTabulator_Form do
      begin
        Date_DateTimePicker.DateTime := LTVT_Form.Date_DateTimePicker.DateTime;
        Time_DateTimePicker.DateTime := LTVT_Form.Time_DateTimePicker.DateTime;

        if GeocentricSubEarthMode then
          begin
            GeocentricObserver_CheckBox.Checked := True;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := Format('%0.0f',[-REarth]);;
          end
        else
          begin
            GeocentricObserver_CheckBox.Checked := False;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
          end;

        if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
          begin
            Crater_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
            Crater_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
          end;

        LibrationTabulator_Form.Show;
      end;
end;

procedure TLTVT_Form.SearchUncalibratedPhotos_MainMenuItemClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat : extended;
begin

  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if not EphemerisFileLoaded then
    ShowMessage('The PhotoSession Search requires a JPL ephemeris file')
  else
    with PhotosessionSearch_Form do
      begin
        PSS_JPL_Filename := FullFilename(JPL_Filename);
        PSS_JPL_Path := JPL_FilePath;
        if PhotoSessionsFilename='' then PhotoSessionsFilename := FullFilename(NormalPhotoSessionsFilename);

        Date_DateTimePicker.DateTime := LTVT_Form.Date_DateTimePicker.DateTime;
        Time_DateTimePicker.DateTime := LTVT_Form.Time_DateTimePicker.DateTime;
        if GeocentricSubEarthMode then
          begin
            GeocentricObserver_CheckBox.Checked := True;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := Format('%0.0f',[-REarth]);;
          end
        else
          begin
            GeocentricObserver_CheckBox.Checked := False;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
          end;
        Colongitude_LabeledNumericEdit.NumericEdit.Text := Colongitude_Label.Caption;
        SolarLatitude_LabeledNumericEdit.NumericEdit.Text := SubSol_Lat_LabeledNumericEdit.NumericEdit.Text;

        if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
          begin
            Crater_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
            Crater_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
          end;

        CalculateCircumstances_Button.Click;

        PhotosessionSearch_Form.Show;
      end;
end;

procedure TLTVT_Form.ChangeDemOptions_MainMenuItemClick(Sender: TObject);
begin
  WriteDemOptionsToForm;
  DEM_Options_Form.ChangeOptions := False;
  DEM_Options_Form.ShowModal;
  if DEM_Options_Form.ChangeOptions then ReadDemOptionsFromForm;
end;

procedure TLTVT_Form.SaveDemOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  IniFile.WriteString('LTVT Defaults','DEM_File',BriefName(DEM_Filename));
  IniFile.WriteString('LTVT Defaults','DEM_includes_cast_shadows',BooleanToYesNo(DemIncludesCastShadows));
  IniFile.WriteString('LTVT Defaults','DEM_cast_shadow_color',Format('$%6.6x',[DemCastShadowColor]));
//  IniFile.WriteString('LTVT Defaults','DEM_in_3D',BooleanToYesNo(DemIn3D));
  IniFile.WriteString('LTVT Defaults','DEM_multiplied_by_texture',BooleanToYesNo(MultiplyDemByTexture3));
  IniFile.WriteString('LTVT Defaults','Display_DEM_computation_times',BooleanToYesNo(DisplayDemComputationTimes));
  IniFile.WriteString('LTVT Defaults','Stay_in_DEM_mode_on_refresh',BooleanToYesNo(StayInDemModeOnRefresh));
  IniFile.WriteString('LTVT Defaults','Rigorous_DEM_normals',BooleanToYesNo(RigorousDemNormals));
  IniFile.WriteString('LTVT Defaults','Draw_terminator_on_DEM',BooleanToYesNo(DrawTerminatorOnDem));
  IniFile.WriteFloat('LTVT Defaults','DEM_grid_step_multiplier',DemGridStepMultiplier);
  IniFile.Free;
end;

procedure TLTVT_Form.RestoreDemOptions;
var
  IniFile : TIniFile;
  TempDEMName : String;
begin
  IniFile := TIniFile.Create(IniFileName);

  TempDEMName := DEM_Filename;
  DEM_Filename := FullFilename(IniFile.ReadString('LTVT Defaults','DEM_File','LALT_GGT_MAP.IMG'));
  if TempDEMName<>DEM_Filename then with DEM_data do
    begin
      Clear;
      FileOpen := False;
    end;

  DemIncludesCastShadows := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','DEM_includes_cast_shadows','yes'));
  try
    DemCastShadowColor := StrToInt(IniFile.ReadString('LTVT Defaults','DEM_cast_shadow_color',IntToStr(clBlack)));
  except
    DemCastShadowColor := clBlack;
  end;
//  DemIn3D := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','DEM_in_3D','no'));
  MultiplyDemByTexture3 := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','DEM_multiplied_by_texture','no'));
  DisplayDemComputationTimes := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Display_DEM_computation_times','no'));
  StayInDemModeOnRefresh := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Stay_in_DEM_mode_on_refresh','no'));
  RigorousDemNormals := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Rigorous_DEM_normals','yes'));
  DrawTerminatorOnDem := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Draw_terminator_on_DEM','no'));
  DemGridStepMultiplier := IniFile.ReadFloat('LTVT Defaults','DEM_grid_step_multiplier',1);

  IniFile.Free;
end;

procedure TLTVT_Form.WriteDemOptionsToForm;
begin
  with DEM_Options_Form do
    begin
      TempDEMFilename := DEM_Filename;
      ComputeCastShadows_CheckBox.Checked := DemIncludesCastShadows;
      CastShadow_ColorBox.Selected := DemCastShadowColor;
//      ThreeD_CheckBox.Checked := DemIn3D;
      MultiplyByAlbedoCheckBox.Checked := MultiplyDemByTexture3;
      DisplayComputationTimes_CheckBox.Checked := DisplayDemComputationTimes;
      RecalculateDEMonRecenter_CheckBox.Checked := StayInDemModeOnRefresh;
      RigorousNormals_CheckBox.Checked := RigorousDemNormals;
      DrawTerminatorOnDEM_CheckBox.Checked := DrawTerminatorOnDem;
      GridStepMultiplier_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[DemGridStepMultiplier]);
    end;
end;

procedure TLTVT_Form.ReadDemOptionsFromForm;
begin
  with DEM_Options_Form do
    begin
      if TempDEMFilename<>DEM_Filename then
        begin
          DEM_data.Clear;
          DEM_data.FileOpen := False;
          DEM_Filename := TempDEMFilename;
//          FileSettingsChanged := True;  //  DEM file not saved/restored with others
        end;

      DemIncludesCastShadows := ComputeCastShadows_CheckBox.Checked;
      DemCastShadowColor := CastShadow_ColorBox.Selected;
//      DemIn3D := ThreeD_CheckBox.Checked;
      MultiplyDemByTexture3 := MultiplyByAlbedoCheckBox.Checked;
      DisplayDemComputationTimes := DisplayComputationTimes_CheckBox.Checked;
      StayInDemModeOnRefresh := RecalculateDEMonRecenter_CheckBox.Checked;
      RigorousDemNormals := RigorousNormals_CheckBox.Checked;
      DrawTerminatorOnDem := DrawTerminatorOnDEM_CheckBox.Checked;
      DemGridStepMultiplier := GridStepMultiplier_LabeledNumericEdit.NumericEdit.ExtendedValue;
    end;
end;

procedure TLTVT_Form.ChangeCartographicOptions_MainMenuItemClick(Sender: TObject);
begin
  WriteCartographicOptionsToForm;
  CartographicOptions_Form.ChangeOptions := False;
  CartographicOptions_Form.ShowModal;
  if CartographicOptions_Form.ChangeOptions then ReadCartographicOptionsFromForm;
end;

procedure TLTVT_Form.SaveCartographicOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  IniFile.WriteString('LTVT Defaults','Start_with_current_UT',BooleanToYesNo(StartWithCurrentUT));
//  IniFile.WriteString('LTVT Defaults','Cartographic_orientation',BooleanToYesNo(CartographicOrientation));
  case OrientationMode of
    LineOfCusps : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','LineOfCusps');
    Cartographic : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','Cartographic');
    Equatorial : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','Equatorial');
    AltAz : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','AltAz');
    end;
  IniFile.WriteString('LTVT Defaults','Invert_image_left-right',BooleanToYesNo(InvertLR));
  IniFile.WriteString('LTVT Defaults','Invert_image_up-down',BooleanToYesNo(InvertUD));
//  IniFile.WriteString('LTVT Defaults','Manual_Rotation_Angle',Format('%0.3f',[ManualRotationDegrees]));
  IniFile.WriteString('LTVT Defaults','Terminator_lines',BooleanToYesNo(IncludeTerminatorLines));
  IniFile.WriteString('LTVT Defaults','Libration_circle',BooleanToYesNo(IncludeLibrationCircle));
  IniFile.WriteString('LTVT Defaults','Libration_Circle_Color',Format('$%6.6x',[LibrationCircleColor]));
  IniFile.WriteString('LTVT Defaults','Sky_Color',Format('$%6.6x',[SkyColor]));
  IniFile.WriteString('LTVT Defaults','DotMode_SunlitColor',Format('$%6.6x',[DotModeSunlitColor]));
  IniFile.WriteString('LTVT Defaults','DotMode_ShadowedColor',Format('$%6.6x',[DotModeShadowedColor]));
  IniFile.WriteString('LTVT Defaults','NoData_Color',Format('$%6.6x',[NoDataColor]));
  IniFile.WriteInteger('LTVT Defaults','ShadowLineLength_pixels',ShadowLineLength_pixels);
  IniFile.WriteString('LTVT Defaults','SelenographicAxes_p1Angle_arcsec',p1Text);
  IniFile.WriteString('LTVT Defaults','SelenographicAxes_p2Angle_arcsec',p2Text);
  IniFile.WriteString('LTVT Defaults','SelenographicAxes_tauAngle_arcsec',tauText);
  IniFile.Free;
end;

procedure TLTVT_Form.RestoreCartographicOptions;
const
  p1_DefaultText = '-78.9316';
  p2_DefaultText = '0.2902';
  tau_DefaultText = '66.1898';
var
  IniFile : TIniFile;
  OrientationString : String;
begin
  IniFile := TIniFile.Create(IniFileName);
  StartWithCurrentUT := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Start_with_current_UT','no'));

  OrientationString := UpperCase(IniFile.ReadString('LTVT Defaults','Cartographic_orientation','Cartographic'));
// support older mode where orientation was boolean: YES = Cartographic, NO = LineOfCusps
  if (OrientationString='NO') or (OrientationString='LINEOFCUSPS') then
    OrientationMode := LineOfCusps
  else if OrientationString='EQUATORIAL' then
    OrientationMode := Equatorial
  else if OrientationString='ALTAZ' then
    OrientationMode := AltAz
  else
    OrientationMode := Cartographic;

  InvertLR := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Invert_image_left-right','no'));
  InvertUD := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Invert_image_up-down','no'));
{
  try
    ManualRotationDegrees := StrToFloat(IniFile.ReadString('LTVT Defaults','Manual_Rotation_Angle','0'));
  except
    ManualRotationDegrees := 0;
  end;
}
  IncludeLibrationCircle := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Libration_circle','yes'));
  IncludeTerminatorLines := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Terminator_lines','yes'));
  try
    LibrationCircleColor := StrToInt(IniFile.ReadString('LTVT Defaults','Libration_Circle_Color',IntToStr(clWhite)));
  except
    LibrationCircleColor := clWhite;
  end;

  try
    SkyColor := StrToInt(IniFile.ReadString('LTVT Defaults','Sky_Color',IntToStr(clNavy)));
  except
    SkyColor := clWhite;
  end;

  try  // Note: original color was  $C8C8C8 (R=G=B= 200) -- very similar to clSilver
    DotModeSunlitColor := StrToInt(IniFile.ReadString('LTVT Defaults','DotMode_SunlitColor',IntToStr(clSilver)));
  except
    DotModeSunlitColor := clSilver;
  end;

  try  // Note: original color was  $646464 (R=G=B= 100)  -- a little darker than clGray
    DotModeShadowedColor := StrToInt(IniFile.ReadString('LTVT Defaults','DotMode_ShadowedColor',IntToStr(clGray)));
  except
    DotModeShadowedColor := clGray;
  end;

  try
    NoDataColor := StrToInt(IniFile.ReadString('LTVT Defaults','NoData_Color',IntToStr(clAqua)));
  except
    NoDataColor := clAqua;
  end;

  ShadowLineLength_pixels := IniFile.ReadInteger('LTVT Defaults','ShadowLineLength_pixels',300);

// Delete these older keys if present:
  IniFile.DeleteKey('LTVT Defaults','MeanEarthAxes_p1Angle_arcsec');
  IniFile.DeleteKey('LTVT Defaults','MeanEarthAxes_p2Angle_arcsec');
  IniFile.DeleteKey('LTVT Defaults','MeanEarthAxes_tauAngle_arcsec');
  IniFile.DeleteKey('LTVT Defaults','Use_black_sky');

// Note: it is not possible to enter these into the SetObserverLocation form at this point because
// the form has not been created!

  p1Text := Trim(IniFile.ReadString('LTVT Defaults','SelenographicAxes_p1Angle_arcsec',p1_DefaultText));
  p2Text := Trim(IniFile.ReadString('LTVT Defaults','SelenographicAxes_p2Angle_arcsec',p2_DefaultText));
  tauText := Trim(IniFile.ReadString('LTVT Defaults','SelenographicAxes_tauAngle_arcsec',tau_DefaultText));

  if p1Text='' then p1Text := p1_DefaultText;
  if p2Text='' then p2Text := p2_DefaultText;
  if tauText='' then tauText := tau_DefaultText;

  MoonPosition.p1 := OneArcSecond*ExtendedValue(p1Text);
  MoonPosition.p2 := OneArcSecond*ExtendedValue(p2Text);
  MoonPosition.tau := OneArcSecond*ExtendedValue(tauText);

  AdjustToMeanEarthSystem := (MoonPosition.p1<>0) or (MoonPosition.p2<>0) or (MoonPosition.tau<>0);

  if AdjustToMeanEarthSystem then ComputeMeanEarthSystemOffsetMatix;  // replace default with that specified in ini file

  IniFile.Free;
end;

procedure TLTVT_Form.WriteCartographicOptionsToForm;
begin
  with CartographicOptions_Form do
    begin
      UseCurrentUT_CheckBox.Checked := StartWithCurrentUT;
      Cartographic_RadioButton.Checked := OrientationMode=Cartographic;
      LineOfCusps_RadioButton.Checked := OrientationMode=LineOfCusps;
      Equatorial_RadioButton.Checked := OrientationMode=Equatorial;
      AltAz_RadioButton.Checked := OrientationMode=AltAz;
      InvertLR_CheckBox.Checked := InvertLR;
      InvertUD_CheckBox.Checked := InvertUD;
//      BlackSky_CheckBox.Checked := BlackSky;
      Sky_ColorBox.Selected := SkyColor;
      DotModeSunlitColor_ColorBox.Selected := DotModeSunlitColor;
      DotModeShadowedColor_ColorBox.Selected := DotModeShadowedColor;
      NoDataColor_ColorBox.Selected := NoDataColor;

      ShadowLineLength_LabeledNumericEdit.NumericEdit.Text := IntToStr(ShadowLineLength_pixels);

//      RotationAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[ManualRotationDegrees]);

      TerminatorLines_CheckBox.Checked := IncludeTerminatorLines;

      LibrationCircle_CheckBox.Checked := IncludeLibrationCircle;
      LibrationCircle_ColorBox.Selected := LibrationCircleColor;

      ShowDetails_CheckBox.Checked := ShowDetails;
    end;
end;

procedure TLTVT_Form.ReadCartographicOptionsFromForm;
begin
  with CartographicOptions_Form do
    begin
      StartWithCurrentUT := UseCurrentUT_CheckBox.Checked;

      if LineOfCusps_RadioButton.Checked then
        OrientationMode := LineOfCusps
      else if Equatorial_RadioButton.Checked then
        OrientationMode := Equatorial
      else if AltAz_RadioButton.Checked then
        OrientationMode := AltAz
      else
        OrientationMode := Cartographic;

      InvertLR := InvertLR_CheckBox.Checked;
      InvertUD := InvertUD_CheckBox.Checked;
      SkyColor := Sky_ColorBox.Selected;
      DotModeSunlitColor := DotModeSunlitColor_ColorBox.Selected;
      DotModeShadowedColor := DotModeShadowedColor_ColorBox.Selected;
      NoDataColor := NoDataColor_ColorBox.Selected;
      ShadowLineLength_pixels := ShadowLineLength_LabeledNumericEdit.NumericEdit.IntegerValue;
//      ManualRotationDegrees := RotationAngle_LabeledNumericEdit.NumericEdit.ExtendedValue;
      IncludeTerminatorLines := TerminatorLines_CheckBox.Checked;
      IncludeLibrationCircle := LibrationCircle_CheckBox.Checked;
      LibrationCircleColor := LibrationCircle_ColorBox.Selected;
      ShowDetails := ShowDetails_CheckBox.Checked;
    end;
end;

procedure TLTVT_Form.Changelabelpreferences_MainMenuItemClick(Sender: TObject);
begin
  WriteLabelOptionsToForm;
  LabelFontSelector_Form.ShowModal;
  if LabelFontSelector_Form.ChangeSelections then  ReadLabelOptionsFromForm;
end;

procedure TLTVT_Form.SaveDefaultLabelOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  with Image1.Canvas.Font do
    begin
      IniFile.WriteString('LTVT Defaults','LabelFont_Name',Name);
      IniFile.WriteInteger('LTVT Defaults','LabelFont_CharSet',Byte(Charset));
      IniFile.WriteInteger('LTVT Defaults','LabelFont_Style',Byte(Style));
      IniFile.WriteInteger('LTVT Defaults','LabelFont_Size',Size);
      IniFile.WriteString('LTVT Defaults','LabelFont_Color',Format('$%6.6x',[Color]));
    end;
  IniFile.WriteInteger('LTVT Defaults','Label_XOffset',LabelXPix_Offset);
  IniFile.WriteInteger('LTVT Defaults','Label_YOffset',LabelYPix_Offset);
  IniFile.WriteString('LTVT Defaults','RadialDotOffset',BooleanToYesNo(RadialDotOffset));
  IniFile.WriteString('LTVT Defaults','IncludeFeatureName',BooleanToYesNo(IncludeFeatureName));
  IniFile.WriteString('LTVT Defaults','UseFullCraterNames',BooleanToYesNo(FullCraterNames));
  IniFile.WriteString('LTVT Defaults','IncludeFeatureSize',BooleanToYesNo(IncludeFeatureSize));
  IniFile.WriteString('LTVT Defaults','IncludeUnits',BooleanToYesNo(IncludeUnits));
  IniFile.WriteString('LTVT Defaults','IncludeDiscontinuedNames',BooleanToYesNo(IncludeDiscontinuedNames));
  IniFile.WriteInteger('LTVT Defaults','DotSizeInPixels',DotSize);
  IniFile.WriteInteger('LTVT Defaults','MediumCraterStartingDiameter',Round(MediumCraterDiam));
  IniFile.WriteInteger('LTVT Defaults','LargeCraterStartingDiameter',Round(LargeCraterDiam));
  IniFile.WriteString('LTVT Defaults','NonCraterDotColor',Format('$%6.6x',[NonCraterColor]));
  IniFile.WriteString('LTVT Defaults','SmallCraterDotColor',Format('$%6.6x',[SmallCraterColor]));
  IniFile.WriteString('LTVT Defaults','MediumCraterDotColor',Format('$%6.6x',[MediumCraterColor]));
  IniFile.WriteString('LTVT Defaults','LargeCraterDotColor',Format('$%6.6x',[LargeCraterColor]));
  IniFile.WriteString('LTVT Defaults','CraterCircleColor',Format('$%6.6x',[CraterCircleColor]));
  IniFile.WriteString('LTVT Defaults','ReferencePointColor',Format('$%6.6x',[ReferencePointColor]));
  IniFile.WriteString('LTVT Defaults','SnapShadowPointsToPlanView',BooleanToYesNo(SnapShadowPointsToPlanView));
  IniFile.WriteString('LTVT Defaults','AnnotateSavedImages',BooleanToYesNo(AnnotateSavedImages));
  IniFile.WriteString('LTVT Defaults','SavedImageUpperLabels_Color',Format('$%6.6x',[SavedImageUpperLabelsColor]));
  IniFile.WriteString('LTVT Defaults','SavedImageLowerLabels_Color',Format('$%6.6x',[SavedImageLowerLabelsColor]));
  IniFile.Free;
end;

procedure TLTVT_Form.RestoreDefaultLabelOptions;
var
  IniFile : TIniFile;
  StyleNum : Integer;
begin
  IniFile := TIniFile.Create(IniFileName);

  with Image1.Canvas.Font do
    begin
      Name := IniFile.ReadString('LTVT Defaults','LabelFont_Name','MS Sans Serif');
      CharSet := IniFile.ReadInteger('LTVT Defaults','LabelFont_CharSet',0);
      StyleNum := IniFile.ReadInteger('LTVT Defaults','LabelFont_Style',0);
      Style := [];
      if (StyleNum and 1)<>0 then Style := Style + [fsBold];
      if (StyleNum and 2)<>0 then Style := Style + [fsItalic];
      if (StyleNum and 4)<>0 then Style := Style + [fsUnderline];
      if (StyleNum and 8)<>0 then Style := Style + [fsStrikeOut];
      Size := IniFile.ReadInteger('LTVT Defaults','LabelFont_Size',8);
      try
        Color := StrToInt(IniFile.ReadString('LTVT Defaults','LabelFont_Color',IntToStr(clLime)));
      except
        Color := clLime;
      end;
    end;

  LabelXPix_Offset := IniFile.ReadInteger('LTVT Defaults','Label_XOffset',7);
  LabelYPix_Offset := IniFile.ReadInteger('LTVT Defaults','Label_YOffset',0);
  Corrected_LabelXPix_Offset := LabelXPix_Offset;
    // TextOut(X,Y) prints with Y = top of text, so need to center it per height
  Corrected_LabelYPix_Offset := LabelYPix_Offset + (Abs(Image1.Canvas.Font.Height) div 2);

  RadialDotOffset := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','RadialDotOffset','no'));
  IncludeFeatureName := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeFeatureName','yes'));
  FullCraterNames := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','UseFullCraterNames','no'));
  IncludeFeatureSize := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeFeatureSize','no'));
  IncludeUnits := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeUnits','no'));
  IncludeDiscontinuedNames := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeDiscontinuedNames','no'));

  DotSize := IniFile.ReadInteger('LTVT Defaults','DotSizeInPixels',2);
  MediumCraterDiam := IniFile.ReadInteger('LTVT Defaults','MediumCraterStartingDiameter',50);
  LargeCraterDiam := IniFile.ReadInteger('LTVT Defaults','LargeCraterStartingDiameter',100);
  try
    NonCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','NonCraterDotColor',IntToStr(clYellow)));
  except
    NonCraterColor := clYellow;
  end;
  try
    SmallCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','SmallCraterDotColor',IntToStr(clBlue)));
  except
    SmallCraterColor := clBlue;
  end;
  try
    MediumCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','MediumCraterDotColor',IntToStr(clLime)));
  except
    MediumCraterColor := clLime;
  end;
  try
    LargeCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','LargeCraterDotColor',IntToStr(clRed)));
  except
    LargeCraterColor := clRed;
  end;
  try
    CraterCircleColor := StrToInt(IniFile.ReadString('LTVT Defaults','CraterCircleColor',IntToStr(clWhite)));
  except
    CraterCircleColor := clWhite;
  end;
  try
    ReferencePointColor := StrToInt(IniFile.ReadString('LTVT Defaults','ReferencePointColor',IntToStr(clAqua)));
  except
    ReferencePointColor := clAqua;
  end;

  SnapShadowPointsToPlanView := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','SnapShadowPointsToPlanView','no'));

  AnnotateSavedImages := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','AnnotateSavedImages','yes'));

  try
    SavedImageUpperLabelsColor := StrToInt(IniFile.ReadString('LTVT Defaults','SavedImageUpperLabels_Color',IntToStr(clBlue)));
  except
    SavedImageUpperLabelsColor := clBlue;
  end;

  try
    SavedImageLowerLabelsColor := StrToInt(IniFile.ReadString('LTVT Defaults','SavedImageLowerLabels_Color',IntToStr(clOlive)));
  except
    SavedImageLowerLabelsColor := clOlive;
  end;

  IniFile.Free;
end;

procedure TLTVT_Form.WriteLabelOptionsToForm;
begin
  with LabelFontSelector_Form do
    begin
      DesiredFont.Assign(Image1.Canvas.Font);
      XOffset_LabeledNumericEdit.NumericEdit.Text := IntToStr(LabelXPix_Offset);
      YOffset_LabeledNumericEdit.NumericEdit.Text := IntToStr(LabelYPix_Offset);
      RadialDotOffset_CheckBox.Checked := RadialDotOffset;
      IncludeName_CheckBox.Checked := IncludeFeatureName;
      FullCraterNames_CheckBox.Checked := FullCraterNames;
      IncludeSize_CheckBox.Checked := IncludeFeatureSize;
      IncludeUnits_CheckBox.Checked := IncludeUnits;
      IncludeDiscontinuedNames_CheckBox.Checked := IncludeDiscontinuedNames;
      DotSize_LabeledNumericEdit.NumericEdit.Text := IntToStr(DotSize);
      MediumCraterDiam_NumericEdit.Text := Format('%0.0f',[MediumCraterDiam]);
      LargeCraterDiam_NumericEdit.Text  := Format('%0.0f',[LargeCraterDiam]);
      NonCrater_ColorBox.Selected := NonCraterColor;
      SmallCrater_ColorBox.Selected := SmallCraterColor;
      MediumCrater_ColorBox.Selected := MediumCraterColor;
      LargeCrater_ColorBox.Selected := LargeCraterColor;
      DotCircle_ColorBox.Selected := CraterCircleColor;
      RefPt_ColorBox.Selected := ReferencePointColor;
      SnapShadowPoint_CheckBox.Checked := SnapShadowPointsToPlanView;
      AnnotateSavedImages_CheckBox.Checked := AnnotateSavedImages;
      SavedImageUpperLabels_ColorBox.Selected := SavedImageUpperLabelsColor;
      SavedImageLowerLabels_ColorBox.Selected := SavedImageLowerLabelsColor;
    end;
end;

procedure TLTVT_Form.ReadLabelOptionsFromForm;
begin
  with LabelFontSelector_Form do
    begin
      Image1.Canvas.Font.Assign(DesiredFont);
      LabelXPix_Offset :=  XOffset_LabeledNumericEdit.NumericEdit.IntegerValue;
      LabelYPix_Offset :=  YOffset_LabeledNumericEdit.NumericEdit.IntegerValue;
      Corrected_LabelXPix_Offset := LabelXPix_Offset;
        // TextOut(X,Y) prints with Y = top of text, so need to center it per height
      Corrected_LabelYPix_Offset := LabelYPix_Offset + (Abs(Image1.Canvas.Font.Height) div 2);
      RadialDotOffset := RadialDotOffset_CheckBox.Checked;
      IncludeFeatureName := IncludeName_CheckBox.Checked;
      FullCraterNames := FullCraterNames_CheckBox.Checked;
      IncludeFeatureSize := IncludeSize_CheckBox.Checked;
      IncludeUnits := IncludeUnits_CheckBox.Checked;
      IncludeDiscontinuedNames := IncludeDiscontinuedNames_CheckBox.Checked;
      DotSize := DotSize_LabeledNumericEdit.NumericEdit.IntegerValue;
      MediumCraterDiam := MediumCraterDiam_NumericEdit.ExtendedValue;
      LargeCraterDiam := LargeCraterDiam_NumericEdit.ExtendedValue;
      NonCraterColor := NonCrater_ColorBox.Selected;
      SmallCraterColor := SmallCrater_ColorBox.Selected;
      MediumCraterColor := MediumCrater_ColorBox.Selected;
      LargeCraterColor := LargeCrater_ColorBox.Selected;
      CraterCircleColor := DotCircle_ColorBox.Selected;
      ReferencePointColor := RefPt_ColorBox.Selected;
      SnapShadowPointsToPlanView := SnapShadowPoint_CheckBox.Checked;
      AnnotateSavedImages := AnnotateSavedImages_CheckBox.Checked;
      SavedImageUpperLabelsColor := SavedImageUpperLabels_ColorBox.Selected;
      SavedImageLowerLabelsColor := SavedImageLowerLabels_ColorBox.Selected;
    end;
end;

procedure TLTVT_Form.MouseOptions_RightClickMenuItemClick(Sender: TObject);
begin
  ChangeMouseOptions_MainMenuItemClick(Sender);
end;

procedure TLTVT_Form.ChangeMouseOptions_MainMenuItemClick(Sender: TObject);
begin  {ChangeMouseOptions_MainMenuItemClick}
  with MouseOptions_Form do
    begin
      RefPtOptions_GroupBox.Caption :=
        Format(' Reference point is set at Longitude = %0.3f  and  Latitude = %0.3f  with  sun angle = %0.3f degrees ',
          [RadToDeg(RefPtLon),RadToDeg(RefPtLat),RadToDeg(RefPtSunAngle)]);

      WriteMouseOptionsToForm;

      ChangeOptions := False;
      ShowModal;

      if ChangeOptions then ReadMouseOptionsFromForm;
    end;
end;   {ChangeMouseOptions_MainMenuItemClick}

procedure TLTVT_Form.SaveMouseOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);

  if CursorType=UseCrosshairCursor then
    IniFile.WriteString('LTVT Defaults','Cursor_Type','cross-hair')
  else
    IniFile.WriteString('LTVT Defaults','Cursor_Type','normal');

  if RefPtReadoutMode=NoRefPtReadout then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','none')
  else if RefPtReadoutMode=DistanceAndBearingRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','distance')
  else if RefPtReadoutMode=PixelDataReadoutMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','pixel-data')
  else if RefPtReadoutMode=ShadowLengthRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','shadow-length')
  else if RefPtReadoutMode=InverseShadowLengthRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','inverse-shadow-length')
  else if RefPtReadoutMode=RayHeightsRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','ray-height');
  IniFile.Free;
end;

procedure TLTVT_Form.RestoreMouseOptions;
var
  IniFile : TIniFile;
  CursorMode, RefMode : String;
begin
  IniFile := TIniFile.Create(IniFileName);

  CursorMode := UpperCase(Trim(IniFile.ReadString('LTVT Defaults','Cursor_Type','normal')));
  if CursorMode='CROSS-HAIR' then
    begin
      Image1.Cursor := crCross;
      CursorType := UseCrosshairCursor;
    end
  else
    begin
      Image1.Cursor := crDefault;
      CursorType := UseDefaultCursor;
    end;

  RefMode := UpperCase(Trim(IniFile.ReadString('LTVT Defaults','RefPt_readout','none')));
  if RefMode='DISTANCE' then
    RefPtReadoutMode := DistanceAndBearingRefPtMode
  else if RefMode='PIXEL-DATA' then
    RefPtReadoutMode := PixelDataReadoutMode
  else if RefMode='SHADOW-LENGTH' then
    RefPtReadoutMode := ShadowLengthRefPtMode
  else if RefMode='INVERSE-SHADOW-LENGTH' then
    RefPtReadoutMode := ShadowLengthRefPtMode
  else if RefMode='RAY-HEIGHT' then
    RefPtReadoutMode := RayHeightsRefPtMode
  else
    RefPtReadoutMode := NoRefPtReadout;

  IniFile.Free;
end;

procedure TLTVT_Form.WriteMouseOptionsToForm;
begin
  with MouseOptions_Form do
    begin
      NormalCursor_RadioButton.Checked := (CursorType=UseDefaultCursor);
      CrosshairCursor_RadioButton.Checked := (CursorType=UseCrosshairCursor);

      case RefPtReadoutMode of
        DistanceAndBearingRefPtMode : DistanceAndBearingFromRefPt_RadioButton.Checked := True;
        PixelDataReadoutMode : PixelDataReadout_RadioButton.Checked := True;
        ShadowLengthRefPtMode : ShadowLengthRefPtReadout_RadioButton.Checked := True;
        InverseShadowLengthRefPtMode : InverseShadowLengthRefPtReadout_RadioButton.Checked := True;
        RayHeightsRefPtMode : PointOfLightRefPtReadout_RadioButton.Checked := True;
        else
          NoRefPtReadout_RadioButton.Checked := True;
        end;

    end;
end;

procedure TLTVT_Form.ReadMouseOptionsFromForm;
begin
  with MouseOptions_Form do
    begin
      if CrosshairCursor_RadioButton.Checked then
        begin
          Image1.Cursor := crCross;
          CursorType := UseCrosshairCursor;
        end
      else
        begin
          Image1.Cursor := crDefault;
          CursorType := UseDefaultCursor;
        end;

      if DistanceAndBearingFromRefPt_RadioButton.Checked then
        RefPtReadoutMode := DistanceAndBearingRefPtMode
      else if PixelDataReadout_RadioButton.Checked then
        RefPtReadoutMode := PixelDataReadoutMode
      else if ShadowLengthRefPtReadout_RadioButton.Checked then
        RefPtReadoutMode := ShadowLengthRefPtMode
      else if InverseShadowLengthRefPtReadout_RadioButton.Checked then
        RefPtReadoutMode := InverseShadowLengthRefPtMode
      else if PointOfLightRefPtReadout_RadioButton.Checked then
        RefPtReadoutMode := RayHeightsRefPtMode
      else
        RefPtReadoutMode := NoRefPtReadout;

    end;

end;

procedure TLTVT_Form.ChangeExternalFiles_MainMenuItemClick(Sender: TObject);
begin
      WriteFileOptionsToForm;
      ExternalFileSelection_Form.ChangeFileNames := False;
      ExternalFileSelection_Form.ShowModal;

      if ExternalFileSelection_Form.ChangeFileNames then  ReadFileOptionsFromForm;
end;

function TLTVT_Form.BriefName(const FullName : string) : string;
{strip off path if it is the same as LTVT.exe}
  begin
    if ExtractFilePath(FullName)=BasePath then
      Result := ExtractFileName(FullName)
    else
      Result := FullName;
  end;

procedure TLTVT_Form.SaveFileOptions;
var
  IniFile : TIniFile;

begin  {TLTVT_Form.SaveFileOptions}
  IniFile := TIniFile.Create(IniFileName);

  IniFile.WriteString('LTVT Defaults','Linux_Compatibility_Mode',BooleanToYesNo(LinuxCompatibilityMode));

  if TAIOffsetFile.FileLoaded then
    begin
      IniFile.WriteString('LTVT Defaults','Correct_for_Ephemeris_Time_TAI_Offset','yes');
      IniFile.WriteString('LTVT Defaults','TAI_Offset_Data_File',BriefName(TAIOffsetFile.FileName));
    end
  else
    begin
      IniFile.WriteString('LTVT Defaults','Correct_for_Ephemeris_Time_TAI_Offset','no');
      IniFile.DeleteKey('LTVT Defaults','TAI_Offset_Data_File');
    end;

  IniFile.WriteString('LTVT Defaults','Crater_File',BriefName(CraterFilename));
  IniFile.WriteString('LTVT Defaults','Photo_File',BriefName(NormalPhotoSessionsFilename));
  IniFile.WriteString('LTVT Defaults','Calibrated_Photo_File',BriefName(CalibratedPhotosFilename));
  IniFile.WriteString('LTVT Defaults','Observatory_List_File',BriefName(ObservatoryListFilename));
  IniFile.WriteString('LTVT Defaults','JPL_Ephemeris_File',BriefName(JPL_Filename));

  IniFile.WriteString('LTVT Defaults','Texture1_Caption',LoResUSGS_RadioButton.Caption);
  IniFile.WriteString('LTVT Defaults','Texture1_File',BriefName(LoResFilename));

  IniFile.WriteString('LTVT Defaults','Texture2_Caption',HiResUSGS_RadioButton.Caption);
  IniFile.WriteString('LTVT Defaults','Texture2_File',BriefName(HiResFilename));

  IniFile.WriteString('LTVT Defaults','Texture3_Caption',Clementine_RadioButton.Caption);
  IniFile.WriteString('LTVT Defaults','Texture3_File',BriefName(ClementineFilename));

  IniFile.WriteString('LTVT Defaults','Texture3_MinLon_deg',Tex3MinLonText);
  IniFile.WriteString('LTVT Defaults','Texture3_MaxLon_deg',Tex3MaxLonText);
  IniFile.WriteString('LTVT Defaults','Texture3_MinLat_deg',Tex3MinLatText);
  IniFile.WriteString('LTVT Defaults','Texture3_MaxLat_deg',Tex3MaxLatText);

  IniFile.WriteString('LTVT Defaults','EarthTexture_File',BriefName(EarthTextureFilename));

  FileSettingsChanged := False;
  IniFile.Free;
end;   {TLTVT_Form.SaveFileOptions}

procedure TLTVT_Form.RestoreFileOptions;
const
  Texture1_DefaultText = 'Low Resolution Shaded Relief';
  Texture2_DefaultText = 'High Resolution Shaded Relief';
  Texture3_DefaultText = 'Clementine Photo Mosaic';

var
  IniFile : TIniFile;
  TempTexture1Name, TempTexture2Name, TempTexture3Name, TempEarthTextureName : String;

begin  {TLTVT_Form.RestoreFileOptions}
//  ShowMessage('Reading options from ini file...');
  IniFile := TIniFile.Create(IniFileName);

  LinuxCompatibilityMode := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Linux_Compatibility_Mode','no'));

  NormalPhotoSessionsFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Photo_File','PhotoSessions.csv'));
  CalibratedPhotosFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Calibrated_Photo_File','PhotoCalibrationData.txt'));
  ObservatoryListFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Observatory_List_File','Observatory_List.txt'));

  if YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Correct_for_Ephemeris_Time_TAI_Offset','yes')) then
    begin
      OldFilename := FullFilename(IniFile.ReadString('LTVT Defaults','TAI_Offset_Data_File','TAI_Offset_Data.txt'));
      if (not FileExists(OldFilename)) and (MessageDlg('LTVT is looking for a TAI_Offset file'+CR
                        +'   Do you want help with this topic?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TAI_Offsets.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      TAIOffsetFile.SetFile(OldFilename);  // this initiates dialog if file does not exist.
      if TAIOffsetFile.FileName<>OldFilename then FileSettingsChanged := True;
// note: if no file was loaded, TAIOffsetFile returns the default offset of 65.184 sec
//   also, when the options are saved, this key will be deleted if there is no file currently loaded
    end;

  JPL_Filename   := FullFilename(IniFile.ReadString('LTVT Defaults','JPL_Ephemeris_File','UNXP2000.405'));
  JPL_FilePath := ExtractFilePath(JPL_Filename);

  CraterFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Crater_File','Named_Lunar_Features.csv'));

  TempTexture1Name := LoResFilename;
  LoResUSGS_RadioButton.Caption  := Substring(IniFile.ReadString('LTVT Defaults','Texture1_Caption',Texture1_DefaultText),1,40);
  if Trim(LoResUSGS_RadioButton.Caption)='' then LoResUSGS_RadioButton.Caption := Texture1_DefaultText;
  LoResFilename  := IniFile.ReadString('LTVT Defaults','Low_Resolution_USGS_Relief_Map','');
  if LoResFilename<>'' then
    begin
      IniFile.WriteString('LTVT Defaults','Texture1_File',LoResFilename);
      IniFile.DeleteKey('LTVT Defaults','Low_Resolution_USGS_Relief_Map');
    end;
  LoResFilename  := FullFilename(IniFile.ReadString('LTVT Defaults','Texture1_File','lores.jpg'));
  if TempTexture1Name<>LoResFilename then
    begin
      LoRes_TextureMap.Free;
      LoRes_Texture_Loaded := False;
      LoResUSGS_RadioButton.Font.Color := clGray;
    end;

  TempTexture2Name := HiResFilename;
  HiResUSGS_RadioButton.Caption  := Substring(IniFile.ReadString('LTVT Defaults','Texture2_Caption',Texture2_DefaultText),1,40);
  if Trim(HiResUSGS_RadioButton.Caption)='' then HiResUSGS_RadioButton.Caption := Texture2_DefaultText;
  HiResFilename  := IniFile.ReadString('LTVT Defaults','High_Resolution_USGS_Relief_Map','');
  if HiResFilename<>'' then
    begin
      IniFile.WriteString('LTVT Defaults','Texture2_File',HiResFilename);
      IniFile.DeleteKey('LTVT Defaults','High_Resolution_USGS_Relief_Map');
    end;
  HiResFilename  := FullFilename(IniFile.ReadString('LTVT Defaults','Texture2_File','hires.jpg'));
  if TempTexture2Name<>HiResFilename then
    begin
      HiRes_TextureMap.Free;
      HiRes_Texture_Loaded := False;
      HiResUSGS_RadioButton.Font.Color := clGray;
    end;

  TempTexture3Name := ClementineFilename;
  Clementine_RadioButton.Caption  := Substring(IniFile.ReadString('LTVT Defaults','Texture3_Caption',Texture3_DefaultText),1,40);
  if Trim(Clementine_RadioButton.Caption)='' then Clementine_RadioButton.Caption := Texture3_DefaultText;
  ClementineFilename := IniFile.ReadString('LTVT Defaults','Clementine_Texture_Map','');
  if ClementineFilename<>'' then
    begin
      IniFile.WriteString('LTVT Defaults','Texture3_File',ClementineFilename);
      IniFile.DeleteKey('LTVT Defaults','Clementine_Texture_Map');
    end;
  ClementineFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Texture3_File','hires_clem.jpg'));
  if TempTexture3Name<>ClementineFilename then
    begin
      Clementine_TextureMap.Free;
      Clementine_Texture_Loaded := False;
      Clementine_RadioButton.Font.Color := clGray;
    end;

  Tex3MinLonText := IniFile.ReadString('LTVT Defaults','Texture3_MinLon_deg',Tex3MinLon_DefaultText);
  Tex3MaxLonText := IniFile.ReadString('LTVT Defaults','Texture3_MaxLon_deg',Tex3MaxLon_DefaultText);
  Tex3MinLatText := IniFile.ReadString('LTVT Defaults','Texture3_MinLat_deg',Tex3MinLat_DefaultText);
  Tex3MaxLatText := IniFile.ReadString('LTVT Defaults','Texture3_MaxLat_deg',Tex3MaxLat_DefaultText);

  TempEarthTextureName := EarthTextureFilename;
  EarthTextureFilename := FullFilename(IniFile.ReadString('LTVT Defaults','EarthTexture_File','land_shallow_topo_2048.jpg'));
  if TempEarthTextureName<>EarthTextureFilename then
    begin
      Earth_TextureMap.Free;
      Earth_Texture_Loaded := False;
    end;

  IniFile.Free;
end;   {TLTVT_Form.RestoreFileOptions}

procedure TLTVT_Form.WriteFileOptionsToForm;
begin
//  ShowMessage('Copying options to form...');
  with ExternalFileSelection_Form do
    begin
      WineCompatibility_CheckBox.Checked := LinuxCompatibilityMode;

      Texture1Description_Edit.Text := LoResUSGS_RadioButton.Caption;
      TempTexture1Name := LoResFilename;
      Texture2Description_Edit.Text := HiResUSGS_RadioButton.Caption;
      TempTexture2Name := HiResFilename;
      Texture3Description_Edit.Text := Clementine_RadioButton.Caption;
      TempTexture3Name := ClementineFilename;
      Tex3MinLon_LabeledNumericEdit.NumericEdit.Text := Tex3MinLonText;
      Tex3MaxLon_LabeledNumericEdit.NumericEdit.Text := Tex3MaxLonText;
      Tex3MinLat_LabeledNumericEdit.NumericEdit.Text := Tex3MinLatText;
      Tex3MaxLat_LabeledNumericEdit.NumericEdit.Text := Tex3MaxLatText;
      TempEarthTextureName := EarthTextureFilename;

      TempDotFilename := CraterFilename;
      H_Terminator_Goto_Form.MinimizeGotoList_CheckBox.Checked :=
        (ExtractFileName(CraterFilename)='ClementineAltimeterData.csv') or (ExtractFileName(CraterFilename)='2005_ULCN.csv');

// check if Photo Sessions Search form has been used, if so, adopt current name in it.
// otherwise retain name probably read from LTVT.ini .
      if PhotosessionSearch_Form.PhotoSessionsFilename<>'' then
        NormalPhotoSessionsFilename := PhotosessionSearch_Form.PhotoSessionsFilename;
      TempNormalPhotoSessionsFilename := NormalPhotoSessionsFilename;

      TempCalibratedPhotosFilename := CalibratedPhotosFilename;
      TempObservatoryListFilename := ObservatoryListFilename;

      TempEphemerisFilename := JPL_Filename;
      TempTAIFilename := TAIOffsetFile.FileName;
    end;
end;

procedure TLTVT_Form.ReadFileOptionsFromForm;
var
  SelectedFilename : String;
begin
  with ExternalFileSelection_Form do
    begin
      if WineCompatibility_CheckBox.Checked<>LinuxCompatibilityMode then
        begin
          LinuxCompatibilityMode := WineCompatibility_CheckBox.Checked;
          FileSettingsChanged := True;
        end;

      LoResUSGS_RadioButton.Caption := Texture1Description_Edit.Text;
      if TempTexture1Name<>LoResFilename then
        begin
          LoRes_TextureMap.Free;
          LoRes_Texture_Loaded := False;
          LoResUSGS_RadioButton.Font.Color := clGray;
          LoResFilename := TempTexture1Name;
          FileSettingsChanged := True;
        end;

      HiResUSGS_RadioButton.Caption := Texture2Description_Edit.Text;
      if TempTexture2Name<>HiResFilename then
        begin
          HiRes_TextureMap.Free;
          HiRes_Texture_Loaded := False;
          HiResUSGS_RadioButton.Font.Color := clGray;
          HiResFilename := TempTexture2Name;
          FileSettingsChanged := True;
        end;

      Clementine_RadioButton.Caption := Texture3Description_Edit.Text;
      if TempTexture3Name<>ClementineFilename then
        begin
          Clementine_TextureMap.Free;
          Clementine_Texture_Loaded := False;
          Clementine_RadioButton.Font.Color := clGray;
          ClementineFilename := TempTexture3Name;
          FileSettingsChanged := True;
        end;

      Tex3MinLonText := Tex3MinLon_LabeledNumericEdit.NumericEdit.Text;
      Tex3MaxLonText := Tex3MaxLon_LabeledNumericEdit.NumericEdit.Text;
      Tex3MinLatText := Tex3MinLat_LabeledNumericEdit.NumericEdit.Text;
      Tex3MaxLatText := Tex3MaxLat_LabeledNumericEdit.NumericEdit.Text;

      if TempEarthTextureName<>EarthTextureFilename then
        begin
          Earth_TextureMap.Free;
          Earth_Texture_Loaded := False;
          EarthTextureFilename := TempEarthTextureName;
          FileSettingsChanged := True;
        end;

      if TempDotFilename<>CraterFilename then
        begin
          CraterFilename := TempDotFilename;
          FileSettingsChanged := True;
          SelectedFilename := ExtractFileName(CraterFilename);
          H_Terminator_Goto_Form.MinimizeGotoList_CheckBox.Checked :=
            (SelectedFilename='ClementineAltimeterData.csv') or (SelectedFilename='2005_ULCN.csv');
        end;

      if TempNormalPhotoSessionsFilename<>NormalPhotoSessionsFilename then
        begin
          NormalPhotoSessionsFilename := TempNormalPhotoSessionsFilename;
          PhotosessionSearch_Form.PhotoSessionsFilename := NormalPhotoSessionsFilename;
          FileSettingsChanged := True;
        end;

      if TempCalibratedPhotosFilename<>CalibratedPhotosFilename then
        begin
          CalibratedPhotosFilename := TempCalibratedPhotosFilename;
          FileSettingsChanged := True;
        end;

      if TempObservatoryListFilename<>ObservatoryListFilename then
        begin
          ObservatoryListFilename := TempObservatoryListFilename;
          FileSettingsChanged := True;
        end;

      if TempEphemerisFilename<>JPL_Filename then
        begin
          JPL_Filename := TempEphemerisFilename;
          JPL_FilePath := ExtractFilePath(JPL_Filename);
          FileSettingsChanged := True;
        end;

      if TempTAIFilename<>TAIOffsetFile.FileName then
        begin
          TAIOffsetFile.SetFile(TempTAIFilename);
          FileSettingsChanged := True;
        end;

    end;
end;

procedure TLTVT_Form.SetLocation_ButtonClick(Sender: TObject);
begin
  FocusControl(MousePosition_GroupBox); // need to remove focus or button will remain pictured in a depressed state
  WriteLocationOptionsToForm;
  SetObserverLocation_Form.ShowModal;
  if not SetObserverLocation_Form.ActionCanceled then ReadLocationOptionsFromForm;
end;

procedure TLTVT_Form.SaveLocationOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  IniFile.WriteString('LTVT Defaults','Geocentric_Observer',BooleanToYesNo(GeocentricSubEarthMode));
  IniFile.WriteString('LTVT Defaults','Observer_East_Longitude',ObserverLongitudeText);
  IniFile.WriteString('LTVT Defaults','Observer_North_Latitude',ObserverLatitudeText);
  IniFile.WriteString('LTVT Defaults','Observer_Elevation',ObserverElevationText);
  IniFile.Free;
end;

procedure TLTVT_Form.RestoreLocationOptions;
const
  Longitude_DefaultText = '0.000';
  Latitude_DefaultText = '0.000';
  Elevation_DefaultText = '0.0';
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);

  GeocentricSubEarthMode := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Geocentric_Observer','yes'));
  ObserverLongitudeText := Trim(IniFile.ReadString('LTVT Defaults','Observer_East_Longitude',Longitude_DefaultText));
  ObserverLatitudeText := Trim(IniFile.ReadString('LTVT Defaults','Observer_North_Latitude',Latitude_DefaultText));
  ObserverElevationText := Trim(IniFile.ReadString('LTVT Defaults','Observer_Elevation',Elevation_DefaultText));

  if ObserverLongitudeText='' then ObserverLongitudeText := Longitude_DefaultText;
  if ObserverLatitudeText='' then ObserverLatitudeText := Latitude_DefaultText;
  if ObserverElevationText='' then ObserverElevationText := Elevation_DefaultText;

  IniFile.Free;
end;

procedure TLTVT_Form.WriteLocationOptionsToForm;
begin
  with SetObserverLocation_Form do
    begin
      Geocentric_RadioButton.Checked := GeocentricSubEarthMode;
      UserSpecified_RadioButton.Checked := not Geocentric_RadioButton.Checked;
      ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
      ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
      ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
    end;
end;

procedure TLTVT_Form.ReadLocationOptionsFromForm;
begin
  with SetObserverLocation_Form do
    begin
      GeocentricSubEarthMode := Geocentric_RadioButton.Checked;
      ObserverLongitudeText := ObserverLongitude_LabeledNumericEdit.NumericEdit.Text;
      ObserverLatitudeText := ObserverLatitude_LabeledNumericEdit.NumericEdit.Text;
      ObserverElevationText := ObserverElevation_LabeledNumericEdit.NumericEdit.Text;
      EstimateData_Button.Click;
    end;
end;

procedure TLTVT_Form.Saveoptions_MainMenuItemClick(Sender: TObject);
var
  IniFile : TIniFile;

begin  {Saveoptions_MainMenuItemClick}
  if MessageDlg('Save all current settings as defaults?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      IniFile := TIniFile.Create(IniFileName);

      if DrawingMode=DotMode then
        IniFile.WriteString('LTVT Defaults','Draw_Dots_on_Startup','yes')
      else
        IniFile.WriteString('LTVT Defaults','Draw_Dots_on_Startup','no');

      IniFile.WriteString('LTVT Defaults','Feature_size_threshold',CraterThreshold_LabeledNumericEdit.NumericEdit.Text);

      IniFile.Free;

      SaveDemOptions;
      SaveCartographicOptions;
      SaveDefaultLabelOptions;
      SaveMouseOptions;
      SaveFileOptions;
      SaveLocationOptions;

    end;
end;   {Saveoptions_MainMenuItemClick}

procedure TLTVT_Form.CalibratePhoto_MainMenuItemClick(Sender: TObject);
begin
  PhotoCalibrator_Form.Show;
end;

procedure TLTVT_Form.Calibrateasatellitephoto1Click(Sender: TObject);
begin
  SatellitePhotoCalibrator_Form.Show;
end;

procedure TLTVT_Form.SearchPhotoSessions_ButtonClick(Sender: TObject);
begin
  with CalibratedPhotoLoader_Form do
    begin
      Sort_CheckBox.Checked := True;
      FilterPhotos_CheckBox.Checked := True;
    end;
  LoadCalibratedPhoto_MainMenuItemClick(Sender);
end;

procedure TLTVT_Form.LoadCalibratedPhoto_MainMenuItemClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat : Extended;

  ErrorCode, Ref2XPixel, Ref2YPixel : Integer;
  SubObsLonDeg, SubObsLatDeg, Ref1LonDeg, Ref1LatDeg,
  Ref2LonDeg, Ref2LatDeg, Ref2X, Ref2Y,
  PhotoCenterX, PhotoCenterY,
  PixelDistSqrd, XYDistSqrd,
  RotationAngle,
  SatelliteNLatDeg, SatelliteELonDeg, SatelliteElevKm : Extended;
  GroundPointVector : TVector;

  LoadSuccessful : Boolean;

begin  {TLTVT_Form.LoadCalibratedPhoto_MainMenuItemClick}
  with CalibratedPhotoLoader_Form do
    begin
      PhotoSelected := False;
      if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
        begin
          TargetLon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
          TargetLat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
        end;

      ListPhotos_Button.Click;

      ShowModal;
      if PhotoSelected then
        begin
          LoadSuccessful := True;
          UserPhotoLoaded := False;
          UserPhoto_RadioButton.Font.Color := clGray;
          UserPhotoData := SelectedPhotoData;

          if UserPhotoData.PhotoCalCode='U1' then
            UserPhotoType := Satellite
          else
            UserPhotoType := EarthBased;

          Val(UserPhotoData.InversionCode,UserPhoto_InversionCode,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.SubObsLon,SubObsLonDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.SubObsLat,SubObsLatDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          if UserPhotoType=Satellite then with UserPhotoData do
            begin
              Val(PhotoObsNLatDeg,SatelliteNLatDeg,ErrorCode);
              LoadSuccessful := LoadSuccessful and (ErrorCode=0);

              Val(PhotoObsELonDeg,SatelliteElonDeg,ErrorCode);
              LoadSuccessful := LoadSuccessful and (ErrorCode=0);

              Val(PhotoObsHt,SatelliteElevKm,ErrorCode);
              LoadSuccessful := LoadSuccessful and (ErrorCode=0);

              PolarToVector(DegToRad(SatelliteElonDeg), DegToRad(SatelliteNLatDeg),
                MoonRadius + SatelliteElevKm, SatelliteVector);

              PolarToVector(DegToRad(SubObsLonDeg), DegToRad(SubObsLatDeg),
                MoonRadius, GroundPointVector);

              VectorDifference(GroundPointVector,SatelliteVector,UserPhoto_ZPrime_Unit_Vector);

              if VectorMagnitude(UserPhoto_ZPrime_Unit_Vector)=0 then
                begin
                  ShowMessage('Satellite and Ground Point must be at different positions!');
                  Exit
                end;

              NormalizeVector(UserPhoto_ZPrime_Unit_Vector);

              CrossProduct(UserPhoto_ZPrime_Unit_Vector, Uy, UserPhoto_XPrime_Unit_Vector);
              if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then
                begin
                  CrossProduct(UserPhoto_ZPrime_Unit_Vector, Ux, UserPhoto_XPrime_Unit_Vector);
                end;

              if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then
                begin // this should never happen
                  ShowMessage('Internal error: unable to establish camera axis');
                  Exit
                end;

              NormalizeVector(UserPhoto_XPrime_Unit_Vector);

              CrossProduct(UserPhoto_ZPrime_Unit_Vector, UserPhoto_XPrime_Unit_Vector, UserPhoto_YPrime_Unit_Vector);

              SubObsLatDeg := RadToDeg(ArcSin(-UserPhoto_ZPrime_Unit_Vector[y]));   // results in radians
              SubObsLonDeg := RadToDeg(ArcTan2(-UserPhoto_ZPrime_Unit_Vector[x],-UserPhoto_ZPrime_Unit_Vector[z]));

              SubObsLat := Format('%0.3f',[SubObsLatDeg]);
              SubObsLon := Format('%0.3f',[PosNegDegrees(SubObsLonDeg)]);
//                  ShowMessage('Sub-obs lon = '+SubObsLon);
            end;

          PolarToVector(DegToRad(SubObsLonDeg),DegToRad(SubObsLatDeg),1,UserPhoto_SubObsVector);
          NormalizeVector(UserPhoto_SubObsVector);

          if UserPhotoType=Earthbased then
            begin
              UserPhoto_ZPrime_Unit_Vector := UserPhoto_SubObsVector;
              CrossProduct(Uy,UserPhoto_ZPrime_Unit_Vector,UserPhoto_XPrime_Unit_Vector);
              if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then UserPhoto_XPrime_Unit_Vector := Ux;  //UserPhoto_SubObsVector parallel to Uy (looking from over north or south pole)
              NormalizeVector(UserPhoto_XPrime_Unit_Vector);
              CrossProduct(UserPhoto_SubObsVector,UserPhoto_XPrime_Unit_Vector,UserPhoto_YPrime_Unit_Vector);
              MultiplyVector(UserPhoto_InversionCode,UserPhoto_XPrime_Unit_Vector);
            end;


          Val(UserPhotoData.Ref1XPix,UserPhoto_StartXPix,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref1YPix,UserPhoto_StartYPix,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref1Lon,Ref1LonDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref1Lat,Ref1LatDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          LoadSuccessful := LoadSuccessful and ConvertLonLatToUserPhotoXY(DegToRad(Ref1LonDeg),DegToRad(Ref1LatDeg),
            MoonRadius,UserPhoto_StartX,UserPhoto_StartY);

          Val(UserPhotoData.Ref2XPix,Ref2XPixel,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref2YPix,Ref2YPixel,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref2Lon,Ref2LonDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref2Lat,Ref2LatDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          LoadSuccessful := LoadSuccessful and ConvertLonLatToUserPhotoXY(DegToRad(Ref2LonDeg),DegToRad(Ref2LatDeg),
            MoonRadius,Ref2X,Ref2Y);
          PixelDistSqrd := Sqr(Ref2XPixel - UserPhoto_StartXPix) + Sqr(Ref2YPixel - UserPhoto_StartYPix);
          XYDistSqrd := Sqr(Ref2X - UserPhoto_StartX) + Sqr(Ref2Y - UserPhoto_StartY);
          LoadSuccessful := LoadSuccessful and  (PixelDistSqrd<>0) and (XYDistSqrd<>0);

          if not LoadSuccessful then
            begin
              ShowMessage('An error occurred reading the calibration data -- please load a different photo');
              UserPhoto_RadioButton.Hide;
              LoResUSGS_RadioButton.Checked := True;
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

          UserPhoto_RadioButton.Caption := ExtractFileName(UserPhotoData.PhotoFilename);
          UserPhoto_RadioButton.Show;
          UserPhoto_RadioButton.Checked := True;

          if not OverwriteNone_RadioButton.Checked then SetManualGeometryLabels; // will be overwritten if there is a call to EstimateData_Button.Click

          if OverwriteAll_RadioButton.Checked then with SelectedPhotoData do
            begin
              Date_DateTimePicker.Date := PhotoDate;
              Time_DateTimePicker.Time := PhotoTime;
              GeocentricSubEarthMode := False;
              OrientationMode := Cartographic;
              InvertLR := UserPhoto_InversionCode<0;
              InvertUD := False;
//                  ManualRotationDegrees := Sign(UserPhoto_InversionCode)*RadToDeg(RotationAngle);
              RotationAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[Sign(UserPhoto_InversionCode)*RadToDeg(RotationAngle)]);
              Zoom_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[UserPhoto_PixelsPerXYUnit/(Image1.Width/2)]);
              PhotoCenterX := (UserPhoto_StartX + Ref2X)/2;
              PhotoCenterY := (UserPhoto_StartY + Ref2Y)/2;
//                  ConvertUserPhotoXPixYPixToXY(Ref2XPixel, Ref2YPixel, PhotoCenterX, PhotoCenterY);
              ImageCenterX := UserPhoto_InversionCode*(PhotoCenterX*Cos(RotationAngle) + PhotoCenterY*Sin(RotationAngle));
              ImageCenterY := -PhotoCenterX*Sin(RotationAngle) + PhotoCenterY*Cos(RotationAngle);
              if (PhotoObsHt<>'-999') and (PhotoCalCode<>'U1') then
                begin
                  ObserverLongitudeText := PhotoObsELonDeg;
                  ObserverLatitudeText  := PhotoObsNLatDeg;
                  ObserverElevationText := PhotoObsHt;
                  EstimateData_Button.Click;
                end
              else
                begin
                  SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLon;
                  SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLat;
                  SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
                  SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
                  DrawTexture_Button.Click;
                end;
            end
          else if OverwriteDateTime_RadioButton.Checked then with SelectedPhotoData do
            begin
              Date_DateTimePicker.Date := PhotoDate;
              Time_DateTimePicker.Time := PhotoTime;
              GeocentricSubEarthMode := False;
              if (PhotoObsHt<>'-999') and (PhotoCalCode<>'U1') then
                begin
                  ObserverLongitudeText := PhotoObsELonDeg;
                  ObserverLatitudeText  := PhotoObsNLatDeg;
                  ObserverElevationText := PhotoObsHt;
                  EstimateData_Button.Click;
                end
              else
                begin
                  SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLon;
                  SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLat;
                  SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
                  SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
                  DrawTexture_Button.Click;
                end;
            end
          else if OverwriteGeometry_RadioButton.Checked then with SelectedPhotoData do
            begin
              SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLon;
              SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLat;
              SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
              SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
              DrawTexture_Button.Click;
            end
          else if SunAngleOnly_RadioButton.Checked then with SelectedPhotoData do
            begin
              SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
              SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
              DrawTexture_Button.Click;
            end
          else
            DrawTexture_Button.Click;
        end;
    end;

end;   {TLTVT_Form.LoadCalibratedPhoto_MainMenuItemClick}

procedure TLTVT_Form.OpenAnLTOchart1Click(Sender: TObject);
begin
  LTO_Viewer_Form.Show;
end;

function TLTVT_Form.LTO_SagCorrectionDeg(const DelLonDeg, LatDeg : Extended) : Extended;
{amount to be added to true Latitude to get Latitude as read on central meridian;
 DelLonDeg = displacement in longitude from center of map}
begin
  Result := 0.045*Sin(DegToRad(LatDeg))*Sqr((DelLonDeg)/2.5);
end;

function TLTVT_Form.ConvertLTOLonLatToXY(const LTO_LonDeg, LTO_LatDeg : Extended; var LTO_XPix, LTO_YPix : Integer) : Boolean;
var
  DelLon, DelX, DelY, TrueX, TrueY, RawX, RawY, Tangent, Rho : Extended;
begin
  Result := False;

  case LTO_MapMode of
    LTO_map :
      begin
        DelLon := LTO_LonDeg - LTO_CenterLon;
        while DelLon>180 do DelLon := DelLon - 360;
        while DelLon<-180 do DelLon := DelLon + 360;
        DelX := DelLon*LTO_HorzPixPerDeg*Cos(DegToRad(LTO_LatDeg));
        DelY := (LTO_LatDeg - LTO_CenterLat + LTO_SagCorrectionDeg(DelLon,LTO_LatDeg))*LTO_VertPixPerDeg ;
        LTO_XPix := Round(LTO_CenterXPix + DelX*LTO_CosTheta - DelY*LTO_SinTheta);
        LTO_YPix := Round(LTO_CenterYPix + DelX*LTO_SinTheta + DelY*LTO_CosTheta);
        Result := True;
      end;

    Mercator_map :
      begin
        DelLon := LTO_LonDeg - LTO_CenterLon;
        while DelLon>180 do DelLon := DelLon - 360;
        while DelLon<-180 do DelLon := DelLon + 360;
        TrueX := LTO_CenterXPix + LTO_MercatorScaleFactor*DegToRad(DelLon);
        Tangent := Tan((PiByTwo +DegToRad(LTO_LatDeg))/2);
        if Tangent>0 then
          begin
            TrueY := LTO_CenterYPix - LTO_MercatorScaleFactor*Ln(Tangent);
            RawX := TrueX*LTO_CosTheta - TrueY*LTO_SinTheta;  // this is the inverse of the rotation in the LTO_Viewer
            RawY := TrueX*LTO_SinTheta + TrueY*LTO_CosTheta;
            RawY := RawY*LTO_VertCorrection;  // note, LTO_VertCorrection is the reciprocal of VertCorrection in the LTO viewer

            LTO_XPix := Round(RawX);
            LTO_YPix := Round(RawY);
            Result := True;
          end;
      end;

    Lambert_map :
      begin
        DelLon := LTO_LonDeg - LTO_CenterLon;
        while DelLon>180 do DelLon := DelLon - 360;
        while DelLon<-180 do DelLon := DelLon + 360;
        Tangent := Tan((PiByTwo + DegToRad(LTO_LatDeg))/2);
        if Tangent>0 then
          begin
            Rho := LTO_Lambert_F/Power(Tangent,LTO_Lambert_n);

            TrueX := LTO_CenterXPix + LTO_Lambert_ScaleFactor*Rho*Sin(LTO_Lambert_n*DegToRad(DelLon));
            TrueY := LTO_CenterYPix - LTO_Lambert_ScaleFactor*(LTO_Lambert_Rho_zero - Rho*Cos(LTO_Lambert_n*DegToRad(DelLon)));

            RawX := TrueX*LTO_CosTheta - TrueY*LTO_SinTheta;  // this is the inverse of the rotation in the LTO_Viewer
            RawY := TrueX*LTO_SinTheta + TrueY*LTO_CosTheta;
            RawY := RawY*LTO_VertCorrection;  // note, LTO_VertCorrection is the reciprocal of VertCorrection in the LTO viewer

            LTO_XPix := Round(RawX);
            LTO_YPix := Round(RawY);
            Result := True;
          end;
      end;

    end;
end;

procedure TLTVT_Form.FormResize(Sender: TObject);
var
  AddedWidth : Integer;
begin
  AddedWidth := (Width - 994);
  Geometry_GroupBox.Left := 648 + AddedWidth;
  MoonDisplay_GroupBox.Left := Geometry_GroupBox.Left;
  MousePosition_GroupBox.Left := Geometry_GroupBox.Left;
  SaveImage_Button.Left := Geometry_GroupBox.Left + 8;
  Predict_Button.Left := Geometry_GroupBox.Left + 128;
  SearchPhotoSessions_Button.Left := Geometry_GroupBox.Left + 224;
  Image1.Picture.Bitmap.Width := LastImageWidth;
  Image1.Picture.Bitmap.Height := LastImageHeight;
  Image1.Width := 641 + AddedWidth;
  Image1.Height := 641 + (Height - 744);
  Image1.Top := 45;
  Image1.Left := 0;
  ImageSize_Label.Caption := Format('%0dx%0d',[Image1.Width,Image1.Height]);
  LastImageWidth := Image1.Width;
  LastImageHeight := Image1.Height;

{
  Image1.Canvas.Brush.Color := clRed;
  Image1.Canvas.Brush.Style := bsSolid;
  Image1.Canvas.FillRect(Rect(0,0,Width,Height));
}
end;

procedure TLTVT_Form.DrawLimb_MainMenuItemClick(Sender: TObject);
var
  Theta : Extended;
  SubObsPoint, SubSolPoint : TPolarCoordinates;
begin
  if DrawingMode=EarthView then
    begin
      ShowMessage('This tool is not intended for use with Earth images');
      Exit;
    end;

  if not CalculateSubPoints(DateTimeToModifiedJulianDate(DateOf(Date_DateTimePicker.Date) + TimeOf(Time_DateTimePicker.Time)),
    ExtendedValue(ObserverLongitudeText),ExtendedValue(ObserverLatitudeText),ExtendedValue(ObserverElevationText),
    SubObsPoint,SubSolPoint) then exit;

  Theta := ArcCos(MoonRadius*OneKm/OneAU/ObserverToMoonAU);  // angle from sub-observer point to limb [rad]

  with CircleDrawing_Form do
    begin
      LonDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubObsPoint.Longitude)]);
      LatDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubObsPoint.Latitude)]);
      Diam_LabeledNumericEdit.NumericEdit.Text := Format('%0.1f',[2*Theta*MoonRadius]);
      DrawCircle_Button.Click;
    end;
end;

procedure TLTVT_Form.DrawRuklGrid_MainMenuItemClick(Sender: TObject);
{note: this is a simplified routine that works only for a zero libration view}
var
  I : Integer;
  X, Y : Extended;
  WantRuklSubgrid : Boolean;
begin
  if not ((SubObs_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue=0)
   and (SubObs_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue=0))
     and (MessageDlg('Rükl grid is valid only for zero libration views',mtWarning,mbOKCancel,0)=mrCancel) then
       Exit;

  WantRuklSubgrid := not H_Terminator_Goto_Form.Center_RadioButton.Checked; // assume subgrid is wanted only after a GoTo to a quadrant

  with Image1 do
    begin
      with Canvas do
        begin
          Pen.Color := clWhite;

          X := -1;
          for I := 1 to (NumRuklCols+1) do
            begin
              Pen.Style := psSolid;
              MoveTo(XPix(X),YPix(1));
              LineTo(XPix(X),YPix(-1));    // note: LineTo stops short of destination by 1 pixel

              if WantRuklSubgrid then
                begin
                  X := X + RuklXiStep/2;
                  Pen.Style := psDashDot;
                  MoveTo(XPix(X),YPix(1));
                  LineTo(XPix(X),YPix(-1));    // note: LineTo stops short of destination by 1 pixel
                  X := X + RuklXiStep/2;
                end
              else
                X := X + RuklXiStep;

            end;

          Y := 1;
          for I := 1 to (NumRuklCols+1) do
            begin
              Pen.Style := psSolid;
              MoveTo(XPix(-1),YPix(Y));
              LineTo(XPix(1),YPix(Y));    // note: LineTo stops short of destination by 1 pixel

              if WantRuklSubgrid then
                begin
                  Y := Y - RuklEtaStep/2;
                  Pen.Style := psDashDot;
                  MoveTo(XPix(-1),YPix(Y));
                  LineTo(XPix(1),YPix(Y));    // note: LineTo stops short of destination by 1 pixel
                  Y := Y - RuklEtaStep/2;
                end
              else
                  Y := Y - RuklEtaStep;
            end;

          Pen.Style := psSolid; // probably not necessary if other routines set desired style

        end;
    end;
end;

procedure TLTVT_Form.Image_PopupMenuPopup(Sender: TObject);

  procedure SetItems(const DesiredState : Boolean);
    begin
      MouseOptions_RightClickMenuItem.Visible := DesiredState;
      DrawLinesToPoleAndSun_RightClickMenuItem.Visible := DesiredState;
//      Goto_RightClickMenuItem.Visible := DesiredState;
      IdentifyNearestFeature_RightClickMenuItem.Visible := DesiredState;
      LabelFeatureAndSatellites_RightClickMenuItem.Visible := DesiredState;
      LabelNearestDot_RightClickMenuItem.Visible := DesiredState;
      CountDots_RightClickMenuItem.Visible := DesiredState;
      DrawCircle_RightClickMenuItem.Visible := DesiredState;
      SetRefPt_RightClickMenuItem.Visible := DesiredState;
      NearestDotToReferencePoint_RightClickMenuItem.Visible := DesiredState;
      Recordshadowmeasurement_RightClickMenuItem.Visible := DesiredState;
    end;
    
begin
  if DrawingMode=EarthView then
    SetItems(False)  // hide most options
  else
    begin
      SetItems(True);  // make same options visible
      Recordshadowmeasurement_RightClickMenuItem.Visible :=
        (RefPtReadoutMode=ShadowLengthRefPtMode) or (RefPtReadoutMode=InverseShadowLengthRefPtMode);
    end;
end;

procedure TLTVT_Form.ShowEarth_MainMenuItemClick(Sender: TObject);
var
  UT_MJD : extended;
  SubLunar, SubSolar : TPolarCoordinates;
  TempPicture : TPicture;
  ScaledMap : TBitMap;

  MapPtr : ^TBitmap;

  i, j,                {screen coords}
  RawXPix, RawYPix  : Integer;

  Lat, Lon,            {selenographic latitude, longitude [radians]}
  MinLon, MaxLon, MinLat, MaxLat,  {of TextureMap}
  XPixPerRad, YPixPerRad,  {of TextureMap}
  Y  : Extended;

  RawRow, ScaledRow  :  pRGBArray;

  SkyPixel, NoDataPixel : TRGBTriple;

function GeographicLatitude(const VectorLatitude : Extended) : Extended;
  const
  // WGS-84 values from http://www.movable-type.co.uk/scripts/latlong-vincenty.html
  // for others see http://en.wikipedia.org/wiki/Figure_of_the_Earth
    a = 6378137.0;    // [km]
    b = 6356752.3142;
    ab_ratio_sqrd = (a*a)/(b*b);
  begin
    if VectorLatitude>=PiByTwo then
      Result := PiByTwo
    else if VectorLatitude<=-PiByTwo then
      Result := -PiByTwo
    else
    // formula verified at  http://bse.unl.edu/adamchuk/web_ssm/web_GPS_eq.html
      Result := ArcTan(ab_ratio_sqrd*Tan(VectorLatitude));
  end;

begin {TLTVT_Form.ShowEarth_MainMenuItemClick}
  ImageDate := DateOf(Date_DateTimePicker.Date);
  ImageTime := TimeOf(Time_DateTimePicker.Time);

// Note time correction is needed to make results agree with JPL Ephemeris and maximum zenith elevation in mouseover
  UT_MJD := DateTimeToModifiedJulianDate(ImageDate + ImageTime) - 1.5*OneMinute/OneDay; // add empirical time correction

  if not EphemerisDataAvailable(UT_MJD) then
    begin
      ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
      Exit;
    end;

  SubLunar := SubLunarPointOnEarth(UT_MJD);
  SubSolar := SubSolarPointOnEarth(UT_MJD);

  PolarToVector(SubLunar.Longitude,SubLunar.Latitude,1,SubObsvrVector);
  PolarToVector(SubSolar.Longitude,SubSolar.Latitude,1,SubSolarVector);

  with SubLunar do   // for labeling if image is saved
    begin
      ImageSubObsLon := Longitude;
      ImageSubObsLat := GeographicLatitude(Latitude);
    end;

  with SubSolar do
    begin
      ImageSubSolLon := Longitude;
      ImageSubSolLat := GeographicLatitude(Latitude);
    end;

{
  ShowMessage(Format('Sun at %0.3f, %0.3f (%0.3f)'+CR+'Moon at %0.3f, %0.3f (%0.3f)',
    [RadToDeg(SubSolar.Longitude),RadToDeg(SubSolar.Latitude),RadToDeg(GeographicLatitude(SubSolar.Latitude)),
    RadToDeg(SubLunar.Longitude),RadToDeg(SubLunar.Latitude),RadToDeg(GeographicLatitude(SubLunar.Latitude))]));
}

  PolarToVector(SubLunar.Longitude, GeographicLatitude(SubLunar.Latitude), 1, ZPrime_UnitVector); {sub-observer point}

  NormalizeVector(ZPrime_UnitVector);

  CrossProduct(Uy,ZPrime_UnitVector,XPrime_UnitVector);
  if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to Uy (looking from over north or south pole)
  NormalizeVector(XPrime_UnitVector);
  CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);

  ClearImage;

  SkyPixel := ColorToRGBTriple(SkyColor);
  NoDataPixel := ColorToRGBTriple(NoDataColor);

  if not Earth_Texture_Loaded then
    begin
      OldFilename := EarthTextureFilename;
      Earth_TextureMap := TBitmap.Create;

      if (not FileExists(EarthTextureFilename)) and (MessageDlg('LTVT cannot find the Earth texture map'+CR
                        +'   Do you want help with this?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(EarthTextureFilename) or PictureFileFound('Earth Texture File','land_shallow_topo_2048.jpg',EarthTextureFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          ThreeD_CheckBox.Hide;
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TempPicture.OnProgress := ImageLoadProgress;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(EarthTextureFilename);
              if LinuxCompatibilityMode then
                begin
                  Earth_TextureMap.Width  := TempPicture.Graphic.Width;
                  Earth_TextureMap.Height := TempPicture.Graphic.Height;
                  Earth_TextureMap.PixelFormat := pf24bit;
                  Earth_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  Earth_TextureMap.Assign(TempPicture.Graphic);
                  Earth_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              Earth_Texture_Loaded := true;
            EXCEPT
              ShowMessage('Unable to load "'+EarthTextureFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            ThreeD_CheckBox.Show;
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if EarthTextureFilename<>OldFilename then FileSettingsChanged := True;
    end;

  MapPtr := @Earth_TextureMap;
  TextureFilename := EarthTextureFilename;

  if MapPtr=nil then
    begin
      ShowMessage('No texture map loaded -- drawing map in Dots mode');
      DrawDots_Button.Click;
    end
  else
    begin
      DrawingMap_Label.Caption := 'Drawing texture map...';
      Screen.Cursor := crHourGlass;
      ProgressBar1.Max := Image1.Height-1;
      ProgressBar1.Step := 1;
      ProgressBar1.Show;
      DrawCircles_CheckBox.Hide;
      MarkCenter_CheckBox.Hide;
      ThreeD_CheckBox.Hide;
      Application.ProcessMessages;

      MinLon := DegToRad(-180);
      MaxLon := DegToRad(180);
      MinLat := DegToRad(-90);
      MaxLat := DegToRad(90);

      XPixPerRad := MapPtr^.Width/(MaxLon - MinLon);
      YPixPerRad := MapPtr^.Height/(MaxLat - MinLat);

      with Image1 do
        begin
          if Width>Height then
            SetRange(-Width/Height,Width/Height,-1,1)
          else
            SetRange(-1,1,-Height/Width,Height/Width);
        end;

//      ShowMessage(Format('Min lon: %0.3f  Max Lon: %0.3f  ppd: %0.3f',[RadToDeg(MinLon),RadToDeg(MaxLon),XPixPerRad*DegToRad(1)]));

      ScaledMap := TBitmap.Create;
      ScaledMap.PixelFormat := pf24bit;
      ScaledMap.Height := Image1.Height;
      ScaledMap.Width := Image1.Width;

      for j := 0 to Image1.Height-1 do with Image1 do
        begin
    //      Application.ProcessMessages;
          ProgressBar1.StepIt;
          Y := YValue(j);
          ScaledRow := ScaledMap.ScanLine[j];

          for i := 0 to Image1.Width-1 do
            begin
              if ConvertXYtoLonLat(XValue(i),Y,Lon,Lat) then {point is inside circle, want to draw}
                begin
                      RawXPix := Trunc((Lon - MinLon)*XPixPerRad);
                      RawYPix := Trunc((MaxLat - Lat)*YPixPerRad);

                   // wrap around if necessary
                      while RawXPix<0 do RawXPix := RawXPix + MapPtr^.Width;
                      while RawXPix>(MapPtr^.Width-1) do RawXPix := RawXPix - MapPtr^.Width;
                      while RawYPix<0 do RawYPix := RawYPix + MapPtr^.Height;
                      while RawYPix>(MapPtr^.Height-1) do RawYPix := RawYPix - MapPtr^.Height;

                      RawRow := MapPtr^.ScanLine[RawYPix];
                      ScaledRow[i] := RawRow[RawXPix];
                      GammaCorrectPixelValue(ScaledRow[i],ImageGamma);
                end
              else if SkyColor<>clWhite then
                begin
                  ScaledRow[i] := SkyPixel;  // generates background of specified color outside image area
                end;
            end;

        end;

      Image1.Canvas.Draw(0,0,ScaledMap);

      ScaledMap.Free;

      DrawCircle(RadToDeg(SubSolar.Longitude),RadToDeg(SubSolar.Latitude),RadToDeg(Pi/2-SunRad),clRed); // Evening terminator
      DrawCircle(RadToDeg(SubSolar.Longitude),RadToDeg(SubSolar.Latitude),RadToDeg(Pi/2+SunRad),clBlue); // Morning terminator

      MarkXY(0,0,ReferencePointColor);

      ProgressBar1.Hide;
      DrawCircles_CheckBox.Show;
      MarkCenter_CheckBox.Show;
      ThreeD_CheckBox.Show;
      DrawingMap_Label.Caption := '';
      Screen.Cursor := DefaultCursor;

      DrawingMode := EarthView;
    end;


end;  {TLTVT_Form.ShowEarth_MainMenuItemClick}

function TLTVT_Form.EphemerisDataAvailable(const MJD : Extended) : Boolean;
var
  JED : Extended;

  procedure LookForJPLFile;
    var
      JPL_Year : integer;
    begin  // try to silently load another file
      JPL_Year := Round(YearOf(Date_DateTimePicker.Date));
      FindAndLoadJPL_File(JPL_FilePath+'UNXP'+IntToStr(50*(JPL_Year div 50))+'.405');
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

begin {TLTVT_Form.EphemerisDataAvailable}
  Result := False;

  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  JED := MJD + MJDOffset;

  if EphemerisFileLoaded and ((JED<SS[1]) or (JED>SS[2])) then
  {JED = requested Julian date;  SS[1] = start date of file; SS[2] = end date of file}
    LookForJPLFile;

  if EphemerisFileLoaded and ((JED<SS[1]) or (JED>SS[2])) then
    begin // ask for assistance only if necessary
      if MessageDlg(format('Unable to estimate geometry: requested date is not within ephemeris file limits of %0s to %0s',
        [DateToStr(JulianDateToDateTime(SS[1])),DateToStr(JulianDateToDateTime(SS[2]))])
        +' Load a different JPL file?',mtConfirmation,mbOKCancel,0)=mrOK then
        LookForJPLFile
      else
        Exit;
    end;

  if (not EphemerisFileLoaded) or ((JED<SS[1]) or (JED>SS[2])) then
    begin
//      ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
      Exit;
    end;

  Result := True;

end;   {TLTVT_Form.EphemerisDataAvailable}

procedure TLTVT_Form.DisplayF1Help(const PressedKey : Word; const ShiftState : TShiftState; const HelpFileName : String);
{launches .chm help on indicated page if PressedKey=F1}
type
  TFormList = (PhotoCalibratorForm, SatellitePhotoCalibratorForm, LTO_ViewerForm,
    MoonEventPredictorForm, LibrationTabulatorForm, PhotosessionSearchForm, Unknown);
const
  LastCallingForm : TFormList = Unknown;
begin
  if PressedKey=VK_F1 then HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/'+HelpFileName),HH_DISPLAY_TOPIC, 0);
  if (ssCtrl in ShiftState) and (PressedKey=VK_TAB) then
    begin //  CTRL-Tab pressed
      if not LTVT_Form.Active then
        begin
          if PhotoCalibrator_Form.Active then
            LastCallingForm := PhotoCalibratorForm
          else if SatellitePhotoCalibrator_Form.Active then
            LastCallingForm := SatellitePhotoCalibratorForm
          else if LTO_Viewer_Form.Active then
            LastCallingForm := LTO_ViewerForm
          else if MoonEventPredictor_Form.Active then
            LastCallingForm := MoonEventPredictorForm
          else if LibrationTabulator_Form.Active then
            LastCallingForm := LibrationTabulatorForm
          else if PhotosessionSearch_Form.Active then
            LastCallingForm := PhotosessionSearchForm;

          LTVT_Form.Show
        end
      else // LTVT_Form active
        begin
          case LastCallingForm of
            PhotoCalibratorForm :    PhotoCalibrator_Form.Show;
            SatellitePhotoCalibratorForm : SatellitePhotoCalibrator_Form.Show;
            LTO_ViewerForm :         LTO_Viewer_Form.Show;
            MoonEventPredictorForm : MoonEventPredictor_Form.Show;
            LibrationTabulatorForm : LibrationTabulator_Form.Show;
            PhotosessionSearchForm : PhotosessionSearch_Form.Show;
            Unknown :
              begin
                if PhotoCalibrator_Form.Visible then
                  PhotoCalibrator_Form.Show
                else if SatellitePhotoCalibrator_Form.Visible then
                  SatellitePhotoCalibrator_Form.Show
                else if LTO_Viewer_Form.Visible then
                  LTO_Viewer_Form.Show
                else if MoonEventPredictor_Form.Visible then
                  MoonEventPredictor_Form.Show
                else if LibrationTabulator_Form.Visible then
                  MoonEventPredictor_Form.Show
                else if PhotosessionSearch_Form.Visible then
                  PhotosessionSearch_Form.Show;
              end;
            end; {case}
        end;
    end;
end;

procedure TLTVT_Form.Abort_ButtonClick(Sender: TObject);
begin
  AbortDrawing := True;
end;

procedure TLTVT_Form.Now_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Current_UT');
end;

procedure TLTVT_Form.Date_DateTimePickerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=27 then with Terminator_SetYear_Form do
    begin
      ShowModal;
      if SetYearRequested then
        Date_DateTimePicker.DateTime :=
          EncodeDate(DesiredYear_LabeledNumericEdit.NumericEdit.IntegerValue,
            MonthOf(Date_DateTimePicker.DateTime),DayOf(Date_DateTimePicker.DateTime));
    end
  else
    DisplayF1Help(Key,Shift,'MainForm.htm#Date_Time');
end;

procedure TLTVT_Form.Time_DateTimePickerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Date_Time');
end;

procedure TLTVT_Form.SetLocation_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Set_Location');
end;

procedure TLTVT_Form.EstimateData_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Compute_Geometry');
end;

procedure TLTVT_Form.SubObs_Lon_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubObserver_Location');
end;

procedure TLTVT_Form.SubObs_Lat_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubObserver_Location');
end;

procedure TLTVT_Form.SubSol_Lon_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubSolar_Location');
end;

procedure TLTVT_Form.SubSol_Lat_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubSolar_Location');
end;

procedure TLTVT_Form.CraterThreshold_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Feature_Threshold');
end;

procedure TLTVT_Form.DrawDots_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Dots');
end;

procedure TLTVT_Form.DrawTexture_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Texture');
end;

procedure TLTVT_Form.OverlayDots_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Overlay_Dots');
end;

procedure TLTVT_Form.LabelDots_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Label');
end;

procedure TLTVT_Form.LoResUSGS_RadioButtonKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TLTVT_Form.HiResUSGS_RadioButtonKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TLTVT_Form.Clementine_RadioButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TLTVT_Form.UserPhoto_RadioButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TLTVT_Form.LTO_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TLTVT_Form.Gamma_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Gamma');
end;

procedure TLTVT_Form.Zoom_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Zoom');
end;

procedure TLTVT_Form.ResetZoom_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Reset');
end;

procedure TLTVT_Form.SaveImage_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Save_Image');
end;

procedure TLTVT_Form.Predict_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Predict');
end;

procedure TLTVT_Form.SearchPhotoSessions_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Search_for_Photos');
end;

procedure TLTVT_Form.RotationAngle_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Rotation');
end;

procedure TLTVT_Form.GridSpacing_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Grid');
end;

procedure TLTVT_Form.DrawCircles_CheckBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Circles');
end;

procedure TLTVT_Form.MarkCenter_CheckBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#MarkCenter');
end;

procedure TLTVT_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm');
end;

procedure TLTVT_Form.DrawDEM_ButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#DrawDEM');
end;

procedure TLTVT_Form.ThreeD_CheckBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#DrawDEM');
end;

procedure TLTVT_Form.Help_RightClickMenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/MainForm.htm#Right_Click_Menu'),HH_DISPLAY_TOPIC, 0);
end;

procedure TLTVT_Form.CountDots_RightClickMenuItemClick(
  Sender: TObject);
begin
  ShowMessage('Number of dots in current display: '+IntToStr(Length(CraterInfo)));
end;

end.
