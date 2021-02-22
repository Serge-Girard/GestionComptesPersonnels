program ComptesPerso;

{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {FMain},
  UDm in 'UDm.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
