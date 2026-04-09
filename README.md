# nvim-config

Personal Neovim configuration built on top of
[LazyVim](https://www.lazyvim.org/).
Works on macOS and Linux.

## Installation

### Homebrew (recommended)

```bash
brew install fcrozetta/tools/nvim-config
```

This installs all dependencies, symlinks the config to
`~/.config/nvim`, and sets up npm packages.
If you already have a Neovim config, it will be backed up
automatically.

After upgrades, run `nvim-config-setup` to re-link.

### Manual

Requires [Homebrew](https://brew.sh/) installed.

```bash
git clone https://github.com/fcrozetta/nvim-config.git \
  ~/.config/nvim
~/.config/nvim/setup.sh
```

The setup script installs brew and npm dependencies,
symlinks the config, syncs plugins, and installs
Treesitter parsers. Mason LSP servers install on first
launch.

### Uninstall

```bash
nvim-config-uninstall
brew uninstall nvim-config
brew autoremove
```

The uninstall script removes the config symlink, restores
the most recent backup if one exists, cleans up plugin
data, and removes npm packages.

### Dependencies

Installed automatically by either method above.

| Tool                     | Purpose                    |
| ------------------------ | -------------------------- |
| neovim                   | Editor                     |
| ripgrep                  | Fast text search           |
| fd                       | Fast file finder           |
| fzf                      | Fuzzy finder               |
| lazygit                  | Terminal git UI            |
| tree-sitter              | Syntax parsing             |
| node                     | Required by several plugins|
| python@3.12              | Python tooling support     |
| uv                       | Python package manager     |
| ghostscript              | PDF/image rendering        |
| imagemagick              | Image processing           |
| luarocks                 | Lua package manager        |
| @mermaid-js/mermaid-cli  | Diagram rendering (npm)    |

## What's included

This config extends LazyVim with additional plugins and
customizations. All standard
[LazyVim features](https://www.lazyvim.org/) are available
out of the box.

### Language support

Enabled via LazyVim extras:

| Language/Tool | Extra           | What you get            |
| ------------- | --------------- | ----------------------- |
| Python        | `lang.python`   | Pyright + Ruff + debugpy|
| Docker        | `lang.docker`   | Dockerfile + Compose LSP|
| Vue           | `lang.vue`      | Volar + vtsls           |
| Svelte        | `lang.svelte`   | Svelte LSP              |
| Tailwind CSS  | `lang.tailwind` | Tailwind CSS LSP        |
| JSON          | `lang.json`     | JSON LSP + SchemaStore  |
| YAML          | `lang.yaml`     | YAML LSP                |
| TOML          | `lang.toml`     | taplo LSP               |
| Markdown      | `lang.markdown` | Markdown LSP + tools    |
| Git           | `lang.git`      | Git-related tooling     |
| Dotfiles      | `util.dot`      | Dotfile utilities       |
| DAP           | `dap.core`      | Debug Adapter Protocol  |
| Claude Code   | `ai.claudecode` | AI assistant            |

### Plugins

| Plugin              | What it does                 |
| ------------------- | ---------------------------- |
| snacks.nvim         | Picker, notifier, explorer   |
| lspsaga.nvim        | Floating peek windows        |
| neotest             | Test runner (pytest)         |
| nvim-dap-python     | Python debugging (debugpy)   |
| venv-selector.nvim  | Auto-activates `.venv`       |
| better-comments     | `!` `?` `*` `//` highlights  |
| todo-comments.nvim  | TODO/FIX/HACK highlighting   |
| diagram.nvim        | Mermaid/PlantUML/D2 diagrams |
| image.nvim          | Inline images (Kitty/Ghostty)|
| markdown-preview    | Live preview in browser      |
| render-markdown     | In-buffer markdown rendering |
| noice.nvim          | Command line UI              |
| which-key.nvim      | Keymap hints                 |

### Mason tools

Automatically installed on first launch:

- **Linters**: hadolint, markdownlint-cli2, shellcheck
- **Formatters**: shfmt, stylua
- **DAP**: debugpy, js-debug-adapter
- **Tools**: markdown-toc

## Custom keymaps

All standard
[LazyVim keymaps](https://www.lazyvim.org/keymaps) apply.
The following are additions or overrides.

### LSP navigation (Lspsaga)

| Key            | Action                          |
| -------------- | ------------------------------- |
| `gd`           | Peek definition (float)         |
| `gD`           | Go to definition (native)       |
| `gi`           | Peek implementation (float)     |
| `gI`           | Go to implementation (native)   |
| `<Esc>` / `q`  | Close Lspsaga windows          |

### Testing (Neotest)

| Key          | Action              |
| ------------ | ------------------- |
| `<leader>tn` | Run nearest test   |
| `<leader>tf` | Run current file   |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show test output   |
| `<leader>tS` | Stop running tests |
| `<leader>tw` | Toggle test watch  |
| `<leader>td` | Debug nearest test |

In the test summary panel:

| Key                   | Action          |
| --------------------- | --------------- |
| `<CR>`/`<leader>tj`  | Jump to test    |
| `<leader>te`          | Expand/collapse |
| `<leader>to`          | Show output     |
| `q`                   | Close panel     |

### Other

| Key          | Action                          |
| ------------ | ------------------------------- |
| `<leader>be` | Edit `.env` from project root   |
| `]t` / `[t` | Next/previous TODO comment      |
| `<leader>xt` | TODO list (Trouble)             |
| `<leader>st` | Search TODOs (Telescope)        |

## Notes

- **Nerd Font required** -- icons need a
  [Nerd Font](https://www.nerdfonts.com/)
  (e.g., MesloLGS NF, JetBrainsMono NF).
- **Image rendering** uses the Kitty graphics protocol.
  Works in Kitty and Ghostty. Other terminals work
  fine but without inline images.
- **Python venv** is detected from `.venv` in the
  project root. Pyright is configured before LSP
  starts so no restart is needed.
- **Mason LSP servers** install on first launch --
  the first open may take a moment.
