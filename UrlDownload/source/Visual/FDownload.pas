
unit FDownload;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  System.ImageList, FMX.ImgList;

type
  TDownloadThreadDataEvent = procedure(const Sender: TObject; ThreadNo, ASpeed: Integer; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean) of object;
  TDownloadThread = class(TThread)
  private
    FOnThreadData: TDownloadThreadDataEvent;

  protected
    FURL, FFileName: string;
    FStartPoint, FEndPoint: Int64;
    FThreadNo: Integer;
    FTimeStart: Cardinal;

    procedure ReceiveDataEvent(const Sender: TObject; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
  public
    constructor Create(const URL, FileName: string; ThreadNo: Integer; StartPoint, EndPoint: Int64);
    destructor Destroy; override;
    procedure Execute; override;

    property OnThreadData: TDownloadThreadDataEvent write FOnThreadData;
  end;

  TFormDownload = class(TForm)
    PanelTop: TPanel;
    PanelCenter: TPanel;
    LabelFile: TLabel;
    EditFileName: TEdit;
    BStartDownload: TButton;
    Memo1: TMemo;
    ProgressBarPart1: TProgressBar;
    Label1: TLabel;
    Button1: TButton;
    ImageList1: TImageList;
    LabelURL: TLabel;
    EditURL: TEdit;
    LabelGlobalSpeed: TLabel;
    Panel1: TPanel;
    Panel5: TPanel;
    procedure BStartDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    ButtonCancelArray: array [0..0] of TButton;
    ProgressBarArray: array [0..0] of TProgressBar;
    LabelProgressArray: array [0..0] of TLabel;

    [volatile] FAllowFormClose: Boolean;
    [volatile] FClosingForm: Boolean;
    procedure ReceiveThreadDataEvent(const Sender: TObject; ThreadNo, ASpeed: Integer; AContentLength: Int64; AReadCount: Int64; var Abort: Boolean);
  public
  const
    NumThreads: Integer = 1;
  public
    { Public declarations }
    procedure SampleDownload;
  end;

var
  FormDownload: TFormDownload;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TFormDownload.BStartDownloadClick(Sender: TObject);
begin
  (Sender as TButton).Enabled := False;
  FAllowFormClose := False;
  TThread.CreateAnonymousThread(procedure
  begin
    SampleDownload;
  end).Start;
end;

procedure TFormDownload.ButtonCancelClick(Sender: TObject);
begin
  (Sender as TButton).Enabled := False;
end;

procedure TFormDownload.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin
	Memo1.Lines.Add('Cancelar o processo de download pode levar algum tempo.');
	Application.ProcessMessages;

  FClosingForm := True;

  for I := Low(ButtonCancelArray) to High(ButtonCancelArray) do
    ButtonCancelArray[I].Enabled := False;

  while not FAllowFormClose do
  begin
    Application.ProcessMessages;
    Sleep(1);
  end;
end;

procedure TFormDownload.FormCreate(Sender: TObject);
begin
  FAllowFormClose := True;
  ButtonCancelArray[0] := Button1;
  ProgressBarArray[0] := ProgressBarPart1;
  LabelProgressArray[0] := Label1;
end;

procedure TFormDownload.ReceiveThreadDataEvent(const Sender: TObject; ThreadNo: Integer; ASpeed: Integer; AContentLength, AReadCount: Int64;
  var Abort: Boolean);
var
  LCad: string;
  LCancel: Boolean;
  LSpeed: Integer;
begin
  LCancel := Abort or FClosingForm;
  if not LCancel then
    TThread.Synchronize(nil,
      procedure
      begin
        LCancel := not ButtonCancelArray[ThreadNo].Enabled;

        ProgressBarArray[ThreadNo].Value := AReadCount;
        LabelProgressArray[ThreadNo].Text := Format('%d KB/s', [ASpeed div 1024]);
      end);
  Abort := LCancel;
end;


procedure TFormDownload.SampleDownload;
var
  LClient: THTTPClient;
  URL: string;
  LResponse: IHTTPResponse;
  StFile: TFileStream;
  LFileName: string;
  LStart, LEnd, LSize, LFragSize: Int64;
  I: Integer;
  LDownloadThreads: array of TDownloadThread;
  LFinished: Boolean;
  LStartTime, LEndTime: Cardinal;
begin
  LClient := THTTPClient.Create;
  LFileName := TPath.Combine(TPath.GetDocumentsPath, EditFileName.Text);

  TThread.Synchronize(nil, procedure
  begin
    Memo1.Lines.Add('File location = ' + LFileName);
    Memo1.Lines.Add('Downloading ' + URL + ' ...');
    Application.ProcessMessages;
  end);
  try
    URL := EditURL.Text;
    if LClient.CheckDownloadResume(URL) then
    begin
      LResponse := LClient.Head(URL);

      // Obtenha espaço para o arquivo que será baixado
      LSize := LResponse.ContentLength;
      StFile := TFileStream.Create(LFileName, fmCreate);
      try
        STFile.Size := LSize;
      finally
        STFile.Free;
      end;

      // Divida o arquivo em blocos
      LFragSize := LSize div NumThreads;
      LStart := 0;
      LEnd := LStart + LFragSize;

      SetLength(LDownloadThreads, NumThreads);
      for I := 0 to NumThreads - 1 do
      begin
        if FClosingForm then
          Break;

        // Criando a Thread
        LDownloadThreads[I] := TDownloadThread.Create(URL, LFileName, I, LStart, LEnd);
        LDownloadThreads[I].OnThreadData := ReceiveThreadDataEvent;

        TThread.Synchronize(nil, procedure
        begin
          // Ajustar o valor máximo da ProgressBar
          if LEnd >= LSize then
          begin
            ProgressBarArray[I].Max := LFragSize - (LEnd - LSize);
            LEnd := LSize;
          end
          else
            ProgressBarArray[I].Max := LFragSize;
          ProgressBarArray[I].Min := 0;
          ProgressBarArray[I].Value := 0;

          ButtonCancelArray[I].Enabled := True;
          LabelProgressArray[I].Text := '0 KB/s';
        end);

        // Atualizar valores iniciais e finais
        LStart := LStart + LFragSize;
        LEnd := LStart + LFragSize;
      end;

      // Inicie o processo de download
      LStartTime := TThread.GetTickCount;
      for I := 0 to NumThreads - 1 do
        LDownloadThreads[I].Start;

      // Aguarde até que todos os threads terminem
      LFinished := False;
      while not LFinished and not FClosingForm do
      begin
        LFinished := True;
        for I := 0 to NumThreads - 1 do
          LFinished := LFinished and LDownloadThreads[I].Finished;
      end;

      LEndTime := TThread.GetTickCount - LStartTime;
      TThread.Synchronize(nil, procedure
      begin
        LabelGlobalSpeed.Text := Format('Speed: %d KB/s', [((LSize*1000) div LEndTime) div 1024]);
      end);

      // Cleanup Threads
      for I := 0 to NumThreads - 1 do
        LDownloadThreads[I].Free;

    end
    else
    begin
      TThread.Synchronize(nil, procedure
      begin
        Memo1.Lines.Add('O servidor não retomou o recurso de download');
      end);
    end;
  finally
    LClient.Free;
    TThread.Synchronize(nil, procedure
    begin
     BStartDownload.Enabled := True;
    end);
    FAllowFormClose := True;

  end;
end;

{ TDownloadThread }

constructor TDownloadThread.Create(const URL, FileName: string; ThreadNo: Integer; StartPoint, EndPoint: Int64);
begin
  inherited Create(True);
  FURL := URL;
  FFileName := FileName;
  FThreadNo := ThreadNo;
  FStartPoint := StartPoint;
  FEndPoint := EndPoint;
end;

destructor TDownloadThread.Destroy;
begin
  inherited;
end;

procedure TDownloadThread.Execute;
var
  LResponse: IHTTPResponse;
  LStream: TFileStream;
  LHttpClient: THTTPClient;
begin
  inherited;
  LHttpClient := THTTPClient.Create;
  try
    LHttpClient.OnReceiveData := ReceiveDataEvent;
    LStream := TFileStream.Create(FFileName, fmOpenWrite or fmShareDenyNone);
    try
      FTimeStart := GetTickCount;
      LStream.Seek(FStartPoint, TSeekOrigin.soBeginning);
      LResponse := LHttpClient.GetRange(FURL, FStartPoint, FEndPoint, LStream);
    finally
      LStream.Free;
    end;
  finally
    LHttpClient.Free;
  end;
end;

procedure TDownloadThread.ReceiveDataEvent(const Sender: TObject; AContentLength, AReadCount: Int64;
  var Abort: Boolean);
var
  LTime: Cardinal;
  LSpeed: Integer;
begin
  if Assigned(FOnThreadData) then
  begin
    LTime := GetTickCount - FTimeStart;
    if AReadCount = 0 then
      LSpeed := 0
    else
      LSpeed := (AReadCount * 1000) div LTime;

    FOnThreadData(Sender, FThreadNo, LSpeed, AContentLength, AReadCount, Abort);
  end;
end;

end.
