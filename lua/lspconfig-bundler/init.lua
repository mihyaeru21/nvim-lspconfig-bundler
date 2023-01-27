local io = require('io')
local string = require('string')
local lspconfig = require('lspconfig')
local path_util = lspconfig.util.path

local RUBY_CONFIGS = {
  ruby_ls = {
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

local contains_str = function(path, str)
  for line in io.lines(path) do
    if string.find(line, str, 1, true) then
      return true
    end
  end
  return false
end

M.setup = function()
  -- If the Gemfile.lock exists and contains a gem that provides the command, add `bundle exec` to `config.cmd`.
  lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
    local conf = RUBY_CONFIGS[config.name]
    if not conf then return end

    -- find Gemfile.lock in project
    local current = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    if #current == 0 then
      current = vim.fn.getcwd()
    end
    local root_dir = lspconfig.util.root_pattern('Gemfile.lock')(path_util.sanitize(current))
    if not root_dir then return end

    -- find the gem in Gemfile.lock
    local path = path_util.sanitize(path_util.join(root_dir, 'Gemfile.lock'))
    local gem_line = ' ' .. conf.gem .. ' ('
    if not contains_str(path, gem_line) then return end

    config.cmd = vim.list_extend({ 'bundle', 'exec' }, config.cmd)
  end)
end

return M
