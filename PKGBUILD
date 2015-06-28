# Author: ava1ar <mail(at)ava1ar(dot)info>

pkgname=rc.sysd-git
_pkgname=rc-sysd
pkgrel=1
pkgdesc="rc output for systemd systemctl"
url="https://github.com:pale3/rc-sysd.git" 
license=('GPL')
arch=('any')
depends=('bash') 
source=(git+https://github.com/pale3/rc-sysd.git) 
sha1sums=('SKIP')

pkgver() {
	cd ${_pkgname}
	echo $(git rev-list --count master).$(git rev-parse --short master)
}

package() { 
	cd ${_pkgname}
	
	mkdir -p "${pkgdir}"/usr/lib/rc-sysd/
	cp -R lib/* "${pkgdir}"/usr/lib/rc-sysd

	mkdir -p "${pkgdir}"/etc/rc-sysd.d/
	cp *.example "${pkgdir}"/etc/rc-sysd.d/
}
