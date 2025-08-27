{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    blender
    davinci-resolve
    discord
    entr
    ffmpeg
    gitFull
    git-credential-manager
    gpick
    libreoffice-qt6-fresh
    localsend
    manim
    neofetch
    nodePackages_latest.nodejs
    nodePackages_latest.np
    obs-studio
    obsidian
    kdePackages.okular
    texlive.combined.scheme-full # asymptote included
    vlc
    vscode
    yt-dlp
    zathura
    zoom-us
  ];
}
