unit MsgSource;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, FireDAC.Stan.Option,
  System.Generics.Collections;

type
  TMaxLogDateRecord = class
    protected
      FMsgSourceID: Integer;
      FMaxLogDate: TDateTime;
    public
      constructor Create(AMsgSourceID: Integer; AMaxLogDate: TDateTime); virtual;
      property MsgSourceID: Integer read FMsgSourceID;
      property MaxLogDate: TDateTime read FMaxLogDate;
  end;

  TMsgSource = class
    protected
      FMsgSourceID: Integer;
      FHostID: Integer;
      FSystemMonitorID: Integer;
      FMsgSourceTypeID: Integer;
      FMPEPolicyID: Integer;
      FName: String;
      FShortDesc: String;
      FLongDesc: String;
      FStatus: Byte;
      FFilePath: String;
      FCryptoMode: Byte;
      FSignMode: Byte;
      FMonitorStart: TDateTime;
      FMonitorStop: TDateTime;
      FDefMsgTTL: Integer;
      FDefMsgArchiveMode: Byte;
      FMPEMode: Byte;
      FMsgsPerCycle: Integer;
      FRecordStatus: Byte;
      FIsVirtual: Byte;
      FDateUpdated: TDateTime;
      FMaxLogDate: TDateTime;
      FCollectionDepth: Integer;
      FMsgSourceDateFormatID: Integer;
      FUDLAConnectionString: String;
      FUDLAStateField: String;
      FUDLAStateFieldType: Byte;
      FUDLAStateFieldConversion: String;
      FUDLAQueryStatement: String;
      FUDLAOutputFormat: String;
      FUDLAUniqueIdentifier: String;
      FUDLAMsgDateField: String;
      FUDLAGetUTCDateStatement: String;
      FParameter1: Integer;
      FParameter2: Integer;
      FParameter3: Integer;
      FParameter4: Integer;
      FParameter5: Integer;
      FParameter6: String;
      FParameter7: String;
      FParameter8: String;
      FParameter9: String;
      FParameter10: String;
      FMsgRegexStart: String;
      FMsgRegexDelimeter: String;
      FMsgRegexEnd: String;
      FRecursionDepth: Integer;
      FIsDirectory: Byte;
      FInclusions: String;
      FExclusions: String;
      FCompressionType: Byte;
      FUDLAConnectionType: Byte;
    public
      constructor Create; overload; virtual;
      constructor Create(AMsgSource: TMsgSource); overload; virtual;
      property MsgSourceID: Integer read FMsgSourceID write FMsgSourceID;
      property HostID: Integer read FHostID write FHostID;
      property SystemMonitorID: Integer read FSystemMonitorID write FSystemMonitorID;
      property MsgSourceTypeID: Integer read FMsgSourceTypeID write FMsgSourceTypeID;
      property MPEPolicyID: Integer read FMPEPolicyID write FMPEPolicyID;
      property Name: String read FName write FName;
      property ShortDesc: String read FShortDesc write FShortDesc;
      property LongDesc: String read FLongDesc write FLongDesc;
      property Status: Byte read FStatus write FStatus;
      property FilePath: String read FFilePath write FFilePath;
      property CryptoMode: Byte read FCryptoMode write FCryptoMode;
      property SignMode: Byte read FSignMode write FSignMode;
      property MonitorStart: TDateTime read FMonitorStart write FMonitorStart;
      property MonitorStop: TDateTime read FMonitorStop write FMonitorStop;
      property DefMsgTTL: Integer read FDefMsgTTL write FDefMsgTTL;
      property DefMsgArchiveMode: Byte read FDefMsgArchiveMode write FDefMsgArchiveMode;
      property MPEMode: Byte read FMPEMode write FMPEMode;
      property MsgsPerCycle: Integer read FMsgsPerCycle write FMsgsPerCycle;
      property RecordStatus: Byte read FRecordStatus write FRecordStatus;
      property IsVirtual: Byte read FIsVirtual write FIsVirtual;
      property DateUpdated: TDateTime read FDateUpdated write FDateUpdated;
      property MaxLogDate: TDateTime read FMaxLogDate write FMaxLogDate;
      property CollectionDepth: Integer read FCollectionDepth write FCollectionDepth;
      property MsgSourceDateFormatID: Integer read FMsgSourceDateFormatID write FMsgSourceDateFormatID;
      property UDLAConnectionString: String read FUDLAConnectionString write FUDLAConnectionString;
      property UDLAStateField: String read FUDLAStateField write FUDLAStateField;
      property UDLAStateFieldType: Byte read FUDLAStateFieldType write FUDLAStateFieldType;
      property UDLAStateFieldConversion: String read FUDLAStateFieldConversion write FUDLAStateFieldConversion;
      property UDLAQueryStatement: String read FUDLAQueryStatement write FUDLAQueryStatement;
      property UDLAOutputFormat: String read FUDLAOutputFormat write FUDLAOutputFormat;
      property UDLAUniqueIdentifier: String read FUDLAUniqueIdentifier write FUDLAUniqueIdentifier;
      property UDLAMsgDateField: String read FUDLAMsgDateField write FUDLAMsgDateField;
      property UDLAGetUTCDateStatement: String read FUDLAGetUTCDateStatement write FUDLAGetUTCDateStatement;
      property Parameter1: Integer read FParameter1 write FParameter1;
      property Parameter2: Integer read FParameter2 write FParameter2;
      property Parameter3: Integer read FParameter3 write FParameter3;
      property Parameter4: Integer read FParameter4 write FParameter4;
      property Parameter5: Integer read FParameter5 write FParameter5;
      property Parameter6: String read FParameter6 write FParameter6;
      property Parameter7: String read FParameter7 write FParameter7;
      property Parameter8: String read FParameter8 write FParameter8;
      property Parameter9: String read FParameter9 write FParameter9;
      property Parameter10: String read FParameter10 write FParameter10;
      property MsgRegexStart: String read FMsgRegexStart write FMsgRegexStart;
      property MsgRegexDelimeter: String read FMsgRegexDelimeter write FMsgRegexDelimeter;
      property MsgRegexEnd: String read FMsgRegexEnd write FMsgRegexEnd;
      property RecursionDepth: Integer read FRecursionDepth write FRecursionDepth;
      property IsDirectory: Byte read FIsDirectory write FIsDirectory;
      property Inclusions: String read FInclusions write FInclusions;
      property Exclusions: String read FExclusions write FExclusions;
      property CompressionType: Byte read FCompressionType write FCompressionType;
      property UDLAConnectionType: Byte read FUDLAConnectionType write FUDLAConnectionType;
  end;

  TMsgSourceList = class
    protected
      FIDList: TList<Integer>;
      FDict: TDictionary<Integer, TMsgSource>;
      function GetCount: Integer;
      function GetMsgSource(AIndex: Integer): TMsgSource;
      class function GetInitialSQL: TStringList;
      class function CreateMsgSource(ADataSet: TDataSet): TMsgSource;
    public
      constructor Create; overload; virtual;
      constructor Create(AMsgSourceList: TMsgSourceList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      procedure Add(AMsgSource: TMsgSource);
      procedure SetMaxLogDates(AMaxLogDates: TObjectList<TMaxLogDateRecord>);
      function GetMsgSourceByID(AMsgSourceID: Integer): TMsgSource;
      function GetMsgSourcesForSystemMonitor(ASystemMonitorID: Integer): TMsgSourceList;
      class function GetMaxLogDates(AConnection: TFDConnection): TDictionary<Integer, TDateTime>;
      class function GetAll(AConnection: TFDConnection): TMsgSourceList;
      property Count: Integer read GetCount;
      property MsgSources: TDictionary<Integer, TMsgSource> read FDict;
      property MsgSource[AIndex: Integer]: TMsgSource read GetMsgSource; default;
  end;

implementation

constructor TMaxLogDateRecord.Create(AMsgSourceID: Integer; AMaxLogDate: TDateTime);
begin
  FMsgSourceID := AMsgSourceID;
  FMaxLogDate := AMaxLogDate;
end;

constructor TMsgSource.Create;
begin
  FMsgSourceID := 0;
  FHostID := 0;
  FSystemMonitorID := 0;
  FMsgSourceTypeID := 0;
  FMPEPolicyID := 0;
  FName := '';
  FShortDesc := '';
  FLongDesc := '';
  FStatus := 0;
  FFilePath := '';
  FCryptoMode := 0;
  FSignMode := 0;
  FMonitorStart := -1.00;
  FMonitorStop := -1.00;
  FDefMsgTTL := 0;
  FDefMsgArchiveMode := 0;
  FMPEMode := 0;
  FMsgsPerCycle := 0;
  FRecordStatus := 0;
  FIsVirtual := 0;
  FDateUpdated := -1.00;
  FMaxLogDate := -1.00;
  FCollectionDepth := 0;
  FMsgSourceDateFormatID := 0;
  FUDLAConnectionString := '';
  FUDLAStateField := '';
  FUDLAStateFieldType := 0;
  FUDLAStateFieldConversion := '';
  FUDLAQueryStatement := '';
  FUDLAOutputFormat := '';
  FUDLAUniqueIdentifier := '';
  FUDLAMsgDateField := '';
  FUDLAGetUTCDateStatement := '';
  FParameter1 := 0;
  FParameter2 := 0;
  FParameter3 := 0;
  FParameter4 := 0;
  FParameter5 := 0;
  FParameter6 := '';
  FParameter7 := '';
  FParameter8 := '';
  FParameter9 := '';
  FParameter10 := '';
  FMsgRegexStart := '';
  FMsgRegexDelimeter := '';
  FMsgRegexEnd := '';
  FRecursionDepth := 0;
  FIsDirectory := 0;
  FInclusions := '';
  FExclusions := '';
  FCompressionType := 0;
  FUDLAConnectionType := 0;
end;

constructor TMsgSource.Create(AMsgSource: TMsgSource);
begin
  FMsgSourceID := AMsgSource.MsgSourceID;
  FHostID := AMsgSource.HostID;
  FSystemMonitorID := AMsgSource.SystemMonitorID;
  FMsgSourceTypeID := AMsgSource.MsgSourceTypeID;
  FMPEPolicyID := AMsgSource.MPEPolicyID;
  FName := AMsgSource.Name;
  FShortDesc := AMsgSource.ShortDesc;
  FLongDesc := AMsgSource.LongDesc;
  FStatus := AMsgSource.Status;
  FFilePath := AMsgSource.FilePath;
  FCryptoMode := AMsgSource.CryptoMode;
  FSignMode := AMsgSource.SignMode;
  FMonitorStart := AMsgSource.MonitorStart;
  FMonitorStop := AMsgSource.MonitorStop;
  FDefMsgTTL := AMsgSource.DefMsgTTL;
  FDefMsgArchiveMode := AMsgSource.DefMsgArchiveMode;
  FMPEMode := AMsgSource.MPEMode;
  FMsgsPerCycle := AMsgSource.MsgsPerCycle;
  FRecordStatus := AMsgSource.RecordStatus;
  FIsVirtual := AMsgSource.IsVirtual;
  FDateUpdated := AMsgSource.DateUpdated;
  FMaxLogDate := AMsgSource.MaxLogDate;
  FCollectionDepth := AMsgSource.CollectionDepth;
  FMsgSourceDateFormatID := AMsgSource.MsgSourceDateFormatID;
  FUDLAConnectionString := AMsgSource.UDLAConnectionString;
  FUDLAStateField := AMsgSource.UDLAStateField;
  FUDLAStateFieldType := AMsgSource.UDLAStateFieldType;
  FUDLAStateFieldConversion := AMsgSource.UDLAStateFieldConversion;
  FUDLAQueryStatement := AMsgSource.UDLAQueryStatement;
  FUDLAOutputFormat := AMsgSource.UDLAOutputFormat;
  FUDLAUniqueIdentifier := AMsgSource.UDLAUniqueIdentifier;
  FUDLAMsgDateField := AMsgSource.UDLAMsgDateField;
  FUDLAGetUTCDateStatement := AMsgSource.UDLAGetUTCDateStatement;
  FParameter1 := AMsgSource.Parameter1;
  FParameter2 := AMsgSource.Parameter2;
  FParameter3 := AMsgSource.Parameter3;
  FParameter4 := AMsgSource.Parameter4;
  FParameter5 := AMsgSource.Parameter5;
  FParameter6 := AMsgSource.Parameter6;
  FParameter7 := AMsgSource.Parameter7;
  FParameter8 := AMsgSource.Parameter8;
  FParameter9 := AMsgSource.Parameter9;
  FParameter10 := AMsgSource.Parameter10;
  FMsgRegexStart := AMsgSource.MsgRegexStart;
  FMsgRegexDelimeter := AMsgSource.MsgRegexDelimeter;
  FMsgRegexEnd := AMsgSource.MsgRegexEnd;
  FRecursionDepth := AMsgSource.RecursionDepth;
  FIsDirectory := AMsgSource.IsDirectory;
  FInclusions := AMsgSource.Inclusions;
  FExclusions := AMsgSource.Exclusions;
  FCompressionType := AMsgSource.CompressionType;
  FUDLAConnectionType := AMsgSource.UDLAConnectionType;
end;

function TMsgSourceList.GetCount: Integer;
begin
  Result := FDict.Count;
end;

function TMsgSourceList.GetMsgSource(AIndex: Integer): TMsgSource;
begin
  Result := FDict[ FIDList[AIndex] ];
end;

class function TMsgSourceList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select MsgSource.MsgSourceID, ');
  Result.Add('MsgSource.HostID, ');
  Result.Add('MsgSource.SystemMonitorID, ');
  Result.Add('MsgSource.MsgSourceTypeID, ');
  Result.Add('MsgSource.MPEPolicyID, ');
  Result.Add('MsgSource.Name, ');
  Result.Add('MsgSource.ShortDesc, ');
  Result.Add('MsgSource.LongDesc, ');
  Result.Add('MsgSource.Status, ');
  Result.Add('MsgSource.FilePath, ');
  Result.Add('MsgSource.CryptoMode, ');
  Result.Add('MsgSource.SignMode, ');
  Result.Add('MsgSource.MonitorStart, ');
  Result.Add('MsgSource.MonitorStop, ');
  Result.Add('MsgSource.DefMsgTTL, ');
  Result.Add('MsgSource.DefMsgArchiveMode, ');
  Result.Add('MsgSource.MPEMode, ');
  Result.Add('MsgSource.MsgsPerCycle, ');
  Result.Add('MsgSource.RecordStatus, ');
  Result.Add('MsgSource.IsVirtual, ');
  Result.Add('MsgSource.DateUpdated, ');
  Result.Add('MsgSource.MaxLogDate, ');
  Result.Add('MsgSource.LogMartMode, ');
  Result.Add('MsgSource.CollectionDepth, ');
  Result.Add('MsgSource.MsgSourceDateFormatID, ');
  Result.Add('MsgSource.UDLAConnectionString, ');
  Result.Add('MsgSource.UDLAStateField, ');
  Result.Add('MsgSource.UDLAStateFieldType, ');
  Result.Add('MsgSource.UDLAStateFieldConversion, ');
  Result.Add('MsgSource.UDLAQueryStatement, ');
  Result.Add('MsgSource.UDLAOutputFormat, ');
  Result.Add('MsgSource.UDLAUniqueIdentifier, ');
  Result.Add('MsgSource.UDLAMsgDateField, ');
  Result.Add('MsgSource.UDLAGetUTCDateStatement, ');
  Result.Add('MsgSource.Parameter1, ');
  Result.Add('MsgSource.Parameter2, ');
  Result.Add('MsgSource.Parameter3, ');
  Result.Add('MsgSource.Parameter4, ');
  Result.Add('MsgSource.Parameter5, ');
  Result.Add('MsgSource.Parameter6, ');
  Result.Add('MsgSource.Parameter7, ');
  Result.Add('MsgSource.Parameter8, ');
  Result.Add('MsgSource.Parameter9, ');
  Result.Add('MsgSource.Parameter10, ');
  Result.Add('MsgSource.MsgRegexStart, ');
  Result.Add('MsgSource.MsgRegexDelimeter, ');
  Result.Add('MsgSource.MsgRegexEnd, ');
  Result.Add('MsgSource.RecursionDepth, ');
  Result.Add('MsgSource.IsDirectory, ');
  Result.Add('MsgSource.Inclusions, ');
  Result.Add('MsgSource.Exclusions, ');
  Result.Add('MsgSource.CompressionType, ');
  Result.Add('MsgSource.UDLAConnectionType ');
  Result.Add('From MsgSource  With (NoLock) ');
end;

class function TMsgSourceList.CreateMsgSource(ADataSet: TDataSet): TMsgSource;
begin
  Result := TMsgSource.Create;
  Result.MsgSourceID := ADataSet.Fields[0].AsInteger;
  Result.HostID := ADataSet.Fields[1].AsInteger;
  Result.SystemMonitorID := ADataSet.Fields[2].AsInteger;
  Result.MsgSourceTypeID := ADataSet.Fields[3].AsInteger;
  Result.MPEPolicyID := ADataSet.Fields[4].AsInteger;
  Result.Name := ADataSet.Fields[5].AsString;
  Result.ShortDesc := ADataSet.Fields[6].AsString;
  Result.LongDesc := ADataSet.Fields[7].AsString;
  Result.Status := ADataSet.Fields[8].AsInteger;
  Result.FilePath := ADataSet.Fields[9].AsString;
  Result.CryptoMode := ADataSet.Fields[10].AsInteger;
  Result.SignMode := ADataSet.Fields[11].AsInteger;
  Result.MonitorStart := ADataSet.Fields[12].AsDateTime;
  Result.MonitorStop := ADataSet.Fields[13].AsDateTime;
  Result.DefMsgTTL := ADataSet.Fields[14].AsInteger;
  Result.DefMsgArchiveMode := ADataSet.Fields[15].AsInteger;
  Result.MPEMode := ADataSet.Fields[16].AsInteger;
  Result.MsgsPerCycle := ADataSet.Fields[17].AsInteger;
  Result.RecordStatus := ADataSet.Fields[18].AsInteger;
  Result.IsVirtual := ADataSet.Fields[19].AsInteger;
  Result.DateUpdated := ADataSet.Fields[20].AsDateTime;
  Result.MaxLogDate := ADataSet.Fields[21].AsDateTime;
  Result.CollectionDepth := ADataSet.Fields[23].AsInteger;
  Result.MsgSourceDateFormatID := ADataSet.Fields[24].AsInteger;
  Result.UDLAConnectionString := ADataSet.Fields[25].AsString;
  Result.UDLAStateField := ADataSet.Fields[26].AsString;
  Result.UDLAStateFieldType := ADataSet.Fields[27].AsInteger;
  Result.UDLAStateFieldConversion := ADataSet.Fields[28].AsString;
  Result.UDLAQueryStatement := ADataSet.Fields[29].AsString;
  Result.UDLAOutputFormat := ADataSet.Fields[30].AsString;
  Result.UDLAUniqueIdentifier := ADataSet.Fields[31].AsString;
  Result.UDLAMsgDateField := ADataSet.Fields[32].AsString;
  Result.UDLAGetUTCDateStatement := ADataSet.Fields[33].AsString;
  Result.Parameter1 := ADataSet.Fields[34].AsInteger;
  Result.Parameter2 := ADataSet.Fields[35].AsInteger;
  Result.Parameter3 := ADataSet.Fields[36].AsInteger;
  Result.Parameter4 := ADataSet.Fields[37].AsInteger;
  Result.Parameter5 := ADataSet.Fields[38].AsInteger;
  Result.Parameter6 := ADataSet.Fields[39].AsString;
  Result.Parameter7 := ADataSet.Fields[40].AsString;
  Result.Parameter8 := ADataSet.Fields[41].AsString;
  Result.Parameter9 := ADataSet.Fields[42].AsString;
  Result.Parameter10 := ADataSet.Fields[43].AsString;
  Result.MsgRegexStart := ADataSet.Fields[44].AsString;
  Result.MsgRegexDelimeter := ADataSet.Fields[45].AsString;
  Result.MsgRegexEnd := ADataSet.Fields[46].AsString;
  Result.RecursionDepth := ADataSet.Fields[47].AsInteger;
  Result.IsDirectory := ADataSet.Fields[48].AsInteger;
  Result.Inclusions := ADataSet.Fields[49].AsString;
  Result.Exclusions := ADataSet.Fields[50].AsString;
  Result.CompressionType := ADataSet.Fields[51].AsInteger;
  Result.UDLAConnectionType := ADataSet.Fields[52].AsInteger;
end;

constructor TMsgSourceList.Create;
begin
  inherited Create;
  FIDList := TList<Integer>.Create;
  FDict := TDictionary<Integer, TMsgSource>.Create;
end;

constructor TMsgSourceList.Create(AMsgSourceList: TMsgSourceList);
var
  i: Integer;
  LSrc: TMsgSource;
begin
  inherited Create;
  FIDList := TList<Integer>.Create;
  FDict := TDictionary<Integer, TMsgSource>.Create;
  for i in AMsgSourceList.MsgSources.Keys do
  begin
    LSrc := AMsgSourceList.MsgSources[i];
    FIDList.Add( LSrc.MsgSourceID );
    FDict.Add( LSrc.MsgSourceID, TMsgSource.Create(LSrc) );
  end;
end;

destructor TMsgSourceList.Destroy;
begin
  Clear;
  FIDList.Free;
  FDict.Free;
  inherited Destroy;
end;

procedure TMsgSourceList.Clear;
var
  i: Integer;
begin
  for i in FDict.Keys do
    FDict[i].Free;
  FDict.Clear;
  FIDList.Clear;
end;

procedure TMsgSourceList.Add(AMsgSource: TMsgSource);
begin
  FIDList.Add(AMsgSource.MsgSourceID);
  FDict.Add(AMsgSource.MsgSourceID, AMsgSource);
end;

procedure TMsgSourceList.SetMaxLogDates(AMaxLogDates: TObjectList<TMaxLogDateRecord>);
var
  i: Integer;
  LSrc: TmsgSource;
begin
  for i := 0 to (AMaxLogDates.Count - 1) do
  begin
    if FDict.TryGetValue(AMaxLogDates[i].MsgSourceID, LSRC ) then
      LSRC.MaxLogDate := AMaxLogDates[i].MaxLogDate;
  end;
end;

function TMsgSourceList.GetMsgSourceByID(AMsgSourceID: Integer): TMsgSource;
var
  LSrc: TMsgSource;
begin
  if FDict.TryGetValue(AMsgSourceID, LSrc) then
    Result := LSrc
  else
    Result := nil;
end;

function TMsgSourceList.GetMsgSourcesForSystemMonitor(ASystemMonitorID: Integer): TMsgSourceList;
var
  i: Integer;
begin
  Result := nil;
  for i in FDict.Keys do
  begin
    if ASystemMonitorID = FDict[i].SystemMonitorID then
    begin
      if nil = Result then
        Result := TMsgSourceList.Create;
      Result.Add(TMsgSource.Create(FDict[i]));
    end;
  end;
end;

class function TMsgSourceList.GetMaxLogDates(AConnection: TFDConnection): TDictionary<Integer, TDateTime>;
var
  LConnection: TFDConnection;
  LQuery: TFDQuery;
  i: Integer;
begin
  Result := nil;
  try
    LQuery := TDataServices.GetQuery(AConnection);
    try
      LQuery.SQL.Add('Select MsgSourceID, MaxLogDate From MsgSource Order By MsgSourceID');
      AConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TDictionary<Integer, TDateTime>.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          Result.Add(LQuery.Fields[0].AsInteger, LQuery.Fields[1].AsDateTime);
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

class function TMsgSourceList.GetAll(AConnection: TFDConnection): TMsgSourceList;
begin
  Result := nil;
  var LRecord: TMsgSource := nil;
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
        Result := TMsgSourceList.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          LRecord := CreateMsgSource(LQuery);
          Result.Add(LRecord);
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

end.
