unit DIE.Utils;

interface

type
  TUtils = class
    class function AppPath: string;
    class function ToLocalPath(const ACurrentPath, ASelectedPath: string): string;
  end;

implementation

uses
  System.SysUtils;
{ TUtils }

class function TUtils.AppPath: string;
begin
  Result := ExtractFileDir(ParamStr(0));
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

