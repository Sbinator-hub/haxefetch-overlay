# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

MY_PV="${PV/_/-}"
MY_P="Haxefetch-${MY_PV}"
HXCPP_VERSION="4.3.2"

DESCRIPTION="A fetch program written in Haxe"
HOMEPAGE="https://github.com/Sbinator-hub/Haxefetch"

SRC_URI="
    https://github.com/Sbinator-hub/Haxefetch/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
    https://lib.haxe.org/p/hxcpp/${HXCPP_VERSION}/download/ -> hxcpp-${HXCPP_VERSION}.zip
"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT=0
KEYWORDS="amd64"

BDEPEND="
    dev-lang/haxe
    app-arch/unzip
"

src_compile() {
    export HAXELIB_PATH="${WORKDIR}/haxelib"
    mkdir -p "${HAXELIB_PATH}"
    haxelib setup "${HAXELIB_PATH}"

    local hxcpp_path=$(find "${WORKDIR}" -maxdepth 3 -name "haxelib.json" -path "*/hxcpp/*" -exec dirname {}\;)
    if [[ -z "${hxcpp_path}" ]]; then
        hxcpp_path=$(find "${WORKDIR}" -maxdepth 3 -name "haxelib.json" -exec dirname {} \; | head -n 1)
    else
        die "Hxcpp source was not found in ${WORKDIR}. Aborting!"
    fi

    haxelib dev hxcpp "${hxcpp_path}"

    einfo "Compiling Haxefetch.."
    haxe build.hxml -D git_hash=$(git rev-parse --short HEAD) -D no_debug || die "Haxefetch compilation failed!"
}

src_install() {
    local bin_path=$(find bin/ -type f -executable ! -name "*.so" ! -name "*.dylib" 2>/dev/null | head -n 1)
    if [[ -n "${bin_path}" ]]; then
        einfo "Installing compiled binary from ${bin_path} to /usr/bin"
        newbin "${bin_path}" haxefetch
    else
        die "Could not find binary. Aborting!"
    fi

    insinto /usr/share/fish/vendor_completions.d
    doins "${FILESDIR}/haxefetch.fish"
}

