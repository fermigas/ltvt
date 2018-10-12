unit ExportTexture_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LabeledNumericEdit, ExtDlgs, ComCtrls, ExtCtrls;

type
  TExportTexture_Form = class(TForm)
    Export_Button: TButton;
    Close_Button: TButton;
    LeftLon_LabeledNumericEdit: TLabeledNumericEdit;
    RightLon_LabeledNumericEdit: TLabeledNumericEdit;
    TopLat_LabeledNumericEdit: TLabeledNumericEdit;
    BottomLat_LabeledNumericEdit: TLabeledNumericEdit;
    Label1: TLabel;
    Label2: TLabel;
    HorizontalPixels_LabeledNumericEdit: TLabeledNumericEdit;
    SavePictureDialog1: TSavePictureDialog;
    ExportGeometry_GroupBox: TGroupBox;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Abort_Button: TButton;
    Copy_Button: TButton;
    Clear_Button: TButton;
    NoDataColor_ColorBox: TColorBox;
    Label3: TLabel;
    procedure Close_ButtonClick(Sender: TObject);
    procedure Export_ButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Copy_ButtonClick(Sender: TObject);
    procedure Clear_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Abort_ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AbortKeyPressed : Boolean;
  end;

var
  ExportTexture_Form: TExportTexture_Form;

implementation

{$R *.dfm}

uses MoonPosition {MoonRadius}, Constnts, Win_Ops, RGB_Library, LTVT_Unit, JPEG;

procedure TExportTexture_Form.FormCreate(Sender: TObject);
begin
  Clear_Button.Click;
  ProgressBar1.Hide;
  Abort_Button.Hide;
  NoDataColor_ColorBox.Selected := LTVT_Form.NoDataColor;
end;

procedure TExportTexture_Form.Export_ButtonClick(Sender: TObject);
var
  JPEG_Image : TJPEGImage;
  TextureMap : TBitMap;
  RawRow, TextureRow  :  pRGBArray;
  NoDataPixel : TRGBTriple;
  NumLons, NumLats, LonNum, LatNum, RawXPix, RawYPix,
  CharPos : Integer;
  LeftLonRad, RightLonRad, TopLatRad, BottomLatRad, LonStepRad, LatStepRad,
  LatRad, LonRad : Extended;
  ProposedFilename, DesiredExtension : String;
//  Answer : Word;

begin {TExportTexture_Form.Export_ButtonClick}
  NoDataPixel := ColorToRGBTriple(NoDataColor_ColorBox.Selected);

  ProposedFilename := LTVT_Form.UserPhotoData.PhotoFilename;
  CharPos := Length(ProposedFilename);
  while (CharPos>0) and (ProposedFilename[CharPos]<>'.') do Dec(CharPos);
  if CharPos>1 then ProposedFilename := Substring(ProposedFilename,1,CharPos-1);
  ProposedFilename := ProposedFilename+'_Lon'+LeftLon_LabeledNumericEdit.NumericEdit.Text+
    'to'+RightLon_LabeledNumericEdit.NumericEdit.Text+'_Lat'+TopLat_LabeledNumericEdit.NumericEdit.Text+
    'to'+BottomLat_LabeledNumericEdit.NumericEdit.Text+'.bmp';

  SavePictureDialog1.FileName := ProposedFilename;

  if SavePictureDialog1.Execute then
    begin
      Memo1.Lines.Add('Source file :  '+LTVT_Form.UserPhotoData.PhotoFilename);
      Memo1.Lines.Add('');

      LeftLonRad  := LeftLon_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree;
      RightLonRad := RightLon_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree;

      TopLatRad    := TopLat_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree;
      BottomLatRad := BottomLat_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree;

      NumLons := HorizontalPixels_LabeledNumericEdit.NumericEdit.IntegerValue;
      LonStepRad := (RightLonRad - LeftLonRad)/NumLons;

      NumLats := Round(Abs((BottomLatRad - TopLatRad)/LonStepRad));  // try same spacing as in longitude: Round to whole steps
      LatStepRad := (BottomLatRad - TopLatRad)/NumLats;

      Memo1.Lines.Add('Texture map parameters');
      Memo1.Lines.Add('  Left longitude: '+LeftLon_LabeledNumericEdit.NumericEdit.Text+'  Right longitude: '+RightLon_LabeledNumericEdit.NumericEdit.Text);
      Memo1.Lines.Add('  Top latitude: '+TopLat_LabeledNumericEdit.NumericEdit.Text+'  Bottom latitude: '+BottomLat_LabeledNumericEdit.NumericEdit.Text);
      Memo1.Lines.Add(Format('  Longitude increment: %0.6f°  (%d steps)',[LonStepRad/OneDegree,NumLons]));
      Memo1.Lines.Add(Format('  Latitude increment:  %0.6f°  (%d steps)',[LatStepRad/OneDegree,NumLats]));
      Memo1.Lines.Add('');

      TextureMap := TBitmap.Create;
      TextureMap.PixelFormat := pf24bit;
      TextureMap.Height := NumLats;
      TextureMap.Width := NumLons;

      Screen.Cursor := crHourGlass;

      ProgressBar1.Max := NumLats;  
      ProgressBar1.Position := 0;
      ProgressBar1.Show;

      AbortKeyPressed := False;
      Abort_Button.Show;

      LatRad := TopLatRad + 0.5*LatStepRad; // adjust to center of first cell
      LatNum := 0;
      while (LatNum<NumLats) and (not AbortKeyPressed) do with LTVT_Form do
        begin
          ProgressBar1.Position := LatNum;
          LonRad := LeftLonRad + 0.5*LonStepRad; // adjust to center of first cell
          LonNum := 0;
          TextureRow := TextureMap.ScanLine[LatNum];
          while LonNum<NumLons do
            begin
              if ConvertLonLatToUserPhotoXPixYPix(LonRad,LatRad,MoonRadius,RawXPix,RawYPix)
                and (RawXPix>=0) and (RawXPix<UserPhoto.Width) and (RawYPix>=0) and (RawYPix<UserPhoto.Height) then
                begin
//                  TextureRow[LonNum] := ColorToRGBTriple(UserPhoto.Canvas.Pixels[RawXPix,RawYPix])
                  RawRow := UserPhoto.ScanLine[RawYPix];
                  TextureRow[LonNum] := RawRow[RawXPix];
                end
              else
                TextureRow[LonNum] := NoDataPixel;

              LonRad := LonRad + LonStepRad;
              Inc(LonNum);
            end;
          LatRad := LatRad + LatStepRad;
          Inc(LatNum);
          Application.ProcessMessages;
        end;

      Abort_Button.Hide;
      ProgressBar1.Hide;
      Screen.Cursor := crDefault;

      if AbortKeyPressed then
        begin
          Memo1.Lines.Add('Processing aborted -- texture not saved...');
          Memo1.Lines.Add('');
        end
      else
        begin
          DesiredExtension := UpperCase(ExtractFileExt(SavePictureDialog1.FileName));

          if (DesiredExtension='.JPG') or (DesiredExtension='.JPEG') then
            begin
              JPEG_Image := TJPEGImage.Create;
              try
      {          JPEG_Image.PixelFormat := jf24Bit; }    {this is supposed to be true by default}
      {          JPEG_Image.Performance := jpBestQuality; } {this is supposed to apply only to playback}
      {          JPEG_Image.ProgressiveEncoding := False; } {makes no difference}
                JPEG_Image.CompressionQuality := 90;  {highest possible is 100;  90 makes files half the size but indistinguishable}
                JPEG_Image.Assign(TextureMap);
                JPEG_Image.SaveToFile(SavePictureDialog1.FileName);
              finally
                JPEG_Image.Free;
              end;
            end
          else {.bmp}
            begin
              SavePictureDialog1.FileName := ChangeFileExt(SavePictureDialog1.FileName,'.bmp');
              TextureMap.SaveToFile(SavePictureDialog1.FileName);
            end;
          TextureMap.Free;
          Memo1.Lines.Add('Image saved as texture: '+SavePictureDialog1.FileName);
          Memo1.Lines.Add('');
        end;
    end
  else
    ShowMessage('Dialog cancelled; texture not saved to disk');
end;  {TExportTexture_Form.Export_ButtonClick}

procedure TExportTexture_Form.Copy_ButtonClick(Sender: TObject);
begin
  Memo1.SelectAll;
  Memo1.CopyToClipboard;
end;

procedure TExportTexture_Form.Clear_ButtonClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TExportTexture_Form.Close_ButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TExportTexture_Form.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  LTVT_Form.DisplayF1Help(Key,Shift,'ExportTextureForm.htm');
end;

procedure TExportTexture_Form.Abort_ButtonClick(Sender: TObject);
begin
  AbortKeyPressed := True;
end;

end.
