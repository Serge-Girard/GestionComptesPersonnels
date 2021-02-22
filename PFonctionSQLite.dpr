program PFonctionSQLite;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFonctionSQlite in 'UFonctionSQlite.pas' {Form11};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm11, Form11);
  Application.Run;
end.
