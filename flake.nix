{
  inputs.nixos.url = "github:CHN-beta/nixos";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs:
    let
      # pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      pkgs = import inputs.nixpkgs
      {
        localSystem.system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [ inputs.nixos.overlays.default ];
      };
    in
    {
      devShell.x86_64-linux = pkgs.mkShell.override { stdenv = pkgs.gcc13Stdenv; }
      {
        packages = with pkgs; [ pkg-config cmake ninja ];
        buildInputs =
          (with pkgs; [ fmt boost magic-enum libbacktrace ])
          ++ (with pkgs.localPackages; [ concurrencpp tgbot-cpp nameof ]);
        hardeningDisable = [ "all" ];
        # NIX_DEBUG = "1";
      };
    };
}
