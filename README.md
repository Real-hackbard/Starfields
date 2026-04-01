# Starfields

</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)  ![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) ![None](https://github.com/user-attachments/assets/30ebe930-c928-4aaf-a8e1-5f68ec1ff349)  
![Description](https://github.com/user-attachments/assets/dbf330e0-633c-4b31-a0ef-b1edb9ed5aa7) ![Starfields](https://github.com/user-attachments/assets/93c63144-4174-467b-8a3c-2ecf9046f20f)  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) ![042026](https://github.com/user-attachments/assets/2446b1e1-a732-4080-97bc-11906d6ff389)  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)  

</br>

A Starfield simulation is a classic graphics effect in which small dots (stars) are animated to create the illusion of movement through space. This effect achieved cult status primarily through the legendary screensaver in Windows 3.1 and Windows 95.

</br>

![StarfieldSimulation](https://github.com/user-attachments/assets/4f8f201f-dae2-49f4-a670-f442b974cecb)

</br>

# How the graphics work:
The simulation uses simple mathematical principles to represent depth and movement on a 2D screen:

* Central perspective: All stars move outwards from a central vanishing point.
* Depth parameter (z): Each star is assigned a fictitious depth. The smaller (z) becomes (the star "gets closer"), the faster its (x) and (y) coordinates move towards the edge of the screen.
* Size change: Stars that are "farther away" are displayed as tiny pixels; "closer" stars are drawn larger to enhance the parallax effect.
* Scrolling pixels across multiple levels.
* Scrolling pixels in a 2D space from left to right.
* Scrolling of [canvas](https://en.wikipedia.org/wiki/Canvas_X) graphics instead of pixels in 3D.

</br>

# Create Real 3D-Starfield Animation (Complete Program):
```pascal
program Project1;
{$R-}
{$I-}
{$Q-}

uses  Windows,  Messages,  OpenGL;

const
  WND_TITLE = 'stars';
  FPS_TIMER = 1;                     // Timer to calculate FPS
  FPS_INTERVAL = 500;               // Calculate FPS every 1000 ms
Const
  ThreadLength = 100;
  MaxThreads = 127;
  StarCount = 255;

type TVertex = Record
       X, Y, Z : glFloat;
     end;
var
  h_Wnd  : HWND;                     // Global window handle
  h_DC   : HDC;                      // Global device context
  h_RC   : HGLRC;                    // OpenGL rendering context
  keys : Array[0..255] of Boolean;   // Holds keystrokes
  FPSCount : Integer = 0;            // Counter for FPS
  ElapsedTime : Integer;             // Elapsed time between frames
  Xcoord, Ycoord : Integer;          // mouse coordinates
  Smoothing : Boolean;
  RndVal : glFloat;

  ThreadCount : Integer = 5;
  Stars   : Array[0..StarCount, 0..1] of TVertex;
  Rnd     : Array[0..MaxThreads] of TVertex;
  SSP     : Array[0..StarCount] of glFloat;



procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;

function IntToStr(Num : Integer) : String;
begin
  Str(Num, result);
end;

procedure glDraw();
var I : Integer;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);    // Clear The Screen And The Depth Buffer
  glLoadIdentity();                                       // Reset The View
  glTranslate(0, 0, -7);
  glRotatef(90, 1,0,0);
  // Draw the stars
  For I := 0 to StarCount do
  begin
    glBegin(GL_LINE_STRIP);
      glColor3f((Stars[I,0].Y/5), (Stars[I, 0].Y/5), (Stars[I, 0].Y/5));
      glVertex3fv(@Stars[I, 0]);
      glColor3f(0,0,0);
      glVertex3fv(@Stars[I, 1]);
      Stars[I,1] := Stars[I,0];
      Stars[I,0].Y := Stars[I,0].Y + SSP[I];
      if Stars[I,0].Y >= 10 then
      begin
        SSP[I] := Random(80)/1000;   // ################# star speed
        Stars[I,0].X := (Random(200)-100)/100;
        Stars[I,0].Y := 0;
        Stars[I,0].Z := (Random(200)-100)/100;
        Stars[I,1] := Stars[I,0];
      end;
    glEnd;
  end;
end;


procedure glInit();
var I : Integer;
begin
  glClearColor(0.0, 0.0, 0.0, 0.0); 	     // Black Background
  glShadeModel(GL_SMOOTH);                 // Enables Smooth Color Shading
  glClearDepth(1.0);                       // Depth Buffer Setup
  glDisable(GL_DEPTH_TEST);
  glBlendFunc(GL_ONE, GL_ONE);
  glEnable(GL_BLEND);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  glLineWidth(2);
  Smoothing :=FALSE;
  RndVal :=0.07;
  For I := 0 to StarCount do
    SSP[I] := Random(1000)/1000;

end;

procedure glResizeWnd(Width, Height : Integer);
begin
  if (Height = 0) then                // prevent divide by zero exception
    Height := 1;
  glViewport(0, 0, Width, Height);    // Set the viewport for the OpenGL window
  glMatrixMode(GL_PROJECTION);        // Change Matrix Mode to Projection
  glLoadIdentity();                   // Reset View
  gluPerspective(45.0, Width/Height, 1.0, 100.0);  // Do the perspective calculations. Last value = max clipping depth
  glMatrixMode(GL_MODELVIEW);         // Return to the modelview matrix
  glLoadIdentity();                   // Reset View
end;


function WndProc(hWnd: HWND; Msg: UINT;  wParam: WPARAM;  lParam: LPARAM): LRESULT; stdcall;
begin
  case (Msg) of
    WM_CREATE:
      begin
        // Insert stuff you want executed when the program starts
      end;
    WM_CLOSE:
      begin
        PostQuitMessage(0);
        Result := 0
      end;
    WM_KEYDOWN:       // Set the pressed key (wparam) to equal true so we can check if its pressed
      begin
        keys[wParam] := True;
        Result := 0;
      end;
    WM_KEYUP:         // Set the released key (wparam) to equal false so we can check if its pressed
      begin
        keys[wParam] := False;
        Result := 0;
      end;
    WM_SIZE:          // Resize the window with the new width and height
      begin
        glResizeWnd(LOWORD(lParam),HIWORD(lParam));
        Result := 0;
      end;
    WM_MOUSEMOVE:
      begin
        Xcoord := LOWORD(lParam);
        Ycoord := HIWORD(lParam);
        Result := 0;
      end;
    WM_TIMER :
      begin
        if wParam = FPS_TIMER then
        begin
          FPSCount :=Round(FPSCount * 1000/FPS_INTERVAL);   // calculate to get per Second incase intercal is less or greater than 1 second
          SetWindowText(h_Wnd, PChar(WND_TITLE + '   [' + intToStr(FPSCount) + ' FPS]    Threads=' + intToStr(ThreadCount+1)));
          FPSCount := 0;
          Result := 0;
        end;
      end;
    else
      Result := DefWindowProc(hWnd, Msg, wParam, lParam);    // Default result if nothing happens
  end;
end;

procedure glKillWnd(Fullscreen : Boolean);
begin
  if Fullscreen then
  begin
    ChangeDisplaySettings(devmode(nil^), 0);
    ShowCursor(True);
  end;

  if (not wglMakeCurrent(h_DC, 0)) then
    MessageBox(0, 'Release of DC and RC failed!', 'Error', MB_OK or MB_ICONERROR);

  if (not wglDeleteContext(h_RC)) then
  begin
    MessageBox(0, 'Release of rendering context failed!', 'Error', MB_OK or MB_ICONERROR);
    h_RC := 0;
  end;

  if ((h_DC = 1) and (ReleaseDC(h_Wnd, h_DC) <> 0)) then
  begin
    MessageBox(0, 'Release of device context failed!', 'Error', MB_OK or MB_ICONERROR);
    h_DC := 0;
  end;

  if ((h_Wnd <> 0) and (not DestroyWindow(h_Wnd))) then
  begin
    MessageBox(0, 'Unable to destroy window!', 'Error', MB_OK or MB_ICONERROR);
    h_Wnd := 0;
  end;

  if (not UnRegisterClass('OpenGL', hInstance)) then
  begin
    MessageBox(0, 'Unable to unregister window class!', 'Error', MB_OK or MB_ICONERROR);
    hInstance := 0;
  end;
end;

function glCreateWnd(Width, Height : Integer; Fullscreen : Boolean; PixelDepth : Integer) : Boolean;
var
  wndClass : TWndClass;     
  dwStyle : DWORD;
  dwExStyle : DWORD;
  dmScreenSettings : DEVMODE;
  PixelFormat : GLuint;
  h_Instance : HINST;
  pfd : TPIXELFORMATDESCRIPTOR;
begin
  h_Instance := GetModuleHandle(nil);
  ZeroMemory(@wndClass, SizeOf(wndClass));
  with wndClass do
  begin
    style         := CS_HREDRAW or CS_VREDRAW or CS_OWNDC;
    lpfnWndProc   := @WndProc;
    hInstance     := h_Instance;
    hCursor       := LoadCursor(0, IDC_CROSS);
    lpszClassName := 'OpenGL';
  end;

  if (RegisterClass(wndClass) = 0) then
  begin
    MessageBox(0, 'Failed to register the window class!',
    'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit
  end;

  if Fullscreen then
  begin
    ZeroMemory(@dmScreenSettings, SizeOf(dmScreenSettings));
    with dmScreenSettings do begin
      dmSize       := SizeOf(dmScreenSettings);
      dmPelsWidth  := Width;
      dmPelsHeight := Height;
      dmBitsPerPel := PixelDepth;
      dmFields     := DM_PELSWIDTH or DM_PELSHEIGHT or DM_BITSPERPEL;
    end;

    if (ChangeDisplaySettings(dmScreenSettings, CDS_FULLSCREEN) = DISP_CHANGE_FAILED) then
    begin
      MessageBox(0, 'Unable to switch to fullscreen!',
      'Error', MB_OK or MB_ICONERROR);
      Fullscreen := False;
    end;
  end;

  if (Fullscreen) then
  begin
    dwStyle := WS_POPUP or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    dwExStyle := WS_EX_APPWINDOW;
    ShowCursor(False);
  end
  else
  begin
    dwStyle := WS_OVERLAPPEDWINDOW or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
    dwExStyle := WS_EX_APPWINDOW or WS_EX_WINDOWEDGE;
  end;

  h_Wnd := CreateWindowEx(dwExStyle,      // Extended window styles
                          'OpenGL',       // Class name
                          WND_TITLE,      // Window title (caption)
                          dwStyle,        // Window styles
                          0, 0,           // Window position
                          Width, Height,  // Size of window
                          0,              // No parent window
                          0,              // No menu
                          h_Instance,     // Instance
                          nil);           // Pass nothing to WM_CREATE
  if h_Wnd = 0 then
  begin
    glKillWnd(Fullscreen);
    MessageBox(0, 'Unable to create window!', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  h_DC := GetDC(h_Wnd);
  if (h_DC = 0) then
  begin
    glKillWnd(Fullscreen);
    MessageBox(0, 'Unable to get a device context!', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  with pfd do
  begin
    nSize           := SizeOf(TPIXELFORMATDESCRIPTOR); // Size Of This Pixel Format Descriptor
    nVersion        := 1;                    // The version of this data structure
    dwFlags         := PFD_DRAW_TO_WINDOW    // Buffer supports drawing to window
                       or PFD_SUPPORT_OPENGL // Buffer supports OpenGL drawing
                       or PFD_DOUBLEBUFFER;  // Supports double buffering
    iPixelType      := PFD_TYPE_RGBA;        // RGBA color format
    cColorBits      := PixelDepth;           // OpenGL color depth
    cRedBits        := 0;                    // Number of red bitplanes
    cRedShift       := 0;                    // Shift count for red bitplanes
    cGreenBits      := 0;                    // Number of green bitplanes
    cGreenShift     := 0;                    // Shift count for green bitplanes
    cBlueBits       := 0;                    // Number of blue bitplanes
    cBlueShift      := 0;                    // Shift count for blue bitplanes
    cAlphaBits      := 0;                    // Not supported
    cAlphaShift     := 0;                    // Not supported
    cAccumBits      := 0;                    // No accumulation buffer
    cAccumRedBits   := 0;                    // Number of red bits in a-buffer
    cAccumGreenBits := 0;                    // Number of green bits in a-buffer
    cAccumBlueBits  := 0;                    // Number of blue bits in a-buffer
    cAccumAlphaBits := 0;                    // Number of alpha bits in a-buffer
    cDepthBits      := 16;                   // Specifies the depth of the depth buffer
    cStencilBits    := 0;                    // Turn off stencil buffer
    cAuxBuffers     := 0;                    // Not supported
    iLayerType      := PFD_MAIN_PLANE;       // Ignored
    bReserved       := 0;                    // Number of overlay and underlay planes
    dwLayerMask     := 0;                    // Ignored
    dwVisibleMask   := 0;                    // Transparent color of underlay plane
    dwDamageMask    := 0;                     // Ignored
  end;

  PixelFormat := ChoosePixelFormat(h_DC, @pfd);
  if (PixelFormat = 0) then
  begin
    glKillWnd(Fullscreen);
    MessageBox(0, 'Unable to find a suitable pixel format', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  if (not SetPixelFormat(h_DC, PixelFormat, @pfd)) then
  begin
    glKillWnd(Fullscreen);
    MessageBox(0, 'Unable to set the pixel format', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  h_RC := wglCreateContext(h_DC);
  if (h_RC = 0) then
  begin
    glKillWnd(Fullscreen);
    MessageBox(0, 'Unable to create an OpenGL rendering context', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  if (not wglMakeCurrent(h_DC, h_RC)) then
  begin
    glKillWnd(Fullscreen);
    MessageBox(0, 'Unable to activate OpenGL rendering context', 'Error', MB_OK or MB_ICONERROR);
    Result := False;
    Exit;
  end;

  SetTimer(h_Wnd, FPS_TIMER, FPS_INTERVAL, nil);
  ShowWindow(h_Wnd, SW_SHOW);  SetForegroundWindow(h_Wnd);
  SetFocus(h_Wnd);  glResizeWnd(Width, Height);
  glInit();  Result := True;
end;

function WinMain(hInstance : HINST; hPrevInstance : HINST;
                 lpCmdLine : PChar; nCmdShow : Integer) : Integer; stdcall;
var
  msg : TMsg;
  finished : Boolean;
  DemoStart, LastTime : DWord;
begin
  finished := False;

  if not glCreateWnd(1024, 768, true, 32) then // ##### window
  begin
    Result := 0;
    Exit;
  end;

  //DemoStart := GetTickCount();            // Get Time when demo started
  {$R-}
  {$I-}
  while not finished do
  begin
    if (PeekMessage(msg, 0, 0, 0, PM_REMOVE)) then
    begin
      if (msg.message = WM_QUIT) then
        finished := True
      else
      begin
  	TranslateMessage(msg);
        DispatchMessage(msg);
      end;

    end
    else
    begin
      Inc(FPSCount);
      LastTime :=ElapsedTime;
      ElapsedTime :=GetTickCount() - DemoStart;
      ElapsedTime :=(LastTime + ElapsedTime) DIV 2;
      glDraw();
      SwapBuffers(h_DC);
      if (keys[VK_ESCAPE]) then
        finished := True
      else
        //ProcessKeys;
    end;
  end;
  glKillWnd(FALSE);
  Result := msg.wParam;

  end;

begin
  WinMain( hInstance, hPrevInst, CmdLine, CmdShow );
end.
```






