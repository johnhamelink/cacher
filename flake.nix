{
  description = "Example Typescript DevShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      # See: https://flake.parts/debug
      debug = false;

      systems = [
        "x86_64-linux"
        "aarch64-linux"

        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              # For Nix
              nixd
              nixfmt-rfc-style
              fswatch # Used to re-run tests
              # For JS
              nodejs
              typescript-language-server # LSP Server
              vscode-js-debug # DAP debugger

              # This is used by Dape.el and js-comint.el as a less
              # buggy replacement for ts-node.
              (writeShellApplication {
                name = "ts-node";
                runtimeInputs = [
                  nodejs
                ];

                text = ''
                  # Use tsc to compile the typescript, but without
                  # emitting any resultant files.
                  ${pkgs.typescript}/bin/tsc --noEmit
                  # Execute the typescript with tsx
                  ${pkgs.nodejs}/bin/npx tsx -- "''${@}" 
                '';
              })
            ];

          };
        };
    };
}
