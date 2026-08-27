# Official Gentoo Linux portage overlay for Haxefetch

## How to install this?

1. Install repository module (`emerge --ask --verbose eselect-repository`)
2. Enable repo (`eselect repository add haxefetch-overlay git https://github.com/Sbinator-hub/haxefetch-overlay.git`)
3. Sync repos (`emerge --sync haxefetch-overlay` || `emaint sync --repo haxefetch-overlay`)
4. Unmask dependencies (`echo -e "dev-lang/haxe ~amd64\ndev-lang/neko ~amd64\ndev-ml/sedlex ~amd64\ndev-lang/ocaml ~amd64\ndev-ml/* ~amd64" | tee -a /etc/portage/package.accept_keywords/haxe
`)
4. Emerge Haxefetch (`emerge --ask --verbose app-misc/haxefetch` (for people who want to avoid compiling, i made binary ebuild and it can be emerged with `emerge --ask --verbose app-misc/haxefetch-bin`))

### If you want to get Haxefetch from latest git commits i push
 Source:
 - Unmask haxefetch (`echo "app-misc/haxefetch ~amd64" | tee -a /etc/portage/package.accept-keywords/haxefetch`)
 - Emerge haxefetch (`emerge --ask --verbose --update app-misc/haxefetch`)

 Binary:
 - Unmask binary haxefetch (`echo "app-misc/haxefetch-bin ~amd64" | tee -a /etc/portage/package.accept-keywords/haxefetch-bin`)
 - Emerge binary haxefetch (`emerge --ask --verbose --update app-misc/haxefetch-bin`)

 > **Note:** Resyncing repos is required if you use live binary (source live is not required)
