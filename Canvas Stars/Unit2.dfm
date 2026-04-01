object Form3: TForm3
  Left = 314
  Top = 186
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 153
  ClientWidth = 234
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 16
    Width = 56
    Height = 13
    Caption = 'Star Count :'
  end
  object Label2: TLabel
    Left = 96
    Top = 40
    Width = 37
    Height = 13
    Caption = 'Speed :'
  end
  object Edit1: TEdit
    Left = 144
    Top = 8
    Width = 57
    Height = 21
    TabStop = False
    TabOrder = 0
    Text = '300'
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 144
    Top = 32
    Width = 57
    Height = 21
    TabStop = False
    TabOrder = 1
    Text = '25'
    OnKeyPress = Edit1KeyPress
  end
  object UpDown1: TUpDown
    Left = 201
    Top = 8
    Width = 16
    Height = 21
    Associate = Edit1
    Max = 1000
    Position = 300
    TabOrder = 2
  end
  object UpDown2: TUpDown
    Left = 201
    Top = 32
    Width = 16
    Height = 21
    Associate = Edit2
    Max = 1000
    Position = 25
    TabOrder = 3
  end
  object Button1: TButton
    Left = 144
    Top = 104
    Width = 73
    Height = 25
    Caption = 'Accept'
    TabOrder = 4
    TabStop = False
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 135
    Top = 72
    Width = 79
    Height = 17
    Caption = 'Alpha Blend'
    TabOrder = 5
    OnClick = CheckBox1Click
  end
end
