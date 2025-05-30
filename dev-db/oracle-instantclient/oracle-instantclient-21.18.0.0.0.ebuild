# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils

DESCRIPTION="Oracle 21c Instant Client with SDK"
HOMEPAGE="https://www.oracle.com/database/technologies/instant-client.html"

MY_SOVER=21.1 # the library soname found in the zip files
MY_PVM=$(ver_cut 1-2)
MY_P="instantclient_$(ver_rs 1 _ ${MY_PVM})"
MY_PVP=$(ver_cut 5) # p2
MY_URI="https://download.oracle.com/otn_software/linux/instantclient/$(ver_rs 1-5 '' $(ver_cut 1-5))"

# MY_PLAT_x86="Linux x86"
# MY_BITS_x86=32
# MY_A_x86="${MY_URI}/${PN/oracle-/}-basic-linux-${PV}.zip"
# MY_A_x86_jdbc="${MY_A_x86/basic/jdbc}"
# MY_A_x86_odbc="${MY_A_x86/basic/odbc}"
# MY_A_x86_precomp="${MY_A_x86/basic/precomp}"
# MY_A_x86_sdk="${MY_A_x86/basic/sdk}"
# MY_A_x86_sqlplus="${MY_A_x86/basic/sqlplus}"
# MY_A_x86_tools="${MY_A_x86/basic/tools}"

MY_PLAT_amd64="Linux x86-64"
MY_BITS_amd64=64
MY_A_amd64="${MY_URI}/${PN/oracle-}-basic-linux.x64-${PV}dbru.zip"
MY_A_amd64_jdbc="${MY_A_amd64/basic/jdbc}"
MY_A_amd64_odbc="${MY_A_amd64/basic/odbc}"
MY_A_amd64_precomp="${MY_A_amd64/basic/precomp}"
MY_A_amd64_sdk="${MY_A_amd64/basic/sdk}"
MY_A_amd64_sqlplus="${MY_A_amd64/basic/sqlplus}"
MY_A_amd64_tools="${MY_A_amd64/basic/tools}"

if [[ ${MY_PVP} == p* ]]
then
	MY_PVP=-${MY_PVP#p}
	# Updated 9/22/2017: instantclient-odbc-linux-12.2.0.1.0-2.zip
	MY_A_x86_odbc="${MY_URI}/${MY_A_x86_odbc%.zip}${MY_PVP}.zip"
	MY_A_amd64_odbc="${MY_URI}/${MY_A_amd64_odbc%.zip}${MY_PVP}.zip"
fi

#SRC_URI="
# 	x86? (
# 		${MY_A_x86}
# 		jdbc?    ( ${MY_A_x86_jdbc}    )
# 		odbc?    ( ${MY_A_x86_odbc}    )
# 		precomp? ( ${MY_A_x86_precomp} )
# 		!abi_x86_64? (
# 			sdk?     ( ${MY_A_x86_sdk}     )
# 			sqlplus? ( ${MY_A_x86_sqlplus} )
# 			tools?   ( ${MY_A_x86_tools}   )
# 	) )
SRC_URI="
	amd64? (
		${MY_A_amd64}
		jdbc?    ( ${MY_A_amd64_jdbc}    )
		odbc?    ( ${MY_A_amd64_odbc}    )
		precomp? ( ${MY_A_amd64_precomp} )
		sdk?     ( ${MY_A_amd64_sdk}     )
		sqlplus? ( ${MY_A_amd64_sqlplus} )
		tools?   ( ${MY_A_amd64_tools}   )
	)
"

S="${WORKDIR}/${MY_P}"

LICENSE="OTN"
SLOT="0/${MY_SOVER}"
KEYWORDS="~amd64"
IUSE="jdbc odbc precomp +sdk +sqlplus tools"
REQUIRED_USE="precomp? ( sdk )"

RDEPEND="
	>=dev-libs/libaio-0.3.109-r5
	odbc? ( dev-db/unixODBC )
"
BDEPEND="app-arch/unzip"

RESTRICT="mirror splitdebug test"

QA_PREBUILT="usr/lib*/oracle/client/*/*"

src_unpack() {
	local ABI=${ARCH}
	MY_WORKDIR="${WORKDIR}"
	MY_S="${S}"
	MY_PLAT=MY_PLAT_${ABI}          ; MY_PLAT=${!MY_PLAT}         # platform name
	MY_BITS=MY_BITS_${ABI}          ; MY_BITS=${!MY_BITS}         # platform bitwidth
	MY_A=MY_A_${ABI}                ; MY_A=${!MY_A##*/}               # runtime distfile
	MY_A_jdbc=MY_A_${ABI}_jdbc      ; MY_A_jdbc=${!MY_A_jdbc##*/}       # jdbc distfile
	MY_A_odbc=MY_A_${ABI}_odbc      ; MY_A_odbc=${!MY_A_odbc##*/}       # odbc distfile
	MY_A_precomp=MY_A_${ABI}_precomp; MY_A_precomp=${!MY_A_precomp##*/} # precomp distfile
	MY_A_sdk=MY_A_${ABI}_sdk        ; MY_A_sdk=${!MY_A_sdk##*/}         # sdk distfile
	MY_A_sqlplus=MY_A_${ABI}_sqlplus; MY_A_sqlplus=${!MY_A_sqlplus##*/} # sqlplus distfile
	MY_A_tools=MY_A_${ABI}_tools    ; MY_A_tools=${!MY_A_tools##*/}     # tools distfile

	mkdir -p "${MY_WORKDIR}" || die
	cd "${MY_WORKDIR}" || die
	unpack ${MY_A}
	use jdbc    && unpack ${MY_A_jdbc}
	use odbc    && unpack ${MY_A_odbc}
	use precomp && unpack ${MY_A_precomp}
	use sdk     && unpack ${MY_A_sdk}
	use sqlplus && unpack ${MY_A_sqlplus}
	use tools   && unpack ${MY_A_tools}
}

src_prepare() {
	local PATCHES=()
	if use precomp; then
		# Not supporting COBOL for now
		rm -f sdk/demo/*procob*
	fi
	if use sdk; then
		PATCHES+=( "${FILESDIR}"/21.18.0.0.0-makefile.patch )
		rm sdk/include/ldap.h || die #299562
	fi
	default
}

# silence configure&compile messages from multilib-minimal
src_configure() { :; }
src_compile() { :; }

src_install() {
	# all content goes here without version number, bug#578402
	local oracle_home=/usr/$(get_libdir)/oracle/client
	local oracle_home_to_root=../../../.. # for dosym
	local ldpath=

	local ABI=${ARCH}

	einfo "Installing runtime for ${MY_PLAT} ..."

	cd "${MY_S}" || die

	# shared libraries
	insinto "${oracle_home}"/lib
	doins lib*.so*
	chmod +x "${ED}"/"${oracle_home}"/lib/lib*.so* || die
	if use precomp; then
		doins cobsqlintf.o
	fi

	# ensure to be linkable
	[[ -e libocci.so ]] ||
	dosym libocci.so.${MY_SOVER} \
		"${oracle_home}"/lib/libocci.so
	[[ -e libclntsh.so ]] ||
	dosym libclntsh.so.${MY_SOVER} \
		"${oracle_home}"/lib/libclntsh.so

	# java archives
	insinto "${oracle_home}"/lib
	doins *.jar

	# runtime library path
	ldpath+=${ldpath:+:}${oracle_home}/lib

	# Vanilla filesystem layout does not support multilib
	# installation, so we need to move the libs into the
	# ABI specific libdir.  However, ruby-oci8 build system
	# detects an instantclient along the shared libraries,
	# and does expect the sdk right there.
	use sdk && dosym ../sdk "${oracle_home}"/lib/sdk

	local DOCS=( BASIC_README )
	local HTML_DOCS=()
	local paxbins=( adrci genezi uidrvci )
	local scripts=()

	if use jdbc; then
		DOCS+=( JDBC_README )
	fi
	if use odbc; then
		DOCS+=( ODBC_README )
		HTML_DOCS+=( help )
		scripts+=( odbc_update_ini.sh )
	fi
	if use precomp; then
		DOCS+=( PRECOMP_README )
		paxbins+=( sdk/proc )
		# Install pcscfg.cfg into /etc/oracle, as the user probably
		# wants to add the include path for the compiler headers
		# here and we do not want this to be overwritten.
		insinto /etc/oracle
		doins precomp/admin/pcscfg.cfg
		sed -i -e "s%^sys_include=.*%sys_include=(${oracle_home}/sdk/include,${EPREFIX}/usr/include)%" \
			"${ED}"/etc/oracle/pcscfg.cfg || die
		dosym ../../${oracle_home_to_root}/etc/oracle/pcscfg.cfg "${oracle_home}/precomp/admin/pcscfg.cfg"
		dosym ../.."${oracle_home}"/bin/proc /usr/bin/proc
		# Not supporting COBOL for now
		# paxbins+=( sdk/{procob,rtsora} )
		# doins precomp/admin/pcbcfg.cfg
	fi
	if use sdk; then
		einfo "Installing SDK ..."
		DOCS+=( SDK_README )
		scripts+=( sdk/ott )
		insinto "${oracle_home}"/lib
		doins sdk/ottclasses.zip
		insinto "${oracle_home}"/sdk
		doins -r sdk/{admin,demo,include}
		# Some build systems simply expect ORACLE_HOME/include.
		dosym sdk/include "${oracle_home}"/include
		# Some build systems do not know the instant client,
		# expecting headers in rdbms/public, see bug#669316.
		# Additionally, some (probably older ruby-oci8) do
		# require rdbms/public to be a real directory.
		insinto "${oracle_home}"/rdbms/public
		doins -r sdk/include/*
		# Others (like the DBD::Oracle perl module) know the Oracle
		# eXpress Edition's client, parsing an rdbms/demo/demo_xe.mk.
		dosym ../../sdk/demo/demo.mk "${oracle_home}"/rdbms/demo/demo_xe.mk
		# And some do expect /usr/include/oracle/<ver>/client/include,
		# querying 'sqlplus' for the version number, also see bug#652096.
		dosym ../../../.."${oracle_home}"/sdk/include /usr/include/oracle/${MY_PVM}/client
	fi
	if use sqlplus; then
		DOCS+=( SQLPLUS_README )
		paxbins+=( sqlplus )
		insinto "${oracle_home}"/sqlplus/admin
		doins glogin.sql
		dosym ../.."${oracle_home}"/bin/sqlplus /usr/bin/sqlplus
	fi
	if use tools; then
		DOCS+=( TOOLS_README )
		paxbins+=( exp expdp imp impdp sqlldr wrc )
	fi

	einfo "Installing binaries for ${MY_PLAT} ..."
	into "${oracle_home}"
	dobin ${paxbins[*]} ${scripts[*]}
	pushd "${ED}${oracle_home}/bin" >/dev/null || die
	pax-mark -c ${paxbins[*]#*/} || die
	popd >/dev/null || die

	einstalldocs

	# create path for tnsnames.ora
	insinto /etc/oracle
	doins "${FILESDIR}"/tnsnames.ora.sample

	# Add OCI libs to library path
	{
		echo "# ${EPREFIX}/etc/env.d/50${PN}"
		echo "# Do not edit this file, but 99${PN} instead"
		echo
		echo "ORACLE_HOME=${EPREFIX}${oracle_home}"
		echo "LDPATH=${ldpath}"
		echo "TNS_ADMIN=${EPREFIX}/etc/oracle/"
	} > "${T}"/50${PN}

	doenvd "${T}"/50${PN}

	# ensure ORACLE_HOME/lib exists
# 	[[ -e ${ED}${oracle_home}/lib/. ]] ||
# 	dosym $(get_libdir) "${oracle_home#/}"/lib
}

pkg_preinst() {
	if [[ -r ${EROOT}/etc/env.d/99${PN} ]]; then
		cp "${EROOT}/etc/env.d/99${PN}" "${ED}/etc/env.d/" || die
	else
		{
			echo "# ${EPREFIX}/etc/env.d/99${PN}"
			echo "# Configure system-wide defaults for your Oracle Instant Client here"
			echo
			echo "#$(grep '^ORACLE_HOME=' "${ED}/etc/env.d/50${PN}")"
			echo "#$(grep '^TNS_ADMIN=' "${ED}/etc/env.d/50${PN}")"
			echo "#NLS_LANG="
		} > "${ED}/etc/env.d/99${PN}"
	fi
}

pkg_postinst() {
	elog "${P} does not provide an sqlnet.ora"
	elog "configuration file, redirecting oracle diagnostics for database-"
	elog "and network-issues into ~USER/oradiag_USER/ instead."
	elog "It should be safe to ignore this message in sqlnet.log there:"
	elog "   Directory does not exist for read/write [ORACLE_HOME/client/log] []"
	elog "See https://bugs.gentoo.org/show_bug.cgi?id=465252 for reference."
	elog "If you want to directly analyse low-level debug info or don't want"
	elog "to see it at all, so you really need an sqlnet.ora file, please"
	elog "consult http://search.oracle.com/search/search?q=sqlnet.ora"
	elog ""
	elog "TNS_ADMIN has been set to ${EPREFIX}/etc/oracle by default,"
	elog "put your tnsnames.ora there or configure TNS_ADMIN"
	elog "to point to your user specific configuration."
	if use precomp; then
		elog ""
		elog "The proc precompiler uses the system library headers, which in"
		elog "turn include the headers of the used compiler."
		elog "To make proc work, please add the compiler header path of your"
		elog "preferred compiler to sys_include in:"
		elog "  ${EPREFIX}/etc/oracle/pcscfg.cfg"
		elog "Remember to update this setting when you switch or update the"
		elog "compiler."
		elog "For gcc, the headers are usually found in a path matching the"
		elog "following pattern:"
		elog "  ${EPREFIX}/usr/lib/gcc/*/*/include"
		elog "The exact details depend on the architecture and the version of"
		elog "the compiler to be used."
	fi
	ewarn "Please re-source your shell settings for ORACLE_HOME"
	ewarn "  changes, such as: source ${EPREFIX}/etc/profile"
}
