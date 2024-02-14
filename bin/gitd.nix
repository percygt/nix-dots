{pkgs}:
pkgs.writeShellScriptBin
"gitd"
/*
bash
*/
''
  URL=`echo $1`
  folder=`echo $URL | sed 's|tree/master|trunk|g'`

  "${pkgs.subversionClient}/bin/svn" export $folder
''
