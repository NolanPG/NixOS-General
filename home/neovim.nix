{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # Theme
    colorschemes.tokyonight.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      clipboard = "unnamedplus";
    };

    plugins = {

      # Interface
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      which-key = {
        enable = true;
      };

      noice = {
        # WARNING: This is considered experimental feature, but provides nice UX
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          #inc_rename = false;
          #lsp_doc_border = false;
        };
      };

      telescope = {
        enable = true;
        settings.keymaps = {
          "<leader>ff" = {
            desc = "file finder";
            action = "find_files";
          };
          "<leader>fg" = {
            desc = "find via grep";
            action = "live_grep";
          };
        };
        extensions = {
          file-browser.enable = true;
        };
      };
    };
  };
}