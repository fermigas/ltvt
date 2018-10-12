unit ObserverLocationName_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TObserverLocationName_Form = class(TForm)
    Name_Edit: TEdit;
    Label1: TLabel;
    OK_Button: TButton;
    Cancel_Button: TButton;
    procedure FormShow(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure OK_ButtonClick(Sender: TObject);
    procedure ShowHelp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    CancelAction : Boolean;
  end;

var
  ObserverLocationName_Form: TObserverLocationName_Form;

implementation

{$R *.dfm}

uses Win_Ops, LTVT_Unit;

procedure TObserverLocationName_Form.FormShow(Sender: TObject);
begin
  CancelAction := True;
end;

procedure TObserverLocationName_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TObserverLocationName_Form.OK_ButtonClick(Sender: TObject);
var
  ObsListFile : TextFile;
  NameFound : Boolean;
  DataLine, ObsLon, ObsLat, ObsElev, ObsName : String;
begin
  if Trim(Name_Edit.Text)='' then
    begin
      ShowMessage('Please enter a name in the edit box');
      Exit;
    end;

  if FileExists(LTVT_Form.ObservatoryListFilename) then
    begin
      NameFound := False;

      AssignFile(ObsListFile,LTVT_Form.ObservatoryListFilename);
      Reset(ObsListFile);
      while (not EOF(ObsListFile)) and (not NameFound) do
        begin
          Readln(ObsListFile,DataLine);
          DataLine := Trim(DataLine);
          if (DataLine<>'') and (Substring(DataLine,1,1)<>'*') then
            begin
              ObsLon := LeadingElement(DataLine,',');
              ObsLat := LeadingElement(DataLine,',');
              ObsElev := LeadingElement(DataLine,',');
              ObsName := Trim(DataLine);
            end;
          NameFound := Trim(Name_Edit.Text)=ObsName;
        end;
      CloseFile(ObsListFile);

      if NameFound and (MessageDlg('Name already in list -- add anyway?',mtConfirmation,[mbYes,mbNo],0)=mrNo) then Exit;
    end;

    CancelAction := False;
    Close;

end;

procedure TObserverLocationName_Form.ShowHelp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'ObserverLocationNameForm.htm');
end;

end.
