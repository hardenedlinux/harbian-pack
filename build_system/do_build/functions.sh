builddep_populate() {
	for i in build-essential $*
	do
		if ! dpkg -l $i >/dev/null ; then
			apt-get install -y $i
		fi
	done
}

prepare_control() {
	local file pkg ver outf
	file="$1"
	pkg="$2"
	ver=""
	shift 2
	for i
	do
		if [ "`echo $i | cut -c 1-4`" = "ver=" ]; then
			ver="`echo $i | cut -c 5-`"
		fi
	done
	if [ ! -d "$OUT_DIR_INSTALL/$pkg" ]; then
		echo "Package $pkg not built!" >&2
		exit 1
	fi
	mkdir -p "$OUT_DIR_INSTALL/$pkg/DEBIAN"
	outf="$OUT_DIR_INSTALL/$pkg/DEBIAN/control"
	if ! cp "$file" "$outf"; then
		echo "Copy control file failed!" >&2
		exit 1
	fi
	if ! grep -q "^Version:" "$outf"; then
		echo "Version: @VERSION@" >> "$outf"
	fi
	if ! grep -q "^Architecture:" "$outf"; then
		echo "Architecture: @ARCH@" >> "$outf"
	fi
	if [ "$ver" != "" ]; then
		if ! sed -i 's/@VERSION@/'"$ver"'/g' "$outf"; then
			echo "Replace Version info failed!" >&2
			exit 1
		fi
	fi
	if ! grep -q '^Architecture: all$' "$outf"; then
		if ! sed -i 's/@ARCH@/'"$DPKG_ARCH"'/g' "$outf"; then
			echo "Replace Architecture info failed!" >&2
			exit 1
		fi
	fi
}

clean_build() {
	for i
	do
		rm -rf "$BUILD_DIR/$i"
	done
}

clean_package() {
	for i
	do
		rm -rf "$OUT_DIR_INSTALL/$i"
		rm -f "$OUT_DIR_DEB/$i_*"
	done
}

read_control_string() {
	grep "$2:" "$1" | cut -d ':' -f 2- | sed 's/^ //g'
}

do_pack() {
	local pkg_dir pkgname_control ver_control arch_control deb_file control_file
	pkg_dir="$OUT_DIR_INSTALL/$1"
	control_file="$pkg_dir/DEBIAN/control"
	if [ ! -e "$control_file" ]; then
		echo "Package $1 have currently no control file!" >&2
		exit 1
	fi
	pkgname_control="`read_control_string "$control_file" Package`"
	ver_control="`read_control_string "$control_file" Version`"
	arch_control="`read_control_string "$control_file" Architecture`"
	if [ "$pkgname_control" != "$1" ]; then
		echo "Package $1 has a different name $pkgname_control in control file!" >&2
		exit 1
	fi
	echo "Installed-Size: `du -s "$pkg_dir" | cut -d ' ' -f 1`" >> $control_file
	deb_file="$OUT_DIR_DEB/${pkgname_control}_${ver_control}_${arch_control}.deb"
	if ! dpkg-deb --build "$pkg_dir" "$deb_file"; then
		echo "Build $deb_file failed!" >&2
		exit 1
	fi
}

enter_def_dir() {
	cd "$def_dir"
}

enter_build_dir() {
	mkdir -p "$BUILD_DIR/$1"
	cd "$BUILD_DIR/$1"
	if [ "$SRCDIR" = "" ]; then
		for i in *
		do
			if [ -d "$i" ]; then
				SRCDIR="$i"
			fi
		done
	fi
	if [ "$SRCDIR" != "" ] && [ -d "$SRCDIR" ]; then
		cd "$SRCDIR"
	fi
}

enter_top_dir() {
	cd "$BUILD_TOP"
}

get_src_net_with_md5() {
	local filename
	filename="`basename "$1"`"
	wget "$1" -O "$filename"
	if [ "`md5sum $filename | cut -d ' ' -f 1`" != "$2" ]; then
		echo "MD5 checksum failed for file $1" >&2
		exit 1
	fi
}

auto_extract_src() {
	for i in *
	do
		if echo "$i" | grep '\.tar\.'; then
			tar xvf $i
		fi
	done
}

get_pkg_dir() {
	echo "$OUT_DIR_INSTALL/$1"
}

enter_pkg_dir() {
	cd "`get_pkg_dir "$1"`"
}

do_autoconf() {
	shift
	./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var "$@"
}

do_make() {
	make -j`nproc`
}

do_make_inst() {
	pkg="$1"
	make DESTDIR="`get_pkg_dir "$pkg"`" install
}
