# Copyright (C) 2022 Deokgyu Yang <secugyu@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

all: package

.PHONY: modules package extract

modules:
	$(MAKE) -C src/ modules

package: modules
	dpkg-buildpackage -b -rfakeroot -us -uc

extract:
	dpkg-deb -e $(wildcard deb_dist/*latest_all.deb) deb_dist/extract
	dpkg-deb -x $(wildcard deb_dist/*latest_all.deb) deb_dist/extract

clean:
	rm -rf deb_dist
	rm -rf debian/*.debhelper
	rm -rf debian/*.log
	rm -rf debian/*.substvars
	rm -rf debian/files
	rm -rf debian/*.debhelper.log
	$(MAKE) -C src/ clean

.PHONY: docker-start docker-build

docker-build:
	docker build -t rtl8821cu-dkms-dev .
	
docker-start: docker-build
	docker run -d --name rtl8821cu-dkms-dev rtl8821cu-dkms-dev
