# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/wikiman-/}
WIKIMAN_VERSION=2.7

DESCRIPTION="Pages from Arch Wiki for offline browsing"
HOMEPAGE="https://github.com/filiparag/wikiman"
SRC_URI="https://github.com/filiparag/wikiman/releases/download/${WIKIMAN_VERSION}/${MY_PN}_${PV}-1.tar.xz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/doc/${P}
	doins -r usr/share/doc/gentoo-wiki/*
}
