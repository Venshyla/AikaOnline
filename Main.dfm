object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 115
  ClientWidth = 314
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 176
    Top = 32
    Width = 129
    Height = 69
    Caption = 'Criar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edit1: TLabeledEdit
    Left = 8
    Top = 32
    Width = 145
    Height = 21
    EditLabel.Width = 11
    EditLabel.Height = 13
    EditLabel.Caption = 'ID'
    TabOrder = 1
  end
  object edit2: TLabeledEdit
    Left = 8
    Top = 80
    Width = 145
    Height = 21
    EditLabel.Width = 30
    EditLabel.Height = 13
    EditLabel.Caption = 'Senha'
    TabOrder = 2
  end
end
