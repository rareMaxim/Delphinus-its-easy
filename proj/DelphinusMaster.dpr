program DelphinusMaster;

uses
  System.StartUpCopy,
  FMX.Forms,
  Master in '..\view\Master.pas' {Main},
  Master.Info in '..\view\Master.Info.pas' {viewMasterInfo: TFrame},
  Master.Install in '..\view\Master.Install.pas' {viewMasterInstall: TFrame},
  DIE.Utils in 'DIE.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
