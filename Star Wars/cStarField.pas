unit cStarField;

interface

uses windows, classes, Graphics, SysUtils;

const gMaxStars = 50000;

type
  TStarDrawStyle = (sdDot, sdBlock, sdBmp, sdEllipse);

  TStar = class
  private
    // to keep track of position, size of the star
    FXPos, FYPos, FZPos: Integer;
    FSize: Integer;
    // save values for erasing
    FOldXPos, FOldYPos: integer;
    FOldSize: Integer;
  public
    constructor create;
    destructor Destroy; override;
  published
  end;

  TStarField = class
  private
    FNumberOfStars: integer;
    FCenterX: Integer;
    FCenterY: Integer;
    FStarFieldHeight: integer;
    FStarFieldWidth: integer;
    FStarColor: TColor;
    FStarBGColor: TColor;

      // for the sdBmp
    FBmp: TBitmap;
    FVoidBmp: TBitmap;
    FStarText: string;

    FStarDrawStyle: TStarDrawStyle;

    function rnd(min, max: integer): integer;

    procedure SetNumberOfStars(const Value: integer);
    procedure SetStarFieldHeight(const Value: integer);
    procedure SetStarFieldWidth(const Value: Integer);
    procedure SetStarDrawStyle(const Value: TStarDrawStyle);
    function GetStarText: string;
    procedure SetStarText(const Value: string);
  protected
    Stars : array [0..gMaxStars-1] of TStar;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetUpStars(NumStars: integer);
    procedure SetDimensions(Width, Height: integer);
    procedure DrawStarField(Canvas: TCanvas);
    procedure MoveStarField(nXOfs, nYOfs, nZOfs: Integer);
  published
    property NumberOfStars: integer read FNumberOfStars write SetNumberOfStars;
    property StarFieldWidth: Integer read FStarFieldWidth write SetStarFieldWidth default 640;
    property StarFieldHeight: integer read FStarFieldHeight write SetStarFieldHeight default 480;
    property StarColor: TColor read FStarColor write FStarColor default clWhite;
    property StarBGColor: TColor read FStarBGColor write FStarBGColor default clBlack;
    property StarDrawStyle: TStarDrawStyle read FStarDrawStyle write SetStarDrawStyle default sdDot;
    property StarText : string read GetStarText write SetStarText;
  end;


implementation

{ TStarField }

constructor TStarField.Create;
var i: integer;
begin
  for i := 0 to Length(Stars) - 1 do
    Stars[i] := TStar.Create;
  FBmp := TBitmap.Create;
  FVoidBmp := TBitmap.Create;
  StarText := 'X'
end;

destructor TStarField.Destroy;
var i: integer;
begin
  for i := 0 to Length(Stars) - 1 do
    FreeAndNil(Stars[i]);
  FBmp.Free;
  FVoidBmp.Free;

  inherited;
end;

function TStarField.GetStarText: string;
begin
  Result := FStarText;
end;

procedure TStarField.SetStarText(const Value: string);
begin
  FBmp.Canvas.Font.Name := 'Tahoma';
  FBmp.Canvas.Font.Size := 24;
  FBmp.Canvas.Font.Color := FStarColor;
  FBmp.Canvas.Brush.Color := FStarBGColor;
  FBmp.Width := FBmp.Canvas.TextWidth(Value);
  FBmp.Height := FBmp.Canvas.TextHeight(Value);
  FBmp.Canvas.TextOut(0, 0, Value);

  FVoidBmp.Width := FBmp.Width;
  FVoidBmp.Height := FBmp.Height;
  FVoidBmp.Canvas.Font.Color := FStarBGColor;
  FVoidBmp.Canvas.Brush.Color := FStarBGColor;
  FVoidBmp.Canvas.FillRect(Rect(0, 0, FVoidBmp.Width, FVoidBmp.Height));
  FStarText := Value;
end;


procedure TStarField.DrawStarField(Canvas: TCanvas);
var i, x, y, size: integer;
begin
  for i := 0 to FNumberOfStars - 1 do begin
    case StarDrawStyle of
      sdDot:
        begin
          // clear last position
          Canvas.Pixels[Stars[i].FOldXPos, Stars[i].FOldYPos] := FStarBGColor;
          // calculate new position
          x := (stars[i].FXPos div stars[i].FZPos) + FCenterX;
          y := (stars[i].FYPos div stars[i].FZPos) + FCenterY;
          //set pixel
          Canvas.Pixels[x, y] := FStarColor;

        end;
      sdBlock:
        begin
          // clear last position
          Canvas.Brush.Color := FStarBGColor;
          PatBlt(Canvas.Handle, Stars[i].FOldXPos, Stars[i].FOldYPos,
                 stars[i].FOldSize, stars[i].FOldSize, PATCOPY);
          // calculate new size and position
          size  := ( Stars[i].FSize ) div Stars[i].FZPos;
          x     := ( Stars[i].FXPos  div Stars[i].FZPos ) + FCenterX - size;
          y     := ( Stars[i].FYPos  div Stars[i].FZPos ) + FCenterY - size;

          // paint
          Canvas.Brush.Color := FStarColor;
          PatBlt(Canvas.Handle, x, y, size, size, PATCOPY	);
        end;
      sdEllipse:
        begin
          Canvas.Pen.Color := FStarBGColor;
          Canvas.Brush.Color := FStarBGColor;
          Ellipse(Canvas.Handle, stars[i].FOldXPos, Stars[i].FOldYPos,
                  Stars[i].FOldXPos+Stars[i].FOldSize, Stars[i].FOldYPos +Stars[i].FOldSize);
          size  := ( Stars[i].FSize ) div Stars[i].FZPos;
          x     := ( Stars[i].FXPos  div Stars[i].FZPos ) + FCenterX - size;
          y     := ( Stars[i].FYPos  div Stars[i].FZPos ) + FCenterY - size;
          Canvas.Brush.Color := FStarColor;
          canvas.Pen.Color := FStarColor;
          Ellipse(Canvas.Handle, x, y, x+size, y+size );
        end;
      sdBmp:
        begin
          // clear last position
          StretchBlt(Canvas.Handle, Stars[i].FOldXPos, Stars[i].FOldYPos,
                     stars[i].FOldSize * Length(FStarText),
                     stars[i].FOldSize,
                     FVoidBmp.Canvas.Handle, 0, 0, FVoidBmp.Width, FVoidBmp.Height,
                     SRCCOPY);

          // calculate new size and position
          size  := ( Stars[i].FSize ) div Stars[i].FZPos;
          x     := ( Stars[i].FXPos  div Stars[i].FZPos ) + FCenterX - size;
          y     := ( Stars[i].FYPos  div Stars[i].FZPos ) + FCenterY - size;

          // paint the new bitmap
          StretchBlt(Canvas.Handle, x, y,
                      size * Length(FStarText),
                     size,
                     FBmp.Canvas.Handle, 0, 0, FBmp.Width, FBmp.Height,
                     SRCCOPY);
        end;

       else begin
         x := -1;
         y := -1;
         size := -1;
       end;
    end;

    // save positions
    stars[i].FOldXPos := x;
    Stars[i].FOldYPos := y;
    Stars[i].FOldSize := size;
  end;
end;

procedure TStarField.MoveStarField(nXOfs, nYOfs, nZOfs: Integer);
var i: integer;
begin
  for i := 0 to FNumberOfStars - 1 do begin
    Stars[i].FXPos := Stars[i].FXPos + nXOfs;
    Stars[i].FYPos := stars[i].FYPos + nYOfs;
    stars[i].FZPos := stars[i].FZPos + nZOfs;
    if stars[i].FZPos > FNumberOfStars then stars[i].FZPos := stars[i].FZPos - FNumberOfStars;
    if Stars[i].FZPos < 1 then stars[i].FZPos := stars[i].FZPos + FNumberOfStars;
  end;
end;

function TStarField.rnd(min, max: integer): integer;
begin
  Result := Random(max + Abs(min));
  Result := Result - Abs(min);
end;

procedure TStarField.SetDimensions(Width, Height: integer);
begin
  FCenterX :=  Width  shr 1;
  FCenterY := Height shr 1;
end;

procedure TStarField.SetNumberOfStars(const Value: integer);
begin
  FNumberOfStars := Value;
  if FNumberOfStars > gMaxStars then FNumberOfStars := gMaxStars;
end;

procedure TStarField.SetStarDrawStyle(const Value: TStarDrawStyle);
begin
  FStarDrawStyle := Value;
end;

procedure TStarField.SetStarFieldHeight(const Value: integer);
begin
  FStarFieldHeight := Value;
  FCenterY := Value shr 1;
end;

procedure TStarField.SetStarFieldWidth(const Value: Integer);
begin
  FStarFieldWidth := Value;
  FCenterX := Value shr 1;
end;


procedure TStarField.SetUpStars(NumStars: integer);
var i: integer;
begin
  for i := 0 to gMaxStars - 1 do
    FreeAndNil(Stars[i]);


  FNumberOfStars := NumStars;

  for i := 0 to NumStars - 1 do begin
    Stars[i] := TStar.Create;
    repeat
      Stars[i].FXPos := rnd(-StarFieldWidth, StarFieldWidth) shl 7;
      Stars[i].FYPos := rnd(-StarFieldHeight, StarFieldHeight) shl 7;
      Stars[i].FZPos := i+1;
      Stars[i].FSize := FCenterX + FCenterY;

      Stars[i].FOldXPos := -1;
      Stars[i].FOldYPos := -1;
      Stars[i].FOldSize := 0;

    until ((Stars[i].FXPos <> 0) and (Stars[i].FYPos <> 0));
  end;

end;

{ TStar }

constructor TStar.create;
begin
  inherited;
end;

destructor TStar.Destroy;
begin
  inherited;
end;

end.
