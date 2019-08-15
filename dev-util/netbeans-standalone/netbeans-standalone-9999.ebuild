# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANT_TASKS="ant-apache-bsf"

if [ ${PV} = "9999" ]; then
	inherit git-r3 java-pkg-2 java-ant-2 desktop
	EGIT_REPO_URI="https://github.com/apache/netbeans.git"
else
	inherit java-pkg-2 java-ant-2 desktop
	SRC_URI="https://github.com/apache/netbeans/archive/${PV}.zip -> ${P}.zip"
	S=${WORKDIR}/netbeans-${PV}
fi

DESCRIPTION="Apache Netbeans IDE"
HOMEPAGE="https://netbeans.apache.org/"
LICENSE="Apache-2.0"
SLOT=$(ver_cut 1-1)
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jdk-1.8:*"

JAVA_PKG_BSFIX="off"
INSTALL_DIR=/usr/share/${PN}-${SLOT}

pkg_pretend() {
	if has network-sandbox ${FEATURES}; then
		ewarn "Netbeans downloads a lot of dependencies during the"
		ewarn "build process, you need to disable network-sandbox"
		ewarn "for this ebuild."
		die "network-sandbox is enabled, disabled it";
	fi
}

src_compile() {
	eant -Dcluster.config=full -Dpermit.jdk9.builds=true -Dbinaries.cache="${S}"/.hgexternalcache || die "Failed to compile"
}

src_install() {
	pushd nbbuild/netbeans >/dev/null || die

	insinto ${INSTALL_DIR}
	doins -r .
	dodoc DEPENDENCIES NOTICE
	dosym ${INSTALL_DIR}/bin/netbeans /usr/bin/${PN}-${SLOT}
	fperms 755 ${INSTALL_DIR}/bin/netbeans

	insinto /etc/${PN}-${SLOT}
	doins etc/*
	rm -fr "${D}"/${INSTALL_DIR}/etc
	dosym ../../../../etc/${PN}-${SLOT} ${INSTALL_DIR}/etc
	sed -i -e "s/#netbeans_jdkhome.*/netbeans_jdkhome=\$\(java-config -O\)/g" "${D}"/etc/${PN}-${SLOT}/netbeans.conf || die "Failed to set set Netbeans JDK home"

	if [[ -e "${D}"/${INSTALL_DIR}/bin/netbeans ]]; then
	sed -i -e "s:\"\$progdir\"/../etc/:/etc/${PN}-${SLOT}/:" "${D}"/${INSTALL_DIR}/bin/netbeans
	sed -i -e "s:\"\${userdir}\"/etc/:/etc/${PN}-${SLOT}/:" "${D}"/${INSTALL_DIR}/bin/netbeans
	fi

	dodir /usr/share/icons/hicolor/32x32/apps
	dosym ${INSTALL_DIR}/nb/netbeans.png /usr/share/icons/hicolor/32x32/apps/${PN}-${SLOT}.png

	popd >/dev/null || die

	make_desktop_entry ${PN}-${SLOT} "Netbeans ${PV}" ${PN}-${SLOT} Development

	mkdir -p  "${D}"/${INSTALL_DIR}/nb/config || die
	echo "NBGNT" > "${D}"/${INSTALL_DIR}/nb/config/productid || die
}
