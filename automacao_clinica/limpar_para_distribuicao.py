"""
limpar_para_distribuicao.py
===========================
Limpa todos os dados pessoais e temporários do projeto
antes de gerar o instalador para distribuição.

O que é removido:
  - clinica.db        (histórico de execuções e usuários)
  - config.json       (seus caminhos, configurações SMTP)
  - .auth_token       (token de login salvo)
  - .porta_local      (porta preferida do seu PC)
  - config_tesseract.py (caminho do Tesseract da sua máquina)
  - __pycache__/      (cache do Python)
  - .ocr_*.json       (cache de OCR)
  - *.pyc             (bytecode compilado)
  - update.log        (log de updates)
  - dist_releases/    (pacotes de release gerados)
  - .backups/         (backups de updates)

O que é MANTIDO (necessário para o instalador):
  - Todos os .py
  - iniciar.bat
  - requirements.txt
  - .streamlit/config.toml
  - ifind.ico
  - README.md

Execute ANTES de abrir o Inno Setup para gerar o instalador.
"""

import os
import shutil
import json
from pathlib import Path

PASTA = Path(__file__).parent


def limpar():
    removidos = []
    erros     = []

    def remover(caminho: Path):
        try:
            if caminho.is_dir():
                shutil.rmtree(caminho)
            elif caminho.exists():
                caminho.unlink()
            removidos.append(str(caminho.relative_to(PASTA)))
        except Exception as e:
            erros.append(f"{caminho.name}: {e}")

    print()
    print("=" * 55)
    print("  iFind Clínica — Limpeza para distribuição")
    print("=" * 55)
    print()

    # ── Dados pessoais ─────────────────────────────────────────
    print("  Removendo dados pessoais...")
    remover(PASTA / "clinica.db")
    remover(PASTA / "config.json")
    remover(PASTA / ".auth_token")
    remover(PASTA / ".porta_local")
    remover(PASTA / "update.log")

    # ── config_tesseract.py aponta para o caminho da sua máquina
    # Substitui por uma versão limpa (sem caminho hardcoded)
    cfg_tess = PASTA / "config_tesseract.py"
    if cfg_tess.exists():
        cfg_tess.write_text(
            "# Gerado automaticamente pelo setup_tesseract.py\n"
            "# Este arquivo sera criado na maquina do usuario.\n",
            encoding="utf-8"
        )
        print("  config_tesseract.py → resetado (sem caminho pessoal)")

    # ── Cache Python ───────────────────────────────────────────
    print("  Removendo cache Python...")
    for pycache in PASTA.rglob("__pycache__"):
        # Pula qualquer coisa dentro do .venv — pode estar em uso
        if ".venv" in pycache.parts:
            continue
        try:
            shutil.rmtree(pycache, ignore_errors=True)
            removidos.append(str(pycache.relative_to(PASTA)))
        except Exception:
            pass
    for pyc in PASTA.rglob("*.pyc"):
        if ".venv" in pyc.parts:
            continue
        try:
            pyc.unlink(missing_ok=True)
            removidos.append(str(pyc.relative_to(PASTA)))
        except Exception:
            pass

    # ── Cache OCR ──────────────────────────────────────────────
    print("  Removendo cache OCR...")
    for ocr_cache in PASTA.rglob(".ocr_*.json"):
        remover(ocr_cache)

    # ── Pastas de build/release ────────────────────────────────
    print("  Removendo pastas temporárias...")
    remover(PASTA / "dist_releases")
    remover(PASTA / ".backups")
    remover(PASTA / "dist")       # pasta de output do Inno Setup

    # ── .venv não vai no instalador (é enorme e criada pelo bat)
    # Mas NÃO removemos aqui — só alertamos
    venv = PASTA / ".venv"
    if venv.exists():
        tamanho_mb = sum(
            f.stat().st_size for f in venv.rglob("*") if f.is_file()
        ) // (1024 * 1024)
        print(f"\n  ⚠️  .venv encontrada ({tamanho_mb} MB)")
        print("     O Inno Setup já a ignora (não está na lista [Files]).")
        print("     Se quiser economizar espaço, pode apagar manualmente.")

    # ── Cria um config.json limpo como template ────────────────
    config_limpo = {
        "smtp": {},
        "drive_raiz": "",
        "pasta_destino": "",
        "threshold_fuzzy": 80,
        "filtrar_aso": False,
        "enviar_email_auto": False,
        "email_relatorio": "",
        "modo_extracao": "auto",
        "dpi_ocr": 150,
        "max_workers": 4,
        "varredura_total": False
    }
    with open(PASTA / "config.json", "w", encoding="utf-8") as f:
        json.dump(config_limpo, f, indent=2, ensure_ascii=False)
    print("\n  config.json → criado limpo (sem seus dados pessoais)")

    # ── Resultado ──────────────────────────────────────────────
    print()
    print("=" * 55)
    if removidos:
        print(f"  ✅ {len(removidos)} item(ns) removido(s):")
        for r in removidos:
            print(f"     - {r}")
    else:
        print("  ✅ Nada para remover — projeto já estava limpo.")

    if erros:
        print(f"\n  ⚠️  {len(erros)} erro(s):")
        for e in erros:
            print(f"     - {e}")

    print()
    print("  Projeto pronto para gerar o instalador!")
    print("  Abra o Inno Setup e compile o ifind_setup.iss")
    print("=" * 55)
    print()


if __name__ == "__main__":
    resposta = input("  Isso vai apagar seus dados locais do iFind. Confirma? (s/n): ")
    if resposta.strip().lower() == "s":
        limpar()
    else:
        print("  Operação cancelada.")