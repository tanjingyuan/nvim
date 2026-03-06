# Neovim Configuration

A modern Neovim configuration built on [LazyVim](https://www.lazyvim.org/) with extensive customizations for a powerful development environment.

## Features

- 🚀 **Fast and Modern**: Built on LazyVim with lazy-loading for optimal performance
- 🎨 **Beautiful UI**: Catppuccin & Everforest theme with custom highlights
- 🤖 **AI-Powered**: GitHub Copilot integration for intelligent code completion
- 📁 **Smart Project Management**: Project detection and navigation
- 🔧 **Multi-Language Support**: Pre-configured for C/C++, Lua, Python, Shell, and more
- 📋 **Intelligent Clipboard**: Works seamlessly across WSL, SSH, and native environments
- 🔍 **Powerful Search**: Snacks and FZF integration for fuzzy finding
- 📊 **Git Integration**: LazyGit, Gitsigns, and Diffview built-in

## Requirements

- Neovim >= 0.10.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for some LSP servers)
- Ripgrep (for searching)
- fd (for file finding)
- lazygit (for Git TUI)

### Language-Specific Requirements

- **C/C++**: clangd, clang-format
- **Lua**: stylua
- **Python**: black, pyright
- **Shell**: shfmt
- **CMake**: cmake-format, cmakelint
- **YAML**: yamlfix

## Installation

1. Backup your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this configuration:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```

4. LazyVim will automatically install all plugins on first launch

## Key Mappings

### General

| Key | Description |
|-----|-------------|
| `<Space>` | Leader key |
| `;` | Enter command mode (mapped to `:`) |
| `<C-q>` | Close current buffer |
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>/` | Toggle comment |

### Insert Mode

| Key | Description |
|-----|-------------|
| `<C-b>` | Move to beginning of line |
| `<C-e>` | Move to end of line |
| `<C-h>` | Move left |
| `<C-l>` | Move right |
| `<C-j>` | Move down |
| `<C-k>` | Move up |

### Search

| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files (FZF) |
| `<leader>fg` | Find Git files |
| `<leader>fw` | Fuzzy grep in Neo-tree path (Snacks literal search) |
| `<leader>fW` | Fixed string search in Neo-tree path (literal, for special chars) |
| `<leader>fa` | Exact search in Neo-tree path (Snacks, case-sensitive whole word) |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find help tags |
| `<leader>fm` | Find marks |
| `<leader>fo` | Find old files |
| `<leader>fz` | Exact search in current buffer (Snacks) |
| `<leader>sp` | Search in current file's directory |
| `<leader>sP` | Show project info |
| `<leader>cm` | Git commits |
| `<leader>gt` | Git status |
| `<leader>pt` | Pick hidden terminal |

### Code Actions

| Key | Description |
|-----|-------------|
| `<leader>ds` | LSP diagnostic loclist |
| `<leader>cf` | Format file or range (in visual mode) |
| `<leader>ch` | Show signature help |
| `<C-s>` | Save file |

### Git

| Key | Description |
|-----|-------------|
| `<leader>gg` | Open LazyGit for current file repo |
| `<leader>gG` | Open LazyGit for current cwd |
| `<leader>gf` | Show current file history in LazyGit |
| `<leader>gF` | Show repository history in LazyGit |
| `<leader>gC` | Open LazyGit config |
| `<leader>gdo` | Open Diffview |
| `<leader>gdc` | Close Diffview |

### Project Management

| Key | Description |
|-----|-------------|
| `<leader>pp` | Go to project root |
| `<leader>pa` | Add project |

### Terminal

| Key | Description |
|-----|-------------|
| `<Alt-h>` | Toggle horizontal terminal |
| `<leader>cd` | Open floating terminal in current file's directory |

### Special Features

| Key | Description |
|-----|-------------|
| `<leader>h` | Hop to line |
| `<leader>dam` | Delete all marks |
| `<leader>dm` | Delete mark on current line |
| `<leader>gh` | Switch between header/source (C/C++) |
| `<leader>cg` | Generate call graph (C/C++) |
| `<leader>uo` | Toggle whitespace visibility |
| `<leader>al` | Clear Avante history |
| `<leader>sr` | Search and replace (Grug-far) |
| `<leader>b1-9` | Jump to buffer 1-9 (Bufferline) |

## Plugin Highlights

### UI & Themes
- Catppuccin: Primary color scheme with custom highlights
- **Everforest**: Primary color scheme with eye-friendly forest theme
- **Bufferline**: Enhanced buffer tabs with number indicators
- **Lualine**: Informative status line with LSP server display
- **Snacks.nvim**: UI utilities with custom dashboard

### Editor Enhancement
- **Snacks.nvim**: Primary picker and search UI
- **fzf-lua**: Secondary picker for directory and file workflows
- **Neo-tree**: File explorer
- **Hop**: Quick navigation
- **Wildfire**: Smart text object selection
- **UFO**: Advanced folding with fold previews
- **Blink.cmp**: High-performance completion engine

### Development Tools
- **LSP**: Full language server protocol support
- **Treesitter**: Advanced syntax highlighting
- **Conform**: Unified formatting
- **Copilot**: AI pair programming
- **Gitsigns**: Git integration in buffers
- **LazyGit**: Terminal UI for Git

### Utilities
- **Mini.surround**: Surround operations
- **Toggleterm**: Integrated terminal
- **Grug-far**: Find and replace
- **Hardtime**: Build better Vim habits
- **vim-visual-multi**: Multiple cursor support
- **vim-oscyank**: Remote clipboard support

## Customization

### Adding Plugins

Create a new file in `lua/plugins/` with your plugin configuration:

```lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  opts = {
    -- your options here
  },
}
```

### Modifying Keymaps

Edit `lua/config/keymaps.lua` for global keymaps or the respective plugin file for plugin-specific mappings.

### Changing Options

Modify `lua/config/options.lua` for Neovim options.

## Environment Support

This configuration automatically detects and adapts to:
- WSL (Windows Subsystem for Linux)
- SSH sessions
- macOS
- Native Linux

Clipboard operations and formatting behavior adjust accordingly.

## Project Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lazy-lock.json        # Plugin versions
├── lazyvim.json         # LazyVim extras
├── stylua.toml          # Lua formatter config
├── lua/
│   ├── config/          # Core configuration
│   │   ├── autocmds.lua # Auto commands
│   │   ├── keymaps.lua  # Key mappings
│   │   ├── lazy.lua     # Plugin manager
│   │   └── options.lua  # Vim options
│   ├── plugins/         # Plugin configs
│   └── utils/           # Utilities
│       ├── clipboard.lua # Clipboard handling
│       ├── highlight.lua # Custom highlights
│       ├── system.lua    # System detection
│       ├── format.lua    # Format utilities
│       ├── check.lua     # Module checking
│       └── vendor.lua    # Third-party integrations
```

## Troubleshooting

### Plugins not loading
- Run `:Lazy sync` to update plugins
- Check `:Lazy` for plugin status

### LSP not working
- Ensure language servers are installed
- Run `:Mason` to manage LSP servers

### Clipboard issues
- The configuration auto-detects your environment
- For SSH: ensure `vim-oscyank` is working
- For WSL: `win32yank.exe` is used automatically

## Contributing

Feel free to submit issues or pull requests for improvements!

## License

This configuration is available under the MIT License.
