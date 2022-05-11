unit UCadUrl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Data.DB, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TFrmPrincipal = class(TForm)
    DSUrl: TDataSource;
    GridCidade: TDBGrid;
    Panel1: TPanel;
    EdtCodigo: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdtUrl: TDBEdit;
    BtnIncluir: TButton;
    BtnAlterar: TButton;
    BtnExcluir: TButton;
    BtnSalvar: TButton;
    BtnCancelar: TButton;
    NavUrl: TDBNavigator;
    procedure BtnIncluirClick(Sender: TObject);
    procedure BtnAlterarClick(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure DSUrlDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  Data.Principal;

procedure TFrmPrincipal.BtnAlterarClick(Sender: TObject);
begin
  DSUrl.DataSet.Edit;
  EdtUrl.SetFocus;
end;

procedure TFrmPrincipal.BtnCancelarClick(Sender: TObject);
begin
  DSUrl.DataSet.Cancel;
end;

procedure TFrmPrincipal.BtnExcluirClick(Sender: TObject);
begin
  if (Application.MessageBox('Deseja realmente excluir este registro?',
  'Confirmação', MB_ICONQUESTION + MB_USEGLYPHCHARS) = mrYes) then
    DSUrl.DataSet.Delete;
end;

procedure TFrmPrincipal.BtnIncluirClick(Sender: TObject);
begin
  DSUrl.DataSet.Append;
  EdtUrl.SetFocus;
end;

procedure TFrmPrincipal.BtnSalvarClick(Sender: TObject);
begin
  DSUrl.DataSet.Post;
end;

procedure TFrmPrincipal.DSUrlDataChange(Sender: TObject; Field: TField);
begin
  EdtUrl.Enabled := DSUrl.DataSet.State in [dsInsert, dsEdit];

  BtnIncluir.Enabled := not (DSUrl.DataSet.State in [dsInsert, dsEdit]);

  BtnAlterar.Enabled := ((not (DSUrl.DataSet.State in [dsInsert, dsEdit])) and
  (not (DSUrl.DataSet.IsEmpty)));

  BtnExcluir.Enabled := ((not (DSUrl.DataSet.State in [dsInsert, dsEdit])) and
  (not (DSUrl.DataSet.IsEmpty)));

  BtnSalvar.Enabled := DSUrl.DataSet.State in [dsInsert, dsEdit];
  BtnCancelar.Enabled := DSUrl.DataSet.State in [dsInsert, dsEdit];
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  if not (DSUrl.DataSet.Active) then
    DSUrl.DataSet.Open;
end;

end.
