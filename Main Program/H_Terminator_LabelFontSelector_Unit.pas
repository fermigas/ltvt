unit H_Terminator_LabelFontSelector_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LabeledNumericEdit, ExtCtrls, NumericEdit;

type
  TLabelFontSelector_Form = class(TForm)
    FontDialog1: TFontDialog;
    FontSample_Label: TLabel;
    ChangeFont_Button: TButton;
    OK_Button: TButton;
    Cancel_Button: TButton;
    XOffset_LabeledNumericEdit: TLabeledNumericEdit;
    Label2: TLabel;
    YOffset_LabeledNumericEdit: TLabeledNumericEdit;
    IncludeSize_CheckBox: TCheckBox;
    FullCraterNames_CheckBox: TCheckBox;
    Save_Button: TButton;
    Restore_Button: TButton;
    SatelliteFontSample_Label: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Labels_GroupBox: TGroupBox;
    NonCrater_ColorBox: TColorBox;
    Label4: TLabel;
    DotSize_LabeledNumericEdit: TLabeledNumericEdit;
    SmallCrater_ColorBox: TColorBox;
    MediumCrater_ColorBox: TColorBox;
    LargeCrater_ColorBox: TColorBox;
    Label5: TLabel;
    MediumCraterDiam_NumericEdit: TNumericEdit;
    LargeCraterDiam_NumericEdit: TNumericEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Dot_GroupBox: TGroupBox;
    SavedImage_GroupBox: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    SavedImageUpperLabels_ColorBox: TColorBox;
    SavedImageLowerLabels_ColorBox: TColorBox;
    AnnotateSavedImages_CheckBox: TCheckBox;
    Label12: TLabel;
    IncludeUnits_CheckBox: TCheckBox;
    IncludeName_CheckBox: TCheckBox;
    IncludeDiscontinuedNames_CheckBox: TCheckBox;
    Label13: TLabel;
    DotCircle_ColorBox: TColorBox;
    Label14: TLabel;
    RefPt_ColorBox: TColorBox;
    procedure ChangeFont_ButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OK_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IncludeSize_CheckBoxClick(Sender: TObject);
    procedure Restore_ButtonClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure FullCraterNames_CheckBoxClick(Sender: TObject);
    procedure ChangeFont_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure XOffset_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure YOffset_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure FullCraterNames_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure IncludeSize_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SmallCrater_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MediumCraterDiam_NumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure MediumCrater_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LargeCraterDiam_NumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure LargeCrater_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NonCrater_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DotSize_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure AnnotateSavedImages_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure SavedImageUpperLabels_ColorBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure SavedImageLowerLabels_ColorBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Save_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Restore_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OK_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IncludeName_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IncludeUnits_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IncludeName_CheckBoxClick(Sender: TObject);
    procedure IncludeUnits_CheckBoxClick(Sender: TObject);
    procedure DotCircle_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RefPt_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IncludeDiscontinuedNames_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure TransparentDots_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    DesiredFont : TFont;
    ChangeSelections : Boolean;
    procedure RefreshFontSample;
  end;

var
  LabelFontSelector_Form: TLabelFontSelector_Form;

implementation

uses
  LTVT_Unit;

{$R *.dfm}

procedure TLabelFontSelector_Form.FormCreate(Sender: TObject);
begin
  DesiredFont := TFont.Create;
end;

procedure TLabelFontSelector_Form.FormDestroy(Sender: TObject);
begin
  DesiredFont.Free;
end;

procedure TLabelFontSelector_Form.RefreshFontSample;
var
  TestInfo : TCraterInfo;
begin
  with TestInfo do
    begin
      Name := 'Ptolemaeus';
      NumericData := '164';
      USGS_Code := 'AA';
    end;
  FontSample_Label.Caption := Terminator_Form.LabelString(TestInfo,
    IncludeName_CheckBox.Checked,FullCraterNames_CheckBox.Checked,
    IncludeSize_CheckBox.Checked,IncludeUnits_CheckBox.Checked,False);

  with TestInfo do
    begin
      Name := 'Ptolemaeus A';
      NumericData := '17';
      USGS_Code := 'SF';
    end;
  SatelliteFontSample_Label.Caption := Terminator_Form.LabelString(TestInfo,
    IncludeName_CheckBox.Checked,FullCraterNames_CheckBox.Checked,
    IncludeSize_CheckBox.Checked,IncludeUnits_CheckBox.Checked,False);

  FontSample_Label.Font.Assign(DesiredFont);
  SatelliteFontSample_Label.Font.Assign(DesiredFont);

  FullCraterNames_CheckBox.Visible := IncludeName_CheckBox.Checked;
  IncludeUnits_CheckBox.Visible := IncludeSize_CheckBox.Checked;
end;

procedure TLabelFontSelector_Form.ChangeFont_ButtonClick(Sender: TObject);
begin
  if FontDialog1.Execute then
    begin
      DesiredFont.Assign(FontDialog1.Font);
      RefreshFontSample;
    end;
end;

procedure TLabelFontSelector_Form.FormShow(Sender: TObject);
begin
  ChangeSelections := False;
  FontDialog1.Font.Assign(DesiredFont);
  RefreshFontSample;
end;

procedure TLabelFontSelector_Form.OK_ButtonClick(Sender: TObject);
begin
  ChangeSelections := True;
  DesiredFont.Assign(FontSample_Label.Font);  // should be unnecessary
  Close;
end;

procedure TLabelFontSelector_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TLabelFontSelector_Form.IncludeName_CheckBoxClick(
  Sender: TObject);
begin
  RefreshFontSample;
end;

procedure TLabelFontSelector_Form.FullCraterNames_CheckBoxClick(Sender: TObject);
begin
  RefreshFontSample;
end;

procedure TLabelFontSelector_Form.IncludeSize_CheckBoxClick(Sender: TObject);
begin
  RefreshFontSample;
end;

procedure TLabelFontSelector_Form.IncludeUnits_CheckBoxClick(
  Sender: TObject);
begin
  RefreshFontSample;
end;

procedure TLabelFontSelector_Form.Save_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      ReadLabelOptionsFromForm;
      SaveDefaultLabelOptions;
    end;
end;

procedure TLabelFontSelector_Form.Restore_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      RestoreDefaultLabelOptions;
      WriteLabelOptionsToForm;
      RefreshFontSample;
    end;
end;

procedure TLabelFontSelector_Form.ChangeFont_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.XOffset_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.YOffset_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.FullCraterNames_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.IncludeSize_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.SmallCrater_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.MediumCraterDiam_NumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.MediumCrater_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.LargeCraterDiam_NumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.LargeCrater_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.NonCrater_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.DotSize_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.AnnotateSavedImages_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.SavedImageUpperLabels_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.SavedImageLowerLabels_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.Save_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.Restore_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.OK_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.IncludeName_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.IncludeUnits_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.DotCircle_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.RefPt_ColorBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.IncludeDiscontinuedNames_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

procedure TLabelFontSelector_Form.TransparentDots_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'ModifyLabels.htm');
end;

end.
