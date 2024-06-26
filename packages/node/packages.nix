# This file has been generated by node2nix 1.11.1. Do not edit!
{
  nodeEnv,
  fetchurl,
  globalBuildInputs ? [],
}: let
  sources = {
    "@astrojs/compiler-1.8.2" = {
      name = "_at_astrojs_slash_compiler";
      packageName = "@astrojs/compiler";
      version = "1.8.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@astrojs/compiler/-/compiler-1.8.2.tgz";
        sha512 = "o/ObKgtMzl8SlpIdzaxFnt7SATKPxu4oIP/1NL+HDJRzxfJcAkOTAb/ZKMRyULbz4q+1t2/DAebs2Z1QairkZw==";
      };
    };
    "prettier-3.1.1" = {
      name = "prettier";
      packageName = "prettier";
      version = "3.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/prettier/-/prettier-3.1.1.tgz";
        sha512 = "22UbSzg8luF4UuZtzgiUOfcGM8s4tjBv6dJRT7j275NXsy2jb4aJa4NNveul5x4eqlF1wuhuR2RElK71RvmVaw==";
      };
    };
    "s.color-0.0.15" = {
      name = "s.color";
      packageName = "s.color";
      version = "0.0.15";
      src = fetchurl {
        url = "https://registry.npmjs.org/s.color/-/s.color-0.0.15.tgz";
        sha512 = "AUNrbEUHeKY8XsYr/DYpl+qk5+aM+DChopnWOPEzn8YKzOhv4l2zH6LzZms3tOZP3wwdOyc0RmTciyi46HLIuA==";
      };
    };
    "sass-formatter-0.7.8" = {
      name = "sass-formatter";
      packageName = "sass-formatter";
      version = "0.7.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/sass-formatter/-/sass-formatter-0.7.8.tgz";
        sha512 = "7fI2a8THglflhhYis7k06eUf92VQuJoXzEs2KRP0r1bluFxKFvLx0Ns7c478oYGM0fPfrr846ZRWVi2MAgHt9Q==";
      };
    };
    "suf-log-2.5.3" = {
      name = "suf-log";
      packageName = "suf-log";
      version = "2.5.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/suf-log/-/suf-log-2.5.3.tgz";
        sha512 = "KvC8OPjzdNOe+xQ4XWJV2whQA0aM1kGVczMQ8+dStAO6KfEB140JEVQ9dE76ONZ0/Ylf67ni4tILPJB41U0eow==";
      };
    };
  };
in {
  prettier-plugin-astro = nodeEnv.buildNodePackage {
    name = "prettier-plugin-astro";
    packageName = "prettier-plugin-astro";
    version = "0.12.3";
    src = fetchurl {
      url = "https://registry.npmjs.org/prettier-plugin-astro/-/prettier-plugin-astro-0.12.3.tgz";
      sha512 = "GthUSu3zCvmtVyqlArosez0xE08vSJ0R1sWurxIWpABaCkNGYFANoUdFkqmIo54EV2uPLGcVJzOucWvCjPBWvg==";
    };
    dependencies = [
      sources."@astrojs/compiler-1.8.2"
      sources."prettier-3.1.1"
      sources."s.color-0.0.15"
      sources."sass-formatter-0.7.8"
      sources."suf-log-2.5.3"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "A Prettier Plugin for formatting Astro files";
      homepage = "https://github.com/withastro/prettier-plugin-astro/";
      license = "MIT";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
}
