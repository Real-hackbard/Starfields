object Form1: TForm1
  Left = 336
  Top = 197
  BorderStyle = bsNone
  Caption = 'Right Scroller'
  ClientHeight = 558
  ClientWidth = 587
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  PopupMenu = PopupMenu1
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  TextHeight = 13
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 104
    Top = 48
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 48
    object S4: TMenuItem
      AutoCheck = True
      Caption = 'Start'
      Checked = True
      RadioItem = True
      ShortCut = 112
      OnClick = S4Click
    end
    object S5: TMenuItem
      AutoCheck = True
      Caption = 'Stop'
      RadioItem = True
      ShortCut = 113
      OnClick = S5Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object S1: TMenuItem
      Caption = 'Stars'
      object N11: TMenuItem
        AutoCheck = True
        Caption = '100'
        RadioItem = True
        ShortCut = 114
        OnClick = N11Click
      end
      object N21: TMenuItem
        AutoCheck = True
        Caption = '250'
        Checked = True
        RadioItem = True
        ShortCut = 115
        OnClick = N21Click
      end
      object N51: TMenuItem
        AutoCheck = True
        Caption = '500'
        RadioItem = True
        ShortCut = 116
        OnClick = N51Click
      end
      object N12: TMenuItem
        AutoCheck = True
        Caption = '1000'
        RadioItem = True
        ShortCut = 117
        OnClick = N12Click
      end
      object N22: TMenuItem
        AutoCheck = True
        Caption = '2000'
        RadioItem = True
        ShortCut = 118
        OnClick = N22Click
      end
    end
    object S2: TMenuItem
      Caption = 'Speed'
      object N13: TMenuItem
        AutoCheck = True
        Caption = '1 (ms)'
        RadioItem = True
        OnClick = N13Click
      end
      object N52: TMenuItem
        AutoCheck = True
        Caption = '5 (ms)'
        Checked = True
        RadioItem = True
        ShortCut = 119
        OnClick = N52Click
      end
      object N14: TMenuItem
        AutoCheck = True
        Caption = '10 (ms)'
        RadioItem = True
        OnClick = N14Click
      end
      object N23: TMenuItem
        AutoCheck = True
        Caption = '25 (ms)'
        RadioItem = True
        OnClick = N23Click
      end
      object N53: TMenuItem
        AutoCheck = True
        Caption = '50 (ms)'
        RadioItem = True
        OnClick = N53Click
      end
      object N15: TMenuItem
        AutoCheck = True
        Caption = '100 (ms)'
        RadioItem = True
        ShortCut = 120
        OnClick = N15Click
      end
    end
    object C1: TMenuItem
      Caption = 'Colors'
      object B1: TMenuItem
        Caption = 'Background Stars'
        OnClick = B1Click
      end
      object M1: TMenuItem
        Caption = 'Middle Stars'
        OnClick = M1Click
      end
      object F1: TMenuItem
        Caption = 'Front Stars'
        OnClick = F1Click
      end
    end
    object S3: TMenuItem
      Caption = 'Screen'
      object W1: TMenuItem
        AutoCheck = True
        Caption = 'Window Mode'
        RadioItem = True
        ShortCut = 16471
        OnClick = W1Click
      end
      object F2: TMenuItem
        AutoCheck = True
        Caption = 'Fullscreen Mode'
        Checked = True
        RadioItem = True
        ShortCut = 16467
        OnClick = F2Click
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object C2: TMenuItem
      Caption = 'Close'
      OnClick = C2Click
    end
  end
  object ColorDialog1: TColorDialog
    Left = 248
    Top = 48
  end
  object ColorDialog2: TColorDialog
    Left = 320
    Top = 48
  end
  object ColorDialog3: TColorDialog
    Left = 400
    Top = 48
  end
end
