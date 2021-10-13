# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Offline search engine for manual pages, Arch Wiki, Gentoo Wiki,..."
HOMEPAGE="https://github.com/filiparag/wikiman"

ARCH_WIKI_VER="20211009"
FBSD_DOCS_VER="20211009"
GENTOO_WIKI_VER="20200831"
TLDR_PAGES_VER="20211009"

SRC_URI="https://github.com/filiparag/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="arch-wiki fbsd-docs +gentoo-wiki tldr-pages"

RDEPEND="
	app-shells/fzf
	sys-apps/ripgrep
	sys-process/parallel
	virtual/awk
	virtual/man
	virtual/w3m
	arch-wiki? ( ~app-text/wikiman-arch-wiki-${ARCH_WIKI_VER} )
	fbsd-docs? ( ~app-text/wikiman-freebsd-docs-${FBSD_DOCS_VER} )
	gentoo-wiki? ( ~app-text/wikiman-gentoo-wiki-${GENTOO_WIKI_VER} )
	tldr-pages? ( ~app-text/wikiman-tldr-pages-${TLDR_PAGES_VER} )
"

src_prepare() {
	default
	sed -i "s:doc/wikiman:doc/${P}:g
		s:doc/\${NAME}:doc/${P}:g
		s:@tar.*:@cp ./\${NAME}.1.man \${BUILDDIR}/usr/share/man/man1:g
		s:\.1\.gz:\.1\.man:g" Makefile || die

	sed -i "s:arch-wiki:${PN}-arch-wiki-${ARCH_WIKI_VER}:" sources/arch.sh || die
	sed -i "s:freebsd-docs:${PN}-freebsd-docs-${FBSD_DOCS_VER}:" sources/fbsd.sh || die
	sed -i "s:gentoo-wiki:${PN}-gentoo-wiki-${GENTOO_WIKI_VER}:" sources/gentoo.sh || die
	sed -i "s:tldr-pages:${PN}-tldr-pages-${TLDR_PAGES_VER}:" sources/tldr.sh || die
}

src_compile() {
	:
}

src_install() {
	emake prefix="${D}" install
}
