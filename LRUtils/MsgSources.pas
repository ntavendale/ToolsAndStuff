unit MsgSources;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Generics.Collections,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, RzEdit,
  Vcl.ExtCtrls, RzPanel, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkroom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringtime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinTheBezier, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, dxDateRanges, dxCore,
  cxDataControllerConditionalFormattingRulesManagerDialog, Data.DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, MsgSource.Syslog, Settings,
  DataServices, LookUpSystemMonitor, Utilities, Vcl.Menus, FileLogger;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TSyslogMsgSourceList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AList: TSyslogMsgSourceList);
    destructor Destroy; override;
    property MsgSources: TSyslogMsgSourceList read FList;
  end;

  TfmSyslogSources = class(TForm)
    gbSearch: TRzGroupBox;
    ebSearch: TRzEdit;
    lvMsgSources: TcxGridLevel;
    gMsgSources: TcxGrid;
    tvMsgSources: TcxGridTableView;
    colMsgSourceName: TcxGridColumn;
    colMsgSourceType: TcxGridColumn;
    colMsgSourceHost: TcxGridColumn;
    colSystemMonitor: TcxGridColumn;
    colMsgSourceEntity: TcxGridColumn;
    ppmMsgSource: TPopupMenu;
    ppmiChangeAgent: TMenuItem;
    procedure ppmiChangeAgentClick(Sender: TObject);
    procedure ebSearchChange(Sender: TObject);
    procedure ebSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure GetData;
    procedure LoadGrid(AList: TSyslogMsgSourceList);
    procedure ClearGrid;
    function SelectSystemMonitorID: Integer;
    procedure LoadSort(AGridTableView: TcxGridTableView);
    procedure SaveSort(AGridTableView: TcxGridTableView);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{$REGION 'TGridDataSource'}
constructor TGridDataSource.Create(AList: TSyslogMsgSourceList);
begin
  if nil = AList then
    FList := TSyslogMsgSourceList.Create
  else
    FList := TSyslogMsgSourceList.Create(AList);
end;

destructor TGridDataSource.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TGridDataSource.GetRecordCount: Integer;
begin
  if nil = FList then
    Result := 0
  else
    Result := FList.Count;
end;

function TGridDataSource.GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant;
begin
  Result := NULL;
  var LRecordIndex := Integer(ARecordHandle);
  var LRec := FList[LRecordIndex];
  if nil = LRec then
    EXIT;

  var LCloumnIndex := Integer(AItemHandle);

  case LCloumnIndex of
    0: Result := LRec.MsgSourceName;
    1: Result := LRec.MsgSourceType;
    2: Result := LRec.MsgSourceHost;
    3: Result := LRec.MsgSourceHostEnity;
    4: Result := LRec.SystemMonitor;
  end;
end;
{$ENDREGION}

{$REGION 'Custom Methods'}
constructor TfmSyslogSources.Create(AOwner: TComponent);
begin
  inherited Create(nil);
  GetData;
  LoadSort(tvMsgSources);
end;

destructor TfmSyslogSources.Destroy;
begin
  SaveSort(tvMsgSources);
  ClearGrid;
  inherited Destroy;
end;

procedure TfmSyslogSources.GetData;
begin
  var LConn := TDataServices.GetConnection(TSettings.Settings.Host, TSettings.Settings.Database, TSettings.Settings.UserName, TSettings.Settings.Password, TSettings.Settings.WindowsAuth);
  try
    var LList := TSyslogMsgSourceList.GetAll(LConn);
    try
      LogInfo('Retreived %d Syslog Msg Sources From EMDB', [LList.Count]);
      LoadGrid(LList);
    finally
      LList.Free;
    end;
  finally
    LConn.Free;
  end;
end;

procedure TfmSyslogSources.LoadGrid(AList: TSyslogMsgSourceList);
begin
  var LDS: TGridDataSource;
  tvMsgSources.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvMsgSources.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvMsgSources.DataController.CustomDataSource);
      tvMsgSources.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvMsgSources.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create(AList);
      tvMsgSources.DataController.CustomDataSource := LDS;
    finally
      tvMsgSources.DataController.EndFullUpdate;
    end;
  finally
    tvMsgSources.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmSyslogSources.ClearGrid;
begin
  tvMsgSources.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvMsgSources.DataController.CustomDataSource) then
    begin
      var LDS := TGridDataSource(tvMsgSources.DataController.CustomDataSource);
      tvMsgSources.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvMsgSources.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

function TfmSyslogSources.SelectSystemMonitorID: Integer;
begin
  Result := -1;
  var fm := TfmSystemMonitorLookUp.Create(nil);
  try
    if (mrOK = fm.ShowModal) then
      Result := fm.PrimaryKey;
  finally
    fm.Free;
  end;
end;

procedure TfmSyslogSources.LoadSort(AGridTableView: TcxGridTableView);
begin
  var LSortList := TStringList.Create;
  try
    LSortList.Delimiter := ',';
    var LSortOrderList := TStringList.Create;
    try
      LSortOrderList.Delimiter := ',';
      LSortList.DelimitedText := TUtilities.GetFormKey('MsgSources', 'LastSort');
      LSortOrderList.DelimitedText := TUtilities.GetFormKey('MsgSources', 'LastSortOrder');
      var LAllColumnsExist := TRUE;
      if 0 = LSortList.Count then
      begin
        LSortList.Clear;
        LSortList.Add('0');
        LSortOrderList.Clear;
        LSortList.Add('0');
      end;
      if (not (0 = LSortList.Count)) and (not (0 = LSortOrderList.Count)) then
      begin
        for var i := 0 to (LSortList.Count - 1) do
          LAllColumnsExist := LAllColumnsExist and (StrToIntDef(LSortList[i], -1) >= 0) and (StrToIntDef(LSortList[i], -1) < AGridTableView.ColumnCount);

        LAllColumnsExist := LAllColumnsExist and (LSortOrderList.Count = LSortList.Count);
        if LAllColumnsExist then
        begin
          for var j := 0 to (LSortList.Count - 1) do
            AGridTableView.Columns[StrToIntDef(LSortList[j], -1)].SortOrder := TdxSortOrder(StrToIntDef(LSortOrderList[j], 0));
        end;
      end else
      begin
        AGridTableView.Columns[1].SortOrder := TdxSortOrder(1);
      end;
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;

procedure TfmSyslogSources.SaveSort(AGridTableView: TcxGridTableView);
begin
  var LSortList := TStringList.Create;
  try
    var LSortOrderList := TStringList.Create;
    try
      TUtilities.SetFormKey('MsgSources', 'LastSort', '');
      TUtilities.SetFormKey('MsgSources', 'LastSortOrder', '');
      //Pre Size  Lists
      for var i := 0 to (AGridTableView.ColumnCount - 1) do
      begin
        if soNone <> AGridTableView.Columns[i].SortOrder then
        begin
          LSortList.Append('');
          LSortOrderList.Append('');
        end;
      end;
      for var j := 0 to (AGridTableView.ColumnCount - 1) do
      begin
        if soNone <> AGridTableView.Columns[j].SortOrder then
        begin
          LSortList[AGridTableView.Columns[j].SortIndex] := IntToStr(j);
          LSortOrderList[AGridTableView.Columns[j].SortIndex] := IntToStr(Integer(AGridTableView.Columns[j].SortOrder));
        end;
      end;
      LSortList.Delimiter := ',';
      LSortOrderList.Delimiter := ',';
      Assert(LSortList.Count = LSortOrderList.Count);
      TUtilities.SetFormKey('MsgSources', 'LastSort', LSortList.DelimitedText);
      TUtilities.SetFormKey('MsgSources', 'LastSortOrder', LSortOrderList.DelimitedText);
    finally
      LSortOrderList.Free;
    end;
  finally
    LSortList.Free;
  end;
end;
{$ENDREGION}

procedure TfmSyslogSources.ppmiChangeAgentClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  try
    var LSystemMonitorID := SelectSystemMonitorID;
    if LSystemMonitorID <= 0 then
      EXIT;
    var LIDs := TList<String>.Create;
    var LIDsString: String := String.Empty;
    try
      for var i := 0 to (tvMsgSources.Controller.SelectedRecordCount - 1) do
        LIDs.Add(TGridDataSource(tvMsgSources.DataController.CustomDataSource).MsgSources[tvMsgSources.Controller.SelectedRecords[i].RecordIndex].MsgSourceID.ToString);
      LIDsString := String.Join(',', LIds.ToArray);
    finally
      LIDs.Free;
    end;

    var LQuerySring := String.Format('Update MsgSource Set SystemMonitorID=%d Where MsgSourceID in (%s)', [LSystemMonitorID, LIDsString]);

    var LConn := TDataServices.GetConnection(TSettings.Settings.Host, TSettings.Settings.Database, TSettings.Settings.UserName, TSettings.Settings.Password, TSettings.Settings.WindowsAuth);
    try
      var LQuery := TDataServices.GetQuery(LConn);
      try
        LQuery.SQL.Text := LQuerySring;
        LConn.Open;
        LQuery.ExecSQL;
        LConn.Close;
      finally
        LQuery.Free;
      end;
    finally
      LConn.Free;
    end;
    GetData;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmSyslogSources.ebSearchChange(Sender: TObject);
begin
  inherited;
  var LColIndex: Integer;

  LColIndex := -1;
  for var i := 0 to (tvMsgSources.ColumnCount - 1) do
  begin
    if (soNone <> tvMsgSources.Columns[i].SortOrder) and (0 = tvMsgSources.Columns[i].SortIndex) then
    begin
      LColIndex := i;
      BREAK;
    end;
  end;

  if -1 = LColIndex  then
    EXIT;

  var recIndex := tvMsgSources.DataController.FindRecordIndexByText(1, LColIndex, ebSearch.Text, true, true, true);
  var rowIndex := tvMsgSources.DataController.GetRowIndexByRecordIndex(recIndex, True);
  tvMsgSources.Controller.FocusedRowIndex := rowIndex;
end;

procedure TfmSyslogSources.ebSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  try
    case key of
      VK_UP: tvMsgSources.Controller.FocusedRowIndex := tvMsgSources.Controller.FocusedRowIndex - 1;
      VK_DOWN: tvMsgSources.Controller.FocusedRowIndex := tvMsgSources.Controller.FocusedRowIndex + 1;
    end;
  except
  end;
end;

end.
