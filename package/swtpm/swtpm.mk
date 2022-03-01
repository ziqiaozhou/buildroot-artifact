SWTPM_VERSION = 0.7.1
SWTPM_SITE = $(call github,stefanberger,swtpm,v$(SWTPM_VERSION))

SWTPM_INSTALL_STAGING = YES
define SWTPM_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) autoreconf --verbose --force --install
endef

SWTPM_PRE_CONFIGURE_HOOKS += SWTPM_RUN_AUTOGEN

SWTPM_CONF_OPTS += \
	--with-openssl  --with-tpm2 --disable-hardening

$(eval $(autotools-package)) 