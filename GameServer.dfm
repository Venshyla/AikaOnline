object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 438
  ClientWidth = 613
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = 'Porta:'
  end
  object Edit1: TEdit
    Left = 8
    Top = 27
    Width = 81
    Height = 21
    MaxLength = 5
    TabOrder = 0
  end
  object Button1: TButton
    Left = 95
    Top = 25
    Width = 89
    Height = 25
    Caption = 'Iniciar Servidor'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    Left = 296
    Top = 8
  end
end
