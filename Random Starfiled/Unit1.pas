unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Menus;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    PaintBox1: TPaintBox;
    PopupMenu1: TPopupMenu;
    F1: TMenuItem;
    N81: TMenuItem;
    N51: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    N31: TMenuItem;
    C1: TMenuItem;
    N1: TMenuItem;
    S1: TMenuItem;
    N52: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N53: TMenuItem;
    B1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N81Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Declarations privates }
  public
    { Declarations public }
  end;

type
   // Here, the pScanArray type allows us to retrieve the maximum 4096 pixels.
   // Transmitted by Bitmap.ScanLine, it's a pointer to the TScanArray type.
   pScanArray = ^TScanArray;
   TScanArray = array[0..4095] of integer;

var
  Form1: TForm1;
  Buffer : TBitmap; // buffer for the effect

implementation

{$R *.dfm}
procedure MakeFormFullscreenAcrossAllMonitors(Form: TForm);
begin
  Form.BorderStyle := bsNone;
  Form.WindowState := wsNormal; // Make sure it is not maximized

  // Use the virtual screen boundaries
  Form.Left := 0;
  Form.Top := 0;
  Form.Width := Screen.DesktopWidth;
  Form.Height := Screen.DesktopHeight;

  // Optional: If this still doesn't take precedence over everything,
  // consider the taskbar.
  // or use Form.BringToFront.
end;

function Max(const A,B : integer) : integer;
begin
  if B > A then 
    result := B
  else
    result := A;
end;

// function allowing the creation of a grey level from a single byte.
function CreateGray(const B : byte) : integer;
begin
  result := B + (B shl 8) + (B shl 16);
end;

// The snow effect, simple to use.
procedure FX_Starfield(const Starfield, GroundColor : integer;
          const ShowScan : boolean; Bitmap : Tbitmap);
var
  N,
  X,Y,
  CB  : integer;
   
	// By setting TScanArray to a value of 4096,
  // we obtain 3 buffers of a maximum of 16KB, which is reasonable and sufficient.
	PSA0,
	PSA1,
	PSA2 : pScanArray; 
    
	XOK1,
	YOK1,
  XOK2,
	YOK2 : boolean;
    
	Col0,
	Col1,
	Col2 : integer;
begin
  // we fill in the background of the image
  Bitmap.Canvas.Brush.Color := GroundColor;
  Bitmap.Canvas.FillRect(Rect(0,0,Bitmap.Width,Bitmap.Height));

  // If SnowCount is 0 or lower, we don't waste time and we leave.
  if Starfield <= 0 then
     exit;

  for N := 0 to Starfield do begin
      // We retrieve random coordinates to place the point
      X := Random(Bitmap.Width);
      Y := Random(Bitmap.Height);
	  
	  // We retrieve a random value of 0..255 for the grey level
      CB:= Random(256);

	  // we check a few conditions
      XOK1 := X > 0;
      XOK2 := X < Bitmap.Width-1;
      YOK1 := Y > 0;
      YOK2 := Y < Bitmap.Height-1;

	  // If everything is OK, we can create the image.
      if (YOK1 and YOK2) and (XOK1 and XOK2) then begin
	     
		 // we create the main color
         Col0 := CreateGray(CB);
		 
         // it is assigned to the random point
         PSA0 := Bitmap.ScanLine[Y];
         PSA0[X]   := Col0;

		 // If we don't use the scanline effect, we'll display large dots.
         if not ShowScan then begin
		    
			// provided that the random color is greater than 0
            if CB > 0 then begin
			    // We calculate the other two levels for a better effect
          // [color-33%] [color-20%] [color-33%]
          // [color-20%] [color] [color-20%]
          // [color-33%] [color-20%] [color-33%]
		   
               Col1 := CreateGray(max(CB-(CB div 5),0));
               Col2 := CreateGRay(max(CB-(CB div 3),0));
            end else begin
			   // otherwise it's black
               Col1 := 0;
               Col2 := 0;
            end;

			// Nothing too complicated here, we create a 3x3 pixel square around the first one
      // point ...
			// [x-1, y-1] [x  , y-1] [x+1, y-1]  = PSA1
			// [x-1, y  ] [x  , y  ] [x+1, y  ]  = PSA0
			// [x-1, y+1] [x  , y+1] [x+1, y+1]  = PSA2

            // We retrieve the line above and below the origin point (x,y)
            PSA1 := Bitmap.ScanLine[Y-1];
            PSA2 := Bitmap.ScanLine[Y+1];

            PSA1[X-1] := Col2;
            PSA1[X]   := Col1;
            PSA1[X+1] := Col2;
            PSA0[X-1] := Col1;
			// PSA0[X] has already been assigned above
            PSA0[X+1] := Col1;
            PSA2[X-1] := Col2;
            PSA2[X]   := Col1;
            PSA2[X+1] := Col2;
         end;
      end;
   end;

   // Finally, if we use the scanline effect
   if ShowScan then
      // We fill all the even-numbered rows with the background color
      for Y := 0 to Bitmap.height-1 do
	      // Tip: Y mod 2 is equal to 0 if Y is even and different from 0 if odd.
          if (Y mod 2) = 0 then
          begin
             PSA0 := Bitmap.ScanLine[Y];
             for X := 0 to Bitmap.Width-1 do
                 PSA0[X] := GroundColor;
          end;
end;

// upon creation of the record
procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  DoubleBuffered := true;
  MakeFormFullscreenAcrossAllMonitors(Form1);

  // We create the buffer; here we will save time by avoiding thousands of
  // creation/destruction of the buffer with each image creation.
  try
    Buffer             := Tbitmap.Create;
    Buffer.PixelFormat := pf32bit; // 32 bits because we use an Array of integers for the colors
                                   // This is notably faster than 24-bit and better than 16-bit.
                   // although with greyscale we could work in 16 bits
                   // but less obvious and simple...
    Buffer.Width       := PaintBox1.Width;
    Buffer.Height      := PaintBox1.Height;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;

  // We start the timer
  Timer1.Enabled  := true;

  {
    As Cirec suggests, the doublebuffer is unnecessary here since the bitmap
    serves as our double buffer. We can therefore ignore the
    PaintBox's OnPaint event and the setting of
    the doublebuffered property in the form. This saves CPU cycles and resources.
  }
end;

// to the destruction of the record
procedure TForm1.FormDestroy(Sender: TObject);
begin
  // we release the buffer
  Buffer.Free;
end;
// the timer
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // We resize the buffer to the size of the paintbox, just in case
  Buffer.Width  := PaintBox1.Width;
  Buffer.Height := PaintBox1.Height;

  // the effect is applied to the buffer
  // allows you to change the number of points in the effect.
  // number of points displayed in a label
  // shl 2 corresponds to a multiplication by 4 but consumes fewer CPU
  // cycles than a multiplication
  // from 0 to 5000, although we could have defined it differently.
  // a larger interval, but this allows us to demonstrate the
  // multiplication technique via SHL
  if B1.Checked = true then
  begin
    if N52.Checked = true then FX_Starfield(500 shl 2, $121212, false, Buffer);
    if N11.Checked = true then FX_Starfield(1000 shl 2, $121212, false, Buffer);
    if N21.Checked = true then FX_Starfield(2500 shl 2, $121212, false, Buffer);
    if N53.Checked = true then FX_Starfield(5000 shl 2, $121212, false, Buffer);
  end else begin
    if N52.Checked = true then FX_Starfield(500 shl 2, $121212, true, Buffer);
    if N11.Checked = true then FX_Starfield(1000 shl 2, $121212, true, Buffer);
    if N21.Checked = true then FX_Starfield(2500 shl 2, $121212, true, Buffer);
    if N53.Checked = true then FX_Starfield(5000 shl 2, $121212, true, Buffer);
  end;

  // We draw the buffer in the Paintbox canvas
  PaintBox1.Canvas.Draw(0,0,Buffer);
end;

// The OnChange function of ComboBox1 allows you to set the desired FPS.
procedure TForm1.N81Click(Sender: TObject);
begin
  // FPS = Frames Per Second
  // The timer interval is expressed in milliseconds.
  // Therefore, you must divide 1000 (1 second) by the desired number of FPS.
  // To obtain the interval in milliseconds between each refresh, divide 1000 (1 second) by the desired number of FPS.
  // The higher the FPS, the shorter the interval in milliseconds will be. // Remember this well because it's pointless, in a graphics application,
  // to go beyond 30 FPS with GDI, and your application
  // will be less CPU-intensive if you use a 40ms interval instead of
  // a 1ms interval (~1000 FPS) or 20ms (50 FPS)...
  // This is also one of the vital optimizations that allows you to increase
  // the smoothness of a program, a frame-by-frame animation, or object movement
  // by incrementing position (Left/Top -/+ n).
  
  Timer1.Interval := 1000 div 12; // 83 ms

  // It is not necessary to disable and re-enable the timer to change
  // the interval; the timer does it automatically. However, in some
  // cases, you may have to do so, but this is rare.
end;

procedure TForm1.N51Click(Sender: TObject);
begin
  Timer1.Interval := 1000 div 20; // 50 ms
end;

procedure TForm1.N41Click(Sender: TObject);
begin
  Timer1.Interval := 1000 div 23; // 43 ms
end;

procedure TForm1.N42Click(Sender: TObject);
begin
  Timer1.Interval := 1000 div 25; // 40 ms
end;

procedure TForm1.N31Click(Sender: TObject);
begin
  Timer1.Interval := 1000 div 30; // 33 ms
end;

procedure TForm1.C1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Close();
end;

end.
