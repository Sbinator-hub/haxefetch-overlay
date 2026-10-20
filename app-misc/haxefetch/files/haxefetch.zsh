#compdef haxefetch

_haxefetch() {
    local -a args
    args=(
        '(-h --help)'{-h, --help}'[Show help.]'
        '(-v --version)'{-v, --version}'[Show version of Haxefetch.]'
        '(-c --config)'{-c, --config}'[Generate new config of Haxefetch.]'
        '(-t --tutorial)'{-t, --tutorial}'[Show how to customise Haxefetch.]'
        '(-s --supported)'{-s, --supported}'[Check if Haxefetch is supported].'
    )
    _arguments -s $args
}

_haxefetch "$@"