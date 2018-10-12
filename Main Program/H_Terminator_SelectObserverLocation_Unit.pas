unit H_Terminator_SelectObserverLocation_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, LabeledNumericEdit;

type
  TSetObserverLocation_Form = class(TForm)
    ObserverElevation_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverLatitude_LabeledNumericEdit: TLabeledNumericEdit;
    ObserverLongitude_LabeledNumericEdit: TLabeledNumericEdit;
    Geocentric_RadioButton: TRadioButton;
    ObserverLocation_Panel: TPanel;
    UserSpecified_RadioButton: TRadioButton;
    OK_Button: TButton;
    Cancel_Button: TButton;
    Save_Button: TButton;
    Restore_Button: TButton;
    ObservatoryList_ComboBox: TComboBox;
    AddLocation_Button: TButton;
    procedure Geocentric_RadioButtonClick(Sender: TObject);
    procedure UserSpecified_RadioButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OK_ButtonClick(Sender: TObject);
    procedure Cancel_ButtonClick(Sender: TObject);
    procedure Save_ButtonClick(Sender: TObject);
    procedure Restore_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ObservatoryList_ComboBoxSelect(Sender: TObject);
    procedure ObserverLongitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverLatitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverElevation_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure AddLocation_ButtonClick(Sender: TObject);
    procedure ShowHelp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    ActionCanceled : boolean;
    ObsNameList, ObsLatList, ObsLonList, ObsElevList : TStrings;

    procedure RefreshSelection;

  end;

var
  SetObserverLocation_Form: TSetObserverLocation_Form;

implementation

{$R *.dfm}

uses
  Win_Ops, IniFiles, LTVT_Unit, ObserverLocationName_Unit;

var
  SelectingItem : Boolean;   // flag to avoid refreshing Combo-box selection during a new selection

procedure TSetObserverLocation_Form.FormCreate(Sender: TObject);
begin
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  ObsNameList := TStringList.Create;
  ObsLatList := TStringList.Create;
  ObsLonList := TStringList.Create;
  ObsElevList := TStringList.Create;

  SelectingItem := False;
end;

procedure TSetObserverLocation_Form.FormDestroy(Sender: TObject);
begin
  ObsNameList.Free;
  ObsLatList.Free;;
  ObsLonList.Free;;
  ObsElevList.Free;;
end;

procedure TSetObserverLocation_Form.FormShow(Sender: TObject);
var
  ObsListFile : TextFile;
  DataLine : String;
begin
  ObsNameList.Clear;
  ObsLatList.Clear;
  ObsLonList.Clear;
  ObsElevList.Clear;

  if FileExists(Terminator_Form.ObservatoryListFilename) then
    begin
      AssignFile(ObsListFile,Terminator_Form.ObservatoryListFilename);
      Reset(ObsListFile);
      while (not EOF(ObsListFile)) {and (Length(FeatureList)<100)} do
        begin
          Readln(ObsListFile,DataLine);
          DataLine := Trim(DataLine);
          if (DataLine<>'') and (Substring(DataLine,1,1)<>'*') then
            begin
              ObsLonList.Add(Trim(LeadingElement(DataLine,',')));
              ObsLatList.Add(Trim(LeadingElement(DataLine,',')));
              ObsElevList.Add(Trim(LeadingElement(DataLine,',')));
              ObsNameList.Add(Trim(DataLine));
            end;
        end;
      CloseFile(ObsListFile);
    end;

  ObservatoryList_ComboBox.Items.Clear;
  ObservatoryList_ComboBox.Items.AddStrings(ObsNameList);
  RefreshSelection;

  ObserverLocation_Panel.Visible := UserSpecified_RadioButton.Checked;
  ActionCanceled := true;
end;

procedure TSetObserverLocation_Form.ObservatoryList_ComboBoxSelect(Sender: TObject);
begin
  with ObservatoryList_ComboBox do if ItemIndex>=0 then
    begin
      SelectingItem := True;
      ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObsLonList[ItemIndex];
      ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObsLatList[ItemIndex];
      ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObsElevList[ItemIndex];
      SelectingItem := False;
    end
  else
    ShowMessage('Please try again:  you must click on an item in the list');
end;

procedure TSetObserverLocation_Form.AddLocation_ButtonClick(Sender: TObject);
var
  ObsListFile : TextFile;
  NameToAdd : String;
begin
  with ObserverLocationName_Form do
    begin
      ShowModal;
      if CancelAction then Exit;

      NameToAdd := Trim(Name_Edit.Text);
    end;

  AssignFile(ObsListFile,Terminator_Form.ObservatoryListFilename);

  if FileExists(Terminator_Form.ObservatoryListFilename) then
    begin
      Append(ObsListFile);
    end
  else
    begin
      Rewrite(ObsListFile);
      Writeln(ObsListFile,'* List of observatory locations for use by LTVT');
      Writeln(ObsListFile,'*   (blank lines and lines with ''*'' in the first column are ignored)');
      Writeln(ObsListFile,'');
      Writeln(ObsListFile,'*   The observatory name can include any characters -- including commas');
      Writeln(ObsListFile,'*   Longitudes and latitudes must be in decimal degrees (NOT degrees-minutes-seconds)');
      Writeln(ObsListFile,'*   Important: you must use ''.'' (period) for for the decimal point');
      Writeln(ObsListFile,'');
      Writeln(ObsListFile,'* List items in this format (using commas to separate items):');
      Writeln(ObsListFile,'* ObservatoryEastLongitude_degrees, ObservatoryNorthLatitude_degrees, ObservatoryElevation_meters, ObservatoryName');
      Writeln(ObsListFile,'');
    end;

  Writeln(ObsListFile,
    Trim(ObserverLongitude_LabeledNumericEdit.NumericEdit.Text)+', '+
    Trim(ObserverLatitude_LabeledNumericEdit.NumericEdit.Text)+', '+
    Trim(ObserverElevation_LabeledNumericEdit.NumericEdit.Text)+', '+
    NameToAdd);
  CloseFile(ObsListFile);

  ObsLonList.Add(Trim(ObserverLongitude_LabeledNumericEdit.NumericEdit.Text));
  ObsLatList.Add(Trim(ObserverLatitude_LabeledNumericEdit.NumericEdit.Text));
  ObsElevList.Add(Trim(ObserverElevation_LabeledNumericEdit.NumericEdit.Text));
  ObsNameList.Add(NameToAdd);

  ObservatoryList_ComboBox.Items.Add(NameToAdd);

//  ShowMessage('Location added to '+Terminator_Form.ObservatoryListFilename);
  RefreshSelection;
end;

procedure TSetObserverLocation_Form.RefreshSelection;
var
  i : Integer;
begin
  if ObservatoryList_ComboBox.Visible and not SelectingItem then
    begin
      i := 0;
      while (i<ObsNameList.Count) and
        (    (Trim(ObserverLongitude_LabeledNumericEdit.NumericEdit.Text)<>ObsLonList[i])
          or (Trim(ObserverLatitude_LabeledNumericEdit.NumericEdit.Text)<>ObsLatList[i])
          or (Trim(ObserverElevation_LabeledNumericEdit.NumericEdit.Text)<>ObsElevList[i])
        ) do Inc(i);

      if i<ObservatoryList_ComboBox.Items.Count then
        ObservatoryList_ComboBox.ItemIndex := i
      else
        begin
          if FileExists(Terminator_Form.ObservatoryListFilename) then
            begin
              ObservatoryList_ComboBox.ItemIndex := -1;
              ObservatoryList_ComboBox.Text := Terminator_Form.ObservatoryComboBoxDefaultText;
            end
          else
            begin
              ObservatoryList_ComboBox.ItemIndex := -1;
              ObservatoryList_ComboBox.Text := Terminator_Form.ObservatoryNoFileText;
            end
        end;
    end;
end;

procedure TSetObserverLocation_Form.ObserverLongitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TSetObserverLocation_Form.ObserverLatitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TSetObserverLocation_Form.ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  RefreshSelection;
end;

procedure TSetObserverLocation_Form.Geocentric_RadioButtonClick(Sender: TObject);
begin
  ObserverLocation_Panel.Hide;
end;

procedure TSetObserverLocation_Form.UserSpecified_RadioButtonClick(Sender: TObject);
begin
  ObserverLocation_Panel.Show;
end;

procedure TSetObserverLocation_Form.OK_ButtonClick(Sender: TObject);
begin
  ActionCanceled := false;
  Close;
end;

procedure TSetObserverLocation_Form.Cancel_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TSetObserverLocation_Form.Save_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      ReadLocationOptionsFromForm;
      SaveLocationOptions;
    end;
end;

procedure TSetObserverLocation_Form.Restore_ButtonClick(Sender: TObject);
begin
  with Terminator_Form do
    begin
      RestoreLocationOptions;
      WriteLocationOptionsToForm;
      RefreshSelection;
    end;
end;

procedure TSetObserverLocation_Form.ShowHelp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  Terminator_Form.DisplayF1Help(Key,Shift,'SetLocationForm.htm');
end;

end.
