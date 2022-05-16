final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) {};
  # then, call packages with `final.callPackage`

  ## dotflakes internals ========================================================

  dotflakes-config = prev.stdenv.mkDerivation {
    name = "dotflakes-config";
    src = final.gitignoreSource ../config;
    installPhase = ''
      mkdir -p $out
      cp -R * $out/
    '';
  };

  # dotflakes-php = prev.stdenv.mkDerivation {
  #   name = "dotflakes-php";
  #   src = ./dotflakes-php/vendor/bin;
  #   installPhase = ''
  #     mkdir -p $out
  #     cp -L * $out/bin
  #   '';
  # };

  ## third-party scripts =======================================================

  ediff-tool = final.stdenv.mkDerivation rec {
    name = "ediff-tool";
    src = final.gitignoreSource ../vendor/ediff-tool;
    installPhase = ''
      mkdir -p $out/bin
      cp ${name} $out/bin/${name}
    '';
  };

  git-submodule-rewrite = final.stdenv.mkDerivation rec {
    name = "git-submodule-rewrite";
    src = final.gitignoreSource ../vendor/git-submodule-rewrite;
    installPhase = ''
      mkdir -p $out/bin
      cp bin/${name} $out/bin/${name}
    '';
  };

  ## fonts =====================================================================

  sf-pro = final.callPackage ./fonts/sf-pro.nix {};
}
