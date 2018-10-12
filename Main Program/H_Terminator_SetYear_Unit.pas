unit H_Terminator_SetYear_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LabeledNumericEdit;

type
  TTerminator_SetYear_Form = class(TForm)
    DesiredYear_LabeledNumericEdit: TLabeledNumericEdit;
    SetTo_Button: TButton;
    Cancel_Button: TButton;
    procedure FormShow(Sender: TObject);
    procedure SetTo_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure SetTo_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Cancel_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DesiredYear_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    SetYearRequested : Boolean;
  end;

var
  Terminator_SetYear_Form: TTerminator_SetYear_Form;

implementation

{$R *.dfm}

uses LTVT_Unit;

procedure TTerminator_SetYear_Form.FormShow(Sender: TObject);
begin
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  SetYearRequested := False;
end;

procedure TTerminator_SetYear_Form.SetTo_ButtonClick(Sender: TObject);
begin
  SetYearRequested := True;
  Close;
end;

procedure TTerminator_SetYear_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTerminator_SetYear_Form.SetTo_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'SetYearForm.htm');
end;

procedure TTerminator_SetYear_Form.Cancel_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'SetYearForm.htm');
end;

procedure TTerminator_SetYear_Form.DesiredYear_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'SetYearForm.htm');
end;

end.
