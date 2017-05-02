if [ ! -d "pkgs/$1" ]; then
	echo "Cannot find package $1" >&2
	exit 1
fi

def_dir="$BUILD_TOP/pkgs/$1"

source build_system/do_build/functions.sh

source "pkgs/$1/build.sh"
