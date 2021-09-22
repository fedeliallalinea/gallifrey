# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2

SR="R"
RNAME="2021-09"
SRC_BASE="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/${RNAME}/${SR}/eclipse"

DESCRIPTION="The Leading Open Platform for Professional Developers"
HOMEPAGE="http://www.eclipse.org"
SRC_URI="
	committers? ( ${SRC_BASE}-committers-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-committers-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	cpp? ( ${SRC_BASE}-cpp-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-cpp-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	computing? ( ${SRC_BASE}-parallel-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-parallel-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	dsl? ( ${SRC_BASE}-dsl-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-dsl-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	embedcpp? ( ${SRC_BASE}-embedcpp-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-embedcpp-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	php? ( ${SRC_BASE}-php-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-php-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	java? ( ${SRC_BASE}-java-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-java-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	javaee? ( ${SRC_BASE}-jee-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-jee-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	modeling? ( ${SRC_BASE}-modeling-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-modeling-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	rcp? ( ${SRC_BASE}-rcp-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-rcp-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
	scout? ( ${SRC_BASE}-scout-${RNAME}-${SR}-linux-gtk-x86_64.tar.gz&r=1 -> eclipse-scout-${RNAME}-${SR}-linux-gtk-x86_64-${PV}.tar.gz )
"
S="${WORKDIR}/eclipse"

LICENSE="EPL-1.0"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="committers cpp computing dsl embedcpp php +java javaee modeling rcp scout"
REQUIRED_USE="^^ ( committers cpp computing dsl embedcpp php java javaee modeling rcp scout )"

RDEPEND="
	net-libs/webkit-gtk
	x11-libs/gtk+:3
	virtual/jre:11"

QA_PREBUILT="opt/eclipse-ide-bin-4.20/plugins/org.eclipse.justj.openjdk.hotspot.jre.full.linux.x86_64_*/jre/**/*.so"

src_install() {
	local dest="/opt/${PN}-${SLOT}"

	insinto "${dest}"
	doins -r *
	find "${ED}${dest}" -name "*.so" -type f -exec chmod +x {} + || die "Change .so permission failed" 

	exeinto "${dest}"
	doexe eclipse

	docinto html
	dodoc -r readme/*

	insinto /etc
	cp "${FILESDIR}/eclipserc-bin" "${T}" || die "Move conf file to temporary directory failed"
	newins "${T}/eclipserc-bin" "eclipserc-bin-${SLOT}"

	cp "${FILESDIR}/eclipse-bin" "${T}" || die "Move run script file to temporary directory failed"
	sed "s@%SLOT%@${SLOT}@" -i "${T}/eclipse-bin" || die "Change script file version failed"
	newbin "${T}/eclipse-bin" "eclipse-bin-${SLOT}"

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_

	make_desktop_entry "eclipse-bin-${SLOT}" "Eclipse ${PV}" "${dest}/icon.xpm" "Development"
}
