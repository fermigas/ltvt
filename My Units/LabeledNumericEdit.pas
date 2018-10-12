unit LabeledNumericEdit;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NumericEdit;

type
  TLabeledNumericEdit = class(TFrame)
    Item_Label: TLabel;
    Units_Label: TLabel;
    NumericEdit: TNumericEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
 