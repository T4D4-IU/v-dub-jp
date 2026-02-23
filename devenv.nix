{ pkgs, lib, config, ... }: {
  # https://devenv.sh/basics/
  languages.rust.enable = true;
  languages.rust.channel = "stable";
  languages.rust.components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];

  # https://devenv.sh/packages/
  packages = with pkgs; [
    ffmpeg
    yt-dlp
    bacon
    jj
    gh
  ];

  # https://devenv.sh/scripts/
  scripts.test.exec = "cargo test";
  scripts.check.exec = "cargo clippy";

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks.rustfmt.enable = true;
  pre-commit.hooks.clippy.enable = true;

  enterShell = ''
    echo "🎥 Video Dubbing Platform Dev Environment"
    cargo --version
    ffmpeg -version | head -n 1
    yt-dlp --version
  '';
}
