{
  pkgs,
  host,
  options,
  ...
}: {
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    nameservers = [ "1.1.1.1" ];
    extraHosts = ''
      151.101.65.140 reddit.com
      151.101.1.140 reddit.com
      151.101.193.140 reddit.com
      151.101.129.140 reddit.com
      151.101.65.140 www.reddit.com
      151.101.1.140 www.reddit.com
      151.101.193.140 www.reddit.com
      151.101.129.140 www.reddit.com
    '';
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
        8080
        53317
      ];
      allowedUDPPorts = [
        59010
        59011
        53317
      ];
    };
  };

  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
