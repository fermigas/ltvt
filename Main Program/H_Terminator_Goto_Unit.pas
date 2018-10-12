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
    LAC_Label: TLabel;
    RuklZone_Label: TLabel;
    MinimizeGotoList_CheckBox: TCheckBox;
    XY_Redraw_Button: TButton;
    RuklZone_RadioButton: TRadioButton;
    RuklZone_GroupBox: TGroupBox;
    Label4: TLabel;
    NW_RadioButton: TRadioButton;
    NE_RadioButton: TRadioButton;
    SW_RadioButton: TRadioButton;
    SE_RadioButton: TRadioButton;
    RuklZone_LabeledNumericEdit: TLabeledNumericEdit;
    Center_RadioButton: TRadioButton;
    Next_Button: TButton;
    AutoLabel_CheckBox: TCheckBox;
    SetToRadius_TLabeledNumericEdit: TLabeledNumericEdit;
    ResetRadius_Button: TButton;
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
    procedure RuklZone_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledNumericEdit2NumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Center_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NW_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NE_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SW_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SE_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RuklZone_RadioButtonClick(Sender: TObject);
    procedure Next_ButtonClick(Sender: TObject);
    procedure Next_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AutoLabel_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetToRadius_TLabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ResetRadius_ButtonClick(Sender: TObject);
    procedure ResetRadius_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    GoToState : (Mark, Center, AerialView, Cancel);
// following items are to be populated by calling program, for use in FeatureNames_ComboBox
    FeatureNameList, FeatureLatStringList, FeatureLonStringList : TStrings;
    LastItemSelected : integer;

    procedure GoToRuklZone_Center(var Xi, Eta, LonDeg, LatDeg : Extended);
    // determines Xi-Eta, and Lon-Lat values at center of current Rukl zone or quadrant

    procedure SelectCurrentItem;
    procedure UpdateMapZone;
    procedure ResetRadius(const DesiredRadius : Extended);
  end;

var
  H_Terminator_Goto_Form: TH_Terminator_Goto_Form;

implementation

uses LTVT_Unit, MPVectors, Math, Win_Ops, JimsGraph, MapFns_Unit;

{$R *.dfm}

procedure TH_Terminator_Goto_Form.FormCreate(Sender: TObject);
begin
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  FeatureNameList := TStringList.Create;
  FeatureLatStringList := TStringList.Create;
  FeatureLonStringList := TStringList.Create;
  LastItemSelected := 0;

  ResetRadius_Button.Click;
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
  RuklZone_GroupBox.Visible := RuklZone_RadioButton.Checked;
  UpdateMapZone;

  SetToRadius_TLabeledNumericEdit.Visible := LTVT_Form.DrawingMode=DEM_3D;
  ResetRadius_Button.Visible := LTVT_Form.DrawingMode=DEM_3D;
end;

procedure TH_Terminator_Goto_Form.ResetRadius(const DesiredRadius : Extended);
begin
  SetToRadius_TLabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[DesiredRadius]);
end;

procedure TH_Terminator_Goto_Form.ResetRadius_ButtonClick(Sender: TObject);
begin
  ResetRadius(LTVT_Form.MoonRadius);
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
  RuklZone_GroupBox.Visible := False;
end;

procedure TH_Terminator_Goto_Form.XY_RadioButtonClick(Sender: TObject);
begin
  LonLat_GroupBox.Visible := False;
  XY_GroupBox.Visible := True;
  RuklZone_GroupBox.Visible := False;
end;

procedure TH_Terminator_Goto_Form.RuklZone_RadioButtonClick(Sender: TObject);
begin
  LonLat_GroupBox.Visible := False;
  XY_GroupBox.Visible := False;
  RuklZone_GroupBox.Visible := True;
end;

procedure TH_Terminator_Goto_Form.GoToRuklZone_Center(var Xi, Eta, LonDeg, LatDeg : Extended);
// determines Xi-Eta, and Lon-Lat values at center of current Rukl zone or quadrant
var
  RuklZone, RuklRow, RuklCount : Integer;
  CenterX, CenterY, X_offset, Y_Offset, RSqrd, Zeta : Extended;
begin
  RuklZone := RuklZone_LabeledNumericEdit.NumericEdit.IntegerValue;
  RuklRow := 1;
  RuklCount := RuklRowLength[RuklRow];
  while (RuklZone>RuklCount) and (RuklRow<NumRuklRows) do
    begin
      Inc(RuklRow);
      RuklCount := RuklCount + RuklRowLength[RuklRow];
    end;

  CenterX := RuklXiStep*(RuklZone - RuklCenterCol[RuklRow]);
  CenterY := -RuklEtaStep*(RuklRow - (NumRuklRows/2 + 0.5));

  if NW_RadioButton.Checked then
    begin
      X_offset := -RuklXiStep/4;
      Y_offset := RuklEtaStep/4;
    end
  else
  if NE_RadioButton.Checked then
    begin
      X_offset := RuklXiStep/4;
      Y_offset := RuklEtaStep/4;
    end
  else
  if SW_RadioButton.Checked then
    begin
      X_offset := -RuklXiStep/4;
      Y_offset := -RuklEtaStep/4;
    end
  else
  if SE_RadioButton.Checked then
    begin
      X_offset := RuklXiStep/4;
      Y_offset := -RuklEtaStep/4;
    end
  else
    begin
      X_offset := 0;
      Y_offset := 0;
    end;

  Xi  := CenterX + X_offset;
  Eta := CenterY + Y_offset;

  RSqrd := Sqr(Xi) + Sqr(Eta);
  if RSqrd>=1 then
    begin
      LonDeg := -999;
      LatDeg := -999;
    end
  else
    begin
      Zeta := Sqrt(1 - RSqrd);
      LonDeg := RadToDeg(ArcTan2(Xi,Zeta));
      LatDeg := RadToDeg(ArcSin(Eta));
    end;
end;

procedure TH_Terminator_Goto_Form.UpdateMapZone;
var
  RadLon, RadLat : Extended;
  RuklString : String;

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

begin {TH_Terminator_Goto_Form.UpdateMapZone}
  if InputGood(SetToLon_LabeledNumericEdit.NumericEdit.Text)
    and InputGood(SetToLat_LabeledNumericEdit.NumericEdit.Text) then
    begin
      RadLon := DegToRad(SetToLon_LabeledNumericEdit.NumericEdit.ExtendedValue);
      RadLat := DegToRad(SetToLat_LabeledNumericEdit.NumericEdit.ExtendedValue);

      RuklString := Rukl_String(RadLon, RadLat);

      if RuklString='' then
        RuklZone_Label.Caption := ''
      else
        RuklZone_Label.Caption := 'Rükl: '+RuklString;

      LTOZone_Label.Caption := LTO_String(RadLon, RadLat);
      if LTO_MapExists(LTOZone_Label.Caption) then
        LTOZone_Label.Font.Color := clBlack
      else
        LTOZone_Label.Font.Color := clGray;

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
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.XY_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.CenterX_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewValue, OnePixel, StepSize : Extended;
  Digits : Integer;
  FormatString : String;
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');

  with LTVT_Form do
    begin
      OnePixel := (XValue(LTVT_Form.Image1.Width)-XValue(0))/LTVT_Form.Image1.Width;
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
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');

  with LTVT_Form do
    begin
      OnePixel := (YValue(LTVT_Form.Image1.Height)-YValue(0))/LTVT_Form.Image1.Height;
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

procedure TH_Terminator_Goto_Form.Next_ButtonClick(Sender: TObject);
  procedure IncrementZone;
    var
      CurrentZone : Integer;
    begin
      CurrentZone := RuklZone_LabeledNumericEdit.NumericEdit.IntegerValue;
      if CurrentZone<76 then
        begin
          Inc(CurrentZone);
          RuklZone_LabeledNumericEdit.NumericEdit.Text := IntToStr(CurrentZone);
        end;
    end;
begin
  if Center_RadioButton.Checked then
    IncrementZone
  else if NW_RadioButton.Checked then
    NE_RadioButton.Checked := True
  else if NE_RadioButton.Checked then
    SE_RadioButton.Checked := True
  else if SE_RadioButton.Checked then
    SW_RadioButton.Checked := True
  else if SW_RadioButton.Checked then
    begin
      IncrementZone;
      NW_RadioButton.Checked := True;
    end;
end;

procedure TH_Terminator_Goto_Form.MinimizeGotoList_CheckBoxClick(
  Sender: TObject);
begin
  with LTVT_Form do
    begin
      GoToListCurrent := False;
      RefreshGoToList;
    end;
end;

procedure TH_Terminator_Goto_Form.XY_Redraw_ButtonClick(Sender: TObject);
begin
  GoToState := Center;
  LTVT_Form.GoToXY(CenterX_LabeledNumericEdit.NumericEdit.ExtendedValue,CenterY_LabeledNumericEdit.NumericEdit.ExtendedValue);;
  GoToState := Cancel; // without this, closing form may cause another redraw
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
    LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SelectFeature_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SetToLon_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SetToLat_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SetToRadius_TLabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.MarkFeature_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.GoTo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.AerialView_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.MinimizeGotoList_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.XY_Redraw_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.RuklZone_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.LabeledNumericEdit2NumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.Center_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.NW_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.NE_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SW_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.SE_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.Next_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.AutoLabel_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

procedure TH_Terminator_Goto_Form.ResetRadius_ButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'GotoForm.htm');
end;

end.
