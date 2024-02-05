unit CryptoAPI;

interface

uses
  Windows, SysUtils, Classes, EncdDecd, wcrypt2, System.NetEncoding;

const
  LR_KEY_LEN = 64;
  aBaseKey: array [0..34] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

type
  TLRKey = array[0..(LR_KEY_LEN -1)] of Byte;
  TCryptoAPI = Class
  protected
    class function rsaMakeHash(const aHashType:ULONG; const HashBufLen:Integer; const aData:TStream;var aText:String):Boolean;
  public
    class function rsaMakeKeys(var aPrivate,aPublic:TStream):Boolean;
    class function rsaKeyToBase64(const aKey:TStream;var aText:String):Boolean;
    class function rsaBase64ToKey(const aText:String;var aKey:TStream):Boolean;
    class function rsaMakeSHAHash(const aData:TStream;var aText:String):Boolean;
    class function rsaMakeMD5Hash(const aData:TStream;var aText:String):Boolean;
    class function rsaCryptStream(const aKey:TStream;const aSourceStream:TStream; const aTargetStream:TStream):Boolean;
    class function rsaDecryptStream(Const aKey:TStream;const aSourceStream:TStream; const aTargetStream:TStream):Boolean;
    class function aesGetEncryptionKey: TLRKey;
    class function aesEncryptString(const AInput:String; var AOutput: String):Integer;
    class function aesDecryptString(const AInput:String; var AOutput: String):Integer;
  end;

implementation

const
  CNT_RSA_1024BIT_KEY = $04000000;
  CNT_RSA_512BIT_KEY  = $02000000;

class function TCryptoAPI.rsaMakeHash(const aHashType:ULONG; const HashBufLen:Integer; const aData:TStream;var aText:String):Boolean;
var
  mProvider: HCRYPTPROV;
  mHash:  HCRYPTHASH;
  mTotal:   Int64;
  mRead:    Int64;
  mBuffer:  PByte;
  mHashBuffer: packed array[1..512] of byte;
  mHashByteLen:  Integer;
  x:  Integer;
Begin
  setLength(aText,0);
  result:=False;

  if aData<>NIL then
  begin
    if aData.Size>0 then
    begin
      aData.Position:=0;
      if CryptAcquireContext(@mProvider, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT) then
      Begin
        try
          if CryptCreateHash(mProvider,aHashType,0,0,@mHash) then
          begin
            try
              mBuffer:=Allocmem(1024);
              try
                mTotal:=aData.Size;
                repeat
                  mRead:=aData.Read(mBuffer^,SizeOf(mBuffer));
                  if mRead>0 then
                  begin
                    if not CryptHashData(mHash,mBuffer,mRead, 0) then
                    break;
                  end;
                  mTotal:=mTotal - mRead;
                until mTotal<1;

                mHashByteLen:=HashBufLen;
                if CryptGetHashParam(mHash, HP_HASHVAL, @mHashBuffer, @mHashByteLen, 0) then
                Begin
                  for x:=1 to mHashByteLen do
                  aText:=aText + IntToHex(mHashBuffer[x],2);
                  result:=True;
                end;
              finally
                FreeMem(mbuffer);
              end;
            finally
              CryptDestroyHash(mHash);
            end;
          end;
        finally
          (* Release crypto provider context *)
          CryptReleaseContext(mProvider, 0);
        end;
      end;
    end;
  end;
end;

class function TCryptoAPI.aesGetEncryptionKey: TLRKey;
const
  v1 = 587;
	v2 = 121;
	v3 = 923;
	s0 = v1 + v2 + v3;
var
  i, LPos: Integer;
  LResultPointer: PByte;
begin
  LPos := 0;

	for i := 0 to 24 do
	begin
		if 0 = (i mod 2) then
    begin
      Result[LPos] := Byte(s0 + i + v1);
    end
		else
    begin
      Result[LPos] := Byte(s0 + i + v2);
    end;
    Inc(LPos);
	end;

  LResultPointer := Pointer(@Result);
  for i := 0 to (LPos -1) do
    Inc(LResultPointer);
  MoveMemory(LResultPointer, @aBaseKey[0], SizeOf(aBaseKey));

	Inc(LPos, Length(aBaseKey));
  for i := LPos to (LR_KEY_LEN - 1) do
  begin
    if 0 = (i mod 2) then
      Result[LPos] := Byte(s0 + i + v3)
     else
       Result[LPos] := Byte(s0 + i + v2);
    Inc(LPos);
  end;

end;

class function TCryptoAPI.rsaMakeMD5Hash(const aData: TStream;
  var aText: String): Boolean;
Begin
  result:=TCryptoAPI.rsaMakeHash(CALG_MD5,16,aData,atext);
end;

class function TCryptoAPI.rsaMakeSHAHash(const aData:TStream;
      var aText:String):Boolean;
Begin
  result:=TCryptoAPI.rsaMakeHash(CALG_SHA1,20,aData,atext);
end;

class function TCryptoAPI.rsaDecryptStream(Const aKey:TStream;
        const aSourceStream:TStream;
        const aTargetStream:TStream):Boolean;
var
  mProvider: HCRYPTPROV;
  key: HCRYPTKEY;
  mTotal:   Int64;
  mRead:    DWord;
  mBuffer:  PByte;
  mPrefetch:  Integer;
  mHash:  HCRYPTHASH;
  mHashBuffer:  PByte;
begin
  result:=False;
  if aKey<>NIL then
  begin
    if aKey.Size>0 then
    begin
      aKey.Position:=0;
      if aSourceStream<>NIl then
      begin
        if atargetStream<>NIl then
        begin
          (* Get crypto-API context *)
          if CryptAcquireContext(@mProvider, nil, nil,
          PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then
          Begin
            try
              (* Create a Hash object *)
              if CryptCreateHash(mProvider, CALG_MD5, 0, 0, @mHash) then
              Begin

                try
                  (* Build the hash based on our key *)
                  mHashBuffer:=Allocmem(1024);
                  try
                    mTotal:=aKey.Size;
                    repeat
                      mRead:=aKey.Read(mHashBuffer^,1024);
                      if mRead>0 then
                      begin
                        if not CryptHashData(mHash,mHashBuffer,mRead,0) then
                        break;
                      end else
                      break;
                      mTotal:=mTotal - mRead;
                    until mTotal<1;

                    (* re-wind source stream *)
                    aSourceStream.Position:=0;

                    (* Derive an ecryption key from our hash *)
                    if CryptDeriveKey(mProvider, CALG_RC4, mHash, 0, @key) then
                    Begin
                      (* Query the prefetch-buffer for the context *)
                      mPrefetch:=1024;
                      if CryptEncrypt(key,0,true,0,NIL,@mPrefetch,mPrefetch) then
                      Begin
                        (* Allocate encryption cache *)
                        mBuffer:=Allocmem(mPrefetch);
                        try
                          mTotal:=aSourceStream.Size;
                          repeat
                            mRead:=aSourceStream.Read(mBuffer^,mPrefetch);
                            mTotal:=mTotal - mRead;
                            if mRead>0 then
                            begin
                              (* Encrypt read buffer *)
                              if not cryptDecrypt(key,0,
                              (mTotal<1),0,
                              mBuffer,@mRead) then
                              RaiseLastOSError;

                              (* Write encrypted buffer to target *)
                              atargetStream.Write(mBuffer^,mRead);
                            end else
                            break;
                          until mTotal<1;

                          (* Re-wind and return *)
                          aTargetStream.position:=0;
                          result:=aTargetStream.size>0;
                        finally
                          freeMem(mBuffer);
                        end;
                      end;
                    end else
                    RaiseLastOSError;
                  finally
                    FreeMem(mHashBuffer);
                  end;
                finally
                  (* Release the hash *)
                  CryptDestroyHash(mHash);
                end;
              end else
              RaiseLastOSError;
            finally
              (* Release crypto provider context *)
              CryptReleaseContext(mProvider, 0);
            end;
          end;
        end;
      end;
    end;
  end;
end;

(* NOTE: aKey here can be anything, not the same as a key-pair (!)
   What you can do is to generate a hash of a password, store that
   hash in a stream - and then use that as the key stream *)
class function TCryptoAPI.rsaCryptStream(const aKey, aSourceStream,
  aTargetStream: TStream): Boolean;
var
  mProvider: HCRYPTPROV;
  key: HCRYPTKEY;
  mTotal:   Int64;
  mRead:    DWord;
  mBuffer:  PByte;
  mPrefetch:  Integer;
  mHash:  HCRYPTHASH;
  mHashBuffer:  PByte;
begin
  result:=False;
  if aKey<>NIL then
  begin
    if aKey.Size>0 then
    begin
      aKey.Position:=0;
      if aSourceStream<>NIl then
      begin
        if atargetStream<>NIl then
        begin
          (* Get crypto-API context *)
          if CryptAcquireContext(@mProvider, nil, nil,
          PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then
          Begin

            try
              (* Create a Hash object *)
              if CryptCreateHash(mProvider, CALG_MD5, 0, 0, @mHash) then
              Begin

                try
                  (* Build the hash based on our key *)
                  mHashBuffer:=Allocmem(1024);
                  try
                    mTotal:=aKey.Size;
                    repeat
                      mRead:=aKey.Read(mHashBuffer^,1024);
                      if mRead>0 then
                      begin
                        if not CryptHashData(mHash,mHashBuffer,mRead,0) then
                        break;
                      end else
                      break;
                      mTotal:=mTotal - mRead;
                    until mTotal<1;

                    (* re-wind source stream *)
                    aSourceStream.Position:=0;

                    (* Derive an ecryption key from our hash *)
                    if CryptDeriveKey(mProvider, CALG_RC4, mHash, 0, @key) then
                    Begin
                      (* Query the prefetch-buffer for the context *)
                      mPrefetch:=1024;
                      if CryptEncrypt(key,0,true,0,NIL,@mPrefetch,mPrefetch) then
                      Begin
                        (* Allocate encryption cache *)
                        mBuffer:=Allocmem(mPrefetch);
                        try
                          mTotal:=aSourceStream.Size;
                          repeat
                            mRead:=aSourceStream.Read(mBuffer^,mPrefetch);
                            mTotal:=mTotal - mRead;
                            if mRead>0 then
                            begin
                              (* Encrypt read buffer *)
                              if not CryptEncrypt(key,0,
                              Bool(mTotal<1),0,
                              mBuffer,@mRead,mRead) then
                              RaiseLastOSError;

                              (* Write encrypted buffer to target *)
                              atargetStream.Write(mBuffer^,mRead);
                            end else
                            break;
                          until mTotal<1;

                          (* Re-wind and return *)
                          aTargetStream.position:=0;
                          result:=aTargetStream.size>0;
                        finally
                          freeMem(mBuffer);
                        end;
                      end;
                    end else
                    RaiseLastOSError;
                  finally
                    FreeMem(mHashBuffer);
                  end;
                finally
                  (* Release the hash *)
                  CryptDestroyHash(mHash);
                end;
              end else
              RaiseLastOSError;
            finally
              (* Release crypto provider context *)
              CryptReleaseContext(mProvider, 0);
            end;
          end;
        end;
      end;
    end;
  end;
end;

class function TCryptoAPI.rsaBase64ToKey(const aText:String;
      var aKey:TStream):Boolean;
var
  mSrc: TStringStream;
  mdst: TmemoryStream;
begin
  result:=False;
  aKey:=NIL;
  if Length(aText)>0 then
  begin
    mSrc:=TStringStream.Create(aText);
    try
      mdst:=TmemoryStream.Create;
      try
        DecodeStream(mSrc,mDst);
      except
        on exception do
        mdst.Free;
      end;

      mDst.Position:=0;
      aKey:=mDSt;
      result:=True;

    finally
      mSrc.Free;
    end;
  end;
end;

class function TCryptoAPI.rsaKeyToBase64(const aKey: TStream;
  var aText: String): Boolean;
var
  mTemp:  TStringStream;
Begin
  setLength(aText,0);
  result:=False;
  if aKey<>NIL then
  begin
    mtemp:=TStringStream.Create;
    try
      aKey.Position:=0;
      encodeStream(aKey,mTemp);
      aText:=mTemp.DataString;
      result:=True;
    finally
      mtemp.Free;
    end;
  end;
end;

class function TCryptoAPI.rsaMakeKeys(var aPrivate,
  aPublic: TStream): Boolean;
var
  mProvider: HCRYPTPROV;
  mKeyPair: HCRYPTKEY;
  buflen: DWORD;
begin
  aPrivate:=NIL;
  aPublic:=NIL;
  result:=False;

  (* Get crypto-API context *)
  if CryptAcquireContext(@mProvider, nil, nil, PROV_RSA_FULL,CRYPT_VERIFYCONTEXT) then
  Begin
    try
      if CryptGenKey(mProvider, AT_KEYEXCHANGE, CNT_RSA_1024BIT_KEY or CRYPT_EXPORTABLE, @mKeyPair) then
      Begin
        try
          (* Query size of private buffer *)
          if CryptExportKey(mKeyPair, 0, PRIVATEKEYBLOB, 0, nil, @buflen) then
          Begin
            (* set private buffer to default size *)
            aPrivate:=TMemoryStream.Create;
            aPrivate.Size:=bufLen;

            (* export private key to buffer *)
            if CryptExportKey(mKeyPair, 0, PRIVATEKEYBLOB, 0,
            PByte(TMemoryStream(aPrivate).Memory), @buflen) then
            Begin

              (* Query size of pubic buffer *)
              if CryptExportKey(mKeyPair, 0, PUBLICKEYBLOB, 0, nil, @buflen) then
              Begin
                (* set public buffer to default size *)
                aPublic:=TMemoryStream.Create;
                aPublic.Size:=bufLen;

                (* export public key to buffer *)
                if CryptExportKey(mKeyPair, 0, PUBLICKEYBLOB, 0,
                PByte(TMemoryStream(aPublic).Memory), @buflen) then
                Begin
                  aPrivate.Position:=0;
                  aPublic.Position:=0;
                  result:=True;
                end else
                begin
                  FreeAndNIL(aPrivate);
                  FreeAndNIL(aPublic);
                  RaiseLastOSError;
                end;
              end;
            end else
            begin
              FreeAndNIL(aPrivate);
              RaiseLastOSError;
            end;
          end;
        finally
          (* Release key-pair *)
          CryptDestroyKey(mKeyPair);
        end;
      end;
    finally
      (* Release crypto provider context *)
      CryptReleaseContext(mProvider, 0);
    end;
  end;
end;

class function TCryptoAPI.aesEncryptString(const AInput:String; var AOutput: String):Integer;
var
  mProvider: HCRYPTPROV;
  mHashPassword: HCRYPTHASH;
  mCryptKey: HCRYPTKEY;
  LDataLen, LBufferLen: DWORD;
  LByteArray: TBytes;
  hshBuff, buff, ptrByte: PByte;
  i: Integer;
  LTest : String;
  LKey: TLRKey;
begin
  Result := 0;
  if CryptAcquireContext(@mProvider, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT)  then
  begin
    try
      if CryptCreateHash( mProvider, CALG_SHA_256, 0, 0, @mHashPassword ) then
      begin
        hshBuff := AllocMem(1024);
        try
          LKey := aesGetEncryptionKey;
          Move(LKey, hshBuff^, Length(LKey));
          if CryptHashData( mHashPassword, hshBuff, Length(LKey), 0 ) then
          begin
            if CryptDeriveKey( mProvider, CALG_AES_256, mHashPassword, CRYPT_CREATE_SALT, @mCryptKey ) then
            begin
              LByteArray:= TEncoding.UTF8.GetBytes(AInput);
              LDataLen := Length(LByteArray);
              if CryptEncrypt(mCryptKey, 0, TRUE, 0, nil, @LDataLen, LDataLen) then
              begin
                buff := AllocMem(LDataLen);
                try
                  ptrByte := buff;
                  for i := 0 to (Length(LByteArray) - 1) do
                  begin
                    ptrByte^ := LByteArray[i];
                    Inc(ptrByte);
                  end;
                  LBufferLen := LDataLen;
                  LDataLen := Length(LByteArray);
                  if CryptEncrypt( mCryptKey, 0, TRUE, 0, buff, @LDataLen, LBufferLen ) then
                  begin
                    SetLength(LByteArray, LBufferLen);
                    ptrByte := buff;
                    for i := 0 to (LBufferLen - 1) do
                    begin
                      LByteArray[i] := ptrByte^;
                      Inc(ptrByte);
                    end;
                    LTest := String(EncodeBase64(LByteArray, Length(LByteArray)));
                    AOutput := LTest;
                  end else
                    Result := GetLastError;
                finally
                  FreeMem(buff);
                end;
              end else
                Result := GetLastError;
              CryptDestroyKey(mCryptKey);
            end;
          end else
            Result := GetLastError;
          if 0 <> mHashPassword then
            CryptDestroyHash(mHashPassword);
        finally
          if hshBuff <> nil then
            FreeMem(hshBuff)
        end;
      end;
    finally
      CryptReleaseContext(mProvider, 0);
    end;
  end else
    Result := GetLastError;
end;

class function TCryptoAPI.aesDecryptString(const AInput:String; var AOutput: String):Integer;
var
  mProvider: HCRYPTPROV;
  mHashPassword: HCRYPTHASH;
  mCryptKey: HCRYPTKEY;
  LDataLen: DWORD;
  LByteArray: TBytes;
  hshBuff, buff, ptrByte: PByte;
  i: Integer;
  LTest : String;
  LKey: TLRKey;
begin
  Result := 0;
  if CryptAcquireContext(@mProvider, nil, nil, PROV_RSA_AES, CRYPT_VERIFYCONTEXT)  then
  begin
    try
      if CryptCreateHash( mProvider, CALG_SHA_256, 0, 0, @mHashPassword ) then
      begin
        hshBuff := AllocMem(1024);
        try
          LKey := aesGetEncryptionKey;
          Move(LKey, hshBuff^, Length(LKey));
          if CryptHashData( mHashPassword, hshBuff, Length(LKey), 0 ) then
          begin
            if CryptDeriveKey( mProvider, CALG_AES_256, mHashPassword, CRYPT_CREATE_SALT, @mCryptKey ) then
            begin
              LByteArray:= DecodeBase64(AInput);
              LDataLen := Length(LByteArray);
              buff := AllocMem(LDataLen);
              try
                ptrByte := buff;
                for i := 0 to (Length(LByteArray) - 1) do
                begin
                  ptrByte^ := LByteArray[i];
                  Inc(ptrByte);
                end;
                if CryptDecrypt( mCryptKey, 0, TRUE, 0, buff, @LDataLen ) then
                begin
                  SetLength(LByteArray, LDataLen);
                  ptrByte := buff;
                  for i := 0 to (LDataLen - 1) do
                  begin
                    LByteArray[i] := ptrByte^;
                    Inc(ptrByte);
                  end;
                  LTest := TEncoding.UTF8.GetString(LByteArray);
                  AOutput := LTest;
                end else
                  Result := GetLastError;
              finally
                FreeMem(buff);
              end;

              CryptDestroyKey(mCryptKey);
            end;
          end else
            Result := GetLastError;
          if 0 <> mHashPassword then
            CryptDestroyHash(mHashPassword);
        finally
          if hshBuff <> nil then
            FreeMem(hshBuff)
        end;
      end;
    finally
      CryptReleaseContext(mProvider, 0);
    end;
  end else
    Result := GetLastError;
end;

end.

//Code for C# aes Encryption/Decrytion that is equivelant to AES Code above
(*
public class StringEncryptor
    {
        public static readonly byte[] aSeed = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

        public static string aesHash()
        {
            var hash = new SHA256CryptoServiceProvider();
            byte[] tmpKey = hash.ComputeHash(aSeed);

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data
            // and format each one as a hexadecimal string.
            for (int i = 0; i < tmpKey.Length; i++)
            {
                sBuilder.Append(tmpKey[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString().ToUpper();


            //return Convert.ToBase64String(tmpKey, 0, tmpKey.Length);
        }

        public static string aesEcryptString(string toEncrypt)
        {
            string encryptedPassword = string.Empty;

            if (string.IsNullOrEmpty(toEncrypt))
                return encryptedPassword;

            SHA256CryptoServiceProvider hash = null;
            AesCryptoServiceProvider aes = null;

            try
            {
                byte[] toEncryptArray = Encoding.UTF8.GetBytes(toEncrypt);

                hash = new SHA256CryptoServiceProvider();
                byte[] tmpKey = hash.ComputeHash(aSeed);
                byte[] keyArray = new byte[32];
                tmpKey.CopyTo(keyArray, 0);

                aes = new AesCryptoServiceProvider();
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;
                aes.IV = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
                aes.Key = keyArray;

                ICryptoTransform cTransform = aes.CreateEncryptor();
                byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);

                encryptedPassword = Convert.ToBase64String(resultArray, 0, resultArray.Length);
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                if (hash != null)
                    hash.Clear();

                if (aes != null)
                    aes.Clear();
            }

            return encryptedPassword;
        }


        public static string aesDecryptString(string toDecrypt)
        {
            string decryptedPassword = string.Empty;

            if (string.IsNullOrEmpty(toDecrypt))
                return decryptedPassword;

            SHA256CryptoServiceProvider hash = null;
            AesCryptoServiceProvider aes = null;

            try
            {
                byte[] toDecryptArray = Convert.FromBase64String(toDecrypt);

                hash = new SHA256CryptoServiceProvider();
                byte[] tmpKey = hash.ComputeHash(aSeed);
                byte[] keyArray = new byte[32];
                tmpKey.CopyTo(keyArray, 0);

                aes = new AesCryptoServiceProvider();
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;
                aes.IV = new byte[] { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
                aes.Key = keyArray;

                ICryptoTransform cTransform = aes.CreateDecryptor();
                byte[] resultArray = cTransform.TransformFinalBlock(toDecryptArray, 0, toDecryptArray.Length);

                decryptedPassword = Encoding.UTF8.GetString(resultArray, 0, resultArray.Length);
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            finally
            {
                if (hash != null)
                    hash.Clear();

                if (aes != null)
                    aes.Clear();
            }

            return decryptedPassword;
        }
    }
*)
