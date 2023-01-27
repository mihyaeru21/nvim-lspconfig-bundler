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
local lspconfig = require('lspconfig')

require('lspconfig-bundler').setup()

lspconfig.ruby_ls.setup {
  ...
}
```

