{ pkgs, ... }:
{
  # Run very early to create Neovim runtime directories so plugins that open
  # log files (neo-tree, etc.) don't fail during headless checks/builds.
  extraConfigLua = ''
    local data = vim.fn.stdpath('data')
    if vim.fn.isdirectory(data) == 0 then vim.fn.mkdir(data, 'p') end
    local cache = vim.fn.stdpath('cache')
    if vim.fn.isdirectory(cache) == 0 then vim.fn.mkdir(cache, 'p') end
  '';
}
