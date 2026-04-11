unit cSWScroller;

interface

uses Windows, Classes, Graphics, SysUtils;
type
  TSWScroller = class
  private
    FSList : TStringList;
    FBmp: TBitmap;
    FSWBitmap: TBitmap;

    FCanDraw: Boolean;
    FTextColor: TColor;
    FBGColor: TColor;
    FFontName: string;
//    FTextFont: TFont;
    FFontSize: integer;

    FHeight: integer;
    FWidth : integer;
    FScrollHeight: integer;
    FCutOff: Integer;

    // global vars I need...
    screenTopY, newTopEdge: Integer;
    mLeftSide: Real;
    p1, r1, r2: TPoint;

    procedure GenerateBMPFromStringList;
    procedure InitGlobalVars;
    procedure InitSWBitmap;
    function GetLines: TStringList;
    procedure SetLines(const Value: TStringList);
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
//    procedure SetTextFont(const Value: TFont);
//    function GetTextFont: TFont;
  public
    constructor Create;
    destructor Destroy; override;
    procedure TransformStarwarsBitmap(MoveStep: Integer);
    procedure DrawStarwarsBitmap(Canvas: TCanvas);
    procedure InitializeScrolling;

  published
    property Lines: TStringList read GetLines write SetLines;
//    property TextFont: TFont read GetTextFont write SetTextFont;

    property FontName: string read FFontName write FFontName;
    property TextColor: TColor read FTextColor write FTextColor default clYellow;
    property BGColor: TColor read FBGColor write FBGColor default clBlack;
    property FontSize: integer read FFontSize write FFontSize default 48;

    property Height : integer read FHeight write SetHeight default 0;
    property Width : Integer read FWidth write SetWidth default 0;
    property ScrollHeight : Integer read FScrollHeight write FScrollHeight;

    property b: TBitmap read FBmp;
    property sw: TBitmap read FSWBitmap;


  end;

implementation

{ TSWScroller }

constructor TSWScroller.Create;
begin
  FSList := TStringList.Create;
  FBmp := TBitmap.Create;
  FSWBitmap := TBitmap.Create;
  FCanDraw := false;
  FFontName := 'Arial';
end;

destructor TSWScroller.Destroy;
begin
  FreeAndNil(FSList);
  FreeAndNil(FBmp);
  FreeAndNil(FSWBitmap);
  inherited;
end;

function TSWScroller.GetLines: TStringList;
begin
  Result := FSList;
end;
{
function TSWScroller.GetTextFont: TFont;
begin
  if FTextFont = nil then begin
    FTextFont := TFont.Create;
    if FFontName = '' then
      FTextFont.Name := 'Arial'
    else FTextFont.Name := FFontName;
    FTextFont.Color := FTextColor;
    FTextFont.Size := 48;
    FTextFont.Style := FTextFont.Style + [fsBold];
  end;

  Result := FTextFont;
end;
}

{
procedure TSWScroller.SetTextFont(const Value: TFont);
begin
  if FTextFont = nil then begin
    FTextFont := TFont.Create;
    FTextFont.Assign(Value);
  end;

end;
}

procedure TSWScroller.SetHeight(const Value: Integer);
begin
  FHeight := Value;
  FCutOff := FHeight div 4;
  FCanDraw := false;
end;

procedure TSWScroller.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  FCanDraw := false;
end;

procedure TSWScroller.SetLines(const Value: TStringList);
begin
  Value.Assign(FSList);
end;

procedure TSWScroller.DrawStarwarsBitmap(Canvas: TCanvas);
begin
  if FCanDraw then Canvas.Draw(0, 0, FSWBitmap);
end;

procedure TSWScroller.GenerateBMPFromStringList;
var WidestLine: integer; i: integer; LineHi, LinePos : integer;
begin
  if FSList.Count <= 0 then begin
    FCanDraw := false;
    Exit;
  end;

  if FBmp = nil then begin
    FCanDraw := false;
    Exit;
  end;

  WidestLine := 0;
  for i := 0 to FSList.Count - 1 do
    if Length(FSList[i]) > Length(FSList[WidestLine]) then
      WidestLine := i;


  with FBmp do begin
//    if FTextFont = nil then begin
      Canvas.font.name := FFontName;
      Canvas.Font.Color := TextColor;
      Canvas.Brush.Color := BGColor;
      Canvas.Font.Size := 48;
//    end
//    else Canvas.Font.Assign(TextFont);

    PixelFormat := pf16bit;
    LineHi := Canvas.TextHeight('W');
    Height := LineHi * FSList.Count;
    Width := Canvas.TextWidth(FSList[WidestLine]);
  end;

  LinePos := 0;
  for i := 0 to FSList.Count - 1 do begin
    FBmp.Canvas.TextOut(0, LinePos, FSList[i]);
    LinePos := Linepos + LineHi;
  end;

  FScrollHeight := FBmp.Height;
  FCanDraw := true;
end;

procedure TSWScroller.InitSWBitmap;
begin
  if ((FWidth = 0) or (FHeight=0))  then begin
    FCanDraw := False;
    exit;
  end;


  FSWBitmap.Height := FHeight;
  FSWBitmap.Width := FWidth;
  FSWBitmap.PixelFormat := pf16bit;

  FSWBitmap.canvas.brush.color:=BGColor;
  FSWBitmap.canvas.pen.color:= BGColor;

end;

procedure TSWScroller.InitGlobalVars;
var mg1, mg2: Real;
textY, screenZ : Integer;
begin
  if not FCanDraw then exit;

  FSWBitmap.canvas.Rectangle(0,0,FSWBitmap.width,FSWBitmap.height);
  //The following code works in space
  textY:=-30;

  mg1 := textY / ( (FBmp.Width/2) + (FBmp.Height) );
  mg2 := textY / (FBmp.Width / 2);

  // bereken screenz en screentop Y
  screenZ := Round( FSWBitmap.Height / (mg1-mg2) );
  screenTopY:=Round( mg1 * screenZ);

  //newTopEdge is the length of the OrgBMPs top side in newBMP
  newTopEdge := FSWBitmap.Width * FBmp.Width;
  newTopEdge := Round(newTopEdge / ((FBmp.Width / 2) + FBmp.Height));
  newTopEdge := newTopEdge div -2;

  //
  mLeftSide := newTopEdge - FSWBitmap.Width;
  mLeftSide := mLeftSide / 2;
  mLeftSide := mLeftSide / FSWBitmap.Height;

  //
  p1.x:=FBmp.width div 2;
  p1.y:=textY;
  r1.x:=FBmp.Height;
  r1.y:=0;
  r2.x:=screenZ;
end;


procedure TSWScroller.InitializeScrolling;
begin
  GenerateBMPFromStringList;
  if FCanDraw then InitSWBitmap;
  if FCanDraw then InitGlobalVars;
end;

procedure TSWScroller.TransformStarwarsBitmap(MoveStep: Integer);
var
  xc,yc:Integer;
  orgCoord:TPoint;
  param:Real;
  newBMPPointer,orgBMPPointer:PWordArray;
  startX, stopX: real;
begin
  if not FCanDraw then exit;


  //StartX and StopX tell you how wide one line is in SWBMP
  startX:=( FSWBitmap.Width - newTopEdge ) / 2;
  stopX:=FSWBitmap.Width-startX;


  for yc:=1 to FSWBitmap.height-1 do begin
    startX:=startX+mLeftSide;
    stopX:=stopX-mLeftSide;

    // make sure there is a horizon and not a DOT! / Pyramid
    if ABS( startX - stopX) < FCutOff  then continue;

    //Change r2.y and get the y-coordinate in the original
    r2.y:=screenTopY-yc;
    param:=(p1.y*r2.x-p1.x*r2.y)/(r1.x*r2.y-r1.y*r2.x);

    OrgCoord.Y := FBmp.Height - Round( FBmp.Height * param ) + MoveStep;

    //YRangeCheck
    if (orgCoord.y<=0) or (orgCoord.y>=FBmp.Height) then continue;

    //Initialize Pointers for using ScanLine
    orgBMPPointer:=FBmp.ScanLine[orgCoord.y];
    newBMPPointer:=FSWBitmap.ScanLine[yc];


    for xc:=Round(startX) to Round(stopX) do begin
      //Get X-Coordinate on the original text
      orgCoord.x:=Round((xc-startX)/(stopx-startx)*FBmp.width);
      //XRangeCheck
      if (orgCoord.x>0) and (orgCoord.x<=FBmp.width-10) then
        newBMPPointer[xc]:=orgBMPPointer[orgCoord.x];     //SetPixel
    end;
  end;
end;

end.
