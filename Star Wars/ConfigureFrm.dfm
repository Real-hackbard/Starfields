object ConfigureForm: TConfigureForm
  Left = 527
  Top = 229
  BorderStyle = bsDialog
  ClientHeight = 427
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 336
    Width = 67
    Height = 13
    Caption = 'Timer Interval:'
  end
  object btnOk: TButton
    Left = 386
    Top = 387
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 470
    Top = 387
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object seTimerInterval: TSpinEdit
    Left = 81
    Top = 332
    Width = 81
    Height = 22
    MaxValue = 0
    MinValue = 1
    TabOrder = 2
    Value = 0
  end
  object grp1: TGroupBox
    Left = 8
    Top = 8
    Width = 225
    Height = 273
    Caption = 'Starfield Options'
    TabOrder = 3
    object lbl1: TLabel
      Left = 3
      Top = 24
      Width = 74
      Height = 13
      Caption = 'Number of stars'
    end
    object lbl2: TLabel
      Left = 3
      Top = 52
      Width = 46
      Height = 13
      Caption = 'Star Color'
    end
    object lbl3: TLabel
      Left = 3
      Top = 84
      Width = 85
      Height = 13
      Caption = 'Background Color'
    end
    object lbl9: TLabel
      Left = 3
      Top = 232
      Width = 42
      Height = 13
      Caption = 'Stepping'
    end
    object seNumStars: TSpinEdit
      Left = 104
      Top = 21
      Width = 73
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 300
    end
    object clbStarColor: TColorBox
      Left = 104
      Top = 49
      Width = 113
      Height = 22
      ItemHeight = 16
      TabOrder = 1
    end
    object clbSFBGColor: TColorBox
      Left = 104
      Top = 81
      Width = 113
      Height = 22
      ItemHeight = 16
      TabOrder = 2
    end
    object rgStarDrawingStyle: TRadioGroup
      Left = 3
      Top = 109
      Width = 110
      Height = 105
      Caption = 'Star Drawing Style'
      ItemIndex = 0
      Items.Strings = (
        'Dots'
        'Blocks'
        'Spheres'
        'Text')
      TabOrder = 3
      OnClick = rgStarDrawingStyleClick
    end
    object edtBmpText: TEdit
      Left = 120
      Top = 184
      Width = 97
      Height = 21
      TabOrder = 4
      Visible = False
    end
    object seSFStepping: TSpinEdit
      Left = 51
      Top = 229
      Width = 47
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 5
      Value = 0
    end
  end
  object grp2: TGroupBox
    Left = 239
    Top = 8
    Width = 306
    Height = 361
    Caption = 'Starwars Scroller Options'
    TabOrder = 4
    object lbl4: TLabel
      Left = 115
      Top = 14
      Width = 43
      Height = 13
      Caption = 'The Text'
    end
    object lbl5: TLabel
      Left = 3
      Top = 215
      Width = 48
      Height = 13
      Caption = 'Text Color'
    end
    object lbl6: TLabel
      Left = 3
      Top = 262
      Width = 85
      Height = 13
      Caption = 'Background Color'
    end
    object lbl7: TLabel
      Left = 3
      Top = 167
      Width = 45
      Height = 13
      Caption = 'Text Font'
    end
    object lbl8: TLabel
      Left = 7
      Top = 305
      Width = 44
      Height = 13
      Caption = 'Font Size'
    end
    object lbl10: TLabel
      Left = 243
      Top = 305
      Width = 42
      Height = 13
      Caption = 'Stepping'
    end
    object btn1: TSpeedButton
      Left = 138
      Top = 184
      Width = 16
      Height = 21
      Caption = '...'
      OnClick = btn1Click
    end
    object mSWText: TMemo
      Left = 27
      Top = 33
      Width = 262
      Height = 128
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object clbTextColor: TColorBox
      Left = 11
      Top = 234
      Width = 113
      Height = 22
      ItemHeight = 16
      TabOrder = 2
    end
    object clbSWBGColor: TColorBox
      Left = 11
      Top = 281
      Width = 113
      Height = 22
      ItemHeight = 16
      TabOrder = 3
    end
    object cbTextFont: TComboBox
      Left = 10
      Top = 184
      Width = 122
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'cbTextFont'
      OnDropDown = cbTextFontDropDown
    end
    object seFontSize: TSpinEdit
      Left = 11
      Top = 324
      Width = 58
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 5
      Value = 0
    end
    object seSWStepping: TSpinEdit
      Left = 243
      Top = 324
      Width = 47
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object cbRepeat: TCheckBox
      Left = 206
      Top = 282
      Width = 67
      Height = 17
      Caption = 'Repeat'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
  end
  object dlgFont1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 504
    Top = 208
  end
end
