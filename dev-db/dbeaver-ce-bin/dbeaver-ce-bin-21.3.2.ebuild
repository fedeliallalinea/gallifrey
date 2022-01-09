# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin*}"

inherit desktop java-pkg-2 xdg

DESCRIPTION="Free universal database tool (community edition)."
HOMEPAGE="https://dbeaver.io/"
SRC_URI="https://github.com/dbeaver/dbeaver/releases/download/${PV}/${MY_PN}-${PV}-linux.gtk.x86_64-nojdk.tar.gz"
S="${WORKDIR}/dbeaver"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	x11-libs/gtk+:3
	virtual/jre:11"

src_prepare() {
	default
	sed -i -e "s:/usr/share/dbeaver-ce/dbeaver\.png:${MY_PN}:" \
		-e "s:/usr/share/dbeaver-ce/dbeaver:/usr/bin/${MY_PN}:" \
		-e "s:/usr/share/dbeaver-ce:/opt/${MY_PN}:" dbeaver-ce.desktop || die "failed to change .desktop"
}

src_install() {
	local dest="/opt/${MY_PN}"

	insinto "${dest}"
	doins -r META-INF features licenses plugins configuration p2
	doins dbeaver.ini readme.txt

	newicon -s 128 dbeaver.png  "${MY_PN}.png"
	newicon icon.xpm "${MY_PN}.xpm"

	exeinto "${dest}"
	doexe dbeaver
	dobin "${FILESDIR}/${MY_PN}"

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_

	domenu dbeaver-ce.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
