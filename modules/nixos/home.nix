{
  config,
  inputs,
  specialArgs,
  username,
  ...
}: let
  cfg = config.nMods.de.environment;
  isPlasma = cfg == "plasma";
in {
  home-manager = {
    backupFileExtension = "bak";
    extraSpecialArgs = specialArgs;
    sharedModules = [
      ../home
      ../home/de
      inputs.plasma-manager.homeModules.plasma-manager
    ];
    users.${username} = {
      hMods.de.enablePM = isPlasma;
    };
  };
}
