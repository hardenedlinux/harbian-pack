# Build a package

In order to build a package, first enter the environment according to the
commands in enter-environment.md.

The debian package "build-essential" is assumed to be installed, and won't
be listed in the build dependencies.

Then run `do_build aaa/bbb`. `aaa/bbb` is a directory under pkgs/ directory,
which contains a build.sh file.

The resulting dpkg packages will be available under out/deb/ directory.
