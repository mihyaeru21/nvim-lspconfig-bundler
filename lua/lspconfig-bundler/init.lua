local io = require('io')
local string = require('string')
local lspconfig = require('lspconfig')
local path_util = lspconfig.util.path

local RUBY_CONFIGS = {
  rubocop = {
    gem = 'rubocop',
  },
  ruby_lsp = {
    gem = 'ruby-lsp',
  },
  solargraph = {
    gem = 'solargraph',
  },
  sorbet = {
    gem = 'sorbet',
  },
  steep = {
    gem = 'steep',
  },
  syntax_tree = {
    gem = 'syntax_tree',
  },
  typeprof = {
    gem = 'typeprof',
  },
}

local M = {}

--- @param path string
--- @param str string
--- @return boolean
local contains_str = function(path, str)
  for line in io.lines(path) do
    if string.find(line, str, 1, true) then
      return true
    end
  end
  return false
end

--- @param gem string
--- @return boolean
local gem_installed = function(gem)
  -- find Gemfile.lock in project
  local current = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  if #current == 0 then
    current = vim.fn.getcwd()
  end
  local root_dir = lspconfig.util.root_pattern('Gemfile.lock')(path_util.sanitize(current))
  if not root_dir then
    return false
  end

  -- find the gem in Gemfile.lock
  local path = path_util.sanitize(path_util.join(root_dir, 'Gemfile.lock'))
  local gem_line = ' ' .. gem .. ' ('
  return contains_str(path, gem_line)
end

--- @class lspconfig-bundler.Config
--- @field only_bundler? boolean

--- @param plugin_config? lspconfig-bundler.Config
M.setup = function(plugin_config)
  if plugin_config == nil then
    plugin_config = {}
  end

  lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
    local conf = RUBY_CONFIGS[config.name]
    if not conf then
      return
    end
    local installed = gem_installed(conf.gem)

    -- If the Gemfile.lock exists and contains a gem that provides the command, add `bundle exec` to `config.cmd`.
    if installed then
      -- If the command not includes `bundle`, add `bundle exec` to the command.
      local cmd = vim.fs.basename(config.cmd[1])
      if not string.find(cmd, 'bundle', 1, true) then
        config.cmd[1] = cmd -- replace `/usr/local/bin/hoge` -> `hoge`
        config.cmd = vim.list_extend({ 'bundle', 'exec' }, config.cmd)
      end
    end

    -- If `only_bundler` is true, enable the language server only if the gem is installed in the project.
    if plugin_config.only_bundler then
      config.enabled = installed
    end
  end)
end

return M
