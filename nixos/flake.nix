{
  description = "Multi-system NixOS and nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld.url = "github:Mic92/nix-ld";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
  url = "github:schembriaiden/helium-browser-nix-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "stable";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    hyprland.url = "github:hyprwm/Hyprland";
    # awww.url = "git+https://codeberg.org/LGFae/awww";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # quickshell = {
    #   url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    # caelestia-shell = {
    #   url = "github:caelestia-dots/shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # ags = {
    #   url = "github:aylur/ags";
    #   inputs.nixpkgs.follows = "stable";
    # };
    # astal = {
    #   url = "github:aylur/astal";
    #   inputs.nixpkgs.follows = "stable";
    # };
    # zen-browser.url = "github:MarceColl/zen-browser-flake";
    pwndbg.url = "github:pwndbg/pwndbg";
    pwndbg.inputs.nixpkgs.follows = "nixpkgs";
    nixcord.url = "github:FlameFlag/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      stable,
      nix-darwin,
      home-manager,
      home-manager-stable,
      ghostty,
      aagl,
      ...
    }@inputs:
    let
      vars = import ./vars.nix;

      nixpkgsConfig = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
        allowAliases = true;
        permittedInsecurePackages = [
          "electron-25.9.0" # Obsidian
          "python-2.7.18.8"
          "beekeeper-studio-5.5.5" # electron 32
        ];
      };

      mkNixosHost =
        {
          hostName, # e.g. "zephyrus", "linux", "thinkpad"
          hostVars, # e.g. vars.zephyrus
          nixpkgsInput ? nixpkgs, # which nixpkgs to use
          hmInput ? home-manager, # which home-manager to use
          hmUserFile, # e.g. ./home-manager/htrowii.nix
          extraModules ? [ ],
        }:
        let
          system = hostVars.system;
          pkgs = nixpkgsInput.legacyPackages.${system};
          hostVar = { inherit hostVars; };
        in
        nixpkgsInput.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs vars;
            hostVars = hostVars;
          };
          modules = [
            {
              nixpkgs = {
                config = nixpkgsConfig;
                hostPlatform = system;
              };
            }
            # nix-ld.nixosModules.nix-ld
            # { programs.nix-ld.dev.enable = true; }
            (
              { pkgs, ... }:
              {
                environment.systemPackages = [
                  ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
                ];
              }
            )
            ./hosts/${hostName}/configuration.nix
            hmInput.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs vars;
                  hostVars = hostVars;
                };
                users.${hostVars.username} = import hmUserFile;
                backupFileExtension =
                  "backup-"
                  + pkgs.lib.readFile "${pkgs.runCommand "timestamp" {
                    env.when = self.sourceInfo.lastModified;
                  } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        zephyrus = mkNixosHost {
          hostName = "zephyrus";
          hostVars = vars.zephyrus;
          hmUserFile = ./home-manager/venti.nix;
          extraModules = [
            {
              nixpkgs.overlays = [ (import ./overlays/soapymiri.nix) ];
              # imports = [ aagl.nixosModules.default ];
              # programs.anime-game-launcher.enable = false;
              # programs.anime-games-launcher.enable = false;
            }
          ];
        };

        linux = mkNixosHost {
          hostName = "linux";
          hostVars = vars.linux;
          hmUserFile = ./home-manager/htrowii.nix;
          extraModules = [
            {
              imports = [ aagl.nixosModules.default ];
              nix.settings = aagl.nixConfig;
              programs.anime-game-launcher.enable = true;
              programs.anime-games-launcher.enable = true;
              nixpkgs.overlays = [ (import ./overlays/soapymiri.nix) ];
            }
          ];
        };

        thinkpad = mkNixosHost {
          hostName = "thinkpad";
          hostVars = vars.thinkpad;
          nixpkgsInput = stable;
          hmUserFile = ./home-manager/violet.nix;
          extraModules = [ ];
        };
	edgy14yearold = mkNixosHost {
          hostName = "edgy14yearold";
          hostVars = vars.e14;
          hmUserFile = ./home-manager/violet.nix;
          extraModules = [ ];
        };

      };

      darwinConfigurations.${vars.darwin.hostname} = nix-darwin.lib.darwinSystem {
        system = vars.darwin.system;
        specialArgs = {
          inherit inputs vars;
          hostVars = vars.darwin;
        };
        modules = [
          ./darwin/configuration.nix
          home-manager.darwinModules.home-manager
          { nixpkgs.config.allowUnfree = true; }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs vars;
                hostVars = vars.darwin;
              };
              users.${vars.darwin.username} = import ./darwin-home/ibarahime.nix;
              backupFileExtension =
                "backup-"
                +
                  (nixpkgs.legacyPackages.${vars.darwin.system}).lib.readFile
                    "${(nixpkgs.legacyPackages.${vars.darwin.system}).runCommand "timestamp" {
                      env.when = self.sourceInfo.lastModified;
                    } "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";
            };
          }
        ];
      };
    };
}
