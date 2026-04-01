unit StarCls;

interface

uses
  Types, Graphics;

type
  TStar = class(TObject)
  private
    FPosition: TPoint;
    FColor: TColor;
    FSpeed: Integer;
    FSize: Integer;
    procedure SetPos(Position: TPoint);
  public
    constructor Create(Position: TPoint; Color: TColor; Speed: Integer);
    procedure DrawStar(Canvas: TCanvas);
    property Position: TPoint read FPosition write SetPos;
    property Speed: Integer read FSpeed write FSpeed;
    property Size: Integer read FSize write FSize;
  end;

implementation

constructor TStar.Create(Position: TPoint; Color: TColor; Speed: Integer);
begin
  FPosition := Position;
  FColor := Color;
  FSpeed := Speed;
  FSize := 2;
end;

procedure TStar.DrawStar(Canvas: TCanvas);
var
  rect: TRect;
  OldColor: TColor;
begin
  with canvas do
  begin
    OldColor := Brush.Color;
    rect.Left := FPosition.X;
    rect.Top := FPosition.Y;
    rect.Right := FPosition.X + FSize;
    rect.Bottom := FPosition.Y + FSize;
    Pen.Color := FColor;
    Brush.Color := FColor;
    Brush.Style := bsSolid;
    Ellipse(rect);
    Brush.Color := OldColor;
  end;
end;

procedure TStar.SetPos(Position: TPoint);
begin
  FPosition := Position;
end;

end.

