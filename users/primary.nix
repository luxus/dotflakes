{
  username,
  hashedPassword ? "$6$I2LIdqsjBKTilFex$pUn6l2RxxP5LUyXYgbIV26FkNLWw79IB6nxEjSaKHNIQHo5ynbIM0rjT8oOiITdLxrMoR53oKwTIifOK9F1SO0",
}: {
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  secretsDir = ../secrets;

  sessionUser = builtins.getEnv "USER";
  name =
    if builtins.elem sessionUser ["" "root"]
    then username
    else sessionUser;

  userCfg = config.users.users.${name};
  sshHome = "${userCfg.home}/.ssh";
in
lib.mkMerge [
{
  users.users.${name} =
    {
      shell = pkgs.fish;
      home =
        if isDarwin
        then "/Users/${name}"
        else "/home/${name}";
    };
  #  age.identityPaths =
  #    ["${sshHome}/id_ed25519"]
  #    ++ options.age.identityPaths.default;
  #
  #  age.secrets."aws/aws-cdom-default.pem" = {
  #    file = "${secretsDir}/aws/aws-cdom-default.pem.age";
  #    path = "${sshHome}/aws-cdom-default.pem";
  #    owner = name;
  #  };
}
  (lib.mkIf (!isDarwin) {
    users.users.${name} = {
      extraGroups = [
        pkgs.lib.our.dotfield.group
        "wheel"
      ];
      hashedPassword = lib.mkDefault hashedPassword;
      isNormalUser = lib.mkForce true;
    };
  })
]
