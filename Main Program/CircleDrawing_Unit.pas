unit CircleDrawing_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, StdCtrls, ExtCtrls;

type
  TCircleDrawing_Form = class(TForm)
    Diam_LabeledNumericEdit: TLabeledNumericEdit;
    LonDeg_LabeledNumericEdit: TLabeledNumericEdit;
    LatDeg_LabeledNumericEdit: TLabeledNumericEdit;
    Circle_ColorBox: TColorBox;
    DrawCircle_Button: TButton;
    ClearCircle_Button: TButton;
    Close_Button: TButton;
    ShowCenter_CheckBox: TCheckBox;
    Label1: TLabel;
    Record_Button: TButton;
    InitiateShadowFile_Button: TButton;
    procedure DrawCircle_ButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearCircle_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LonDeg_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure LatDeg_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Diam_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Circle_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawCircle_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClearCircle_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Close_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Close_ButtonClick(Sender: TObject);
    procedure Record_ButtonClick(Sender: TObject);
    procedure Record_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InitiateShadowFile_ButtonClick(Sender: TObject);
    procedure InitiateShadowFile_ButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    SavedImage : TBitMap;

    procedure ProcessKeyStroke(const Key: Word; const Shift: TShiftState; const HelpFile : String);

  end;

var
  CircleDrawing_Form: TCircleDrawing_Form;

implementation

{$R *.dfm}

uses LTVT_Unit, MPVectors, Math;

procedure TCircleDrawing_Form.FormShow(Sender: TObject);
begin
  if SavedImage<>nil then SavedImage.Free; 
  SavedImage := TBitmap.Create;
  SavedImage.Assign(LTVT_Form.Image1.Picture.Bitmap);
  ActiveControl := DrawCircle_Button;
end;

procedure TCircleDrawing_Form.Close_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TCircleDrawing_Form.DrawCircle_ButtonClick(Sender: TObject);
var
  LonDeg, LatDeg, RadiusDeg : Extended;
  CenterVector : TVector;
  CenterXPix, CenterYPix {, DotRadius, DotRadiusSqrd, XOffset, YOffset} : Integer;

begin
  LonDeg := LonDeg_LabeledNumericEdit.NumericEdit.ExtendedValue;
  LatDeg := LatDeg_LabeledNumericEdit.NumericEdit.ExtendedValue;
  RadiusDeg := RadToDeg(Diam_LabeledNumericEdit.NumericEdit.ExtendedValue/LTVT_Form.MoonRadius/2);

  with LTVT_Form do
    begin
      DrawCircle(LonDeg,LatDeg,RadiusDeg, Circle_ColorBox.Selected);

      PolarToVector(DegToRad(LonDeg),DegToRad(LatDeg),1,CenterVector);
      if DotProduct(CenterVector,SubObsvrVector)>=0 then with Image1 do
        begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
          CenterXPix := XPix(DotProduct(CenterVector,XPrime_UnitVector));
          CenterYPix := YPix(DotProduct(CenterVector,YPrime_UnitVector));

// represent center with plus mark
          if ShowCenter_CheckBox.Checked then DrawCross(CenterXPix,CenterYPix,DotSize,Circle_ColorBox.Selected);

{// represent center with dot:
          DotRadius := Round(DotSize/2.0 + 0.5);
          if DotSize=0 then
            DotRadiusSqrd := -1  // prevents drawing any dots
          else
            DotRadiusSqrd := Round(Sqr(DotSize/2.0));

          CenterXPix := XPix(CenterX);
          CenterYPix := YPix(CenterY);
          with Canvas do
            begin
              for XOffset := -DotRadius to DotRadius do
                for YOffset := -DotRadius to DotRadius do
                  if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                    Pixels[CenterXPix+XOffset, CenterYPix+YOffset] := Circle_ColorBox.Selected;
            end;
}
        end;
    end;
end;

procedure TCircleDrawing_Form.ClearCircle_ButtonClick(Sender: TObject);
begin
  LTVT_Form.Image1.Canvas.Draw(0,0,SavedImage);
end;

procedure TCircleDrawing_Form.LonDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  LonDeg, CosLatDeg, OnePixel, StepSize : Extended;
  Digits : Integer;
  FormatString : String;
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');

  with LTVT_Form do
    begin
      OnePixel := (180/Pi)*(XValue(Image1.Width)-XValue(0))/Image1.Width;
      StepSize := Abs(OnePixel);
    end;

  CosLatDeg := Cos(DegToRad(LatDeg_LabeledNumericEdit.NumericEdit.ExtendedValue));
  if CosLatDeg=0 then
    StepSize := 1
  else
    StepSize := StepSize/CosLatDeg;

  Digits := 1 + Trunc(-Ln(StepSize)/Ln(10));
  if Digits<0 then Digits := 0;

  FormatString := '%0.'+IntToStr(Digits)+'f';

  if (ssShift in Shift) then StepSize := 5*StepSize;

  case Key of
  VK_UP :
    begin
      LonDeg := LonDeg_LabeledNumericEdit.NumericEdit.ExtendedValue + StepSize;
      LonDeg_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[LonDeg]);
      ClearCircle_Button.Click;
      DrawCircle_Button.Click;
    end;
  VK_DOWN :
    begin
      LonDeg := LonDeg_LabeledNumericEdit.NumericEdit.ExtendedValue - StepSize;
      LonDeg_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[LonDeg]);
      ClearCircle_Button.Click;
      DrawCircle_Button.Click;
    end;
  else
  end;
end;

procedure TCircleDrawing_Form.LatDeg_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  LatDeg, OnePixel, StepSize : Extended;
  Digits : Integer;
  FormatString : String;
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');

  with LTVT_Form do
    begin
      OnePixel := (180/Pi)*(XValue(Image1.Width)-XValue(0))/Image1.Width;
      StepSize := Abs(OnePixel);
    end;

  Digits := 1 + Trunc(-Ln(StepSize)/Ln(10));
  if Digits<0 then Digits := 0;

  FormatString := '%0.'+IntToStr(Digits)+'f';

  if (ssShift in Shift) then StepSize := 5*StepSize;

  case Key of
  VK_UP :
    begin
      LatDeg := LatDeg_LabeledNumericEdit.NumericEdit.ExtendedValue + StepSize;
      if LatDeg>90 then LatDeg := 90;
      LatDeg_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[LatDeg]);
      ClearCircle_Button.Click;
      DrawCircle_Button.Click;
    end;
  VK_DOWN :
    begin
      LatDeg := LatDeg_LabeledNumericEdit.NumericEdit.ExtendedValue - StepSize;
      if LatDeg<-90 then LatDeg := -90;
      LatDeg_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[LatDeg]);
      ClearCircle_Button.Click;
      DrawCircle_Button.Click;
    end;
  else
  end;
end;

procedure TCircleDrawing_Form.Diam_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Diam, OnePixel, StepSize : Extended;
  Digits : Integer;
  FormatString : String;
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');

  with LTVT_Form do
    begin
      OnePixel := 2*MoonRadius*(XValue(Image1.Width)-XValue(0))/Image1.Width;
      StepSize := Abs(OnePixel);
    end;

  Digits := 1 + Trunc(-Ln(StepSize)/Ln(10));
  if Digits<0 then Digits := 0;

  FormatString := '%0.'+IntToStr(Digits)+'f';

  if (ssShift in Shift) then StepSize := 5*StepSize;

  case Key of
  VK_UP :
    begin
      Diam := Diam_LabeledNumericEdit.NumericEdit.ExtendedValue + StepSize;
      Diam_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[Diam]);
      ClearCircle_Button.Click;
      DrawCircle_Button.Click;
    end;
  VK_DOWN :
    begin
      Diam := Diam_LabeledNumericEdit.NumericEdit.ExtendedValue - StepSize;
      Diam_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[Diam]);
      ClearCircle_Button.Click;
      DrawCircle_Button.Click;
    end;
  else
  end;
end;

procedure TCircleDrawing_Form.Record_ButtonClick(Sender: TObject);
var
  OutputFilename : String;
  OutputFile : TextFile;
begin
  OutputFilename := LTVT_Form.BasePath+'CircleList.txt';
  AssignFile(OutputFile,OutputFilename);
  if FileExists(OutputFilename) then
    Append(OutputFile)
  else
    begin
      Rewrite(OutputFile);
      Writeln(OutputFile,'USGS1  <-- please do not disturb this line.  The file must begin with these five characters.');
      Writeln(OutputFile);
      Writeln(OutputFile,'* This is a list of positions and diameters recorded with the LTVT Circle Drawing Tool');
      Writeln(OutputFile,'* It is in LTVT dot file format.');
      Writeln(OutputFile,'* The circle names, flag field, and feature type code can be edited with any text processor.');
      Writeln(OutputFile,'* A non-blank character in the Flag Field causes the dot to display when the feature size threshold is set to -1.');
      Writeln(OutputFile);
      Writeln(OutputFile,'* Flag Field, Name, Latitude [deg N], Longitude [deg E], Diam [km], FT [USGS feature type code]');
    end;

  Writeln(OutputFile,'x, 1, '+LatDeg_LabeledNumericEdit.NumericEdit.Text+', '
    +LonDeg_LabeledNumericEdit.NumericEdit.Text+', '+Diam_LabeledNumericEdit.NumericEdit.Text+', AA');

  CloseFile(OutputFile);
end;

procedure TCircleDrawing_Form.ProcessKeyStroke(const Key: Word; const Shift: TShiftState; const HelpFile : String);
begin
  if Key=VK_ESCAPE then
    Close
  else
    LTVT_Form.DisplayF1Help(Key,Shift,HelpFile);
end;

procedure TCircleDrawing_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');
end;

procedure TCircleDrawing_Form.Circle_ColorBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');
end;

procedure TCircleDrawing_Form.DrawCircle_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');
end;

procedure TCircleDrawing_Form.ClearCircle_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');
end;

procedure TCircleDrawing_Form.Close_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm');
end;

procedure TCircleDrawing_Form.Record_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm#Record_Button');
end;

procedure TCircleDrawing_Form.InitiateShadowFile_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ProcessKeyStroke(Key,Shift,'CircleDrawingTool.htm#Record_Button');
end;

procedure TCircleDrawing_Form.InitiateShadowFile_ButtonClick(Sender: TObject);
var
  ShadowFile : TextFile;
begin
  if FileExists(LTVT_Form.ShadowProfileFilename) and
    (mrNO=MessageDlg('Overwrite existing shadow profile?',mtConfirmation,[mbYes,mbNo],0)) then Exit;

  LTVT_Form.PolarToVector(DegToRad(LonDeg_LabeledNumericEdit.NumericEdit.ExtendedValue),
    DegToRad(LatDeg_LabeledNumericEdit.NumericEdit.ExtendedValue), 1, LTVT_Form.ShadowProfileCenterVector);

  AssignFile(ShadowFile, LTVT_Form.ShadowProfileFilename);
  Rewrite(ShadowFile);

  Writeln(ShadowFile,'* Crater profile -- distances referenced to point at');
  Writeln(ShadowFile,'*  Lon : '+LonDeg_LabeledNumericEdit.NumericEdit.Text+
    '  Lat : '+LatDeg_LabeledNumericEdit.NumericEdit.Text);
  Writeln(ShadowFile,'');
  Writeln(ShadowFile,Format('Crater radius = %0.3f',[Diam_LabeledNumericEdit.NumericEdit.ExtendedValue/2]));
  Writeln(ShadowFile,'');
  Writeln(ShadowFile,'* Distance, Elev. Difference, Start Lon, Start Lat, End Lon, End Lat, PhotoID ');
  Writeln(ShadowFile,Format('%0.3f, 0',[Diam_LabeledNumericEdit.NumericEdit.ExtendedValue/2]));

  CloseFile(ShadowFile);

  ShowMessage('Ready to record shadow data in file : '+LTVT_Form.ShadowProfileFilename);

end;

end.
