# Neovim Configuration

A modern Neovim configuration built on [LazyVim](https://www.lazyvim.org/) with extensive customizations for a powerful development environment.

## Features

- 🚀 **Fast and Modern**: Built on LazyVim with lazy-loading for optimal performance
- 🎨 **Beautiful UI**: Catppuccin theme with custom highlights
- 🤖 **AI-Powered**: GitHub Copilot integration for intelligent code completion
- 📁 **Smart Project Management**: Project detection and navigation
- 🔧 **Multi-Language Support**: Pre-configured for C/C++, Lua, Python, Shell, and more
- 📋 **Intelligent Clipboard**: Works seamlessly across WSL, SSH, and native environments
- 🔍 **Powerful Search**: Telescope and FZF integration for fuzzy finding
- 📊 **Git Integration**: Gitsigns, Diffview, and Git commands built-in

## Requirements

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Node.js (for some LSP servers)
- Ripgrep (for searching)
- fd (for file finding)

### Language-Specific Requirements

- **C/C++**: clangd, clang-format
- **Lua**: stylua
- **Python**: black
- **Shell**: shfmt
- **CMake**: cmake-format
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

### Telescope

| Key | Description |
|-----|-------------|
| `<leader>fW` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Find help tags |
| `<leader>fm` | Find marks |
| `<leader>fo` | Find old files |
| `<leader>fz` | Find in current buffer |
| `<leader>cm` | Git commits |
| `<leader>gt` | Git status |
| `<leader>pt` | Pick hidden terminal |

### Code Actions

| Key | Description |
|-----|-------------|
| `<leader>ds` | LSP diagnostic loclist |
| `<leader>cf` | Format file or range (in visual mode) |
| `gp` | Preview definition |
| `gl` | Preview declaration |
| `q` | Close all preview windows |

### Git

| Key | Description |
|-----|-------------|
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
| `<leader>cd` | Open terminal in current file's directory |

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

## Plugin Highlights

### UI & Themes
- **Catppuccin**: Primary color scheme with custom highlights
- **Bufferline**: Enhanced buffer tabs
- **Lualine**: Informative status line
- **Snacks.nvim**: UI utilities with custom dashboard

### Editor Enhancement
- **Telescope**: Primary fuzzy finder
- **Neo-tree**: File explorer
- **Hop**: Quick navigation
- **Wildfire**: Smart text object selection
- **UFO**: Advanced folding with fold previews

### Development Tools
- **LSP**: Full language server protocol support
- **Treesitter**: Advanced syntax highlighting
- **Conform**: Unified formatting
- **Copilot**: AI pair programming
- **Gitsigns**: Git integration in buffers

### Utilities
- **Mini.surround**: Surround operations
- **Toggleterm**: Integrated terminal
- **Grug-far**: Find and replace
- **Hardtime**: Build better Vim habits

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
│       └── system.lua    # System detection
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