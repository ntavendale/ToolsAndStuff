unit SystemMonitor;

interface

uses
  SysUtils, Classes, DataServices, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS,  FireDAC.DApt.Intf, FireDAC.DApt, DB, FireDAC.Stan.Option,
  System.Generics.Collections, FileLogger, SystemMonitorToMediator,
  DateUtils;

type
  THeartbeatRecord = class
    protected
      FSystemMonitorID: Integer;
      FLastHeartbeat: TDateTime;
    public
      constructor Create(ASystemMonitorID: Integer; ALastHeartbeat: TDateTime); virtual;
      property SystemMonitorID: Integer read FSystemMonitorID;
      property LastHeartbeat: TDateTime read FLastHeartbeat;
  end;

  TSystemMonitor = class
    protected
      FSystemMonitorID: Integer;
      FHostID: Integer;
      FName: String;
      FShortDesc: String;
      FLongDesc: String;
      FPassphrase: String;
      FStatus: Byte;
      FHeartbeatInterval: Integer;
      FCycleTime: Integer;
      FMsgBuffer: Integer;
      FRecordStatus: Byte;
      FDateUpdated: TDateTime;
      FSystemMonitorType: Byte;
      FLastHeartbeat: TDateTime;
      FHeartbeatWarningInterval: Integer;
      FGUID: String;
      FVersion: String;
      FLogLevel: Byte;
      FCompress: Byte;
      FCompressBatch: Integer;
      FProcessPriority: Byte;
      FMaxServiceMemory: Integer;
      FMaxLogQueueMemory: Integer;
      FConnectionTimeout: Integer;
      FSocketSendTimeout: Integer;
      FSocketReceiveTimeout: Integer;
      FFlushBatch: Integer;
      FDisableFlushThrottle: Byte;
      FMaxSyslogSuspenseSize: Integer;
      FEventLogBuffer: Integer;
      FEventLogTimeout: Integer;
      FEventLogCacheLifetime: Integer;
      FLocalLogLifetime: Integer;
      FFileMonitor: Byte;
      FVirtualSourceDNSResolution: Byte;
      FSyslogServer: Byte;
      FSyslogServerNIC: String;
      FSyslogServerCrypto: Byte;
      FSyslogFile: Byte;
      FSyslogFilePath: String;
      FSyslogFileRotationSize: Integer;
      FSyslogFileHistory: Integer;
      FNetflowServer: Byte;
      FNetflowServerNIC: String;
      FNetflowServerPort: Integer;
      FNetflowServerCrypto: Byte;
      FParameter1: Integer;
      FParameter2: Integer;
      FParameter3: Integer;
      FParameter4: Integer;
      FParameter5: Integer;
      FParameter6: String;
      FParameter7: String;
      FSyslogParsedHosts: String;
      FSyslogParsedHostExpressions: String;
      FSyslogUDPPort: Integer;
      FSyslogTCPPort: Integer;
      FDataDefender: Integer;
      FDLDPolicyID: Integer;
      FFIMPolicyID: Integer;
      FFIMIncludeUAMData: Byte;
      FSNMPTrapReceiver: Byte;
      FSNMPLocalIP: String;
      FSNMPLocalPort: Integer;
      FSNMPCommunityString: String;
      FSNMPAuthenticationUser: String;
      FSNMPAuthenticationPassword: String;
      FSNMPAuthenticationAlgorithm: Byte;
      FSNMPEncryptionPassword: String;
      FSNMPEncryptionAlgorithm: Byte;
      FProcessMonitor: Byte;
      FProcessMonitorInterval: Integer;
      FPMIncludeUAMData: Byte;
      FNetworkConnectionMonitor: Byte;
      FNetworkConnectionMonitorInterval: Integer;
      FNCMIncludeUAMData: Byte;
      FLogListeners: Byte;
      FLogEstablishedInboundConnections: Byte;
      FLogEstablishedOutboundConnections: Byte;
      FNetflowVerbose: Byte;
      FLastMediator: String;
      FMsgSourceSearchScope: Byte;
      FRealtimeFileMonitor: Byte;
      FUseAgentTLSCert: Byte;
      FAgentTLSCertLocation: String;
      FAgentTLSCertStore: String;
      FAgentTLSCertSubject: String;
      FMediatorTLSCertLocation: String;
      FAgentTLSCertFile: String;
      FAgentTLSSecretKeyFilename: String;
      FAgentTLSSecretKeyPassword: String;
      FEnforceMediatorTLSCertTrust: Byte;
      FEnforceMediatorTLSCertRevocation: Byte;
      FMediatorTLSCertOCSPURL: String;
      FRealtimeAnomalyDetection: Byte;
      FRealtimeRecordBufferLimit: Integer;
      FSFlowServerEnabled: Byte;
      FSFlowServerUDPPort: Integer;
      FSFlowExtraLogging: Byte;
      FSFlowServerNIC: String;
      FSFlowLogDetails: Byte;
      FSFlowLogCounters: Byte;
      FUnidirectionalAgentEnabled: Integer;
      FUnidirectionalAgentMediatorPort: Integer;
      FUnidirectionalAgentHashMode: Byte;
      FFailbackDelay: Integer;
      FLoadBalanceDelay: Integer;
      FRealtimeIDMPollingInterval: Integer;
      FMediators: TSystemMonitorToMediatorList;
      FQueryTime: TDateTime;
      function GetSecondsSinceLastheartbeat: Integer;
    public
      constructor Create; overload; virtual;
      constructor Create(ASystemMonitor: TSystemMonitor); overload; virtual;
      destructor Destroy; override;
      property QueryTime: TDateTime read FQueryTime write FQueryTime;
      property SystemMonitorID: Integer read FSystemMonitorID write FSystemMonitorID;
      property HostID: Integer read FHostID write FHostID;
      property Name: String read FName write FName;
      property ShortDesc: String read FShortDesc write FShortDesc;
      property LongDesc: String read FLongDesc write FLongDesc;
      property Passphrase: String read FPassphrase write FPassphrase;
      property Status: Byte read FStatus write FStatus;
      property HeartbeatInterval: Integer read FHeartbeatInterval write FHeartbeatInterval;
      property CycleTime: Integer read FCycleTime write FCycleTime;
      property MsgBuffer: Integer read FMsgBuffer write FMsgBuffer;
      property RecordStatus: Byte read FRecordStatus write FRecordStatus;
      property DateUpdated: TDateTime read FDateUpdated write FDateUpdated;
      property SystemMonitorType: Byte read FSystemMonitorType write FSystemMonitorType;
      property LastHeartbeat: TDateTime read FLastHeartbeat write FLastHeartbeat;
      property HeartbeatWarningInterval: Integer read FHeartbeatWarningInterval write FHeartbeatWarningInterval;
      property GUID: String read FGUID write FGUID;
      property Version: String read FVersion write FVersion;
      property LogLevel: Byte read FLogLevel write FLogLevel;
      property Compress: Byte read FCompress write FCompress;
      property CompressBatch: Integer read FCompressBatch write FCompressBatch;
      property ProcessPriority: Byte read FProcessPriority write FProcessPriority;
      property MaxServiceMemory: Integer read FMaxServiceMemory write FMaxServiceMemory;
      property MaxLogQueueMemory: Integer read FMaxLogQueueMemory write FMaxLogQueueMemory;
      property ConnectionTimeout: Integer read FConnectionTimeout write FConnectionTimeout;
      property SocketSendTimeout: Integer read FSocketSendTimeout write FSocketSendTimeout;
      property SocketReceiveTimeout: Integer read FSocketReceiveTimeout write FSocketReceiveTimeout;
      property FlushBatch: Integer read FFlushBatch write FFlushBatch;
      property DisableFlushThrottle: Byte read FDisableFlushThrottle write FDisableFlushThrottle;
      property MaxSyslogSuspenseSize: Integer read FMaxSyslogSuspenseSize write FMaxSyslogSuspenseSize;
      property EventLogBuffer: Integer read FEventLogBuffer write FEventLogBuffer;
      property EventLogTimeout: Integer read FEventLogTimeout write FEventLogTimeout;
      property EventLogCacheLifetime: Integer read FEventLogCacheLifetime write FEventLogCacheLifetime;
      property LocalLogLifetime: Integer read FLocalLogLifetime write FLocalLogLifetime;
      property FileMonitor: Byte read FFileMonitor write FFileMonitor;
      property VirtualSourceDNSResolution: Byte read FVirtualSourceDNSResolution write FVirtualSourceDNSResolution;
      property SyslogServer: Byte read FSyslogServer write FSyslogServer;
      property SyslogServerNIC: String read FSyslogServerNIC write FSyslogServerNIC;
      property SyslogServerCrypto: Byte read FSyslogServerCrypto write FSyslogServerCrypto;
      property SyslogFile: Byte read FSyslogFile write FSyslogFile;
      property SyslogFilePath: String read FSyslogFilePath write FSyslogFilePath;
      property SyslogFileRotationSize: Integer read FSyslogFileRotationSize write FSyslogFileRotationSize;
      property SyslogFileHistory: Integer read FSyslogFileHistory write FSyslogFileHistory;
      property NetflowServer: Byte read FNetflowServer write FNetflowServer;
      property NetflowServerNIC: String read FNetflowServerNIC write FNetflowServerNIC;
      property NetflowServerPort: Integer read FNetflowServerPort write FNetflowServerPort;
      property NetflowServerCrypto: Byte read FNetflowServerCrypto write FNetflowServerCrypto;
      property Parameter1: Integer read FParameter1 write FParameter1;
      property Parameter2: Integer read FParameter2 write FParameter2;
      property Parameter3: Integer read FParameter3 write FParameter3;
      property Parameter4: Integer read FParameter4 write FParameter4;
      property Parameter5: Integer read FParameter5 write FParameter5;
      property Parameter6: String read FParameter6 write FParameter6;
      property Parameter7: String read FParameter7 write FParameter7;
      property SyslogParsedHosts: String read FSyslogParsedHosts write FSyslogParsedHosts;
      property SyslogParsedHostExpressions: String read FSyslogParsedHostExpressions write FSyslogParsedHostExpressions;
      property SyslogUDPPort: Integer read FSyslogUDPPort write FSyslogUDPPort;
      property SyslogTCPPort: Integer read FSyslogTCPPort write FSyslogTCPPort;
      property DataDefender: Integer read FDataDefender write FDataDefender;
      property DLDPolicyID: Integer read FDLDPolicyID write FDLDPolicyID;
      property FIMPolicyID: Integer read FFIMPolicyID write FFIMPolicyID;
      property FIMIncludeUAMData: Byte read FFIMIncludeUAMData write FFIMIncludeUAMData;
      property SNMPTrapReceiver: Byte read FSNMPTrapReceiver write FSNMPTrapReceiver;
      property SNMPLocalIP: String read FSNMPLocalIP write FSNMPLocalIP;
      property SNMPLocalPort: Integer read FSNMPLocalPort write FSNMPLocalPort;
      property SNMPCommunityString: String read FSNMPCommunityString write FSNMPCommunityString;
      property SNMPAuthenticationUser: String read FSNMPAuthenticationUser write FSNMPAuthenticationUser;
      property SNMPAuthenticationPassword: String read FSNMPAuthenticationPassword write FSNMPAuthenticationPassword;
      property SNMPAuthenticationAlgorithm: Byte read FSNMPAuthenticationAlgorithm write FSNMPAuthenticationAlgorithm;
      property SNMPEncryptionPassword: String read FSNMPEncryptionPassword write FSNMPEncryptionPassword;
      property SNMPEncryptionAlgorithm: Byte read FSNMPEncryptionAlgorithm write FSNMPEncryptionAlgorithm;
      property ProcessMonitor: Byte read FProcessMonitor write FProcessMonitor;
      property ProcessMonitorInterval: Integer read FProcessMonitorInterval write FProcessMonitorInterval;
      property PMIncludeUAMData: Byte read FPMIncludeUAMData write FPMIncludeUAMData;
      property NetworkConnectionMonitor: Byte read FNetworkConnectionMonitor write FNetworkConnectionMonitor;
      property NetworkConnectionMonitorInterval: Integer read FNetworkConnectionMonitorInterval write FNetworkConnectionMonitorInterval;
      property NCMIncludeUAMData: Byte read FNCMIncludeUAMData write FNCMIncludeUAMData;
      property LogListeners: Byte read FLogListeners write FLogListeners;
      property LogEstablishedInboundConnections: Byte read FLogEstablishedInboundConnections write FLogEstablishedInboundConnections;
      property LogEstablishedOutboundConnections: Byte read FLogEstablishedOutboundConnections write FLogEstablishedOutboundConnections;
      property NetflowVerbose: Byte read FNetflowVerbose write FNetflowVerbose;
      property LastMediator: String read FLastMediator write FLastMediator;
      property MsgSourceSearchScope: Byte read FMsgSourceSearchScope write FMsgSourceSearchScope;
      property RealtimeFileMonitor: Byte read FRealtimeFileMonitor write FRealtimeFileMonitor;
      property UseAgentTLSCert: Byte read FUseAgentTLSCert write FUseAgentTLSCert;
      property AgentTLSCertLocation: String read FAgentTLSCertLocation write FAgentTLSCertLocation;
      property AgentTLSCertStore: String read FAgentTLSCertStore write FAgentTLSCertStore;
      property AgentTLSCertSubject: String read FAgentTLSCertSubject write FAgentTLSCertSubject;
      property MediatorTLSCertLocation: String read FMediatorTLSCertLocation write FMediatorTLSCertLocation;
      property AgentTLSCertFile: String read FAgentTLSCertFile write FAgentTLSCertFile;
      property AgentTLSSecretKeyFilename: String read FAgentTLSSecretKeyFilename write FAgentTLSSecretKeyFilename;
      property AgentTLSSecretKeyPassword: String read FAgentTLSSecretKeyPassword write FAgentTLSSecretKeyPassword;
      property EnforceMediatorTLSCertTrust: Byte read FEnforceMediatorTLSCertTrust write FEnforceMediatorTLSCertTrust;
      property EnforceMediatorTLSCertRevocation: Byte read FEnforceMediatorTLSCertRevocation write FEnforceMediatorTLSCertRevocation;
      property MediatorTLSCertOCSPURL: String read FMediatorTLSCertOCSPURL write FMediatorTLSCertOCSPURL;
      property RealtimeAnomalyDetection: Byte read FRealtimeAnomalyDetection write FRealtimeAnomalyDetection;
      property RealtimeRecordBufferLimit: Integer read FRealtimeRecordBufferLimit write FRealtimeRecordBufferLimit;
      property SFlowServerEnabled: Byte read FSFlowServerEnabled write FSFlowServerEnabled;
      property SFlowServerUDPPort: Integer read FSFlowServerUDPPort write FSFlowServerUDPPort;
      property SFlowExtraLogging: Byte read FSFlowExtraLogging write FSFlowExtraLogging;
      property SFlowServerNIC: String read FSFlowServerNIC write FSFlowServerNIC;
      property SFlowLogDetails: Byte read FSFlowLogDetails write FSFlowLogDetails;
      property SFlowLogCounters: Byte read FSFlowLogCounters write FSFlowLogCounters;
      property UnidirectionalAgentEnabled: Integer read FUnidirectionalAgentEnabled write FUnidirectionalAgentEnabled;
      property UnidirectionalAgentMediatorPort: Integer read FUnidirectionalAgentMediatorPort write FUnidirectionalAgentMediatorPort;
      property UnidirectionalAgentHashMode: Byte read FUnidirectionalAgentHashMode write FUnidirectionalAgentHashMode;
      property FailbackDelay: Integer read FFailbackDelay write FFailbackDelay;
      property LoadBalanceDelay: Integer read FLoadBalanceDelay write FLoadBalanceDelay;
      property RealtimeIDMPollingInterval: Integer read FRealtimeIDMPollingInterval write FRealtimeIDMPollingInterval;
      property Mediators: TSystemMonitorToMediatorList read FMediators;
      property SecondsSinceLastheartBeat: Integer read GetSecondsSinceLastheartbeat;
  end;

  TSystemMonitorList = class
    protected
      FDict: TDictionary<Integer, TSystemMonitor>;
      FIDList: TList<Integer>;
      function GetCount: Integer;
      function GetSystemMonitor(AIndex: Integer): TSystemMonitor;
      class function GetInitialSQL: TStringList;
      class function CreateSystemMonitor(ADataSet: TDataSet): TSystemMonitor;
      class function CreateSystemMonitorToMediator(ADataSet: TDataSet): TSystemMonitorToMediator;
    public
      constructor Create; overload; virtual;
      constructor Create(ASystemMonitorList: TSystemMonitorList); overload; virtual;
      destructor Destroy; override;
      procedure Clear;
      function GetSystemMonitorByID(ASystemMonitorID: Integer): TSystemMonitor;
      procedure SetLastHeartbeats(ALastHeartbeats: TObjectList<THeartbeatRecord>);
      class function GetAll(AConnection: TFDConnection): TSystemMonitorList;
      class function GetHeartbeats(AConnection: TFDConnection): TDictionary<Integer, TDateTime>;
      procedure Add(ASystemMonitor: TSystemMonitor);
      property Count: Integer read GetCount;
      property SystemMonitors: TDictionary<Integer, TSystemMonitor> read FDict;
      property SystemMonitor[AIndex: Integer]: TSystemMonitor read GetSystemMonitor; default;
  end;

implementation

constructor THeartbeatRecord.Create(ASystemMonitorID: Integer; ALastHeartbeat: TDateTime);
begin
  FSystemMonitorID := ASystemMonitorID;
  FLastHeartbeat := ALastHeartbeat;
end;

constructor TSystemMonitor.Create;
begin
  FSystemMonitorID := 0;
  FHostID := 0;
  FName := '';
  FShortDesc := '';
  FLongDesc := '';
  FPassphrase := '';
  FStatus := 0;
  FHeartbeatInterval := 0;
  FCycleTime := 0;
  FMsgBuffer := 0;
  FRecordStatus := 0;
  FDateUpdated := -1.00;
  FSystemMonitorType := 0;
  FLastHeartbeat := -1.00;
  FHeartbeatWarningInterval := 0;
  FGUID := '';
  FVersion := '';
  FLogLevel := 0;
  FCompress := 0;
  FCompressBatch := 0;
  FProcessPriority := 0;
  FMaxServiceMemory := 0;
  FMaxLogQueueMemory := 0;
  FConnectionTimeout := 0;
  FSocketSendTimeout := 0;
  FSocketReceiveTimeout := 0;
  FFlushBatch := 0;
  FDisableFlushThrottle := 0;
  FMaxSyslogSuspenseSize := 0;
  FEventLogBuffer := 0;
  FEventLogTimeout := 0;
  FEventLogCacheLifetime := 0;
  FLocalLogLifetime := 0;
  FFileMonitor := 0;
  FVirtualSourceDNSResolution := 0;
  FSyslogServer := 0;
  FSyslogServerNIC := '';
  FSyslogServerCrypto := 0;
  FSyslogFile := 0;
  FSyslogFilePath := '';
  FSyslogFileRotationSize := 0;
  FSyslogFileHistory := 0;
  FNetflowServer := 0;
  FNetflowServerNIC := '';
  FNetflowServerPort := 0;
  FNetflowServerCrypto := 0;
  FParameter1 := 0;
  FParameter2 := 0;
  FParameter3 := 0;
  FParameter4 := 0;
  FParameter5 := 0;
  FParameter6 := '';
  FParameter7 := '';
  FSyslogParsedHosts := '';
  FSyslogParsedHostExpressions := '';
  FSyslogUDPPort := 0;
  FSyslogTCPPort := 0;
  FDataDefender := 0;
  FDLDPolicyID := 0;
  FFIMPolicyID := 0;
  FFIMIncludeUAMData := 0;
  FSNMPTrapReceiver := 0;
  FSNMPLocalIP := '';
  FSNMPLocalPort := 0;
  FSNMPCommunityString := '';
  FSNMPAuthenticationUser := '';
  FSNMPAuthenticationPassword := '';
  FSNMPAuthenticationAlgorithm := 0;
  FSNMPEncryptionPassword := '';
  FSNMPEncryptionAlgorithm := 0;
  FProcessMonitor := 0;
  FProcessMonitorInterval := 0;
  FPMIncludeUAMData := 0;
  FNetworkConnectionMonitor := 0;
  FNetworkConnectionMonitorInterval := 0;
  FNCMIncludeUAMData := 0;
  FLogListeners := 0;
  FLogEstablishedInboundConnections := 0;
  FLogEstablishedOutboundConnections := 0;
  FNetflowVerbose := 0;
  FLastMediator := '';
  FMsgSourceSearchScope := 0;
  FRealtimeFileMonitor := 0;
  FUseAgentTLSCert := 0;
  FAgentTLSCertLocation := '';
  FAgentTLSCertStore := '';
  FAgentTLSCertSubject := '';
  FMediatorTLSCertLocation := '';
  FAgentTLSCertFile := '';
  FAgentTLSSecretKeyFilename := '';
  FAgentTLSSecretKeyPassword := '';
  FEnforceMediatorTLSCertTrust := 0;
  FEnforceMediatorTLSCertRevocation := 0;
  FMediatorTLSCertOCSPURL := '';
  FRealtimeAnomalyDetection := 0;
  FRealtimeRecordBufferLimit := 0;
  FSFlowServerEnabled := 0;
  FSFlowServerUDPPort := 0;
  FSFlowExtraLogging := 0;
  FSFlowServerNIC := '';
  FSFlowLogDetails := 0;
  FSFlowLogCounters := 0;
  FUnidirectionalAgentEnabled := 0;
  FUnidirectionalAgentMediatorPort := 0;
  FUnidirectionalAgentHashMode := 0;
  FFailbackDelay := 0;
  FLoadBalanceDelay := 0;
  FRealtimeIDMPollingInterval := 0;
  FMediators := TSystemMonitorToMediatorList.Create;
end;

constructor TSystemMonitor.Create(ASystemMonitor: TSystemMonitor);
begin
  FSystemMonitorID := ASystemMonitor.SystemMonitorID;
  FHostID := ASystemMonitor.HostID;
  FName := ASystemMonitor.Name;
  FShortDesc := ASystemMonitor.ShortDesc;
  FLongDesc := ASystemMonitor.LongDesc;
  FPassphrase := ASystemMonitor.Passphrase;
  FStatus := ASystemMonitor.Status;
  FHeartbeatInterval := ASystemMonitor.HeartbeatInterval;
  FCycleTime := ASystemMonitor.CycleTime;
  FMsgBuffer := ASystemMonitor.MsgBuffer;
  FRecordStatus := ASystemMonitor.RecordStatus;
  FDateUpdated := ASystemMonitor.DateUpdated;
  FSystemMonitorType := ASystemMonitor.SystemMonitorType;
  FLastHeartbeat := ASystemMonitor.LastHeartbeat;
  FHeartbeatWarningInterval := ASystemMonitor.HeartbeatWarningInterval;
  FGUID := ASystemMonitor.GUID;
  FVersion := ASystemMonitor.Version;
  FLogLevel := ASystemMonitor.LogLevel;
  FCompress := ASystemMonitor.Compress;
  FCompressBatch := ASystemMonitor.CompressBatch;
  FProcessPriority := ASystemMonitor.ProcessPriority;
  FMaxServiceMemory := ASystemMonitor.MaxServiceMemory;
  FMaxLogQueueMemory := ASystemMonitor.MaxLogQueueMemory;
  FConnectionTimeout := ASystemMonitor.ConnectionTimeout;
  FSocketSendTimeout := ASystemMonitor.SocketSendTimeout;
  FSocketReceiveTimeout := ASystemMonitor.SocketReceiveTimeout;
  FFlushBatch := ASystemMonitor.FlushBatch;
  FDisableFlushThrottle := ASystemMonitor.DisableFlushThrottle;
  FMaxSyslogSuspenseSize := ASystemMonitor.MaxSyslogSuspenseSize;
  FEventLogBuffer := ASystemMonitor.EventLogBuffer;
  FEventLogTimeout := ASystemMonitor.EventLogTimeout;
  FEventLogCacheLifetime := ASystemMonitor.EventLogCacheLifetime;
  FLocalLogLifetime := ASystemMonitor.LocalLogLifetime;
  FFileMonitor := ASystemMonitor.FileMonitor;
  FVirtualSourceDNSResolution := ASystemMonitor.VirtualSourceDNSResolution;
  FSyslogServer := ASystemMonitor.SyslogServer;
  FSyslogServerNIC := ASystemMonitor.SyslogServerNIC;
  FSyslogServerCrypto := ASystemMonitor.SyslogServerCrypto;
  FSyslogFile := ASystemMonitor.SyslogFile;
  FSyslogFilePath := ASystemMonitor.SyslogFilePath;
  FSyslogFileRotationSize := ASystemMonitor.SyslogFileRotationSize;
  FSyslogFileHistory := ASystemMonitor.SyslogFileHistory;
  FNetflowServer := ASystemMonitor.NetflowServer;
  FNetflowServerNIC := ASystemMonitor.NetflowServerNIC;
  FNetflowServerPort := ASystemMonitor.NetflowServerPort;
  FNetflowServerCrypto := ASystemMonitor.NetflowServerCrypto;
  FParameter1 := ASystemMonitor.Parameter1;
  FParameter2 := ASystemMonitor.Parameter2;
  FParameter3 := ASystemMonitor.Parameter3;
  FParameter4 := ASystemMonitor.Parameter4;
  FParameter5 := ASystemMonitor.Parameter5;
  FParameter6 := ASystemMonitor.Parameter6;
  FParameter7 := ASystemMonitor.Parameter7;
  FSyslogParsedHosts := ASystemMonitor.SyslogParsedHosts;
  FSyslogParsedHostExpressions := ASystemMonitor.SyslogParsedHostExpressions;
  FSyslogUDPPort := ASystemMonitor.SyslogUDPPort;
  FSyslogTCPPort := ASystemMonitor.SyslogTCPPort;
  FDataDefender := ASystemMonitor.DataDefender;
  FDLDPolicyID := ASystemMonitor.DLDPolicyID;
  FFIMPolicyID := ASystemMonitor.FIMPolicyID;
  FFIMIncludeUAMData := ASystemMonitor.FIMIncludeUAMData;
  FSNMPTrapReceiver := ASystemMonitor.SNMPTrapReceiver;
  FSNMPLocalIP := ASystemMonitor.SNMPLocalIP;
  FSNMPLocalPort := ASystemMonitor.SNMPLocalPort;
  FSNMPCommunityString := ASystemMonitor.SNMPCommunityString;
  FSNMPAuthenticationUser := ASystemMonitor.SNMPAuthenticationUser;
  FSNMPAuthenticationPassword := ASystemMonitor.SNMPAuthenticationPassword;
  FSNMPAuthenticationAlgorithm := ASystemMonitor.SNMPAuthenticationAlgorithm;
  FSNMPEncryptionPassword := ASystemMonitor.SNMPEncryptionPassword;
  FSNMPEncryptionAlgorithm := ASystemMonitor.SNMPEncryptionAlgorithm;
  FProcessMonitor := ASystemMonitor.ProcessMonitor;
  FProcessMonitorInterval := ASystemMonitor.ProcessMonitorInterval;
  FPMIncludeUAMData := ASystemMonitor.PMIncludeUAMData;
  FNetworkConnectionMonitor := ASystemMonitor.NetworkConnectionMonitor;
  FNetworkConnectionMonitorInterval := ASystemMonitor.NetworkConnectionMonitorInterval;
  FNCMIncludeUAMData := ASystemMonitor.NCMIncludeUAMData;
  FLogListeners := ASystemMonitor.LogListeners;
  FLogEstablishedInboundConnections := ASystemMonitor.LogEstablishedInboundConnections;
  FLogEstablishedOutboundConnections := ASystemMonitor.LogEstablishedOutboundConnections;
  FNetflowVerbose := ASystemMonitor.NetflowVerbose;
  FLastMediator := ASystemMonitor.LastMediator;
  FMsgSourceSearchScope := ASystemMonitor.MsgSourceSearchScope;
  FRealtimeFileMonitor := ASystemMonitor.RealtimeFileMonitor;
  FUseAgentTLSCert := ASystemMonitor.UseAgentTLSCert;
  FAgentTLSCertLocation := ASystemMonitor.AgentTLSCertLocation;
  FAgentTLSCertStore := ASystemMonitor.AgentTLSCertStore;
  FAgentTLSCertSubject := ASystemMonitor.AgentTLSCertSubject;
  FMediatorTLSCertLocation := ASystemMonitor.MediatorTLSCertLocation;
  FAgentTLSCertFile := ASystemMonitor.AgentTLSCertFile;
  FAgentTLSSecretKeyFilename := ASystemMonitor.AgentTLSSecretKeyFilename;
  FAgentTLSSecretKeyPassword := ASystemMonitor.AgentTLSSecretKeyPassword;
  FEnforceMediatorTLSCertTrust := ASystemMonitor.EnforceMediatorTLSCertTrust;
  FEnforceMediatorTLSCertRevocation := ASystemMonitor.EnforceMediatorTLSCertRevocation;
  FMediatorTLSCertOCSPURL := ASystemMonitor.MediatorTLSCertOCSPURL;
  FRealtimeAnomalyDetection := ASystemMonitor.RealtimeAnomalyDetection;
  FRealtimeRecordBufferLimit := ASystemMonitor.RealtimeRecordBufferLimit;
  FSFlowServerEnabled := ASystemMonitor.SFlowServerEnabled;
  FSFlowServerUDPPort := ASystemMonitor.SFlowServerUDPPort;
  FSFlowExtraLogging := ASystemMonitor.SFlowExtraLogging;
  FSFlowServerNIC := ASystemMonitor.SFlowServerNIC;
  FSFlowLogDetails := ASystemMonitor.SFlowLogDetails;
  FSFlowLogCounters := ASystemMonitor.SFlowLogCounters;
  FUnidirectionalAgentEnabled := ASystemMonitor.UnidirectionalAgentEnabled;
  FUnidirectionalAgentMediatorPort := ASystemMonitor.UnidirectionalAgentMediatorPort;
  FUnidirectionalAgentHashMode := ASystemMonitor.UnidirectionalAgentHashMode;
  FFailbackDelay := ASystemMonitor.FailbackDelay;
  FLoadBalanceDelay := ASystemMonitor.LoadBalanceDelay;
  FRealtimeIDMPollingInterval := ASystemMonitor.RealtimeIDMPollingInterval;
  FMediators := TSystemMonitorToMediatorList.Create(ASystemMonitor.Mediators);
end;

destructor TSystemMonitor.Destroy;
begin
  FMediators.Free;
  inherited Destroy;
end;

function TSystemMonitor.GetSecondsSinceLastheartbeat: Integer;
var
  LHeartbeat: TDateTime;
begin
  if FLastheartbeat < 10.00 then
    Result := -1
  else
  begin
    LHeartbeat := TTimeZone.Local.ToLocalTime(FLastHeartbeat);
    Result := SecondsBetween(FQueryTime, TTimeZone.Local.ToLocalTime(LHeartbeat));
  end;
end;

function TSystemMonitorList.GetCount: Integer;
begin
  Result := FDict.Keys.Count;
end;

class function TSystemMonitorList.GetInitialSQL: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('Select SystemMonitor.SystemMonitorID, ');
  Result.Add('SystemMonitor.HostID, ');
  Result.Add('SystemMonitor.Name, ');
  Result.Add('SystemMonitor.ShortDesc, ');
  Result.Add('SystemMonitor.LongDesc, ');
  Result.Add('SystemMonitor.Passphrase, ');
  Result.Add('SystemMonitor.Status, ');
  Result.Add('SystemMonitor.HeartbeatInterval, ');
  Result.Add('SystemMonitor.CycleTime, ');
  Result.Add('SystemMonitor.MsgBuffer, ');
  Result.Add('SystemMonitor.RecordStatus, ');
  Result.Add('SystemMonitor.DateUpdated, ');
  Result.Add('SystemMonitor.SystemMonitorType, ');
  Result.Add('SystemMonitor.LastHeartbeat, ');
  Result.Add('SystemMonitor.HeartbeatWarningInterval, ');
  Result.Add('SystemMonitor.GUID, ');
  Result.Add('SystemMonitor.Version, ');
  Result.Add('SystemMonitor.LogLevel, ');
  Result.Add('SystemMonitor.Compress, ');
  Result.Add('SystemMonitor.CompressBatch, ');
  Result.Add('SystemMonitor.ProcessPriority, ');
  Result.Add('SystemMonitor.MaxServiceMemory, ');
  Result.Add('SystemMonitor.MaxLogQueueMemory, ');
  Result.Add('SystemMonitor.ConnectionTimeout, ');
  Result.Add('SystemMonitor.SocketSendTimeout, ');
  Result.Add('SystemMonitor.SocketReceiveTimeout, ');
  Result.Add('SystemMonitor.FlushBatch, ');
  Result.Add('SystemMonitor.DisableFlushThrottle, ');
  Result.Add('SystemMonitor.MaxSyslogSuspenseSize, ');
  Result.Add('SystemMonitor.EventLogBuffer, ');
  Result.Add('SystemMonitor.EventLogTimeout, ');
  Result.Add('SystemMonitor.EventLogCacheLifetime, ');
  Result.Add('SystemMonitor.LocalLogLifetime, ');
  Result.Add('SystemMonitor.FileMonitor, ');
  Result.Add('SystemMonitor.VirtualSourceDNSResolution, ');
  Result.Add('SystemMonitor.SyslogServer, ');
  Result.Add('SystemMonitor.SyslogServerNIC, ');
  Result.Add('SystemMonitor.SyslogServerCrypto, ');
  Result.Add('SystemMonitor.SyslogFile, ');
  Result.Add('SystemMonitor.SyslogFilePath, ');
  Result.Add('SystemMonitor.SyslogFileRotationSize, ');
  Result.Add('SystemMonitor.SyslogFileHistory, ');
  Result.Add('SystemMonitor.NetflowServer, ');
  Result.Add('SystemMonitor.NetflowServerNIC, ');
  Result.Add('SystemMonitor.NetflowServerPort, ');
  Result.Add('SystemMonitor.NetflowServerCrypto, ');
  Result.Add('SystemMonitor.Parameter1, ');
  Result.Add('SystemMonitor.Parameter2, ');
  Result.Add('SystemMonitor.Parameter3, ');
  Result.Add('SystemMonitor.Parameter4, ');
  Result.Add('SystemMonitor.Parameter5, ');
  Result.Add('SystemMonitor.Parameter6, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.SyslogParsedHosts, ');
  Result.Add('SystemMonitor.SyslogParsedHostExpressions, ');
  Result.Add('SystemMonitor.SyslogUDPPort, ');
  Result.Add('SystemMonitor.SyslogTCPPort, ');
  Result.Add('SystemMonitor.DataDefender, ');
  Result.Add('SystemMonitor.DLDPolicyID, ');
  Result.Add('SystemMonitor.SNMPTrapReceiver, ');
  Result.Add('SystemMonitor.SNMPLocalIP, ');
  Result.Add('SystemMonitor.SNMPLocalPort, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.Parameter7, ');
  Result.Add('SystemMonitor.ProcessMonitor, ');
  Result.Add('SystemMonitor.ProcessMonitorInterval, ');
  Result.Add('SystemMonitor.PMIncludeUAMData, ');
  Result.Add('SystemMonitor.NetworkConnectionMonitor, ');
  Result.Add('SystemMonitor.NetworkConnectionMonitorInterval, ');
  Result.Add('SystemMonitor.NCMIncludeUAMData, ');
  Result.Add('SystemMonitor.LogListeners, ');
  Result.Add('SystemMonitor.LogEstablishedInboundConnections, ');
  Result.Add('SystemMonitor.LogEstablishedOutboundConnections, ');
  Result.Add('SystemMonitor.NetflowVerbose, ');
  Result.Add('SystemMonitor.LastMediator, ');
  Result.Add('SystemMonitor.MsgSourceSearchScope, ');
  Result.Add('SystemMonitor.RealtimeFileMonitor, ');
  Result.Add('SystemMonitor.UseAgentTLSCert, ');
  Result.Add('SystemMonitor.AgentTLSCertLocation, ');
  Result.Add('SystemMonitor.AgentTLSCertStore, ');
  Result.Add('SystemMonitor.AgentTLSCertSubject, ');
  Result.Add('SystemMonitor.MediatorTLSCertLocation, ');
  Result.Add('SystemMonitor.AgentTLSCertFile, ');
  Result.Add('SystemMonitor.AgentTLSSecretKeyFilename, ');
  Result.Add('SystemMonitor.AgentTLSSecretKeyPassword, ');
  Result.Add('SystemMonitor.EnforceMediatorTLSCertTrust, ');
  Result.Add('SystemMonitor.EnforceMediatorTLSCertRevocation, ');
  Result.Add('SystemMonitor.MediatorTLSCertOCSPURL, ');
  Result.Add('SystemMonitor.RealtimeAnomalyDetection, ');
  Result.Add('SystemMonitor.RealtimeRecordBufferLimit, ');
  Result.Add('SystemMonitor.SFlowServerEnabled, ');
  Result.Add('SystemMonitor.SFlowServerUDPPort, ');
  Result.Add('SystemMonitor.SFlowExtraLogging, ');
  Result.Add('SystemMonitor.SFlowServerNIC, ');
  Result.Add('SystemMonitor.SFlowLogDetails, ');
  Result.Add('SystemMonitor.SFlowLogCounters, ');
  Result.Add('SystemMonitor.UnidirectionalAgentEnabled, ');
  Result.Add('SystemMonitor.UnidirectionalAgentMediatorPort, ');
  Result.Add('SystemMonitor.UnidirectionalAgentHashMode, ');

  Result.Add('0, ');
  Result.Add('0, ');
  Result.Add('0, ');
  Result.Add('SystemMonitorToMediator.MediatorID, ');
  Result.Add('SystemMonitorToMediator.Priority, ');
  Result.Add('SystemMonitorToMediator.ClientAddress, ');
  Result.Add('SystemMonitorToMediator.ClientPort, ');
  Result.Add('Mediator.Name ');
  Result.Add('From SystemMonitor With (NoLock) Left Outer Join SystemMonitorToMediator ON SystemMonitor.SystemMonitorID=SystemMonitorToMediator.SystemMonitorID ');
  Result.Add('Inner Join Mediator ON SystemMonitorToMediator.MediatorID=Mediator.MediatorID ');
end;

class function TSystemMonitorList.CreateSystemMonitor(ADataSet: TDataSet): TSystemMonitor;
begin
  Result := TSystemMonitor.Create;
  Result.SystemMonitorID := ADataSet.Fields[0].AsInteger;
  Result.HostID := ADataSet.Fields[1].AsInteger;
  Result.Name := ADataSet.Fields[2].AsString;
  Result.ShortDesc := ADataSet.Fields[3].AsString;
  Result.LongDesc := ADataSet.Fields[4].AsString;
  Result.Passphrase := ADataSet.Fields[5].AsString;
  Result.Status := ADataSet.Fields[6].AsInteger;
  Result.HeartbeatInterval := ADataSet.Fields[7].AsInteger;
  Result.CycleTime := ADataSet.Fields[8].AsInteger;
  Result.MsgBuffer := ADataSet.Fields[9].AsInteger;
  Result.RecordStatus := ADataSet.Fields[10].AsInteger;
  Result.DateUpdated := ADataSet.Fields[11].AsDateTime;
  Result.SystemMonitorType := ADataSet.Fields[12].AsInteger;
  Result.LastHeartbeat := ADataSet.Fields[13].AsDateTime;
  Result.HeartbeatWarningInterval := ADataSet.Fields[14].AsInteger;
  Result.GUID := ADataSet.Fields[15].AsString;
  Result.Version := ADataSet.Fields[16].AsString;
  Result.LogLevel := ADataSet.Fields[17].AsInteger;
  Result.Compress := ADataSet.Fields[18].AsInteger;
  Result.CompressBatch := ADataSet.Fields[19].AsInteger;
  Result.ProcessPriority := ADataSet.Fields[20].AsInteger;
  Result.MaxServiceMemory := ADataSet.Fields[21].AsInteger;
  Result.MaxLogQueueMemory := ADataSet.Fields[22].AsInteger;
  Result.ConnectionTimeout := ADataSet.Fields[23].AsInteger;
  Result.SocketSendTimeout := ADataSet.Fields[24].AsInteger;
  Result.SocketReceiveTimeout := ADataSet.Fields[25].AsInteger;
  Result.FlushBatch := ADataSet.Fields[26].AsInteger;
  Result.DisableFlushThrottle := ADataSet.Fields[27].AsInteger;
  Result.MaxSyslogSuspenseSize := ADataSet.Fields[28].AsInteger;
  Result.EventLogBuffer := ADataSet.Fields[29].AsInteger;
  Result.EventLogTimeout := ADataSet.Fields[30].AsInteger;
  Result.EventLogCacheLifetime := ADataSet.Fields[31].AsInteger;
  Result.LocalLogLifetime := ADataSet.Fields[32].AsInteger;
  Result.FileMonitor := ADataSet.Fields[33].AsInteger;
  Result.VirtualSourceDNSResolution := ADataSet.Fields[34].AsInteger;
  Result.SyslogServer := ADataSet.Fields[35].AsInteger;
  Result.SyslogServerNIC := ADataSet.Fields[36].AsString;
  Result.SyslogServerCrypto := ADataSet.Fields[37].AsInteger;
  Result.SyslogFile := ADataSet.Fields[38].AsInteger;
  Result.SyslogFilePath := ADataSet.Fields[39].AsString;
  Result.SyslogFileRotationSize := ADataSet.Fields[40].AsInteger;
  Result.SyslogFileHistory := ADataSet.Fields[41].AsInteger;
  Result.NetflowServer := ADataSet.Fields[42].AsInteger;
  Result.NetflowServerNIC := ADataSet.Fields[43].AsString;
  Result.NetflowServerPort := ADataSet.Fields[44].AsInteger;
  Result.NetflowServerCrypto := ADataSet.Fields[45].AsInteger;
  Result.Parameter1 := ADataSet.Fields[46].AsInteger;
  Result.Parameter2 := ADataSet.Fields[47].AsInteger;
  Result.Parameter3 := ADataSet.Fields[48].AsInteger;
  Result.Parameter4 := ADataSet.Fields[49].AsInteger;
  Result.Parameter5 := ADataSet.Fields[50].AsInteger;
  Result.Parameter6 := ADataSet.Fields[51].AsString;
  Result.Parameter7 := ADataSet.Fields[52].AsString;
  Result.SyslogParsedHosts := ADataSet.Fields[53].AsString;
  Result.SyslogParsedHostExpressions := ADataSet.Fields[54].AsString;
  Result.SyslogUDPPort := ADataSet.Fields[55].AsInteger;
  Result.SyslogTCPPort := ADataSet.Fields[56].AsInteger;
  Result.DataDefender := ADataSet.Fields[57].AsInteger;
  Result.DLDPolicyID := ADataSet.Fields[58].AsInteger;
  Result.SNMPTrapReceiver := ADataSet.Fields[59].AsInteger;
  Result.SNMPLocalIP := ADataSet.Fields[60].AsString;
  Result.SNMPLocalPort := ADataSet.Fields[61].AsInteger;
  Result.SNMPCommunityString := ADataSet.Fields[62].AsString;
  Result.SNMPAuthenticationUser := ADataSet.Fields[63].AsString;
  Result.SNMPAuthenticationPassword := ADataSet.Fields[64].AsString;
//  Result.SNMPAuthenticationAlgorithm := ADataSet.Fields[65].AsInteger;
  Result.SNMPEncryptionPassword := ADataSet.Fields[66].AsString;
//  Result.SNMPEncryptionAlgorithm := ADataSet.Fields[67].AsInteger;
  Result.ProcessMonitor := ADataSet.Fields[68].AsInteger;
  Result.ProcessMonitorInterval := ADataSet.Fields[69].AsInteger;
  Result.PMIncludeUAMData := ADataSet.Fields[70].AsInteger;
  Result.NetworkConnectionMonitor := ADataSet.Fields[71].AsInteger;
  Result.NetworkConnectionMonitorInterval := ADataSet.Fields[72].AsInteger;
  Result.NCMIncludeUAMData := ADataSet.Fields[73].AsInteger;
  Result.LogListeners := ADataSet.Fields[74].AsInteger;
  Result.LogEstablishedInboundConnections := ADataSet.Fields[75].AsInteger;
  Result.LogEstablishedOutboundConnections := ADataSet.Fields[75].AsInteger;
  Result.NetflowVerbose := ADataSet.Fields[77].AsInteger;
  Result.LastMediator := ADataSet.Fields[78].AsString;
  Result.MsgSourceSearchScope := ADataSet.Fields[79].AsInteger;
  Result.RealtimeFileMonitor := ADataSet.Fields[80].AsInteger;
  Result.UseAgentTLSCert := ADataSet.Fields[81].AsInteger;
  Result.AgentTLSCertLocation := ADataSet.Fields[82].AsString;
  Result.AgentTLSCertStore := ADataSet.Fields[83].AsString;
  Result.AgentTLSCertSubject := ADataSet.Fields[84].AsString;
  Result.MediatorTLSCertLocation := ADataSet.Fields[85].AsString;
  Result.AgentTLSCertFile := ADataSet.Fields[86].AsString;
  Result.AgentTLSSecretKeyFilename := ADataSet.Fields[87].AsString;
  Result.AgentTLSSecretKeyPassword := ADataSet.Fields[88].AsString;
  Result.EnforceMediatorTLSCertTrust := ADataSet.Fields[89].AsInteger;
  Result.EnforceMediatorTLSCertRevocation := ADataSet.Fields[90].AsInteger;
  Result.MediatorTLSCertOCSPURL := ADataSet.Fields[91].AsString;
  Result.RealtimeAnomalyDetection := ADataSet.Fields[92].AsInteger;
  Result.RealtimeRecordBufferLimit := ADataSet.Fields[93].AsInteger;
  Result.SFlowServerEnabled := ADataSet.Fields[94].AsInteger;
  Result.SFlowServerUDPPort := ADataSet.Fields[95].AsInteger;
  Result.SFlowExtraLogging := ADataSet.Fields[96].AsInteger;
  Result.SFlowServerNIC := ADataSet.Fields[97].AsString;
  Result.SFlowLogDetails := ADataSet.Fields[98].AsInteger;
  Result.SFlowLogCounters := ADataSet.Fields[99].AsInteger;
//  Result.UnidirectionalAgentEnabled := ADataSet.Fields[100].AsInteger;
//  Result.UnidirectionalAgentMediatorPort := ADataSet.Fields[101].AsInteger;
//  Result.UnidirectionalAgentHashMode := ADataSet.Fields[102].AsInteger;
//  Result.FailbackDelay := ADataSet.Fields[103].AsInteger;
//  Result.LoadBalanceDelay := ADataSet.Fields[104].AsInteger;
//  Result.RealtimeIDMPollingInterval := ADataSet.Fields[105].AsInteger;
end;

class function TSystemMonitorList.CreateSystemMonitorToMediator(ADataSet: TDataSet): TSystemMonitorToMediator;
begin
  Result := TSystemMonitorToMediator.Create;
  Result.MediatorID := ADataSet.Fields[106].AsInteger;
  Result.SystemMonitorID := ADataSet.Fields[0].AsInteger;
  Result.Priority := ADataSet.Fields[107].AsInteger;
  Result.ClientAddress := ADataSet.Fields[108].AsString;
  Result.ClientPort := ADataSet.Fields[109].AsInteger;
  Result.MediatorName := ADataSet.Fields[110].AsString;
end;

constructor TSystemMonitorList.Create;
begin
  inherited Create;
  FIDList := TList<Integer>.Create;
  FDict := TDictionary<Integer, TSystemMonitor>.Create;
end;

constructor TSystemMonitorList.Create(ASystemMonitorList: TSystemMonitorList);
var
  i: Integer;
  LSM: TSystemMonitor;
begin
  inherited Create;
  FIDList := TList<Integer>.Create;
  FDict := TDictionary<Integer, TSystemMonitor>.Create;
  for i in ASystemMonitorList.SystemMonitors.Keys do
  begin
    LSM := ASystemMonitorList.SystemMonitors[i];
    FIDList.Add(LSM.SystemMonitorID);
    FDict.Add(LSM.SystemMonitorID, TSystemMonitor.Create(LSM) );
  end;
end;

destructor TSystemMonitorList.Destroy;
begin
  Clear;
  FIDList.Free;
  FDict.Free;
  inherited Destroy;
end;

procedure TSystemMonitorList.Clear;
var
  i: Integer;
begin
  for i in FDict.Keys do
     FDict[i].Free;
  FDict.Clear;
  FIDList.Clear;
end;

function TSystemMonitorList.GetSystemMonitor(AIndex: Integer): TSystemMonitor;
begin
  Result := FDict[FIDList[AIndex]];
end;

procedure TSystemMonitorList.Add(ASystemMonitor: TSystemMonitor);
begin
  FIDList.Add(ASystemMonitor.SystemMonitorID);
  FDict.Add(ASystemMonitor.SystemMonitorID, ASystemMonitor);
end;

function TSystemMonitorList.GetSystemMonitorByID(ASystemMonitorID: Integer): TSystemMonitor;
var
  i: Integer;
  LSystemMonitor : TSystemMonitor;
begin
  Result := nil;
  if FDict.TryGetValue(ASystemMonitorID, LSystemMonitor) then
    Result := LSystemMonitor;
end;

procedure TSystemMonitorList.SetLastHeartbeats(ALastHeartbeats: TObjectList<THeartbeatRecord>);
var
  i: Integer;
  LSM: TSystemMonitor;
begin
  for i := 0 to (ALastHeartbeats.Count - 1) do
  begin
    if FDict.TryGetValue(ALastHeartbeats[i].SystemMonitorID, LSM) then
      LSM.LastHeartbeat := ALastHeartbeats[i].LastHeartbeat;
  end;
end;

class function TSystemMonitorList.GetAll(AConnection: TFDConnection): TSystemMonitorList;
begin
  Result := nil;
  try
    var LQuery := TDataServices.GetQuery(AConnection);
    try
      var LSQL := GetInitialSQL;
      LSQL.Add('Order By SystemMonitor.SystemMonitorID, SystemMonitorToMediator.Priority ');
      try
        for var i := 0 to (LSQL.Count - 1) do
          LQuery.SQL.Add(LSQL[i]);
      finally
        LSQL.Free;
      end;

      AConnection.Open;
      var LQueryTime := Now;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TSystemMonitorList.Create;
        LQuery.First;
        var LSystemMonitorID := -1;
        var LRecord: TSystemMonitor := nil;
        while not LQuery.EOF do
        begin
          if (LSystemMonitorID <> LQuery.Fields[0].AsInteger) then
          begin
            LRecord := CreateSystemMonitor(LQuery);
            LRecord.QueryTime := LQueryTime;
            Result.Add(LRecord);
            LSystemMonitorID := LQuery.Fields[0].AsInteger
          end;
          if not LQuery.Fields[106].IsNull then
          begin
            var LSystemMonitorToMediator := CreateSystemMonitorToMediator(LQuery);
            LRecord.Mediators.Add(LSystemMonitorToMediator);
          end;
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

class function TSystemMonitorList.GetHeartbeats(AConnection: TFDConnection): TDictionary<Integer, TDateTime>;
begin
  Result := nil;
  try
    var LQuery := TDataServices.GetQuery(AConnection);
    try
      LQuery.SQL.Add('Select SystemMonitorID, LastHeartbeat From SystemMonitor Order By SystemMonitorID');
      AConnection.Open;
      LQuery.Open;
      if not LQuery.IsEmpty then
      begin
        Result := TDictionary<Integer, TDateTime>.Create;
        LQuery.First;
        while not LQuery.EOF do
        begin
          Result.Add( LQuery.Fields[0].AsInteger, LQuery.Fields[1].AsDateTime );
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
