# Copyright (C) 2018 Project dotOS
# Copyright (C) 2018 VenomRom
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


PRODUCT_BRAND ?= VenomRom

include vendor/venom/config/version.mk

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/venom/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/venom/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh \

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/venom/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/venom/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Bootanimation
TARGET_BOOTANIMATION_480P := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -le 720 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Bootanimation
ifeq ($(TARGET_BOOTANIMATION_480P),true)
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/bootanimation/bootanimation-480p.zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/bootanimation/bootanimation.zip:system/media/bootanimation.zip
endif

# priv-app permissions
PRODUCT_COPY_FILES += \
    vendor/superior/prebuilt/common/etc/permissions/privapp-permissions-superior.xml:system/etc/permissions/privapp-permissions-superior.xml

# Device Overlays
DEVICE_PACKAGE_OVERLAYS += \
    vendor/venom/overlay/common \
    vendor/venom/overlay/dictionaries \
    vendor/venom/overlay/themes


# EXT4/F2FS format script
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/bin/format.sh:install/bin/format.sh

# Custom superiorOS packages
PRODUCT_PACKAGES += \
    LatinIME \
    PixelLauncher3 \
    Calendar \
    LiveWallpapers \
    LiveWallpapersPicker \
    Stk \
    Recorder \
    Music \
    Browser \
    InterfaceCenter \
    SystemUpdates \
    MarkupGoogle \
    WellbeingPrebuilt

# Extra tools
PRODUCT_PACKAGES += \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    7z \
    bzip2 \
    curl \
    lib7z \
    powertop \
    pigz \
    tinymix \
    unrar \
    unzip \
    zip \
	vim \
    rsync \
	bash

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/venom/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Markup libs
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/lib/libsketchology_native.so:system/lib/libsketchology_native.so \
    vendor/venom/prebuilt/common/lib64/libsketchology_native.so:system/lib64/libsketchology_native.so

# Pixel sysconfig
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/etc/sysconfig/pixel.xml:system/etc/sysconfig/pixel.xml	

# init.d support
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner

# superiorOS-specific init file
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/etc/init.local.rc:root/init.venom.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/venom/prebuilt/common/media/LMspeed_508.emd:system/media/LMspeed_508.emd \
    vendor/venom/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Fix Dialer
PRODUCT_COPY_FILES +=  \
    vendor/venom/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Media
PRODUCT_GENERIC_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Needed by some RILs and for some Gapps packages
PRODUCT_PACKAGES += \
    librsjni \
    libprotobuf-cpp-full

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images

# Clean cache
PRODUCT_COPY_FILES += \
    vendor/venom/prebuilt/common/bin/clean_cache.sh:system/bin/clean_cache.sh

# Recommend using the non debug dexpreopter
USE_DEX2OAT_DEBUG ?= false

# CAF
# Telephony packages
PRODUCT_PACKAGES += \
    ims-ext-common \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

#Telephony
$(call inherit-product, vendor/venom/config/telephony.mk)

# Venom_props
$(call inherit-product, vendor/venom/config/venom_props.mk)

# Packages
include vendor/venom/config/packages.mk

# Enable ADB authentication
ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.adb.secure=1
endif

# Include SDCLANG definitions if it is requested and available
#ifeq ($(HOST_OS),linux)
#    ifneq ($(wildcard vendor/qcom/sdclang-4.0/),)
#        include vendor/venom/sdclang/sdclang.mk
#    endif
#endif
