  #------------------------------------------------------------------------------

  { config, pkgs, ... }:
  
  {

  #------------------------------------------------------------------------------

  # Docker
  virtualisation.docker.enable = true;

  # Programs
  programs.hyprland.enable = true;
  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.fish;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #------------------------------------------------------------------------------

  # Nvidia
  hardware.graphics = {
     enable = true;
  };

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

  #------------------------------------------------------------------------------

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #------------------------------------------------------------------------------

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  #------------------------------------------------------------------------------

  # Network
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
 
  #------------------------------------------------------------------------------

  # System Settings
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  #------------------------------------------------------------------------------

  # Personal (local) Packages
  users.users.jacob = {
    isNormalUser = true;
    description = "jacob";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #------------------------------------------------------------------------------

  # System (global) Packages
  environment.systemPackages = with pkgs; [

  #code
  ghostty
  zed-editor
  neovim
  git
  gh
  wget
  deno
  python312
  pkg-config
  luarocks # (Lazyvim)
  stylua # (LazyVim)
  fzf #Fuzzy Finder (LazyVim)
  libgccjit
  nodejs_22
  sublime4
  llvmPackages_19.libcxxClang
  zoxide # Smarter Cli
  bun
  cargo
  rustup
  rustlings
  python312Packages.cmake
  typescript
  gnumake
  timer
  texliveTeTeX
  pandoc
  jdk21
  rocmPackages_5.llvm.clang-unwrapped
  helix
  helix-gpt
  sublime-merge-dev

  #System
  fish # Shell
  brightnessctl # Controls Brightness
  unzip # Unzip packages
  wl-clipboard # For automatically copying whole files  
  tofi # Search tool
  playerctl # Music Player for keys
  dunst # Notification daemon
  xdg-utils # command-line utilites
  fastfetch # cutom GUI prompt for cli
  hyprpaper # Hyprland wallpaper manager
  wayland 
  wayland-protocols
  mesa #Collection of graphic libraries that run OpenGL, Vulkan, ect.
  vulkan-tools
  wineWowPackages.waylandFull #For running window applications on Linux
  usbutils #Collection of tools for interacting with USB devices
  btop # Resource monitoring tool 
  gthumb # Image viewer
  glib # Low level core library (used by many Linux applications)
  gtk3 # To create window application (vauge)
  nvtopPackages.nvidia # For Nvidia
  openssl
  grimblast # Screenshot tool
  util-linux # Utils for Linux
  dolphin

  #personal
  obsidian
  google-chrome
  vesktop 
  lunar-client
  obs-studio
  steam
  zoom-us
  cider

  #Temp but don't want to nix-shell
  x11vnc
  ];

  #------------------------------------------------------------------------------

  # Other

# Set cursor theme and size globally for XWayland and Wayland apps
  environment.variables = {
    XCURSOR_THEME = "HyprBibataModernClassicSVG";  # Cursor theme for XWayland apps
    XCURSOR_SIZE = "24";  # Cursor size for XWayland apps
    HYPRCURSOR_THEME = "HyprBibataModernClassicSVG";  # Cursor theme for Wayland apps (Hyprland)
    HYPRCURSOR_SIZE = "24";  # Cursor size for Wayland apps (Hyprland)
  };

 
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  services.pipewire = {
     enable = true;
     audio.enable = true;
     extraConfig.pipewire = {
       "context.modules" = [
         { name = "libpipewire-module-bluez5"; args = { "a2dp.force-a2dp" = true; }; }
       ];
     };
   };

}

  #------------------------------------------------------------------------------
