unit SystemMonitorToMediator;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB,
  FireDAC.Stan.Option, System.Generics.Collections;

type
  TSystemMonitorToMediator = class
    protected
      FMediatorID: Integer;
      FSystemMonitorID: Integer;
      FPriority: Integer;
      FClientAddress: String;
      FClientPort: Integer;
      FMediatorName: String;
    public
      constructor Create; overload; virtual;
      constructor Create(ASystemMonitorToMediator: TSystemMonitorToMediator); overload; virtual;
      property MediatorID: Integer read FMediatorID write FMediatorID;
      property SystemMonitorID: Integer read FSystemMonitorID write FSystemMonitorID;
      property Priority: Integer read FPriority write FPriority;
      property ClientAddress: String read FClientAddress write FClientAddress;
      property ClientPort: Integer read FClientPort write FClientPort;
      property MediatorName: String read FMediatorName write FMediatorName;
  end;

  TSystemMonitorToMediatorList = class
    protected
      FList: TObjectList<TSystemMonitorToMediator>;
      function GetCount: Integer;
      function GetSystemMonitorToMediator(AIndex: Integer): TSystemMonitorToMediator;
      class function GetInitialSQL: TStringList;
      class function CreateSystemMonitorToMediator(ADataSet: TDataSet): TSystemMonitorToMediator;
    public
      constructor Create; overload; virtual;
      constructor Create(ASystemMonitorToMediatorList: TSystemMonitorToMediatorList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(ASystemMonitorToMediator: TSystemMonitorToMediator);
      property Count: Integer read GetCount;
      property SystemMonitorToMediator[AIndex: Integer]: TSystemMonitorToMediator read GetSystemMonitorToMediator; default; 
  end;

implementation

constructor TSystemMonitorToMediator.Create;
begin
  FMediatorID := 0;
  FSystemMonitorID := 0;
  FPriority := 0;
  FClientAddress := '';
  FClientPort := 0;
  FMediatorName := '';
end;

constructor TSystemMonitorToMediator.Create(ASystemMonitorToMediator: TSystemMonitorToMediator);
begin
  FMediatorID := ASystemMonitorToMediator.MediatorID;
  FSystemMonitorID := ASystemMonitorToMediator.SystemMonitorID;
  FPriority := ASystemMonitorToMediator.Priority;
  FClientAddress := ASystemMonitorToMediator.ClientAddress;
  FClientPort := ASystemMonitorToMediator.ClientPort;
  FMediatorName := ASystemMonitorToMediator.MediatorName;
end;

function TSystemMonitorToMediatorList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSystemMonitorToMediatorList.GetSystemMonitorToMediator(AIndex: Integer): TSystemMonitorToMediator;
begin
  Result := FList[AIndex];
end;

class function TSystemMonitorToMediatorList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select SystemMonitorToMediator.MediatorID, ');
  Result.Add('SystemMonitorToMediator.SystemMonitorID, ');
  Result.Add('SystemMonitorToMediator.Priority, ');
  Result.Add('SystemMonitorToMediator.ClientAddress, ');
  Result.Add('SystemMonitorToMediator.ClientPort ');
  Result.Add('From SystemMonitorToMediator ');
end;

class function TSystemMonitorToMediatorList.CreateSystemMonitorToMediator(ADataSet: TDataSet): TSystemMonitorToMediator;
begin
  Result := TSystemMonitorToMediator.Create;
  Result.MediatorID := ADataSet.Fields[0].AsInteger;
  Result.SystemMonitorID := ADataSet.Fields[1].AsInteger;
  Result.Priority := ADataSet.Fields[2].AsInteger;
  Result.ClientAddress := ADataSet.Fields[3].AsString;
  Result.ClientPort := ADataSet.Fields[4].AsInteger;
end;

constructor TSystemMonitorToMediatorList.Create;
begin
  inherited Create;
  FList := TObjectList<TSystemMonitorToMediator>.Create(TRUE);
end;

constructor TSystemMonitorToMediatorList.Create(ASystemMonitorToMediatorList: TSystemMonitorToMediatorList);
var
  i: Integer;
begin
  inherited Create;
  FList := TObjectList<TSystemMonitorToMediator>.Create(TRUE);
  for i := 0 to (ASystemMonitorToMediatorList.Count - 1) do 
    FList.Add(TSystemMonitorToMediator.Create(ASystemMonitorToMediatorList[i]));
end;

destructor TSystemMonitorToMediatorList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

procedure TSystemMonitorToMediatorList.Clear;
begin
  FList.Clear;
end;

procedure TSystemMonitorToMediatorList.Add(ASystemMonitorToMediator: TSystemMonitorToMediator);
begin
  FList.Add(ASystemMonitorToMediator);
end;

end.
