unit H_CartographicOptions_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LabeledNumericEdit, ExtCtrls;

type
  TCartographicOptions_Form = class(TForm)
    InvertLR_CheckBox: TCheckBox;
    InvertUD_CheckBox: TCheckBox;
    OK_Button: TButton;
    Cancel_Button: TButton;
    Cartographic_CheckBox: TCheckBox;
    ShowDetails_CheckBox: TCheckBox;
    LibrationCircle_CheckBox: TCheckBox;
    LibrationCircle_ColorBox: TColorBox;
    Label1: TLabel;
    Sky_ColorBox: TColorBox;
    Label2: TLabel;
    Save_Button: TButton;
    Restore_Button: TButton;
    TerminatorLines_CheckBox: TCheckBox;
    Label3: TLabel;
    NoDataColor_ColorBox: TColorBox;
    UseCurrentUT_CheckBox: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    DotModeSunlitColor_ColorBox: TColorBox;
    DotModeShadowedColor_ColorBox: TColorBox;
    Label6: TLabel;
    Label7: TLabel;
    ShadowLineLength_LabeledNumericEdit: TLabeledNumericEdit;
    procedure OK_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Restore_ButtonClick(Sender: TObject);
    procedure UseCurrentUT_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cartographic_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InvertLR_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InvertUD_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShowDetails_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RotationAngle_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LibrationCircle_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure TerminatorLines_CheckBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure LibrationCircle_ColorBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Sky_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NoDataColor_ColorBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DotModeSunlitColor_ColorBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure DotModeShadowedColor_ColorBoxKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Save_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Restore_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OK_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShadowLineLength_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ChangeOptions : boolean;
  end;

var
  CartographicOptions_Form: TCartographicOptions_Form;

implementation

{$R *.dfm}

uses LTVT_Unit;

procedure TCartographicOptions_Form.OK_ButtonClick(Sender: TObject);
begin
  ChangeOptions := True;
  Close;
end;

procedure TCartographicOptions_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TCartographicOptions_Form.Save_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      ReadCartographicOptionsFromForm;
      SaveCartographicOptions;
    end;
end;

procedure TCartographicOptions_Form.Restore_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      RestoreCartographicOptions;
      WriteCartographicOptionsToForm;
    end;
end;

procedure TCartographicOptions_Form.UseCurrentUT_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.Cartographic_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.InvertLR_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.InvertUD_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.ShowDetails_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.RotationAngle_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.LibrationCircle_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.TerminatorLines_CheckBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.LibrationCircle_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.Sky_ColorBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.NoDataColor_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.DotModeSunlitColor_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.DotModeShadowedColor_ColorBoxKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.Save_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.Restore_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.OK_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

procedure TCartographicOptions_Form.ShadowLineLength_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'DisplayOptionsForm.htm');
end;

end.
