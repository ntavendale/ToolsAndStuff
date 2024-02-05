object fmSyslogSources: TfmSyslogSources
  Left = 0
  Top = 0
  Caption = 'Syslog Sources'
  ClientHeight = 636
  ClientWidth = 967
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object gbSearch: TRzGroupBox
    Left = 0
    Top = 0
    Width = 967
    Height = 49
    Align = alTop
    Caption = 'Search....'
    TabOrder = 0
    object ebSearch: TRzEdit
      Left = 1
      Top = 14
      Width = 965
      Height = 21
      Hint = 'Sort Grid By A Column to Incrementally Search It'
      Text = ''
      Align = alTop
      FrameStyle = fsBump
      FrameVisible = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = ebSearchChange
      OnKeyDown = ebSearchKeyDown
    end
  end
  object gMsgSources: TcxGrid
    Left = 0
    Top = 49
    Width = 967
    Height = 587
    Align = alClient
    PopupMenu = ppmMsgSource
    TabOrder = 1
    object tvMsgSources: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.HideFocusRectOnExit = False
      OptionsSelection.UnselectFocusedRecordOnExit = False
      object colMsgSourceName: TcxGridColumn
        Caption = 'Msg Source'
        Width = 192
      end
      object colMsgSourceType: TcxGridColumn
        Caption = 'Type'
        Width = 153
      end
      object colMsgSourceHost: TcxGridColumn
        Caption = 'Msg Source Host'
        Width = 201
      end
      object colMsgSourceEntity: TcxGridColumn
        Caption = 'Msg Source Entity'
        Width = 193
      end
      object colSystemMonitor: TcxGridColumn
        Caption = 'Agent'
        Width = 196
      end
    end
    object lvMsgSources: TcxGridLevel
      GridView = tvMsgSources
    end
  end
  object ppmMsgSource: TPopupMenu
    Left = 216
    Top = 240
    object ppmiChangeAgent: TMenuItem
      Caption = 'Change System Monitor'
      OnClick = ppmiChangeAgentClick
    end
  end
end
