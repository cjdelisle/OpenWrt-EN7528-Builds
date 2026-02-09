#!/bin/sh

git clone https://github.com/naseef/openwrt.git
cd openwrt || exit 1
git checkout en7528-subtarget

./scripts/feeds update -a
./scripts/feeds install -a

echo '
CONFIG_TARGET_econet=y
CONFIG_TARGET_econet_en7528=y
CONFIG_TARGET_MULTI_PROFILE=y
CONFIG_TARGET_DEVICE_econet_en7528_DEVICE_dasan_h660gm-a=y
CONFIG_TARGET_DEVICE_PACKAGES_econet_en7528_DEVICE_dasan_h660gm-a=""
CONFIG_TARGET_DEVICE_econet_en7528_DEVICE_en7528_generic=y
CONFIG_TARGET_DEVICE_PACKAGES_econet_en7528_DEVICE_en7528_generic=""
CONFIG_TARGET_PER_DEVICE_ROOTFS=y
CONFIG_IMAGEOPT=y
CONFIG_PACKAGE_kmod-crypto-sha256=y
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-lib-crc16=y
CONFIG_PACKAGE_kmod-libphy=y
CONFIG_PACKAGE_kmod-mii=y
CONFIG_PACKAGE_kmod-nls-base=y
CONFIG_PACKAGE_kmod-nls-cp437=y
CONFIG_PACKAGE_kmod-nls-iso8859-1=y
CONFIG_PACKAGE_kmod-nls-utf8=y
CONFIG_PACKAGE_kmod-scsi-core=y
CONFIG_PACKAGE_kmod-tun=y
CONFIG_PACKAGE_kmod-usb-common=y
CONFIG_PACKAGE_kmod-usb-core=y
CONFIG_PACKAGE_kmod-usb-net-rtl8152=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_kmod-usb-xhci-hcd=m
CONFIG_PACKAGE_kmod-usb3=m
CONFIG_PACKAGE_libatomic=y
CONFIG_PACKAGE_libpthread=y
CONFIG_PACKAGE_librt=y
CONFIG_PACKAGE_libstdcpp=y
CONFIG_PACKAGE_r8152-firmware=y
CONFIG_PACKAGE_kmod-cfg80211=y
CONFIG_PACKAGE_kmod-mac80211=y
CONFIG_PACKAGE_kmod-mt76-core=y
CONFIG_PACKAGE_kmod-mt76-connac=y
CONFIG_PACKAGE_kmod-mt7603=y
CONFIG_PACKAGE_kmod-mt7615-common=y
CONFIG_PACKAGE_kmod-mt7615e=y
CONFIG_PACKAGE_kmod-mt7663-firmware-ap=y
CONFIG_PACKAGE_hostapd-common=y
CONFIG_PACKAGE_wpad-basic-mbedtls=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_libiperf3=y
CONFIG_TARGET_INITRAMFS_COMPRESSION_NONE=y
CONFIG_TARGET_ROOTFS_INITRAMFS=y
' > .config

make defconfig

make "-j$(nproc)"

# We need to do this for now because otherwise the binaries are unfindable
cd ./bin/targets/econet/en7528
ls | sed -n -e 's/openwrt-snapshot-\(.*\)-econet-\(.*\)/mv openwrt-snapshot-\1-econet-\2 openwrt-econet-\2/p' | sh

