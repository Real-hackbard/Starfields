unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Unit1;

{$R *.dfm}
procedure TForm3.Button1Click(Sender: TObject);
var
  i,j:integer;
begin
  j:=strtoint(edit1.Text);
  if kol > j then

  for i:=j to kol do
    form1.canvas.Pixels[xx[i],yy[i]]:=clBlack;

  kol:=j;
  form1.timer1.Interval:=strtoint(edit2.Text);
  close;
end;

procedure TForm3.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['a'..'z'] + ['à'..'ÿ']+['À'..'ß']+
    ['`']+['~']+['!']+['@']+['"']+['#']+['¹']+[';']+['$']+
    ['%']+['^']+[':']+['&']+['?']+['(']+[')']+['-']+['_']+
    ['=']+['+']+['/']+[',']+['.']+['¨']+['¸']+['|']+
    ['*']+['{']+['}']+['[']+[']']+['<']+['>']+[' '] then Key:=#0;
end;

procedure TForm3.CheckBox1Click(Sender: TObject);
begin
  Form1.AlphaBlend := CheckBox1.Checked;
end;

end.
