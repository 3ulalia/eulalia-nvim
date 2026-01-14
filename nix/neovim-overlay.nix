# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
      inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
    };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars
    luasnip # snippets | https://github.com/l3mon4d3/luasnip/
    friendly-snippets
    # nvim-cmp (autocompletion) and extensions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions
    # ^ nvim-cmp extensions
    # git integration plugins
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    # vim-fugitive # https://github.com/tpope/vim-fugitive/
    lazygit-nvim
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # A highly extendable fuzzy finder over lists. | https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # FZY style sorter that is compiled. | https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # telescope-smart-history-nvim # https://github.com/nvim-telescope/telescope-smart-history.nvim
    # ^ telescope and extensions
    # UI
    lualine-nvim # Easily configurable, blazingly fast statusline. | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # A simple statusline/winbar component that uses LSP to show your current code context. | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Configurable 'statuscolumn' with built-in segments and click handlers. | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # Shows floating hover with the current function/block context. | https://github.com/nvim-treesitter/nvim-treesitter-context 
    which-key-nvim # Shows a popup with possible keybindings of the command you started typing. | https://github.com/folke/which-key.nvim
    todo-comments-nvim
    # ^ UI
    # Motion
    precognition-nvim
    leap-nvim
    treewalker-nvim
    # ^ Motion
    # language support
    rustaceanvim #  A heavily modified fork of rust-tools.nvim that does not require a setup call and does not depend on nvim-lspconfig. | https://github.com/mrcjkb/rustaceanvim
    # ^ language support
    # navigation/editing enhancement plugins
    vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # A plugin for adding/changing/deleting surrounding delimiter pairs. | https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # Create your own textobjects using Tree-sitter queries. |  https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring #  Sets the commentstring option based on the cursor location in the file. The location is checked via Tree-sitter queries. | https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins
    # Useful utilities
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    nvim-ufo # Ultra fold with modern looking and performance boosting. | https://github.com/kevinhwang91/nvim-ufo
    neo-tree-nvim
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nvim-web-devicons
    promise-async
    vim-repeat
    nui-nvim
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    (mkNvimPlugin 
      (pkgs.fetchFromGitHub {
        owner = "craftzdog";
        repo = "solarized-osaka.nvim";
        rev = "725064069861811398e6d7f4653e6be6d760a07d";
        sha256 = "8z7ULBp2oEwLoLPgtUREORbB/GZjzXxHXB1cIKUU024=";
      } // {lastModifiedDate = "2025-01-07";})
      "solarized-osaka"
    )
    /*
    (mkNvimPlugin
      (pkgs.fetchFromGitHub {
        owner = "alexmozaidze";
        repo = "tree-comment.nvim";
        rev = "525a37cececcbd0e4dd1429b7c966302d2abcf64";
        sha256 = "sha256-Xs2m09H7W/H5GikZmhg3+0eooKRfe6SUTDaks/QFZBY=";
      } // {lastModifiedDate = "2025-11-18";})
      "tree-comment-nvim"
    )*/
    (mkNvimPlugin
      (pkgs.fetchFromGitHub {
        owner = "dmmulroy";
        repo = "ts-error-translator.nvim";
        rev = "558abff11b9e8f4cefc0de09df780c56841c7a4b";
        sha256 = "sha256-kjZwfvb0B7GC4dBBSdgC/zRmCUCfCm4H5J+8SFzANJ4=";
      } // {lastModifiedDate = "2026-01-03";})
      "ts-error-translator-nvim"
    )
    # ^ bleeding-edge plugins from flake inputs
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    lua-language-server # duh
    nil # nix LSP
    alejandra # nix formatter
    nodePackages.typescript-language-server
    rust-analyzer
    ocamlPackages.ocaml-lsp
    # ^ language servers
    ripgrep
    lazygit
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
