# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PV_COMMIT="2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f"

DESCRIPTION="Sweetest login theme available for the SDDM display manager"
HOMEPAGE="https://framagit.org/MarianArlt/sddm-sugar-candy https://store.kde.org/p/1312658/"
SRC_URI="https://framagit.org/MarianArlt/${PN}/-/archive/${PV_COMMIT}/${PN}-${PV_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	>=x11-misc/sddm-0.18"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CHANGELOG.md COPYING CREDITS )

S="${WORKDIR}/${PN}-${PV_COMMIT}"

src_install() {
	default

	insinto /usr/share/sddm/themes/sugar-candy
	doins -r {Assets,Backgrounds,Components,Previews,Main.qml,metadata.desktop}

	insinto /etc/sddm/themes/sugar-candy
	doins theme.conf
	dosym ../../../../../etc/sddm/themes/sugar-candy/theme.conf /usr/share/sddm/themes/sugar-candy/theme.conf
}

pkg_postinst() {
	elog
	elog "Theme can be configured via /etc/sddm/themes/sugar-candy/theme.conf"
	elog
}
