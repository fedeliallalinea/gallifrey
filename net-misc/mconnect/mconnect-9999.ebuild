# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.40

inherit meson vala

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bboozzoo/${PN}.git"
else
	SRC_URI="https://github.com/bboozzoo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="KDE Connect protocol implementation in Vala/C"
HOMEPAGE="https://github.com/bboozzoo/mconnect"

LICENSE="GPL-2"
SLOT="0"
IUSE="+introspection"

BDEPEND="
	$(vala_depend)
	virtual/pkgconfig"
DEPEND="app-accessibility/at-spi2-core[introspection=]
	dev-libs/json-glib[introspection=]
	dev-libs/glib:2
	dev-libs/libgee:0.8[introspection=]
	net-libs/gnutls
	x11-libs/gtk+:3[introspection=]
	x11-libs/libnotify[introspection=]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	vala_src_prepare
}
