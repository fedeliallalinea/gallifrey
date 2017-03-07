# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit eutils multilib

GCC_VERSION="4.9.4"
GNATGCC_SLOT="4.9"
ISL_VERSION="0.12.2"
CLOOG_VERSION="0.18.1"

DESCRIPTION="Complete VHDL simulator using the GCC technology"
HOMEPAGE="http://ghdl.free.fr"
SRC_URI="https://github.com/tgingold/ghdl/archive/v${PV}.tar.gz
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-${ISL_VERSION}.tar.bz2
	http://www.bastoul.net/cloog/pages/download/cloog-${CLOOG_VERSION}.tar.gz"
LICENSE="GPL-2"
SLOT="0/${GCC_VERSION}"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-apps/texinfo
	dev-lang/gnat-gcc:${GNATGCC_SLOT}"
RDEPEND=""
S="${WORKDIR}/gcc-${GCC_VERSION}"

ADA_INCLUDE_PATH="${ROOT}/usr/lib/gnat-gcc/${CHOST}/${GNATGCC_SLOT}/adainclude"
ADA_OBJECTS_PATH="${ROOT}/usr/lib/gnat-gcc/${CHOST}/${GNATGCC_SLOT}/adalib"
GNATGCC_PATH="${ROOT}/usr/${CHOST}/gnat-gcc-bin/${GNATGCC_SLOT}:${ROOT}/usr/libexec/gnat-gcc/${CHOST}/${GNATGCC_SLOT}"

src_prepare() {
	default
	src_copy_vhdl_sources

	sed -i -e 's/ADAC = \$(CC)/ADAC = gnatgcc/' gcc/vhdl/Makefile.in || die "sed failed"
	sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" {libiberty,gcc}/configure

	ln -s ../isl-${ISL_VERSION} isl
	ln -s ../cloog-${CLOOG_VERSION} cloog
}

src_copy_vhdl_sources() {
	cd "${WORKDIR}/${P}"
	PATH="${GNATGCC_PATH}:${PATH}" ./configure \
		--prefix=/usr \
		--with-gcc="${WORKDIR}/gcc-${GCC_VERSION}"
	make copy-sources
	cd "${S}"
}

src_configure() {
	PATH="${GNATGCC_PATH}:${PATH}" econf \
		--enable-languages=vhdl \
		--enable-cloog-backend=isl \
		--disable-libstdcxx-pch \
		--disable-libssp \
		--enable-checking=release \
		--disable-bootstrap
}

src_compile() {
	PATH="${GNATGCC_PATH}:${PATH}" emake -j1 || die "Compilation failed"
}

src_install() {
	# bug #277644
	PATH="${GNATGCC_PATH}:${PATH}" emake -j1 DESTDIR="${D}" install || die "Installation failed"

	cd "${D}"/usr/bin ; rm `ls --ignore=ghdl`
	rm -rf "${D}"/usr/include
	for libdir in $(get_all_libdirs); do
		rm "${D}"/usr/${libdir}/lib*
		if [ -d "${D}/usr/${libdir}/gcc/${CHOST}/${GCC_VERSION}" ]; then
			cd "${D}"/usr/${libdir}/gcc/${CHOST}/${GCC_VERSION} ;rm -rf `ls --ignore=vhdl*`
		fi
	done
	cd "${D}"/usr/libexec/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=ghdl*`
	cd "${D}"/usr/share/info ; rm `ls --ignore=ghdl*`
	cd "${D}"/usr/share/man/man1 ; rm `ls --ignore=ghdl*`
	rm -Rf "${D}"/usr/share/locale
	rm -Rf "${D}"/usr/share/man/man7
}
