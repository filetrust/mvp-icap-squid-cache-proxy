#!/bin/bash
sudo ln -s /usr/bin/aclocal-1.15 /usr/bin/aclocal-1.16 # Build scripts looks for aclocal-1.16 , Symlinking current version 1.15
sudo apt install -y gcc g++ devscripts dh-apparmor libcppunit-dev libcap-dev libdb-dev \
	libexpat1-dev libgnutls28-dev cdbs debhelper  libkrb5-dev comerr-dev libldap2-dev \
	libnetfilter-conntrack-dev libpam0g-dev libsasl2-dev libxml2-dev nettle-dev \
	libnettle6 libhogweed4 libp11-kit-dev libp11-kit0 pkg-config libssl-dev
git clone https://git.launchpad.net/ubuntu/+source/squid # Cloning Squid Ubuntu package source code
pushd squid
git checkout ubuntu/focal # Checking out to Ubuntu 20.04 Repo (Squid 4.10)
patch debian/rules <<EOF
diff --git a/debian/rules b/debian/rules
index fac4ec7e..83475ac2 100755
--- a/debian/rules
+++ b/debian/rules
@@ -67,7 +67,10 @@ DEB_CONFIGURE_EXTRA_FLAGS := BUILDCXXFLAGS="\$(CXXFLAGS) \$(CPPFLAGS) \$(LDFLAGS)"
 		--with-filedescriptors=65536 \\
 		--with-large-files \\
 		--with-default-user=proxy \\
-		--with-gnutls
+		--with-gnutls \\
+		--with-openssl \\
+		--enable-ssl \\
+		--enable-ssl-crtd
 
 ifeq (\$(DEB_HOST_ARCH_OS), kfreebsd)
 		DEB_CONFIGURE_EXTRA_FLAGS += --enable-kqueue
EOF
# Patched debian/rules to add options to enable ssl bumping support
dch -i --distribution bionic 'Glasswall build' # New version to changelog with Ubuntu bionic target
debuild -i -us -uc -b # Building the package
popd
