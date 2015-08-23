# -*-makefile-*-
#
# Copyright (C) 2012 by Andreas Bießmann <andreas@biessmann.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_U_BOOT_TOOLS) += u-boot-tools

#
# Paths and names
#
U_BOOT_TOOLS_VERSION	:= 2015.01
U_BOOT_TOOLS_MD5	:= 7f08dc9e98a71652bd6968888ed6ec95
U_BOOT_TOOLS		:= u-boot-$(U_BOOT_TOOLS_VERSION)
U_BOOT_TOOLS_SUFFIX	:= tar.bz2
U_BOOT_TOOLS_URL	:= http://ftp.denx.de/pub/u-boot/$(U_BOOT_TOOLS).$(U_BOOT_TOOLS_SUFFIX)
U_BOOT_TOOLS_SOURCE	:= $(SRCDIR)/$(U_BOOT_TOOLS).$(U_BOOT_TOOLS_SUFFIX)
U_BOOT_TOOLS_DIR	:= $(BUILDDIR)/$(U_BOOT_TOOLS)
U_BOOT_TOOLS_LICENSE	:= GPLv2

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

U_BOOT_TOOLS_CONF_TOOL	:= NO
# just pick sandbox as a dummy target config
U_BOOT_TOOLS_MAKE_OPT	:= \
	CROSS_COMPILE=$(BOOTLOADER_CROSS_COMPILE) \
	sandbox_config tools

ifdef PTXCONF_U_BOOT_TOOLS_TOOL_ENV
U_BOOT_TOOLS_MAKE_OPT	+= env
endif

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-tools.install:
	@$(call targetinfo)
ifdef PTXCONF_U_BOOT_TOOLS_TOOL_ENV
	install -D $(U_BOOT_TOOLS_DIR)/tools/env/fw_printenv \
		$(U_BOOT_TOOLS_PKGDIR)/usr/sbin/fw_printenv
endif
	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/u-boot-tools.targetinstall:
	@$(call targetinfo)

	@$(call install_init,  u-boot-tools)
	@$(call install_fixup, u-boot-tools,PRIORITY,optional)
	@$(call install_fixup, u-boot-tools,SECTION,base)
	@$(call install_fixup, u-boot-tools,AUTHOR,\
		"Andreas Bießmann <andreas@biessmann.de>")
	@$(call install_fixup, u-boot-tools,DESCRIPTION,missing)

ifdef PTXCONF_U_BOOT_TOOLS_TOOL_ENV
	@$(call install_copy, u-boot-tools, 0, 0, 0755, -, /usr/sbin/fw_printenv)
	@$(call install_link, u-boot-tools, fw_printenv, /usr/sbin/fw_setenv)
	@$(call install_alternative, u-boot-tools, 0, 0, 0644, /etc/fw_env.config)
endif

	@$(call install_finish, u-boot-tools)

	@$(call touch)

# vim: syntax=make
