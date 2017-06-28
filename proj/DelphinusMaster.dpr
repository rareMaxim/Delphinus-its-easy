program DelphinusMaster;

uses
  System.StartUpCopy,
  FMX.Forms,
  Master in '..\view\Master.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
