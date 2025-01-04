#  sudo nixos-rebuild switch --upgrade-all
  #  sudo nix-collect-garbage -d **try not to use** 

# edit this configuration file to define what should be installed on

# and in the nixos manual (accessible by running ‘nixos-help’).

  # Enable Prime offloading with optimus (NVIDIA Optimus laptops)
  # We don't need a separate option here, NixOS automatically handles GPU offloading via the X server.
  # You can use `primusrun` or `optirun` to offload to the NVIDIA GPU
{ config, pkgs, ... }:

{

nix.extraOptions = ''
 experimental-features = nix-command flakes
'';


 programs.nix-ld.enable = true;
 programs.nix-ld.libraries = with pkgs; [
];


hardware.graphics = {
    enable = true;
  };

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};

imports = [
      ./hardware-configuration.nix
    ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;


  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # define your hostname.
  # networking.wireless.enable = true;  # enables wireless support via wpa_supplicant.


#Nvidia
services.xserver.videoDrivers = ["nvidia"];

hardware.nvidia = {
modesetting.enable = true; # Enable modesetting for better performance
powerManagement.enable = false; # Disable power management to avoid interruptions
powerManagement.finegrained = false; # Avoid fine-grained power management
open = false; # Stick with proprietary driver (better for gaming)
nvidiaSettings = true; # Enable nvidia-settings tool for GPU management
package = config.boot.kernelPackages.nvidiaPackages.stable; # Stable driver package

};
hardware.nvidia.prime = {
offload = {
enable = true;
enableOffloadCmd = true;
};
# Make sure to use the correct Bus ID values for your system!
intelBusId = "PCI:0:2:0"; # Intel GPU
nvidiaBusId = "PCI:1:0:0"; # NVIDIA GPU
# amdgpuBusId = "PCI:54:0:0"; # For AMD GPUs (not applicable here)
};


  #configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noproxy = "127.0.0.1,localhost,internal.domain";

  # enable networking
  networking.networkmanager.enable = true;

  # set your time zone.
  time.timeZone = "america/new_york";

  # select internationalisation properties.
 i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # configure keymap in x11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # define a user account. don't forget to set a password with ‘passwd’.
    users.users.jacob = {
    isNormalUser = true;
    description = "jacob";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];

    };

  # allow unfree packages
  nixpkgs.config.allowUnfree  = true;

# list packages installed in system profile. to search, run:
  # $ nix search wget
  
  environment.systemPackages = with pkgs; [
  #  vim # do not forget to add an editor to edit configuration.nix! the nano editor is also installed by default.

  #code
  neovim
  gh
  git
  wget
  gcc
  nodejs_23
  unzip
  python312
  pkg-config
  deno
  wl-clipboard
  luarocks
  stylua
  fzf
  picom
  obsidian
  python312Packages.pip
  python312Packages.cmake
  gnumake42
  libgccjit

#hyprland 
  kitty
  tofi
  waybar
  killall
  dolphin
  brightnessctl
  grim # helper for screenshots within hyprland
  slurp
  playerctl 
  networkmanagerapplet 
  dunst
  fish
  xdg-utils
  fastfetch
  hyprpaper
  swaybg
  wayland
  wayland-protocols
  mesa
  vulkan-tools
  wineWowPackages.waylandFull
  perl540Packages.OpenGL
  usbutils
  cheese
  v4l-utils
  libv4l
  jellyfin-ffmpeg
  gopro
  zenith-nvidia
  btop
  sxiv

  #personal applications
  vesktop
  google-chrome
  lunar-client
  obs-studio
  steam 
  heroic
  vlc
  spotify
  skypeforlinux
	
  #Nvidia
  nvtopPackages.nvidia
];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "CascadiaCode" ]; })
  ];

  #hyprland
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    waybar.enable = true;
    xwayland.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
};

  # Set cursor theme and size globally for XWayland and Wayland apps
  environment.variables = {
    XCURSOR_THEME = "HyprBibataModernClassicSVG";  # Cursor theme for XWayland apps
    XCURSOR_SIZE = "24";  # Cursor size for XWayland apps
    HYPRCURSOR_THEME = "HyprBibataModernClassicSVG";  # Cursor theme for Wayland apps (Hyprland)
    HYPRCURSOR_SIZE = "24";  # Cursor size for Wayland apps (Hyprland)
  };


# some programs need suid wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enablesshsupport = true;
  # };

  # list services that you want to enable:

  # enable the openssh daemon.
  # services.openssh.enable = true;

  # open ports in the firewall.
  # networking.firewall.allowedtcpports = [ ... ];
  # networking.firewall.allowedudpports = [ ... ];
  # or disable the firewall altogether.
  # networking.firewall.enable = false;

  # this value determines the nixos release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. it‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # did you read the comment?

}
