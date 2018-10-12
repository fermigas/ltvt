unit DEM_Options_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl, LabeledNumericEdit, ExtCtrls;

type
  TDEM_Options_Form = class(TForm)
    DisplayComputationTimes_CheckBox: TCheckBox;
    OK_Button: TButton;
    Cancel_Button: TButton;
    ComputeCastShadows_CheckBox: TCheckBox;
    CastShadow_ColorBox: TColorBox;
    Label2: TLabel;
    Save_Button: TButton;
    Restore_Button: TButton;
    GridStepMultiplier_LabeledNumericEdit: TLabeledNumericEdit;
    Label4: TLabel;
    MultiplyByAlbedoCheckBox: TCheckBox;
    RecalculateDEMonRecenter_CheckBox: TCheckBox;
    RigorousNormals_CheckBox: TCheckBox;
    DrawTerminatorOnDEM_CheckBox: TCheckBox;
    ChangeDEM_Button: TButton;
    DEMFilename_Label: TLabel;
    OpenDialog1: TOpenDialog;
    Lambertian_RadioButton: TRadioButton;
    LommelSeeliger_RadioButton: TRadioButton;
    LunarLambert_RadioButton: TRadioButton;
    PhotometricModel_GroupBox: TGroupBox;
    procedure OK_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Restore_ButtonClick(Sender: TObject);
    procedure ThreeD_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DisplayComputationTimes_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComputeCastShadows_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure CastShadow_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Save_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Restore_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OK_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RecalculateDEMonRecenter_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure ChangeDEM_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ChangeDEM_ButtonClick(Sender: TObject);
    procedure Lambertian_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LommelSeeliger_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure LunarLambert_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ChangeOptions : Boolean;

    TempDEMFilename : String;

    procedure RefreshLabels;
  end;

var
  DEM_Options_Form: TDEM_Options_Form;

implementation

{$R *.dfm}

uses LTVT_Unit;

procedure TDEM_Options_Form.RefreshLabels;
begin
  DEMFilename_Label.Caption := MinimizeName(TempDEMFilename,DEMFilename_Label.Canvas,DEMFilename_Label.Width);
end;

procedure TDEM_Options_Form.FormShow(Sender: TObject);
begin
  RefreshLabels;
end;

procedure TDEM_Options_Form.ChangeDEM_ButtonClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
      Title := 'Select DEM file';
      if TempDEMFilename='' then
        FileName := LTVT_Form.FullFilename('LALT_GGT_MAP.IMG')
      else
        FileName := TempDEMFilename;
      Filter := 'PDS image array (*.IMG)|*.IMG|All files|*.*';
      if Execute then
        begin
          TempDEMFilename := FileName;
          DEMFilename_Label.Caption := MinimizeName(TempDEMFilename,DEMFilename_Label.Canvas,DEMFilename_Label.Width);
        end;
    end;
end;

procedure TDEM_Options_Form.OK_ButtonClick(Sender: TObject);
begin
  ChangeOptions := True;
  Close;
end;

procedure TDEM_Options_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TDEM_Options_Form.Save_ButtonClick(Sender: TObject);
begin
  with LTVT_Form do
    begin
      ReadDemOptionsFromForm;
      SaveDemOptions;
    end;
end;

procedure TDEM_Options_Form.Restore_ButtonClick(Sender: TObject);
begin
  with LTVT_Form do
    begin
      RestoreDemOptions;
      WriteDemOptionsToForm;
    end;
  RefreshLabels;
end;

procedure TDEM_Options_Form.ThreeD_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.DisplayComputationTimes_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.ComputeCastShadows_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.CastShadow_ColorBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.Save_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.Restore_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.OK_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.RecalculateDEMonRecenter_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.ChangeDEM_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.Lambertian_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.LommelSeeliger_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

procedure TDEM_Options_Form.LunarLambert_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'DemOptionsForm.htm');
end;

end.
