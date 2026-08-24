# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A fetch program written in Haxe (live binary)"
HOMEPAGE="https://github.com/Sbinator-hub/Haxefetch"
SRC_URI="https://raw.githubusercontent.com/Sbinator-hub/Haxefetch/main/binary/haxefetch -> ${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
    elibc_musl? ( sys-libs/gcompat )
"

S="${WORKDIR}"

src_unpack() {
   cp "${DISTDIR}/${P}" "${S}/haxefetch" || die "Error copying binary"
}

src_compile() {
	:
}

src_install() {
	exeinto /usr/bin
   doexe haxefetch

   insinto /usr/share/fish/vendor_completions.d
   doins "${FILESDIR}/haxefetch.fish"
}