unit UDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLiteWrapper, FireDAC.Phys.SQLite,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FMX.Listbox, FMX.Types, FMX.Controls, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Comp.Script;

type
  TDM = class(TDataModule)
    FDCnxcomptes: TFDConnection;
    FDQEcritures: TFDQuery;
    tblComptes: TFDTable;
    FDQEcritureslibelle: TStringField;
    FDQEcrituresCategorie: TStringField;
    FDQEcrituresmontant: TFMTBCDField;
    FDQEcrituressens: TStringField;
    FDQEcrituresdate: TStringField;
    tblCategories: TFDTable;
    FDScripts: TFDScript;
    FDQEcrituresverifie: TBooleanField;
    FDQEcrituresid: TFDAutoIncField;
    FDUpdateEcritures: TFDUpdateSQL;
    FDQEcriturescategorie_id: TIntegerField;
    FDQEcriturescompte_id: TIntegerField;
    procedure FDSQLiteFunctionMontantCalculate(AFunc: TSQLiteFunctionInstance;
      AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure FDSQLiteFunctionAAAAMMJJ2DateCalculate(
      AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs;
      AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure FDCnxcomptesBeforeConnect(Sender: TObject);
    procedure tblCategoriesAfterPost(DataSet: TDataSet);
    procedure FDCnxcomptesAfterConnect(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AjoutEcriture(const Libelle, sens,SDate: String;
                            const montant: Currency;
                            const compte, categorie: Integer);
    procedure EcritureValidee(const id : integer) ;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
uses System.StrUtils, System.IOUtils, FMX.Dialogs;

procedure TDM.AjoutEcriture( const Libelle, sens,Sdate: String;
                             const montant: Currency;
                             const compte, categorie: Integer);
{en commentaire la version avec FDUpdateSQL}
const SQL = 'INSERT INTO ECRITURES(Libelle,Montant,Sens,Date,Categorie_id,compte_id) '+
            'VALUES (?,?,?,?,?,?)';
begin
//FDQEcritures.Append;
//FDQEcritures.FieldByName('Libelle').AsString:=libelle;
//FDQEcritures.FieldByName('Sens').AsString:=Sens;
//FDQEcritures.FieldByName('Date').AsString:=SDate;
//FDQEcritures.FieldByName('Montant').AsCurrency:=Montant;
//FDQEcritures.FieldByName('Categorie_id').AsInteger:=Categorie;
//FDQEcritures.FieldByName('Compte_id').AsInteger:=Compte;
//FDQEcritures.FieldByName('verifie').AsBoolean:=false;
//FDQEcritures.Post;
 FDCnxcomptes.ExecSQL(SQL,[libelle,montant,sens,date,categorie,compte]);
 FDQEcritures.Open('');
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
Dm.tblComptes.Open;
Dm.tblCategories.Open;
end;

procedure TDM.EcritureValidee(const id : integer );
{en commentaire la version avec FDUpdateSQL}
const SQL = 'UPDATE ecritures set verifie=NOT verifie WHERE id=:n';
begin
// DM.FDQEcritures.Edit;
// DM.FDQEcritures.FieldByName('verifie').asBoolean:=Not DM.FDQEcritures.FieldByName('verifie').asBoolean;
// DM.FDQEcritures.Post;
FDCnxcomptes.ExecSQL(SQL,[id]);
FDQEcritures.Open('');
end;

procedure TDM.FDCnxcomptesAfterConnect(Sender: TObject);
var vScript : TFDScript;
    version,v : integer;
begin

{Utilisation d'une spécificité SQLite : user_version}
 version:=FDCnxcomptes.ExecSQlScalar('PRAGMA user_version');

{Pourquoi un script au runtime ? Pour reprendre à partir d'une version }
// todo : version sans ce script au runtime, utilisation de  FDScripts.ExecuteScript(FDScripts.SQLScripts[v].SQL);

 vScript:=TFDScript.Create(Self);
 try
   VScript.Connection:=FDCnxcomptes;
   with vScript.SQlScripts.Add do
     begin
       name:='root';
       for v := version+1 to FDScripts.SQLScripts.Count do
         SQL.Add(format('@version%d',[v]));
     end;
   for v := version+1 to FDScripts.SQLScripts.Count - 1 do
      begin
        with vScript.SQLScripts.Add do begin
          Name := format('version%d',[v+1]);
          SQL:=FDScripts.SQLScripts[v].SQL;
        end;
      end;
   try
     FDCnxcomptes.StartTransaction;
     vScript.ExecuteAll;
     FDCnxcomptes.Commit;
   except
     FDCnxcomptes.Rollback;
   end;
 finally
   vScript.Free;
 end;
end;

procedure TDM.FDCnxcomptesBeforeConnect(Sender: TObject);
begin
With fdcnxComptes.Params as TFDPhysSQLiteConnectionDefParams do
     begin
{$IFDEF MSWINDOWS}
       Database:='..\..\madb.sdb';
{$ELSE}
       // Todo : Pour OSX ?
       Database:=Tpath.Combine(TPath.GetDocumentsPath,'madb.sdb');
{$ENDIF}
     end;
end;

procedure TDM.FDSQLiteFunctionAAAAMMJJ2DateCalculate(
  AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs;
  AOutput: TSQLiteOutput; var AUserData: TObject);
var vSDate : String;
    vDate : TDate;
begin
vsDate:=AInputs[0].AsString;
if vsDate.IsEmpty
  then vdate:=Date
  else
    vDate:=EncodeDate(StrToInt(Copy(vsdate,1,4)),
                  StrToInt(Copy(vsdate,5,2)),
                  StrToInt(Copy(vsdate,7,2)));
  AOutput.AsString:=FormatDateTime('dd/mm/yy',vDate);
end;

procedure TDM.FDSQLiteFunctionMontantCalculate(
  AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs;
  AOutput: TSQLiteOutput; var AUserData: TObject);
begin
 if Ainputs[0].AsString='-'
    then AOutput.AsInteger:=-1
    else AOutput.AsInteger:=1;
end;

procedure TDM.tblCategoriesAfterPost(DataSet: TDataSet);
begin
// tri à nouveau (order by)
FDQEcritures.Open('');
end;

end.
