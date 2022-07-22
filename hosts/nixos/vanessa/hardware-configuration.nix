{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    refind
  ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  systemd.services.systemd-udev-settle.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  virtualisation.kvmgt = {
    enable = true;
    device = "0000:00:02.0";
    vgpus = {
      i915-GVTg_V5_4 = {
        uuid = [
          "15feffce-745b-4cb6-9f48-075af14cdb6f"
        ];
      };
    };
  };
  services.hercules-ci-agent.settings = {
    concurrentTasks = 2;
  };
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = [
    pkgs.amdvlk
    pkgs.rocm-opencl-icd
  ];
  # To enable Vulkan support for 32-bit applications, also add:
  hardware.opengl.extraPackages32 = [
    pkgs.driversi686Linux.amdvlk
  ];

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
  # Or
  environment.variables.VK_ICD_FILENAMES =
    "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  # FIXME: do we need this?
  systemd.coredump.enable = true;
  boot = {
  kernelModules = [ "v4l2loopback" "kvm-intel" "wl" ];
#FIXME:this line doesnt work
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out broadcom_sta];
    loader = {
      timeout = lib.mkDefault 5;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 100;
      };
    };

    initrd = {
      systemd.enable = true;
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod" "uas"];
      kernelModules = ["amdgpu" "tpm" "tpm_tis" "tpm_crb"];
      luks.forceLuksSupportInInitrd = true;
      luks.devices."enc".device = "/dev/disk/by-uuid/2c913cfd-aa74-4629-b8a0-0a0a080e1f19";
      verbose = false;
    };
    consoleLogLevel = 0;
    # plymouth = {
    #   enable = true;
    #   theme = "spinning-watch";
    #   font = "${pkgs.ibm-plex}/share/fonts/opentype/IBMPlexSans-Text.otf";
    #   themePackages = with pkgs; [
    #     plymouth-spinning-watch-theme
    #   ];
    # };
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a5a16dd1-f62f-4175-9144-fd2cd8383643";
    fsType = "btrfs";
    options = ["subvol=root"];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/a5a16dd1-f62f-4175-9144-fd2cd8383643";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/a5a16dd1-f62f-4175-9144-fd2cd8383643";
    fsType = "btrfs";
    options = ["subvol=persist"];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/a5a16dd1-f62f-4175-9144-fd2cd8383643";
    fsType = "btrfs";
    options = ["subvol=var-log"];
    neededForBoot = true;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/61B1-2C06";
    fsType = "vfat";
  };
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/fa4fe315-136c-47d2-9ecb-726d4901ae75";
    }
  ];
}
