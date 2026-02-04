{
  description = "NixOS configuration for rowii";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-ld.url = "github:Mic92/nix-ld";
    unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    LazyVim = {
      url = "github:matadaniel/LazyVim-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    # dgop = {
    #   url = "github:AvengeMedia/dgop";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # dms-cli = {
    #   url = "github:AvengeMedia/danklinux";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # dankMaterialShell = {
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.dgop.follows = "dgop";
    #   inputs.dms-cli.follows = "dms-cli";
    # };
    # ags = {
    #   url = "github:aylur/ags";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # astal = {
    #   url = "github:aylur/astal";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # claude-desktop = {
    #   url = "github:k3d3/claude-desktop-linux-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
    #   # to have it up-to-date or simply don't specify the nixpkgs input
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    ghostty,
    nix-ld,
    aagl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        {
            imports = [ aagl.nixosModules.default ];
            # nix.settings = aagl.nixConfig; # Set up Cachix
            programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
            programs.anime-games-launcher.enable = true;
            # programs.honkers-railway-launcher.enable = true;
            # programs.honkers-launcher.enable = true;
            # programs.wavey-launcher.enable = true;
            # programs.sleepy-launcher.enable = true;
        }
        nix-ld.nixosModules.nix-ld
        { programs.nix-ld.dev.enable = true; }
        ({ pkgs, ... }: {
          environment.systemPackages = [
          ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
        })
        {
          nixpkgs = {
            config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
              allowAliases = true;
              permittedInsecurePackages = [
                "electron-25.9.0" # Obsidian
                "python-2.7.18.8"
                "beekeeper-studio-5.5.3" # electron 31
              ];
            };
            hostPlatform = system;
          };
        }
        ./hosts/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs;};
            users.ibarahime = import ./home-manager/htrowii.nix;
            backupFileExtension = "backup-" + pkgs.lib.readFile "${pkgs.runCommand "timestamp" { env.when = self.sourceInfo.lastModified; } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";
          };
        }
      ];
    };
  };
}
