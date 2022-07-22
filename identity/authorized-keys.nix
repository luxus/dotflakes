let
  inherit (builtins) readFile;
  inherit (peers) hosts;
  peers = import ../ops/metadata/peers.nix;
  # yubiGpg = readFile ./ssh-yubikey.pub;
in
  with hosts;
    # [yubiGpg]
    emily.keys
    ++ emily.users.luxus.keys
    ++ vanessa.users.luxus.keys
    ++ kaiphone.users.blink.keys
    ++ kaiphone.users.workingcopy.keys
    ++ kaipad.users.blink.keys
