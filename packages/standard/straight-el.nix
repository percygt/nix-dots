{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "straight.el";
  src = fetchFromGitHub {
    owner = "radian-software";
    repo = "straight.el";
    rev = "59c92dd45085b8f8fc44ea0039c205f4a3c43b62";
    sha256 = "00ibxmgqfb5bqd4b9jqj8vdiszkph6vv64m1y3kf9xav15v8sfyx";
  };
  buildPhase = ''
    sed -i -e 's|(with-current-buffer|(with-temp-buffer|g' install.el
    sed -i -e 's|(url-retrieve-synchronously|(insert-file-contents "'"$out"'/share/straight/straight.el")|g' install.el
    sed -i -e 's|         (format||g' install.el
    sed -i -e 's|(concat "https:\/\/raw.githubusercontent.com\/"||g' install.el
    sed -i -e 's|"raxod502\/straight.el\/install\/%s\/straight.el")||g' install.el
    sed -i -e 's|(substring (symbol-name version) 1))||g' install.el
    sed -i -e "s|'silent 'inhibit-cookies)||g" install.el
    sed -i -e "s|(unless (equal url-http-response-status 200)||g" install.el
    sed -i -e 's|(error "Unknown recipe version: %S" version))||g' install.el
    sed -i -e "s|(delete-region (point-min) url-http-end-of-headers)||g" install.el
    echo '(defvar bootstrap-version)
          (let ((bootstrap-file
                 (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
                (bootstrap-version 5))
            (unless (file-exists-p bootstrap-file)
              (with-temp-buffer
                (insert-file-contents "'"$out"'/share/straight/install.el")
                (goto-char (point-max))
                (eval-print-last-sexp)))
            (load bootstrap-file nil '"'"'nomessage))' > init.el
     echo -e '#!/bin/bash\necho -n "'"$out"'/share/straight/init.el"' > straight-init-path
  '';
  installPhase = ''
    mkdir -p $out/share/straight
    cp install.el straight.el init.el $out/share/straight/
    mkdir -p $out/bin
    cp straight-init-path $out/bin/
    chmod +x $out/bin/straight-init-path
  '';
}
