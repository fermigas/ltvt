unit TargetSelection_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MP_Defs;

type
  TTargetSelection_Form = class(TForm)
    PlanetSelector_ComboBox: TComboBox;
    OK_Button: TButton;
    Cancel_Button: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure OK_ButtonClick(Sender: TObject);
    procedure ProcessKeyStroke(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    PlanetSelected : Boolean;
    SelectedPlanet : Planet;

    procedure SelectPlanet(const DesiredPlanet : Planet);
  end;

var
  TargetSelection_Form: TTargetSelection_Form;

implementation

uses LTVT_Unit;

{$R *.dfm}

const
  PlanetList : array[0..8] of Planet = (Moon, Mercury, Venus, Mars, Jupiter, Saturn, Uranus, Neptune, Pluto);

procedure TTargetSelection_Form.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  with PlanetSelector_ComboBox do
    for I := 0 to (Length(PlanetList) - 1) do Items.Add(PlanetName[PlanetList[I]]);
  SelectPlanet(Moon);
  SelectedPlanet := Moon;
  ActiveControl := OK_Button;
end;

procedure TTargetSelection_Form.SelectPlanet(const DesiredPlanet : Planet);
var
  I : Integer;
  SearchName : String;
begin
  SearchName := PlanetName[DesiredPlanet];
  with PlanetSelector_ComboBox do
    begin
      ItemIndex := -1;
      for I := 0 to (Items.Count - 1) do
        if Items[I]=SearchName then
          begin
            ItemIndex := I;
            Break;
          end;
    end;
end;

procedure TTargetSelection_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TTargetSelection_Form.OK_ButtonClick(Sender: TObject);
begin
  with PlanetSelector_ComboBox do
    if ItemIndex=-1 then
      begin
        PlanetSelected := False;
        ShowMessage('You have to select and item from the list');
      end
    else
      begin
        PlanetSelected := True;
        SelectedPlanet := PlanetList[ItemIndex];
        Close;
      end;

end;

procedure TTargetSelection_Form.ProcessKeyStroke(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    Close
  else
    LTVT_Form.DisplayF1Help(Key,Shift,'TargetPlanetSelectionForm.htm');
end;

end.
