# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/robbyrussell/${PN}.git"
inherit git-r3 readme.gentoo-r1

DESCRIPTION="A ready-to-use zsh configuration with plugins"
HOMEPAGE="https://github.com/robbyrussell/oh-my-zsh"

LICENSE="ZSH"
SLOT="0"
IUSE=""
PROPERTIES="live"

RDEPEND="app-shells/zsh"

ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"
ZSH_EDEST="${EPREFIX}${ZSH_DEST}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

src_prepare() {
	local i
	for i in "${S}"/tools/*install* "${S}"/tools/*upgrade*
	do	test -f "${i}" && : >"${i}"
	done
	sed -i -e 's!^ZSH=.*$!ZSH='"${ZSH_EDEST}"'!' \
		-e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' "${S}/${ZSH_TEMPLATE}"
	sed -i -e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' \
		"${S}/plugins/dirpersist/dirpersist.plugin.zsh"
	sed -i -e '/zstyle.*cache/d' "${S}/lib/completion.zsh"
	default
}

src_install() {
	local DISABLE_AUTOFORMATTING DOC_CONTENTS
	insinto "${ZSH_DEST}"
	doins -r *
	DISABLE_AUTOFORMATTING="true"
	DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add to your ~/.zshrc
source '${ZSH_DEST}/${ZSH_TEMPLATE}'
or copy a modification of that file to your ~/.zshrc
If you just want to try, enter the above command in your zsh."

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
