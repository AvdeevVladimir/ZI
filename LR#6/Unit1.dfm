object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 347
  ClientWidth = 567
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
    Width = 84
    Height = 13
    Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1092#1072#1081#1083':'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 84
    Height = 13
    Caption = #1042#1099#1093#1086#1076#1085#1086#1081' '#1092#1072#1081#1083':'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 32
    Height = 13
    Caption = #1050#1083#1102#1095':'
  end
  object Label4: TLabel
    Left = 240
    Top = 72
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object Edit1: TEdit
    Left = 98
    Top = 8
    Width = 367
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 98
    Top = 35
    Width = 367
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 487
    Top = 8
    Width = 42
    Height = 25
    Caption = '...'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 487
    Top = 33
    Width = 42
    Height = 25
    Caption = '...'
    TabOrder = 3
    OnClick = Button2Click
  end
  object SpinEdit1: TSpinEdit
    Left = 72
    Top = 69
    Width = 121
    Height = 22
    MaxValue = 25
    MinValue = 1
    TabOrder = 4
    Value = 3
  end
  object Edit3: TEdit
    Left = 320
    Top = 69
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 5
  end
  object Button3: TButton
    Left = 136
    Top = 104
    Width = 91
    Height = 25
    Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100
    TabOrder = 6
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 336
    Top = 104
    Width = 89
    Height = 25
    Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100
    TabOrder = 7
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Left = 464
    Top = 248
  end
  object SaveDialog1: TSaveDialog
    Left = 384
    Top = 256
  end
end
