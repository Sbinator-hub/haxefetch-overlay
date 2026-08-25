# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A fetch program written in Haxe (live)"
HOMEPAGE="https://github.com/Sbinator-hub/Haxefetch"
EGIT_REPO_URI="https://github.com/Sbinator-hub/Haxefetch.git"
HXCPP_VERSION="4.3.2"

SRC_URI="https://lib.haxe.org/p/hxcpp/${HXCPP_VERSION}/download/ -> hxcpp-${HXCPP_VERSION}.zip"

LICENSE="MIT"
SLOT=0
KEYWORDS="~amd64"

BDEPEND="
    ~dev-lang/haxe-4.3.7
    app-arch/unzip
"

src_unpack() {
    git-r3_fetch
    git-r3_checkout

    einfo "Extracting Hxcpp.."
    mkdir -p "${WORKDIR}/hxcpp-src" || die
    unzip -q "${DISTDIR}/hxcpp-${HXCPP_VERSION}.zip" -d "${WORKDIR}/hxcpp-src" || die
}

src_compile() {
    export HAXELIB_PATH="${WORKDIR}/haxelib"
    mkdir -p "${HAXELIB_PATH}"
    haxelib setup "${HAXELIB_PATH}"

    local hxcpp_path=$(find "${WORKDIR}/hxcpp-src" -name "haxelib.json" -exec dirname {} \;)
    if [[ -z "${hxcpp_path}" ]]; then
        die "Hxcpp directory was not found in ${WORKDIR}. Aborting!"
    fi

    haxelib dev hxcpp "${hxcpp_path}"

    einfo "Compiling Haxefetch.."
    haxe build.hxml -D git_hash=$(git rev-parse --short HEAD) -D no_debug || die "Haxefetch compilation failed. Aborting!"
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
