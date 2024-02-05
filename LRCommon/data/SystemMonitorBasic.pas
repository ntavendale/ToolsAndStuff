unit SystemMonitorBasic;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, FireDAC.Stan.Option,
  System.Generics.Collections;

type
  TSystemMonitorBasic = class
  private
    FSystemMonitorID: Integer;
    FName: String;
    FSystemMonitorHost: String;
    FSystemMonitorEntity: String;
    FSystemMonitorParentEntity: String;
    FActive: Boolean;
  public
    constructor Create; overload;
    constructor Create(ASystemMonitorBasic: TSystemMonitorBasic); overload;
    property SystemMonitorID: Integer read FSystemMonitorID write FSystemMonitorID;
    property Name: String read FName write FName;
    property SystemMonitorHost: String read FSystemMonitorHost write FSystemMonitorHost;
    property SystemMonitorEntity: String read FSystemMonitorEntity write FSystemMonitorEntity;
    property SystemMonitorParentEntity: String read FSystemMonitorParentEntity write FSystemMonitorParentEntity;
    property Active: Boolean read FActive write FActive;
  end;


  TSystemMonitorBasicList = class
  private
    FList: TObjectList<TSystemMonitorBasic>;
    function GetCount: Integer;
    function GetListItem(AIndex: Integer): TSystemMonitorBasic;
    procedure SetListItem(AIndex: Integer; AValue: TSystemMonitorBasic);
  protected
    class function GetInitialSQL: TStrings;
    class function CreateSystemMonitorBasic(ADataSet: TDataSet): TSystemMonitorBasic;
  public
    constructor Create; overload;
    constructor Create(ASystemMonitorBasicList: TSystemMonitorBasicList); overload;
    destructor Destroy; override;
    procedure Add(AValue: TSystemMonitorBasic);
    procedure Delete(AIndex: Integer);
    property Count: Integer read GetCount;
    property SystemMonitors[AIndex: Integer]: TSystemMonitorBasic read GetListitem write Setlistitem; default;
    class function GetAll(AConnection: TFDConnection): TSystemMonitorBasicList;
  end;

implementation

{$REGION 'TSystemMonitorBasic'}
constructor TSystemMonitorBasic.Create;
begin
  FSystemMonitorID := -1;
  FName := String.Empty;
  FSystemMonitorHost := String.Empty;
  FSystemMonitorEntity := String.Empty;
  FSystemMonitorParentEntity := String.Empty;
  FActive := FALSE;
end;

constructor TSystemMonitorBasic.Create(ASystemMonitorBasic: TSystemMonitorBasic);
begin
  FSystemMonitorID := -1;
  FName := String.Empty;
  FSystemMonitorHost := String.Empty;
  FSystemMonitorEntity := String.Empty;
  FSystemMonitorParentEntity := String.Empty;
  FActive := FALSE;
  if nil <> ASystemMonitorBasic then
  begin
    FSystemMonitorID := ASystemMonitorBasic.SystemMonitorID;
    FName := ASystemMonitorBasic.Name;
    FSystemMonitorHost := ASystemMonitorBasic.SystemMonitorHost;
    FSystemMonitorEntity := ASystemMonitorBasic.SystemMonitorEntity;
    FSystemMonitorParentEntity := ASystemMonitorBasic.SystemMonitorParentEntity;
    FActive := ASystemMonitorBasic.Active;
  end;
end;
{$ENDREGION}

{$REGION 'TSystemMonitorBasicList'}
constructor TSystemMonitorBasicList.Create;
begin
  FList := TObjectList<TSystemMonitorBasic>.Create(TRUE);
end;

constructor TSystemMonitorBasicList.Create(ASystemMonitorBasicList: TSystemMonitorBasicList);
begin
  FList := TObjectList<TSystemMonitorBasic>.Create(TRUE);
  for var i := 0 to (ASystemMonitorBasicList.Count - 1) do
    Flist.Add(TSystemMonitorBasic.Create(ASystemMonitorBasicList[i]));
end;

destructor TSystemMonitorBasicList.Destroy;
begin
  Flist.Free;
  inherited Destroy;
end;

function TSystemMonitorBasicList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSystemMonitorBasicList.GetListItem(AIndex: Integer): TSystemMonitorBasic;
begin
  Result := FList[AIndex];
end;

procedure TSystemMonitorBasicList.SetListItem(AIndex: Integer; AValue: TSystemMonitorBasic);
begin
  FList[AIndex] := AValue;
end;

class function TSystemMonitorBasicList.GetInitialSQL: TStrings;
begin
  Result := TStringList.Create;
  Result.Add('Select SystemMonitor.SystemMonitorID SystemMonitorID, ');
  Result.Add('SystemMonitor.Name SystemMonitor, ');
  Result.Add('smh.Name SystemMonitorHost, ');
  Result.Add('sme.Name SystemMonitorEntity, ');
  Result.Add('smpe.Name SystemMonitorParentEntity, ');
  Result.Add('SystemMonitor.RecordStatus ');
  Result.Add('From SystemMonitor ');
  Result.Add('Inner Join Host smh On SystemMonitor.HostID = smh.HostID ');
  Result.Add('Inner Join Entity sme On smh.EntityID = sme.EntityID ');
  Result.Add('Left Join Entity smpe On smpe.EntityID = sme.ParentEntityID ');
  Result.Add('Where SystemMonitor.SystemMonitorID > 0 ');
end;

class function TSystemMonitorBasicList.CreateSystemMonitorBasic(ADataSet: TDataSet): TSystemMonitorBasic;
begin
  Result := TSystemMonitorBasic.Create;
  Result.SystemMonitorID := ADataSet.Fields[0].AsInteger;
  Result.Name := ADataSet.Fields[1].AsString;
  Result.SystemMonitorHost := ADataSet.Fields[2].AsString;
  Result.SystemMonitorEntity := ADataSet.Fields[3].AsString;
  Result.SystemMonitorParentEntity := ADataSet.Fields[4].AsString;
  Result.Active := (0 <> ADataSet.Fields[5].AsInteger);
end;

procedure TSystemMonitorBasicList.Add(AValue: TSystemMonitorBasic);
begin
  Flist.Add(AValue);
end;

procedure TSystemMonitorBasicList.Delete(AIndex: Integer);
begin
  Flist.Delete(AIndex);
end;

class function TSystemMonitorBasicList.GetAll(AConnection: TFDConnection): TSystemMonitorBasicList;
begin
  Result := nil;
  try
    var LQuery := TDataServices.GetQuery(AConnection);
    try
      var LSQL := GetInitialSQL;
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
        Result := TSystemMonitorBasicList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          Result.Add(CreateSystemMonitorBasic(LQuery));
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
