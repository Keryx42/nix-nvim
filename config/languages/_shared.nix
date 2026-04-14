{ pkgs, ... }:
{
  # Shared LSP configuration across all languages
  # Global onAttach hook for client-specific workarounds and utilities

  plugins.lsp = {
    enable = true;

    # Global onAttach hook — used to apply client-specific workarounds such as
    # disabling semanticTokens for the vue language server which can crash
    # for certain .vue templates (workaround for volar/vue-language-server bug).
    onAttach = ''
      -- Workaround: disable semantic tokens for vue_ls to avoid volar plugin crash
      if client and client.name then
        if client.name == "vue_ls" or client.name:match("volar") or client.name:match("vue-language-server") then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end
    '';
  };
}
