# SPDX-FileCopyrightText: 2022-present Didier Malenfant <coding@malenfant.net>
#
# SPDX-License-Identifier: MIT
 
HEAP_SIZE      = 8388208
STACK_SIZE     = 61800

PRODUCT = sinescroll.pdx

# -- Locate the SDK
SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
SDKBIN = $(SDK)/bin

GAME=$(notdir $(CURDIR))
SIM=Playdate Simulator

# -- Add our extensions and libraries
include toyboxes/toyboxes.mk
include extension/extension.mk

# -- Include the common build rules
include $(SDK)/C_API/buildsupport/common.mk

# -- Make sure we compile a universal binary for the Simulator (Intel + Apple Silicon)
SYM_CPFLAGS += -arch x86_64 -arch arm64     # -- This is currently only used in my custom common.mk
DYLIB_FLAGS += -arch x86_64 -arch arm64
