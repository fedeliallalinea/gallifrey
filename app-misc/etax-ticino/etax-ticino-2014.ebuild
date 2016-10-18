# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="eTax per le imposte di persone fisiche"
HOMEPAGE="http://www4.ti.ch/dfe/dc/dichiarazione/etaxpf/download-scaricare/"

LICENSE="Repubblica-e-Cantone-Ticino"
SLOT="2014"
KEYWORDS="~amd64"
IUSE=""

MY_PV="eTax_ticino${SLOT}-unix"

SRC_URI="
	amd64? ( https://www3.ti.ch/DFE/sw/struttura/dfe/dc/etax/${SLOT}/${MY_PV}-64bit.sh )
	x86? ( https://www3.ti.ch/DFE/sw/struttura/dfe/dc/etax/${SLOT}/${MY_PV}-32bit.sh )
"

DEPEND="virtual/jre:*"
RDEPEND="${DEPEND}"

src_unpack() {
	if use amd64; then
		MY_PV=${MY_PV}-64bit
	else
		MY_PV=${MY_PV}-32bit
	fi
	mkdir "${WORKDIR}"/"${P}"
	cp "${DISTDIR}"/"${MY_PV}".sh "${WORKDIR}"/"${P}"/
}

src_prepare() {
	# for user root install4j writes into /opt/icedtea-bin-7.2.0/jre/.systemPrefs or whatever it
	# found via JAVA_HOME or similar variables
	# for other users it writes into $HOME/.java/.userPrefs/

	# trick setting -Djava.util.prefs.systemRoot="${TMPDIR}" does not work
	sed \
		-e "s@/bin/java\" -Dinstall4j.jvmDir=\"\$app_java_home\"@/bin/java\" -Duser.home="${TMPDIR}" -Dinstall4j.jvmDir="${TMPDIR}" -Dsys.symlinkDir="${D}"usr/bin -Djava.util.prefs.systemRoot="${TMPDIR}"@" \
		-i "${WORKDIR}"/"${P}"/"${MY_PV}".sh \
		|| die "failed to set userHome and jvmDir where JAVA .systemPrefs can be found"
}

src_install() {
	local DEST=opt/"${PN}"/"${SLOT}"
	dodir /usr/share/applications/
	dodir "${DEST}"
	sh "${WORKDIR}"/"${P}"/"${MY_PV}".sh -q -dir "${D}""${DEST}"
	mv "${D}${DEST}"/"eTax.ticino PF ${SLOT}" "${D}${DEST}"/eTax.ticino-${SLOT}
	rm -r "${D}${DEST}/jre" "${D}${DEST}"/*.desktop "${D}${DEST}"/uninstall

	make_desktop_entry "/bin/sh /${DEST}/eTax.ticino-${SLOT}" "eTax Ticino ${PV}" "/${DEST}/eTax.ticino PF ${SLOT}.png" "Utility"
	mv "${D}usr/share/applications"/*.desktop "${D}usr/share/applications/${P}.desktop"
}
