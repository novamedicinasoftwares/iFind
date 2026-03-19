"""
auth.py — Controle de autenticação e sessão Streamlit.
Usa st.session_state para persistir o usuário logado durante a sessão
e um arquivo de token local para "lembrar" o login entre sessões.

FUNCIONALIDADES:
  1. Login normal com usuário e senha
  2. Checkbox "Lembrar-me" — salva token seguro em .auth_token
  3. Na próxima abertura, lê o token e loga automaticamente
  4. Token expira em 30 dias
  5. Logout apaga o token do disco
  6. Token é um hash SHA-256 — nunca salva senha em texto
"""

import streamlit as st
import hashlib
import json
import os
from pathlib import Path
from datetime import datetime, timedelta
from database import verificar_login


# ---------------------------------------------------------------------------
# Configuração do token
# ---------------------------------------------------------------------------

_TOKEN_PATH  = Path(__file__).parent / ".auth_token"
_TOKEN_DIAS  = 30   # token válido por 30 dias


# ---------------------------------------------------------------------------
# Gerenciamento de token local
# ---------------------------------------------------------------------------

def _gerar_token(usuario_id: int, usuario_login: str) -> str:
    """Gera token único e seguro baseado no usuário + timestamp."""
    base = f"{usuario_id}:{usuario_login}:{datetime.now().isoformat()}:{os.urandom(16).hex()}"
    return hashlib.sha256(base.encode()).hexdigest()


def _salvar_token(usuario_id: int, usuario_login: str, nome: str, admin: bool):
    """Salva token no disco com validade de _TOKEN_DIAS dias."""
    token = _gerar_token(usuario_id, usuario_login)
    dados = {
        "token"      : token,
        "usuario_id" : usuario_id,
        "usuario"    : usuario_login,
        "nome"       : nome,
        "admin"      : admin,
        "expira_em"  : (datetime.now() + timedelta(days=_TOKEN_DIAS)).isoformat(),
    }
    try:
        _TOKEN_PATH.write_text(
            json.dumps(dados, ensure_ascii=False),
            encoding="utf-8"
        )
    except Exception:
        pass  # falha silenciosa — login ainda funciona normalmente


def _ler_token() -> dict | None:
    """
    Lê e valida o token salvo no disco.
    Retorna os dados do usuário se válido, None se inválido ou expirado.
    """
    if not _TOKEN_PATH.exists():
        return None
    try:
        dados = json.loads(_TOKEN_PATH.read_text(encoding="utf-8"))
        expira = datetime.fromisoformat(dados["expira_em"])
        if datetime.now() > expira:
            _apagar_token()
            return None
        return dados
    except Exception:
        _apagar_token()
        return None


def _apagar_token():
    """Remove o token do disco."""
    try:
        _TOKEN_PATH.unlink(missing_ok=True)
    except Exception:
        pass


# ---------------------------------------------------------------------------
# Sessão Streamlit
# ---------------------------------------------------------------------------

def inicializar_sessao():
    """
    Garante que todas as chaves de sessão existam com valores padrão.
    Deve ser chamada antes de qualquer leitura do session_state.
    """
    defaults = {
        "usuario_logado" : None,
        "usuario_login"  : None,
        "usuario_id"     : None,
        "usuario_admin"  : False,
    }
    for chave, valor in defaults.items():
        if chave not in st.session_state:
            st.session_state[chave] = valor


def esta_logado() -> bool:
    """Retorna True se há um usuário autenticado na sessão."""
    return st.session_state.get("usuario_logado") is not None


def _aplicar_sessao(dados: dict):
    """
    Preenche o session_state com os dados do usuário.
    Aceita tanto 'id' (vindo do banco via verificar_login)
    quanto 'usuario_id' (vindo do token salvo em disco).
    """
    st.session_state["usuario_logado"] = dados["nome"]
    st.session_state["usuario_login"]  = dados["usuario"]
    st.session_state["usuario_id"]     = dados.get("usuario_id") or dados.get("id")
    st.session_state["usuario_admin"]  = bool(dados.get("admin", False))


def usuario_atual() -> dict | None:
    """
    Retorna dict com os dados do usuário logado ou None se não autenticado.

    Campos:
        id      : int  — ID no banco
        nome    : str  — nome completo
        usuario : str  — login
        admin   : bool — perfil admin
    """
    if not esta_logado():
        return None
    return {
        "id"      : st.session_state.get("usuario_id"),
        "nome"    : st.session_state.get("usuario_logado"),
        "usuario" : st.session_state.get("usuario_login"),
        "admin"   : st.session_state.get("usuario_admin", False),
    }


def fazer_login(usuario: str, senha: str, lembrar: bool = False) -> bool:
    """
    Valida credenciais contra o banco.
    Se lembrar=True, salva token no disco para login automático futuro.
    """
    user = verificar_login(usuario, senha)
    if user:
        _aplicar_sessao(user)
        if lembrar:
            _salvar_token(
                usuario_id    = user["id"],
                usuario_login = user["usuario"],
                nome          = user["nome"],
                admin         = bool(user.get("admin", False)),
            )
        else:
            _apagar_token()  # garante que token antigo seja removido
        return True
    return False


def fazer_logout():
    """
    Limpa a sessão e remove o token salvo (desativa o lembrar-me).
    """
    for chave in ["usuario_logado", "usuario_login", "usuario_id", "usuario_admin"]:
        st.session_state.pop(chave, None)
    _apagar_token()


# ---------------------------------------------------------------------------
# Tela de login
# ---------------------------------------------------------------------------

def tela_login():
    """
    Verifica token salvo → loga automaticamente se válido.
    Caso contrário, exibe o formulário de login.

    Uso no app.py:
        from auth import tela_login, usuario_atual
        tela_login()
        usuario = usuario_atual()
    """
    inicializar_sessao()

    # 1. Já logado nesta sessão — continua normalmente
    if esta_logado():
        return

    # 2. Tem token salvo e válido — loga automaticamente sem mostrar tela
    token_dados = _ler_token()
    if token_dados:
        _aplicar_sessao(token_dados)
        # Renova o token a cada login automático (reinicia o contador de 30 dias)
        _salvar_token(
            usuario_id    = token_dados["usuario_id"],
            usuario_login = token_dados["usuario"],
            nome          = token_dados["nome"],
            admin         = token_dados.get("admin", False),
        )
        return  # continua direto para o app sem mostrar tela de login

    # 3. Sem sessão e sem token — exibe formulário
    st.title("🔍 Buscador de Documentos")
    st.caption("Sistema de busca automática em PDFs — Clínica")
    st.divider()

    col1, col2, col3 = st.columns([1, 2, 1])
    with col2:
        st.subheader("Entrar")

        campo_usuario = st.text_input(
            "Usuário",
            placeholder="seu.usuario",
            key="login_usuario",
        )
        campo_senha = st.text_input(
            "Senha",
            type="password",
            placeholder="••••••••",
            key="login_senha",
        )
        lembrar = st.checkbox(
            "Lembrar-me neste computador",
            value=True,
            key="login_lembrar",
            help=f"Mantém você logado por {_TOKEN_DIAS} dias. "
                 "Desmarque em computadores compartilhados."
        )

        if st.button("Entrar", type="primary", use_container_width=True):
            if not campo_usuario.strip() or not campo_senha.strip():
                st.error("Preencha o usuário e a senha.")
            elif fazer_login(campo_usuario.strip(), campo_senha, lembrar=lembrar):
                st.rerun()
            else:
                st.error("Usuário ou senha incorretos.")

        st.divider()
        st.caption("Primeiro acesso: usuário `admin`, senha `admin123`")
        st.caption("Altere a senha em **Configurações** após o primeiro login.")

    try:
        st.stop()
    except Exception:
        raise