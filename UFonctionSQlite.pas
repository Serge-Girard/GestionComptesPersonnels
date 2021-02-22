unit UFonctionSQlite;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteWrapper, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, FMX.Memo.Types, FMX.Memo,
  FMX.Objects, FMX.StdCtrls, FMX.Layouts;

type
  TForm11 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDSQLiteFunctionToMontant: TFDSQLiteFunction;
    FDSQLiteFunctionToDate: TFDSQLiteFunction;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Memo1: TMemo;
    Text1: TText;
    Layout1: TLayout;
    Label1: TLabel;
    Total: TText;
    Label2: TLabel;
    procedure FDPhysSQLiteDriverLink1DriverCreated(Sender: TObject);
    procedure FDSQLiteFunctionToMontantCalculate(AFunc: TSQLiteFunctionInstance;
      AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure FDSQLiteFunctionToDateCalculate(AFunc: TSQLiteFunctionInstance;
      AInputs: TSQLiteInputs; AOutput: TSQLiteOutput; var AUserData: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form11: TForm11;

implementation

{$R *.fmx}

procedure TForm11.FDPhysSQLiteDriverLink1DriverCreated(Sender: TObject);
begin
FDSQLiteFunctionToMontant.Active:=True;
FDSQLiteFunctionToDate.Active:=True;
end;

procedure TForm11.FDSQLiteFunctionToDateCalculate(
  AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs;
  AOutput: TSQLiteOutput; var AUserData: TObject);
var AA,MM,JJ : Word;
begin
AA:=AInputs[0].AsString.Substring(1, 4).ToInteger;
  MM := AInputs[0].AsString.Substring(5, 2).ToInteger;
  JJ := AInputs[0].AsString.Substring(7, 2).ToInteger;
  try
    AOutput.AsDate := EncodeDate(AA, MM, JJ);
  except
    AOutput.AsDate := Date;
  end;
end;

procedure TForm11.FDSQLiteFunctionToMontantCalculate(
  AFunc: TSQLiteFunctionInstance; AInputs: TSQLiteInputs;
  AOutput: TSQLiteOutput; var AUserData: TObject);
begin
if AInputs[0].AsString = '+' then
    AOutput.AsCurrency := AInputs[1].AsCurrency
  else
    AOutput.AsCurrency := AInputs[1].AsCurrency * -1;
end;

procedure TForm11.FormCreate(Sender: TObject);
begin
fdQuery1.Open;
Total.Text:=FDConnection1.ExecSQLScalar('SELECT SUM(ToMontant(sens,Montant)) FROM ECRITURES');
end;

end.
