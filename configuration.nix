{ config, pkgs, lib, ... }: {

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
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
    vim
  ];
  virtualisation.libvirtd.enable = true;
   virtualisation.msize =1048576;
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
