unit ScreenSaverUtils;

interface

uses SysUtils, Windows;

type
  TScreenSaverMode = (ssPassword, ssPreview, ssConfigure, ssRun);
var
  ScreenSaverMode: TScreenSaverMode;
  ParentSaverHandle: THandle = 0;

procedure SetScreenSaverMode;
procedure SetScreenSaverPassword; // Calls Halt - doesn't return
function PromptIfPasswordNeeded(ParentHandle: THandle): Boolean;

implementation

uses Registry;

const
  cApplicationName = 'StarWars Screen Saver';

procedure SetScreenSaverMode;
{
  Find the command line switch to set the screen saver mode.
  Switches can be upper or lower case, preceded by /, -, or nothing.
  Some have a number separated either by a space or a colon.

  (none)  - show configuration dialog with no parent window
            (this is what is done when you double click on a .scr file).
  /c      - config dialog with GetForegroundWindow() as parent
  /c #    - config dialog with # as parent
  /s      - run as full-screen saver
  /p #    - show preview within window whose handle is #
  /l #    - same as /p #
  /a #    - show password dialog as child of #
}
var
  Param: string;
begin
  ScreenSaverMode := ssConfigure;
  if ParamCount > 0 then
  begin
    Param := LowerCase(ParamStr(1));
    if Length(Param) > 1 then
      if Param[1] = '/' then
        Delete(Param, 1, 1);
    if Length(Param) > 1 then
      if Param[1] = '-' then
        Delete(Param, 1, 1);
    case Param[1] of
      'c': ScreenSaverMode := ssConfigure;
      's': ScreenSaverMode := ssRun;
      'p': ScreenSaverMode := ssPreview;
      'l': ScreenSaverMode := ssPreview;
      'a': ScreenSaverMode := ssPassword;
    end;
    // Find out if a handle was passed
    if (Length(Param) > 2) and (Param[2] = ':') then
      Delete(Param, 1, 2)
    else if ParamCount > 1 then
      Param := ParamStr(2);
    try
      ParentSaverHandle := StrToInt(Param);
    except
      ParentSaverHandle := 0;
    end;
  end;
  if ScreenSaverMode = ssPassword then
    SetScreenSaverPassword; // Call's halt
end;

procedure SetScreenSaverPassword;
var
  SysDir: string;
  MyMod: THandle;
  PwdFunc: function(a : PChar; ParentHandle: THandle; b, c: Integer):
    Integer; stdcall;
begin
  SetLength(SysDir, MAX_PATH);
  SetLength(SysDir, GetSystemDirectory(PChar(SysDir), MAX_PATH));
  if (Length(SysDir) > 0) and (SysDir[Length(SysDir)] <> '\') then
    SysDir := SysDir+'\';
  MyMod := LoadLibrary(PChar(SysDir + 'MPR.DLL'));
  try
    if MyMod <> 0 then
    begin
      try
        PwdFunc := GetProcAddress(MyMod,'PwdChangePasswordA');
        if Assigned(PwdFunc) then
          PwdFunc('SCRSAVE',StrToInt(ParamStr(2)),0,0)
        else
          raise Exception.Create('Libarary ' + SysDir + 'MPR.DLL does not ' +
            'contain PwdChangePasswordA used to set the password!');
      finally
        FreeLibrary(MyMod);
      end;
    end
    else
      raise Exception.Create('Could not load library ' + SysDir + 'MPR.DLL - ' +
        ' The password cannot be changed');
  except
    on E: Exception do
      MessageBox(ParentSaverHandle, PChar(E.Message), cApplicationName,
        MB_OK or MB_ICONSTOP)
  end;
  Halt;
end;

function PromptIfPasswordNeeded(ParentHandle: THandle): Boolean;
var
  SysDir: string;
  PwdFunc: function (Parent : THandle) : Boolean; stdcall;
  MyMod: THandle;
begin
  // Return true if we can close
  Result := True;
  with TRegistry.Create do
  try
    if OpenKey('Control Panel\Desktop', False) then
    begin
      if ValueExists('ScreenSaveUsePassword') and
        (ReadInteger('ScreenSaveUsePassword') <> 0) then
      begin
        SetLength(SysDir, MAX_PATH);
        SetLength(SysDir, GetSystemDirectory(PChar(SysDir), MAX_PATH));
        if (Length(SysDir) > 0) and (SysDir[Length(SysDir)] <> '\') then
          SysDir := SysDir + '\';
        MyMod := LoadLibrary(PChar(SysDir+'password.cpl'));
        if MyMod <> 0 then
        try
          PwdFunc := GetProcAddress(MyMod, 'VerifyScreenSavePwd');
          if not PwdFunc(ParentHandle) then
            Result := False;
          FreeLibrary(MyMod);
        except
        end;
      end;
    end;
  finally
    Free;
  end;
end;

end.
