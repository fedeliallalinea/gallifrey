# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils qmake-utils

DESCRIPTION="Powerful yet simple to use screenshot software for GNU/Linux"
HOMEPAGE="http://github.com/lupoDharkael/flameshot"

if [[ ${PV} == *9999* ]];then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~x86 ~amd64 ~arm"
fi

LICENSE="FreeArt GPL-3+ Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
"
RDEPEND="${DEPEND}"

src_prepare(){
	eapply_user
	sed -i "s#icons#pixmaps#" ${PN}.pro
	sed -i "s#icons#pixmaps#" docs/desktopEntry/package/${PN}.desktop
	sed -i "s#icons#pixmaps#" docs/desktopEntry/package/${PN}-init.desktop
	sed -i "s#icons#pixmaps#" docs/desktopEntry/package/${PN}-config.desktop
}

src_configure(){
	local myeqmakeargs=(
		CONFIG+=packaging
		BASEDIR="${EPREFIX}"
	)
	eqmake5 ${myeqmakeargs[@]}
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}
