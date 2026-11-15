#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# DescartesOS for CMF Phone 1 (Tetris) - maintained by chakra
# Credits: LineageOS, crDroid, CMF-Phone-1, lufrz, Sreelekshman,
#          Mashopy, swiitch-OFF-Lab (see README.md)
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from Tetris device
$(call inherit-product, device/nothing/Tetris/device.mk)

# GMS
WITH_GMS := true

# Inherit some common DescartesOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Bootanimation
TARGET_BOOT_ANIMATION_RES := 1080

# DescartesOS
DESCARTES_MAINTAINER := chakra
DESCARTES_BUILD_TYPE := UNOFFICIAL
DESCARTES_PROCESSOR := Dimensity_7300
DESCARTES_BATTERY := 5000_mAh
DESCARTES_DISPLAY := 6.67_AMOLED_120Hz
DESCARTES_CAMERA_REAR_INFO := 50
DESCARTES_CAMERA_FRONT_INFO := 16
EXTRA_UDFPS_ANIMATIONS := true
TARGET_HAS_UDFPS := true

PRODUCT_NAME := lineage_Tetris
PRODUCT_DEVICE := Tetris
PRODUCT_BRAND := Nothing
PRODUCT_MANUFACTURER := Nothing
PRODUCT_MODEL := A015

PRODUCT_GMS_CLIENTID_BASE := android-nothing

DEVICE_CODENAME := Tetris

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_mssi_64_64only_ww_armv82-user 16 BP2A.250605.031.A3 2609281140 release-keys" \
    BuildFingerprint=Nothing/Tetris/Tetris:16/BP2A.250605.031.A3/2609281140:user/release-keys \
    DeviceProduct=$(DEVICE_CODENAME) \
    DeviceName=$(DEVICE_CODENAME) \
    SystemDevice=$(DEVICE_CODENAME) \
    SystemName=$(DEVICE_CODENAME)
