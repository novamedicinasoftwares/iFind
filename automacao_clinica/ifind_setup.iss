; ================================================================
;  iFind Clinica — Inno Setup 6.x
;  Versao limpa e robusta — sem compilacao C# em runtime
;
;  Fluxo:
;    1. Verifica Python 3.9+ no sistema
;    2. Se nao tiver, baixa e instala Python 3.11 automaticamente
;    3. Copia todos os arquivos do sistema
;    4. Cria atalhos que chamam: pythonw.exe launcher.py
;    5. Na primeira execucao, launcher.py instala dependencias com UI
;
;  Por que pythonw.exe direto (sem .exe wrapper):
;    - Sem dependencia de csc.exe / .NET Framework para compilar
;    - Sem risco de .exe nao ser gerado silenciosamente
;    - Funciona em todo Windows com Python instalado
;    - O launcher.py ja tem interface grafica propria (tkinter)
;    - pythonw.exe = Python sem janela de terminal preta
; ================================================================

#define AppName      "iFind Clinica"
#define AppVersion   "2.0"
#define AppPublisher "iFind"
#define AppId        "{{B3C4D5E6-F7A8-9012-BCDE-F12345678901}}"
#define PythonUrl    "https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe"
#define PythonExe    "python-3.11.9-amd64.exe"
#define LauncherPy   "launcher.py"

[Setup]
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} v{#AppVersion}
AppPublisher={#AppPublisher}
<<<<<<< HEAD
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
=======

; Instala em AppData do usuario — sem precisar de admin
DefaultDirName={localappdata}\iFind Clinica
DefaultGroupName={#AppName}

OutputDir=dist
OutputBaseFilename=ifind_clinica_v2_setup
SetupIconFile=ifind.ico
UninstallDisplayIcon={app}\ifind.ico
UninstallDisplayName={#AppName}

; Compressao maxima
Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes

; Visual
WizardStyle=modern
WizardResizable=no

; Nao precisa de admin (instala em AppData)
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
UsedUserAreasWarning=no
DisableProgramGroupPage=yes

<<<<<<< HEAD
=======
; Nao exige reinicializacao
RestartIfNeededByRun=no

>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Messages]
<<<<<<< HEAD
WelcomeLabel1=Bem-vindo ao instalador do {#AppName}
WelcomeLabel2=Este assistente ira instalar o {#AppName} v{#AppVersion} no seu computador.%n%nTudo sera configurado automaticamente:%n  - Python 3.11 (se necessario)%n  - Dependencias do sistema%n  - Tesseract OCR%n%nClique em Avancar para continuar.
FinishedHeadingLabel=Instalacao concluida!
FinishedLabel=O {#AppName} foi instalado com sucesso.%n%nNa PRIMEIRA execucao aguarde alguns minutos enquanto o sistema instala as dependencias.%n%nLogin padrao:%n  Usuario: admin%n  Senha: admin123
=======
WelcomeLabel1=Bem-vindo ao {#AppName}
WelcomeLabel2=Este assistente ira instalar o {#AppName} v{#AppVersion}.%n%nO instalador configura tudo automaticamente:%n%n  - Python 3.11 (se necessario)%n  - Dependencias Python (na primeira execucao)%n  - Tesseract OCR (na primeira execucao)%n%nClique em Avancar para continuar.
FinishedHeadingLabel=Instalacao concluida!
FinishedLabel=O {#AppName} foi instalado com sucesso.%n%nNA PRIMEIRA EXECUCAO: aguarde alguns minutos enquanto o sistema instala as dependencias automaticamente. Uma janela de progresso sera exibida.%n%nLogin padrao:%n  Usuario: admin%n  Senha:   admin123%n%nAltere a senha em Configuracoes apos o primeiro acesso.
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d

[Tasks]
Name: "desktopicon"; Description: "Criar icone na &Area de Trabalho"; GroupDescription: "Atalhos:"; Flags: checkedonce
Name: "startmenu";   Description: "Criar atalho no &Menu Iniciar";    GroupDescription: "Atalhos:"; Flags: checkedonce

<<<<<<< HEAD
[Files]
Source: "ifind.ico";              DestDir: "{app}"; Flags: ignoreversion
=======
; ================================================================
; ARQUIVOS
; Todos os .py do sistema + assets + configs padrao
; ================================================================
[Files]

; ── Launcher (ponto de entrada principal) ──────────────────────
Source: "launcher.py";            DestDir: "{app}"; Flags: ignoreversion

; ── Modulos do sistema ─────────────────────────────────────────
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
Source: "app.py";                 DestDir: "{app}"; Flags: ignoreversion
Source: "auth.py";                DestDir: "{app}"; Flags: ignoreversion
Source: "database.py";            DestDir: "{app}"; Flags: ignoreversion
Source: "processor.py";           DestDir: "{app}"; Flags: ignoreversion
Source: "mailer.py";              DestDir: "{app}"; Flags: ignoreversion
Source: "updater.py";             DestDir: "{app}"; Flags: ignoreversion
<<<<<<< HEAD
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
=======

; ── Instaladores e setup ───────────────────────────────────────
Source: "setup_tesseract.py";     DestDir: "{app}"; Flags: ignoreversion
Source: "requirements.txt";       DestDir: "{app}"; Flags: ignoreversion
Source: "iniciar.bat";            DestDir: "{app}"; Flags: ignoreversion

; ── Assets ─────────────────────────────────────────────────────
Source: "ifind.ico";              DestDir: "{app}"; Flags: ignoreversion

; ── Documentacao ───────────────────────────────────────────────
Source: "README.md";              DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: "gerar_release.py";       DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist
Source: "limpar_para_distribuicao.py"; DestDir: "{app}"; Flags: ignoreversion skipifsourcedoesntexist

; ── Streamlit config ───────────────────────────────────────────
Source: ".streamlit\config.toml"; DestDir: "{app}\.streamlit"; Flags: ignoreversion skipifsourcedoesntexist

; ── Configuracao Tesseract (limpa — sem caminho pessoal) ───────
; Sempre sobrescreve: o config_tesseract.py da distribuicao e vazio,
; o launcher.py cria o correto automaticamente na maquina do usuario
Source: "config_tesseract.py";    DestDir: "{app}"; Flags: ignoreversion

; ── Config e banco — so instala se nao existir (preserva dados do usuario) ──
Source: "config.json";            DestDir: "{app}"; Flags: onlyifdoesntexist skipifsourcedoesntexist
; NOTA: clinica.db NAO deve ser distribuido — o sistema cria automaticamente

; ================================================================
; ATALHOS
; Usam pythonw.exe (sem terminal preto) para chamar launcher.py
;
; Por que nao usar um .exe wrapper?
;   O .exe seria compilado em runtime via csc.exe, o que:
;     - Depende do .NET Framework SDK no PATH (pode nao existir)
;     - Pode falhar silenciosamente sem nenhuma mensagem de erro
;     - Cria um arquivo temporario que precisa ser compilado e assinado
;   Usando pythonw.exe diretamente:
;     - Funciona em qualquer Windows com Python instalado
;     - Zero dependencias extras
;     - launcher.py ja tem icone, titulo e interface propria (tkinter)
; ================================================================
[Icons]

; Area de Trabalho
    Name: "{userdesktop}\{#AppName}";
    Filename: "{code:GetPythonW}";
    Parameters: """{app}\{#LauncherPy}""";
    WorkingDir: "{app}";
    IconFilename: "{app}\ifind.ico";
    Comment: "Abrir iFind Clinica";
    Tasks: desktopicon

; Menu Iniciar — atalho principal
Name: "{userprograms}\{#AppName}\{#AppName}";
    Filename: "{code:GetPythonW}";
    Parameters: """{app}\{#LauncherPy}""";
    WorkingDir: "{app}";
    IconFilename: "{app}\ifind.ico";
    Comment: "Abrir iFind Clinica";
    Tasks: startmenu

; Menu Iniciar — iniciar.bat (fallback com terminal visivel para debug)
Name: "{userprograms}\{#AppName}\{#AppName} (modo terminal)";
    Filename: "{app}\iniciar.bat";
    WorkingDir: "{app}";
    IconFilename: "{app}\ifind.ico";
    Comment: "Abrir iFind Clinica com terminal visivel (debug)";
    Tasks: startmenu

; Menu Iniciar — desinstalar
Name: "{userprograms}\{#AppName}\Desinstalar {#AppName}";
    Filename: "{uninstallexe}";
    Tasks: startmenu

; ================================================================
; EXECUCAO POS-INSTALACAO
; Abre o launcher automaticamente ao terminar
; ================================================================
[Run]
Filename: "{code:GetPythonW}";
    Parameters: """{app}\{#LauncherPy}""";
    WorkingDir: "{app}";
    Description: "Iniciar {#AppName} agora";
    Flags: nowait postinstall skipifsilent

; ================================================================
; DESINSTALACAO
; ================================================================
[UninstallRun]
; Encerra processos antes de desinstalar
Filename: "taskkill.exe"; Parameters: "/F /IM streamlit.exe /T";  Flags: runhidden; RunOnceId: "KillStreamlit"
Filename: "taskkill.exe"; Parameters: "/F /IM python.exe /T";     Flags: runhidden; RunOnceId: "KillPython"
Filename: "taskkill.exe"; Parameters: "/F /IM pythonw.exe /T";    Flags: runhidden; RunOnceId: "KillPythonW"

[UninstallDelete]
; Remove apenas o que o sistema criou — preserva dados do usuario (db, config)
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
Type: filesandordirs; Name: "{app}\.venv"
Type: filesandordirs; Name: "{app}\.streamlit"
Type: filesandordirs; Name: "{app}\tesseract_bin"
Type: filesandordirs; Name: "{app}\__pycache__"
<<<<<<< HEAD
Type: files;          Name: "{app}\{#AppExeName}"
Type: files;          Name: "{app}\.auth_token"

[Code]

=======
Type: filesandordirs; Name: "{app}\.backups"
Type: filesandordirs; Name: "{app}\dist_releases"
Type: files;          Name: "{app}\.auth_token"
Type: files;          Name: "{app}\.porta_local"
Type: files;          Name: "{app}\update.log"

; ================================================================
; CODIGO PASCAL — logica de instalacao
; ================================================================
[Code]

var
  PythonWPath: String;   // caminho do pythonw.exe encontrado
  ProgressPage: TOutputProgressWizardPage;

// ── Busca pythonw.exe em todos os locais possiveis ─────────────
//
// Ordem de busca:
//   1. PATH do sistema (onde(), equivalente a 'where pythonw')
//   2. Registro — HKCU\Software\Python\PythonCore (instalacao do usuario)
//   3. Registro — HKLM\Software\Python\PythonCore (instalacao global)
//   4. Caminhos fixos mais comuns no Windows
//
// Retorna True e preenche PythonWPath se encontrado.
function BuscarPythonW(): Boolean;
var
  Vers: TArrayOfString;
  i: Integer;
  TestPath, RegBase, RegKey: String;
  Candidatos: TArrayOfString;
begin
  Result := False;
  PythonWPath := '';

  // Lista de versoes para verificar no registro (mais novas primeiro)
  Vers := ['3.12', '3.11', '3.10', '3.9'];

  // ── Verifica via registro do Windows ───────────────────────
  for i := 0 to GetArrayLength(Vers) - 1 do
  begin
    RegBase := 'Software\Python\PythonCore\' + Vers[i] + '\InstallPath';

    // Registro do usuario atual (sem admin)
    if RegQueryStringValue(HKCU, RegBase, '', TestPath) then
    begin
      TestPath := AddBackslash(TestPath) + 'pythonw.exe';
      if FileExists(TestPath) then
      begin
        PythonWPath := TestPath;
        Result := True;
        Exit;
      end;
    end;

    // Registro global (com admin — instalacao para todos)
    if RegQueryStringValue(HKLM, RegBase, '', TestPath) then
    begin
      TestPath := AddBackslash(TestPath) + 'pythonw.exe';
      if FileExists(TestPath) then
      begin
        PythonWPath := TestPath;
        Result := True;
        Exit;
      end;
    end;
  end;

  // ── Caminhos fixos comuns (fallback) ───────────────────────
  SetArrayLength(Candidatos, 12);
  Candidatos[0]  := ExpandConstant('{localappdata}\Programs\Python\Python312\pythonw.exe');
  Candidatos[1]  := ExpandConstant('{localappdata}\Programs\Python\Python311\pythonw.exe');
  Candidatos[2]  := ExpandConstant('{localappdata}\Programs\Python\Python310\pythonw.exe');
  Candidatos[3]  := ExpandConstant('{localappdata}\Programs\Python\Python39\pythonw.exe');
  Candidatos[4]  := 'C:\Python312\pythonw.exe';
  Candidatos[5]  := 'C:\Python311\pythonw.exe';
  Candidatos[6]  := 'C:\Python310\pythonw.exe';
  Candidatos[7]  := 'C:\Python39\pythonw.exe';
  Candidatos[8]  := ExpandConstant('{autopf64}\Python312\pythonw.exe');
  Candidatos[9]  := ExpandConstant('{autopf64}\Python311\pythonw.exe');
  Candidatos[10] := ExpandConstant('{autopf}\Python312\pythonw.exe');
  Candidatos[11] := ExpandConstant('{autopf}\Python311\pythonw.exe');

  for i := 0 to GetArrayLength(Candidatos) - 1 do
  begin
    if FileExists(Candidatos[i]) then
    begin
      PythonWPath := Candidatos[i];
      Result := True;
      Exit;
    end;
  end;
end;

// ── Callback usado em [Icons] e [Run] para obter pythonw.exe ───
// O Inno Setup chama {code:GetPythonW} para substituir o Filename
function GetPythonW(Param: String): String;
begin
  if PythonWPath <> '' then
    Result := PythonWPath
  else
  begin
    // Ultimo recurso — usa pythonw do PATH (funciona se Python esta no PATH)
    Result := 'pythonw.exe';
  end;
end;

// ── Verifica se Python 3.9+ esta instalado e acessivel ─────────
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
function PythonOk(): Boolean;
var
  RC: Integer;
begin
<<<<<<< HEAD
  Result := Exec(
    ExpandConstant('{cmd}'),
    '/C python -c "import sys; sys.exit(0 if sys.version_info>=(3,9) else 1)"',
=======
  // Testa via registro primeiro (mais confiavel)
  if BuscarPythonW() then
  begin
    // Verifica a versao
    Result := Exec(
      PythonWPath,
      '-c "import sys; exit(0 if sys.version_info>=(3,9) else 1)"',
      '', SW_HIDE, ewWaitUntilTerminated, RC
    ) and (RC = 0);
    if Result then Exit;
  end;

  // Fallback: testa via cmd/PATH
  Result := Exec(
    ExpandConstant('{cmd}'),
    '/C python -c "import sys; exit(0 if sys.version_info>=(3,9) else 1)"',
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
    '', SW_HIDE, ewWaitUntilTerminated, RC
  ) and (RC = 0);
end;

<<<<<<< HEAD
function BaixarArquivo(Url, Destino: String): Boolean;
var
  RC: Integer;
  Cmd: String;
begin
  Cmd := '-NoProfile -NonInteractive -Command "' +
         '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ' +
         '(New-Object Net.WebClient).DownloadFile(' + #39 + Url + #39 + ', ' + #39 + Destino + #39 + ')"';
=======
// ── Baixa arquivo via PowerShell ───────────────────────────────
// Usa TLS 1.2 explicitamente (necessario em Windows 7/8 mais antigos)
function BaixarArquivo(Url, Destino: String): Boolean;
var
  RC: Integer;
  Cmd, Q: String;
begin
  Q   := Chr(39);  // aspas simples — evita conflito com preprocessador do ISS
  Cmd := '-NoProfile -NonInteractive -Command "' +
         '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ' +
         '$wc = New-Object Net.WebClient; ' +
         '$wc.Headers.Add(' + Q + 'User-Agent' + Q + ',' + Q + 'iFind-Setup/2.0' + Q + '); ' +
         '$wc.DownloadFile(' + Q + Url + Q + ',' + Q + Destino + Q + ')"';
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
  Result := Exec('powershell.exe', Cmd, '', SW_HIDE, ewWaitUntilTerminated, RC)
            and (RC = 0);
end;

<<<<<<< HEAD
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
=======
// ── Instala Python 3.11 silenciosamente ────────────────────────
//
// Flags do instalador oficial do Python:
//   InstallAllUsers=0  → instala so para o usuario atual (sem admin)
//   PrependPath=1      → adiciona Python ao PATH automaticamente
//   Include_pip=1      → garante que pip seja instalado
//   SimpleInstall=1    → pula todas as telas de configuracao
//   Include_launcher=0 → pula o Python Launcher (nao necessario)
//
function InstalarPython(): Boolean;
var
  TempDir, Instalador: String;
  RC: Integer;
begin
  Result := False;
  TempDir   := ExpandConstant('{tmp}');
  Instalador := TempDir + '\{#PythonExe}';

  WizardForm.StatusLabel.Caption := 'Baixando Python 3.11... (pode levar alguns minutos)';
  WizardForm.ProgressGauge.Style := npbstMarquee;

  if not BaixarArquivo('{#PythonUrl}', Instalador) then
  begin
    MsgBox(
      'Nao foi possivel baixar o Python 3.11.' + #13#10 + #13#10 +
      'Verifique sua conexao com a internet e tente novamente.' + #13#10 + #13#10 +
      'Ou instale manualmente em: https://www.python.org/downloads/' + #13#10 +
      'Marque "Add Python to PATH" durante a instalacao.',
      mbError, MB_OK
    );
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
    Exit;
  end;

  WizardForm.StatusLabel.Caption := 'Instalando Python 3.11...';

  Result := Exec(
<<<<<<< HEAD
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

=======
    Instalador,
    '/quiet InstallAllUsers=0 PrependPath=1 Include_pip=1 ' +
    'SimpleInstall=1 Include_launcher=0',
    '', SW_HIDE, ewWaitUntilTerminated, RC
  ) and (RC = 0);

  // Remove o instalador temporario independente do resultado
  DeleteFile(Instalador);

  if not Result then
  begin
    MsgBox(
      'A instalacao do Python falhou (codigo: ' + IntToStr(RC) + ').' + #13#10 + #13#10 +
      'Instale manualmente em: https://www.python.org/downloads/' + #13#10 +
      'Marque "Add Python to PATH" e execute este instalador novamente.',
      mbError, MB_OK
    );
    Exit;
  end;

  // Atualiza PythonWPath apos instalacao bem-sucedida
  BuscarPythonW();
end;

// ── Cria o .streamlit/config.toml se nao existir ───────────────
// Garante que o Streamlit use as configuracoes corretas de tema
procedure CriarStreamlitConfig(AppPath: String);
var
  ConfigDir, ConfigFile, Conteudo: String;
begin
  ConfigDir  := AppPath + '\.streamlit';
  ConfigFile := ConfigDir + '\config.toml';

  if FileExists(ConfigFile) then Exit;  // ja existe — nao sobrescreve

  ForceDirectories(ConfigDir);

  Conteudo := '[theme]'                                        + #13#10;
  Conteudo := Conteudo + 'base = "light"'                     + #13#10;
  Conteudo := Conteudo + 'primaryColor = "#1D9E75"'           + #13#10;
  Conteudo := Conteudo + 'backgroundColor = "#FFFFFF"'        + #13#10;
  Conteudo := Conteudo + 'secondaryBackgroundColor = "#F1EFE8"' + #13#10;
  Conteudo := Conteudo + 'textColor = "#2C2C2A"'              + #13#10;
  Conteudo := Conteudo + 'font = "sans serif"'                + #13#10;
  Conteudo := Conteudo + ''                                   + #13#10;
  Conteudo := Conteudo + '[server]'                           + #13#10;
  Conteudo := Conteudo + 'headless = true'                    + #13#10;
  Conteudo := Conteudo + 'fileWatcherType = "none"'           + #13#10;
  Conteudo := Conteudo + ''                                   + #13#10;
  Conteudo := Conteudo + '[browser]'                          + #13#10;
  Conteudo := Conteudo + 'gatherUsageStats = false'           + #13#10;

  SaveStringToFile(ConfigFile, Conteudo, False);
end;

// ── Cria o config.json limpo se nao existir ────────────────────
procedure CriarConfigJson(AppPath: String);
var
  ConfigFile, Conteudo: String;
begin
  ConfigFile := AppPath + '\config.json';
  if FileExists(ConfigFile) then Exit;  // preserva dados do usuario

  Conteudo := '{'                                   + #13#10;
  Conteudo := Conteudo + '  "smtp": {},'            + #13#10;
  Conteudo := Conteudo + '  "drive_raiz": "",'      + #13#10;
  Conteudo := Conteudo + '  "pasta_destino": "",'   + #13#10;
  Conteudo := Conteudo + '  "threshold_fuzzy": 80,' + #13#10;
  Conteudo := Conteudo + '  "filtrar_aso": false,'  + #13#10;
  Conteudo := Conteudo + '  "enviar_email_auto": false,' + #13#10;
  Conteudo := Conteudo + '  "email_relatorio": "",' + #13#10;
  Conteudo := Conteudo + '  "modo_extracao": "auto",' + #13#10;
  Conteudo := Conteudo + '  "dpi_ocr": 150,'        + #13#10;
  Conteudo := Conteudo + '  "max_workers": 4,'      + #13#10;
  Conteudo := Conteudo + '  "varredura_total": false' + #13#10;
  Conteudo := Conteudo + '}'                        + #13#10;

  SaveStringToFile(ConfigFile, Conteudo, False);
end;

// ── config_tesseract.py limpo (sem caminho do desenvolvedor) ───
procedure LimparConfigTesseract(AppPath: String);
var
  ConfigFile, Conteudo: String;
begin
  ConfigFile := AppPath + '\config_tesseract.py';

  // Sempre sobrescreve com versao limpa
  // O launcher.py vai preencher com o caminho correto na maquina do usuario
  Conteudo := '# Gerado automaticamente pelo setup_tesseract.py' + #13#10;
  Conteudo := Conteudo + '# Este arquivo sera criado na maquina do usuario.' + #13#10;

  SaveStringToFile(ConfigFile, Conteudo, False);
end;

// ── Inicializa o wizard ────────────────────────────────────────
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
procedure InitializeWizard();
begin
  ProgressPage := CreateOutputProgressPage(
    'Finalizando instalacao',
<<<<<<< HEAD
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
=======
    'Configurando arquivos do sistema...'
  );
end;

// ── Executa apos copiar todos os arquivos ──────────────────────
procedure CurStepChanged(CurStep: TSetupStep);
var
  AppPath: String;
begin
  if CurStep <> ssPostInstall then Exit;

  AppPath := ExpandConstant('{app}');

  ProgressPage.Show;
  try
    ProgressPage.SetText('Criando configuracoes padrao...', '');
    ProgressPage.SetProgress(0, 3);

    // Cria .streamlit/config.toml se nao existir
    CriarStreamlitConfig(AppPath);
    ProgressPage.SetProgress(1, 3);

    // Cria config.json limpo se nao existir
    CriarConfigJson(AppPath);
    ProgressPage.SetProgress(2, 3);

    // Garante que config_tesseract.py esta limpo (sem caminho do dev)
    LimparConfigTesseract(AppPath);
    ProgressPage.SetProgress(3, 3);

>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
  finally
    ProgressPage.Hide;
  end;
end;

<<<<<<< HEAD
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
=======
// ── Ponto de entrada do wizard — roda antes de tudo ────────────
//
// Logica:
//   1. Tenta encontrar Python 3.9+ no sistema
//   2. Se nao encontrar, oferece instalar automaticamente
//   3. Instalacao do Python e silenciosa (sem janelas extras)
//   4. Apos instalar, atualiza PythonWPath para os atalhos usarem
//
function InitializeSetup(): Boolean;
begin
  Result := True;

  // Ja tem Python 3.9+ — tudo certo, continua normalmente
  if PythonOk() then Exit;

  // Python nao encontrado — instala automaticamente
  MsgBox(
    'Python nao foi encontrado neste computador.' + #13#10 + #13#10 +
    'O instalador ira baixar e instalar o Python 3.11 automaticamente.' + #13#10 + #13#10 +
    'Isso requer conexao com a internet e pode levar alguns minutos.' + #13#10 + #13#10 +
    'Clique em OK para continuar.',
    mbInformation, MB_OK
  );

  if not InstalarPython() then
  begin
    // Python nao instalado — aborta
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
    Result := False;
    Exit;
  end;

<<<<<<< HEAD
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
=======
  // Verifica novamente apos instalacao
  if not PythonOk() then
  begin
    // PATH nao atualizado nesta sessao — normal no Windows
    // O launcher.py lida com isso via busca em caminhos fixos
    MsgBox(
      'Python instalado com sucesso!' + #13#10 + #13#10 +
      'IMPORTANTE: ao abrir o iFind pela primeira vez, caso' + #13#10 +
      'apareça algum erro, feche e abra novamente.' + #13#10 + #13#10 +
      'Isso acontece porque o Windows precisa atualizar' + #13#10 +
      'o PATH apos instalar um novo programa.',
      mbInformation, MB_OK
    );
    // Continua mesmo assim — launcher.py encontra o Python
>>>>>>> a407495f46f05c77ba4476b7dcb3ef060667606d
  end;
end;
