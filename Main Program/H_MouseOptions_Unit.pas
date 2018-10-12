unit H_MouseOptions_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMouseOptions_Form = class(TForm)
    CursorOptions_GroupBox: TGroupBox;
    NormalCursor_RadioButton: TRadioButton;
    CrosshairCursor_RadioButton: TRadioButton;
    RefPtOptions_GroupBox: TGroupBox;
    CurrentReferencePoint_Label: TLabel;
    DistanceAndBearingFromRefPt_RadioButton: TRadioButton;
    NoRefPtReadout_RadioButton: TRadioButton;
    ShadowLengthRefPtReadout_RadioButton: TRadioButton;
    PointOfLightRefPtReadout_RadioButton: TRadioButton;
    OK_Button: TButton;
    Cancel_Button: TButton;
    Save_Button: TButton;
    Restore_Button: TButton;
    InverseShadowLengthRefPtReadout_RadioButton: TRadioButton;
    procedure OK_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Restore_ButtonClick(Sender: TObject);
    procedure NormalCursor_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure CrosshairCursor_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure NoRefPtReadout_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure DistanceAndBearingFromRefPt_RadioButtonKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShadowLengthRefPtReadout_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure InverseShadowLengthRefPtReadout_RadioButtonKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PointOfLightRefPtReadout_RadioButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Save_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Restore_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OK_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ChangeOptions : boolean;
  end;

var
  MouseOptions_Form: TMouseOptions_Form;

implementation

uses LTVT_Unit;

{$R *.dfm}

procedure TMouseOptions_Form.OK_ButtonClick(Sender: TObject);
begin
  ChangeOptions := True;
  if PointOfLightRefPtReadout_RadioButton.Checked and Terminator_Form.UserPhoto_RadioButton.Checked then
    ShowMessage('Warning:  the elevation of sun rays readout is not intended for use on user-supplied photos.'+Char(13)
                +'Please make the measurements on one of the selenographic texture maps.');

  Close;
end;

procedure TMouseOptions_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMouseOptions_Form.Save_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      ReadMouseOptionsFromForm;
      SaveMouseOptions;
    end;
end;

procedure TMouseOptions_Form.Restore_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      RestoreMouseOptions;
      WriteMouseOptionsToForm;
    end;
end;

procedure TMouseOptions_Form.NormalCursor_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.CrosshairCursor_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.NoRefPtReadout_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.DistanceAndBearingFromRefPt_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.ShadowLengthRefPtReadout_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.InverseShadowLengthRefPtReadout_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.PointOfLightRefPtReadout_RadioButtonKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.Save_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.Restore_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.OK_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

procedure TMouseOptions_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   Terminator_Form.DisplayF1Help(Key,Shift,'MouseOptionsForm.htm');
end;

end.
