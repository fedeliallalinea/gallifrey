# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/wikiman-/}

DESCRIPTION="Pages from Arch Wiki for offline browsing"
HOMEPAGE="https://github.com/filiparag/wikiman"
SRC_URI="https://github.com/filiparag/wikiman/releases/download/2.9/${MY_PN}_${PV}.tar.xz -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/doc/${P}
	doins -r usr/share/doc/arch-wiki/*
}
