program UrlDownload;



uses
  Vcl.Forms,
  UrlPrincipal in 'UrlPrincipal.pas' {FormMenuUrlDownload},
  UCadUrl in 'source\Visual\UCadUrl.pas' {FrmPrincipal: TDataModule},
  Data.Principal in 'source\Data\Data.Principal.pas' {DtmPrincipal: TDataModule},
  FDownload in 'source\Visual\FDownload.pas' {FormDownload};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMenuUrlDownload, FormMenuUrlDownload);
  Application.CreateForm(TDtmPrincipal, DtmPrincipal);
  //Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.

