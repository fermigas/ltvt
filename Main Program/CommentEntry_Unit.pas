unit CommentEntry_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TCommentEntry_Form = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Accept_Button: TButton;
    Cancel_Button: TButton;
    Clear_Button: TButton;
    procedure Clear_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Accept_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DesiredComment : String;  // on close contains desired comment ('' if cancelled)
  end;

var
  CommentEntry_Form: TCommentEntry_Form;

implementation
{$R *.dfm}

uses LTVT_Unit;

procedure TCommentEntry_Form.FormCreate(Sender: TObject);
begin
  Clear_Button.Click;
end;

procedure TCommentEntry_Form.Clear_ButtonClick(Sender: TObject);
begin
  Edit1.Text := '';
end;

procedure TCommentEntry_Form.Accept_ButtonClick(Sender: TObject);
begin
  DesiredComment := Edit1.Text;
  Close;
end;

procedure TCommentEntry_Form.Cancel_ButtonClick(Sender: TObject);
begin
  DesiredComment := '';
  Close;
end;

procedure TCommentEntry_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'CommentEntryForm.htm');
end;

end.
