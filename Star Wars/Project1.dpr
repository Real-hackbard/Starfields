program Project1;

uses
  Windows,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SingleInstance in 'SingleInstance.pas',
  ScreenSaverUtils in 'ScreenSaverUtils.pas',
  ConfigureFrm in 'ConfigureFrm.pas' {ConfigureForm},
  cStarField in 'cStarField.pas',
  cSWScroller in 'cSWScroller.pas',
  RegSettings in 'RegSettings.pas';

{$R *.RES}
{$E scr} // Set the screen saver's extension

// To get the name to work in the Display Settings, you must have:
// a short file name (8.3 characters), an all lowercase filename,
// and a stringtable resource with an ID of 1. The below .res file
// has this. See the .bat file on how to make it. Edit the .rc file
// to modify what the title is.
{$R delphi_string_table.RES}

begin
  // First, process the Param's passed to see
  // what mode the screen saver is to run in
  // This set's the global variable's ScreenSaverMode
  // and ParentHandle. If the mode was to set the password,
  // a call to this function will never return (it calls Halt).
  SetScreenSaverMode;

  Randomize;
  Application.Initialize;
  Application.Title := '';
  SetWindowLong(Application.Handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
  if ScreenSaverMode = ssConfigure then
  begin
    // Create the configure form to configure the screen saver
    Application.CreateForm(TConfigureForm, ConfigureForm);
  end
  else
  begin
    // We are either doing a preview or actually running the screen saver
    Application.CreateForm(TForm1, Form1);
  end;


  Application.Run;
end.
