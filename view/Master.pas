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
  FMX.EditBox,
  FMX.SpinBox;

type
  TForm1 = class(TForm)
    tbc1: TTabControl;
    tbtm1: TTabItem;
    lytFileName: TLayout;
    lblFileName: TLabel;
    edtFileName: TEdit;
    btnFileNameOpen: TEditButton;
    btnFileNameSave: TEditButton;
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
    lblPlatforms: TLabel;
    chkPlatformsWin32: TCheckBox;
    chkPlatformsOSX32: TCheckBox;
    chkPlatformsWin64: TCheckBox;
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
    procedure btnFileNameOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnIDGenerateClick(Sender: TObject);
    procedure btnPictureBrowseClick(Sender: TObject);
    procedure btnFileNameSaveClick(Sender: TObject);
  private
    { Private declarations }
    FInfo: TInfoFile;
    procedure DoReadModel;
    procedure DoWriteModel;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  DN.Types;

{$R *.fmx}

procedure TForm1.btnFileNameOpenClick(Sender: TObject);
var
  OD: TOpenDialog;
begin
  OD := TOpenDialog.Create(Self);
  try
    OD.Filter := 'Delphinus.Info.json|Delphinus.Info.json';
    if not OD.Execute then
      Exit;
    edtFileName.Text := OD.FileName;
    FInfo.LoadFromFile(edtFileName.Text);
    DoReadModel;
  finally
    OD.Free;
  end;
end;

procedure TForm1.btnPictureBrowseClick(Sender: TObject);
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

procedure TForm1.btnFileNameSaveClick(Sender: TObject);
var
  OD: TSaveDialog;
begin
  OD := TSaveDialog.Create(Self);
  try
    OD.FileName := 'Delphinus.Info.json';
    if not OD.Execute then
      Exit;
    DoWriteModel;
    FInfo.SaveToFile(OD.FileName);
  finally
    OD.Free;
  end;
end;

procedure TForm1.btnIDGenerateClick(Sender: TObject);
begin
  edtID.Text := TGUID.NewGuid.ToString;
end;

procedure TForm1.DoReadModel;
begin
  edtID.Text := FInfo.ID.ToString;
  edtName.Text := FInfo.Name;
  edtPicture.Text := FInfo.Picture;
  edtLicenseType.Text := FInfo.LicenseType;
  edtLicenseFile.Text := FInfo.LicenseFile;
  chkPlatformsWin32.IsChecked := TDNCompilerPlatform.cpWin32 in FInfo.Platforms;
  chkPlatformsWin64.IsChecked := TDNCompilerPlatform.cpWin64 in FInfo.Platforms;
  chkPlatformsOSX32.IsChecked := TDNCompilerPlatform.cpOSX32 in FInfo.Platforms;
  spnbxPackageCompilerMin.Value := FInfo.PackageCompilerMin;
  spnbxPackageCompilerMax.Value := FInfo.PackageCompilerMax;
  spnbxCompilerMin.Value := FInfo.CompilerMin;
  spnbxCompilerMax.Value := FInfo.CompilerMax;
  edtFirstVersion.Text := FInfo.FirstVersion;
  {TODO -oM.E.Sysoev -cGeneral : Add Dependencies}
end;

procedure TForm1.DoWriteModel;
begin
  FInfo.ID := TGUID.Create(edtID.Text);
  FInfo.Name := edtName.Text;
 // FInfo.Picture := edtPicture.Text;
  FInfo.LicenseType := edtLicenseType.Text;
  FInfo.LicenseFile := edtLicenseFile.Text;
//  if chkPlatformsWin32.IsChecked then
//    FInfo.Platforms := FInfo.Platforms + TDNCompilerPlatform.cpWin32;
//  if chkPlatformsWin64.IsChecked then
//    FInfo.Platforms := FInfo.Platforms + TDNCompilerPlatform.cpWin64;
//  if chkPlatformsOSX32.IsChecked then
//    FInfo.Platforms := FInfo.Platforms + TDNCompilerPlatform.cpOSX32;
 // FInfo.PackageCompilerMin := spnbxPackageCompilerMin.Value;
 // FInfo.PackageCompilerMax := spnbxPackageCompilerMax.Value;
//  FInfo.CompilerMin := spnbxCompilerMin.Value;
//  FInfo.CompilerMax := spnbxCompilerMax.Value;
 // FInfo.FirstVersion := edtFirstVersion.Text;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FInfo := TInfoFile.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FInfo.Free;
end;

end.

