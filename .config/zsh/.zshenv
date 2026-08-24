##
# This env is loaded in all environments
##

# Lazy zsh-defer wrapper: loads zsh-defer on first use, falls back to immediate execution
_zsh_defer() {
    if ! typeset -f zsh-defer > /dev/null; then
        local zsh_defer_path="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins/zsh-defer/zsh-defer.plugin.zsh"
        if [[ -f "$zsh_defer_path" ]]; then
            source "$zsh_defer_path"
        else
            # Fallback: run immediately if zsh-defer not available
            zsh-defer() { "$@" }
        fi
    fi
    zsh-defer "$@"
}

# Source cached plugin, regenerate if missing
# Usage: _source_cached <plugin> [defer]
_source_cached() {
    local plugin=$1 defer=$2
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/${plugin}.zsh"
    [[ ! -f "$cache" ]] && zsh-init --$plugin >/dev/null 2>&1
    if [[ -n "$defer" ]]; then
        _zsh_defer source "$cache"
    else
        source "$cache"
    fi
}

# Source file if it exists
# Usage: _source_if_exists <path> [defer]
_source_if_exists() {
    local file=$1 defer=$2
    [[ ! -f "$file" ]] && return
    if [[ -n "$defer" ]]; then
        _zsh_defer source "$file"
    else
        source "$file"
    fi
}

# Define the path to the dotfiles directory
export DOTFILES="${DOTFILES:=$HOME/.dotfiles}"

# Define https://specifications.freedesktop.org/basedir-spec/latest/#variables
export XDG_BIN_HOME="${XDG_BIN_HOME:=$HOME/.local/bin}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:=/etc/xdg}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:=/usr/local/share/:/usr/share/}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:=$TMPDIR/runtime-$UID}"
export XDG_STATE_HOME="${XDG_STATE_HOME:=$HOME/.local/state}"
if [[ ":$PATH:" != *":$XDG_BIN_HOME:"* ]]; then
  export PATH="$XDG_BIN_HOME:$PATH"
fi

# mise installs Homebrew bottles into the canonical prefix without requiring brew.
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local/Cellar ]]; then
  export HOMEBREW_PREFIX="/usr/local"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"
  path=(${path:#"$HOMEBREW_PREFIX/bin"})
  path=(${path:#"$HOMEBREW_PREFIX/sbin"})
  path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
  export PATH
fi

# https://wiki.archlinux.org/title/XDG_user_directories
export XDG_DESKTOP_DIR="${XDG_DESKTOP_DIR:=$HOME/Desktop}"
export XDG_DOCUMENTS_DIR="${XDG_DOCUMENTS_DIR:=$HOME/Documents}"
export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:=$HOME/Downloads}"
export XDG_MUSIC_DIR="${XDG_MUSIC_DIR:=$HOME/Music}"
export XDG_PICTURES_DIR="${XDG_PICTURES_DIR:=$HOME/Pictures}"
export XDG_PUBLICSHARE_DIR="${XDG_PUBLICSHARE_DIR:=$HOME/Public}"
export XDG_VIDEOS_DIR="${XDG_VIDEOS_DIR:=$HOME/Movies}"

# Define paths for common programs with partial XDG support
# https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export LESSHISTFILE="$XDG_STATE_HOME/less_history"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker_machine"
export MYPY_CACHE_DIR="$XDG_CACHE_HOME/mypy"
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
_npm_prefix_path_first() {
  path=("$NPM_CONFIG_PREFIX/bin" ${path:#"$NPM_CONFIG_PREFIX/bin"})
  export PATH
}
_npm_prefix_path_first
export NVM_DIR="$XDG_DATA_HOME/nvm"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"

# General environment variables
export EDITOR="nvim"
export LESSOPEN="|$HOME/.lessfilter %s"
export CLICOLOR=1
export TURBO_UI=true
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--style full --prompt '❯ ' --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up' --cycle"
