unit DE.Utils;

interface

type
  TUtils = class
    class function DelphiIdToName(const AId: Integer): string;
    class function DelphiNameToId(const AName: string): Integer;
    class function AppPath: string;
    class function ToLocalPath(const ACurrentPath, ASelectedPath: string): string;
  end;

implementation

uses
  DE.Constants,
  System.SysUtils;
{ TUtils }

class function TUtils.AppPath: string;
begin
  Result := ExtractFileDir(ParamStr(0));
end;

class function TUtils.DelphiIdToName(const AId: Integer): string;
begin
  if AId >= Low(CDelphiNames) then
    Result := CDelphiNames[AId];
end;

class function TUtils.DelphiNameToId(const AName: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(CDelphiNames) to High(CDelphiNames) do
    if CDelphiNames[I] = AName then
      Exit(I);
end;

class function TUtils.ToLocalPath(const ACurrentPath, ASelectedPath: string): string;
begin
  if ASelectedPath.ToLower.contains(ACurrentPath.ToLower) then
  begin
    Result := ASelectedPath.Substring(ACurrentPath.Length);
  end
  else
  begin
    Result := ASelectedPath;
  end;
end;

end.

