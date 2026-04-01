object Form1: TForm1
  Left = 563
  Top = 161
  AlphaBlendValue = 210
  Caption = 'Canvas Stars'
  ClientHeight = 410
  ClientWidth = 558
  Color = clBlack
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 13
  object Timer1: TTimer
    Interval = 25
    OnTimer = Timer1Timer
    Left = 160
    Top = 40
  end
  object MainMenu1: TMainMenu
    Left = 96
    Top = 32
    object N1: TMenuItem
      Caption = 'File'
      object N3: TMenuItem
        Caption = 'Close'
        OnClick = N3Click
      end
    end
    object O1: TMenuItem
      Caption = 'Options'
      object S1: TMenuItem
        Caption = 'Stars'
        OnClick = S1Click
      end
    end
  end
end
