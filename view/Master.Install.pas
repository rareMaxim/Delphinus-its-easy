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
    procedure grdRawFolderGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
    procedure grdExpertsGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
  private
    { Private declarations }
    FInstall: TInstallationFile;
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

destructor TviewMasterInstall.Destroy;
begin
  FInstall.Free;
  inherited;
end;

procedure TviewMasterInstall.grdSourceFoldersGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      begin
        Value := FInstall.SourceFolders[ARow].Folder;
      end;
    1:
      begin
        Value := FInstall.SourceFolders[ARow].Recursive;
      end;
    2:
      begin
        Value := FInstall.SourceFolders[ARow].Filter;
      end;
    3:
      begin
        Value := FInstall.SourceFolders[ARow].Base;
      end;
    4:
      begin
        Value := CDelphiNames[FInstall.SourceFolders[ARow].CompilerMin];
      end;
    5:
      begin
        Value := CDelphiNames[FInstall.SourceFolders[ARow].CompilerMax];
      end;
  end;
end;

procedure TviewMasterInstall.grdExpertsGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      begin
        Value := FInstall.Experts[ARow].Expert;
      end;
    1:
      begin
        Value := FInstall.Experts[ARow].HotReload;
      end;
    2:
      begin
        Value := CDelphiNames[FInstall.Experts[ARow].CompilerMin];
      end;
    3:
      begin
        Value := CDelphiNames[FInstall.Experts[ARow].CompilerMax];
      end;
  end;
end;

procedure TviewMasterInstall.grdRawFolderGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      begin
        if Sender = grdRawFolder then
          Value := FInstall.RawFolders[ARow].Folder;
        if Sender = grdProjects then
          Value := FInstall.Projects[ARow].Project;
      end;
    1:
      begin
        if Sender = grdRawFolder then
          Value := CDelphiNames[FInstall.RawFolders[ARow].CompilerMin];
        if Sender = grdProjects then
          Value := CDelphiNames[FInstall.Projects[ARow].CompilerMin];
      end;
    2:
      begin
        if Sender = grdRawFolder then
          Value := CDelphiNames[FInstall.RawFolders[ARow].CompilerMax];
        if Sender = grdProjects then
          Value := CDelphiNames[FInstall.Projects[ARow].CompilerMax];
      end;
  end;
end;

procedure TviewMasterInstall.grdSearchPathesGetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  case ACol of
    0:
      begin
        if Sender = grdSearchPathes then
          Value := FInstall.SearchPathes[ARow].Path;
        if Sender = grdBrowsingPathes then
          Value := FInstall.BrowsingPathes[ARow].Path;
      end;
    1:
      begin
        if Sender = grdSearchPathes then
          Value := CDelphiNames[FInstall.SearchPathes[ARow].CompilerMin];
        if Sender = grdBrowsingPathes then
          Value := CDelphiNames[FInstall.BrowsingPathes[ARow].CompilerMin];
      end;
    2:
      begin
        if Sender = grdSearchPathes then
          Value := CDelphiNames[FInstall.SearchPathes[ARow].CompilerMax];
        if Sender = grdBrowsingPathes then
          Value := CDelphiNames[FInstall.BrowsingPathes[ARow].CompilerMax];
      end;
    3:
      begin
      //  if Sender = grdSearchPathes then
       //   Value := FInstall.SearchPathes[ARow];
      //  if Sender = grdBrowsingPathes then
        //  Value := FInstall.BrowsingPathes[ARow].CompilerMax;
      end;
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

