program DelphinusMaster;

uses
  System.StartUpCopy,
  FMX.Forms,
  Master in '..\view\Master.pas' {Main};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
