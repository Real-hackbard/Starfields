unit RegSettings;

interface

uses Windows, Classes, SysUtils, Registry, Graphics, cStarField;

type
  TSettings = class
  private
    // starfield properties
    FNumStars: integer;
    FStarColor: TColor;
    FSFBGColor: TColor;
    FStarDrawingStyle: TStarDrawStyle;
    FbmpText: string;
    FSFStepping: integer;

    // SWScroller properties
    FScrollList: TStringList;
    FFontName: string;
    FTextColor: TColor;
    FSWBGColor: TColor;
    FFontSize: integer;
    FSWRepeat: Boolean;
    FSWStepping: integer;


    FTimerInterval: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadRegistrySettings;
    procedure SaveRegistrySettings;

    property NumStars: integer read FNumStars write FNumStars;
    property StarColor: TColor read FStarColor write FStarColor;
    property SFBGColor: TColor read FSFBGColor write FSFBGColor;
    property StarDrawingStyle: TStarDrawStyle read FStarDrawingStyle write FStarDrawingStyle;
    property BmpText: string read FbmpText write FbmpText;
    property SFStepping: integer read FSFStepping write FSFStepping;
    property ScrollList: TStringList read FScrollList write FScrollList;
    property FontName: string read FFontName write FFontName;
    property TextColor: TColor read FTextColor write FTextColor;
    property SWBGColor: TColor read FSWBGColor write FSWBGColor;
    property FontSize: integer read FFontSize write FFontSize;
    property SWRepeat: Boolean read FSWRepeat write FSWRepeat;
    property SWStepping: integer read FSWStepping write FSWStepping;

    property TimerInterval: Integer read FTimerInterval write FTimerInterval;
  end;


implementation

constructor TSettings.Create;
begin
  FScrollList := TStringList.Create;
  // give some initial start values in case it is never run...
    // starfield properties
    FNumStars := 1000;
    FStarColor:= clWhite;
    FSFBGColor:= clBlack;
    FStarDrawingStyle:= sdDot;
    FbmpText := '*';
    FSFStepping := -1;

    // SWScroller properties
    FScrollList.Add('Star Wars Scroller');
    FFontName:= 'Arial';
    FTextColor:= clYellow;
    FSWBGColor:= clBlack;
    FFontSize:= 48;
    FSWRepeat:= True;
    FSWStepping:= 1;

  FTimerInterval := 10;
  LoadRegistrySettings;
end;

destructor TSettings.Destroy;
begin
  FScrollList.Free;
end;

const
  cRegBaseKey = 'Software\StarWars Screen Saver';

  cStarFieldKey = 'StarField';
  cStarWarsScrollerKey = 'StarWarsScrollerKey';
  cNumStars = 'NumStars';
  cStarColor = 'StarColor';
  cSFBGColor = 'SFBGColor';
  cStarDrawingStyle = 'StarDrawingStyle';
  cBmpText = 'BmpText';
  cSFStepping = 'SFStepping';
  cScrollListKey = 'ScrollerLines';
  cFontName = 'FontName';
  cTextColor = 'TextColor';
  cSWBGColor = 'SWBGColor';
  cFontSize = 'FontSize';
  cSWRepeat = 'SWRepeat';
  cSWStepping = 'SWStepping';
  cRegInterval = 'Timer interval';

procedure TSettings.LoadRegistrySettings;
var
  I: Integer;
begin
  FScrollList.Clear;
  with TRegistry.Create do
  try
    if OpenKey(cRegBaseKey, False) then begin
      if ValueExists(cRegInterval) then
        FTimerInterval := ReadInteger(cRegInterval);
      if OpenKey(cStarFieldKey, False) then begin
        if ValueExists(cNumStars) then FNumStars := ReadInteger(cNumStars);
        if ValueExists(cStarColor) then FStarColor := TColor(ReadInteger(cStarColor));
        if ValueExists(cSFBGColor) then FSFBGColor := TColor(ReadInteger(cSFBGColor));
        if ValueExists(cStarDrawingStyle) then FStarDrawingStyle := TStarDrawStyle(ReadInteger(cStarDrawingStyle));
        if ValueExists(cBmpText) then FbmpText := ReadString(cBmpText);
        if ValueExists(cSFStepping ) then FSFStepping := ReadInteger(cSFStepping);
      end;
      CloseKey;
    end;
    if OpenKey(cRegBaseKey, False) then begin
      if OpenKey(cStarWarsScrollerKey, False) then begin
        if ValueExists(cFontName) then FFontName := ReadString(cFontName);
        if ValueExists(cTextColor) then FTextColor := TColor(ReadInteger(cTextColor));
        if ValueExists(cSWBGColor) then FSWBGColor := TColor(ReadInteger(cSWBGColor));
        if ValueExists(cFontSize) then FFontSize := ReadInteger(cFontSize);
        if ValueExists(cSWRepeat) then FSWRepeat := ReadBool(cSWRepeat);
        if ValueExists(cSWStepping) then FSWStepping := ReadInteger(cSWStepping);

        if OpenKey(cScrollListKey, False) then begin
          i := 0;
          while ValueExists(IntToStr(i)) do begin
            FScrollList.Add(ReadString(IntToStr(i)));
            Inc(i);
          end;
        end;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TSettings.SaveRegistrySettings;
var i : integer;
begin
  with TRegistry.Create do
  try
    if OpenKey(cRegBaseKey, True) then begin
      WriteInteger(cRegInterval, FTimerInterval);
      DeleteKey(cStarFieldKey);
      if OpenKey(cStarFieldKey, True) then begin
        WriteInteger(cNumStars, FNumStars);
        WriteInteger(cStarColor, Integer(FStarColor));
        WriteInteger(cSFBGColor, Integer(FSFBGColor));
        WriteInteger(cStarDrawingStyle, Integer(FStarDrawingStyle));
        WriteString(cBmpText, FbmpText);
        WriteInteger(cSFStepping, FSFStepping);
        CloseKey;
      end;
    end;

    if OpenKey(cRegBaseKey, True) then begin
      DeleteKey(cStarWarsScrollerKey);
      if OpenKey(cStarWarsScrollerKey, True) then begin
        WriteString(cFontName, FFontName);
        WriteInteger(cTextColor, Integer(FTextColor));
        WriteInteger(cSWBGColor, Integer(FSWBGColor));
        WriteInteger(cFontSize, FFontSize);
        WriteBool(cSWRepeat, FSWRepeat);
        WriteInteger(cSWStepping, FSWStepping);
        if OpenKey(cScrollListKey, true) then begin
          for i := 0 to FScrollList.Count - 1 do
            WriteString(IntToStr(i), FScrollList[i]);
        end;
      end;
    end;
  finally
    Free;
  end;
end;


end.
