# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

MY_P="${P}-noarch"

DESCRIPTION="Oracle SQL Developer Data Modeler is a graphical data modeling tool"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/datamodeler/downloads/index.html"
SRC_URI="${MY_P}.rpm"
RESTRICT="fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Oracle SQL Datam Modeler for Linux RPM"
	eerror "		${SRC_URI}"
	eerror "and move it to /usr/portage/distfiles"
}

src_prepare() {
	default
	find ./ \( -iname "*.exe" -or -iname "*.dll" \) -exec rm {} + || die
	sed -i 's/Exec=/Exec=sh\ /' opt/${PN}/datamodeler.desktop || die
	sed -i 's/SetJavaHome/#SetJavaHome/' opt/${PN}/datamodeler/bin/datamodeler.conf || die

	if use amd64; then
		rm -r opt/${PN}/netbeans/platform/modules/lib/i386 || die
	else
		rm -r opt/${PN}/netbeans/platform/modules/lib/amd64 || die
	fi
}

QA_PREBUILT="
	opt/${PN}/netbeans/platform/modules/lib/i386/linux/libjnidispatch-422.so
	opt/${PN}/netbeans/platform/modules/lib/amd64/linux/libjnidispatch-422.so
"

src_install() {
	insinto /usr/share/applications/
	doins opt/${PN}/datamodeler.desktop
	rm "${S}"/opt/${PN}/datamodeler.desktop || die "rm failed"

	dobin usr/local/bin/datamodeler
	rm "${S}"/usr/local/bin/datamodeler || die "rm failed"

	insinto /opt/${PN}
	doins -r opt/${PN}/*
	exeinto /opt/${PN}
	doexe opt/${PN}/datamodeler.sh
}
