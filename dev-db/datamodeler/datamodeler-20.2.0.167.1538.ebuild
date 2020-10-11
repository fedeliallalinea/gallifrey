# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm java-pkg-2

MY_P="${P}-noarch"

DESCRIPTION="Oracle SQL Developer Data Modeler is a graphical data modeling tool"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/datamodeler/downloads/index.html"
SRC_URI="${MY_P}.rpm"
RESTRICT="fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="dev-java/openjdk:8[javafx]
	virtual/jre:1.8"

S="${WORKDIR}"

QA_PREBUILT="
	opt/${PN}/netbeans/platform/modules/lib/amd64/linux/libjnidispatch-422.so
"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Oracle SQL Datam Modeler for Linux RPM"
	eerror "		${SRC_URI}"
	eerror "and move it to /var/cache/distfiles"
}

src_prepare() {
	default
	find ./ \( -iname "*.exe" -or -iname "*.dll" \) -exec rm {} + || die
	sed -i 's/Exec=/Exec=sh\ /' opt/${PN}/datamodeler.desktop || die
	sed -i 's/SetJavaHome/#SetJavaHome/' opt/${PN}/datamodeler/bin/datamodeler.conf || die

	rm -r opt/${PN}/netbeans/platform/modules/lib/i386 || die
	rm -r usr || die
}

src_install() {
	insinto /usr/share/applications/
	doins opt/${PN}/datamodeler.desktop
	rm "${S}"/opt/${PN}/datamodeler.desktop || die "rm failed"

	insinto /opt/${PN}
	doins -r opt/${PN}/*
	dobin "${FILESDIR}"/${PN}

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_
}
