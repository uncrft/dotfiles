# Dotfiles

Configuration for Apple Silicon macOS with Colemak DH navigation, Zsh and Nushell support, and TokyoNight theming.

## Bootstrap model

The repository uses [mise bootstrap](https://mise.jdx.dev/bootstrap.html) as the machine setup entry point:

1. `setup.sh` installs the official mise binary in `~/.local/bin` when needed.
2. `mise bootstrap` installs native packages and applications.
3. mise clones the shell plugin repositories.
4. mise links the managed dotfiles into the home directory.
5. mise installs the locked command line tools and regenerates shell caches.
6. mise's bootstrap task configures account-specific Git and SSH settings.

`mise.toml` is also linked to `~/.config/mise/config.toml`, so its tools are available globally. `mise.lock` pins resolved versions, artifact URLs, and checksums for Apple Silicon macOS.

### Dependency sources

The setup does not require the Homebrew CLI.

* Standalone CLIs with suitable assets use upstream GitHub releases directly.
* Node.js, Bun, Rust, Zig, and uv use mise's native backends. Corepack inside the managed Node installation supplies PNPM.
* OpenCode 2 beta, Turbo, and the skills.sh CLI use mise's npm backend; the reviewed skill snapshots remain vendored in the repository.
* eza, git-absorb, and xsv use mise's Cargo backend because their releases do not include Apple Silicon binaries.
* AWS CLI and 1Password CLI use mise backends for their official distribution channels.
* csvkit uses the pipx backend with uv.
* btop, Chafa, ExifTool, and lesspipe use mise's built-in brew backend for native packages.
* macOS applications, fonts, and the Colemak DH keyboard layout use mise's built-in cask backend.
* AeroSpace, Rift, and agent-browser come from their upstream GitHub releases. AeroSpace is linked into `~/Applications`.
* JankyBorders is the sole source-build exception because its third-party tap does not expose metadata that mise's brew backend can consume.

The built-in brew backends fetch and verify formula bottles and casks directly. They do not install or invoke the `brew` executable.

## Features

### Shells

| Feature | Zsh | Nushell |
| --- | --- | --- |
| Vi mode | Yes | Yes |
| Starship prompt | Yes | Yes |
| mise tool activation | Yes | Yes |
| Zoxide and Carapace | Yes | Yes |
| Autosuggestions | Plugin | Built in |
| Syntax highlighting | Plugin | Built in |
| fzf history, files, and directories | Yes | Yes |
| fzf-git keybindings (`Ctrl+G *`) | Yes | No |
| fzf-git commands (`gsw`, `gls`, `gsha`, `gstash`) | No | Yes |
| fzf-tab completions | Yes | No |

### Applications

* **AeroSpace**: tiling window management with Colemak DH navigation
* **Ghostty**: TokyoNight theme, transparency, Colemak DH splits, and Vim scrollback
* **Neovim**: LazyVim, Copilot, Colemak DH, TypeScript, Zig, and Nushell
* **Git**: Delta pager, SSH signing, git-branchless, and custom aliases

### Agent skills

Shared Agent Skills live under `.agents/skills`. Mise links the complete `.agents` directory into the home directory, where Pi and OpenCode discover it natively. This avoids harness-specific skill copies and links. The skills.sh provenance lock is tracked at `.local/state/skills/.skill-lock.json`, its native global location.

Stable Pi instructions and provider-neutral settings are tracked under `.pi/agent`. Credentials, custom providers and models, MCP configuration, sessions, installed packages, caches, histories, model stores, and project trust decisions remain local. Pi keeps `auth.json`, `models.json`, and `mcp.json` as local mode `0600` files.

OpenCode tracks only its public `opencode.json`. Private provider configuration remains in local mode `0600` `opencode.jsonc`; authentication remains in local `~/.local/share/opencode/auth.json`, and OpenCode 2 CLI preferences remain in local `cli.json`.

### Pi question helpers

Nushell provides `q`, `qq`, and `qqq` for one-shot Pi questions. They combine a local default provider with the model names `haiku`, `sonnet`, and `opus`, respectively. Keep the provider in untracked `~/.config/nushell/q.local.json`:

```json
{
  "provider": "provider-name"
}
```

Environment variables can override the local configuration without publishing provider topology:

| Variable | Purpose |
| --- | --- |
| `Q_CONFIG` | Optional path to another local JSON configuration file |
| `Q_PROVIDER` | Provider override shared by all three commands |
| `Q_MODEL` | Model override for `q` |
| `QQ_MODEL` | Model override for `qq` |
| `QQQ_MODEL` | Model override for `qqq` |

The local JSON file can also define `models.q`, `models.qq`, and `models.qqq`. Explicit `--provider` and `--model` arguments take precedence over environment variables and local configuration.

## Requirements

* Apple Silicon Mac running macOS 14 or later
* Xcode Command Line Tools, including Git and Make
* `curl`

Install the command line tools when needed:

```sh
xcode-select --install
```

## Installation

Clone the repository:

```sh
git clone https://github.com/uncrft/dotfiles.git ~/.dotfiles
```

Run the setup entry point:

```sh
~/.dotfiles/setup.sh
```

The script prompts for Git identity values and may request `sudo` while mise applies these declarative system files:

* `/etc/zshenv`: sources the XDG-compliant Zsh environment
* `/etc/pam.d/sudo_local`: enables Touch ID for sudo authentication

To review the plan first:

```sh
~/.dotfiles/setup.sh --dry-run
```

The bootstrap owns `~/.config/mise/config.toml`. Setup stops rather than replacing an existing file at that path.

## Maintenance

```sh
# Converge the complete machine configuration
mise bootstrap

# Preview changes
mise bootstrap --dry-run

# Inspect all managed state
mise bootstrap status

# Apply only dotfiles
mise bootstrap dotfiles apply

# The shell helper defaults to the same dotfile apply command
dotfiles
dotfiles status

# Resolve newer tool releases into mise.lock, then install them
mise lock --global --bump
mise install

# Upgrade only Pi through mise
mise upgrade 'github:earendil-works/pi'

# Upgrade the configured native packages and applications
mise bootstrap packages upgrade

# Regenerate shell caches after tool updates
zsh-init
nu-init

# Configure account-specific Git identity or SSH access
setup-git
setup-ssh

# Add or update shared Agent Skills
skills add owner/repository --global --agent opencode --yes
skills update --global
```

Agent Skill changes appear directly in the dotfiles repository and should be reviewed before committing. Third-party skills can execute instructions with full agent permissions.

Add a standalone GitHub release tool in `mise.toml`:

```toml
[tools]
"github:owner/repository" = "latest"
```

Then update the global lockfile:

```sh
mise lock --global
```

Add a native package or application:

```sh
mise bootstrap packages use brew:package
mise bootstrap packages use brew-cask:application
```

## Keybinding reference

### Colemak DH

Navigation is remapped from QWERTY's HJKL to NEIO:

| QWERTY | Colemak DH | Direction |
| --- | --- | --- |
| H | N | Left |
| J | E | Down |
| K | I | Up |
| L | O | Right |

### Application navigation

**Neovim** window navigation:

* `Ctrl+N/E/I/O`: focus the window in that direction

**AeroSpace** window navigation:

* `Ctrl+Alt+N/E/I/O`: focus the window in that direction
* `Alt+Shift+N/E/I/O`: move the window in that direction

**Ghostty** split navigation:

* `Ctrl+Shift+N/E/I/O`: focus the split in that direction

### fzf-git bindings

Zsh bindings use the `Ctrl+G` prefix:

* `Ctrl+G Ctrl+F`: files
* `Ctrl+G Ctrl+B`: branches
* `Ctrl+G Ctrl+T`: tags
* `Ctrl+G Ctrl+H`: commit hashes
* `Ctrl+G Ctrl+R`: remotes
* `Ctrl+G Ctrl+S`: stashes

Nushell does not support these key sequences. Use `gsw`, `gls`, `gsha`, and `gstash` instead.
