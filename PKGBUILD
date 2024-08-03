# Maintainer: Your Name <your.email@example.com>
pkgname=gudbootie
pkgver=0.1.0
pkgrel=1
pkgdesc="Creates a fallback kernel and modules for Arch Linux."
arch=('any')
url="https://github.com/omnikron13/gudbootie"
license=('custom:Clear Permissive Licence v0.0.0')
depends=(
   'bash'
   'coreutils'
   'fd'
   'systemd'
   'xxhash'
)

source=("${pkgname}-${pkgver}.tar.gz::https://github.com/Omnikron13/gudbootie/archive/refs/tags/v${pkgver}.tar.gz")
b2sums=(
   'aa55fe76455a5bce1a2b9a76721151526296179ea3a9e5580869be4d7e2951aa2f98304e802f38db03961da46e1e63882767a3198bbd240069359d4c213be076'
)

package() {
   fromdir="${srcdir}/gudbootie-${pkgver}/"
   install -Dm644 "${fromdir}/gudbootie.service" "${pkgdir}/etc/systemd/system/gudbootie.service"
   install -Dm755 "${fromdir}/update-fallback.sh" "${pkgdir}/usr/lib/gudbootie/update-fallback.sh"
   install -Dm755 "${fromdir}/systemd-boot.conf" "${pkgdir}/usr/lib/gudbootie/systemd-boot.conf"
}

