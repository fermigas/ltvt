unit H_Terminator_About_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi;

type
  TTerminatorAbout_Form = class(TForm)
    OK_Button: TButton;
    Label1: TLabel;
    Version_Label: TLabel;
    Copyright_Label: TLabel;
    Label4: TLabel;
    Email_Label: TLabel;
    Label2: TLabel;
    JimWebAddress_Label: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    HenrikWebAddress_Label: TLabel;
    More_Button: TButton;
    Label3: TLabel;
    LTVT_WikiWebAddress_Label: TLabel;
    procedure OK_ButtonClick(Sender: TObject);
    procedure Email_LabelClick(Sender: TObject);
    procedure Email_LabelMouseEnter(Sender: TObject);
    procedure Email_LabelMouseLeave(Sender: TObject);
    procedure JimWebAddress_LabelClick(Sender: TObject);
    procedure HenrikWebAddress_LabelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OK_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure More_ButtonClick(Sender: TObject);
    procedure More_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LTVT_WikiWebAddress_LabelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DefaultCursor : TCursor;
  end;

var
  TerminatorAbout_Form: TTerminatorAbout_Form;

implementation

{$R *.dfm}

uses LTVT_Unit;

procedure TTerminatorAbout_Form.OK_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTerminatorAbout_Form.Email_LabelClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar('mailto:'+Email_Label.Caption),'','',sw_ShowNormal)
end;

procedure TTerminatorAbout_Form.Email_LabelMouseEnter(Sender: TObject);
begin
  DefaultCursor := Screen.Cursor;
  Screen.Cursor := crHandPoint;
end;

procedure TTerminatorAbout_Form.Email_LabelMouseLeave(Sender: TObject);
begin
  Screen.Cursor := DefaultCursor;
end;

procedure TTerminatorAbout_Form.LTVT_WikiWebAddress_LabelClick(
  Sender: TObject);
begin
  ShellExecute(0,'open',pchar('http://'+LTVT_WikiWebAddress_Label.Caption),'','',sw_ShowNormal)
end;

procedure TTerminatorAbout_Form.JimWebAddress_LabelClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar('http://'+JimWebAddress_Label.Caption),'','',sw_ShowNormal)
end;

procedure TTerminatorAbout_Form.HenrikWebAddress_LabelClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar('http://'+HenrikWebAddress_Label.Caption),'','',sw_ShowNormal)
end;

procedure TTerminatorAbout_Form.FormCreate(Sender: TObject);
begin
  ThousandSeparator := #0;
  DecimalSeparator := '.';
end;

procedure TTerminatorAbout_Form.OK_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'Contact_Support.htm');
end;

procedure TTerminatorAbout_Form.More_ButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   LTVT_Form.DisplayF1Help(Key,Shift,'What_is_LTVT.htm');
end;

procedure TTerminatorAbout_Form.More_ButtonClick(Sender: TObject);
begin
  LTVT_Form.DisplayF1Help(VK_F1,[],'What_is_LTVT.htm');
end;

end.
