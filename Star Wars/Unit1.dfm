object Form1: TForm1
  Left = 485
  Top = 180
  BorderStyle = bsNone
  Caption = 'Form1'
  ClientHeight = 395
  ClientWidth = 448
  Color = clBlack
  Font.Charset = ANSI_CHARSET
  Font.Color = clYellow
  Font.Height = -32
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnMouseMove = FormMouseMove
  PixelsPerInch = 96
  TextHeight = 45
  object tmrDraw: TTimer
    Enabled = False
    Interval = 1
    OnTimer = tmrDrawTimer
    Left = 416
    Top = 232
  end
end
