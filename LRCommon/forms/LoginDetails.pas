unit LoginDetails;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Winapi.Windows, Winapi.Messages,
  System.Win.Registry, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  BaseModalForm, RzButton, Vcl.ExtCtrls, RzPanel, Vcl.StdCtrls, RzLabel, Vcl.Mask,
  RzEdit, Utilities, DataServices, RzRadChk, FireDAC.Comp.Client, Settings;

type
  TfmLoginDetails = class(TfmBaseModalForm)
    RzGroupBox1: TRzGroupBox;
    RzLabel3: TRzLabel;
    RzLabel5: TRzLabel;
    RzLabel6: TRzLabel;
    ebEMDBUsername: TRzEdit;
    ebEMDBPassword: TRzEdit;
    ebEMDBHost: TRzEdit;
    ebEMDBDatabasename: TRzEdit;
    RzLabel1: TRzLabel;
    ckbWindowsAuth: TRzCheckBox;
    procedure FormShow(Sender: TObject);
    procedure ckbWindowsAuthClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetPreviousLogin;
    procedure SetPreviousLogin;
    procedure SetWindowsLogin(AWindowsLogin: Boolean);
    function ConnectionOK: Boolean;
   protected
    { Protected declarations }
    function RaiseOKError: Boolean; override;
    function RaiseCancelError: Boolean; override;
    function CanOK: Integer; override;
    function CanCancel: Boolean; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

constructor TfmLoginDetails.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GetPreviousLogin;
end;

procedure TfmLoginDetails.GetPreviousLogin;
begin
  ebEMDBHost.Text := TUtilities.GetFormKey('LoginDetail', 'Host');
  ebEMDBDatabasename.Text := TUtilities.GetFormKey('LoginDetail', 'DBName');
  ebEMDBUsername.Text := TUtilities.GetFormKey('LoginDetail', 'UserName');
  ckbWindowsAuth.Checked := (1 = TUtilities.GetIntegerFormKey('LoginDetail', 'UseWindowsAuth'));
end;

procedure TfmLoginDetails.SetPreviousLogin;
begin
  TUtilities.SetFormKey('LoginDetail', 'Host', ebEMDBHost.Text);
  TUtilities.SetFormKey('LoginDetail', 'DBName', ebEMDBDatabasename.Text);
  TUtilities.SetFormKey('LoginDetail', 'UserName', ebEMDBUsername.Text);
  if ckbWindowsAuth.Checked then
    TUtilities.SetIntegerFormKey('LoginDetail', 'UseWindowsAuth', 1)
  else
    TUtilities.SetIntegerFormKey('LoginDetail', 'UseWindowsAuth', 0);
end;

procedure TfmLoginDetails.SetWindowsLogin(AWindowsLogin: Boolean);
begin
  if AWindowsLogin then
  begin
    ebEMDBUsername.Text := String.Format('%s\%s', [TUtilities.GetLoggedInDomain, TUtilities.GetLoggedInUserName]);
    ebEMDBPassword.Text := String.Empty;
  end;
  ebEMDBUsername.Enabled := not AWindowsLogin;
  ebEMDBPassword.Enabled := not AWindowsLogin;
end;

function TfmLoginDetails.ConnectionOK: Boolean;
begin
  Result := FALSE;
  var LConn := TDataServices.GetConnection(ebEMDBHost.Text, ebEMDBDatabaseName.Text, ebEMDBUsername.Text, ebEMDBPassword.Text, ckbWindowsAuth.Checked);
  try
    try
      LConn.Open;
      LConn.Close;
      Result := TRUE;
    except on E:Exception do
      MessageDlg(String.Format('Connection Error: %s', [E.Message]), mtError, [mbOK], 0);
    end;
  finally
    LConn.Free;
  end;
end;

function TfmLoginDetails.RaiseOKError: Boolean;
begin
  Result := (mrYes = MessageDlg('Are you sure you wish to leave the password blank?', mtConfirmation, [mbYes, mbNo], 0));
end;

function TfmLoginDetails.RaiseCancelError: Boolean;
begin
  Result := TRUE;
end;

function TfmLoginDetails.CanOK: Integer;
begin
  Result := 0;

  if '' = Trim(ebEMDBHost.Text) then
  begin
    MessageDlg('EMDB Host cannot be empty.', mtError, [mbOK], 0);
    EXIT;
  end;

  if '' = Trim(ebEMDBDatabaseName.Text) then
  begin
    Result := -1;
    EXIT;
  end;

  if '' = Trim(ebEMDBUsername.Text) then
  begin
    MessageDlg('EMDB User Name cannot be empty.', mtError, [mbOK], 0);
    EXIT;
  end;

  if '' = Trim(ebEMDBPassword.Text) then
  begin
    Result := -1;
    EXIT;
  end;
  if ConnectionOK then
  begin
    TSettings.Settings.Host :=  Trim(ebEMDBHost.Text);
    TSettings.Settings.Database :=  Trim(ebEMDBDatabaseName.Text);
    TSettings.Settings.UserName :=  Trim(ebEMDBUsername.Text);
    TSettings.Settings.Password :=  Trim(ebEMDBPassword.Text);
    SetPreviousLogin;
    Result := 1;
  end else
    Result := -1;

end;

function TfmLoginDetails.CanCancel: Boolean;
begin
  Result := TRUE;
end;

procedure TfmLoginDetails.FormShow(Sender: TObject);
begin
  inherited;
  var LDBName := ebEMDBDatabaseName.Text;
  if String.IsNullOrWhiteSpace(LDBName) then
    ebEMDBDatabaseName.Text := 'LogRhythmEMDB';

  var LUserName := ebEMDBUsername.Text;
  if String.IsNullOrWhiteSpace(LUserName) then
    ebEMDBHost.SetFocus
  else
    ebEMDBPassword.SetFocus;
end;

procedure TfmLoginDetails.ckbWindowsAuthClick(Sender: TObject);
begin
  inherited;
  SetWindowsLogin(ckbWindowsAuth.Checked);
end;

end.
