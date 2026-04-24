object Form1: TForm1
  Left = 438
  Top = 169
  Width = 656
  Height = 567
  Caption = 'Random Starrfield'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 640
    Height = 528
    Align = alClient
    Constraints.MinHeight = 480
    Constraints.MinWidth = 640
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 28
    Top = 28
  end
  object PopupMenu1: TPopupMenu
    Left = 64
    Top = 32
    object F1: TMenuItem
      Caption = 'FPS'
      object N81: TMenuItem
        AutoCheck = True
        Caption = '83 ms'
        Checked = True
        RadioItem = True
        OnClick = N81Click
      end
      object N51: TMenuItem
        AutoCheck = True
        Caption = '50 ms'
        RadioItem = True
        OnClick = N51Click
      end
      object N41: TMenuItem
        AutoCheck = True
        Caption = '43 ms'
        RadioItem = True
        OnClick = N41Click
      end
      object N42: TMenuItem
        AutoCheck = True
        Caption = '40 ms'
        RadioItem = True
        OnClick = N42Click
      end
      object N31: TMenuItem
        AutoCheck = True
        Caption = '33 ms'
        RadioItem = True
        OnClick = N31Click
      end
    end
    object S1: TMenuItem
      Caption = 'Stars'
      object N52: TMenuItem
        AutoCheck = True
        Caption = '500'
        RadioItem = True
      end
      object N11: TMenuItem
        AutoCheck = True
        Caption = '1000'
        Checked = True
        RadioItem = True
      end
      object N21: TMenuItem
        AutoCheck = True
        Caption = '2500'
        RadioItem = True
      end
      object N53: TMenuItem
        AutoCheck = True
        Caption = '5000'
        RadioItem = True
      end
    end
    object B1: TMenuItem
      AutoCheck = True
      Caption = 'Bold'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object C1: TMenuItem
      Caption = 'Close'
      OnClick = C1Click
    end
  end
end
