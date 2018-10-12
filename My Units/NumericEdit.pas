unit NumericEdit;
{Revision: to avoid problems with European data enter, for extended format
 input, replace all commas with periods before trying to apply the val() function.
                                                             9/20/06}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Dialogs;

type
  TInputType =(tInteger, tExtended);

  TNumericEdit = class(TEdit)
  private
    { Private declarations }
    fInputType : TInputType;
    fFormatString,
    fMinString,
    fMaxString : string;
    fMinValid,
    fMaxValid,
    fValidEntry, fEntryValidated : boolean;
    fIntegerValue : integer;
    fMaxValue,
    fMinValue,
    fExtendedValue : extended;
    procedure ValidateEntry;
    procedure SetInputType(const Value : TInputType);
    procedure SetMin(const ValueString : string);
    procedure SetMax(const ValueString : string);
  protected
    { Protected declarations }
    procedure Change; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function IntegerValue : integer;
    function ExtendedValue : extended;
  published
    { Published declarations }
    property InputFormatString : string
      read fFormatString  write fFormatString;
    property InputMin : string
      read fMinString  write SetMin;
    property InputMax : string
      read fMaxString  write SetMax;
    property InputType : TInputType
      read fInputType write SetInputType;
  end;

procedure Register;

implementation

uses Win_Ops;

procedure Register;
begin
  RegisterComponents('Jim', [TNumericEdit]);
end;

constructor TNumericEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 21;
  Width := 71;
  Text := '0';
  fInputType := tExtended;
  fEntryValidated := false;
  ThousandSeparator := #0;
  DecimalSeparator := '.';
end;

procedure TNumericEdit.SetInputType(const Value : TInputType);
begin
  fInputType := Value;
end;

procedure TNumericEdit.SetMin(const ValueString : string);
var
  ErrorCode : integer;
begin
  val(ValueString,fMinValue,ErrorCode);
  fMinValid := (ErrorCode=0);
  if fMinValid then
    fMinString := ValueString
  else
    ShowMessage('The MinString "'+ValueString+'" is not a valid number');
end;

procedure TNumericEdit.SetMax(const ValueString : string);
var
  ErrorCode : integer;
begin
  val(ValueString,fMaxValue,ErrorCode);
  fMaxValid := (ErrorCode=0);
  if fMaxValid then
    fMaxString := ValueString
  else
    ShowMessage('The MaxString "'+ValueString+'" is not a valid number');
end;

procedure TNumericEdit.ValidateEntry;
var
  ErrorCode, CommaPos : integer;
  CorrectedText : string;
begin
  Text := StrippedString(Text);
  fValidEntry := true;
  case InputType of
    tInteger :
      begin
        val(Text,fIntegerValue,ErrorCode);
        if ErrorCode<>0 then
          begin
            ShowMessage('"'+Text+'" is not a valid integer; error at position '+IntToStr(ErrorCode));
            fValidEntry := false;
            fIntegerValue := 0;
          end
        else if fMinValid and fMaxValid then
          begin
            if (fIntegerValue<fMinValue) or (fIntegerValue>fMaxValue) then
              begin
                ShowMessage('Entry must be between '+IntToStr(Round(fMinValue))+
                 ' and '+IntToStr(Round(fMaxValue)));
                fValidEntry := false;
                if fIntegerValue>fMaxValue then
                  fIntegerValue := Round(fMaxValue)
                else
                  fIntegerValue := Round(fMinValue);
              end;
          end;
      end;
    tExtended :
      begin
        CorrectedText := Text;
        CommaPos := Pos(',',CorrectedText);
        while CommaPos<>0 do
          begin
            CorrectedText := Copy(CorrectedText,0,CommaPos-1)+'.'+Copy(CorrectedText,CommaPos+1,MaxInt);
            CommaPos := Pos(',',CorrectedText);
          end;
        val(CorrectedText,fExtendedValue,ErrorCode);
        if ErrorCode<>0 then
          begin
            ShowMessage('"'+Text+'" is not a valid Extended; error at position '+IntToStr(ErrorCode));
            fValidEntry := false;
            fExtendedValue := 0;
          end
        else if fMinValid and fMaxValid then
          begin
            if (fExtendedValue<fMinValue) or (fExtendedValue>fMaxValue) then
              begin
                ShowMessage('Entry must be between '+Format('%0.3g',[fMinValue])+
                 ' and '+Format('%0.3g',[fMaxValue]));
                fValidEntry := false;
                if fExtendedValue>fMaxValue then
                  fExtendedValue := fMaxValue
                else
                  fExtendedValue := fMinValue;
              end;
          end;
      end;
    else
      begin
        ShowMessage('Attempting to validate unknown type');
        fValidEntry := false;
      end;
    end; {case}
  fEntryValidated := true;
end;

procedure TNumericEdit.Change;
begin
  inherited;
  fEntryValidated := false;
end;

function TNumericEdit.IntegerValue : integer;
begin
  if not fEntryValidated then ValidateEntry;
  if fInputType<>tInteger then ShowMessage('Requesting integer value from non-integer control');
  if not fValidEntry then
    begin
      ShowMessage('Substituting "'+IntToStr(fIntegerValue)+'" for "'+Text+'" (invalid entry)');
    end;
  if fInputType<>tInteger then ShowMessage('Requesting integer value from non-integer control');
  Result := fIntegerValue;
end;

function TNumericEdit.ExtendedValue : extended;
begin
  if not fEntryValidated then ValidateEntry;
  if fInputType<>tExtended then ShowMessage('Requesting extended value from non-extended control');
  if not fValidEntry then
    begin
      ShowMessage('Substituting "'+Format('%0.3g',[fExtendedValue])+'" for "'+Text+'" (invalid entry)');
    end;
  Result := fExtendedValue;
end;

end.
