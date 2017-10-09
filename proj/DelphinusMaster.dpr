program DelphinusMaster;

uses
  System.StartUpCopy,
  FMX.Forms,
  Master in '..\view\Master.pas' {Main},
  Master.Info in '..\view\Master.Info.pas' {viewMasterInfo: TFrame},
  Master.Install in '..\view\Master.Install.pas' {viewMasterInstall: TFrame},
  DE.Utils in '..\source\DE.Utils.pas',
  DE.Constants in '..\source\DE.Constants.pas',
  Master.Install.EditorSourceFolders in '..\view\Master.Install.EditorSourceFolders.pas' {PathEditor},
  UI.PlatformSelector in '..\view\UI.PlatformSelector.pas' {PlatformSelector: TFrame},
  UI.CompilerVersions in '..\view\UI.CompilerVersions.pas' {CompilerVersions: TFrame},
  UI.PathEditor in '..\view\UI.PathEditor.pas' {frmPathEditor: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TPathEditor, PathEditor);
  Application.Run;
end.
