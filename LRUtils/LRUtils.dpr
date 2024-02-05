program LRUtils;

uses
  Vcl.Forms,
  Vcl.Controls,
  LRToolsMain in 'LRToolsMain.pas' {fmMain},
  DataServices in '..\LRCommon\data\DataServices.pas',
  MsgSource in '..\LRCommon\data\MsgSource.pas',
  SystemMonitor in '..\LRCommon\data\SystemMonitor.pas',
  CommonEnums in '..\LRCommon\units\CommonEnums.pas',
  CryptoAPI in '..\LRCommon\units\CryptoAPI.pas',
  CustomThread in '..\LRCommon\units\CustomThread.pas',
  FileLogger in '..\LRCommon\units\FileLogger.pas',
  LockableObject in '..\LRCommon\units\LockableObject.pas',
  MyBaseThread in '..\LRCommon\units\MyBaseThread.pas',
  Settings in '..\LRCommon\units\Settings.pas',
  Utilities in '..\LRCommon\units\Utilities.pas',
  Wcrypt2 in '..\LRCommon\units\Wcrypt2.pas',
  SystemMonitorToMediator in '..\LRCommon\data\SystemMonitorToMediator.pas',
  BaseModalForm in '..\LRCommon\forms\BaseModalForm.pas' {fmBaseModalForm},
  LoginDetails in '..\LRCommon\forms\LoginDetails.pas' {fmLoginDetails},
  MsgSources in 'MsgSources.pas' {fmSyslogSources},
  MsgSource.Syslog in '..\LRCommon\data\MsgSource.Syslog.pas',
  SingleRecordLookupUnbound in '..\LRCommon\forms\SingleRecordLookupUnbound.pas' {fmSingleRecordLookupUnbound},
  LookUpSystemMonitor in 'LookUpSystemMonitor.pas' {fmSystemMonitorLookUp},
  SystemMonitorBasic in '..\LRCommon\data\SystemMonitorBasic.pas';

{$R *.res}

function LoginOK: Boolean;
begin
  var fm := TfmLoginDetails.Create(nil);
  try
    Result := (mrOK = fm.ShowModal);
  finally
    fm.Free;
  end;
end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  if LoginOK then
  begin
    Application.CreateForm(TfmMain, fmMain);
  Application.Run;
  end else
    Application.Terminate;
end.
