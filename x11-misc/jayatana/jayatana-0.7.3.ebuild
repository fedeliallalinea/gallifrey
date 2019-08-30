# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils gnome2-utils

DESCRIPTION="Application menu module for Java"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/4158cb00cc3b06992704861a1af5439a/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/glib-2.50[dbus]
	virtual/jre:*
	x11-libs/libxkbcommon"
RDEPEND="${DEPEND}"

src_install () {
	cmake-utils_src_install
	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/appmenu-java-module.sh 80-appmenu-java-module
}

pkg_postinst() {
	gnome2_schemas_update
}
