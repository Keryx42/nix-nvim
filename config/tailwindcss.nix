{
  plugins.lsp.servers.tailwindcss = {
    enable = true;
    filetypes = [ "html" "vue" "jsx" "tsx" "css" ];
    settings = {
      tailwindCSS = {
        validate = true;
        lint = {
          cssConflict = "warning";
          invalidApply = "error";
          invalidScreen = "error";
          invalidVariant = "error";
          invalidConfigPath = "error";
          invalidTailwindDirective = "error";
          recommendedVariantOrder = "warning";
        };
        classAttributes = [ "class" "className" "ngClass" ];
        hovers = true;
        codeActions = true;
      };
    };
  };
}
