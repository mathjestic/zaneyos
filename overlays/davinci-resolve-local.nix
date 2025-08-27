# overlays/davinci-resolve-local.nix
final: prev: {
  # For the free edition. Use davinci-resolve-studio for Studio.
  davinci-resolve = prev.davinci-resolve.overrideAttrs (old: {
    version = "20.1";
    src = prev.requireFile {
      # must match your local filename exactly
      name = "DaVinci_Resolve_20.1_Linux.zip";
      # you can paste the base32 printed by nix-prefetch-url directly:
      sha256 = "16s5vcra81av4p6ncdiwr7w6ci7rp82ny80y6yvyrsd7zkwv4zlx";
      # only a hint for humans; not used to download
      url = "https://www.blackmagicdesign.com/support";
    };
  });
}
