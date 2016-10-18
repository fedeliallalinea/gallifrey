# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3 eutils

DESCRIPTION="Openbox logout script"
HOMEPAGE="https://code.launchpad.net/oblogout"
SRC_URI="http://launchpad.net/${PN}/0.2/0.2.0/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/python-distutils-extra"
RDEPEND="dev-python/dbus-python
	dev-python/pygtk
	media-libs/libcanberra[gtk]
	dev-python/pillow
	x11-libs/cairo"

python_prepare_all() {
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/${P}-frombytes.patch

	distutils-r1_python_prepare_all UseHal=flase
}

src_unpack() {
	mkdir "${S}"
	tar -xjvf "${DISTDIR}"/"${P}.tar.bz2" -C "${S}" --strip-components=1 &> /dev/null || die "unpack failed"
}

python_install() {
	distutils-r1_python_install

	insinto etc
	doins "${FILESDIR}/${PN}.conf"
}
