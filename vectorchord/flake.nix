{
  description = "Vectorchord 1.0.0 override for PostgreSQL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Override vectorchord to version 1.0.0
        # The original package uses buildPgrxExtension which handles cargo dependencies
        vectorchord_1_0_0 = pkgs.postgresql18Packages.vectorchord.overrideAttrs (finalAttrs: previousAttrs: {
          version = "1.0.0";

          src = pkgs.fetchFromGitHub {
            owner = "tensorchord";
            repo = "VectorChord";
            tag = finalAttrs.version;
            hash = "sha256-+BOuiinbKPZZaDl9aYsIoZPgvLZ4FA6Rb4/W+lAz4so=";
          };

          # Override cargoHash for the new version's Cargo.lock
          # Build once with lib.fakeHash to get the correct hash, then replace it
          cargoHash = "sha256-kwe2x7OTjpdPonZsvnR1C/89D5W/R5JswYF79YcSFEA=";

          # Force cargoDeps to be regenerated from the new src and cargoHash
          cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
            inherit (finalAttrs) src;
            name = "${finalAttrs.pname}-${finalAttrs.version}";
            hash = finalAttrs.cargoHash;
          };

          meta = previousAttrs.meta // {
            broken = false;
          };
        });
      in
      {
        packages = {
          vectorchord = vectorchord_1_0_0;
          default = vectorchord_1_0_0;
        };

        # For use with devbox
        overlays.default = final: prev: {
          postgresql18Packages = prev.postgresql18Packages // {
            vectorchord = vectorchord_1_0_0;
          };
        };
      }
    );
}
