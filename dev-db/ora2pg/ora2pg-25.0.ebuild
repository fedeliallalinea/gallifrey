# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Moves Oracle and MySQL database to PostgreSQL"
HOMEPAGE="https://ora2pg.darold.net/index.html"
SRC_URI="https://github.com/darold/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mysql +oracle"
REQUIRED_USE="|| ( mysql oracle )"

RDEPEND="
	dev-perl/DBD-Pg
	dev-perl/File-Tempdir
	dev-lang/perl
	mysql? ( dev-perl/DBD-mysql )
	oracle? ( dev-perl/DBD-Oracle )
"

src_configure() {
	perl Makefile.PL \
		PREFIX="${EPREFIX}/usr" \
		INSTALLDIRS=vendor \
		SYSCONFDIR="${EPREFIX}/etc" \
		DOCDIR="${EPREFIX}/usr/share/doc/${P}" \
		DESTDIR="${D}" \
		|| die 'failed to create a Makefile using Makefile.PL'
}
