#  sudo nixos-rebuild switch --upgrade-all
  #  sudo nix-collect-garbage -d **try not to use** 

# edit this configuration file to define what should be installed on

# and in the nixos manual (accessible by running ‘nixos-help’).

  # Enable Prime offloading with optimus (NVIDIA Optimus laptops)
  # We don't need a separate option here, NixOS automatically handles GPU offloading via the X server.
  # You can use `primusrun` or `optirun` to offload to the NVIDIA GPU
{ lib, pkgs, ... } @args:
{

imports = [ # include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # define your hostname.
  # networking.wireless.enable = true;  # enables wireless support via wpa_supplicant.

  # configure network proxy if necessary
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

#hyprland 
  kitty
  tofi
  waybar
  killall
  dolphin
  brightnessctl
  grimblast # helper for screenshots within hyprland
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
   programs.hyprland.enable = true;

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
