program CriarAcc;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  MiscData in 'Data\MiscData.pas',
  PlayerData in 'Data\PlayerData.pas',
  Util in 'Functions\Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
