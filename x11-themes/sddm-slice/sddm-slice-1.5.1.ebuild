# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Simple dark SDDM theme with many customization options"
HOMEPAGE="https://github.com/EricKotato/sddm-slice https://store.kde.org/p/1260506"
SRC_URI="https://github.com/EricKotato/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsvg:5
	>=x11-misc/sddm-0.18"
RDEPEND="${DEPEND}"

DOCS=( LICENSE README.md )

src_install() {
	default

	insinto /usr/share/sddm/themes/sddm-slice
	doins -r {Main.qml,metadata.desktop,slice,translations}

	insinto /etc/sddm/themes/sddm-slice
	doins theme.conf
	dosym ../../../../../etc/sddm/themes/sddm-slice/theme.conf /usr/share/sddm/themes/sddm-slice/theme.conf
}

pkg_postinst() {
	elog
	elog "Theme can be configured via /etc/sddm/themes/sddm-slice/theme.conf"
	elog
}
