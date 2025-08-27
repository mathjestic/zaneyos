{ host, lib, pkgs, config, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) intelID nvidiaID;

  # Expose the ENTIRE lib dir from the installed NVIDIA driver under /run/opengl-driver/lib
  nvidiaDriverLibs = pkgs.runCommand "nvidia-driver-libs" { } ''
    set -eu
    mkdir -p "$out/lib"
    drv="${config.hardware.nvidia.package}/lib"
    if [ -d "$drv" ]; then
      ln -s "$drv"/* "$out/lib/" || true
    fi
  '';
in {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];

  # Your existing toggles
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.intel.enable  = false;
  vm.guest-services.enable = false;

  # PRIME (hybrid laptop)
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId  = intelID;   # e.g. "PCI:0:2:0"
    nvidiaBusId = nvidiaID;  # e.g. "PCI:1:0:0"
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.rocmPackages.clr.icd
      pkgs.ocl-icd
      nvidiaDriverLibs      # -> puts all driver libs into /run/opengl-driver/lib
    ];
  };

  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;
    open = false;
    powerManagement.enable = lib.mkDefault false;
    powerManagement.finegrained = lib.mkDefault false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Provide a stable vendor file that points at the libfarm path
  environment.etc."OpenCL/vendors/nvidia.icd".text =
    "/run/opengl-driver/lib/libnvidia-opencl.so.1\n";

  # Let the loader search both vendor dirs
  environment.sessionVariables.OCL_ICD_VENDORS =
    "/etc/OpenCL/vendors:/run/opengl-driver/etc/OpenCL/vendors";

  # Tools + robust offload wrapper
  environment.systemPackages = with pkgs; [
    ocl-icd clinfo pciutils mesa-demos vulkan-tools
    (writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      export OCL_ICD_VENDORS="/etc/OpenCL/vendors:/run/opengl-driver/etc/OpenCL/vendors"

      drv_dir="$(dirname "$(readlink -f /run/opengl-driver/lib/libnvidia-opencl.so.1)")"
      if [ -n "$LD_LIBRARY_PATH" ]; then
        export LD_LIBRARY_PATH="/run/opengl-driver/lib:$drv_dir:$LD_LIBRARY_PATH"
      else
        export LD_LIBRARY_PATH="/run/opengl-driver/lib:$drv_dir"
      fi
      exec "$@"
    '')
  ];
}
