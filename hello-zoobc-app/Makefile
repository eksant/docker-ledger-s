#*******************************************************************************
#   Ledger Blue
#   (c) 2016 Ledger
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

ifeq ($(BOLOS_SDK),)
$(error Environment variable BOLOS_SDK is not set)
endif
include $(BOLOS_SDK)/Makefile.defines

PYTHON ?= python
TARGET_ID := $(shell cat $(BOLOS_SDK)/include/bolos_target.h | grep 0x | cut -f3 -d' ')

#################################################################
# Main app configuration
#################################################################
APPNAME = "Hello ZooBC"
APPVERSION_M=0
APPVERSION_N=0
APPVERSION_P=1
APPVERSION=$(APPVERSION_M).$(APPVERSION_N).$(APPVERSION_P)
APP_LOAD_PARAMS = --appFlags 0x00 $(COMMON_LOAD_PARAMS)

# Build configuration
APP_SOURCE_PATH += src
SDK_SOURCE_PATH += lib_stusb lib_stusb_impl

#################################################################
# Default rule
#################################################################
all: default

#################################################################
# Platform
#################################################################
DEFINES += OS_IO_SEPROXYHAL IO_SEPROXYHAL_BUFFER_SIZE_B=128
DEFINES += HAVE_BAGL HAVE_SPRINTF
# DEFINES += HAVE_PRINTF PRINTF=screen_printf
DEFINES += PRINTF\(...\)=
DEFINES += HAVE_IO_USB HAVE_L4_USBLIB IO_USB_MAX_ENDPOINTS=7 IO_HID_EP_LENGTH=64 HAVE_USB_APDU
DEFINES += LEDGER_MAJOR_VERSION=$(APPVERSION_M) LEDGER_MINOR_VERSION=$(APPVERSION_N) LEDGER_PATCH_VERSION=$(APPVERSION_P)

# U2F
DEFINES	+= HAVE_U2F
DEFINES	+= USB_SEGMENT_SIZE=64
DEFINES	+= BLE_SEGMENT_SIZE=32 #max MTU, min 20
DEFINES	+= U2F_MAX_MESSAGE_SIZE=264 #257+5+2
DEFINES	+= UNUSED\(x\)=\(void\)x
DEFINES	+= APPVERSION=\"$(APPVERSION)\"
DEFINES	+= CX_COMPLIANCE_141

#################################################################
# Compiler
#################################################################
ifneq ($(BOLOS_ENV),)
$(info BOLOS_ENV=$(BOLOS_ENV))
CLANGPATH := $(BOLOS_ENV)/clang-arm-fropi/bin/
GCCPATH := $(BOLOS_ENV)/gcc-arm-none-eabi-5_3-2016q1/bin/
else
$(info BOLOS_ENV is not set: falling back to CLANGPATH and GCCPATH)
endif
ifeq ($(CLANGPATH),)
$(info CLANGPATH is not set: clang will be used from PATH)
endif
ifeq ($(GCCPATH),)
$(info GCCPATH is not set: arm-none-eabi-* will be used from PATH)
endif

CC := $(CLANGPATH)clang
CFLAGS += -O3 -Os -I/usr/include

AS := $(GCCPATH)arm-none-eabi-gcc
AFLAGS +=

LD := $(GCCPATH)arm-none-eabi-gcc
LDFLAGS += -O3 -Os
LDLIBS += -lm -lgcc -lc

check:
	$(PYTHON) -m ledgerblue.checkGenuine --targetId $(TARGET_ID)

load: all
	$(PYTHON) -m ledgerblue.loadApp $(APP_LOAD_PARAMS)

delete:
	$(PYTHON) -m ledgerblue.deleteApp $(COMMON_DELETE_PARAMS)
	# $(PYTHON) -m ledgerblue.deleteApp --targetId $(TARGET_ID) --appName $(APPNAME)

# Import generic rules from the SDK
include $(BOLOS_SDK)/Makefile.rules

#add dependency on custom makefile filename
dep/%.d: %.c Makefile