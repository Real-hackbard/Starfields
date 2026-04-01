unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, Menus;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    O1: TMenuItem;
    S1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  Form1: TForm1;
  xx:array [1..1000] of integer;
  yy:array [1..1000] of integer;
  kol:integer;

implementation

uses Unit2;

{$R *.dfm}
Procedure ClearCanvas(C: TCanvas);
begin
    C.FillRect(C.ClipRect);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  kol := 300;
  randomize;

  for i:=1 to kol do
  begin
    xx[i]:=random(form1.Width);
    yy[i]:=random(form1.Height);
  end;

  timer1.enabled:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i:integer;
begin
  form1.Timer1.Enabled:=false;

  for i:=1 to kol do
  begin
    if (xx[i]=0) and (yy[i]=0) then
    begin
      xx[i]:=random(form1.Width);
      yy[i]:=random(form1.Height);
    end
  else
    form1.canvas.Pixels[xx[i],yy[i]] := clBlack;
    xx[i]:=xx[i]+1;
    yy[i]:=yy[i]+1;

  if (xx[i]>form1.Width) or (yy[i]>form1.Width) then
  begin
    xx[i]:=random(form1.Width);
    yy[i]:=random(form1.Height);
  end;
  form1.canvas.Pixels[xx[i],yy[i]]:= clWhite;
  application.ProcessMessages;
  end;

  timer1.Enabled:=true;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.S1Click(Sender: TObject);
begin
  form3.showmodal;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  i:integer;
begin
  ClearCanvas(Form1.Canvas);

  kol := 300;
  randomize;

  for i:=1 to kol do
  begin
    xx[i]:=random(form1.Width);
    yy[i]:=random(form1.Height);
  end;

end;

end.
