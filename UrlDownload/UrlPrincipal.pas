unit UrlPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, uImagensDTC, Vcl.Menus, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxStatusBar, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  Data.FMTBcd, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, UCadUrl, Data.Principal, FDownload,
  Data.DbxSqlite;

type
  TFormMenuUrlDownload = class(TForm)
    MainMenuUrlDownload: TMainMenu;
    Cadastro1: TMenuItem;
    Sair1: TMenuItem;
    dxStatusBar1: TdxStatusBar;
    CadUrl1: TMenuItem;
    Reratrio1: TMenuItem;
    Processar1: TMenuItem;
    ImportarUrls1: TMenuItem;
    procedure CadUrl1Click(Sender: TObject);
    procedure ImportarUrls1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMenuUrlDownload: TFormMenuUrlDownload;

implementation

{$R *.dfm}


procedure TFormMenuUrlDownload.CadUrl1Click(Sender: TObject);
begin
  FrmPrincipal := TFrmPrincipal.Create(nil);
  FrmPrincipal.ShowModal;
end;

procedure TFormMenuUrlDownload.ImportarUrls1Click(Sender: TObject);
begin
  FormDownload := TFormDownload.Create(nil);
  FormDownload.ShowModal;
end;

procedure TFormMenuUrlDownload.Sair1Click(Sender: TObject);
begin
    Close;
end;



end.
