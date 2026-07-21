# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="csakura"
HOMEPAGE="https://github.com/realstrawhat/csakura"
EGIT_REPO_URI="https://github.com/realstrawhat/csakura.git"
EGIT_BRANCH="main"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
