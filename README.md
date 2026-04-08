# Neovim Config

Personal Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim).

## Prerequisites

### Brew

```bash
brew install neovim ripgrep fd fzf lazygit tree-sitter node uv \
  ghostscript imagemagick luarocks
```

### npm

```bash
npm install -g @mermaid-js/mermaid-cli
```

## Install

```bash
# Back up existing config if needed
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone <repo-url> ~/.config/nvim

# Install all dependencies + plugins
~/.config/nvim/setup.sh
```

The script handles:

- **Homebrew** packages (neovim, ripgrep, fd, etc.)
- **npm** global packages (mermaid-cli)
- **Python** via pyenv
- **Plugins** via lazy.nvim (headless sync)
- **Treesitter** parsers
- **Mason** LSP servers install on first launch

## Structure

```text
~/.config/nvim/
├── init.lua                    # Entry point — loads config.lazy
├── lazyvim.json                # LazyVim extras (lang packs, DAP, etc.)
├── lazy-lock.json              # Pinned plugin versions
├── lua/
│   ├── config/
│   │   ├── lazy.lua            # lazy.nvim bootstrap and setup
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Custom keymaps (neotest, lspsaga escape)
│   │   └── autocmds.lua        # Custom autocommands
│   └── plugins/
│       ├── better-comments.lua # VSCode-style comment highlighting (! ? * //)
│       ├── debug.lua           # nvim-dap-python (debugpy)
│       ├── diagram.lua         # Mermaid/PlantUML/D2 diagram rendering
│       ├── disabled.lua        # Disabled plugins
│       ├── example.lua         # LazyVim example spec (inactive)
│       ├── image.lua           # Inline image rendering (kitty protocol)
│       ├── lspsaga.lua         # Lspsaga + LSP keymap overrides
│       ├── markdown-preview.lua# Browser-based markdown preview
│       ├── mason.lua           # Mason ensure_installed (formatters, linters, DAP)
│       ├── neotest.lua         # Test runner (pytest)
│       ├── noice.lua           # Noice UI (hover via Lspsaga)
│       ├── render-markdown.lua # In-buffer markdown rendering
│       ├── snacks.lua          # Snacks.nvim (picker, notifier, statuscolumn, etc.)
│       ├── todo-comments.lua   # TODO/FIX/HACK highlighting
│       ├── venv.lua            # Python venv auto-activation + pyright config
│       └── which-key.lua       # Which-key group labels
└── stylua.toml                 # Lua formatter config
```

## LazyVim Extras

Enabled in `lazyvim.json`:

| Extra           | Purpose                             |
| --------------- | ----------------------------------- |
| `ai.claudecode` | Claude Code integration             |
| `dap.core`      | Debug Adapter Protocol              |
| `lang.docker`   | Dockerfile + Compose LSP            |
| `lang.git`      | Git-related tooling                 |
| `lang.json`     | JSON LSP + SchemaStore              |
| `lang.markdown` | Markdown LSP + tools                |
| `lang.python`   | Pyright + Ruff                      |
| `lang.svelte`   | Svelte LSP                          |
| `lang.tailwind` | Tailwind CSS LSP                    |
| `lang.toml`     | TOML LSP (taplo)                    |
| `lang.vue`      | Vue LSP (Volar) + vtsls integration |
| `lang.yaml`     | YAML LSP                            |
| `util.dot`      | Dotfile utilities                   |

## Key Customizations

### LSP Navigation (via Lspsaga)

| Key  | Action                              |
| ---- | ----------------------------------- |
| `gd` | Peek definition (Lspsaga float)     |
| `gD` | Jump to definition (native LSP)     |
| `gi` | Peek implementation (Lspsaga float) |
| `gI` | Jump to implementation (native LSP) |

### Python Venv

- Auto-activates `.venv` from cwd when opening Python files
- Pyright configured with venv path before LSP starts (no restart needed)

### UI

- **Snacks.nvim** for picker, notifier, statuscolumn, explorer
- **Noice** for cmdline UI (LSP hover/signature handled by Lspsaga)
- **better-comments** for `!` `?` `*` `//` comment highlighting
