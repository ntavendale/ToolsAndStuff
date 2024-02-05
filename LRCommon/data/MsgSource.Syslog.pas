unit MsgSource.Syslog;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, FireDAC.Stan.Option,
  System.Generics.Collections;

type
  TSyslogMsgSource = class
  private
    FMsgSourceID: Integer;
    FMsgSourceName: String;
    FMsgSourceType: String;
    FMsgSourceHost: String;
    FMsgSourceHostEnity: String;
    FMsgSourceHostParentEntity: String;
    FSystemMonitorID: Integer;
    FSystemMonitor: String;
    FSystemMonitorHost: String;
    FSystemMonitorEntity: String;
    FSystemMonitorParentEntity: String;
  public
    constructor Create; overload;
    constructor Create(ASyslogMsgSource: TSyslogMsgSource); overload;
    property MsgSourceID: Integer read FMsgSourceID write FMsgSourceID;
    property MsgSourceName: String read FMsgSourceName write FMsgSourceName;
    property MsgSourceType: String read FMsgSourceType write FMsgSourceType;
    property MsgSourceHost: String read FMsgSourceHost write FMsgSourceHost;
    property MsgSourceHostEnity: String read FMsgSourceHostEnity write FMsgSourceHostEnity;
    property MsgSourceHostParentEntity: String read FMsgSourceHostParentEntity write FMsgSourceHostParentEntity;
    property SystemMonitorID: Integer read FSystemMonitorID write FSystemMonitorID;
    property SystemMonitor: String read FSystemMonitor write FSystemMonitor;
    property SystemMonitorHost: String read FSystemMonitorHost write FSystemMonitorHost;
    property SystemMonitorEntity: String read FSystemMonitorEntity write FSystemMonitorEntity;
    property SystemMonitorParentEntity: String read FSystemMonitorParentEntity write FSystemMonitorParentEntity;
  end;

  TSyslogMsgSourceList = class
  private
    FList: TObjectList<TSyslogMsgSource>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TSyslogMsgSource;
    procedure SetListItem(AIndex: Integer; AValue: TSyslogMsgSource);
  protected
    class function GetInitialSQL: TStrings;
    class function CreateMsgSource(ADataSet: TDataSet): TSyslogMsgSource;
  public
    constructor Create; overload;
    constructor Create(ASyslogMsgSourceList: TSyslogMsgSourceList); overload;
    destructor Destroy; override;
    procedure Add(AValue: TSyslogMsgSource);
    procedure Delete(AIndex: Integer);
    property Count: Integer read GetCount;
    property SyslogMsgSource[AIndex: Integer]: TSyslogMsgSource read GetListItem write SetListItem; default;
    class function GetAll(AConnection: TFDConnection): TSyslogMsgSourceList;
  end;

implementation

{$REGION 'TSyslogMsgSource'}
constructor TSyslogMsgSource.Create;
begin
  FMsgSourceID := -1;
  FMsgSourceName := String.Empty;
  FMsgSourceType := String.Empty;
  FMsgSourceHost := String.Empty;
  FMsgSourceHostEnity := String.Empty;
  FMsgSourceHostParentEntity := String.Empty;
  FSystemMonitorID := -1;
  FSystemMonitor := String.Empty;
  FSystemMonitorHost := String.Empty;
  FSystemMonitorEntity := String.Empty;
  FSystemMonitorParentEntity := String.Empty;
end;

constructor TSyslogMsgSource.Create(ASyslogMsgSource: TSyslogMsgSource);
begin
  FMsgSourceID := -1;
  FMsgSourceName := String.Empty;
  FMsgSourceType := String.Empty;
  FMsgSourceHost := String.Empty;
  FMsgSourceHostEnity := String.Empty;
  FMsgSourceHostParentEntity := String.Empty;
  FSystemMonitorID := -1;
  FSystemMonitor := String.Empty;
  FSystemMonitorHost := String.Empty;
  FSystemMonitorEntity := String.Empty;
  FSystemMonitorParentEntity := String.Empty;
  if nil <> ASyslogMsgSource then
  begin
    FMsgSourceID := ASyslogMsgSource.MsgSourceID;
    FMsgSourceName := ASyslogMsgSource.MsgSourceName;
    FMsgSourceType := ASyslogMsgSource.MsgSourceType;
    FMsgSourceHost := ASyslogMsgSource.MsgSourceHost;
    FMsgSourceHostEnity := ASyslogMsgSource.MsgSourceHostEnity;
    FMsgSourceHostParentEntity := ASyslogMsgSource.MsgSourceHostParentEntity;
    FSystemMonitorID := ASyslogMsgSource.SystemMonitorID;
    FSystemMonitor := ASyslogMsgSource.SystemMonitor;
    FSystemMonitorHost := ASyslogMsgSource.SystemMonitorHost;
    FSystemMonitorEntity := ASyslogMsgSource.SystemMonitorEntity;
    FSystemMonitorParentEntity := ASyslogMsgSource.SystemMonitorParentEntity;
  end;
end;
{$ENDREGION}

{$REGION 'TSyslogMsgSourceList'}
constructor TSyslogMsgSourceList.Create;
begin
  FList := TObjectList<TSyslogMsgSource>.Create(TRUE);
end;

constructor TSyslogMsgSourceList.Create(ASyslogMsgSourceList: TSyslogMsgSourceList);
begin
  FList := TObjectList<TSyslogMsgSource>.Create(TRUE);
  for var i := 0 to (ASyslogMsgSourceList.Count - 1) do
    FList.Add(TSyslogMsgSource.Create(ASyslogMsgSourceList[i]));
end;

destructor TSyslogMsgSourceList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TSyslogMsgSourceList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSyslogMsgSourceList.GetListItem(AIndex: Integer): TSyslogMsgSource;
begin
  Result := FList[AIndex];
end;

procedure TSyslogMsgSourceList.SetListItem(AIndex: Integer; AValue: TSyslogMsgSource);
begin
  Flist[AIndex] := AValue;
end;

class function TSyslogMsgSourceList.GetInitialSQL: TStrings;
begin
  Result := TStringList.Create;
  Result.Add('Select MsgSource.MsgSourceID, ');
  Result.Add('MsgSource.Name MsgSource, ');
  Result.Add('MsgSourceType.Name [Type], ');
  Result.Add('Host.Name MsgSourceHost, ');
  Result.Add('Entity.Name MsgSourceHostEnity, ');
  Result.Add('pe.Name MsgSourceHostParentEntity, ');
  Result.Add('SystemMonitor.SystemMonitorID SystemMonitorID, ');
  Result.Add('SystemMonitor.Name SystemMonitor, ');
  Result.Add('smh.Name SystemMonitorHost, ');
  Result.Add('sme.Name SystemMonitorEntity, ');
  Result.Add('smpe.Name SystemMonitorParentEntity ');
  Result.Add('From MsgSource ');
  Result.Add('Inner Join MsgSourceType On MsgSource.MsgSourceTypeID = MsgSourceType.MsgSourceTypeID ');
  Result.Add('Inner Join Host On MsgSource.HostID = Host.HostID ');
  Result.Add('Inner Join Entity On Host.EntityID = Entity.EntityID ');
  Result.Add('Left Join Entity pe On pe.EntityID = Entity.ParentEntityID ');
  Result.Add('Inner Join SystemMonitor On MsgSource.SystemMonitorID = SystemMonitor.SystemMonitorID ');
  Result.Add('Inner Join Host smh On SystemMonitor.HostID = smh.HostID ');
  Result.Add('Inner Join Entity sme On smh.EntityID = sme.EntityID ');
  Result.Add('Left Join Entity smpe On smpe.EntityID = sme.ParentEntityID ');
  Result.Add('Where MsgSourceType.MsgSourceFormat=1 ');
end;

class function TSyslogMsgSourceList.CreateMsgSource(ADataSet: TDataSet): TSyslogMsgSource;
begin
  Result := TSyslogMsgSource.Create;
  Result.MsgSourceID := ADataSet.Fields[0].AsInteger;
  Result.MsgSourceName := ADataSet.Fields[1].AsString;
  Result.MsgSourceType := ADataSet.Fields[2].AsString;
  Result.MsgSourceHost := ADataSet.Fields[3].AsString;
  Result.MsgSourceHostEnity := ADataSet.Fields[4].AsString;
  Result.MsgSourceHostParentEntity := ADataSet.Fields[5].AsString;
  Result.SystemMonitorID := ADataSet.Fields[6].AsInteger;
  Result.SystemMonitor := ADataSet.Fields[7].AsString;
  Result.SystemMonitorHost := ADataSet.Fields[8].AsString;
  Result.SystemMonitorEntity := ADataSet.Fields[9].AsString;
  Result.SystemMonitorParentEntity := ADataSet.Fields[10].AsString;
end;

procedure TSyslogMsgSourceList.Add(AValue: TSyslogMsgSource);
begin
  FList.Add(AValue);
end;

procedure TSyslogMsgSourceList.Delete(AIndex: Integer);
begin
  FList.Delete(AIndex);
end;

class function TSyslogMsgSourceList.GetAll(AConnection: TFDConnection): TSyslogMsgSourceList;
begin
  Result := nil;
  try
    var LQuery := TDataServices.GetQuery(AConnection);
    try
      var LSQL := GetInitialSQL;
      LSQL.Add('Order By MsgSource.SystemMonitorID, MsgSource.MsgSourceID ');
      try
        for var i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      AConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TSyslogMsgSourceList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          Result.Add(CreateMsgSource(LQuery));
          LQuery.Next;
        end;
      end;
    finally
      LQuery.Close;
      LQuery.Free;
    end;
  finally
    AConnection.Close;
  end;
end;
{$ENDREGION}
end.
