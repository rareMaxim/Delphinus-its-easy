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
  FMX.Menus,
  UI.PlatformSelector,
  UI.CompilerVersions;

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
    lyt1: TLayout;
    lblFirstVersion: TLabel;
    edtFirstVersion: TEdit;
    grpDependencies: TGroupBox;
    grdDependencies: TGrid;
    strngclmnDependenciesGUID: TStringColumn;
    strngclmnDependenciesMinVersion: TStringColumn;
    lytPlatforms: TLayout;
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
    procedure btnIDGenerateClick(Sender: TObject);
    procedure btnPictureBrowseClick(Sender: TObject);
    procedure grdDependenciesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdDependenciesSetValue(Sender: TObject; const ACol, ARow: Integer; const Value: TValue);
    procedure DependMenuAddClick(Sender: TObject);
    procedure DependMenuEditClick(Sender: TObject);
    procedure DependMenuDeleteClick(Sender: TObject);
    procedure btnLicenseFileBrowseClick(Sender: TObject);
  private
    { Private declarations }
    FInfo: TInfoFile;
    FPlatformSelector: TPlatformSelector;
    FProjectPath: string;
    FPackageCompiler: TCompilerVersions;
    FCompiler: TCompilerVersions;
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
  System.IOUtils,
  FMX.DialogService,
  DN.Utils,
  DN.Types,
  DN.Version,
  DE.Constants,
  DE.Utils;

{$R *.fmx}

{ TviewMasterInfo }

procedure TviewMasterInfo.btnIDGenerateClick(Sender: TObject);
begin
  edtID.Text := TGUID.NewGuid.ToString;
end;

procedure TviewMasterInfo.btnLicenseFileBrowseClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(Self);
  try
    if not OD.Execute then
      Exit;
    edtLicenseFile.Text := TUtils.ToLocalPath(FProjectPath, OD.FileName);
  finally
    OD.Free;
  end;
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
    edtPicture.Text := TUtils.ToLocalPath(FProjectPath, OD.FileName);
  finally
    OD.Free;
  end;
end;

constructor TviewMasterInfo.Create(AOwner: TComponent);
begin
  inherited;
  FInfo := TInfoFile.Create;

  FPlatformSelector := TPlatformSelector.Create(lytPlatforms);
  FPlatformSelector.Parent := lytPlatforms;
  FPlatformSelector.Align := TAlignLayout.Client;

  FPackageCompiler := TCompilerVersions.Create(lytPackageCompiler);
  FPackageCompiler.Parent := lytPackageCompiler;
  FPackageCompiler.Align := TAlignLayout.Client;

  FCompiler := TCompilerVersions.Create(lytCompiler);
  FCompiler.Parent := lytCompiler;
  FCompiler.Align := TAlignLayout.Client;
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
  TDialogService.InputQuery('Edit dependencies', ['GUID', 'Min. Ver.'], [LSelDep.ID.ToString, LSelDep.Version.ToString],
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
  FProjectPath := ProjectPath;
  if TFile.Exists(TPath.Combine(ProjectPath, CInfoFile)) then
    FInfo.LoadFromFile(TPath.Combine(ProjectPath, CInfoFile));
  edtID.Text := FInfo.ID.ToString;
  edtName.Text := FInfo.Name;
  edtPicture.Text := FInfo.Picture;
  edtLicenseType.Text := FInfo.LicenseType;
  edtLicenseFile.Text := FInfo.LicenseFile;

  FPlatformSelector.Platforms := FInfo.Platforms;

  FPackageCompiler.Min := Round(FInfo.PackageCompilerMin);
  FPackageCompiler.Max := Round(FInfo.PackageCompilerMax);

  FCompiler.Min := Round(FInfo.CompilerMin);
  FCompiler.Max := Round(FInfo.CompilerMax);

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

  FInfo.Platforms := FPlatformSelector.Platforms;

  FInfo.PackageCompilerMin := FPackageCompiler.Min;
  FInfo.PackageCompilerMax := FPackageCompiler.Max;

  FInfo.CompilerMin := FPackageCompiler.Min;
  FInfo.CompilerMax := FPackageCompiler.Max;

  FInfo.RepositoryType := edtRepositoryType.Text;
  FInfo.RepositoryUser := edtRepositoryUser.Text;
  FInfo.Repository := edtRepositoryName.Text;
  FInfo.RepositoryRedirectIssues := swtchRepositoryRedirectIssues.IsChecked;

  FInfo.FirstVersion := edtFirstVersion.Text;
  FInfo.ReportUrl := edtReportUrl.Text;
  FInfo.SaveToFile(TPath.Combine(ProjectPath, CInfoFile));

end;

procedure TviewMasterInfo.grdDependenciesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
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

procedure TviewMasterInfo.grdDependenciesSetValue(Sender: TObject; const ACol, ARow: Integer; const Value: TValue);
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

