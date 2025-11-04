{...}: {
  programs = {
    gh.enable = true;
    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = "true";
        push.autoSetupRemote = "true";
        user = {
          name = "akhlus";
          email = "93236986+akhlus@users.noreply.github.com";
        };
      };
    };
  };
}
