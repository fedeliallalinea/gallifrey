# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils rpm

MY_P="${P}-1.noarch"

DESCRIPTION="Oracle SQL Developer Data Modeler is a graphical data modeling tool"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/datamodeler/downloads/index.html"
SRC_URI="${MY_P}.rpm"
RESTRICT="fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=virtual/jdk-1.8.0
	dev-java/java-config:2"

S="${WORKDIR}"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Oracle SQL Datam Modeler for Linux RPM"
	eerror "		${SRC_URI}"
	eerror "and move it to /usr/portage/distfiles"
}

src_unpack() {
	rpm_src_unpack ${A}
}

src_prepare() {
	default
	find ./ \( -iname "*.exe" -or -iname "*.dll" \) -exec rm {} +
}

src_install() {
	dodir /usr/share/applications/
	cd "${S}"/opt/${PN} || die "cd failed"
	insinto /usr/share/applications/
	doins datamodeler.desktop
	rm datamodeler.desktop || die "rm failed"

	dodir /usr/bin/
	cd "${S}"/usr/local/bin/ || die "cd failed"
	exeinto /usr/bin/
	doexe datamodeler
	rm datamodeler || die "rm failed"

	dodir /opt/${PN}
	cd "${S}"/opt/${PN} || die "cd failed"
	insinto /opt/${PN}
	doins -r *
	exeinto /opt/${PN}
	doexe datamodeler.sh
}

pkg_postinst() {
	test -d /opt/datamodeler/datamodeler/log \
		|| mkdir /opt/datamodeler/datamodeler/log
	chgrp users /opt/datamodeler/datamodeler/log
	chmod 774 /opt/datamodeler/datamodeler/log

	test -f /opt/datamodeler/datamodeler/types/defaultdomains.xml \
		|| touch /opt/datamodeler/datamodeler/types/defaultdomains.xml
	chgrp users /opt/datamodeler/datamodeler/types/defaultdomains.xml
	chmod 664 /opt/datamodeler/datamodeler/types/defaultdomains.xml

	echo
	einfo "If you don't want to set JDK 1.8 as default virtual machine, open file "
	einfo "/opt/datamodeler/datamodeler/bin/datamodeler.conf and change entry "
	einfo "'SetJavaHome /path/to/jdk-1.8' with the correct java home path."
	echo
}
