# nvim-lspconfig-bundler

A [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) plugin for bundler.
If you use bundler in your project, it will automatically give `bundle exec` to the command.

It may not work on Windows. I have not confirmed that it works.

## Usage

Install with your favorite plugin manager. Here is an example using packer.

```lua
use { 'mihyaeru21/nvim-lspconfig-bundler', requires = 'neovim/nvim-lspconfig' }
```

Call `require('lspconfig-bundler').setup()` before setup each servers.
No modification of `cmd` is required.

```lua
require('lspconfig-bundler').setup()
local lspconfig = require('lspconfig')
lspconfig.ruby_lsp.setup()
```

### `only_bundler`

Setting this option to `true` will enable only the language server for the gem installed in the project.

```lua

require('lspconfig-bundler').setup {
    only_bundler = true,
}
```
