# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm kde.org

KFMIN=5.99.0
QTMIN=5.15.5

DESCRIPTION="KDE image viewer for comic book archives"
HOMEPAGE="https://peruse.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="semantic-desktop"

DEPEND="
	kde-apps/kio-extras
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/kdeclarative-${KFMIN}:5
	>=kde-frameworks/kfilemetadata-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kpackage-${KFMIN}:5
	semantic-desktop? (
		>=kde-frameworks/baloo-${KFMIN}:5
	)
"
RDEPEND="${DEPEND}"
RESTRICT="test"
