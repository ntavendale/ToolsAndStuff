unit MyBaseThread;

interface

uses
  System.Classes, SysUtils, WinApi.Windows, WinApi.Messages, SyncObjs;

type
  TMyBaseThread = class(TThread)
  private
    { Private declarations }
    FCriticalSection: TCriticalSection;
  protected
    FShouldFinishEvent: THandle;
    FFinishedEvent: THandle;
    //Need these to make an interace later
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure Lock;
    procedure Unlock;
    function OnThreadBegin: Boolean; virtual;
    function OnThreadEnd: Boolean; virtual;
  public
    constructor Create; reintroduce; overload; virtual;
    constructor Create(CreateSuspended: Boolean); reintroduce; overload; virtual;
    function ThreadStart: Boolean;
    function ThreadStop(AWaitTillFinished: Boolean): Boolean;
  end;

implementation

constructor TMyBaseThread.Create;
begin
  Create(TRUE);
end;

constructor TMyBaseThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  ThreadStart;
end;

function TMyBaseThread.ThreadStart: Boolean;
begin
  FFinishedEvent := CreateEvent( nil, TRUE, FALSE, nil );
  FShouldFinishEvent := CreateEvent( nil, TRUE, FALSE, nil );
  if 0 = FFinishedEvent then
  begin
    Result := FALSE;
    EXIT;
  end;

  Result := TRUE;
  OnThreadBegin();
end;

function TMyBaseThread.ThreadStop(AWaitTillFinished: Boolean): Boolean;
begin
  Result := FALSE;
  if (0 <> FFinishedEvent) then
  begin
    SetEvent(FShouldFinishEvent);
    if (AWaitTillFinished) then
    begin
      if (WAIT_OBJECT_0 = WaitForSingleObject(FFinishedEvent, INFINITE )) then
        Result := TRUE
      else
        Result := FALSE;
    end;
    CloseHandle(FFinishedEvent);
    CloseHandle(FShouldFinishEvent);
    FFinishedEvent := 0;
  end;
  OnThreadEnd();
end;

function TMyBaseThread.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result:= S_OK
  else
    Result:= E_NOINTERFACE;
end;

function TMyBaseThread._AddRef: Integer;
begin
 Result := -1;
end;

function TMyBaseThread._Release: Integer;
begin
  Result := -1;
end;

function TMyBaseThread.OnThreadBegin: Boolean;
begin
  FCriticalSection := TCriticalSection.Create;
  Result := TRUE;
end;

function TMyBaseThread.OnThreadEnd: Boolean;
begin
  FCriticalSection.Free;
  Result := TRUE;
end;

procedure TMyBaseThread.Lock;
begin
  FCriticalSection.Acquire;
end;

procedure TMyBaseThread.Unlock;
begin
  FCriticalSection.Release;
end;


end.
