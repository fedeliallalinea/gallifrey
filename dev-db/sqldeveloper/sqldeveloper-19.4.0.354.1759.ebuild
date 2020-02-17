# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2

DESCRIPTION="Oracle SQL Developer is a graphical tool for database development"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index.html"
SRC_URI="${P}-no-jre.zip"

RESTRICT="fetch"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="mssql mysql postgres sybase"

DEPEND="mssql? ( dev-java/jtds:1.3 )
	mysql? ( dev-java/jdbc-mysql:0 )
	postgres? ( dev-java/jdbc-postgresql:0 )
	sybase? ( dev-java/jtds:1.3 )
	>=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/${PN}"

QA_PREBUILT="
	opt/${PN}/netbeans/platform/modules/lib/amd64/linux/*.so
	opt/${PN}/netbeans/platform/modules/lib/i386/linux/*.so
"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Oracle SQL Developer for other platforms"
	eerror "		${SRC_URI}"
	eerror "and move it to ${DISTDIR}"
}

src_prepare() {
	default
	# we don't need these, do we?
	find ./ \( -iname "*.exe" -or -iname "*.dll" -or -iname "*.bat" \) -exec rm {} +

	# they both use jtds, enabling one of them also enables the other one
	if use mssql && ! use sybase; then
		einfo "You requested MSSQL support, this also enables Sybase support."
	fi
	if use sybase && ! use mssql; then
		einfo "You requested Sybase support, this also enables MSSQL support."
	fi

	if use mssql || use sybase; then
		echo "AddJavaLibFile $(java-pkg_getjars jtds-1.3)" >> sqldeveloper/bin/sqldeveloper.conf || die
	fi

	if use mysql; then
		echo "AddJavaLibFile $(java-pkg_getjars jdbc-mysql)" >> sqldeveloper/bin/sqldeveloper.conf || die
	fi

	if use postgres; then
		echo "AddJavaLibFile $(java-pkg_getjars jdbc-postgresql)" >> sqldeveloper/bin/sqldeveloper.conf || die
	fi
}

src_install() {
	dodir /opt/${PN}
	# NOTE For future version to get that line (what to copy) go to the unpacked sources dir
	# using `bash` and press Meta+_ (i.e. Meta+Shift+-) -- that is a builtin bash feature ;-)
	cp -r {configuration,d{ataminer,ropins,vt},e{quinox,xternal},ide,j{avavm,d{bc,ev},lib,views},modules,netbeans,rdbms,s{leepycat,ql{developer,j},vnkit}} \
		"${ED}"/opt/${PN}/ || die "Install failed"

	dobin "${FILESDIR}"/${PN}

	newicon icon.png ${PN}-32x32.png
	make_desktop_entry ${PN} "Oracle SQL Developer" ${PN}-32x32

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_
}

pkg_postinst() {
	echo
	einfo "If you want to use the TNS connection type you need to set up the"
	einfo "TNS_ADMIN environment variable to point to the directory your"
	einfo "tnsnames.ora resides in."
	echo
}
