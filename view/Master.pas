unit Master;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.TabControl,
  DN.JSonFile.Info,
  DN.JSonFile.Installation,
  FMX.EditBox,
  FMX.SpinBox,
  FMX.ListBox,
  FMX.Menus;

type
  TMain = class(TForm)
    tbc1: TTabControl;
    tbtm1: TTabItem;
    lytID: TLayout;
    lblID: TLabel;
    edtID: TEdit;
    btnIDGenerate: TEditButton;
    lytPicture: TLayout;
    lblPicture: TLabel;
    edtPicture: TEdit;
    btnPictureBrowse: TEditButton;
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
    lytPlatforms: TLayout;
    tbtm2: TTabItem;
    lytPackageCompiler: TLayout;
    lblPackageCompiler: TLabel;
    lblPackageCompilerMin: TLabel;
    spnbxPackageCompilerMin: TSpinBox;
    spnbxPackageCompilerMax: TSpinBox;
    lblPackageCompilerMax: TLabel;
    lytCompiler: TLayout;
    lblCompiler: TLabel;
    lblCompilerMin: TLabel;
    spnbxCompilerMin: TSpinBox;
    spnbxCompilerMax: TSpinBox;
    lblCompilerMax: TLabel;
    lyt1: TLayout;
    lblFirstVersion: TLabel;
    edtFirstVersion: TEdit;
    lyt2: TLayout;
    chkPlatformsWin32: TCheckBox;
    chkPlatformsWin64: TCheckBox;
    chkPlatformsOSX32: TCheckBox;
    chkPlatformsLinux64: TCheckBox;
    lblPlatforms: TLabel;
    Layout1: TLayout;
    chkPlatformsAndroid: TCheckBox;
    chkPlatformsIOS32: TCheckBox;
    chkPlatformsIOS64: TCheckBox;
    lyt3: TLayout;
    lblReportUrl: TLabel;
    edtReportUrl: TEdit;
    grpDependencies: TGroupBox;
    lstDependencies: TListBox;
    pmDependencies: TPopupMenu;
    DependMenuAdd: TMenuItem;
    DependMenuEdit: TMenuItem;
    DependMenuDelete: TMenuItem;
    lytProjectDir: TLayout;
    lblProjectDir: TLabel;
    edtProjectDir: TEdit;
    edtProjectDirBrowse: TEditButton;
    btnProjectDirSave: TEditButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnIDGenerateClick(Sender: TObject);
    procedure btnPictureBrowseClick(Sender: TObject);
    procedure btnFileNameSaveClick(Sender: TObject);
    procedure DependMenuAddClick(Sender: TObject);
    procedure DependMenuEditClick(Sender: TObject);
    procedure DependMenuDeleteClick(Sender: TObject);
    procedure btnProjectDirSaveClick(Sender: TObject);
  private
    { Private declarations }
    FInfo: TInfoFile;
    FInstall: TInstallationFile;
    procedure DoReadModelInfo;
    procedure DoReadModelInfoDependencies;
    procedure DoWriteIfnoModel;
    /////
    procedure DoReadModelInstall; virtual; abstract;
    procedure DoWriteModelInstall;virtual; abstract;
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

uses
  System.IOUtils,
  FMX.DialogService,
  DN.Types,
  DN.Version;

{$R *.fmx}

procedure TMain.btnPictureBrowseClick(Sender: TObject);
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

procedure TMain.btnProjectDirSaveClick(Sender: TObject);
begin
  DoWriteIfnoModel;
end;

procedure TMain.btnFileNameSaveClick(Sender: TObject);
var
  LDir: string;
begin
  if SelectDirectory('Project dir', '', LDir) then
  begin
    edtProjectDir.Text := LDir;
    if TFile.Exists(TPath.Combine(LDir, 'Delphinus.Info.json')) then
      FInfo.LoadFromFile(TPath.Combine(LDir, 'Delphinus.Info.json'));
    DoReadModelInfo;
  end;
end;

procedure TMain.btnIDGenerateClick(Sender: TObject);
begin
  edtID.Text := TGUID.NewGuid.ToString;
end;

procedure TMain.DoReadModelInfoDependencies;
var
  LDepedenci: TInfoDependency;
begin
  lstDependencies.BeginUpdate;
  try
    lstDependencies.Clear;
    for LDepedenci in FInfo.Dependencies do
    begin
      lstDependencies.Items.Add(LDepedenci.ID.ToString + ' - ' + LDepedenci.Version.ToString);
    end;
  finally
    lstDependencies.EndUpdate;
  end;
end;

procedure TMain.DoReadModelInfo;
begin
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
  spnbxPackageCompilerMin.Value := FInfo.PackageCompilerMin;
  spnbxPackageCompilerMax.Value := FInfo.PackageCompilerMax;
  spnbxCompilerMin.Value := FInfo.CompilerMin;
  spnbxCompilerMax.Value := FInfo.CompilerMax;
  edtFirstVersion.Text := FInfo.FirstVersion;
  edtReportUrl.Text := FInfo.ReportUrl;
  DoReadModelInfoDependencies;
end;

procedure TMain.DoWriteIfnoModel;
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

  FInfo.PackageCompilerMin := spnbxPackageCompilerMin.Value;
  FInfo.PackageCompilerMax := spnbxPackageCompilerMax.Value;
  FInfo.CompilerMin := spnbxCompilerMin.Value;
  FInfo.CompilerMax := spnbxCompilerMax.Value;
  FInfo.FirstVersion := edtFirstVersion.Text;
  FInfo.ReportUrl := edtReportUrl.Text;
  FInfo.SaveToFile(TPath.Combine(edtProjectDir.Text, 'Delphinus.Info.json'));
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  FInfo := TInfoFile.Create;
end;

procedure TMain.FormDestroy(Sender: TObject);
begin
  FInfo.Free;
end;

procedure TMain.DependMenuAddClick(Sender: TObject);
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
        DoReadModelInfoDependencies;
      end;
    end);
end;

procedure TMain.DependMenuDeleteClick(Sender: TObject);
begin
  if lstDependencies.ItemIndex = -1 then
    Exit;
  FInfo.Dependencies.Delete(lstDependencies.ItemIndex);
  DoReadModelInfoDependencies;
end;

procedure TMain.DependMenuEditClick(Sender: TObject);
var
  LSelDep: TInfoDependency;
begin
  if lstDependencies.ItemIndex = -1 then
    Exit;
  LSelDep := FInfo.Dependencies[lstDependencies.ItemIndex];
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
        FInfo.Dependencies[lstDependencies.ItemIndex] := Dep;
        DoReadModelInfoDependencies;
      end;
    end);
end;

end.

