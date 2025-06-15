{
  programs.helix = {
    enable = true;

    defaultEditor = true;

    settings = {
      theme = "gruvbox_dark_soft";

      editor = {
        line-number = "relative";
        continue-comments = false;
        color-modes = true;

        lsp.enable = true;

        shell = ["nu" "-c"];
      };
    };

    languages = {
      language-server = {
        rust-analyzer = {
          command = "rust-analyzer";
        };
        nil = {
          command = "nil";
        };
      };

      languages = [
        {
          name = "rust";
          language-server = "rust-analyzer";
          formatter = {
            command = "rustfmt";
          };
        }
        {
          name = "nix";
          language-server = "nil";
          formatter = {
            command = "alejandra";
          };
        }
      ];
    };
  };
}
