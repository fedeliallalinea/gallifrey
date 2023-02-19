# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

DESCRIPTION="eTax per le imposte di persone fisiche"
HOMEPAGE="http://www4.ti.ch/dfe/dc/dichiarazione/etaxpf/download-scaricare/"

LICENSE="Repubblica-e-Cantone-Ticino"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

MY_PV="eTax_ticino${SLOT}-unix"

SRC_URI="
	amd64? ( https://www3.ti.ch/DFE/DC/etax/${SLOT}/${MY_PV}-64bit.sh )
	x86? ( https://www3.ti.ch/DFE/DC/etax/${SLOT}/${MY_PV}-32bit.sh )
"

DEPEND="virtual/jre:1.8"
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
	sed -e "s/ETAX_SLOT=/ETAX_SLOT=${SLOT}/g" "${FILESDIR}/etax-ticino" > "etax-ticino-${SLOT}" || die "failed to set slot in exec file"
	sh "${S}/${MY_PV}".sh -q -dir "${S}" > /dev/null || die "unpack failed"
}

src_install() {
	exeinto "/opt/${PN}/${SLOT}"
	doexe "eTax.ticino PF ${SLOT}"
	insinto "/opt/${PN}/${SLOT}"
	doins -r {help,lib,.install4j}
	insinto /usr/share/pixmaps
	newins .install4j/"eTax.ticino PF ${SLOT}.png" ${PN}-${SLOT}.png

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_

	dobin "etax-ticino-${SLOT}"

	make_desktop_entry "/bin/sh \"/usr/bin/etax-ticino-${SLOT}\"" "eTax Ticino ${PV}" "${PN}-${SLOT}" "Utility"
}
