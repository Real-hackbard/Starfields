unit SingleInstance;

// Only allow one instance of the screen saver to run at a time.
// Windows tends to start multiple copies of the Screen Saver at
// any time.

interface

procedure FreeMutex;

implementation

uses SysUtils, Forms, Windows;

const
  cSWSSString = 'StarWars Screen Saver';
var
  SingleMutex: THandle = 0;

procedure CreateMutexOrDie;
begin
  if OpenMutex(MUTEX_ALL_ACCESS, False, cSWSSString) = 0 then
  begin
    // First one - the mutex didn't exist, so create it.
    SingleMutex := CreateMutex(nil, False, cSWSSString);
  end
  else
  begin
    // The mutex did exist, so the application is running.
    // Terminate it in this case.
    Application.ShowMainForm := False;
    Application.Terminate;
  end;
end;

procedure FreeMutex;
begin
  if SingleMutex <> 0 then
  begin
    CloseHandle(SingleMutex);
    SingleMutex := 0;
  end;
end;

initialization
  CreateMutexOrDie;
finalization
  FreeMutex;
end.
