unit Settings;

interface

uses
  SysUtils, Classes, INIFiles, CryptoAPI;

type
  TSettings = class
    private
      FHost: String;
      FDatabase: String;
      FUserName: String;
      FPassword: String;
      FWindowsAuth: Boolean;
      class var FSettings: TSettings; //Always put class vars at end
    public
      constructor Create; overload; virtual;
      constructor Create(ASettings: TSettings); overload; virtual;
      property Host: String read FHost write FHost;
      property Database: String read FDatabase write FDatabase;
      property UserName: String read FUserName write FUserName;
      property Password: String read FPassword write FPassword;
      property WindowsAuth: Boolean read FWindowsAuth write FWindowsAuth;
      class property Settings: TSettings read FSettings write FSettings;
  end;

implementation

constructor TSettings.Create;
begin
  FHost := String.Empty;
  FDatabase := String.Empty;
  FUserName := String.Empty;
  FPassword := String.Empty;
  FWindowsAuth := FALSE;
end;

constructor TSettings.Create(ASettings: TSettings);
begin
  FHost := String.Empty;
  FDatabase := String.Empty;
  FUserName := String.Empty;
  FPassword := String.Empty;
  FWindowsAuth := FALSE;
  if nil <> ASettings then
  begin
    FHost := ASettings.Host;
    FDatabase := ASettings.Database;
    FUserName := ASettings.UserName;
    FPassword := ASettings.Password;
    FWindowsAuth := ASettings.WindowsAuth;
  end;
end;

initialization
  TSettings.Settings := TSettings.Create;

end.
