# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 ecm
	EGIT_REPO_URI="https://github.com/MakG10/${PN}"
else
	inherit ecm
	SRC_URI="https://github.com/MakG10/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Plasma 5 applet showing a status of the servers defined by user"
HOMEPAGE="https://store.kde.org/p/1190292/
	https://github.com/MakG10/plasma-applet-server-status"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	kde-plasma/plasma-workspace:5
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}_label-color.patch" )
