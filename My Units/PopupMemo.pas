unit PopupMemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TPopupMemo_Form = class(TForm)
    Memo: TMemo;
    Clear_Button: TButton;
    Close_Button: TButton;
    procedure Clear_ButtonClick(Sender: TObject);
    procedure Close_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TPopupMemo_Form.Clear_ButtonClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TPopupMemo_Form.Close_ButtonClick(Sender: TObject);
begin
  Close;
end;

end.
