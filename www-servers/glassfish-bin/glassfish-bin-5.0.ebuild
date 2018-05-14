# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils user

MY_PN=${PN/-bin/}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Oracle GlassFish Server is the world's first implementation of the Java Platform, Enterprise Edition (Java EE) 6 specification.  Built using the GlassFish Server Open Source Edition, Oracle GlassFish Server delivers a flexible, lightweight, and production-ready Java EE 6 application server."
HOMEPAGE="http://www.oracle.com/technetwork/middleware/glassfish/overview/index.html"
LICENSE="ogsla"
SRC_URI="http://download.oracle.com/${MY_PN}/${PV}/release/${MY_P}.zip"
RESTRICT="mirror"
SLOT="${PV%.*}"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.8"

S="${WORKDIR}/${MY_PN}${SLOT}"
INSTALL_DIR="/opt/${MY_PN}-${SLOT}"

pkg_setup() {
	enewgroup glassfish
	enewuser glassfish -1 /bin/bash ${INSTALL_DIR}/home glassfish
}

src_prepare() {
	default
	find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_install() {
	insinto ${INSTALL_DIR}

	doins -r glassfish javadb mq bin
	keepdir ${INSTALL_DIR}/home

	for i in bin/* ; do
		fperms 755 ${INSTALL_DIR}/${i}
		make_wrapper "$(basename ${i})" "${INSTALL_DIR}/${i}"
	done

	for i in glassfish/bin/* ; do
		fperms 755 ${INSTALL_DIR}/${i}
	done

	newinitd "${FILESDIR}/${MY_PN}-${SLOT}-init" glassfish-${SLOT}

	keepdir ${INSTALL_DIR}/glassfish/domains
	fperms -R g+w "${INSTALL_DIR}/glassfish/domains"

	fowners -R glassfish:glassfish ${INSTALL_DIR}

	echo "CONFIG_PROTECT=\"${INSTALL_DIR}/glassfish/config\"" > "${T}/25glassfish"
	doenvd "${T}/25glassfish"
}

pkg_postinst() {
	elog "You must be in the glassfish group to use GlassFish without root rights."
	elog "You should create separate domain for development needs using"
	elog "    \$ asadmin create-domain devdomain"
	elog "under your account"
	elog "Don't use same domain under different credentials!"
}
