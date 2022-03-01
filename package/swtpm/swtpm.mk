SWTPM_VERSION = 0.7.1
SWTPM_SITE = $(call github,stefanberger,swtpm,v$(SWTPM_VERSION))

SWTPM_INSTALL_STAGING = YES
define SWTPM_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) autoreconf --verbose --force --install
endef

SWTPM_PRE_CONFIGURE_HOOKS += SWTPM_RUN_AUTOGEN

SWTPM_CONF_OPTS += \
	--with-openssl  --with-tpm2 --disable-hardening

define SWTPM_INSTALL_SCRIPTS
	$(INSTALL) -D -m 0755 $(SWTPM_PKGDIR)/qemu-tpm.sh \
		$(TARGET_DIR)/usr/bin/qemu-tpm.sh
endef

SWTPM_POST_INSTALL_TARGET_HOOKS += SWTPM_INSTALL_SCRIPTS

$(eval $(autotools-package))

