{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        catppuccin.catppuccin-vsc
        pkief.material-product-icons

        #CPP
        ms-vscode.cpptools
        adpyke.codesnap
        oderwat.indent-rainbow

        #RUST
        rust-lang.rust-analyzer
        vadimcn.vscode-lldb
    ];
  };
}