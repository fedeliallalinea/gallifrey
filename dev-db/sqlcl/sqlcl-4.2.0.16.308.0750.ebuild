# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_P="${P}-no-jre"

DESCRIPTION="Oracle SQLcl is the new SQL*Plus"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html"
SRC_URI="${MY_P}.zip"
RESTRICT="fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=virtual/jdk-1.7.0
	dev-java/java-config:2
	dev-db/oracle-instantclient"

S="${WORKDIR}"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Command Line - SQLcl"
	eerror "		${SRC_URI}"
	eerror "and move it to ${DISTDIR}"
}

src_prepare() {
	default
	find ./ \( -iname "*.bat" -or -iname "*.exe" \) -exec rm {} +
	mv ./sqlcl/bin/sql ./sqlcl/bin/sqlcl
}

src_install() {
	dodir /opt/${PN}/bin/
	cd "${S}"/sqlcl/bin/
	exeinto /opt/${PN}/bin/
	doexe sqlcl

	dodir /opt/${PN}/lib
	cd "${S}"/sqlcl/lib/
	insinto /opt/${PN}/lib
	doins -r *

	dosym "${ED%/}"/opt/${PN}/bin/sqlcl /usr/bin/sqlcl
}
