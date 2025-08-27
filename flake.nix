{
  description = "ZaneyOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.05";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
    host = "nabilos";
    profile = "nvidia-laptop";
    username = "majestic";

    # NEW: bring a pkgs handle into scope for devShells
    pkgs = import nixpkgs { inherit system; };

    resolveOverlayModule = { pkgs, lib, ... }: {
      nixpkgs = {
        overlays = [ (import ./overlays/davinci-resolve-local.nix) ];
        config = {
          allowUnfree = true;
          allowUnfreePredicate = pkg:
            lib.elem (lib.getName pkg) [ "davinci-resolve" "davinci-resolve-studio" ];
        };
      };
    };
  in
  {
    # ⬇️ Replace your devShells block with this:
    devShells.${system} = rec {
      manim = pkgs.mkShell {
        packages = with pkgs; [
          (python3.withPackages (ps: [ ps.pip ]))
            # runtime deps
            ffmpeg
            cairo
            pango
            pkg-config

            # 🔧 build tools + headers for pycairo/manimpango
            ninja
            meson
            gcc
            gobject-introspection
            glib
            libffi
        ];

        shellHook = ''
          # Runtime libs for manylinux wheels (NumPy, PyAV, etc.) on NixOS
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
            pkgs.glib
            pkgs.libffi
            pkgs.cairo
            pkgs.pango
            pkgs.gobject-introspection
          ]}:$LD_LIBRARY_PATH

          # Shared venv for all TikTok folders
          if [ -n "$TIKTOK_VENV_HOME" ]; then
            VENV_HOME="$TIKTOK_VENV_HOME"
          else
            VENV_HOME="$HOME/Documents/TikTok/.venv"
          fi

          if [ ! -d "$VENV_HOME" ]; then
            python3 -m venv "$VENV_HOME"
          fi
          . "$VENV_HOME/bin/activate"
          echo "✅ Activated shared venv: $VENV_HOME"
          echo 'Tip: pip install "manim>=0.19" MF_Tools'
        '';
      };

      default = manim;
    };

    nixosConfigurations = {
      amd = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [./profiles/amd];
      };
      nvidia = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [./profiles/nvidia];
      };
      nvidia-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [
          ./profiles/nvidia-laptop
          resolveOverlayModule
        ];
      };
      intel = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [./profiles/intel];
      };
      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
        };
        modules = [./profiles/vm];
      };
    };
  };
}
