object Form1: TForm1
  Left = 838
  Top = 409
  Width = 416
  Height = 399
  Caption = 'igess export'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmo1: TMemo
    Left = 0
    Top = 0
    Width = 400
    Height = 321
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btn_export: TButton
    Left = 8
    Top = 328
    Width = 75
    Height = 25
    Caption = 'btn_export'
    TabOrder = 1
    OnClick = btn_exportClick
  end
end
