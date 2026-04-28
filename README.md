# nvim-config

Personal Neovim configuration built on top of
[LazyVim](https://www.lazyvim.org/).
Works on macOS and Linux.

## Installation

```bash
brew install fcrozetta/tools/nvim-config
nvim-config-setup
```

`brew install` installs all dependencies declared in the
formula's `depends_on`. It cannot write outside its prefix,
so it does **not** symlink the config or run the post-install
steps.

`nvim-config-setup` does the rest:

- Symlinks the config to `~/.config/nvim` (backing up any
  existing config to `~/.config/nvim.<timestamp>`).
- Installs pnpm globals (Mermaid CLI).
- Bootstraps Neovim plugins and Treesitter parsers.

Re-run `nvim-config-setup` after upgrades to re-link and
re-sync.

> [!WARNING]
> `nvim-config-setup` executes `pnpm add -g`, plugin
> bootstrap, and Treesitter updates. Treat it as
> trusted-code execution, not a passive config copy.

> [!NOTE]
> Mermaid CLI is installed with `pnpm add -g`. The setup
> script exports `PNPM_HOME` as `~/.local/share/pnpm` when it
> is not already set.

### Uninstall

```bash
nvim-config-uninstall
brew uninstall nvim-config
brew autoremove
```

The uninstall script removes the config symlink, restores
the most recent backup if one exists, cleans up plugin
data, and removes the Mermaid CLI package installed by pnpm.

> [!WARNING]
> `nvim-config-uninstall` now prints the paths it will delete
> and asks for confirmation before removing Neovim data,
> state, cache, backups, and the Mermaid CLI install.

### Dependencies

Installed automatically by either method above.

| Tool                    | Purpose                     |
| ----------------------- | --------------------------- |
| neovim                  | Editor                      |
| ripgrep                 | Fast text search            |
| fd                      | Fast file finder            |
| fzf                     | Fuzzy finder                |
| lazygit                 | Terminal git UI             |
| tree-sitter             | Syntax parsing              |
| node                    | Required by several plugins |
| pnpm                    | Mermaid CLI package manager |
| python@3.12             | Python tooling support      |
| uv                      | Python package manager      |
| ghostscript             | PDF/image rendering         |
| imagemagick             | Image processing            |
| luarocks                | Lua package manager         |
| @mermaid-js/mermaid-cli | Diagram rendering (pnpm)    |

## What's included

This config extends LazyVim with additional plugins and
customizations. All standard
[LazyVim features](https://www.lazyvim.org/) are available
out of the box.

### Language support

Enabled via LazyVim extras:

| Language/Tool | Extra           | What you get             |
| ------------- | --------------- | ------------------------ |
| Python        | `lang.python`   | Pyright + Ruff + debugpy |
| Docker        | `lang.docker`   | Dockerfile + Compose LSP |
| Vue           | `lang.vue`      | Volar + vtsls            |
| Svelte        | `lang.svelte`   | Svelte LSP               |
| Tailwind CSS  | `lang.tailwind` | Tailwind CSS LSP         |
| JSON          | `lang.json`     | JSON LSP + SchemaStore   |
| YAML          | `lang.yaml`     | YAML LSP                 |
| TOML          | `lang.toml`     | taplo LSP                |
| Markdown      | `lang.markdown` | Markdown LSP + tools     |
| Git           | `lang.git`      | Git-related tooling      |
| Dotfiles      | `util.dot`      | Dotfile utilities        |
| DAP           | `dap.core`      | Debug Adapter Protocol   |
| Claude Code   | `ai.claudecode` | AI assistant             |

### Plugins

| Plugin             | What it does                  |
| ------------------ | ----------------------------- |
| snacks.nvim        | Picker, notifier, explorer    |
| lspsaga.nvim       | Floating peek windows         |
| neotest            | Test runner (pytest)          |
| nvim-dap-python    | Python debugging (debugpy)    |
| venv-selector.nvim | Auto-activates `.venv`        |
| better-comments    | `!` `?` `*` `//` highlights   |
| todo-comments.nvim | TODO/FIX/HACK highlighting    |
| diagram.nvim       | Mermaid/PlantUML/D2 diagrams  |
| image.nvim         | Inline images (Kitty/Ghostty) |
| markdown-preview   | Live preview in browser       |
| render-markdown    | In-buffer markdown rendering  |
| noice.nvim         | Command line UI               |
| which-key.nvim     | Keymap hints                  |

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

| Key           | Action                        |
| ------------- | ----------------------------- |
| `gd`          | Peek definition (float)       |
| `gD`          | Go to definition (native)     |
| `gi`          | Peek implementation (float)   |
| `gI`          | Go to implementation (native) |
| `<Esc>` / `q` | Close Lspsaga windows         |

### Testing (Neotest)

| Key          | Action              |
| ------------ | ------------------- |
| `<leader>tn` | Run nearest test    |
| `<leader>tf` | Run current file    |
| `<leader>ts` | Toggle test summary |
| `<leader>to` | Show test output    |
| `<leader>tS` | Stop running tests  |
| `<leader>tw` | Toggle test watch   |
| `<leader>td` | Debug nearest test  |

In the test summary panel:

| Key                 | Action          |
| ------------------- | --------------- |
| `<CR>`/`<leader>tj` | Jump to test    |
| `<leader>te`        | Expand/collapse |
| `<leader>to`        | Show output     |
| `q`                 | Close panel     |

### Other

| Key          | Action                        |
| ------------ | ----------------------------- |
| `<leader>be` | Edit `.env` from project root |
| `]t` / `[t`  | Next/previous TODO comment    |
| `<leader>xt` | TODO list (Trouble)           |
| `<leader>st` | Search TODOs (Telescope)      |

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
