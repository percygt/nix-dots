{
  org-tangle =
    block-predicate: text:
    let
      blocks = (import ./from-elisp).parseOrgModeBabel text;
      block-to-str =
        block: if block-predicate { inherit (block) language flags; } then block.body else "";
    in
    builtins.concatStringsSep "\n" (map block-to-str blocks);
}
