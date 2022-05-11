unit Data.Principal;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.IB, FireDAC.Phys.IBDef,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs;

type
  TDtmPrincipal = class(TDataModule)
    Base: TFDConnection;
    QryUrl: TFDQuery;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DtmPrincipal: TDtmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Forms;

procedure TDtmPrincipal.DataModuleCreate(Sender: TObject);
var

  vName : String;
begin
  Base.Connected := False;

//  vName := ExtractFilePath(Application.ExeName) + '..\..\db\CIDADE.IB';
//  vName := 'c:\CadCidadesSqLite\db\CIDADE.DB';
  vName := 'c:\UrlDownload\db\LOGDOWNLOAD.DB';
  Base.Params.Database := vName;
  Base.Params.UserName := '';//'SYSDBA';
  Base.Params.Password := ''; //'masterkey';

  Base.Open;
end;

end.
