if echo "$0" | grep -qv bash; then
	echo "Please run this build system inside Bash!" >&2
	return 1
fi

if echo "$PS1" | grep -qv BUILD; then
	export PS1='BUILD '"$PS1"
fi

export BUILD_TOP="$PWD"
export BUILD_DIR="$PWD/build"
export OUT_DIR_INSTALL="$PWD/out/not_packaged"
export OUT_DIR_DEB="$PWD/out/deb"
export DPKG_ARCH="`dpkg --print-architecture`"
export IN_BUILD_SYS=1
mkdir -p "$BUILD_DIR" "$OUT_DIR_INSTALL" "$OUT_DIR_DEB"

do_build() {
	bash build_system/do_build/do_build.sh "$@"
}
