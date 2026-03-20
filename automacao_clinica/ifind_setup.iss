; ================================================================
;  iFind Clinica — Inno Setup 6.x
;  Com instalacao automatica do Python 3.11 se necessario.
; ================================================================

#define AppName      "iFind Clinica"
#define AppVersion   "1.0.0"
#define AppPublisher "iFind"
#define AppExeName   "iFind Clinica.exe"
#define AppId        "{{B3C4D5E6-F7A8-9012-BCDE-F12345678901}}"
#define PythonUrl    "https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe"
#define PythonExe    "python-3.11.9-amd64.exe"

[Setup]
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} v{#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={localappdata}\iFind Clinica
DefaultGroupName={#AppName}
OutputDir=dist
OutputBaseFilename=ifind_clinica_v1_setup
SetupIconFile=ifind.ico
UninstallDisplayIcon={app}\ifind.ico
UninstallDisplayName={#AppName}
Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes
WizardStyle=modern
WizardResizable=no
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
UsedUserAreasWarning=no
DisableProgramGroupPage=yes

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Messages]
WelcomeLabel1=Bem-vindo ao instalador do {#AppName}
WelcomeLabel2=Este assistente ira instalar o {#AppName} v{#AppVersion} no seu computador.%n%nTudo sera configurado automaticamente:%n  - Python 3.11 (se necessario)%n  - Dependencias do sistema%n  - Tesseract OCR%n%nClique em Avancar para continuar.
FinishedHeadingLabel=Instalacao concluida!
FinishedLabel=O {#AppName} foi instalado com sucesso.%n%nNa PRIMEIRA execucao aguarde alguns minutos enquanto o sistema instala as dependencias.%n%nLogin padrao:%n  Usuario: admin%n  Senha: admin123

[Tasks]
Name: "desktopicon"; Description: "Criar icone na &Area de Trabalho"; GroupDescription: "Atalhos:"; Flags: checkedonce
Name: "startmenu";   Description: "Criar atalho no &Menu Iniciar";    GroupDescription: "Atalhos:"; Flags: checkedonce

[Files]
Source: "ifind.ico";              DestDir: "{app}"; Flags: ignoreversion
Source: "app.py";                 DestDir: "{app}"; Flags: ignoreversion
Source: "auth.py";                DestDir: "{app}"; Flags: ignoreversion
Source: "database.py";            DestDir: "{app}"; Flags: ignoreversion
Source: "processor.py";           DestDir: "{app}"; Flags: ignoreversion
Source: "mailer.py";              DestDir: "{app}"; Flags: ignoreversion
Source: "updater.py";             DestDir: "{app}"; Flags: ignoreversion
Source: "gerar_release.py";       DestDir: "{app}"; Flags: ignoreversion
Source: "setup_tesseract.py";     DestDir: "{app}"; Flags: ignoreversion
Source: "requirements.txt";       DestDir: "{app}"; Flags: ignoreversion
Source: "iniciar.bat";            DestDir: "{app}"; Flags: ignoreversion
Source: "README.md";              DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: "config_tesseract.py";    DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: ".streamlit\config.toml"; DestDir: "{app}\.streamlit"; Flags: ignoreversion
Source: "config.json";            DestDir: "{app}"; Flags: onlyifdoesntexist skipifsourcedoesntexist
Source: "clinica.db";             DestDir: "{app}"; Flags: onlyifdoesntexist skipifsourcedoesntexist

[Icons]
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\ifind.ico"; Comment: "Abrir iFind Clinica"; Tasks: desktopicon
Name: "{userprograms}\{#AppName}\{#AppName}"; Filename: "{app}\{#AppExeName}"; IconFilename: "{app}\ifind.ico"; Comment: "Abrir iFind Clinica"; Tasks: startmenu
Name: "{userprograms}\{#AppName}\Desinstalar {#AppName}"; Filename: "{uninstallexe}"; Tasks: startmenu

[Run]
Filename: "{app}\{#AppExeName}"; Description: "Iniciar {#AppName} agora"; Flags: nowait postinstall skipifsilent; WorkingDir: "{app}"

[UninstallRun]
Filename: "taskkill.exe"; Parameters: "/F /IM streamlit.exe /T"; Flags: runhidden; RunOnceId: "KillStreamlit"
Filename: "taskkill.exe"; Parameters: "/F /IM python.exe /T";    Flags: runhidden; RunOnceId: "KillPython"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\.venv"
Type: filesandordirs; Name: "{app}\.streamlit"
Type: filesandordirs; Name: "{app}\tesseract_bin"
Type: filesandordirs; Name: "{app}\__pycache__"
Type: files;          Name: "{app}\{#AppExeName}"
Type: files;          Name: "{app}\.auth_token"

[Code]

function PythonOk(): Boolean;
var
  RC: Integer;
begin
  Result := Exec(
    ExpandConstant('{cmd}'),
    '/C python -c "import sys; sys.exit(0 if sys.version_info>=(3,9) else 1)"',
    '', SW_HIDE, ewWaitUntilTerminated, RC
  ) and (RC = 0);
end;

function BaixarArquivo(Url, Destino: String): Boolean;
var
  RC: Integer;
  Cmd: String;
begin
  Cmd := '-NoProfile -NonInteractive -Command "' +
         '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ' +
         '(New-Object Net.WebClient).DownloadFile(' + #39 + Url + #39 + ', ' + #39 + Destino + #39 + ')"';
  Result := Exec('powershell.exe', Cmd, '', SW_HIDE, ewWaitUntilTerminated, RC)
            and (RC = 0);
end;

function InstalarPython(): Boolean;
var
  TempDir, PythonInstaller: String;
  RC: Integer;
  Msg: String;
begin
  Result := False;
  TempDir := ExpandConstant('{tmp}');
  PythonInstaller := TempDir + '\{#PythonExe}';

  WizardForm.StatusLabel.Caption := 'Baixando Python 3.11...';
  WizardForm.ProgressGauge.Style := npbstMarquee;

  if not BaixarArquivo('{#PythonUrl}', PythonInstaller) then
  begin
    Msg := 'Nao foi possivel baixar o Python automaticamente.';
    Msg := Msg + #13#10;
    Msg := Msg + #13#10;
    Msg := Msg + 'Verifique sua conexao com a internet e tente novamente.';
    Msg := Msg + #13#10;
    Msg := Msg + #13#10;
    Msg := Msg + 'Ou instale manualmente em: https://www.python.org/downloads/';
    MsgBox(Msg, mbError, MB_OK);
    Exit;
  end;

  WizardForm.StatusLabel.Caption := 'Instalando Python 3.11...';

  Result := Exec(
    PythonInstaller,
    '/quiet InstallAllUsers=0 PrependPath=1 Include_pip=1 SimpleInstall=1',
    '', SW_HIDE, ewWaitUntilTerminated, RC
  ) and (RC = 0);

  DeleteFile(PythonInstaller);

  if not Result then
  begin
    Msg := 'A instalacao do Python falhou.';
    Msg := Msg + #13#10;
    Msg := Msg + #13#10;
    Msg := Msg + 'Instale manualmente em: https://www.python.org/downloads/';
    Msg := Msg + #13#10;
    Msg := Msg + 'Marque "Add Python to PATH" e execute este instalador novamente.';
    MsgBox(Msg, mbError, MB_OK);
  end;
end;

procedure SalvarArquivoCS(CsSrc: String);
var
  C: String;
begin
  C := 'using System;'                                                                        + #13#10;
  C := C + 'using System.Diagnostics;'                                                       + #13#10;
  C := C + 'using System.IO;'                                                                + #13#10;
  C := C + 'using System.Windows.Forms;'                                                     + #13#10;
  C := C + 'class Program {'                                                                 + #13#10;
  C := C + '    [STAThread]'                                                                 + #13#10;
  C := C + '    static void Main() {'                                                        + #13#10;
  C := C + '        string dir = AppDomain.CurrentDomain.BaseDirectory;'                    + #13#10;
  C := C + '        string bat = Path.Combine(dir, ' + #34 + 'iniciar.bat' + #34 + ');'    + #13#10;
  C := C + '        if (!File.Exists(bat)) {'                                               + #13#10;
  C := C + '            MessageBox.Show(' + #34 + 'iniciar.bat nao encontrado.' + #34 + ',' + #13#10;
  C := C + '                ' + #34 + 'Erro' + #34 + ', MessageBoxButtons.OK, MessageBoxIcon.Error);' + #13#10;
  C := C + '            return;'                                                             + #13#10;
  C := C + '        }'                                                                       + #13#10;
  C := C + '        bool first = !Directory.Exists(Path.Combine(dir, ' + #34 + '.venv' + #34 + '));' + #13#10;
  C := C + '        var p = new ProcessStartInfo();'                                        + #13#10;
  C := C + '        p.FileName = ' + #34 + 'cmd.exe' + #34 + ';'                           + #13#10;
  C := C + '        p.Arguments = ' + #34 + '/c ' + #34 + ' + ' + #34 + #34 + ' + bat + ' + #34 + #34 + ' + ' + #34 + #34 + ';' + #13#10;
  C := C + '        p.WorkingDirectory = dir;'                                              + #13#10;
  C := C + '        if (first) {'                                                           + #13#10;
  C := C + '            p.WindowStyle    = ProcessWindowStyle.Normal;'                     + #13#10;
  C := C + '            p.CreateNoWindow = false;'                                         + #13#10;
  C := C + '            p.UseShellExecute = true;'                                         + #13#10;
  C := C + '        } else {'                                                               + #13#10;
  C := C + '            p.WindowStyle    = ProcessWindowStyle.Hidden;'                     + #13#10;
  C := C + '            p.CreateNoWindow = true;'                                          + #13#10;
  C := C + '            p.UseShellExecute = false;'                                        + #13#10;
  C := C + '        }'                                                                      + #13#10;
  C := C + '        Process.Start(p);'                                                     + #13#10;
  C := C + '    }'                                                                          + #13#10;
  C := C + '}'                                                                              + #13#10;
  SaveStringToFile(CsSrc, C, False);
end;

procedure SalvarScriptPS(ScriptPS, CsSrc, ExeDst, IcoPath: String);
var
  PS: String;
begin
  PS := '$csc = $null'                                                                       + #13#10;
  PS := PS + 'foreach ($fw in @(' + #39 + 'Framework64' + #39 + ',' + #39 + 'Framework' + #39 + ')) {' + #13#10;
  PS := PS + '    $base = "C:\Windows\Microsoft.NET\$fw"'                                   + #13#10;
  PS := PS + '    if (Test-Path $base) {'                                                   + #13#10;
  PS := PS + '        $f = Get-ChildItem $base -Filter ' + #39 + 'csc.exe' + #39 + ' -Recurse -EA SilentlyContinue | Sort-Object FullName -Desc | Select-Object -First 1' + #13#10;
  PS := PS + '        if ($f) { $csc = $f.FullName; break }'                               + #13#10;
  PS := PS + '    }'                                                                        + #13#10;
  PS := PS + '}'                                                                            + #13#10;
  PS := PS + 'if ($csc) {'                                                                  + #13#10;
  PS := PS + '    & $csc /nologo /target:winexe /out:"' + ExeDst + '" /win32icon:"' + IcoPath + '" /reference:System.Windows.Forms.dll "' + CsSrc + '" 2>$null' + #13#10;
  PS := PS + '} else {'                                                                     + #13#10;
  PS := PS + '    $ws = New-Object -ComObject WScript.Shell'                               + #13#10;
  PS := PS + '    $lnk = $ws.CreateShortcut("' + ExeDst + '")'                            + #13#10;
  PS := PS + '    $lnk.TargetPath = "' + ExtractFilePath(CsSrc) + 'iniciar.bat"'         + #13#10;
  PS := PS + '    $lnk.WorkingDirectory = "' + ExtractFilePath(CsSrc) + '"'              + #13#10;
  PS := PS + '    $lnk.IconLocation = "' + IcoPath + '"'                                  + #13#10;
  PS := PS + '    $lnk.Save()'                                                             + #13#10;
  PS := PS + '}'                                                                            + #13#10;
  PS := PS + 'Remove-Item "' + CsSrc + '" -EA SilentlyContinue'                           + #13#10;
  PS := PS + 'Remove-Item "' + ScriptPS + '" -EA SilentlyContinue'                        + #13#10;
  SaveStringToFile(ScriptPS, PS, False);
end;

procedure CriarLauncherExe(AppPath: String);
var
  CsSrc, ExeDst, IcoPath, ScriptPS: String;
  RC: Integer;
begin
  CsSrc    := AppPath + '\launcher_tmp.cs';
  ExeDst   := AppPath + '\iFind Clinica.exe';
  IcoPath  := AppPath + '\ifind.ico';
  ScriptPS := AppPath + '\build_launcher.ps1';
  SalvarArquivoCS(CsSrc);
  SalvarScriptPS(ScriptPS, CsSrc, ExeDst, IcoPath);
  Exec('powershell.exe',
       '-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "' + ScriptPS + '"',
       AppPath, SW_HIDE, ewWaitUntilTerminated, RC);
end;

var
  ProgressPage: TOutputProgressWizardPage;

procedure InitializeWizard();
begin
  ProgressPage := CreateOutputProgressPage(
    'Finalizando instalacao',
    'Aguarde enquanto o launcher e criado...'
  );
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep <> ssPostInstall then Exit;
  ProgressPage.Show;
  try
    ProgressPage.SetText('Criando iFind Clinica.exe...', 'Compilando launcher...');
    ProgressPage.SetProgress(0, 1);
    CriarLauncherExe(ExpandConstant('{app}'));
    ProgressPage.SetProgress(1, 1);
  finally
    ProgressPage.Hide;
  end;
end;

function InitializeSetup(): Boolean;
var
  Msg: String;
begin
  Result := True;

  if PythonOk() then
    Exit;

  Msg := 'Python nao foi encontrado neste computador.';
  Msg := Msg + #13#10;
  Msg := Msg + #13#10;
  Msg := Msg + 'O instalador ira baixar e instalar o Python 3.11 automaticamente.';
  Msg := Msg + #13#10;
  Msg := Msg + #13#10;
  Msg := Msg + 'Isso requer conexao com a internet e pode levar alguns minutos.';
  Msg := Msg + #13#10;
  Msg := Msg + #13#10;
  Msg := Msg + 'Clique em OK para continuar.';
  MsgBox(Msg, mbInformation, MB_OK);

  if not InstalarPython() then
  begin
    Result := False;
    Exit;
  end;

  if not PythonOk() then
  begin
    Msg := 'Python instalado com sucesso!';
    Msg := Msg + #13#10;
    Msg := Msg + #13#10;
    Msg := Msg + 'IMPORTANTE: Ao abrir o iFind Clinica pela primeira vez,';
    Msg := Msg + #13#10;
    Msg := Msg + 'feche e reabra o atalho caso apareca algum erro.';
    Msg := Msg + #13#10;
    Msg := Msg + #13#10;
    Msg := Msg + 'Isso acontece porque o Windows precisa de uma nova sessao';
    Msg := Msg + #13#10;
    Msg := Msg + 'para reconhecer o Python recem instalado.';
    MsgBox(Msg, mbInformation, MB_OK);
  end;
end;
