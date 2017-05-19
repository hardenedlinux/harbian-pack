# Add a package

First, please ensure that you can build an existing package!

The build script of a package is the build.sh file in its build definition
directory (the directory under pkgs/). (Sometimes a build.sh can create
multiple packages if necessary)

In fact the build system is very simple -- you can just build .deb files
and copy them to out/deb/ directory. This functionality will be useful
if the source code contains a proper system for building .deb packages,
e.g. the Linux kernel. However the packages should be properly named
in the "${NAME}\_${VER}\_${ARCH}.deb" role, in order to make the helper
functions to work properly.

There's also many now many helper functions to use in build.sh, and the
number of helper functions is still increasing if needed.

Here's a list of them:

### builddep\_populate

Install a set of packages (building dependencies).

- Parameters: packages to be installed.

### clean\_build

Clean build directories.

- Parameters: the build directories name to be cleaned.

### clean\_package

Clean packages. Both the packaged .deb files and the unpackaged directories
under out/not\_packaged/ will be cleaned.

- Parameters: packages to be cleaned.

### do\_autoconf

Automatically run a autoconf-based "./configure" script.

***NOTE: PLEASE DO NOT USE IT ON NON-AUTOCONF SCRIPTS***

- Parameters: extra parameters to be passed to the script.

### do\_make

Automatically run a generic "make" command.

- Parameters: extra parameters to be passed to the command.

### do\_make\_inst

Automatically run a wrapped generic "make install" command, with DESTDIR
set to install the files to a package's not packaged file directory (under
out/not\_packaged/ directory) and wait it to be packaged.

- Parameter 1: the package name.
- Remaining parameters: extra parameters to be passed to the command.

### do\_pack

Pack a .deb package from a directory in out/not\_packaged/.

You should ensure needed files under DEBIAN/ are also populated before
calling this.

- Parameter 1: the package name.

### enter\_build\_dir

Enter a build directory. It will be a directory under build/ directory now,
and can be cleaned when clean\_build is called with the same directory name.

When it's not cleaned, you can enter it again, and all the contents are kept.

- Parameter 1: the build directory name to enter.

### enter\_def\_dir

Enter the build definition directory of the currently used build definition.

No parameters are needed.

### enter\_top\_dir

Enter the top building system directory.

No parameters are needed.

### prepare\_control

Prepare a DEBIAN/control file based on an existing template.

- Parameter 1: the template file name.
- Parameter 2: the target package name.
- Remaining parameters: parsed as named parameters, which is in the format
  of "name=value". Currently only one name is supported and necessary --
  "var", which should have a value of the current version of this package.
