TSS_MSR_VERSION = 0f2516fca2cd9929c31d5450e39301c9bde43688
TSS_MSR_SITE = $(call github,microsoft,TSS.MSR,$(TSS_MSR_VERSION))

TSS_MSR_INSTALL_STAGING = YES
define TSS_MSR_INSTALL_PY_LIB
	cd $(@D) && $(INSTALL) TSS.Py/src/* -D -m 0755 $(TARGET_DIR)/usr/lib/python3.10/tss_msr/
endef

TSS_MSR_POST_INSTALL_TARGET_HOOKS += TSS_MSR_INSTALL_PY_LIB

$(eval $(generic-package)) 
