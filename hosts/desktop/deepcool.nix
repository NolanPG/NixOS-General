{ pkgs, lib, ... }:

let
  productId = "0x0001"; # Default value (ak400d), can be passed as a parameter
  sensor = "coretemp";  # Replace with the correct sensor label
  disableTemp = false;  # Can be passed as a parameter
  disableUtils = false; # Can be passed as a parameter
in

pkgs.stdenv.mkDerivation rec {
  pname = "deepcool-monitor";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "raghulkrishna";
    repo = "deepcool-ak620-digital-linux";
    rev = "master";
    sha256 = "sha256-xQnIqXhdoA94OkXyDkQ7ip2+JZBN1YvnRwclAcd++FE="; # Replace with the correct hash
  };

  nativeBuildInputs = [ pkgs.python3Packages.setuptools ];

  buildInputs = with pkgs.python3Packages; [
    hid
    hidapi
    psutil
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    hid
    hidapi
    psutil
  ];

  patchPhase = ''
    # Set PRODUCT_ID and SENSOR
    sed -i "/PRODUCT_ID = 0/c\PRODUCT_ID = ${productId}" deepcool-ak-series-digital.py
    sed -i "/SENSOR = \"\"/c\SENSOR = \"${sensor}\"" deepcool-ak-series-digital.py
    
    # Optionally disable temperature and CPU utilization display
    ${if disableTemp then "sed -i '/SHOW_TEMP = True/c\SHOW_TEMP = False' deepcool-ak-series-digital.py" else ""}
    ${if disableUtils then "sed -i '/SHOW_UTIL = True/c\SHOW_UTIL = False' deepcool-ak-series-digital.py" else ""}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp deepcool-ak-series-digital.py $out/bin/deepcool-ak-series-digital.py
    chmod +x $out/bin/deepcool-ak-series-digital.py
  '';

  meta = with lib; {
    description = "Monitor DeepCool AK series coolers on Linux";
    homepage = "https://github.com/raghulkrishna/deepcool-ak620-digital-linux";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}