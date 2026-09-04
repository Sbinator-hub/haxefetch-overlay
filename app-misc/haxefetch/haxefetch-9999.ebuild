# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A fetch program written in Haxe (live)"
HOMEPAGE="https://github.com/Sbinator-hub/Haxefetch"
EGIT_REPO_URI="https://github.com/Sbinator-hub/Haxefetch.git"

HSCRIPT_VERSION="2.7.0"
HXCPP_VERSION="4.3.2"

SRC_URI="
    https://lib.haxe.org/p/hxcpp/${HXCPP_VERSION}/download/ -> hxcpp-${HXCPP_VERSION}.zip 
    https://lib.haxe.org/p/hscript/${HSCRIPT_VERSION}/download/ -> hscript-${HSCRIPT_VERSION}.zip
"

LICENSE="MIT"
SLOT=0
KEYWORDS="~amd64 ~x86 ~arm ~arm64"

BDEPEND="
    app-arch/unzip
    dev-vcs/git
    ~dev-lang/haxe-4.3.7
"

src_unpack() {
    default
    git-r3_src_unpack 2>&1 | grep -vE "EGIT_OVERRIDE|override fetched repository properties"

    einfo "Extracting Hxcpp.."
    mkdir -p "${WORKDIR}/hxcpp-src" || die
    unzip -q "${DISTDIR}/hxcpp-${HXCPP_VERSION}.zip" -d "${WORKDIR}/hxcpp-src" || die

    einfo "Extracting HScript.."
    mkdir -p "${WORKDIR}/hscript-src" || die
    unzip -q "${DISTDIR}/hscript-${HSCRIPT_VERSION}.zip" -d "${WORKDIR}/hscript-src" || die
}

src_compile() {
    export HAXELIB_PATH="${WORKDIR}/haxelib"
    mkdir -p "${HAXELIB_PATH}"
    haxelib setup "${HAXELIB_PATH}"

    local hxcpp_path=$(find "${WORKDIR}/hxcpp-src" -name "haxelib.json" -exec dirname {} \;)
    if [[ -z "${hxcpp_path}" ]]; then
        die "Hxcpp directory was not found in ${WORKDIR}. Aborting!"
    fi
    einfo "Register HXCPP from ${hxcpp_path}.."
    haxelib dev hxcpp "${hxcpp_path}"

    local hscript_path=$(find "${WORKDIR}/hscript-src" -name "haxelib.json" -exec dirname {} \;)
    if [[ -z "${hscript_path}" ]]; then
        die "HScript directory was not found in ${WORKDIR}. Aborting!"
    fi
    einfo "Register HScript from ${hscript_path}.."
    haxelib dev hscript "${hscript_path}"

    einfo "Compiling Haxefetch for ${ARCH}.."
    local haxe_arch=""
    case "${ARCH}" in
        amd64) haxe_arch="-D HXCPP_M64" ;;
        x86) haxe_arch="-D HXCPP_M32" ;;
        arm) haxe_arch="-D HXCPP_ARMV7" ;;
        arm64) haxe_arch="-D HXCPP_ARM64" ;;
    esac

    haxe build.hxml ${haxe_arch} -D no_debug || die "Haxefetch compilation failed. Aborting!"
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
