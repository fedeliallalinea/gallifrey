# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="List ASCII idiomatic names and octal/decimal code-point forms"
HOMEPAGE="http://www.catb.org/~esr/ascii/"
SRC_URI="http://www.catb.org/~esr/ascii/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	dobin ascii
	doman ascii.1
}
