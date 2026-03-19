"""
gerar_release.py — Gera o pacote de update para publicar no servidor
=====================================================================

USE:
    python gerar_release.py 2.1.0

O script:
  1. Lê a versão como argumento
  2. Empacota os arquivos do projeto em ifind_v2.1.0.zip
  3. Calcula o SHA256 do zip
  4. Gera/atualiza o version.json
  5. Mostra o que publicar e onde

Execute na pasta do projeto antes de cada release.
"""

import hashlib
import json
import sys
import zipfile
from pathlib import Path
from datetime import datetime

# ── Arquivos incluídos no pacote de update ─────────────────────
# NÃO inclua config.json, clinica.db, .auth_token — são dados do usuário
ARQUIVOS_INCLUIR = [
    "app.py",
    "auth.py",
    "database.py",
    "processor.py",
    "mailer.py",
    "setup_tesseract.py",
    "updater.py",
    "requirements.txt",
    "iniciar.bat",
    "README.md",
]

PASTAS_INCLUIR = [
    (".streamlit", ["config.toml"]),
]

# ── URL base onde você vai hospedar os arquivos ────────────────
# Troque pelo seu GitHub ou servidor
URL_BASE = "https://raw.githubusercontent.com/seu-usuario/ifind-clinica/releases/download"


def calcular_sha256(caminho: Path) -> str:
    sha256 = hashlib.sha256()
    with open(caminho, "rb") as f:
        for bloco in iter(lambda: f.read(65536), b""):
            sha256.update(bloco)
    return sha256.hexdigest()


def gerar_release(versao: str, notas: str = "", obrigatorio: bool = False):
    pasta_projeto = Path(__file__).parent
    pasta_dist    = pasta_projeto / "dist_releases"
    pasta_dist.mkdir(exist_ok=True)

    nome_zip = f"ifind_v{versao}.zip"
    caminho_zip = pasta_dist / nome_zip
    caminho_json = pasta_dist / "version.json"

    print(f"\n{'='*55}")
    print(f"  iFind Clínica — Gerando release v{versao}")
    print(f"{'='*55}\n")

    # ── Cria o ZIP ─────────────────────────────────────────────
    incluidos = []
    ausentes  = []

    with zipfile.ZipFile(caminho_zip, "w", zipfile.ZIP_DEFLATED) as zf:
        for nome in ARQUIVOS_INCLUIR:
            caminho = pasta_projeto / nome
            if caminho.exists():
                zf.write(caminho, nome)
                incluidos.append(nome)
                print(f"  ✓ {nome}")
            else:
                ausentes.append(nome)
                print(f"  ⚠ {nome} — não encontrado (pulado)")

        for pasta, arquivos in PASTAS_INCLUIR:
            for arq in arquivos:
                caminho = pasta_projeto / pasta / arq
                nome_no_zip = f"{pasta}/{arq}"
                if caminho.exists():
                    zf.write(caminho, nome_no_zip)
                    incluidos.append(nome_no_zip)
                    print(f"  ✓ {nome_no_zip}")
                else:
                    ausentes.append(nome_no_zip)
                    print(f"  ⚠ {nome_no_zip} — não encontrado (pulado)")

    tamanho_kb = caminho_zip.stat().st_size // 1024
    print(f"\n  ZIP gerado: {caminho_zip.name} ({tamanho_kb} KB)")

    # ── SHA256 ─────────────────────────────────────────────────
    sha256 = calcular_sha256(caminho_zip)
    print(f"  SHA256: {sha256}")

    # ── version.json ───────────────────────────────────────────
    url_zip = f"{URL_BASE}/v{versao}/{nome_zip}"

    dados_versao = {
        "version":     versao,
        "url":         url_zip,
        "hash_sha256": sha256,
        "notas":       notas or f"Atualização v{versao}",
        "obrigatorio": obrigatorio,
        "gerado_em":   datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "arquivos":    incluidos,
    }

    with open(caminho_json, "w", encoding="utf-8") as f:
        json.dump(dados_versao, f, indent=2, ensure_ascii=False)

    print(f"  version.json gerado: {caminho_json}")

    # ── Instruções ─────────────────────────────────────────────
    print(f"""
{'='*55}
  PRÓXIMOS PASSOS — Publicar o update:
{'='*55}

  Opção A — GitHub Releases (recomendado, gratuito):
  ───────────────────────────────────────────────────
  1. Acesse: https://github.com/seu-usuario/ifind-clinica/releases/new
  2. Tag: v{versao}
  3. Faça upload de: {nome_zip}
  4. No arquivo updater.py, a VERSION_URL deve apontar para o
     version.json hospedado (ex: GitHub raw ou Gist).
  5. Publique o version.json em:
     https://raw.githubusercontent.com/seu-usuario/ifind-clinica/main/version.json

  Opção B — Servidor próprio / VPS:
  ───────────────────────────────────────────────────
  1. Envie via FTP/SFTP:
       dist_releases/{nome_zip}  →  /var/www/html/ifind/
       dist_releases/version.json → /var/www/html/ifind/
  2. Atualize VERSION_URL em updater.py para apontar para o JSON.

  Opção C — Google Drive / OneDrive (simples):
  ───────────────────────────────────────────────────
  1. Faça upload dos dois arquivos e gere link público.
  2. Use o link direto (raw) no VERSION_URL do updater.py.

  ATENÇÃO: Após publicar, atualize VERSION em updater.py
  para a próxima versão ANTES de compilar o próximo release.
{'='*55}
""")

    if ausentes:
        print(f"  ⚠ Arquivos ausentes não incluídos: {', '.join(ausentes)}\n")

    return caminho_zip, caminho_json


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python gerar_release.py <versao> [notas] [--obrigatorio]")
        print("Ex:  python gerar_release.py 2.1.0 'Correção de caminhos e varredura total'")
        sys.exit(1)

    versao = sys.argv[1]
    notas  = sys.argv[2] if len(sys.argv) > 2 and not sys.argv[2].startswith("--") else ""
    obrig  = "--obrigatorio" in sys.argv

    gerar_release(versao, notas, obrig)
