# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="ZARQUON"

inherit perl-module

DESCRIPTION="Oracle database driver for the DBI module"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
HOMEPAGE="https://metacpan.org/dist/DBD-Oracle"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/DBI
	dev-lang/perl
	dev-db/oracle-instantclient"

PATCHES=(
	"${FILESDIR}/${P}_gcc-14.patch"
	"${FILESDIR}/${P}_oracle-lib-path.patch"
	"${FILESDIR}/${P}_oracle-lib-linking.patch"
)
