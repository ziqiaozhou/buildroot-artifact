################################################################################
#
# ifupdown-scripts
#
################################################################################

define IFUPDOWN_SCRIPTS_PREAMBLE
	echo "# interface file auto-generated by buildroot" \
		> $(TARGET_DIR)/etc/network/interfaces
endef

define IFUPDOWN_SCRIPTS_LOCALHOST
	( \
		echo ; \
		echo "auto lo"; \
		echo "iface lo inet loopback"; \
	) >> $(TARGET_DIR)/etc/network/interfaces
endef

IFUPDOWN_SCRIPTS_DHCP_IFACE = $(call qstrip,$(BR2_SYSTEM_DHCP))

ifneq ($(IFUPDOWN_SCRIPTS_DHCP_IFACE),)
define IFUPDOWN_SCRIPTS_DHCP
	( \
		echo ; \
		echo "auto $(IFUPDOWN_SCRIPTS_DHCP_IFACE)"; \
		echo "iface $(IFUPDOWN_SCRIPTS_DHCP_IFACE) inet dhcp"; \
		echo "  pre-up /etc/network/nfs_check"; \
		echo "  wait-delay 15"; \
		echo "  hostname \$$(hostname)"; \
	) >> $(TARGET_DIR)/etc/network/interfaces
endef
define IFUPDOWN_SCRIPTS_DHCP_OPENRC
	echo "ifup $(IFUPDOWN_SCRIPTS_DHCP_IFACE)" \
		> $(TARGET_DIR)/etc/ifup.$(IFUPDOWN_SCRIPTS_DHCP_IFACE)
	echo "ifdown $(IFUPDOWN_SCRIPTS_DHCP_IFACE)" \
		> $(TARGET_DIR)/etc/ifdown.$(IFUPDOWN_SCRIPTS_DHCP_IFACE)
endef
endif

define IFUPDOWN_SCRIPTS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(IFUPDOWN_SCRIPTS_PKGDIR)/nfs_check \
		$(TARGET_DIR)/etc/network/nfs_check
	$(call SYSTEM_RSYNC,$(IFUPDOWN_SCRIPTS_PKGDIR)/network,$(TARGET_DIR)/etc/network)
endef

define IFUPDOWN_SCRIPTS_INSTALL_INIT_OPENRC
	$(IFUPDOWN_SCRIPTS_PREAMBLE)
	$(IFUPDOWN_SCRIPTS_DHCP)
	$(IFUPDOWN_SCRIPTS_DHCP_OPENRC)
endef

define IFUPDOWN_SCRIPTS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(IFUPDOWN_SCRIPTS_PKGDIR)/$(BR2_PACKAGE_IFUPDOWN_SCRIPTS_CHOICE) \
		$(TARGET_DIR)/etc/init.d/$(BR2_PACKAGE_IFUPDOWN_SCRIPTS_CHOICE)
	$(IFUPDOWN_SCRIPTS_PREAMBLE)
	$(IFUPDOWN_SCRIPTS_LOCALHOST)
	$(IFUPDOWN_SCRIPTS_DHCP)
endef
# ifupdown-scripts can not be selected when systemd-networkd is
# enabled, so if we are enabled with systemd, we must install our
# own service file.
define IFUPDOWN_SCRIPTS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(IFUPDOWN_SCRIPTS_PKGDIR)/network.service \
		$(TARGET_DIR)/etc/systemd/system/network.service
	$(IFUPDOWN_SCRIPTS_PREAMBLE)
	$(IFUPDOWN_SCRIPTS_LOCALHOST)
	$(IFUPDOWN_SCRIPTS_DHCP)
endef

$(eval $(generic-package))
