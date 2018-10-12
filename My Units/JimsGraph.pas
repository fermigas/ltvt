unit JimsGraph;
{Provides procedures for drawing a scaled graph in the usual scientific
coordinate system with +X to the left and +Y up. }

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics{TCanvas};

type
  TJimsGraph = class(TImage)
  private
    { Private declarations }
    fXScale, fXOffset,
    fYScale, fYOffset : extended;
  protected
    { Protected declarations }
  public
    { Public declarations }
    PlotMode : (Logarithmic, Linear);

{the following method has been replaced by the procedure Initialize which must
be explicitly called by the program using TJimsGraph.  Adding intialization
methods by overriding the constructor seemed to work when compiled under Windows
98, but under Windows XP it seems to cause the control to be resized to the default (?)
of 105 pixels on a side, and to ignore any requests to change this.  Delphi help
says that instances of TImage placed on the form at design time are automatically
instantiated and do not need Create}
//    constructor Create(AOwner: TComponent); override;

    procedure Initialize; {set default parameters}
    procedure Clear;
    procedure SetRange(const Xmin, Xmax, Ymin, Ymax : extended);
    function RoundToSmallInt(const X : extended) : integer;
    function XPix(const X : extended) : integer;
    function YPix(const Y : extended) : integer;
    function XValue(const XPix : integer) : extended;
    function YValue(const YPix : integer) : extended;
    procedure MoveToDataPoint(const X,Y : extended);
    procedure LineToDataPoint(const X,Y : extended);
    procedure PlotDataPoint(const X,Y : extended;  const PixelHt : integer;  const BorderColor, FillColor : TColor);
    {plots data point with a square of the specified pixel height and width}

  published
    { Published declarations }
  end;

procedure Register;

PROCEDURE DrawBox(CONST Canvas : TCanvas; CONST Point : TPoint; CONST BorderColor : TColor;
  CONST FillColor: TColor; CONST HalfSize : INTEGER {Pixels});
{This procedure implements that used in EFG's PixelProfile for plotting a
colored square marker on an image.  HalfSize is half the side of the square.}

implementation

procedure Register;
begin
  RegisterComponents('Jim', [TJimsGraph]);
end;

procedure TJimsGraph.Initialize;
{Sets default parameters for black lines on a white background -- Brush and Pen
are probably set to these values automatically, but the documentation is not clear}
begin
  Canvas.Brush.Color := clWhite;  {used for fill}
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := clBlack;    {used for lines}
  Canvas.Pen.Style := psSolid;
  Canvas.CopyMode := cmSrcCopy;
  PlotMode := Linear;
  SetRange(0,1,0,1);
  Clear;
end;

procedure TJimsGraph.Clear;
begin
  with Canvas do FillRect(Rect(0,0,Width,Height));
end;

procedure TJimsGraph.SetRange(const Xmin, Xmax, Ymin, Ymax : extended);
begin
  fXOffset := Xmin;
  fXScale  := Width/(Xmax - Xmin);
  fYOffset := Ymax;
  fYScale  := Height/(Ymin - Ymax);
end;

function TJimsGraph.RoundToSmallInt(const X : extended) : integer;
begin
  if X>=32767 then
    Result := 32767
  else if X<=-32768 then
    Result := -32768
  else
    Result := Round(X);
end;

function TJimsGraph.XPix(const X : extended) : integer;
begin
  Result := RoundToSmallInt(fXScale*(X - fXOffset));
end;

function TJimsGraph.YPix(const Y : extended) : integer;
begin
  Result := RoundToSmallInt(fYScale*(Y - fYOffset));
end;

function TJimsGraph.XValue(const XPix : integer) : extended;
begin
  Result := XPix/fXScale + fXOffset;
end;

function TJimsGraph.YValue(const YPix : integer) : extended;
begin
  Result := YPix/fYScale + fYOffset;
end;

procedure TJimsGraph.MoveToDataPoint(const X,Y : extended);
begin
  Canvas.MoveTo(XPix(X),YPix(Y))
end;

procedure TJimsGraph.LineToDataPoint(const X,Y : extended);
begin
  Canvas.LineTo(XPix(X),YPix(Y))
end;

procedure TJimsGraph.PlotDataPoint(const X,Y : extended;  const PixelHt : integer;  const BorderColor, FillColor : TColor);
{plots data point with a square of the specified pixel height and width}
var
  OldPen : TPen;
  OldBrush : TBrush;
  HalfSize, CenterXPixel, CenterYPixel : integer;
begin
  WITH Canvas DO
    BEGIN
      OldPen := TPen.Create;
      OldBrush := TBrush.Create;
      OldPen.Assign(Pen);
      OldBrush.Assign(Brush);

      Pen.Color   := BorderColor;
      Pen.Style   := psSolid;
      Pen.Width   := 1;  {Hardwire for now}

      Brush.Color := FillColor;

      CenterXPixel := XPix(X);
      CenterYPixel := YPix(Y);
      HalfSize := PixelHt div 2;
      Rectangle(CenterXPixel-HalfSize, CenterYPixel-HalfSize, CenterXPixel+HalfSize, CenterYPixel+HalfSize);

      Pen.Assign(OldPen);
      Brush.Assign(OldBrush);
      OldPen.Free;
      OldBrush.Free;
    END
end;

PROCEDURE DrawBox(CONST Canvas : TCanvas; CONST Point : TPoint; CONST BorderColor : TColor;
  CONST FillColor: TColor; CONST HalfSize : INTEGER {Pixels});
BEGIN
  WITH Canvas DO
    BEGIN
      Pen.Color   := BorderColor;
      Pen.Style   := psSolid;
      Pen.Width   := 1;  {Hardwire for now}

      Brush.Color := FillColor;

      Rectangle(Point.X-HalfSize, Point.Y-HalfSize, Point.X+HalfSize, Point.Y+HalfSize);
    END
END; {DrawBox}


end.
