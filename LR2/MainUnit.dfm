object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'DESX '#1064#1080#1092#1088#1086#1074#1072#1083#1100#1097#1080#1082
  ClientHeight = 461
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pcMain: TPageControl
    Left = 0
    Top = 0
    Width = 684
    Height = 461
    ActivePage = tsText
    Align = alClient
    TabOrder = 0
    object tsText: TTabSheet
      Caption = #1064#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1090#1077#1082#1089#1090#1072
      object lblSource: TLabel
        Left = 10
        Top = 10
        Width = 87
        Height = 13
        Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1090#1077#1082#1089#1090':'
      end
      object lblEncrypted: TLabel
        Left = 10
        Top = 135
        Width = 120
        Height = 13
        Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1085#1099#1081' '#1090#1077#1082#1089#1090':'
      end
      object lblDecrypted: TLabel
        Left = 10
        Top = 260
        Width = 125
        Height = 13
        Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1085#1085#1099#1081' '#1090#1077#1082#1089#1090':'
      end
      object memSource: TMemo
        Left = 10
        Top = 25
        Width = 660
        Height = 100
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object memEncrypted: TMemo
        Left = 13
        Top = 154
        Width = 660
        Height = 100
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object memDecrypted: TMemo
        Left = 10
        Top = 275
        Width = 660
        Height = 100
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object btnEncryptString: TButton
        Left = 200
        Top = 390
        Width = 130
        Height = 25
        Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090
        TabOrder = 3
        OnClick = btnEncryptStringClick
      end
      object btnDecryptString: TButton
        Left = 350
        Top = 390
        Width = 130
        Height = 25
        Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090
        TabOrder = 4
        OnClick = btnDecryptStringClick
      end
    end
    object tsFiles: TTabSheet
      Caption = #1064#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbSourceFile: TGroupBox
        Left = 10
        Top = 10
        Width = 660
        Height = 60
        Caption = #1048#1089#1093#1086#1076#1085#1099#1081' '#1092#1072#1081#1083
        TabOrder = 0
        object edSourceFile: TEdit
          Left = 10
          Top = 20
          Width = 500
          Height = 21
          TabOrder = 0
        end
        object btnBrowseSource: TButton
          Left = 520
          Top = 18
          Width = 120
          Height = 25
          Caption = #1054#1073#1079#1086#1088'...'
          TabOrder = 1
          OnClick = btnBrowseSourceClick
        end
      end
      object gbDestFile: TGroupBox
        Left = 10
        Top = 80
        Width = 660
        Height = 60
        Caption = #1056#1077#1079#1091#1083#1100#1090#1080#1088#1091#1102#1097#1080#1081' '#1092#1072#1081#1083
        TabOrder = 1
        object edDestFile: TEdit
          Left = 10
          Top = 20
          Width = 500
          Height = 21
          TabOrder = 0
        end
        object btnBrowseDest: TButton
          Left = 520
          Top = 18
          Width = 120
          Height = 25
          Caption = #1054#1073#1079#1086#1088'...'
          TabOrder = 1
          OnClick = btnBrowseDestClick
        end
      end
      object btnEncryptFile: TButton
        Left = 200
        Top = 160
        Width = 130
        Height = 25
        Caption = #1047#1072#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1092#1072#1081#1083
        TabOrder = 2
        OnClick = btnEncryptFileClick
      end
      object btnDecryptFile: TButton
        Left = 350
        Top = 160
        Width = 130
        Height = 25
        Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1090#1100' '#1092#1072#1081#1083
        TabOrder = 3
        OnClick = btnDecryptFileClick
      end
      object ProgressBar1: TProgressBar
        Left = 10
        Top = 200
        Width = 600
        Height = 20
        TabOrder = 4
      end
    end
    object tsKeys: TTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1083#1102#1095#1077#1081
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbKeys: TGroupBox
        Left = 10
        Top = 10
        Width = 660
        Height = 200
        Caption = #1050#1083#1102#1095#1080' DESX (8 '#1073#1072#1081#1090' '#1082#1072#1078#1076#1099#1081')'
        TabOrder = 0
        object lblKey1: TLabel
          Left = 10
          Top = 20
          Width = 99
          Height = 13
          Caption = #1050#1083#1102#1095' 1 ('#1086#1089#1085#1086#1074#1085#1086#1081'):'
        end
        object lblKey2: TLabel
          Left = 10
          Top = 50
          Width = 180
          Height = 13
          Caption = #1050#1083#1102#1095' 2 (XOR '#1087#1077#1088#1077#1076' '#1096#1080#1092#1088#1086#1074#1072#1085#1080#1077#1084'):'
        end
        object lblKey3: TLabel
          Left = 10
          Top = 80
          Width = 172
          Height = 13
          Caption = #1050#1083#1102#1095' 3 (XOR '#1087#1086#1089#1083#1077' '#1096#1080#1092#1088#1086#1074#1072#1085#1080#1103'):'
        end
        object lblKeyStatusTitle: TLabel
          Left = 30
          Top = 160
          Width = 82
          Height = 13
          Caption = #1057#1090#1072#1090#1091#1089' '#1082#1083#1102#1095#1077#1081':'
        end
        object lblKeyStatus: TLabel
          Left = 130
          Top = 160
          Width = 119
          Height = 13
          Caption = #1050#1083#1102#1095#1080' '#1085#1077' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object edKey1: TEdit
          Left = 150
          Top = 17
          Width = 200
          Height = 21
          MaxLength = 8
          TabOrder = 0
          Text = '12345678'
        end
        object edKey2: TEdit
          Left = 200
          Top = 47
          Width = 200
          Height = 21
          MaxLength = 8
          TabOrder = 1
          Text = 'ABCDEFGH'
        end
        object edKey3: TEdit
          Left = 200
          Top = 77
          Width = 200
          Height = 21
          MaxLength = 8
          TabOrder = 2
          Text = '87654321'
        end
        object btnSetKeys: TButton
          Left = 30
          Top = 120
          Width = 150
          Height = 25
          Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1082#1083#1102#1095#1080
          TabOrder = 3
          OnClick = btnSetKeysClick
        end
        object btnGenerateRandomKeys: TButton
          Left = 200
          Top = 120
          Width = 200
          Height = 25
          Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1089#1083#1091#1095#1072#1081#1085#1099#1077' '#1082#1083#1102#1095#1080
          TabOrder = 4
          OnClick = btnGenerateRandomKeysClick
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*||'#1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt||'#1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1085#1099#1077' '#1092#1072#1081#1083#1099'|*.desx'
    Left = 104
    Top = 408
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'desx'
    Filter = #1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*||'#1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt||'#1047#1072#1096#1080#1092#1088#1086#1074#1072#1085#1085#1099#1077' '#1092#1072#1081#1083#1099'|*.desx'
    Left = 24
    Top = 408
  end
end
