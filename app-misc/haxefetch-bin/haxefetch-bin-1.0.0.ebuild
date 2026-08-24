# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

HOMEPAGE="https://github.com/Sbinator-hub/Haxefetch"
DESCRIPTION="A fetch program written in Haxe (binary)"
SRC_URI="https://github.com/Sbinator-hub/Haxefetch/releases/download/1.0.0/haxefetch-1.0.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
    elibc_musl? ( sys-libs/gcompat )
"

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
   doexe haxefetch

   insinto /usr/share/fish/vendor_completions.d
   doins "${FILESDIR}/haxefetch.fish"
}