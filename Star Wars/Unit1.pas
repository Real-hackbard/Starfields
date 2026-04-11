unit Unit1;

{ Right-click to configure the screensaver. As you type, the classic Star Wars
  logo will appear, scrolling from the bottom of the screen into the room. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, cStarField, cSWScroller, StdCtrls, RegSettings, XPMan;

type
  TForm1 = class(TForm)
    tmrDraw: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tmrDrawTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FSettings: TSettings;
    FHasActivated: Boolean;
    FLastMousePos: TPoint;

    FIsDrawing: Boolean;

    sf: TStarField;
    sw: TSWScroller;
    z : integer;
    offBmp: TBitmap;

    procedure DoDrawing;
  public
    procedure DoPreviewDrawing;
    function SecondScreenExists: Boolean;
  end;

var
  Form1: TForm1;

implementation

uses ScreenSaverUtils, SingleInstance;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
var
  Dummy: Word;
begin
  FHasActivated := False;
  FIsDrawing := False;
  FLastMousePos.x := -1;
  FLastMousePos.y := -1;

  // Set the position of the form
  Top := 0;
  Left := 0;
  // Create and load the settings
  FSettings := TSettings.Create;

  Screen.Monitors[0].Width;

  offBmp := TBitmap.Create;


  if SecondScreenExists then begin
    offBmp.Height :=   Screen.monitors[0].Height;
    offBmp.Width := Screen.monitors[0].Width;
  end
  else begin
    offBmp.Height := Screen.Height;
    offBmp.Width := Screen.Width;
  end;

  // color background black in case there is no scroller...
  PatBlt(offBmp.Canvas.Handle, 0, 0, offBmp.Width, offBmp.Height, BLACKNESS);


  // create the starfield and initialize
  sf := TStarField.Create;
  sf.StarFieldWidth := Screen.Width;
  sf.StarFieldHeight := Screen.Height;

  // create the Starwars scroller and initialize
  sw := TSWScroller.Create;
  sw.Height := Screen.Height;
  sw.Width := Screen.Width;


  with FSettings do begin
    // starfield and initialize
    sf.StarColor := StarColor;
    sf.StarBGColor := SFBGColor;
    sf.StarDrawStyle := StarDrawingStyle;
    if sf.StarDrawStyle = sdBmp then
      sf.StarText := FSettings.BmpText;
    sf.NumberOfStars := NumStars;

    sw.Lines.Assign(ScrollList);

    sw.TextColor := TextColor;
    sw.BGColor := SWBGColor;
    sw.FontName := FontName;
    sw.TextColor := TextColor;
  end;

  sf.SetUpStars(sf.NumberOfStars);
  sw.InitializeScrolling;
  z := - sw.ScrollHeight;



  Width := Screen.DesktopWidth;
  Height := Screen.DesktopHeight;

  if ScreenSaverMode = ssRun then
  begin
    SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@Dummy,0);
    SetCapture(Self.Handle);
    ShowCursor(False);
  end
  else
  begin
    if (ParentSaverHandle = 0) or (not IsWindow(ParentSaverHandle)) then
      Application.Terminate;
    // Preview mode
    Application.ShowMainForm := False;

    while not IsWindowVisible(ParentSaverHandle) do
      Application.ProcessMessages;
    DoPreviewDrawing;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  Dummy: Word;
begin
  if ScreenSaverMode = ssRun then
  begin
    SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@Dummy,0);
    ReleaseCapture;
    ShowCursor(True);
  end;

  // free the starfield
  sf.Free;
  // the off screen
  offBmp.Free;
  // the scroller
  sw.Free;

  FSettings.Free;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if not FHasActivated then
  begin
    // First activation time
    FHasActivated := True;
    // Start the timer for drawing
    tmrDraw.Interval := FSettings.TimerInterval;
    tmrDraw.Enabled := True;
  end;
end;

procedure TForm1.DoDrawing;
begin
  if not FIsDrawing then
  begin
    FIsDrawing := True;
    // do the actual drawing...
    z := z + FSettings.SWStepping;

    if z > sw.ScrollHeight then begin
      if FSettings.SWRepeat then
        z := -sw.ScrollHeight;
    end
    else begin
      sw.TransformStarwarsBitmap(z);
      sw.DrawStarwarsBitmap(offBmp.Canvas);
    end;

    // do the starfield
    sf.MoveStarField(0, 0, FSettings.SFStepping);
    sf.DrawStarField(offBmp.Canvas);
    // now copy all to screen

    if not SecondScreenExists then
      Canvas.Draw(0, 0, offbmp)
    else begin
      // monitor 1
      BitBlt(Canvas.Handle, 0, 0, Screen.Monitors[0].Width, Screen.Monitors[0].Height,
             offBmp.Canvas.Handle, 0, 0, SRCCOPY);
      // monitor 2
      StretchBlt(Canvas.Handle, Screen.Monitors[1].Left, Screen.Monitors[1].Top,
                 Screen.Monitors[1].Width, Screen.Monitors[1].Height,
                 offBmp.Canvas.Handle, 0, 0, offBmp.Width, offBmp.Height, SRCCOPY );
    end;



    FIsDrawing := False;
  end;
end;

procedure TForm1.tmrDrawTimer(Sender: TObject);
begin
  if ScreenSaverMode = ssRun then
    DoDrawing;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Close;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (FLastMousePos.X = -1) and (FLastMousePos.Y = -1) then
  begin
    FLastMousePos.X := X;
    FLastMousePos.Y := Y;
  end
  else
  begin
    if (Abs(X-FLastMousePos.X) > 2) and (Abs(Y-FLastMousePos.Y) > 2) then
    begin
      FLastMousePos.X := X;
      FLastMousePos.Y := Y;
      Close;
    end;
  end;
end;


function TForm1.SecondScreenExists: Boolean;
begin
  if Screen.MonitorCount > 1 then Result := True
  else Result := false;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ScreenSaverMode = ssRun then
  begin
    tmrDraw.Enabled := False;
    ShowCursor(True);
    CanClose := PromptIfPasswordNeeded(Handle);
    if not CanClose then
    begin
      ShowCursor(False);
      tmrDraw.Enabled := True;
    end;
  end;
end;

procedure TForm1.DoPreviewDrawing;
var
  Rect: TRect;
  cCanvas: TCanvas;
  obmp: TBitmap;
  z: Integer;
begin
  FreeMutex; // Free the mutex so that the screen saver will actually run in preview
  cCanvas := TCanvas.Create;
  try
    cCanvas.Handle := GetDC(ParentSaverHandle);
    try
      GetWindowRect(ParentSaverHandle, Rect);

      // reset the starfield for this canvas...

      sf.SetDimensions((Rect.Right - Rect.Left), (Rect.Bottom - Rect.Top));
      sf.StarDrawStyle := sdDot;
      sf.StarColor := clBlue;
      sf.StarBGColor := clBlack;
      sf.SetUpStars(1000);

      if sw <> nil then FreeAndNil(sw);
      sw := TSWScroller.Create;

      sw.Height := Rect.Bottom - Rect.Top;
      sw.Width := Rect.Right - Rect.Left;

      sw.FontName := Font.Name;
      sw.FontSize := 48;
      sw.TextColor := clYellow;
      sw.BGColor := clBlack;

      sw.Lines.Clear;
      with sw.Lines do begin
        Add('Delphi  Starwars');
        Add('Screen Saver');
        Add('By Davut Tiren');
        Add('I didnt do much...');
        Add(' ');
        Add('Thanks go out to:');
        Add('Denthor of Asphyxia');
        Add('For all his Cool GFX');
        Add('Tutorials, millions ');
        Add('have read!');
        Add('');
        Add('Philipp Crocoll');
        Add('Thanks for the Bitmap');
        Add('Transform routine');
        Add(' ');
        Add('Corbin Dunn');
        Add('From Delphi Developer ');
        Add('Support.');
        Add(' ');
        Add('And the biggest thanks to ');
        Add('Borland for developing and');
        Add('Providing with the ');
        Add('nicest tool available');
        Add('Delphi !!!');

      end;

      sw.InitializeScrolling;
      z := - sw.ScrollHeight;

      obmp := TBitmap.Create;
      obmp.Width := sw.Width;
      obmp.Height := sw.Height;

      while IsWindowVisible(ParentSaverHandle) do
      begin
        if not IsWindowVisible(ParentSaverHandle) then Break;
        // paint it already!
        sf.MoveStarField(0,0, -3);
        z := z + 1;
        if z > sw.ScrollHeight then z := -sw.ScrollHeight;
        sw.TransformStarwarsBitmap(z);

        // Do a check to make sure the window is still visible after
        // the previous operations.
        if IsWindowVisible(ParentSaverHandle) then begin
          sw.DrawStarwarsBitmap(obmp.Canvas);
          sf.DrawStarField(obmp.Canvas);
          cCanvas.Draw(0, 0, obmp);
        end
        else Break;
        Sleep(10);
      end;
    finally
      ReleaseDC(ParentSaverHandle, cCanvas.Handle);
    end;
  finally
    cCanvas.Free;
    obmp.Free;
  end;
  Application.Terminate; // Done with the preview, so quit
end;

end.
