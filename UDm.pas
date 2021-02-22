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
  FireDAC.Phys.SQLiteWrapper.Stat,

  FMX.Listbox, FMX.Types, FMX.Controls;

type
  TDM = class(TDataModule)
    FDCnxcomptes: TFDConnection;
    FDQEcritures: TFDQuery;
    FDQAjoutEcriture: TFDQuery;
    tblComptes: TFDTable;
    FDQEcritureslibelle: TStringField;
    FDQEcrituresCategorie: TStringField;
    FDQEcrituresmontant: TFMTBCDField;
    FDQEcrituressens: TStringField;
    FDQEcrituresdate: TStringField;
    tblCategories: TFDTable;
    procedure FDSQLiteFunctionMontantCalculate(AFunc: TSQLiteFunctionInstance;
      AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure FDSQLiteFunctionAAAAMMJJ2DateCalculate(
      AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs;
      AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure FDQEcrituresCalcFields(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure FDCnxcomptesBeforeConnect(Sender: TObject);
    procedure tblCategoriesAfterPost(DataSet: TDataSet);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AjoutEcriture(const Libelle, sens,date: String;
                            const montant: Currency;
                            const compte, categorie: Integer);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}
uses System.StrUtils, System.IOUtils, UStyleAndroid, UStyleWindows;

procedure TDM.AjoutEcriture( const Libelle, sens,date: String;
                             const montant: Currency;
                             const compte, categorie: Integer);
const SQL = 'INSERT INTO ECRITURES(Libelle,Montant,Sens,Date,Categorie_id,compte_id) '+
            'VALUES (?,?,?,?,?,?)';
begin
FDCnxcomptes.ExecSQL(SQL,[libelle,montant,sens,date,categorie,compte]);
FDQEcritures.Active:=False;
FDQEcritures.Active:=True;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
Dm.tblComptes.Open;
Dm.tblCategories.Open;
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

procedure TDM.FDQEcrituresCalcFields(DataSet: TDataSet);
var vsdate : String;
begin
if Dataset['Sens']='-' then Dataset['valeur']:=Dataset['montant']*-1
                       else DataSet['valeur']:=Dataset['montant'];
VsDate:=Dataset['date'];
Dataset['DateEcriture']:=EncodeDate(StrToInt(Copy(vsdate,1,4)),
                                    StrToInt(Copy(vsdate,5,2)),
                                    StrToInt(Copy(vsdate,7,2)));
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
FDQEcritures.Open('');
end;

end.
