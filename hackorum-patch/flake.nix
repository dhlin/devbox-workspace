{
  description = "Hackorum patch downloader and applier for PostgreSQL";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "hackorum-patch";
            version = "1.2.1";

            src = pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/hackorum-dev/hackorum/main/public/scripts/hackorum-patch";
              hash = "sha256-aYAga3YAyyJqS3LjeC0rI/GfBJdhSBh83AklmIX0lYU=";
            };

            dontUnpack = true;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall
              install -Dm755 $src $out/bin/hackorum-patch
              wrapProgram $out/bin/hackorum-patch \
                --set GEM_PATH "" \
                --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ruby pkgs.git ]}
              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Download and apply PostgreSQL patches from Hackorum";
              homepage = "https://github.com/hackorum-dev/hackorum";
              license = licenses.mit;
              mainProgram = "hackorum-patch";
            };
          };
        }
      );
    };
}
