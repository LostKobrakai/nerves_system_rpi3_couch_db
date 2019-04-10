################################################################################
#
# CouchDB
#
################################################################################

COUCHDB_VERSION = 2.3.0
COUCHDB_SITE = \
	https://github.com/apache/couchdb/releases/download/${COUCHDB_VERSION}
COUCHDB_SOURCE = apache-couchdb-${COUCHDB_VERSION}.tar.gz

COUCHDB_LICENSE = Apache-2.0
COUCHDB_LICENSE_FILES = LICENSE

COUCHDB_DEPENDENCIES = host-autoconf-archive host-pkgconf \
	erlang icu openssl spidermonkey185

# configure.ac is patched.
COUCHDB_AUTORECONF = YES
COUCHDB_AUTORECONF_OPTS = -I $(HOST_DIR)/usr/share/autoconf-archive

COUCHDB_CONF_ENV = ICU_CONFIG=$(STAGING_DIR)/usr/bin/icu-config
COUCHDB_CONF_OPTS = $(if $(BR2_INIT_SYSV)$(BR2_INIT_BUSYBOX),,--disable-init)
COUCHDB_CONF_OPTS += --disable-docs

define COUCHDB_INSTALL_INIT_SYSV
	mv $(TARGET_DIR)/etc/init.d/couchdb $(TARGET_DIR)/etc/init.d/S97couchdb
	install -m 755 package/couchdb/S96prepare-couchdb \
		$(TARGET_DIR)/etc/init.d/
endef

define COUCHDB_USERS
	couchdb -1 couchdb -1 ! - /bin/sh - CouchDB Server
endef

define COUCHDB_PERMISSIONS
	/etc/couchdb		r	755	couchdb	couchdb - - - -
	/var/lib/couchdb	d	750	couchdb	couchdb - - - -
endef

$(eval $(autotools-package))