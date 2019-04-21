# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

DESCRIPTION="eTax per le imposte di persone fisiche"
HOMEPAGE="http://www4.ti.ch/dfe/dc/dichiarazione/etaxpf/download-scaricare/"

LICENSE="Repubblica-e-Cantone-Ticino"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

MY_PV="eTax_ticino${SLOT}-unix"

SRC_URI="
	amd64? ( https://www3.ti.ch/DFE/sw/struttura/dfe/dc/etax/${SLOT}/${MY_PV}-64bit.sh )
	x86? ( https://www3.ti.ch/DFE/sw/struttura/dfe/dc/etax/${SLOT}/${MY_PV}-32bit.sh )
"

DEPEND="virtual/jre:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	if use amd64; then
		MY_PV=${MY_PV}-64bit
	else
		MY_PV=${MY_PV}-32bit
	fi
	cp "${DISTDIR}/${MY_PV}.sh" "${S}"/ || die "cp failed"
}

src_prepare() {
	default
	sed \
		-e "s@/bin/java\" -Dinstall4j.jvmDir=\"\$app_java_home\"@/bin/java\" -Duser.home="${WORKDIR}" -Dinstall4j.jvmDir="${WORKDIR}" -Djava.util.prefs.systemRoot="${WORKDIR}"@" \
		-i "${MY_PV}.sh" \
		|| die "failed to set userHome and jvmDir where JAVA .systemPrefs can be found"
	sh "${S}/${MY_PV}".sh -Vsys.symlinkDir=null -q -dir "${S}" > /dev/null || die "unpack failed"
}

src_install() {
	exeinto "/opt/${PN}/${SLOT}"
	doexe "eTax.ticino PF ${SLOT}"
	insinto "/opt/${PN}/${SLOT}"
	doins -r {help,lib,.install4j}
	dosym "${ED%/}/opt/${PN}/${SLOT}/.install4j/eTax.ticino PF ${SLOT}.png" "/usr/share/pixmaps/${PN}-${SLOT}.png"

	make_desktop_entry "/bin/sh \"/opt/${PN}/${SLOT}/eTax.ticino PF ${SLOT}\"" "eTax Ticino ${PV}" "${PN}-${SLOT}" "Utility"
	mv "${ED%/}/usr/share/applications"/*.desktop "${ED%/}/usr/share/applications/${P}.desktop" || die "rename .desktop file failed"
}
