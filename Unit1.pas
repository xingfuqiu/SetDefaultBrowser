unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    function SetDefaultBrowser_Win7(GTBPath: String): Boolean;
    function SetDefaultBrowser_XP(GTBPath: String): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  SetDefaultBrowser_XP(Edit1.Text);
end;

//******************************************************************************
// 设置默认浏览器 for win7
//******************************************************************************
function TForm1.SetDefaultBrowser_Win7(GTBPath: String): Boolean;
var
  reg: TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;
    if reg.OpenKey('GTBrowser\shell\open\command', True) then
    begin
      reg.WriteString('', GTBPath);
    end;
    reg.CloseKey;

    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey('Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice', True) then
    begin
      reg.WriteString('Progid', 'GTBrowser');
    end;
    Result := True;
  finally
    reg.Free;
  end;
end;

//******************************************************************************
// 设置默认浏览器 for XP
//******************************************************************************
function TForm1.SetDefaultBrowser_XP(GTBPath: String): Boolean;
var
  reg: TRegistry;
begin
  Result := False;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CLASSES_ROOT;

    if Not reg.OpenKey('http\shell\open\command', True) then Exit;
    reg.WriteString('', GTBPath);
    reg.CloseKey;

    if Not reg.OpenKey('http\shell\open\ddeexec\Application', True) then Exit;
    reg.WriteString('', 'GTBrowser');
    reg.CloseKey;

    if Not reg.OpenKey('http\shell\open\ddeexec', True) then Exit;
    reg.WriteString('', '');
    reg.CloseKey;
    Result := True;
  finally
    reg.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SetDefaultBrowser_Win7(Edit1.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  lpVersionInformation: TOSVersionInfo;
begin
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  GetVersionEx(lpVersionInformation);
  if lpVersionInformation.dwMajorVersion = 6 then
  begin
    //win7
    ShowMessage('你的系统是win7');
    SetDefaultBrowser_Win7(Edit1.Text);
  end else
  begin
    //xp
    ShowMessage('你的系统是xp');
    SetDefaultBrowser_XP(Edit1.Text);
  end;
  ShowMessage('设置成功!');
end;

end.
