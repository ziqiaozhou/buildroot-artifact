LIBTPMS_VERSION = 0.9.1
LIBTPMS_SITE = $(call github,stefanberger,libtpms,v$(LIBTPMS_VERSION))

LIBTPMS_INSTALL_STAGING = YES

define LIBTPMS_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) autoreconf --verbose --force --install
endef

LIBTPMS_PRE_CONFIGURE_HOOKS += LIBTPMS_RUN_AUTOGEN
HOST_LIBTPMS_PRE_CONFIGURE_HOOKS += LIBTPMS_RUN_AUTOGEN

LIBTPMS_CONF_OPTS += \
	--with-openssl  --with-tpm2 --disable-hardening

$(eval $(autotools-package))
$(eval $(host-autotools-package))