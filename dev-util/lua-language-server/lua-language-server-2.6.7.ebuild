# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit  )
inherit lua ninja-utils

DESCRIPTION="lua language server written in lua"
HOMEPAGE="https://github.com/sumneko/lua-language-server"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sumneko/lua-language-server.git"
else
	SRC_URI="https://github.com/sumneko/lua-language-server/releases/download/${PV}/lua-language-server-${PV}-submodules.zip -> ${P}.zip"
	S="${WORKDIR}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="strip"

src_compile() {
	pushd 3rd/luamake &>/dev/null || die
	einfo "Building luamake"
	ninja -f compile/ninja/linux.ninja || die "Building luamake failed"
	popd &>/dev/null || die

	einfo "Building ${PN}"
	./3rd/luamake/luamake all || die "Building ${PN} failed"
}

src_install() {
	insinto /usr/libexec/"${PN}"
	doins -r bin locale meta script \
		main.lua debugger.lua

	chmod +x ${D}/usr/libexec/${PN}/bin/${PN}
	sed "s:/usr/:${EPREFIX}&:" "${FILESDIR}"/wrapper | newbin - "${PN}"
}
