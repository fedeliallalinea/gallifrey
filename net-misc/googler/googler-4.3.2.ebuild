# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit eutils python-r1 bash-completion-r1

DESCRIPTION="Google Search from command line"
HOMEPAGE="https://github.com/jarun/googler"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jarun/${PN}"
else
	SRC_URI="https://github.com/jarun/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=" ~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="${PYTHON_DEPS}
	|| (
		x11-misc/xsel
		x11-misc/xclip
	)"
RDEPEND="${DEPEND}"

src_install(){
	emake disable-self-upgrade

	dobin googler
	doman googler.1
	dodoc README.md

	newbashcomp auto-completion/bash/${PN}-completion.bash ${PN}
	insinto /usr/share/fish/vendor_completions.d/
	doins auto-completion/fish/${PN}.fish
	insinto /usr/share/zsh/site-functions
	doins auto-completion/zsh/_${PN}
}
