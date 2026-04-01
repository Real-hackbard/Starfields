unit Unit1;

interface

uses
  Windows, Messages, Graphics, Forms, ExtCtrls, StarCls, Classes, Menus,
  Dialogs, Vcl.Controls, Vcl.StdCtrls;


type
  TForm1 = class(TForm)
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N51: TMenuItem;
    N12: TMenuItem;
    N22: TMenuItem;
    S2: TMenuItem;
    N13: TMenuItem;
    N52: TMenuItem;
    N14: TMenuItem;
    N23: TMenuItem;
    N53: TMenuItem;
    N15: TMenuItem;
    C1: TMenuItem;
    B1: TMenuItem;
    ColorDialog1: TColorDialog;
    ColorDialog2: TColorDialog;
    ColorDialog3: TColorDialog;
    M1: TMenuItem;
    F1: TMenuItem;
    S3: TMenuItem;
    W1: TMenuItem;
    F2: TMenuItem;
    S4: TMenuItem;
    S5: TMenuItem;
    N1: TMenuItem;
    C2: TMenuItem;
    N2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N11Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure x1Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure M1Click(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure W1Click(Sender: TObject);
    procedure F2Click(Sender: TObject);
    procedure S4Click(Sender: TObject);
    procedure S5Click(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    Stars: array of TStar;
    MemBMP: TBitmap;
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  NUMSTARS : integer = 250;
  count : integer;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  ColorDialog1.Color := clGray;
  ColorDialog2.Color := clSilver;
  ColorDialog3.Color := clWhite;

  count := 250;
  Randomize;
  DoubleBuffered := True;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Screen.Width);
    pt.y := Random(Screen.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
      1: StarColor := clGray;
      2: StarColor := clSilver;
      3: StarColor := clWhite;
    end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
  MemBMP := TBitmap.Create;
  MemBMP.Canvas.Brush.Color := clBlack;
  MemBMP.Width := Screen.Width;
  MemBMP.Height := Screen.Height;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to length(Stars) - 1 do
    Stars[i].Free;

  MemBMP.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  BitBlt(Canvas.Handle, 0, 0, Width, Height, MemBMP.Canvas.Handle, 0, 0,
    SRCCOPY);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
begin
  MemBMP.Canvas.Font.Color := clSilver;
  MemBMP.Canvas.Font.Name := 'Verdana';
  MemBMP.Canvas.FillRect(ClientRect);
  for i := 0 to length(Stars) - 1 do
  begin
    pt := Stars[i].Position;
    pt.X := pt.X + Stars[i].Speed;
    if pt.X > Width then
      pt.X := 0;
    Stars[i].Position := pt;
    Stars[i].DrawStar(MemBMP.Canvas);
    MemBMP.Canvas.TextOut(100, 80, 'Star Scroller Demo');
    MemBMP.Canvas.TextOut(100, 100, 'Use right click for function !');
  end;
  Form1.Repaint;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Form1.Repaint;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

procedure TForm1.N11Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  count := 100;
  NUMSTARS := count;
  Randomize;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Form1.Width);
    pt.y := Random(Form1.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
end;

procedure TForm1.N22Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  count := 2000;
  NUMSTARS := count;
  Randomize;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Form1.Width);
    pt.y := Random(Form1.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
end;

procedure TForm1.N21Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  count := 250;
  NUMSTARS := count;
  Randomize;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Form1.Width);
    pt.y := Random(Form1.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
end;

procedure TForm1.N51Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  count := 500;
  NUMSTARS := count;
  Randomize;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Form1.Width);
    pt.y := Random(Form1.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
end;

procedure TForm1.N12Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  count := 1000;
  NUMSTARS := count;
  Randomize;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Form1.Width);
    pt.y := Random(Form1.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
end;

procedure TForm1.N13Click(Sender: TObject);
begin
  Timer1.Interval := 1;
end;

procedure TForm1.N52Click(Sender: TObject);
begin
  Timer1.Interval := 5;
end;

procedure TForm1.N14Click(Sender: TObject);
begin
  Timer1.Interval := 10;
end;

procedure TForm1.N23Click(Sender: TObject);
begin
  Timer1.Interval := 25;
end;

procedure TForm1.N53Click(Sender: TObject);
begin
  Timer1.Interval := 50;
end;

procedure TForm1.N15Click(Sender: TObject);
begin
  Timer1.Interval := 100;
end;

procedure TForm1.x1Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  //StarColor := clWhite;
  Randomize;
  DoubleBuffered := True;
  SetLength(Stars, NUMSTARS);
  for i := 0 to NUMSTARS - 1 do
  begin
    pt.x := Random(Screen.Width);
    pt.y := Random(Screen.Height);
    StarSpeed := Random(3) + 1;

    case StarSpeed of
      1: StarColor := clGray;
      2: StarColor := clSilver;
      3: StarColor := clWhite;
    end;

    Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
    //Stars[i].Size := StarSpeed;
  end;
  MemBMP := TBitmap.Create;
  MemBMP.Canvas.Brush.Color := clBlack;
  MemBMP.Width := Screen.Width;
  MemBMP.Height := Screen.Height;
end;

procedure TForm1.B1Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  if ColorDialog1.Execute then
  begin
    NUMSTARS := count;
    Randomize;
    SetLength(Stars, NUMSTARS);
    for i := 0 to NUMSTARS - 1 do
    begin
      pt.x := Random(Form1.Width);
      pt.y := Random(Form1.Height);
      StarSpeed := Random(3) + 1;

      case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

      Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
      //Stars[i].Size := StarSpeed;
    end;
  end;
end;

procedure TForm1.M1Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  if ColorDialog2.Execute then
  begin
    NUMSTARS := count;
    Randomize;
    DoubleBuffered := True;
    SetLength(Stars, NUMSTARS);
    for i := 0 to NUMSTARS - 1 do
    begin
      pt.x := Random(Form1.Width);
      pt.y := Random(Form1.Height);
      StarSpeed := Random(3) + 1;

      case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

      Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
      //Stars[i].Size := StarSpeed;
    end;
  end;
end;

procedure TForm1.F1Click(Sender: TObject);
var
  i: Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  if ColorDialog3.Execute then
  begin
    NUMSTARS := count;
    Randomize;
    SetLength(Stars, NUMSTARS);
    for i := 0 to NUMSTARS - 1 do
    begin
      pt.x := Random(Form1.Width);
      pt.y := Random(Form1.Height);
      StarSpeed := Random(3) + 1;

      case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

      Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
      //Stars[i].Size := StarSpeed;
    end;
  end;
end;

procedure TForm1.W1Click(Sender: TObject);
var
  i : Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  Timer1.Enabled := false;
  pt.x := 0;
  pt.y := 0;
  Form1.WindowState := wsNormal;
  Form1.Width := 640;
  Form1.Height := 480;
  Application.ProcessMessages;

  NUMSTARS := count;
    Randomize;
    SetLength(Stars, NUMSTARS);
    for i := 0 to NUMSTARS - 1 do
    begin
      pt.x := Random(Form1.Width);
      pt.y := Random(Form1.Height);
      StarSpeed := Random(3) + 1;

      case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

      Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
      //Stars[i].Size := StarSpeed;
    end;
  Timer1.Enabled := true;
end;

procedure TForm1.F2Click(Sender: TObject);
var
  i : Integer;
  pt: TPoint;
  StarSpeed: Integer;
  StarColor: TColor;
begin
  Timer1.Enabled := false;
  pt.x := 0;
  pt.y := 0;
  Form1.WindowState := wsMaximized;
  Application.ProcessMessages;

  NUMSTARS := count;
    Randomize;
    SetLength(Stars, NUMSTARS);
    for i := 0 to NUMSTARS - 1 do
    begin
      pt.x := Random(Screen.Width);
      pt.y := Random(Screen.Height);
      StarSpeed := Random(3) + 1;

      case StarSpeed of
        1: StarColor := ColorDialog1.Color;
        2: StarColor := ColorDialog2.Color;
        3: StarColor := ColorDialog3.Color;
      end;

      Stars[i] := TStar.Create(pt, StarColor, StarSpeed);
      //Stars[i].Size := StarSpeed;
    end;
  Timer1.Enabled := true;
end;

procedure TForm1.S4Click(Sender: TObject);
begin
  Timer1.Enabled := true;
end;

procedure TForm1.S5Click(Sender: TObject);
begin
  Timer1.Enabled := false;
end;

procedure TForm1.C2Click(Sender: TObject);
begin
  Close();
end;


procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if W1.Checked = true then
  begin
    ReleaseCapture;
    Perform(wm_syscommand,$f012, 0);
  end else begin
    ReleaseCapture;
  end;
end;

end.

