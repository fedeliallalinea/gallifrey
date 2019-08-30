# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="OpenGL and OpenGL ES reference page sources"
HOMEPAGE="https://github.com/KhronosGroup/OpenGL-Refpages"
EGIT_REPO_URI="https://github.com/KhronosGroup/OpenGL-Refpages"

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
"

# gl2.1 = OpenGL 2.1 (including fixed functionality)
# es3   = OpenGL ES 3.x (will always be the latest ES, currently 3.2)
# gl4   = OpenGL 4.x (current) API and GLSL pages
INSTALLMANDIRS=(gl4 es3 gl2.1)

src_compile() {
	for MANPAGES in ${INSTALLMANDIRS[@]}; do
		xsltproc --noout --nonet /usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl "${MANPAGES}"/*.xml || die
	done
}

src_install() {
	doman *.3G
}
