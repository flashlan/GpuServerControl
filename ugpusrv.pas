unit uGpuSrv;

{$mode objfpc}{$H+}

// detect OS
// https://forum.lazarus.freepascal.org/index.php?topic=15390.0

interface

uses
  {$ifdef UNIX}
  process, Unix,
   {$IFDEF UseCThreads}
      cthreads,
    {$ENDIF}
  {$endif}

  {$ifdef Windows}
    Process, Windows, win32proc,ShellAPI,
  {$endif}
  //add classes aqui
  Classes, dbugintf, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;
  // Windows removed
type

  { TFormGpuControl }

  TFormGpuControl = class(TForm)
    Bevel1: TBevel;
    BtSDWeb: TButton;
    BtlangflowWeb: TButton;
    BtJupyterWeb: TButton;
    BtFlowiseWeb: TButton;
    CbLangflowSrv: TCheckBox;
    CbSdSrv: TCheckBox;
    CbJupyterSrv: TCheckBox;
    CbOllamaSrv: TCheckBox;
    CbFlowiseServ: TCheckBox;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    TestButton: TButton;
    BtOllamaWeb: TButton;
    ButtonClose: TButton;
    ButtonNvidiaSmi: TButton;
    Button3: TButton;
    PageControl1: TPageControl;
    SyncButton: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    vpnButton: TButton;
    procedure Bevel1ChangeBounds(Sender: TObject);
    procedure BtJupyterWebClick(Sender: TObject);
    procedure BtlangflowWebClick(Sender: TObject);
    procedure BtFlowiseWebClick(Sender: TObject);
    procedure BtSDWebClick(Sender: TObject);
    procedure CbLangflowSrvChange(Sender: TObject);
    procedure CbSdSrvChange(Sender: TObject);
    procedure CbJupyterSrvChange(Sender: TObject);
    procedure CbOllamaSrvChange(Sender: TObject);
    procedure BtOllamaWebClick(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonNvidiaSmiClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SyncButtonClick(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure vpnButtonClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private

  public


  end;

var
  FormGpuControl: TFormGpuControl;
  RunProgram, SSHProcess: TProcess;
  OS, AppPath, ScriptPath, Command, ExePath, CurrentDir, Dir: string;

implementation

{$R *.lfm}

{ TFormGpuControl }

//Function get os
function OSVersion: string;
  begin
    // Cocoa | LCLcarbon
    {$IFDEF Cocoa}
  OSVersion := 'MacOS';
    {$ELSE}
    {$IFDEF Linux}
  OSVersion := 'Linux';
    {$ELSE}
    {$IFDEF UNIX}
  OSVersion := 'Unix';
    {$ELSE}
    {$IFDEF WINDOWS}
  OSVersion := 'Windows';
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  end;

procedure ExecutarComandoSSH(const Comando: string);
  var
    TerminalCommand: string;
  begin
    // Construir o comando para abrir o Terminal.app e executar o comando SSH
    TerminalCommand := 'open -a Terminal "ssh ' + Comando + '"';

    // Executar o comando no terminal
    if fpSystem(TerminalCommand) = 0 then
      begin
      WriteLn('Comando SSH executado com sucesso.');
      end
    else
      begin
      WriteLn('Erro ao executar o comando SSH.');
      end;
  end;

procedure TFormGpuControl.ButtonCloseClick(Sender: TObject);
  begin
    Close();
  end;
// nvidia smi
procedure TFormGpuControl.ButtonNvidiaSmiClick(Sender: TObject);
  begin
    {$IFDEF Linux}
          begin

               RunProgram := TProcess.Create(nil);
               RunProgram.CommandLine := 'xfce4-terminal --geometry 91x24 -e "bash -c "/home/sandman/.bin/nvidia-smi-remote.sh;bash"" ';
               RunProgram.Execute;
               RunProgram.Free;
          end
    {$ELSE}
    {$IFDEF UNIX}
       begin
            SSHProcess := TProcess.Create(nil);
            AppPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(Application.ExeName))));
            ScriptPath := AppPath + '/unixScripts/nvidia-smi.sh';
            //ShowMessage(ScriptPath);
            // Define o executável corretamente, sem espaço extra
            SSHProcess.Executable := '/usr/X11/bin/xterm';
            SSHProcess.Parameters.Add('-geometry');
            SSHProcess.Parameters.Add('100x30'); // Define a janela com 100 colunas e 30 linhas
            SSHProcess.Parameters.Add('-bg');
            SSHProcess.Parameters.Add('black');  // Define o fundo preto
            SSHProcess.Parameters.Add('-fg');
            SSHProcess.Parameters.Add('white');  // Define o texto branco
            // Adiciona os parâmetros corretamente
            SSHProcess.Parameters.Add('-e');
            SSHProcess.Parameters.Add('bash -c "' + ScriptPath + '; exec bash"');
            SSHProcess.Options := [poNoConsole, poDetached];
            SSHProcess.Execute;
            SSHProcess.Free;
      end
    {$ELSE}
    {$IFDEF WINDOWS}
        begin
          ExePath := ExtractFilePath(ParamStr(0));
          Command := ExePath + 'winScripts/nvidia-smi.bat';
          // SW_SHOWNORMAL
          //explorer "https://google.com"
          //RunProgram.CommandLine := 'winScripts/launchLangFlow.bat';
          ShellExecute(0, 'open', PChar(Command), nil, nil, SW_SHOWNORMAL);
      end
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  end;


procedure TFormGpuControl.Button3Click(Sender: TObject);
  begin
    RunProgram := TProcess.Create(nil);
    RunProgram.CommandLine := 'C:\Users\evert\Nextcloud\DEV\x2go-scripts\copyexe.bat" ';

    RunProgram.Execute;
    RunProgram.Free;
  end;


procedure TFormGpuControl.SyncButtonClick(Sender: TObject);
  begin
    RunProgram := TProcess.Create(nil);

    RunProgram.CommandLine :=
      'xfce4-terminal -e "bash -c "/home/sandman/.bin/devsync.sh;bash"" ';
    RunProgram.Execute;
    RunProgram.Free;
  end;


procedure TFormGpuControl.TestButtonClick(Sender: TObject);
  begin

    //ShowMessage('Running on ' + OSVersion);
    OS := OSVersion;
    if OS = 'Windows' then
      begin
      ShowMessage('Running on ' + OS);
      end
    else if OS = 'Linux' then
        begin
        ShowMessage('Running on ' + OS);
        end
      else if OS = 'Unix' then
          begin
          ShowMessage('Running on ' + OS);
          end
        else
          begin
          ShowMessage('Running another thing');
          end;
  end;

//VPN
procedure TFormGpuControl.vpnButtonClick(Sender: TObject);
  begin
    RunProgram := TProcess.Create(nil);
    OS := OSVersion;
    if OS = 'Windows' then
      begin
      //explorer "https://google.com"
      RunProgram.CommandLine :=
        'C:\Program Files\OpenVPN\bin\openvpn-gui.exe --connect pfSense-UDP4-1194-sandman.ovpn';
      end
    else if OS = 'Linux' then
        begin
        RunProgram.CommandLine := 'nmcli con up id pfSense-UDP4-1194-sandman';
        end
      else
        begin
        ShowMessage('Running another thing');
        end;
    RunProgram.Execute;
    RunProgram.Free;
  end;

procedure TFormGpuControl.Label1Click(Sender: TObject);
  begin

  end;

procedure TFormGpuControl.Bevel1ChangeBounds(Sender: TObject);
  begin

  end;

procedure TFormGpuControl.BtJupyterWebClick(Sender: TObject);
  begin
    RunProgram := TProcess.Create(nil);
    OS := OSVersion;
    // Cocoa | LCLcarbon
    {$IFDEF Linux}
      begin
         RunProgram.CommandLine := 'xdg-open "http://192.168.1.129:8888" ';
      end;
    {$ELSE}
    {$IFDEF UNIX}
      begin
         RunProgram.CommandLine := 'open "http://192.168.1.129:8888" ';
      end;
    {$ELSE}
    {$IFDEF WINDOWS}
      begin
           //explorer "https://google.com"
           RunProgram.CommandLine := 'explorer "http://192.168.1.129:8888" ';
      end;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    RunProgram.Execute;
    RunProgram.Free;
  end;

procedure TFormGpuControl.BtlangflowWebClick(Sender: TObject);
  // launch langFlow Button
  begin
    RunProgram := TProcess.Create(nil);
    OS := OSVersion;
    {$IFDEF Linux}
      begin
         RunProgram.CommandLine := 'xdg-open "https://langflow.librography.org" ';
      end;
    {$ELSE}
    {$IFDEF UNIX}
      begin
         RunProgram.CommandLine := 'open "https://langflow.librography.org" ';
      end;
    {$ELSE}
    {$IFDEF WINDOWS}
      begin
           RunProgram.CommandLine := 'explorer "https://langflow.librography.org" ';
      end;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    RunProgram.Execute;
    RunProgram.Free;
  end;

procedure TFormGpuControl.BtFlowiseWebClick(Sender: TObject);
  begin

  end;

procedure TFormGpuControl.BtSDWebClick(Sender: TObject);
  // launch Stable-Diffusion Button
  begin
    RunProgram := TProcess.Create(nil);
    OS := OSVersion;
    // Cocoa | LCLcarbon
    {$IFDEF Linux}
      begin
         RunProgram.CommandLine := 'xdg-open "http://192.168.1.129:7860/" ';
      end;
    {$ELSE}
    {$IFDEF UNIX}
      begin
         RunProgram.CommandLine := 'open "http://192.168.1.129:7860/" ';
      end;
    {$ELSE}
    {$IFDEF WINDOWS}
      begin
           RunProgram.CommandLine := 'explorer "http://192.168.1.129:7860/" ';
      end;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    RunProgram.Execute;
    RunProgram.Free;
  end;

procedure TFormGpuControl.CbLangflowSrvChange(Sender: TObject);
  begin
    {$IFDEF Linux}
  begin
       CurrentDir := GetCurrentDir;
       RunProgram := TProcess.Create(nil);
       if CbLangflowSrv.Checked then
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/startLangflow.sh > /dev/null 2>&1 & " ';
          end
       else
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/stopLangflow.sh > /dev/null 2>&1 & " ';
          end;
       RunProgram.Execute;
       RunProgram.Free;
  end
    {$ELSE}
    {$IFDEF UNIX}
  begin
    SSHProcess := TProcess.Create(nil);
    try
      AppPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(Application.ExeName))));
      if CbLangflowSrv.Checked then
        begin
          ScriptPath := AppPath + '/unixScripts/startLangflow.sh';
        end
      else
        begin
        ScriptPath := AppPath + '/unixScripts/stopLangflow.sh';
        end;
      SSHProcess.Executable := '/usr/X11/bin/xterm';
      //SSHProcess.Parameters.Add('-iconic'); // Inicia o xterm minimizado
      SSHProcess.Parameters.Add('-e');
      SSHProcess.Parameters.Add('bash -c "' + ScriptPath + '; sleep 1; exit"');
      SSHProcess.Options := SSHProcess.Options + [poNoConsole, poDetached];
      SSHProcess.Execute;
    finally
      SSHProcess.Free;
    end;
  end;
    {$ELSE}
    {$IFDEF WINDOWS}
  begin
       ExePath := ExtractFilePath(ParamStr(0));
       if CbLangflowSrv.Checked then
          begin
               Command := ExePath + 'winScripts\launchLangFlow.bat';
          end
       else
           begin
                Command := ExePath + 'winScripts\stopLangFlow.bat';
           end;
       ShellExecute(0, 'open', PChar(Command), nil, nil, SW_HIDE);
  end
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  end;

procedure TFormGpuControl.CbSdSrvChange(Sender: TObject);
  begin
    {$IFDEF Linux}
  begin
       CurrentDir := GetCurrentDir;
       RunProgram := TProcess.Create(nil);
       if CbSdSrv.Checked then
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/startSD.sh > /dev/null 2>&1 & " ';
          end
       else
          begin
               // implementear stop SD on server
               RunProgram.CommandLine := 'bash -c "unixScripts/stopSD.sh > /dev/null 2>&1 & " ';
          end;
       RunProgram.Execute;
       RunProgram.Free;
  end
    {$ELSE}
    {$IFDEF UNIX}
  begin
    SSHProcess := TProcess.Create(nil);
    try
      AppPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(Application.ExeName))));
      if CbSdSrv.Checked then
        begin
          ScriptPath := AppPath + '/unixScripts/startSD.sh';
        end
      else
        begin
        ScriptPath := AppPath + '/unixScripts/stopSD.sh';
        end;
      SSHProcess.Executable := '/usr/X11/bin/xterm';
      //SSHProcess.Parameters.Add('-iconic'); // Inicia o xterm minimizado
      SSHProcess.Parameters.Add('-e');
      SSHProcess.Parameters.Add('bash -c "' + ScriptPath + '; sleep 1; exit"');
      SSHProcess.Options := SSHProcess.Options + [poNoConsole, poDetached];
      SSHProcess.Execute;
    finally
      SSHProcess.Free;
    end;
  end;
    {$ELSE}
    {$IFDEF WINDOWS}
  begin
       ExePath := ExtractFilePath(ParamStr(0));
       if CbOllamaSrv.Checked then
          begin
               Command := ExePath + 'winScripts\launchSD.bat';
          end
       else
           begin
                // implementear stop SD on server
                Command := ExePath + 'winScripts\stopSD.bat';
           end;
       ShellExecute(0, 'open', PChar(Command), nil, nil, SW_HIDE);
  end
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  end;

procedure TFormGpuControl.CbJupyterSrvChange(Sender: TObject);
  begin
    {$IFDEF Linux}
  begin
       CurrentDir := GetCurrentDir;
       RunProgram := TProcess.Create(nil);
       if CbJupyterSrv.Checked then
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/startJupyter.sh > /dev/null 2>&1 & " ';
          end
       else
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/stopJupyter.sh > /dev/null 2>&1 & " ';
          end;
       RunProgram.Execute;
       RunProgram.Free;
  end
    {$ELSE}
    {$IFDEF UNIX}
  begin
    SSHProcess := TProcess.Create(nil);
    try
      AppPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(Application.ExeName))));
      if CbJupyterSrv.Checked then
        begin
          ScriptPath := AppPath + '/unixScripts/startJupyter.sh';
        end
      else
        begin
        ScriptPath := AppPath + '/unixScripts/stopJupyter.sh';
        end;
      SSHProcess.Executable := '/usr/X11/bin/xterm';
      //SSHProcess.Parameters.Add('-iconic'); // Inicia o xterm minimizado
      SSHProcess.Parameters.Add('-e');
      SSHProcess.Parameters.Add('bash -c "' + ScriptPath + '; sleep 1; exit"');
      SSHProcess.Options := SSHProcess.Options + [poNoConsole, poDetached];
      SSHProcess.Execute;
    finally
      SSHProcess.Free;
    end;
  end;
    {$ELSE}
    {$IFDEF WINDOWS}
  begin
       ExePath := ExtractFilePath(ParamStr(0));
       if CbJupyterSrv.Checked then
          begin
               Command := ExePath + 'winScripts\launchJupyter.bat';
          end
       else
           begin
                Command := ExePath + 'winScripts\stopJupyter.bat';
           end;
       ShellExecute(0, 'open', PChar(Command), nil, nil, SW_HIDE);
  end
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
  end;

// lauch llama service
procedure TFormGpuControl.CbOllamaSrvChange(Sender: TObject);
  begin
    //langflow service start -  necessario crar bat na subpasta do .exe e arquivos .sh no server para iniciar e parar
    {$IFDEF Linux}
  begin
       CurrentDir := GetCurrentDir;
       RunProgram := TProcess.Create(nil);
       // change variable below
       if CbOllamaSrv.Checked then
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/startOllama.sh > /dev/null 2>&1 & " ';
          end
       else
          begin
               RunProgram.CommandLine := 'bash -c "unixScripts/stopOllama.sh > /dev/null 2>&1 & " ';
          end;
       RunProgram.Execute;
       RunProgram.Free;
  end
    {$ELSE}
    {$IFDEF UNIX}
  begin
    SSHProcess := TProcess.Create(nil);
    try
      AppPath := ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(Application.ExeName))));
      if CbOllamaSrv.Checked then
        begin
          ScriptPath := AppPath + '/unixScripts/startOllama.sh';
        end
      else
        begin
        ScriptPath := AppPath + '/unixScripts/stopOllama.sh';
        end;
      SSHProcess.Executable := '/usr/X11/bin/xterm';
      SSHProcess.Parameters.Add('-iconic'); // Inicia o xterm minimizado
      SSHProcess.Parameters.Add('-e');
      SSHProcess.Parameters.Add('bash -c "' + ScriptPath + '; sleep 1; exit"');
      SSHProcess.Options := SSHProcess.Options + [poNoConsole, poDetached];
      SSHProcess.Execute;
    finally
      SSHProcess.Free;
    end;
  end;
    {$ELSE}
    {$IFDEF WINDOWS}
  begin
       ExePath := ExtractFilePath(ParamStr(0));
       if CbOllamaSrv.Checked then
          begin
               Command := ExePath + 'winScripts\launchOllama.bat';
          end
       else
           begin
                Command := ExePath + 'winScripts\stopOllama.bat';
           end;
       ShellExecute(0, 'open', PChar(Command), nil, nil, SW_HIDE);
  end
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}

  end;

procedure TFormGpuControl.BtOllamaWebClick(Sender: TObject);
  begin
    RunProgram := TProcess.Create(nil);
    //OS := OSVersion;
    {$IFDEF Linux}
        begin
           RunProgram.CommandLine := 'xdg-open "http://192.168.1.129:8080" ';
        end;
    {$ELSE}
    {$IFDEF UNIX}
    begin
           RunProgram.CommandLine := 'open "http://192.168.1.129:8080" ';
           end;
    {$ELSE}
    {$IFDEF WINDOWS}
        begin   //explorer "https://google.com"
          RunProgram.CommandLine := 'explorer "http://192.168.1.129:8080" ';
        end;
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    //end;
    RunProgram.Execute;
    RunProgram.Free;
  end;


end.
