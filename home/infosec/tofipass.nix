{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.infosec.pass.enable {
    home.packages = with pkgs; [
      (
        writeShellScriptBin
        "tofipass"
        ''
          shopt -s nullglob globstar

          dmenu="${pkgs.tofi}/bin/tofi"

          prefix=''${PASSWORD_STORE_DIR- ~/.password-store}
          password_files=( "$prefix"/**/*.gpg )
          password_files=( "''${password_files[@]#"$prefix"/}" )
          password_files=( "''${password_files[@]%.gpg}" )

          password=$(printf '%s\n' "''${password_files[@]}" | ${pkgs.tofi}/bin/tofi  --prompt-text="Passmenu: ")

          [[ -n $password ]] || exit

          pass show -c "$password" 2>/dev/null
        ''
      )
    ];
  };
}
