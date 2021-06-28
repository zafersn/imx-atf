# Copyright (C) 2018 Marvell International Ltd.
#
# SPDX-License-Identifier:     BSD-3-Clause
# https://spdx.org/licenses

MV_DDR_LIB		=	$(BUILD_PLAT)/ble/mv_ddr_lib.a
LIBC_LIB		=	$(BUILD_PLAT)/lib/libc.a
BLE_LIBS		=	$(MV_DDR_LIB) $(LIBC_LIB)
PLAT_MARVELL		=	plat/marvell/armada

BLE_SOURCES		+= 	$(BLE_PATH)/ble_main.c				\
				$(BLE_PATH)/ble_mem.S				\
				drivers/delay_timer/delay_timer.c		\
				drivers/marvell/iob.c				\
				$(PLAT_MARVELL)/common/aarch64/marvell_helpers.S \
				$(PLAT_MARVELL)/common/plat_delay_timer.c	\
				$(PLAT_MARVELL)/common/marvell_console.c

PLAT_INCLUDES		+= 	-I$(MV_DDR_PATH)				\
				-I$(CURDIR)/include				\
				-I$(CURDIR)/include/arch/aarch64		\
				-I$(CURDIR)/include/lib/libc			\
				-I$(CURDIR)/include/lib/libc/aarch64		\
				-I$(CURDIR)/drivers/marvell

BLE_LINKERFILE		:=	$(BLE_PATH)/ble.ld.S

$(MV_DDR_LIB): FORCE
	$(if $(value MV_DDR_PATH),,$(error "Platform '$(PLAT)' for BLE requires MV_DDR_PATH. Please set MV_DDR_PATH to point to the right directory"))
	$(if $(wildcard $(value MV_DDR_PATH)/*),,$(error "'MV_DDR_PATH=$(value MV_DDR_PATH)' was specified, but '$(value MV_DDR_PATH)' directory does not exist"))
	$(if $(shell git -C $(value MV_DDR_PATH) rev-parse --show-cdup 2>&1),$(error "'MV_DDR_PATH=$(value MV_DDR_PATH)' was specified, but '$(value MV_DDR_PATH)' does not contain valid mv-ddr-marvell git repository"))
	@+make -C $(MV_DDR_PATH) --no-print-directory PLAT_INCLUDES="$(PLAT_INCLUDES)" PLATFORM=$(PLAT) ARCH=AARCH64 OBJ_DIR=$(BUILD_PLAT)/ble
