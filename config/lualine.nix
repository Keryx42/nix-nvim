{
  plugins.lualine = {
    enable = true;
    settings = {
      options.theme = "auto";
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            symbols.modified = " ●";
            symbols.readonly = " ";
            symbols.unnamed = "[No Name]";
          }
        ];
        lualine_x = [ "encoding" "fileformat" "filetype" ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
    };
  };
}
