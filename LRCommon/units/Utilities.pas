{*******************************************************}
{                                                       }
{      Copyright(c) 2003-2016 Oamaru Group , Inc.       }
{                                                       }
{   Copyright and license exceptions noted in source    }
{                                                       }
{*******************************************************}
unit Utilities;

interface

uses
  System.SysUtils, System.Classes, WinApi.Windows, WinApi.Messages, WinApi.ShlObj,
  System.Win.Registry, WinApi.Winsock, System.DateUtils, System.TimeSpan, IdWship6,
  IdWinsock2;

const
{$IFDEF LRTOOLS}
  APP_NAME            = 'LRTools';
{$ENDIF}

 NI_MAXHOST =	1025;
 NI_MAXSERV	= 32;
type
  PVarInt32 = ^TVarInt32;
  TVarInt32 = packed record
    case Word of
      0 : (I32 : Int32);
      1 : (B0, B1, B2, B3:byte);
      2 : (W0, W1:WORD);
      3 : (DW0: DWORD);
  end;

  TVarUInt32 = packed record
     case Word of
      0 : (I32 : UInt32);
      1 : (B0, B1, B2, B3:byte);
      2 : (W0, W1:WORD);
      3 : (DW0: DWORD);
  end;

  PVarInt64 = ^TVarInt64;
  TVarInt64 = packed record
    case Word of
      0 : (I64: Int64);
      1 : (B0, B1, B2, B3, B4, B5, B6, B7: Byte);
      2 : (DW0, DW1: DWORD);
      3 : (W0, W1, W2, W3: WORD);
  end;

  TUtilities = class
    private
      class function GetSpecialFolder(FolderID : DWORD) : String;
    public
      class function GetLoggedInUserName: String;
      class function GetLoggedInDomain: String;
      class function GetSID(var UserName, DomainName:String): String;
      class function SIDToStr(Input:PSID):string;
      class function GetFileSize(const AFileName: string): Int64;
      class function GetFileCreationTime(const AFileName: String): TDateTime;
      class function GetFileLastWriteTime(const AFileName: String): TDateTime;
      class function MyDocumentsDir: String;
      class function AppDataDir: String;
      class function AppDataDirNonRoaming: String;
      class function CommonAppDataDir: String;
      class function GetFormKey(AFormName, AValueName: String): String;
      class function GetIntegerFormKey(AFormName, AValueName: String): Integer;
      class function SetFormKey(AFormName, AValueName, AValue: String): Boolean;
      class function SetIntegerFormKey(AFormName, AValueName: String; AValue: Integer): Boolean;
      class function MemoryUsed: Cardinal;
      class function DottedQuadToUInt32(ADottedQuadAddress: String): UInt32;
      class function UInt32ToDottedQuad(AUInt32Address: UInt32): String;
      class function HostToNetworkByteOrder(AUInt32Address: UInt32): UInt32;
      class function NetworkToHostByteOrder(AUInt32Address: UInt32): UInt32;
      class function ConvertDateTimeString(const ADateTimeString: String): TDateTime;
      class function GetFileModDate(AFileName: String) : TDateTime;
      class function ByteArrayToSidString(AByteArray: array of Byte; ArrayLength: Integer): String;
      class function BytesToSidString(AByteArray: array of Byte; ArrayLength: Integer): String;
      class function StreamToSidString(AStream: TStream): String;
      class function IsAlpha(const AChar: Char): Boolean;
      class function IsNumeric(const AChar: Char): Boolean;
      class function IsAlphaNumeric(const AChar: Char): Boolean;
      class function ExtractAlphaNumericStr(var VString : String) : String;
      class function GetVersionInfo(const AFileName: String; var AMajorVersion: Integer; var AMinorVersion: Integer;  var AReleaseVersion: Integer; var ABuildNumber: Integer): Boolean;
      class function GetLocalMachineName: String;
      class function GetMachineGUID: String;
      class function ISOTimestampStringToDateTime(AValue: String): TDateTime;
      class function ISOTimestampStringToOffset(AValue: String): TTimeSpan;
      class function DateTimeToISOTimestampString(ADateTime: TDateTime): String; overload;
      class function DateTimeToISOTimestampString(ADateTime: TDateTime; ATimeSpan: TTimeSpan): String; overload;
      class function IntToStrWithSeperators(AValue: Int64): String;
      class function GetFullyQualifiedDomainName(AIPAddress: String): String;
  end;

implementation

class function TUtilities.GetLoggedInUserName: String;
var
  pNameBuff: PChar;
  dwNameBuffSize: DWORD;
begin
  dwNameBuffSize := 0;
  GetUserName(nil, dwNameBuffSize);
  if ERROR_INSUFFICIENT_BUFFER = GetLastError then
  begin
    GetMem(pNameBuff, dwNameBuffSize * Sizeof(Char));
    try
      if GetUserName(pNameBuff, dwNameBuffSize) then
        Result := String(pNameBuff)
      else
        RaiseLastOSError;
    finally
      FreeMem(pNameBuff);
    end;
  end
  else
    RaiseLastOSError;
end;

class function TUtilities.GetLoggedInDomain: String;
var
  SNU                : SID_NAME_USE;
  SID                : PSID;
  dwSidSize          : DWORD;
  pNameBuff          : array[0..80] of Char;
  dwNameBuffSize     : DWORD;
  pComputerBuff      : array[0..80] of Char;
  dwComputerBuffSize : DWORD;
  pRefDomain         : PChar;
  dwRefDomainSize    : DWORD;
begin
  SID := nil;
  //Get User Name
  dwNameBuffSize := Sizeof(pNameBuff);
  GetUserName(pNameBuff,dwNameBuffSize);
  //Get Computer Name
  dwComputerBuffSize := Sizeof(pComputerBuff);
  GetComputerName(pComputerBuff,dwComputerBuffSize);

  dwSidSize:=0; //Makes LookupAccountNameFail
                //When it fails with ERROR_INSUFFICIENT_BUFFER
                //it load dwSidSize with the correct buffer size
  dwRefDomainSize := SizeOf(pRefDomain);

  //Do the first lookup with an undersized sid buffer
  pRefDomain := nil;
  LookupAccountName(pComputerBuff,pNameBuff,SID,dwSidSize,pRefDomain,dwRefDomainSize,SNU);

  //Raise error if it is other than undersized buffer error we are expecting
  if GetLastError <> ERROR_INSUFFICIENT_BUFFER then RaiseLastOSError;

  GetMem(SID,dwSidSize);//Allocate memory for Sid
  GetMem(pRefDomain,(dwRefDomainSize * 2));

  //Do lookup again with correct account name
  if not LookupAccountName(pComputerBuff,pNameBuff,SID,dwSidSize,pRefDomain,dwRefDomainSize,SNU) then
    RaiseLastOSError
  else begin
    Result := String(pRefDomain);
  end;
  FreeMem(SID);//free up memory used for SID
  FreeMem(pRefDomain)
end;

class function TUtilities.GetSID(var UserName, DomainName:String):String;
var
  SNU                : SID_NAME_USE;
  SID                : PSID;
  dwSidSize          : DWORD;
  pNameBuff          : array[0..80] of Char;
  dwNameBuffSize     : DWORD;
  pComputerBuff      : array[0..80] of Char;
  dwComputerBuffSize : DWORD;
  pRefDomain         : PChar;
  dwRefDomainSize    : DWORD;
begin
  SID := nil;
  //Get User Name
  dwNameBuffSize := Sizeof(pNameBuff);
  GetUserName(pNameBuff,dwNameBuffSize);
  UserName := String(pNameBuff);
  //Get Computer Name
  dwComputerBuffSize := Sizeof(pComputerBuff);
  GetComputerName(pComputerBuff,dwComputerBuffSize);

  dwSidSize:=0; //Makes LookupAccountNameFail
                //When it fails with ERROR_INSUFFICIENT_BUFFER
                //it load dwSidSize with the correct buffer size
  dwRefDomainSize := SizeOf(pRefDomain);

  //Do the first lookup with an undersized sid buffer
  pRefDomain := nil;
  LookupAccountName(pComputerBuff,pNameBuff,SID,dwSidSize,pRefDomain,dwRefDomainSize,SNU);

  //Raise error if it is other than undersized buffer error we are expecting
  if GetLastError <> ERROR_INSUFFICIENT_BUFFER then RaiseLastOSError;

  GetMem(SID,dwSidSize);//Allocate memory for Sid
  GetMem(pRefDomain,(dwRefDomainSize * 2));

  //Do lookup again with correct account name
  if not LookupAccountName(pComputerBuff,pNameBuff,SID,dwSidSize,pRefDomain,dwRefDomainSize,SNU) then
    RaiseLastOSError
  else begin
    DomainName := String(pRefDomain);
    Result:=SIDToStr(SID);
  end;
  FreeMem(SID);//free up memory used for SID
  FreeMem(pRefDomain)
end;

class function TUtilities.SIDToStr(Input:PSID):string;
var
  psia             : PSIDIdentifierAuthority;
  dwSubAuthorities : DWORD;
  dwSidRev         : DWORD;
  dwCounter        : DWORD;
begin
  dwSidRev :=1;// SID_REVISION;
  if IsValidSid(Input) then
  begin
    psia:=GetSidIdentifierAuthority(Input);
    dwSubAuthorities:=GetSidSubAuthorityCount(Input)^;
    Result:=Format('S-%u-',[dwSidRev]);
    if (psia^.Value[0] <> 0) or (psia^.Value[1] <> 0) then
      Result:=Result + Format('0x%02x%02x%02x%02x%02x%02x',[psia^.Value[0],psia^.Value [1],psia^.Value [2],psia^.Value [3],psia^.Value[4],psia^.Value [5]])
    else
      Result:=Result+Format('%u',[DWORD (psia^.Value [5])+DWORD (psia^.Value [4] shl 8)+DWORD (psia^.Value [3] shl 16)+DWORD (psia^.Value [2] shl 24)]);
    for dwCounter := 0 to dwSubAuthorities - 1 do
      Result:=Result+Format ('-%u', [GetSidSubAuthority(Input,dwCounter)^])
  end else
  begin
    Result:='NULL';
    raise Exception.Create ('Invalid Security ID Exception');
  end;
end;

class function TUtilities.GetFileSize(const AFileName: String): Int64;
var
  AttributeData: TWin32FileAttributeData;
begin
  Result := -1;
  if GetFileAttributesEx(PChar(AFileName), GetFileExInfoStandard, @AttributeData) then
  begin
    Int64Rec(Result).Lo := AttributeData.nFileSizeLow;
    Int64Rec(Result).Hi := AttributeData.nFileSizeHigh;
  end;
end;

class function TUtilities.GetFileCreationTime(const AFileName: String): TDateTime;
var
  AttributeData: TWin32FileAttributeData;
  LLocalTime: TFileTime;
  LDOSTime: Integer;
begin
  Result := -1.00;
  if GetFileAttributesEx(PChar(AFileName), GetFileExInfoStandard, @AttributeData) then
  begin
    FileTimeToLocalFileTime(AttributeData.ftCreationTime, LLocalTime);
    FileTimeToDosDateTime(LLocalTime, LongRec(LDOSTime).Hi, LongRec(LDOSTime).Lo);
    FileDateToDateTime( LDOSTime );
  end;
end;

class function TUtilities.GetFileLastWriteTime(const AFileName: String): TDateTime;
var
  AttributeData: TWin32FileAttributeData;
  LLocalTime: TFileTime;
  LDOSTime: Integer;
begin
  Result := -1.00;
  if GetFileAttributesEx(PChar(AFileName), GetFileExInfoStandard, @AttributeData) then
  begin
    FileTimeToLocalFileTime(AttributeData.ftLastWriteTime, LLocalTime);
    FileTimeToDosDateTime(LLocalTime, LongRec(LDOSTime).Hi, LongRec(LDOSTime).Lo);
    FileDateToDateTime( LDOSTime );
  end;
end;

class function TUtilities.GetSpecialFolder(FolderID : DWORD) : String;
var
 Path : PChar;
 idList : PItemIDList;
begin
  GetMem(Path, (2 * MAX_PATH));
  try
    SHGetSpecialFolderLocation(0, FolderID, idList);
    SHGetPathFromIDList(idList, Path);
    Result := String(Path);
  finally
    FreeMem(Path);
  end;
end;

class function TUtilities.MyDocumentsDir: String;
begin
  Result := ExcludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_PERSONAL));
end;

class function TUtilities.AppDataDir: String;
begin
  Result := ExcludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_APPDATA));
end;

class function TUtilities.AppDataDirNonRoaming: String;
begin
  Result := ExcludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_LOCAL_APPDATA));
end;

class function TUtilities.CommonAppDataDir: String;
begin
  Result := ExcludeTrailingPathDelimiter(GetSpecialFolder(CSIDL_COMMON_APPDATA));
end;

class function TUtilities.GetFormKey(AFormName, AValueName: String): String;
var
  LReg: TRegistry;
begin
  Result := '';
  LReg := TRegistry.Create(KEY_READ);
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKey('Software\Bastard\' + APP_NAME + '\' + AFormName, FALSE) then
    begin
      if LReg.ValueExists(AValueName) then
        Result := LReg.ReadString(AValueName);
      LReg.CloseKey;
    end;
  finally
    LReg.Free;
  end;
end;

class function TUtilities.GetIntegerFormKey(AFormName, AValueName: String): Integer;
var
  LReg: TRegistry;
begin
  Result := 0;
  LReg := TRegistry.Create(KEY_READ);
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKey('Software\Bastard\' + APP_NAME + '\' + AFormName, FALSE) then
    begin
      if LReg.ValueExists(AValueName) then
        Result := LReg.ReadInteger(AValueName);
      LReg.CloseKey;
    end;
  finally
    LReg.Free;
  end;
end;

class function TUtilities.SetFormKey(AFormName, AValueName, AValue: String): Boolean;
var
  LReg: TRegistry;
begin
  Result := FALSE;
  LReg := Tregistry.Create;
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKey('Software\Bastard\' + APP_NAME + '\' + AFormName, TRUE) then
    begin
      LReg.WriteString(AValueName, AValue);
      LReg.CloseKey;
      Result := TRUE;
    end;
  finally
    LReg.Free;
  end;
end;

class function TUtilities.SetIntegerFormKey(AFormName, AValueName: String; AValue: Integer): Boolean;
var
  LReg: TRegistry;
begin
  Result := FALSE;
  LReg := Tregistry.Create;
  try
    LReg.RootKey := HKEY_CURRENT_USER;
    if LReg.OpenKey('Software\Bastard\' + APP_NAME + '\' + AFormName, TRUE) then
    begin
      LReg.WriteInteger(AValueName, AValue);
      LReg.CloseKey;
      Result := TRUE;
    end;
  finally
    LReg.Free;
  end;
end;

class function TUtilities.MemoryUsed: Cardinal;
var
  st: TMemoryManagerState;
  sb: TSmallBlockTypeState;
begin
  GetMemoryManagerState(st);
  Result := st.TotalAllocatedMediumBlockSize + st.TotalAllocatedLargeBlockSize;
  for sb in st.SmallBlockTypeStates do begin
    Result := Result + sb.UseableBlockSize * sb.AllocatedBlockCount;
  end;
end;

class function TUtilities.DottedQuadToUInt32(ADottedQuadAddress: String): UInt32;
var
  LStrings: TStringList;
  LIPInt: TVarUInt32;
begin
  Result := 0;
  LStrings := TStringList.Create;
  try
    LStrings.Delimiter := '.';
    LStrings.StrictDelimiter := TRUE;
    LStrings.DelimitedText := ADottedQuadAddress;
    if 4 <> LStrings.Count then
      raise EArgumentException.Create('Invalid dotted quad address');
    LIPInt.B3 := StrToInt(LStrings[0]);
    LIPInt.B2 := StrToInt(LStrings[1]);
    LIPInt.B1 := StrToInt(LStrings[2]);
    LIPInt.B0 := StrToInt(LStrings[3]);
    Result := LIPInt.I32;
  finally
    LStrings.Free;
  end;
end;

class function TUtilities.UInt32ToDottedQuad(AUInt32Address: UInt32): String;
var
  LIPInt: TVarUInt32;
begin
  LIPInt.I32 := AUInt32Address;
  Result := Format('%d.%d.%d.%d', [LIPInt.B3, LIPInt.B2, LIPInt.B1, LIPInt.B0]);
end;

class function TUtilities.HostToNetworkByteOrder(AUInt32Address: UInt32): UInt32;
begin
  Result := htonl(AUInt32Address);
end;

class function TUtilities.NetworkToHostByteOrder(AUInt32Address: UInt32): UInt32;
begin
  Result := ntohl(AUInt32Address);
end;

//Expected Fornmat = YYYY-MMM-DD hh:nn:ss
class function TUtilities.ConvertDateTimeString(const ADateTimeString: String): TDateTime;
var
  LYear, LMonth, LDay, LHour, LMinute, LSecond: Integer;
  LMonthStr: String;
begin
  LYear := StrToInt(Copy(ADateTimeString, 1, 4));
  LMonthStr := UpperCase(Copy(ADateTimeString, 6, 3));
  LMonth := 0;
  if 'JAN' = LMonthStr then
    LMonth := 1
  else if 'FEB' = LMonthStr then
    LMonth := 2
  else if 'MAR' = LMonthStr then
    LMonth := 3
  else if 'APR' = LMonthStr then
    LMonth := 4
  else if 'MAY' = LMonthStr then
    LMonth := 5
  else if 'JUN' = LMonthStr then
    LMonth := 6
  else if 'JUL' = LMonthStr then
    LMonth := 7
  else if 'AUG' = LMonthStr then
    LMonth := 8
  else if 'SEP' = LMonthStr then
    LMonth := 9
  else if 'OCT' = LMonthStr then
    LMonth := 10
  else if 'NOV' = LMonthStr then
    LMonth := 11
  else if 'DEC' = LMonthStr then
    LMonth := 12;
  LDay := StrToInt(Copy(ADateTimeString, 10, 2));
  LHour := StrToInt(Copy(ADateTimeString, 13, 2));
  LMinute := StrToInt(Copy(ADateTimeString, 16, 2));
  LSecond := StrToInt(Copy(ADateTimeString, 19, 2));
  Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMinute, LSecond, 0);
end;

class function TUtilities.GetFileModDate(AFileName: String) : TDateTime;
var
   F : TSearchRec;
begin
   FindFirst(AFileName, faAnyFile, F);
   try
     Result := F.TimeStamp;
     //if you really wanted an Int, change the return type and use this line:
     //Result := F.Time;
   finally
     System.SysUtils.FindClose(F);
   end;
end;

class function TUtilities.ByteArrayToSidString(AByteArray: array of Byte; ArrayLength: Integer): String;
begin
  Result := '';
  if 0 = ArrayLength then
    EXIT;
  if (AByteArray[0] <> 0) or (AByteArray[1] <> 0) then
    Result:=Result + Format('0x%02x%02x%02x%02x%02x%02x',[AByteArray[0], AByteArray[1], AByteArray[2], AByteArray[3], AByteArray[4], AByteArray[5]])
  else
    Result:=Result + Format('%u',[DWORD(AByteArray[5])+ DWORD(AByteArray[4] shl 8)+ DWORD(AByteArray[3] shl 16) + DWORD (AByteArray[2] shl 24)]);
end;

class function TUtilities.BytesToSidString(AByteArray: array of Byte; ArrayLength: Integer): String;
var
  LDashes: Integer;
  L64: TVarInt64;
  L32: TVarUInt32;
  i: INteger;
begin
  if 0 = ArrayLength then
    EXIT;
  i := 0;
  Result := Format('S-%d', [AByteArray[i]]);
  Inc(i);
  LDashes := (AByteArray[i] + 2) - 1;
  Inc(i);
  L64.B7 := 0;
  L64.B6 := 0;
  L64.B5 := AByteArray[i];
  Inc(i);
  L64.B4 := AByteArray[i];
  Inc(i);
  L64.B3 := AByteArray[i];
  Inc(i);
  L64.B2 := AByteArray[i];
  Inc(i);
  L64.B1 := AByteArray[i];
  Inc(i);
  L64.B0 := AByteArray[i];
  Inc(i);
  Dec(LDashes);
  Result := Format('%s-%d', [Result, L64.I64]);
  if 0 = LDashes then
    Exit;
  while (i < ArrayLength) and (0 <> LDashes) do
  begin
    L32.B0 := AByteArray[i];
    Inc(i);
    L32.B1 := AByteArray[i];
    Inc(i);
    L32.B2 := AByteArray[i];
    Inc(i);
    L32.B3 := AByteArray[i];
    Inc(i);
    Result := Format('%s-%d', [Result, L32.I32]);
    Dec(LDashes);
  end;
end;

class function TUtilities.StreamToSidString(AStream: TStream): String;
var
  LDashes: Integer;
  L64: TVarInt64;
  L32: TVarUInt32;
  LRead: Integer;
  LBuff: Byte;
begin
  if 0 = AStream.Size then
    EXIT;
  LRead := 0;
  LRead := LRead + AStream.Read(LBuff, 1);
  Result := Format('S-%d', [LBuff]);

  LRead := LRead + AStream.Read(LBuff, 1);
  LDashes := (LBuff + 2) - 1;

  L64.B7 := 0;
  L64.B6 := 0;

  LRead := LRead + AStream.Read(LBuff, 1);
  L64.B5 := LBuff;

  LRead := LRead + AStream.Read(LBuff, 1);
  L64.B4 := LBuff;

  LRead := LRead + AStream.Read(LBuff, 1);
  L64.B3 := LBuff;

  LRead := LRead + AStream.Read(LBuff, 1);
  L64.B2 := LBuff;

  LRead := LRead + AStream.Read(LBuff, 1);
  L64.B1 := LBuff;

  LRead := LRead + AStream.Read(LBuff, 1);
  L64.B0 := LBuff;

  Dec(LDashes);
  Result := Format('%s-%d', [Result, L64.I64]);
  if 0 = LDashes then
    Exit;
  while (LRead < AStream.Size) and (0 <> LDashes) do
  begin
    LRead := LRead + AStream.Read(LBuff, 1);
    L32.B0 := LBuff;

    LRead := LRead + AStream.Read(LBuff, 1);
    L32.B1 := LBuff;

    LRead := LRead + AStream.Read(LBuff, 1);
    L32.B2 := LBuff;

    LRead := LRead + AStream.Read(LBuff, 1);
    L32.B3 := LBuff;

    Result := Format('%s-%d', [Result, L32.I32]);
    Dec(LDashes);
  end;
end;

class function TUtilities.IsAlpha(const AChar: Char): Boolean;
begin
    // Do not use IsCharAlpha or IsCharAlphaNumeric - they are Win32 routines
  Result := ((AChar >= 'a') and (AChar <= 'z')) or ((AChar >= 'A') and (AChar <= 'Z')) or (AChar = '-'); {Do not Localize}
end;

class function TUtilities.IsNumeric(const AChar: Char): Boolean;
begin
  // Do not use IsCharAlpha or IsCharAlphaNumeric - they are Win32 routines
  Result := (AChar >= '0') and (AChar <= '9'); {Do not Localize}
end;

class function TUtilities.IsAlphaNumeric(const AChar: Char): Boolean;
begin
  Result := IsAlpha(AChar) or IsNumeric(AChar);
end;

class function TUtilities.ExtractAlphaNumericStr(var VString : String) : String;
var
  i, len : Integer;
begin
  len := 0;
  for i := 1 to Length(VString) do
  begin
    //numbers or alphabet only
    if IsAlphaNumeric(VString[i]) then
    begin
      Inc(len);
    end else
    begin
      BREAK;
    end;
  end;
  Result := Copy(VString, 1, len);
  VString := Copy(VString, len+1, MaxInt);
end;

class function TUtilities.GetVersionInfo(const AFileName: String; var AMajorVersion: Integer; var AMinorVersion: Integer;  var AReleaseVersion: Integer; var ABuildNumber: Integer): Boolean;
var
  VerInfoSize:  DWORD;
  VerInfo:      Pointer;
  VerValueSize: DWORD;
  VerValue:     PVSFixedFileInfo;
  Dummy:        DWORD;
begin
  Result := FALSE;
  AMajorVersion := 0;
  AMinorVersion := 0;
  AReleaseVersion := 0;
  ABuildNumber := 0;
  VerInfoSize := GetFileVersionInfoSize(PChar(AFileName), Dummy);
  GetMem(VerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(PChar(AFileName)), 0, VerInfoSize, VerInfo) then
    begin
      if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
      begin
        with VerValue^ do
        begin
          AMajorVersion := (dwFileVersionMS shr 16);
          AMinorVersion := (dwFileVersionMS and $FFFF);
          AReleaseVersion := (dwFileVersionLS shr 16);
          ABuildNumber := (dwFileVersionLS and $FFFF);
          Result := TRUE;
        end;
      end;
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

class function TUtilities.GetLocalMachineName: String;
var
  LBuffer: PChar;
  LBufferLen: DWORD;
begin
  LBufferLen := 0;
  GetComputerName(nil, LBufferLen);
  if ERROR_BUFFER_OVERFLOW = GetLastError then
  begin
    GetMem(LBuffer, (LBufferLen + 1) * SizeOf(Char));
    try
      GetComputerName(LBuffer, LBufferLen);
      Result := String(LBuffer);
    finally
      FreeMem(LBuffer);
    end;
  end;
end;

class function TUtilities.GetMachineGUID: String;
var
  LReg: TRegistry;
begin
  Result := String.Empty;
  LReg := TRegistry.Create(KEY_READ);
  try
    LReg.RootKey := HKEY_LOCAL_MACHINE;
    if LReg.OpenKey('SOFTWARE\Microsoft\Cryptography', FALSE) then
    begin
      if LReg.ValueExists('MachineGuid') then
        Result := LReg.ReadString('MachineGuid');
      LReg.CloseKey;
    end;
  finally
    LReg.Free;
  end;
end;

class function TUtilities.ISOTimestampStringToDateTime(AValue: String): TDateTime;
var
  LYear, LMonth, LDay, LHour, LMin, LSec, LMSec: WORD;
  LSecFrac: String;
  i: Integer;
begin
  //2003-08-24T05:14:15.000003-07:00
  //Now Convert The TimeStamp
  LYear := StrToInt(Copy(AValue, 1, 4));
  LMonth := StrToInt(Copy(AValue, 6, 2));
  LDay := StrToInt(Copy(AValue, 9, 2));
  LHour := StrToInt(Copy(AValue, 12, 2));
  LMin := StrToInt(Copy(AValue, 15, 2));
  LSec := StrToInt(Copy(AValue, 18, 2));
  Delete(AValue, 1, 19);
  if AValue[1] = '.' then
    Delete(AValue, 1, 1);

  LSecFrac := '';
  i := 1;
  while TUtilities.IsNumeric(AValue[i]) do
  begin
    LSecFrac := LSecFrac + AValue[i];
    Inc(i);
  end;

  case Length(LSecFrac) of
   0: LMsec := 0;
   1: LMSec := StrToInt(LSecFrac) * 100;
   2: LMSec := StrToInt(LSecFrac) * 10;
  else
    LMSec := StrToInt(Copy(LSecFrac, 1, 3));
  end;

  Delete(AValue, 1, Length(LSecFrac));
  Result := EncodeDateTime(LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
end;

class function TUtilities.ISOTimestampStringToOffset(AValue: String): TTimeSpan;
var
  LOffsetHours, LOffsetMin: Integer;
begin
  if  'Z' = AValue[Length(AValue)] then
  begin
    Result := TTimeSpan.Create(0);
    EXIT;
  end;
  Delete(AValue, 1, 20);

  Delete(AValue, 1, Pos('-', AValue) - 1);
  LOffsetHours := StrToInt(Copy(AValue, 2, 2));
  LOffsetMin := StrToInt(Copy(AValue, 5, 2));
  if AValue[1] = '-' then
  begin
    LOffsetHours := (0 - LOffsetHours);
    LOffsetMin := (0 - LOffsetMin);
  end;
  Result := TTimeSpan.Create(0, LOffsetHours, LOffsetMin, 0, 0);
end;

class function TUtilities.DateTimeToISOTimestampString(ADateTime: TDateTime): String;
var
  LYear, LMonth, LDay, LHour, LMin, LSec, LMSec: WORD;
begin
  DecodeDateTime(ADateTime, LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  Result := String.Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.3dZ', [LYear, LMonth, LDay, LHour, LMin, LSec, LMSec]);
end;

class function TUtilities.DateTimeToISOTimestampString(ADateTime: TDateTime; ATimeSpan: TTimeSpan): String;
var
  LYear, LMonth, LDay, LHour, LMin, LSec, LMSec: WORD;
  LOperator: String;
begin
  DecodeDateTime(ADateTime, LYear, LMonth, LDay, LHour, LMin, LSec, LMSec);
  if 0 = ATimeSpan.Ticks then
    Result := String.Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.3dZ', [LYear, LMonth, LDay, LHour, LMin, LSec, LMSec])
  else
  begin
    if ATimeSpan.Ticks < 0 then
      LOperator := '-'
    else
      LOperator := '+';
    Result := String.Format('%.4d-%.2d-%.2dT%.2d:%.2d:%.2d.%.3d%s%.2d:%.2d', [LYear, LMonth, LDay, LHour, LMin, LSec, LMSec, LOperator, Abs(ATimeSpan.Hours), Abs(ATimeSpan.Minutes)]);
  end;
end;

class function TUtilities.IntToStrWithSeperators(AValue: Int64): String;
var
  LStr: String;
  i: Integer;
begin
  Result := '';
  LStr := IntToStr(AValue);
  for i := Length(LStr) downto 1 do
  begin
    Result :=  LStr[i] + Result;
    if (0 = (i mod 3)) and (i <> 1) then
      Result :=  ',' + Result;
  end;
end;

class function TUtilities.GetFullyQualifiedDomainName(AIPAddress: String): String;
const
  LPort = 27015;
var
  LWsaData: WinApi.Winsock.TWSAData;
  LResult: Integer;
  LHostAddress : IdWinsock2.PSockAddr;
  LHostName: array [0..(NI_MAXHOST - 1)] of Char;
  LServInfo: array [0..(NI_MAXSERV - 1)] of Char;
  LErr: DWord;
begin
  Result := '';
  FillChar(LHostName, Sizeof(LHostName), 0);
  FillChar(LServInfo, Sizeof(LServInfo), 0);
  LResult := WinApi.Winsock.WsaStartup(MAKEWORD(2,2), LWsaData);
  if (0 <> LResult) then
  begin
    case LResult of
      WSASYSNOTREADY: raise Exception.Create('WSAStartup returned WSASYSNOTREADY: The underlying network subsystem is not ready for network communication.');
      WSAVERNOTSUPPORTED: raise Exception.Create('WSAStartup returned WSAVERNOTSUPPORTED: The version of Windows Sockets support requested (2.2) is not provided by this particular Windows Sockets implementation.');
      WSAEINPROGRESS: raise Exception.Create('WSAStartup returned WSAEINPROGRESS: A blocking Windows Sockets 1.1 operation is in progress.');
      WSAEPROCLIM: raise Exception.Create('WSAStartup returned WSAEPROCLIM: A limit on the number of tasks supported by the Windows Sockets implementation has been reached.');
      WSAEFAULT: raise Exception.Create('WSAStartup returned WSASYSNOTREADY: The data parameter is not a valid pointer.');
    else
      raise Exception.Create(String.Format('WSAStartup returned 0x%.4x: Unknown error.',[LResult]));
    end;
  end;

  GetMem(LHostAddress, SizeOf(IdWinsock2.TSockAddr));
  try
    LHostAddress^.sin_family := AF_INET;
    LHostAddress^.sin_addr.s_addr := inet_addr(PAnsiChar( AnsiString(AIPAddress) ));
    LHostAddress^.sin_port := htons(LPort);
    LResult := getnameinfo(LHostAddress, SizeOf(TSockAddr), @LHostName, NI_MAXHOST, @LServInfo, NI_MAXSERV, NI_NUMERICSERV);
  finally
    FreeMem(LHostAddress);
  end;
  if 0 = LResult then
  begin
    LErr := 0;
    Result := String(LHostName);
  end else
  begin
    LErr := WSAGetLastError;
  end;
  WinApi.Winsock.WSACleanup;
  if 0 <> LErr then
  begin
    raise Exception.Create(String.Format('getnameinfo returned erro code %d: %s.',[LErr, SysErrorMessage(LErr)]));
  end;
end;

end.
