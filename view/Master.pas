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
  DN.JSonFile.Installation,
  FMX.EditBox,
  FMX.SpinBox,
  FMX.ListBox,
  FMX.Menus,
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox;

type
  TMain = class(TForm)
    lytProjectDir: TLayout;
    lblProjectDir: TLabel;
    edtProjectDir: TEdit;
    edtProjectDirBrowse: TEditButton;
    btnProjectDirSave: TEditButton;
    tbc1: TTabControl;
    tbtm2: TTabItem;
    tbtm1: TTabItem;
    procedure btnProjectDirSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtProjectDirBrowseClick(Sender: TObject);
  private
    { Private declarations }
  protected
   // function IndexOf<T>():Integer;
    procedure LoadProject(const APath: string);
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

uses
  Master.Install,
  Master.Info,
  System.IOUtils,
  System.Generics.Collections,
  FMX.DialogService,
  DN.Utils,
  DN.Version;

{$R *.fmx}

procedure TMain.btnProjectDirSaveClick(Sender: TObject);
begin
  viewMaterInfo.WriteModel(edtProjectDir.Text);
  viewMasterInstall.WriteModel(edtProjectDir.Text);
end;

procedure TMain.edtProjectDirBrowseClick(Sender: TObject);
var
  LDir: string;
begin
  if SelectDirectory('Project dir', '', LDir) then
  begin
    LoadProject(LDir);
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;

  viewMaterInfo := TviewMasterInfo.Create(tbtm1);
  viewMaterInfo.Parent := tbtm1;

  viewMasterInstall := TviewMasterInstall.Create(tbtm2);
  viewMasterInstall.Parent := tbtm2;
end;

procedure TMain.LoadProject(const APath: string);
var
  LPath: string;
begin
  if not DirectoryExists(APath) then
    Exit;
  LPath := IncludeTrailingPathDelimiter(APath);
  edtProjectDir.Text := LPath;
  viewMaterInfo.ReadModel(LPath);
  viewMasterInstall.ReadModel(LPath);
end;

end.

