#!/usr/bin/env bash
#
# Assemble OpenCore based EFI folder.

# Write safe shell scripts
set -euf -o pipefail
# Set locale
export LC_ALL="en_US.UTF-8"
# Keep environment clean
readonly TMP_DIR="$(mktemp -d)"
trap 'echo "Removing ${TMP_DIR}"; rm -rf ${TMP_DIR}' EXIT SIGHUP SIGINT SIGQUIT SIGPIPE SIGTERM

## Variables
# Package versions. Set desired versions here.
OPENCORE_VERSION="0.5.8"
KEXT_APPLEALC_VERSION="1.4.9"
KEXT_INTELMAUSI_VERSION="1.0.2"
KEXT_LILU_VERSION="1.4.4"
KEXT_USBINJECTALL_VERSION="2018-1108"
KEXT_VIRTUALSMC_VERSION="1.1.3"
KEXT_WHATEVERGREEN_VERSION="1.3.9"

# Download locations
# Base URL
OC_BASE_URL="https://github.com/acidanthera"
# Package names
PKG_OC="OpenCore-${OPENCORE_VERSION}-RELEASE"
PKG_OC_BINDATA="master"
PKG_KEXT_APPLEALC="AppleALC-${KEXT_APPLEALC_VERSION}-RELEASE"
PKG_KEXT_INTELMAUSI="IntelMausi-${KEXT_INTELMAUSI_VERSION}-RELEASE"
PKG_KEXT_LILU="Lilu-${KEXT_LILU_VERSION}-RELEASE"
PKG_KEXT_USBINJECTALL="RehabMan-USBInjectAll-${KEXT_USBINJECTALL_VERSION}"
PKG_KEXT_VIRTUALSMC="VirtualSMC-${KEXT_VIRTUALSMC_VERSION}-RELEASE"
PKG_KEXT_WHATEVERGREEN="WhateverGreen-${KEXT_WHATEVERGREEN_VERSION}-RELEASE"
# Download list
PKG_DOWNLOAD_LIST=(
  # OpenCore
  "${OC_BASE_URL}/OpenCorePkg/releases/download/${OPENCORE_VERSION}/${PKG_OC}.zip"
  # OpenCore binary data
  "${OC_BASE_URL}/OcBinaryData/archive/${PKG_OC_BINDATA}.zip"
  # Kext
  "${OC_BASE_URL}/AppleALC/releases/download/${KEXT_APPLEALC_VERSION}/${PKG_KEXT_APPLEALC}.zip"
  "${OC_BASE_URL}/IntelMausi/releases/download/${KEXT_INTELMAUSI_VERSION}/${PKG_KEXT_INTELMAUSI}.zip"
  "${OC_BASE_URL}/Lilu/releases/download/${KEXT_LILU_VERSION}/${PKG_KEXT_LILU}.zip"
  "https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/${PKG_KEXT_USBINJECTALL}.zip"
  "${OC_BASE_URL}/VirtualSMC/releases/download/${KEXT_VIRTUALSMC_VERSION}/${PKG_KEXT_VIRTUALSMC}.zip"
  "${OC_BASE_URL}/WhateverGreen/releases/download/${KEXT_WHATEVERGREEN_VERSION}/${PKG_KEXT_WHATEVERGREEN}.zip"
)
# Package list
PKG_LIST=(
  # OpenCore
  "$PKG_OC"
  "$PKG_OC_BINDATA"
  # Kext
  "$PKG_KEXT_APPLEALC"
  "$PKG_KEXT_INTELMAUSI"
  "$PKG_KEXT_LILU"
  "$PKG_KEXT_USBINJECTALL"
  "$PKG_KEXT_VIRTUALSMC"
  "$PKG_KEXT_WHATEVERGREEN"
)

# Base directory
#readonly BASE_DIR="EFI/OC"
# ACPI SSDT list
#readonly ACPI_SSDT_PATH="ACPI"
#readonly ACPI_SSDT=(
#  [SSDT-AWAC.aml]=https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-AWAC.dsl
#  [SSDT-EC-USBX.aml]=https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-EC-USBX.dsl
#  [SSDT-PLUG.aml]=https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-PLUG.dsl
#  [SSDT-PMC.aml]=https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-PMC.dsl
#  [SSDT-UIAC.aml]=https://github.com/vovinacci/OpenCore-ASUS-ROG-MAXIMUS-XI-HERO/raw/master/ACPI/SSDT-UIAC.aml
#)
# Drivers
#readonly DRIVERS_PATH="Drivers"

# Print error message and exit
# Arguments:
#   Error message
fail() {
  (>&2 echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [FATAL]: $*")
  exit 1
}

# Download all required packages to TMP_DIR
# Globals:
#   PKG_DOWNLOAD_LIST
#   TMP_DIR
download_pkg() {
  echo "Downloading packages..."
  for i in "${PKG_DOWNLOAD_LIST[@]}"; do
    wget -nv -c -P "${TMP_DIR}"  "$i"
  done
}

# Unarchive all downloaded packages in TMP_DIR and delete archives
# Globals:
#   PKG_LIST
#   TMP_DIR
unarchive_pkg() {
  echo "Unarchiving packages and deleting archives..."
  pushd "${TMP_DIR}" > /dev/null || fail "Cannot 'pushd ${TMP_DIR}'"
  for i in "${PKG_LIST[@]}"; do
    unzip -q "${i}.zip" -d "${i}"
    rm -f "${i}.zip"
  done
  ls -lahR
  popd > /dev/null
}

# Start the ball
download_pkg
unarchive_pkg

# EOF
