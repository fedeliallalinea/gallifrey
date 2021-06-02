# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="GNU APL is a free interpreter for the programming language APL"
HOMEPAGE="https://www.gnu.org/software/apl/"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	export CXX_WERROR=no
	default
}
