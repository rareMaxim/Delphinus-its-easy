unit Master.Info;

interface

uses
  DN.JSonFile.Info,
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
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox,
  FMX.ListBox,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Menus;

type
  TviewMasterInfo = class(TFrame)
    lyt3: TLayout;
    lblReportUrl: TLabel;
    edtReportUrl: TEdit;
    lytPicture: TLayout;
    lblPicture: TLabel;
    edtPicture: TEdit;
    btnPictureBrowse: TEditButton;
    lytPackageCompiler: TLayout;
    lblPackageCompiler: TLabel;
    lblPackageCompilerMin: TLabel;
    lblPackageCompilerMax: TLabel;
    cbbPackageCompilerMax: TComboBox;
    cbbPackageCompilerMin: TComboBox;
    lytName: TLayout;
    lblName: TLabel;
    edtName: TEdit;
    lytLicenseType: TLayout;
    lblLicenseType: TLabel;
    edtLicenseType: TEdit;
    lytLicenseFile: TLayout;
    lblLicenseFile: TLabel;
    edtLicenseFile: TEdit;
    btnLicenseFileBrowse: TEditButton;
    lytID: TLayout;
    lblID: TLabel;
    edtID: TEdit;
    btnIDGenerate: TEditButton;
    lytCompiler: TLayout;
    lblCompiler: TLabel;
    lblCompilerMin: TLabel;
    lblCompilerMax: TLabel;
    cbbCompilerMax: TComboBox;
    cbbCompilerMin: TComboBox;
    lyt1: TLayout;
    lblFirstVersion: TLabel;
    edtFirstVersion: TEdit;
    grpDependencies: TGroupBox;
    grdDependencies: TGrid;
    strngclmnDependenciesGUID: TStringColumn;
    strngclmnDependenciesMinVersion: TStringColumn;
    lytPlatforms: TLayout;
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
    pmDependencies: TPopupMenu;
    DependMenuAdd: TMenuItem;
    DependMenuEdit: TMenuItem;
    DependMenuDelete: TMenuItem;
    lyt5: TLayout;
    lblRepositoryRedirectIssues: TLabel;
    swtchRepositoryRedirectIssues: TSwitch;
    grpRepository: TGroupBox;
    lyt6: TLayout;
    lblRepositoryType: TLabel;
    edtRepositoryType: TEdit;
    lyt7: TLayout;
    lblRepositoryUser: TLabel;
    edtRepositoryUser: TEdit;
    lyt8: TLayout;
    lblRepositoryName: TLabel;
    edtRepositoryName: TEdit;
    spl1: TSplitter;
    procedure btnIDGenerateClick(Sender: TObject);
    procedure btnPictureBrowseClick(Sender: TObject);
    procedure grdDependenciesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdDependenciesSetValue(Sender: TObject; const ACol, ARow: Integer; const Value: TValue);
    procedure DependMenuAddClick(Sender: TObject);
    procedure DependMenuEditClick(Sender: TObject);
    procedure DependMenuDeleteClick(Sender: TObject);
  private
    { Private declarations }
    FInfo: TInfoFile;
  public
    { Public declarations }
    procedure ReadModel(const ProjectPath: string);
    procedure WriteModel(const ProjectPath: string);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  viewMaterInfo: TviewMasterInfo;

implementation

uses
  DN.Utils,
  DN.Types,
  System.IOUtils,
  DN.Version,
  FMX.DialogService;

{$R *.fmx}

{ TviewMasterInfo }

procedure TviewMasterInfo.btnIDGenerateClick(Sender: TObject);
begin
  edtID.Text := TGUID.NewGuid.ToString;
end;

procedure TviewMasterInfo.btnPictureBrowseClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(Self);
  try
    OD.Filter := 'jpg|*.jpg|png|*.png';
    if not OD.Execute then
      Exit;
    edtPicture.Text := OD.FileName;
  finally
    OD.Free;
  end;
end;

constructor TviewMasterInfo.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  FInfo := TInfoFile.Create;
  for I := Low(DN.Utils.CDelphiNames) to High(DN.Utils.CDelphiNames) do
  begin
    cbbCompilerMin.Items.Add(DN.Utils.CDelphiNames[I]);
    cbbCompilerMax.Items.Add(DN.Utils.CDelphiNames[I]);
    cbbPackageCompilerMin.Items.Add(DN.Utils.CDelphiNames[I]);
    cbbPackageCompilerMax.Items.Add(DN.Utils.CDelphiNames[I]);
  end;
end;

procedure TviewMasterInfo.DependMenuAddClick(Sender: TObject);
begin
  TDialogService.InputQuery('Create dependencies', ['GUID', 'Min. Ver.'], ['', ''],
    procedure(const AResult: TModalResult; const AValues: array of string)
    var
      Dep: TInfoDependency;
    begin
      if (AResult <> 1) or (AValues[0].IsEmpty) or (AValues[1].IsEmpty) then
        Exit;
      Dep.ID := TGUID.Create(AValues[0]);
      if TDNVersion.TryParse(AValues[1], Dep.Version) then
      begin
        FInfo.Dependencies.Add(Dep);
        grdDependencies.RowCount := FInfo.Dependencies.Capacity;
      end;
    end);
end;

procedure TviewMasterInfo.DependMenuDeleteClick(Sender: TObject);
begin
  if grdDependencies.Row = -1 then
    Exit;
  FInfo.Dependencies.Delete(grdDependencies.Row);
  grdDependencies.RowCount := FInfo.Dependencies.Count;
end;

procedure TviewMasterInfo.DependMenuEditClick(Sender: TObject);
var
  LSelDep: TInfoDependency;
begin
  if grdDependencies.Row = -1 then
    Exit;
  LSelDep := FInfo.Dependencies[grdDependencies.Row];
  TDialogService.InputQuery('Edit dependencies', ['GUID', 'Min. Ver.'], [LSelDep.ID.ToString,
    LSelDep.Version.ToString],
    procedure(const AResult: TModalResult; const AValues: array of string)
    var
      Dep: TInfoDependency;
    begin
      if AResult <> 1 then
        Exit;
      Dep.ID := TGUID.Create(AValues[0]);
      if TDNVersion.TryParse(AValues[1], Dep.Version) then
      begin
        FInfo.Dependencies[grdDependencies.Row] := Dep;
      end;
    end);

end;

destructor TviewMasterInfo.Destroy;
begin
  FInfo.Free;
  inherited;
end;

procedure TviewMasterInfo.ReadModel(const ProjectPath: string);
begin
  if TFile.Exists(TPath.Combine(ProjectPath, CInfoFile)) then
    FInfo.LoadFromFile(TPath.Combine(ProjectPath, CInfoFile));
  edtID.Text := FInfo.ID.ToString;
  edtName.Text := FInfo.Name;
  edtPicture.Text := FInfo.Picture;
  edtLicenseType.Text := FInfo.LicenseType;
  edtLicenseFile.Text := FInfo.LicenseFile;
  chkPlatformsWin32.IsChecked := TDNCompilerPlatform.cpWin32 in FInfo.Platforms;
  chkPlatformsWin64.IsChecked := TDNCompilerPlatform.cpWin64 in FInfo.Platforms;
  chkPlatformsOSX32.IsChecked := TDNCompilerPlatform.cpOSX32 in FInfo.Platforms;
  chkPlatformsLinux64.IsChecked := TDNCompilerPlatform.cpLinux64 in FInfo.Platforms;
  chkPlatformsAndroid.IsChecked := TDNCompilerPlatform.cpAndroid in FInfo.Platforms;
  chkPlatformsIOS32.IsChecked := TDNCompilerPlatform.cpIOSDevice32 in FInfo.Platforms;
  chkPlatformsIOS64.IsChecked := TDNCompilerPlatform.cpIOSDevice64 in FInfo.Platforms;
  cbbPackageCompilerMin.ItemIndex := FInfo.PackageCompilerMin.Frac;
  cbbPackageCompilerMin.ItemIndex := FInfo.PackageCompilerMax.Frac;
  cbbCompilerMin.ItemIndex := FInfo.CompilerMin.Frac;
  cbbCompilerMax.ItemIndex := FInfo.CompilerMax.Frac;
  edtFirstVersion.Text := FInfo.FirstVersion;
  edtReportUrl.Text := FInfo.ReportUrl;
  grdDependencies.RowCount := FInfo.Dependencies.Count;

  edtRepositoryType.Text := FInfo.RepositoryType;
  edtRepositoryUser.Text := FInfo.RepositoryUser;
  edtRepositoryName.Text := FInfo.Repository;
  swtchRepositoryRedirectIssues.IsChecked := FInfo.RepositoryRedirectIssues;
end;

procedure TviewMasterInfo.WriteModel(const ProjectPath: string);
begin
  FInfo.ID := TGUID.Create(edtID.Text);
  FInfo.Name := edtName.Text;
  FInfo.Picture := edtPicture.Text;
  FInfo.LicenseType := edtLicenseType.Text;
  FInfo.LicenseFile := edtLicenseFile.Text;

  if chkPlatformsWin32.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpWin32];
  if chkPlatformsWin64.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpWin64];
  if chkPlatformsOSX32.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpOSX32];
  if chkPlatformsLinux64.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpLinux64];
  if chkPlatformsAndroid.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpAndroid];
  if chkPlatformsIOS32.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpIOSDevice32];
  if chkPlatformsIOS64.IsChecked then
    FInfo.Platforms := FInfo.Platforms + [TDNCompilerPlatform.cpIOSDevice64];

  FInfo.PackageCompilerMin := cbbPackageCompilerMin.ItemIndex + Low(DN.Utils.CDelphiNames);
  FInfo.PackageCompilerMax := cbbPackageCompilerMax.ItemIndex + Low(DN.Utils.CDelphiNames);
  FInfo.CompilerMin := cbbCompilerMin.ItemIndex + Low(DN.Utils.CDelphiNames);
  FInfo.CompilerMax := cbbCompilerMax.ItemIndex + Low(DN.Utils.CDelphiNames);

  FInfo.RepositoryType := edtRepositoryType.Text;
  FInfo.RepositoryUser := edtRepositoryUser.Text;
  FInfo.Repository := edtRepositoryName.Text;
  FInfo.RepositoryRedirectIssues := swtchRepositoryRedirectIssues.IsChecked;

  FInfo.FirstVersion := edtFirstVersion.Text;
  FInfo.ReportUrl := edtReportUrl.Text;
  FInfo.SaveToFile(TPath.Combine(ProjectPath, CInfoFile));

end;

procedure TviewMasterInfo.grdDependenciesGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      begin
        Value := FInfo.Dependencies[ARow].ID.ToString;
      end;
    1:
      begin
        Value := FInfo.Dependencies[ARow].Version.ToString;
      end;
  end;
end;

procedure TviewMasterInfo.grdDependenciesSetValue(Sender: TObject; const ACol,
  ARow: Integer; const Value: TValue);
var
  LDepen: TInfoDependency;
begin
  LDepen := FInfo.Dependencies[ARow];
  case ACol of
    0:
      begin
        LDepen.ID := TGUID.Create(Value.AsType<string>);
      end;
    1:
      begin
        TDNVersion.TryParse(Value.AsType<string>, LDepen.Version);
      end;
  end;
  FInfo.Dependencies[ARow] := LDepen;
end;

end.

