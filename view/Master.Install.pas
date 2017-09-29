unit Master.Install;

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
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.TabControl,
  DN.JSonFile.Installation;

type
  TviewMasterInstall = class(TFrame)
    tbcInstall: TTabControl;
    tbtm3: TTabItem;
    grdSearchPathes: TGrid;
    strngclmn2: TStringColumn;
    pclmn3: TPopupColumn;
    pclmn4: TPopupColumn;
    clmn1: TColumn;
    tbtm6: TTabItem;
    grdBrowsingPathes: TGrid;
    strngclmn3: TStringColumn;
    pclmn5: TPopupColumn;
    pclmn6: TPopupColumn;
    clmn2: TColumn;
    tbtm4: TTabItem;
    grdSourceFolders: TGrid;
    strngclmn4: TStringColumn;
    chckclmn2: TCheckColumn;
    strngclmn5: TStringColumn;
    strngclmn6: TStringColumn;
    pclmn7: TPopupColumn;
    pclmn8: TPopupColumn;
    tbtm7: TTabItem;
    tbtm8: TTabItem;
    tbtm9: TTabItem;
    grdExperts: TGrid;
    strngclmn1: TStringColumn;
    chckclmn1: TCheckColumn;
    pclmn1: TPopupColumn;
    pclmn2: TPopupColumn;
    grdRawFolder: TGrid;
    strngclmn7: TStringColumn;
    pclmn9: TPopupColumn;
    pclmn10: TPopupColumn;
    grdProjects: TGrid;
    strngclmn8: TStringColumn;
    pclmn11: TPopupColumn;
    pclmn12: TPopupColumn;
    procedure grdSearchPathesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdSourceFoldersGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdExpertsGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdBrowsingPathesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdProjectsGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdRawFolderGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdProjectsSetValue(Sender: TObject; const ACol, ARow: Integer; const Value: TValue);
    procedure grdBrowsingPathesSetValue(Sender: TObject; const ACol, ARow: Integer; const Value: TValue);
  private
    { Private declarations }
    FInstall: TInstallationFile;
  protected
    function DelphiIdToName(const AId: Integer): TValue;
    function DelphiNameToId(const AName: string): Integer;
  public
    { Public declarations }
    procedure ReadModel(const ProjectPath: string);
    procedure WriteModel(const ProjectPath: string);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  viewMasterInstall: TviewMasterInstall;

implementation

uses
  System.IOUtils,
  DN.Types,
  DN.Utils;
{$R *.fmx}

{ TviewMasterInstall }

constructor TviewMasterInstall.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  FInstall := TInstallationFile.Create;
  for I := Low(DN.Utils.CDelphiNames) to High(DN.Utils.CDelphiNames) do
  begin
    pclmn1.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn2.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn3.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn4.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn5.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn6.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn7.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn8.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn9.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn10.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn11.Items.Add(DN.Utils.CDelphiNames[I]);
    pclmn12.Items.Add(DN.Utils.CDelphiNames[I]);
  end;
end;

function TviewMasterInstall.DelphiIdToName(const AId: Integer): TValue;
begin
  if AId >= Low(CDelphiNames) then
    Result := CDelphiNames[AId];
end;

function TviewMasterInstall.DelphiNameToId(const AName: string): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(CDelphiNames) to High(CDelphiNames) do
    if CDelphiNames[I] = AName then
      Exit(I);
end;

destructor TviewMasterInstall.Destroy;
begin
  FInstall.Free;
  inherited;
end;

procedure TviewMasterInstall.grdSourceFoldersGetValue(Sender: TObject; const
  ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FInstall.SourceFolders[ARow].Folder;
    1:
      Value := FInstall.SourceFolders[ARow].Recursive;
    2:
      Value := FInstall.SourceFolders[ARow].Filter;
    3:
      Value := FInstall.SourceFolders[ARow].Base;
    4:
      Value := DelphiIdToName(FInstall.SourceFolders[ARow].CompilerMin);
    5:
      Value := DelphiIdToName(FInstall.SourceFolders[ARow].CompilerMax);
  end;
end;

procedure TviewMasterInstall.grdBrowsingPathesGetValue(Sender: TObject; const
  ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FInstall.BrowsingPathes[ARow].Path;
    1:
      Value := DelphiIdToName(FInstall.BrowsingPathes[ARow].CompilerMin);
    2:
      Value := DelphiIdToName(FInstall.BrowsingPathes[ARow].CompilerMax);
    3:
      Value := GeneratePlatformString(FInstall.BrowsingPathes[ARow].Platforms);
  end;
end;

procedure TviewMasterInstall.grdBrowsingPathesSetValue(Sender: TObject; const
  ACol, ARow: Integer; const Value: TValue);
begin
//
end;

procedure TviewMasterInstall.grdExpertsGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FInstall.Experts[ARow].Expert;
    1:
      Value := FInstall.Experts[ARow].HotReload;
    2:
      Value := CDelphiNames[FInstall.Experts[ARow].CompilerMin];
    3:
      Value := CDelphiNames[FInstall.Experts[ARow].CompilerMax];
  end;
end;

procedure TviewMasterInstall.grdProjectsGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FInstall.Projects[ARow].Project;
    1:
      Value := DelphiIdToName(FInstall.Projects[ARow].CompilerMin);
    2:
      Value := DelphiIdToName(FInstall.Projects[ARow].CompilerMax);
  end;
end;

procedure TviewMasterInstall.grdProjectsSetValue(Sender: TObject; const ACol,
  ARow: Integer; const Value: TValue);
begin
  case ACol of
    0:
      FInstall.Projects[ARow].Project := Value.AsType<string>;
    1:
      FInstall.Projects[ARow].CompilerMin := DelphiNameToId(Value.AsType<string>);
    2:
      FInstall.Projects[ARow].CompilerMax := DelphiNameToId(Value.AsType<string>);
  end;
end;

procedure TviewMasterInstall.grdRawFolderGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FInstall.SearchPathes[ARow].Path;
    1:
      Value := DelphiIdToName(FInstall.SearchPathes[ARow].CompilerMin);
    2:
      Value := DelphiIdToName(FInstall.SearchPathes[ARow].CompilerMax);
  end;
end;

procedure TviewMasterInstall.grdSearchPathesGetValue(Sender: TObject; const ACol,
  ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      Value := FInstall.SearchPathes[ARow].Path;
    1:
      Value := CDelphiNames[FInstall.SearchPathes[ARow].CompilerMin];
    2:
      Value := CDelphiNames[FInstall.SearchPathes[ARow].CompilerMax];
  end;
end;

procedure TviewMasterInstall.ReadModel(const ProjectPath: string);
begin
  FInstall.LoadFromFile(TPath.Combine(ProjectPath, CInstallFile));

  grdSearchPathes.RowCount := Length(FInstall.SearchPathes);
  grdBrowsingPathes.RowCount := Length(FInstall.BrowsingPathes);
  grdSourceFolders.RowCount := Length(FInstall.SourceFolders);
  grdRawFolder.RowCount := Length(FInstall.RawFolders);
  grdProjects.RowCount := Length(FInstall.Projects);
  grdExperts.RowCount := Length(FInstall.Experts);
end;

procedure TviewMasterInstall.WriteModel(const ProjectPath: string);
begin
  FInstall.SaveToFile(TPath.Combine(ProjectPath, CInstallFile))
end;

end.

