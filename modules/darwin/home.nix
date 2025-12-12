{
  specialArgs,
  ...
}: {
  home-manager = {
    backupFileExtension = "bak";
    extraSpecialArgs = specialArgs;
    sharedModules = [ ../home];
  };
}
