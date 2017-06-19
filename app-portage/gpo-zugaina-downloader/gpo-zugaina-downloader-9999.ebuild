# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/fedeliallalinea/gpo-zugaina-downloader.git"
	inherit git-r3
else
	SRC_URI="https://github.com/fedeliallalinea/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Download overlay, category or package ebuilds from gpo.zugaina.org"
HOMEPAGE="https://github.com/fedeliallalinea/gpo-zugaina-downloader"
LICENSE="GPL"
SLOT="0"

RDEPEND="net-misc/curl"

src_install() {
	dobin gpo-zugaina-downloader
}
