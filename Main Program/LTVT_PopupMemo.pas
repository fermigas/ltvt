unit LTVT_PopupMemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons;

type
  TLTVT_PopupMemo_Form = class(TForm)
    Clear_Button: TButton;
    Close_Button: TButton;
    Memo: TRichEdit;
    WebLink_BitBtn: TBitBtn;
    Copy_Button: TButton;
    procedure Clear_ButtonClick(Sender: TObject);
    procedure Close_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WebLink_BitBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Copy_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    WebLink_URL : String;   // determines if Web link button is visible
    procedure ClearMemoArea;
  end;

implementation

{$R *.dfm}

uses ShellApi, LTVT_Unit;

procedure TLTVT_PopupMemo_Form.FormCreate(Sender: TObject);
begin
  WebLink_URL := '';
end;

procedure TLTVT_PopupMemo_Form.FormActivate(Sender: TObject);
begin
  WebLink_BitBtn.Visible := WebLink_URL<>'';
end;

procedure TLTVT_PopupMemo_Form.ClearMemoArea;
begin
  Memo.Clear;
end;

procedure TLTVT_PopupMemo_Form.Copy_ButtonClick(Sender: TObject);
begin
  Memo.SelectAll;
  Memo.CopyToClipboard;
end;

procedure TLTVT_PopupMemo_Form.Clear_ButtonClick(Sender: TObject);
begin
  ClearMemoArea;
end;

procedure TLTVT_PopupMemo_Form.Close_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TLTVT_PopupMemo_Form.WebLink_BitBtnClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(WebLink_URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TLTVT_PopupMemo_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'PopUpMemo.htm');
end;

end.
