{
  programs.git.settings.aliases = {
    rs = "reset --soft HEAD^";
    s = "status";
    co = "checkout";
    cb = "checkout -b";
    llg = "log --graph --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ar)%Creset'";
    dub = "fetch -p && git branch -vv | grep ': gone]' | awk '{print }' | xargs git branch -D";
    lg = "llg -n25";
    d = "diff";
    c = "commit";
    ca = "commit --amend";
    can = "commit -amend --no-edit";
    pushf = "push --force-with-lease";
    mom = "merge origin/main --no-edit";
    pum = "pull upstream main";
    p = "pull";
    P = "push";
    br = "branch";
    # Fetch repo and blow out local branch, favoring upstream commits
    reset-origin = "!git fetch && git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)";
    nuke-untracked = "!git status --porcelain | awk '{print $2}' | xargs rm -rf";
  };
}
