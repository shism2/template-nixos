{ config, pkgs, lib, ... }: {

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    useSandbox = true;
    autoOptimiseStore = true;
    readOnlyStore = false;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

  };
  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.openssh.listenAddresses = [{ addr = "0.0.0.0"; port = 22; }];
  services.openssh.passwordAuthentication = true;

  environment.systemPackages = with pkgs; [
    curl
    gitAndTools.gitFull
    htop
    sudo
    tmux
    vagrant
    vim
  ];

virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      enableOnBoot = true;
    };

    libvirtd = {
      enable=true;
    };
    msize =10485760;
  };



   boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  security.sudo.enable = true;

  users.users.root.password = "root";

  users.users.nixos = {
    createHome = true;
     group = "users";
     home = "/home/nixos";
     extraGroups =
       [ "qemu-libvirtd" "libvirtd"
         "wheel" "video" "audio" "disk" "networkmanager"
       ];
    isNormalUser = true;
    password = "nixos";
  };
}
