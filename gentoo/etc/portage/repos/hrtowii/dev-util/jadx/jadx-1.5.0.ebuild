EAPI=8

inherit desktop xdg

DESCRIPTION="Dex to Java decompiler (Command line and GUI tools)"
HOMEPAGE="https://github.com/skylot/jadx"
SRC_URI="https://github.com/skylot/jadx/releases/download/v${PV}/jadx-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"
RDEPEND=">=virtual/jre-11:*"
BDEPEND="app-arch/unzip"

src_configure() { :; }
src_compile() { :; }

src_install() {
    local destdir="/usr/share/${PN}"
    insinto "${destdir}"

    doins -r lib

    exeinto "${destdir}/bin"
    doexe bin/jadx bin/jadx-gui

    dosym "${destdir}/bin/jadx" "/usr/bin/jadx"
    dosym "${destdir}/bin/jadx-gui" "/usr/bin/jadx-gui"

    make_desktop_entry "jadx-gui" "JADX GUI" "java" "Development;Debugger;"
}
