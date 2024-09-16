{ pkgs }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "deepcool-ak-series-monitor";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "raghulkrishna";
    repo = "deepcool-ak620-digital-linux";
    rev = "master";  # You can change this to a specific commit hash
    sha256 = "sha256-UNDEFINED"; # Use nix-prefetch-git to find the correct sha256
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    hidapi
    psutil
  ];

  # Ensure the Python script is installed as a command-line tool
  installPhase = ''
    mkdir -p $out/bin
    cp *.py $out/bin/deepcool-monitor
    chmod +x $out/bin/deepcool-monitor
  '';

  meta = with pkgs.lib; {
    description = "Monitor DeepCool AK series coolers on Linux";
    homepage = "https://github.com/raghulkrishna/deepcool-ak620-digital-linux";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}