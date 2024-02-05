unit LookUpSystemMonitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SingleRecordLookupUnbound, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkroom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringtime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinTheBezier,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVisualStudio2013Blue,
  dxSkinVisualStudio2013Dark, dxSkinVisualStudio2013Light, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, dxDateRanges,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGrid,
  RzButton, RzPanel, Vcl.StdCtrls, Vcl.Mask, RzEdit, Vcl.ExtCtrls,
  SystemMonitorBasic, Settings, DataServices;

type
  TGridDataSource = class(TcxCustomDataSource)
  private
    FList: TSystemMonitorBasicList;
  protected
    function GetRecordCount: Integer; override;
    function GetValue(ARecordHandle: TcxDataRecordHandle; AItemHandle: TcxDataItemHandle): Variant; override;
  public
    constructor Create(AList: TSystemMonitorBasicList);
    destructor Destroy; override;
    property MsgSources: TSystemMonitorBasicList read FList;
  end;

  TfmSystemMonitorLookUp = class(TfmSingleRecordLookupUnbound)
    colName: TcxGridColumn;
    colHost: TcxGridColumn;
    colEntity: TcxGridColumn;
  private
    { Private declarations }
    procedure LoadGrid(AList: TSystemMonitorBasicList);
    procedure ClearGrid;
    function GetPrimaryKey: Integer; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{$REGION 'TGridDataSource'}
constructor TGridDataSource.Create(AList: TSystemMonitorBasicList);
begin
  if nil = AList then
    FList := TSystemMonitorBasicList.Create
  else
    FList := TSystemMonitorBasicList.Create(AList);
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
    0: if LRec.Active then Result := LRec.Name else Result := String.Format('%s*', [LRec.Name]);
    1: Result := LRec.SystemMonitorHost;
    2: Result := LRec.SystemMonitorEntity
  end;
end;
{$ENDREGION}

{$REGION 'Custom Methods'}
constructor TfmSystemMonitorLookUp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  var LConn := TDataServices.GetConnection(TSettings.Settings.Host, TSettings.Settings.Database, TSettings.Settings.UserName, TSettings.Settings.Password, TSettings.Settings.WindowsAuth);
  try
    var LList := TSystemMonitorBasicList.GetAll(LConn);
    try
      LoadGrid(LList);
    finally
      if nil <> LList then LList.Free;
    end;
  finally
    LConn.Free;
  end;
end;

procedure TfmSystemMonitorLookUp.LoadGrid(AList: TSystemMonitorBasicList);
begin
  var LDS: TGridDataSource;
  tvData.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvData.DataController.CustomDataSource) then
    begin
      LDS := TGridDataSource(tvData.DataController.CustomDataSource);
      tvData.DataController.CustomDataSource := nil;
      LDS.Free;
    end;

    tvData.DataController.BeginFullUpdate;
    try
      LDS := TGridDataSource.Create(AList);
      tvData.DataController.CustomDataSource := LDS;
    finally
      tvData.DataController.EndFullUpdate;
    end;
  finally
    tvData.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmSystemMonitorLookUp.ClearGrid;
begin
  tvData.BeginUpdate(lsimImmediate);
  try
    if (nil <> tvData.DataController.CustomDataSource) then
    begin
      var LDS := TGridDataSource(tvData.DataController.CustomDataSource);
      tvData.DataController.CustomDataSource := nil;
      LDS.Free;
    end;
  finally
    tvData.EndUpdate;
    Screen.Cursor := crDefault;
  end;
end;

function TfmSystemMonitorLookUp.GetPrimaryKey: Integer;
begin
  Result := -1;
  var LIndex := tvData.DataController.FocusedRecordIndex;
  if LIndex < 0 then
  begin
    MessageDlg('You must selct a record', mtError, [mbOK], 0);
    EXIT;
  end;

  Result := TGridDataSource(tvData.DataController.CustomDataSource).MsgSources[LIndex].SystemMonitorID;
end;
{$ENDREGION}
end.
