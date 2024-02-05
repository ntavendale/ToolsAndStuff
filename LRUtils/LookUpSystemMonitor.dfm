inherited fmSystemMonitorLookUp: TfmSystemMonitorLookUp
  Caption = 'System Monuitor Look Up'
  PixelsPerInch = 96
  TextHeight = 13
  inherited gbGrid: TRzGroupBox
    Caption = 'System Monitors'
    inherited gLookUp: TcxGrid
      Top = 17
      Height = 407
      inherited tvData: TcxGridTableView
        object colName: TcxGridColumn
          Caption = 'Name'
          Width = 266
        end
        object colHost: TcxGridColumn
          Caption = 'Host'
          Width = 182
        end
        object colEntity: TcxGridColumn
          Caption = 'Entity'
          Width = 184
        end
      end
    end
  end
end
