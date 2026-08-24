# env.nu
#
# Environment configuration for Nushell
# Loaded before config.nu and login.nu
#
# This file sets up XDG directories and environment variables

##
# Homebrew bottle prefix
##
# mise installs the remaining native packages into the canonical prefix.
$env.HOMEBREW_PREFIX = if ("/opt/homebrew" | path exists) {
    "/opt/homebrew"
} else {
    "/usr/local"
}
$env.HOMEBREW_CELLAR = ($env.HOMEBREW_PREFIX | path join "Cellar")
$env.HOMEBREW_REPOSITORY = $env.HOMEBREW_PREFIX
$env.MANPATH = $"($env.HOMEBREW_PREFIX)/share/man($env.MANPATH? | default '' | prepend ':')"
$env.INFOPATH = $"($env.HOMEBREW_PREFIX)/share/info($env.INFOPATH? | default '' | prepend ':')"

##
# Define the path to the dotfiles directory
##
$env.DOTFILES = ($env.DOTFILES? | default ($env.HOME | path join ".dotfiles"))

##
# XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/latest/#variables
##
$env.XDG_BIN_HOME = ($env.XDG_BIN_HOME? | default ($env.HOME | path join ".local" "bin"))
$env.XDG_CACHE_HOME = ($env.XDG_CACHE_HOME? | default ($env.HOME | path join ".cache"))
$env.XDG_CONFIG_HOME = ($env.XDG_CONFIG_HOME? | default ($env.HOME | path join ".config"))
$env.XDG_CONFIG_DIRS = ($env.XDG_CONFIG_DIRS? | default "/etc/xdg")
$env.XDG_DATA_HOME = ($env.XDG_DATA_HOME? | default ($env.HOME | path join ".local" "share"))
$env.XDG_DATA_DIRS = ($env.XDG_DATA_DIRS? | default "/usr/local/share/:/usr/share/")
$env.XDG_RUNTIME_DIR = ($env.XDG_RUNTIME_DIR? | default ($env.TMPDIR | default "/tmp" | path join $"runtime-($env.UID? | default (id -u | str trim))"))
$env.XDG_STATE_HOME = ($env.XDG_STATE_HOME? | default ($env.HOME | path join ".local" "state"))

##
# XDG User Directories
# https://wiki.archlinux.org/title/XDG_user_directories
##
$env.XDG_DESKTOP_DIR = ($env.XDG_DESKTOP_DIR? | default ($env.HOME | path join "Desktop"))
$env.XDG_DOCUMENTS_DIR = ($env.XDG_DOCUMENTS_DIR? | default ($env.HOME | path join "Documents"))
$env.XDG_DOWNLOAD_DIR = ($env.XDG_DOWNLOAD_DIR? | default ($env.HOME | path join "Downloads"))
$env.XDG_MUSIC_DIR = ($env.XDG_MUSIC_DIR? | default ($env.HOME | path join "Music"))
$env.XDG_PICTURES_DIR = ($env.XDG_PICTURES_DIR? | default ($env.HOME | path join "Pictures"))
$env.XDG_PUBLICSHARE_DIR = ($env.XDG_PUBLICSHARE_DIR? | default ($env.HOME | path join "Public"))
$env.XDG_VIDEOS_DIR = ($env.XDG_VIDEOS_DIR? | default ($env.HOME | path join "Movies"))

##
# Tool-specific environment variables with partial XDG support
# https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
##
$env.BUN_HOME = ($env.XDG_CACHE_HOME | path join ".bun")
$env.CARGO_HOME = ($env.XDG_DATA_HOME | path join "cargo")
$env.DOCKER_CONFIG = ($env.XDG_CONFIG_HOME | path join "docker")
$env.FFMPEG_DATADIR = ($env.XDG_CONFIG_HOME | path join "ffmpeg")
$env.GNUPGHOME = ($env.XDG_CONFIG_HOME | path join "gnupg")
$env.LESSHISTFILE = ($env.XDG_STATE_HOME | path join "less_history")
$env.MACHINE_STORAGE_PATH = ($env.XDG_DATA_HOME | path join "docker_machine")
$env.MYPY_CACHE_DIR = ($env.XDG_CACHE_HOME | path join "mypy")
$env.NODE_REPL_HISTORY = ($env.XDG_STATE_HOME | path join "node_repl_history")
$env.NPM_CONFIG_CACHE = ($env.XDG_CACHE_HOME | path join "npm")
$env.NPM_CONFIG_USERCONFIG = ($env.XDG_CONFIG_HOME | path join "npm" "config")
$env.NPM_CONFIG_PREFIX = ($env.XDG_DATA_HOME | path join "npm")
$env.NVM_DIR = ($env.XDG_DATA_HOME | path join "nvm")
$env.PYENV_ROOT = ($env.XDG_DATA_HOME | path join "pyenv")
$env.PYTHONPYCACHEPREFIX = ($env.XDG_CACHE_HOME | path join "python")
$env.PYTHONUSERBASE = ($env.XDG_DATA_HOME | path join "python")
$env.PYTHON_HISTORY = ($env.XDG_STATE_HOME | path join "python_history")
$env.RUSTUP_HOME = ($env.XDG_DATA_HOME | path join "rustup")
$env.WORKON_HOME = ($env.XDG_DATA_HOME | path join "virtualenvs")
$env.ZDOTDIR = ($env.XDG_CONFIG_HOME | path join "zsh")

##
# General environment variables
##
$env.EDITOR = "nvim"
$env.LESSOPEN = "|~/.lessfilter %s"
$env.CLICOLOR = "1"
$env.TURBO_UI = "true"
$env.FD_IGNORE_FILE = ($env.HOME | path join ".config" "fd" "ignore")
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git"
$env.FZF_DEFAULT_OPTS = "--style full --prompt '❯ ' --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up' --cycle"

# Use Nushell-specific starship config (with character module disabled)
$env.STARSHIP_CONFIG = ($env.HOME | path join ".config" "starship-nu.toml")

##
# PATH configuration
##
# Add XDG_BIN_HOME to PATH if not already present
$env.PATH = (
    $env.PATH 
    | split row (char esep)
    | prepend $env.XDG_BIN_HOME
    | prepend ($env.NPM_CONFIG_PREFIX | path join "bin")
    | prepend ($env.CARGO_HOME | path join "bin")
    | prepend ($env.HOMEBREW_PREFIX | path join "bin")
    | prepend ($env.HOMEBREW_PREFIX | path join "sbin")
    | prepend ($env.XDG_CACHE_HOME | path join ".bun/bin")
    | uniq
)

##
# mise activation
##
if (which mise | is-not-empty) {
    let mise_path = ($nu.default-config-dir | path join "mise.nu")
    ^mise activate nu | save $mise_path --force

    let cache_dir = ($env.XDG_CACHE_HOME | path join "nushell")
    let required_cache_files = [
        "carapace.nu"
        "vivid.nu"
        "zoxide.nu"
        "starship.nu"
    ]

    if ($required_cache_files | any {|name|
        not (($cache_dir | path join $name) | path exists)
    }) {
        ^mise exec -- ($env.XDG_BIN_HOME | path join "nu-init") | ignore
    }
}

# Keep shared npm globals ahead of mise-managed tools.
$env.PATH = ($env.PATH | prepend ($env.NPM_CONFIG_PREFIX | path join "bin") | uniq)

##
# LS_COLORS configuration with vivid
##
let ls_colors_cache = ($env.HOME | path join ".cache" "vivid" "ls_colors")
if ($ls_colors_cache | path exists) {
    $env.LS_COLORS = (open $ls_colors_cache)
}

##
# Carapace completion setup
##
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
