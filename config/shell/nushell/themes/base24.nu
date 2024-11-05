let c = source ($nu.default-config-dir | path join base24-colorscheme.nu)
{
  # color for nushell primitives
  separator: $c.base06
  leading_trailing_space_bg: $c.base04
  header: $c.base0B
  date: $c.base16
  filesize: $c.base0D
  row_index: $c.base0C
  bool: $c.base08
  int: $c.base0B
  duration: $c.base08
  range: $c.base08
  float: $c.base08
  string: $c.base04
  nothing: $c.base08
  binary: $c.base08
  cellpath: $c.base08
  empty: $c.base0D
  # Closures can be used to choose colors for specific values.
  # The value (in this case, a bool) is piped into the closure.
  # eg) {|| if $in { '$c.base04' } else { 'light_gray' } }
  cell-path: $c.base05
  record: $c.base05
  list: $c.base06
  block: $c.base06
  hints: $c.base03
  search_result: { bg: $c.base08 fg: $c.base05 }
  shape_and: { fg: $c.base0E attr: b}
  shape_binary: { fg: $c.base0E attr: b}
  shape_block: { fg: $c.base0D attr: b}
  shape_bool: $c.base04
  shape_closure: { fg: $c.base0B attr: b}
  shape_custom: $c.base0B
  shape_datetime: { fg: $c.base0C attr: b}
  shape_directory: $c.base0C
  shape_external: $c.base0C
  shape_externalarg: { fg: $c.base0B attr: b}
  shape_external_resolved: { fg: $c.base0A attr: b}
  shape_filepath: $c.base0C
  shape_flag: { fg: $c.base0D attr: b}
  shape_float: { fg: $c.base0E attr: b}
  # shapes are used to change the cli syntax highlighting
  shape_garbage: { fg: $c.base05 bg: $c.base08 attr: b }
  shape_glob_interpolation: { fg: $c.base0C attr: b}
  shape_globpattern: { fg: $c.base0C attr: b}
  shape_int: { fg: $c.base0E attr: b}
  shape_internalcall: { fg: $c.base0C attr: b}
  shape_keyword: { fg: $c.base0C attr: b}
  shape_list: { fg: $c.base0C attr: b}
  shape_literal: $c.base0D
  shape_match_pattern: $c.base0B
  shape_matching_brackets: { attr: u }
  shape_nothing: $c.base04
  shape_operator: $c.base13
  shape_or: { fg: $c.base0E attr: b}
  shape_pipe: { fg: $c.base0E attr: b}
  shape_range: { fg: $c.base09 attr: b}
  shape_record: { fg: $c.base0C attr: b}
  shape_redirection: { fg: $c.base0E attr: b}
  shape_signature: { fg: $c.base0B attr: b}
  shape_string: $c.base0B
  shape_string_interpolation: { fg: $c.base0C attr: b}
  shape_table: { fg: $c.base0D attr: b}
  shape_variable: $c.base17
  shape_vardecl: $c.base17
  shape_raw_string: $c.base0E

  flatshape_garbage: { fg: $c.base07 bg: $c.base08 attr: b}
  # if you like the regular $c.base05 on $c.base08 for parse errors:
  # flatshape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
  flatshape_bool: $c.base0D
  flatshape_int: { fg: $c.base0E attr: b}
  flatshape_float: { fg: $c.base0E attr: b}
  flatshape_range: { fg: $c.base13 attr: b}
  flatshape_internalcall: { fg: $c.base0C attr: b}
  flatshape_external: $c.base0C
  flatshape_externalarg: { fg: $c.base0B attr: b}
  flatshape_literal: $c.base0D
  flatshape_operator: $c.base13
  flatshape_signature: { fg: $c.base0B attr: b}
  flatshape_string: $c.base0B
  flatshape_filepath: $c.base0D
  flatshape_globpattern: { fg: $c.base0D attr: b}
  flatshape_variable: $c.base0E
  flatshape_flag: { fg: $c.base0D attr: b}
  flatshape_custom: {attr: b}
}
