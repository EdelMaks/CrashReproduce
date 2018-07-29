unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SyncObjs, JclSysUtils;

type
  TMyThread = class(TThread)
  private
    FLock: TCriticalSection;
    FLogSt: TStringList;

    procedure SetLogSt(const Value: TStringList);
    procedure GetALine(const St: String);
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    property LogSt: TStringList read FLogSt write SetLogSt;
  end;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TMyThread.SetLogSt(const Value: TStringList);
begin
  FLogSt := Value;
end;

procedure TMyThread.GetALine(const St: String);
Begin
  FLock.Acquire;
  if St <> '' then
    FLogSt.Add(St);
  Synchronize(
    procedure
    begin
      Form1.Label1.Caption := St
    end);
  FLock.Release;
End;

constructor TMyThread.Create(CreateSuspended: Boolean);
Begin
  inherited;
  FLock := TCriticalSection.Create;
End;

destructor TMyThread.Destroy;
Begin
  inherited;
  FLock.Free;
End;

procedure TMyThread.Execute;
var
  LogString: TStringList;
  TText: TTextHandler;
begin
  LogString := TStringList.Create;
  FLogSt := LogString;
  TText := GetALine;
  JclSysUtils.Execute('cmd /c "cd /d c:\users\edelm\source\repos\mobiwipe\main\win32\release && dir"', TText, false, nil, ppNormal, true);
  FLogSt.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  RunnerThread: TMyThread;
begin
  RunnerThread := TMyThread.Create(true);
  RunnerThread.Start;
end;

end.
