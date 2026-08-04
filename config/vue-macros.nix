{ pkgs, ... }:
{
  # Editor macros for Vue/TypeScript workflows
  keymaps = [
    {
      mode = "n";
      key = "<leader>ms";
      action.__raw = ''function()
  local keys = [[A()<Esc>A(<BS><Esc>IstoreToRefs(<Esc>A)<Esc>Iconst<Space>-<BS>=<Space>{<BS><BS><BS>{}<Space>=<Space><Left><Left><Left><Left><Space><Esc>i]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end'';
      options = { desc = "Wrap StoreToRefs"; silent = true; };
    }

    {
      mode = "n";
      key = "<leader>mc";
      action.__raw = ''function()
  local keys = [[<Esc>Iconst<Space>{}<Space>=<Space><Esc>bba<Space><Esc>i]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end'';
      options = { desc = "Wrap Composable"; silent = true; };
    }

    {
      mode = "n";
      key = "<leader>mj";
      action.__raw = ''function()
  local keys = [[<Esc>gdwwwwwwgdgd]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end'';
      options = { desc = "Go To Definition Alias"; silent = true; };
    }

    {
      mode = "n";
      key = "<leader>mp";
      action.__raw = ''function()
  local keys = [[oconst<Space>{}<Space><Right>=<Space>toRefs(props)<Esc>0wa]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end'';
      options = { desc = "Props to Refs"; silent = true; };
    }

    {
      mode = "n";
      key = "<leader>ma";
      action.__raw = ''function()
  local keys = [[<Esc>Iconst<Space>P<S-BS>{}<Space>=<Space><Esc>bbbci}]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end'';
      options = { desc = "Destruct"; silent = true; };
    }
  ];
}
