# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2 rpm

MY_P="${P}-1.noarch"

DESCRIPTION="Oracle SQL Developer Data Modeler is a graphical data modeling tool"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/datamodeler/downloads/index.html"
SRC_URI="${MY_P}.rpm"
S="${WORKDIR}"

RESTRICT="fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="<dev-java/openjdk-17:*[javafx]
	>=virtual/jre-1.8:*"

QA_PREBUILT="
	opt/${PN}/netbeans/platform/modules/lib/amd64/linux/libjnidispatch-422.so
"

pkg_nofetch() {
	einfo "Please go to"
	einfo "	https://www.oracle.com/tools/downloads/sql-data-modeler-downloads.html"
	einfo "and download"
	einfo "	Oracle SQL Datam Modeler for Linux RPM"
	einfo "		${SRC_URI}"
	einfo "and move it to /var/cache/distfiles"
}

src_prepare() {
	default
	find ./ \( -iname "*.exe" -or -iname "*.dll" \) -exec rm {} + || die
	sed -i 's/Exec=/Exec=sh\ /' opt/${PN}/datamodeler.desktop || die
	sed -i 's/SetJavaHome/#SetJavaHome/' opt/${PN}/datamodeler/bin/datamodeler.conf || die

	rm -r opt/${PN}/netbeans/platform/modules/lib/i386 || die
	rm -r opt/${PN}/modules/javafx || die
	rm -r usr || die
}

src_install() {
	domenu opt/${PN}/datamodeler.desktop
	rm "${S}"/opt/${PN}/datamodeler.desktop || die "rm failed"

	insinto /opt/${PN}
	doins -r opt/${PN}/*
	dobin "${FILESDIR}"/${PN}

	fperms +x /opt/${PN}/netbeans/platform/modules/lib/amd64/linux/libjnidispatch-422.so
	fperms 1777 /opt/datamodeler/datamodeler/log

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_
}
