{pkgs, ...}:
let
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${./layout.xkb} $out
  '';
in
{
    environment.systemPackages = with pkgs; [
        xorg.xkbcomp
    ];
    services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
}
