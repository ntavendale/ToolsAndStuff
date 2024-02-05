inherited fmLoginDetails: TfmLoginDetails
  Left = 656
  Top = 263
  Caption = 'Login Details'
  ClientHeight = 268
  ClientWidth = 426
  OnShow = FormShow
  ExplicitWidth = 432
  ExplicitHeight = 296
  PixelsPerInch = 96
  TextHeight = 13
  inherited RzPanel1: TRzPanel
    Width = 426
    Height = 235
    ExplicitWidth = 565
    ExplicitHeight = 180
    object RzGroupBox1: TRzGroupBox
      Left = 0
      Top = 0
      Width = 426
      Height = 235
      Align = alClient
      BorderOuter = fsBump
      Caption = 'EMDB'
      GroupStyle = gsStandard
      TabOrder = 0
      ExplicitHeight = 308
      object RzLabel3: TRzLabel
        Left = 13
        Top = 110
        Width = 52
        Height = 13
        Caption = 'User Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object RzLabel5: TRzLabel
        Left = 13
        Top = 160
        Width = 46
        Height = 13
        Caption = 'Password'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object RzLabel6: TRzLabel
        Left = 13
        Top = 24
        Width = 22
        Height = 13
        Caption = 'Host'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object RzLabel1: TRzLabel
        Left = 13
        Top = 66
        Width = 76
        Height = 13
        Caption = 'Database Name'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object ebEMDBUsername: TRzEdit
        Left = 13
        Top = 129
        Width = 404
        Height = 21
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 2
      end
      object ebEMDBPassword: TRzEdit
        Left = 13
        Top = 179
        Width = 404
        Height = 21
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        PasswordChar = '*'
        TabOrder = 3
      end
      object ebEMDBHost: TRzEdit
        Left = 13
        Top = 42
        Width = 404
        Height = 21
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 0
      end
      object ebEMDBDatabasename: TRzEdit
        Left = 13
        Top = 85
        Width = 404
        Height = 21
        Text = ''
        FrameStyle = fsBump
        FrameVisible = True
        TabOrder = 1
      end
      object ckbWindowsAuth: TRzCheckBox
        Left = 13
        Top = 206
        Width = 90
        Height = 15
        Caption = 'Windows Login'
        HotTrack = True
        State = cbUnchecked
        TabOrder = 4
        OnClick = ckbWindowsAuthClick
      end
    end
  end
  inherited RzPanel2: TRzPanel
    Top = 235
    Width = 426
    Height = 33
    ExplicitTop = 304
    ExplicitWidth = 426
    ExplicitHeight = 33
    inherited pnOKCancel: TRzPanel
      Left = 265
      Height = 33
      ExplicitLeft = 404
      ExplicitHeight = 33
    end
  end
end
