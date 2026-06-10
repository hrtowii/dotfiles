{
  pkgs,
  hostVars,
  ...
}:

{

  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      imagemagick
      ripgrep
      fd
      git
      gcc
      pkg-config
      nodejs
      python3
      cargo
      cmake
      xdg-utils
      pandoc
      lua-language-server
      nixd
      pyright
      rust-analyzer
      # ols
      # odin
      gopls
      clang-tools
      clang-analyzer
      marksman
      yaml-language-server
      typescript-language-server
      vscode-langservers-extracted
      svelte-language-server
      tailwindcss-language-server
      # nodePackages_latest.typescript-language-server
      # nodePackages_latest.vscode-langservers-extracted
      # nodePackages_latest.svelte-language-server
      # nodePackages."@tailwindcss/language-server"
      # nodePackages_latest.dockerfile-language-server
      black
      biome
      shfmt
      stylelint
      stylua
      rustfmt
      isort
      gopls
      nixfmt
      tree-sitter
      vimPlugins.nvim-treesitter-parsers.qmljs
      tree-sitter-grammars.tree-sitter-typst
      # Tree-sitter grammars
      tree-sitter-grammars.tree-sitter-bash
      tree-sitter-grammars.tree-sitter-c
      # tree-sitter-grammars.tree-sitter-diff
      tree-sitter-grammars.tree-sitter-html
      tree-sitter-grammars.tree-sitter-javascript
      tree-sitter-grammars.tree-sitter-jsdoc
      tree-sitter-grammars.tree-sitter-json
      # tree-sitter-grammars.tree-sitter-jsonc
      tree-sitter-grammars.tree-sitter-lua
      # tree-sitter-grammars.tree-sitter-luadoc
      # tree-sitter-grammars.tree-sitter-luap
      tree-sitter-grammars.tree-sitter-markdown
      tree-sitter-grammars.tree-sitter-markdown-inline
      tree-sitter-grammars.tree-sitter-python
      tree-sitter-grammars.tree-sitter-query
      tree-sitter-grammars.tree-sitter-regex
      tree-sitter-grammars.tree-sitter-toml
      tree-sitter-grammars.tree-sitter-tsx
      tree-sitter-grammars.tree-sitter-typescript
      tree-sitter-grammars.tree-sitter-vim
      # tree-sitter-grammars.tree-sitter-vimdoc
      # tree-sitter-grammars.tree-sitter-xml
      tree-sitter-grammars.tree-sitter-yaml
    ];
  };

  home.sessionVariables = {
    HOMEUSER = hostVars.username;
  };

}
