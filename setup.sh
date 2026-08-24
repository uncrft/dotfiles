#!/bin/sh
set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
MISE_BIN=${MISE_BIN:-"$HOME/.local/bin/mise"}

if [ ! -x "$MISE_BIN" ]; then
    echo "Installing mise..."
    curl --proto '=https' --tlsv1.2 -fsSL https://mise.run | MISE_INSTALL_PATH="$MISE_BIN" sh
fi

MISE_CONFIG="$HOME/.config/mise/config.toml"
MISE_CONFIG_SOURCE="$DOTFILES_DIR/.config/mise/config.toml"
mkdir -p "$(dirname "$MISE_CONFIG")"

if [ -e "$MISE_CONFIG" ] || [ -L "$MISE_CONFIG" ]; then
    existing_source=$(readlink "$MISE_CONFIG" 2>/dev/null || true)
    if [ "$existing_source" = "$DOTFILES_DIR/mise.toml" ]; then
        ln -sfn "$MISE_CONFIG_SOURCE" "$MISE_CONFIG"
    elif [ "$existing_source" != "$MISE_CONFIG_SOURCE" ]; then
        echo "Refusing to replace existing mise config: $MISE_CONFIG" >&2
        exit 1
    fi
else
    ln -s "$MISE_CONFIG_SOURCE" "$MISE_CONFIG"
fi

cd "$DOTFILES_DIR"
"$MISE_BIN" trust mise.toml
"$MISE_BIN" trust "$MISE_CONFIG"
exec "$MISE_BIN" bootstrap "$@"
