# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for davmail server"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( davmail )

acct-user_add_deps

KEYWORDS="~amd64 ~x86"
