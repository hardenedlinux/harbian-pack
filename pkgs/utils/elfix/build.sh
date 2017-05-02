VER=0.9.2
SRCTBL="https://dev.gentoo.org/~blueness/elfix/elfix-$VER.tar.gz"
SRCTBL_MD5="207c91390546e431b14d89a7501d5eca"
SRCDIR="elfix-$VER"
BUILDDEP="python-dev libelf-dev libattr1-dev"

builddep_populate $BUILDDEP

clean_build elfix
clean_package elfix python-pax

enter_build_dir elfix

get_src_net_with_md5 "$SRCTBL" "$SRCTBL_MD5"

auto_extract_src
enter_build_dir elfix

do_autoconf elfix
do_make elfix
do_make_inst elfix

cd scripts

XTPAX=1 python setup.py install --root="`get_pkg_dir python-pax`" --prefix=/usr

enter_def_dir

prepare_control control.python-pax python-pax ver=$VER
prepare_control control.elfix elfix ver=$VER

do_pack python-pax
do_pack elfix

enter_top_dir

clean_build elfix
