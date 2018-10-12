unit H_Terminator_Goto_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LabeledNumericEdit;

type
  TH_Terminator_Goto_Form = class(TForm)
    SetToLon_LabeledNumericEdit: TLabeledNumericEdit;
    SetToLat_LabeledNumericEdit: TLabeledNumericEdit;
    GoTo_Button: TButton;
    Cancel_Button: TButton;
    FeatureNames_ComboBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    AerialView_Button: TButton;
    MarkFeature_Button: TButton;
    LonLat_GroupBox: TGroupBox;
    LonLat_RadioButton: TRadioButton;
    XY_RadioButton: TRadioButton;
    XY_GroupBox: TGroupBox;
    CenterX_LabeledNumericEdit: TLabeledNumericEdit;
    CenterY_LabeledNumericEdit: TLabeledNumericEdit;
    LTOZone_Label: TLabel;
    Label3: TLabel;
    RuklZone_Label: TLabel;
    MinimizeGotoList_CheckBox: TCheckBox;
    XY_Redraw_Button: TButton;
    procedure FormShow(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectFeature_ButtonClick(Sender: TObject);
    procedure AerialView_ButtonClick(Sender: TObject);
    procedure GoTo_ButtonClick(Sender: TObject);
    procedure FeatureNames_ComboBoxSelect(Sender: TObject);
    procedure MarkFeature_ButtonClick(Sender: TObject);
    procedure LonLat_RadioButtonClick(Sender: TObject);
    procedure XY_RadioButtonClick(Sender: TObject);
    procedure LonLat_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure XY_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CenterX_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure CenterY_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FeatureNames_ComboBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SelectFeature_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetToLon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SetToLat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MarkFeature_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GoTo_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AerialView_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetToLon_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure SetToLat_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure MinimizeGotoList_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure MinimizeGotoList_CheckBoxClick(Sender: TObject);
    procedure XY_Redraw_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure XY_Redraw_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GoToState : (Mark, Center, AerialView, Cancel);
// following items are to be populated by calling program, for use in FeatureNames_ComboBox
    FeatureNameList, FeatureLatStringList, FeatureLonStringList : TStrings;
    LastItemSelected : integer;

    procedure SelectCurrentItem;
    procedure UpdateMapZone;
  end;

var
  H_Terminator_Goto_Form: TH_Terminator_Goto_Form;

implementation

uses LTVT_Unit, MVectors, Math, Win_Ops, JimsGraph;

{$R *.dfm}

procedure TH_Terminator_Goto_Form.FormCreate(Sender: TObject);
begin
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  FeatureNameList := TStringList.Create;
  FeatureLatStringList := TStringList.Create;
  FeatureLonStringList := TStringList.Create;
  LastItemSelected := 0;
end;

procedure TH_Terminator_Goto_Form.FormDestroy(Sender: TObject);
begin
  FeatureNameList.Free;
  FeatureLatStringList.Free;
  FeatureLonStringList.Free;
end;

procedure TH_Terminator_Goto_Form.FormShow(Sender: TObject);
begin
  GoToState := Cancel;

  LonLat_GroupBox.Visible := LonLat_RadioButton.Checked;
  XY_GroupBox.Visible := XY_RadioButton.Checked;
  UpdateMapZone;
end;

procedure TH_Terminator_Goto_Form.AerialView_ButtonClick(Sender: TObject);
begin
  GoToState := AerialView;
  Close;
end;

procedure TH_Terminator_Goto_Form.Cancel_ButtonClick(Sender: TObject);
begin
  GoToState := Cancel;
  Close;
end;

procedure TH_Terminator_Goto_Form.SelectCurrentItem;
begin
  with FeatureNames_ComboBox do if ItemIndex>=0 then
    begin
//      Text := FeatureNameList[ItemIndex];
      SetToLon_LabeledNumericEdit.NumericEdit.Text := FeatureLonStringList[ItemIndex];
      SetToLat_LabeledNumericEdit.NumericEdit.Text := FeatureLatStringList[ItemIndex];
      UpdateMapZone;
      LastItemSelected := ItemIndex;
    end
  else
    ShowMessage('Please try again:  you must click on an item in the list');
end;

procedure TH_Terminator_Goto_Form.SelectFeature_ButtonClick(Sender: TObject);
begin
  SelectCurrentItem
end;

procedure TH_Terminator_Goto_Form.FeatureNames_ComboBoxSelect(Sender: TObject);
begin
  SelectCurrentItem
end;

procedure TH_Terminator_Goto_Form.GoTo_ButtonClick(Sender: TObject);
begin
  GoToState := Center;
  Close;
end;

procedure TH_Terminator_Goto_Form.MarkFeature_ButtonClick(Sender: TObject);
begin
  GoToState := Mark;
  Close;
end;

procedure TH_Terminator_Goto_Form.LonLat_RadioButtonClick(Sender: TObject);
begin
  LonLat_GroupBox.Visible := True;
  XY_GroupBox.Visible := False;
end;

procedure TH_Terminator_Goto_Form.XY_RadioButtonClick(Sender: TObject);
begin
  LonLat_GroupBox.Visible := False;
  XY_GroupBox.Visible := True;
end;

procedure TH_Terminator_Goto_Form.UpdateMapZone;
const
  NumRuklRows = 8;  // Rukl divides Y = +1 to -1 into 8 rows
  NumRuklCols = 11; // and X = -1 to +1 into 11 columns
  RuklCenterCol : array[1..NumRuklRows] of Integer = (4, 12, 22, 33, 44, 55, 65, 73);  // Map number at start of row

  LTOStartCol : array[1..12] of Integer = (1, 2, 10, 22, 37, 55, 73, 91, 109, 124, 136, 144);  // Map number at start of row
  LTOStartLon : array[1..12] of Integer = (0, -80, -80, -86, -90, -90, -90, -90, -86, -80, -80, 0); // longitude at left edge of LTOStartCol
  LTOWidth : array[1..12] of Integer = (360, 45, 30, 24, 20, 20, 20, 20, 24, 30, 45, 360); // width of each block in row

var
  DegLon, DegLat, SectionLat, SectionLon, CornerLon, CornerLat,
  DummyLon, DummyLat : Extended;
  RuklRow, RuklColOffset, RuklNum, LTORow, LTONum,
  LTOQuadNum, LTOSubQuadNum,
  SectionWidth, SectionHeight, LonSteps : Integer;
  FeatureVector : Vector;

  RuklString, LTOString : String;

function InputGood(const InputText : String) : Boolean;
{checks if input box is blank or contains only a punctuation mark}
  var
    TestString : String;
    TestChar : Char;
  begin {InputGood}
    TestString := StrippedString(InputText);

    if Length(TestString)=0 then
      TestChar := '.'
    else if Length(TestString)=1 then
      TestChar := Char(InputText[1])
    else
      TestChar := 'x'; // dummy value not it list

    Result := not (TestChar in ['-','+','.',',']);
  end;  {InputGood}

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
  begin
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
  end;

function MapExists(const MapString : String): Boolean;
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

begin {TH_Terminator_Goto_Form.UpdateMapZone}
  if InputGood(SetToLon_LabeledNumericEdit.NumericEdit.Text)
    and InputGood(SetToLat_LabeledNumericEdit.NumericEdit.Text) then
    begin
      DegLon := SetToLon_LabeledNumericEdit.NumericEdit.ExtendedValue;
      DegLat := SetToLat_LabeledNumericEdit.NumericEdit.ExtendedValue;

      LTVT_Unit.Terminator_Form.PolarToVector(DegToRad(DegLat), DegToRad(DegLon), 1, FeatureVector);
      if FeatureVector.z<0 then
        RuklString := ''
      else
        begin
          RuklRow := Round(((1 - FeatureVector.y)*NumRuklRows + 1)/2);
          RuklColOffset := Round(FeatureVector.x*NumRuklCols/2);
          if RuklRow<1 then
            RuklRow := 1
          else if RuklRow>NumRuklRows then
            RuklRow := NumRuklRows;

          RuklNum := RuklCenterCol[RuklRow] + RuklColOffset;

          RuklString := 'Rükl: '+IntToStr(RuklNum);
        end;

{
      LTORow := Trunc(Abs(DegLat)/16);

      if DegLat>=0 then
        LTORow := 6 - LTORow
      else
        LTORow := 7 + LTORow;

      if LTORow<1 then
        LTORow := 1
      else if LTORow>12 then
        LTORow := 12;
}
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

      LTOString := IntToStr(LTONum)+Char(Ord('A')+LTOQuadNum-1)+IntToStr(LTOSubQuadNum);

      if MapExists(LTOString) then
        LTOZone_Label.Font.Color := clBlack
      else
        LTOZone_Label.Font.Color := clGray;

      LTOZone_Label.Caption := LTOString;
      RuklZone_Label.Caption := RuklString;
    end
  else
    begin
      LTOZone_Label.Caption := '';
      RuklZone_Label.Caption := '';
    end;
end;  {TH_Terminator_Goto_Form.UpdateMapZone}

procedure TH_Terminator_Goto_Form.SetToLon_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  UpdateMapZone;
end;

procedure TH_Terminator_Goto_Form.SetToLat_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  UpdateMapZone;
end;

procedure TH_Terminator_Goto_Form.LonLat_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.XY_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.CenterX_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewValue, OnePixel, StepSize : Extended;
  Digits : Integer;
  FormatString : String;
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');

  with Terminator_Form.JimsGraph1 do
    begin
      OnePixel := (XValue(Terminator_Form.JimsGraph1.Width)-XValue(0))/Terminator_Form.JimsGraph1.Width;
      StepSize := Abs(OnePixel);
    end;

  Digits := 1 + Trunc(-Ln(StepSize)/Ln(10));
  if Digits<1 then Digits := 1;

  FormatString := '%0.'+IntToStr(Digits)+'f';

  if (ssShift in Shift) then StepSize := 3*StepSize;
  if (ssCtrl in Shift)  then StepSize := 9*StepSize;

  case Key of
  VK_UP :
    begin
      NewValue := CenterX_LabeledNumericEdit.NumericEdit.ExtendedValue + StepSize;
      CenterX_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[NewValue]);
      XY_Redraw_Button.Click;
    end;
  VK_DOWN :
    begin
      NewValue := CenterX_LabeledNumericEdit.NumericEdit.ExtendedValue - StepSize;
      CenterX_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[NewValue]);
      XY_Redraw_Button.Click;
    end;
  else
  end;

end;

procedure TH_Terminator_Goto_Form.CenterY_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewValue, OnePixel, StepSize : Extended;
  Digits : Integer;
  FormatString : String;
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');

  with Terminator_Form.JimsGraph1 do
    begin
      OnePixel := (YValue(Terminator_Form.JimsGraph1.Height)-YValue(0))/Terminator_Form.JimsGraph1.Height;
      StepSize := Abs(OnePixel);
    end;

  Digits := 1 + Trunc(-Ln(StepSize)/Ln(10));
  if Digits<1 then Digits := 1;

  FormatString := '%0.'+IntToStr(Digits)+'f';

  if (ssShift in Shift) then StepSize := 3*StepSize;
  if (ssCtrl in Shift)  then StepSize := 9*StepSize;

  case Key of
  VK_UP :
    begin
      NewValue := CenterY_LabeledNumericEdit.NumericEdit.ExtendedValue + StepSize;
      CenterY_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[NewValue]);
      XY_Redraw_Button.Click;
    end;
  VK_DOWN :
    begin
      NewValue := CenterY_LabeledNumericEdit.NumericEdit.ExtendedValue - StepSize;
      CenterY_LabeledNumericEdit.NumericEdit.Text := Format(FormatString,[NewValue]);
      XY_Redraw_Button.Click;
    end;
  else
  end;

end;

procedure TH_Terminator_Goto_Form.FeatureNames_ComboBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_RETURN) or (Key=VK_ESCAPE) then
    begin
//      ShowMessage('Key detected');
//      with FeatureNames_ComboBox do if ItemIndex>=0 then Text := FeatureNameList[ItemIndex];
      with FeatureNames_ComboBox do if ItemIndex<0 then Text := '';
    end
  else
    Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SelectFeature_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SetToLon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SetToLat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.MarkFeature_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.GoTo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.AerialView_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;


procedure TH_Terminator_Goto_Form.MinimizeGotoList_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.MinimizeGotoList_CheckBoxClick(
  Sender: TObject);
begin
  Terminator_Form.RefreshGoToList;
end;

procedure TH_Terminator_Goto_Form.XY_Redraw_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.XY_Redraw_ButtonClick(Sender: TObject);
begin
  GoToState := Center;
  Terminator_Form.GoToXY(CenterX_LabeledNumericEdit.NumericEdit.ExtendedValue,CenterY_LabeledNumericEdit.NumericEdit.ExtendedValue);;
  GoToState := Cancel; // without this, closing form may cause another redraw
end;

end.
