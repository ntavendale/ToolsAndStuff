unit LRToolsMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.SyncObjs, System.Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  RzButton, System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, RzPanel, MsgSources, Utilities,
  FileLogger, Vcl.StdCtrls, RzEdit, RzTabs;

type
  TLogWriteProc = procedure(AValue: String) of Object;
  TLogReceptionThread = class(TThread)
    private
      FFinishEvent: THandle;
      FLogEvent: Thandle;
      FCrticalSection: TCriticalSection;
      FCurrentLogMessage: String;
      FList: TList<String>;
      FLogWriteProc: TLogWriteProc;
      procedure PushLogToMainThread;
      procedure WriteLogs;
    protected
      procedure TerminatedSet; override;
      procedure Execute; override;
    public
      constructor Create; reintroduce; overload; virtual;
      constructor Create(CreateSuspended: Boolean); reintroduce; overload; virtual;
      destructor Destroy; override;
      procedure AddLog(AValue: String);
      property LogWriteProc: TLogWriteProc read FLogWriteProc write FLogWriteProc;
  end;

  TfmMain = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    tbMain: TRzToolbar;
    ilMain: TImageList;
    btnSylogSources: TRzToolButton;
    gbDetail: TRzGroupBox;
    pcDetail: TRzPageControl;
    tsLog: TRzTabSheet;
    memLog: TRzMemo;
    procedure btnSylogSourcesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FLogReceptionThread: TLogReceptionThread;
    procedure WriteLog(AValue: String);
    procedure CloseMDIChildren;
    procedure OpenForm(AFormIndex: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

{$REGION 'TLogReceptionThread'}
constructor TLogReceptionThread.Create;
begin
  Create(TRUE);
end;

constructor TLogReceptionThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FCrticalSection := TCriticalSection.Create;
  FFinishEvent := CreateEvent(nil, TRUE, FALSE, nil);
  FLogEvent := CreateEvent(nil, TRUE, FALSE, nil);
  FList := TList<String>.Create;
end;

destructor TLogReceptionThread.Destroy;
begin
  FList.Free;
  CloseHandle(FFinishEvent);
  CloseHandle(FLogEvent);
  FCrticalSection.Release;
  FCrticalSection.Free;
  inherited Destroy;
end;

procedure TLogReceptionThread.TerminatedSet;
begin
  SetEvent( FFinishEvent );
end;

procedure TLogReceptionThread.Execute;
var
  LWaitObject: Cardinal;
  LEvents: array[0..1] of THandle;
begin
  LEvents[0] := FFinishEvent;
  LEvents[1] := FLogEvent;
  while not Terminated do
  begin
    LWaitObject := WaitForMultipleObjects(2, @LEvents, FALSE, INFINITE);
    case (LWaitObject - WAIT_OBJECT_0) of
    0:begin
       BREAK;
      end;
    1:begin
       ResetEvent(FLogEvent);
       WriteLogs;
     end;
    end;
  end;
end;

procedure TLogReceptionThread.PushLogToMainThread;
begin
  FLogWriteProc(FCurrentLogMessage);
end;

procedure TLogReceptionThread.WriteLogs;
begin
  var LNewList: TList<String> := TList<String>.Create;
  var LTempList: TList<String> := nil;
  FCrticalSection.Acquire;
  try
    LTempList := FList;
    FList := LNewList;
  finally
    FCrticalSection.Release;
  end;
  for var i := 0 to (LTempList.Count - 1) do
  begin
    if Assigned(FLogWriteProc) then
    begin
      FCurrentLogMessage := LTempList[i];
      Synchronize(PushLogToMainThread);
    end;
  end;
  LTempList.Free;
end;

procedure TLogReceptionThread.AddLog(AValue: String);
begin
  FCrticalSection.Acquire;
  try
    FList.Add(AValue);
    SetEvent(FLogEvent);
  finally
    FCrticalSection.Release;
  end;
end;
{$ENDREGION}

{$REGION 'Custom Methods'}
constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLogReceptionThread := TLogReceptionThread.Create(TRUE);
  FLogReceptionThread.LogWriteProc := WriteLog;
  FLogReceptionThread.FreeOnTerminate := FALSE;
  TFileLogger.SetFileLogLevel(LOG_DEBUG, FLogReceptionThread.AddLog);
  FLogReceptionThread.Suspended := FALSE;
  var LMajorVersion, LMinorVersion, LReleaseVersion, LBuildNumber: Integer;
  TUtilities.GetVersionInfo(ParamStr(0), LMajorVersion, LMinorVersion, LReleaseVersion, LBuildNumber);
  Self.Caption := String.Format('LRUtils %d.%d.%d.%d', [LMajorVersion, LMinorVersion, LReleaseVersion, LBuildNumber]);
end;

destructor TfmMain.Destroy;
begin
  CloseMDIChildren;
  FLogReceptionThread.Terminate;
  FLogReceptionThread.Free;
  inherited Destroy;
end;

procedure TfmMain.WriteLog(AValue: String);
begin
  memLog.Lines.Add(AValue);
end;

procedure TfmMain.CloseMDIChildren;
var
  iLoop  : Integer;
begin
  iLoop := fmMain.MDIChildCount-1;
  while iLoop >= 0 do
  begin
    fmMain.MDIChildren[iLoop].Close;
    fmMain.MDIChildren[iLoop].Free;
    iLoop := iLoop - 1;
  end;
end;

procedure TfmMain.OpenForm(AFormIndex: Integer);
begin
  if not ((0 <= AFormIndex) and (AFormIndex <= 3)) then
    EXIT;
  var LForm: TForm := nil;
  CloseMDIChildren;
  try
    Screen.Cursor := crHourglass;
    LockWindowUpdate(fmMain.Handle); //Locks Main Form to prevent flashing while
    case AFormIndex of
      0: LForm := TfmSyslogSources.Create(nil);
    end;
    LForm.BorderIcons := [];
    LForm.WindowState := wsMaximized;
    LForm.Show;
  finally
    Screen.Cursor := crDefault;
    LockWindowUpdate(0);//Feeding 0 to function unlocks the locked window
  end;
  TUtilities.SetFormKey('MainApp', 'LastForm', IntToStr(AFormIndex));
end;
{$ENDREGION}

procedure TfmMain.btnSylogSourcesClick(Sender: TObject);
begin
  OpenForm(0);
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  LogInfo('How Are You Gentlemen?');
  LogInfo('All Your Logs Are Blelong To You!');
  var LFormIndex := StrToIntDef(TUtilities.GetFormKey('MainApp', 'LastForm'), -1);
  OpenForm(LFormIndex);
end;

end.
