unit UI.PlatformSelector;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Layouts,
  DN.Types;

type
  TPlatformSelector = class(TFrame)
    lyt2: TLayout;
    chkPlatformsWin32: TCheckBox;
    chkPlatformsWin64: TCheckBox;
    chkPlatformsOSX32: TCheckBox;
    chkPlatformsLinux64: TCheckBox;
    lblPlatforms: TLabel;
    lyt4: TLayout;
    chkPlatformsAndroid: TCheckBox;
    chkPlatformsIOS32: TCheckBox;
    chkPlatformsIOS64: TCheckBox;
  private
    function GetPlatforms: TDNCompilerPlatforms;
    procedure SetPlatforms(const Value: TDNCompilerPlatforms);
    { Private declarations }
  public
    { Public declarations }
    property Platforms: TDNCompilerPlatforms read GetPlatforms write SetPlatforms;
  end;

implementation

{$R *.fmx}

{ TPlatformSelector }

function TPlatformSelector.GetPlatforms: TDNCompilerPlatforms;
begin
  if chkPlatformsWin32.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpWin32];
  if chkPlatformsWin64.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpWin64];
  if chkPlatformsOSX32.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpOSX32];
  if chkPlatformsLinux64.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpLinux64];
  if chkPlatformsAndroid.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpAndroid];
  if chkPlatformsIOS32.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpIOSDevice32];
  if chkPlatformsIOS64.IsChecked then
    Result := Result + [TDNCompilerPlatform.cpIOSDevice64];
end;

procedure TPlatformSelector.SetPlatforms(const Value: TDNCompilerPlatforms);
begin
  chkPlatformsWin32.IsChecked := TDNCompilerPlatform.cpWin32 in Value;
  chkPlatformsWin64.IsChecked := TDNCompilerPlatform.cpWin64 in Value;
  chkPlatformsOSX32.IsChecked := TDNCompilerPlatform.cpOSX32 in Value;
  chkPlatformsLinux64.IsChecked := TDNCompilerPlatform.cpLinux64 in Value;
  chkPlatformsAndroid.IsChecked := TDNCompilerPlatform.cpAndroid in Value;
  chkPlatformsIOS32.IsChecked := TDNCompilerPlatform.cpIOSDevice32 in Value;
  chkPlatformsIOS64.IsChecked := TDNCompilerPlatform.cpIOSDevice64 in Value;
end;

end.

