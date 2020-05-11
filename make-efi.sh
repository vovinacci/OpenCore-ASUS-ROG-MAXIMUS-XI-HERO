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
#
# Packages
# Base URL
readonly OC_BASE_URL="https://github.com/acidanthera"
# Package names
readonly PKG_OC="OpenCore-${OPENCORE_VERSION}-RELEASE"
readonly PKG_OC_BINDATA="master"
readonly PKG_KEXT_APPLEALC="AppleALC-${KEXT_APPLEALC_VERSION}-RELEASE"
readonly PKG_KEXT_INTELMAUSI="IntelMausi-${KEXT_INTELMAUSI_VERSION}-RELEASE"
readonly PKG_KEXT_LILU="Lilu-${KEXT_LILU_VERSION}-RELEASE"
readonly PKG_KEXT_USBINJECTALL="RehabMan-USBInjectAll-${KEXT_USBINJECTALL_VERSION}"
readonly PKG_KEXT_VIRTUALSMC="VirtualSMC-${KEXT_VIRTUALSMC_VERSION}-RELEASE"
readonly PKG_KEXT_WHATEVERGREEN="WhateverGreen-${KEXT_WHATEVERGREEN_VERSION}-RELEASE"
# Download package list
declare -ar PKG_DOWNLOAD_LIST=(
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
declare -ar PKG_LIST=(
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
# Configuration
#
# ACPI SSDT
declare -ar ACPI_SSDT_DOWNLOAD_LIST=(
  "https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-AWAC.dsl"
  "https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-EC-USBX.dsl"
  "https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-PLUG.dsl"
  "https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Docs/AcpiSamples/SSDT-PMC.dsl"
  "https://github.com/vovinacci/OpenCore-ASUS-ROG-MAXIMUS-XI-HERO/raw/master/ACPI/SSDT-UIAC.aml"
)
# OpenCore configuration
readonly OC_CONFIG_PLIST="https://github.com/vovinacci/OpenCore-ASUS-ROG-MAXIMUS-XI-HERO/raw/master/OC/config.plist"

# Files and directories
# Base directories
readonly BASE_DIR="$(dirname "$(realpath "$0")")"
readonly BASE_EFI_DIR="${BASE_DIR}/EFI"
readonly BASE_OC_DIR="${BASE_EFI_DIR}/OC"

# Print error message and exit
# Arguments:
#   Error message
fail() {
  (>&2 echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [FATAL]: $*")
  exit 1
}

# Download all ACPI SSDT to ACPI directory in TMP_DIR
# Globals:
#   ACPI_SSDT_DOWNLOAD_LIST
#   TMP_DIR
download_acpi_ssdt() {
  echo "Downloading ACPI SSDTs..."
  mkdir -p "${TMP_DIR}/ACPI"
  for i in "${ACPI_SSDT_DOWNLOAD_LIST[@]}"; do
    wget -nv -c -P "${TMP_DIR}/ACPI/" "$i"
  done
}

# Download OpenCore 'config.plist' to TMP_DIR
# Globals:
#   OC_CONFIG_PLIST
#   TMP_DIR
download_oc_config() {
  echo "Downloading config.plist..."
  wget -nv -c -P "${TMP_DIR}/" "${OC_CONFIG_PLIST}"
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
  popd > /dev/null
}

# Create EFI directory structure
# Globals:
#   BASE_EFI_DIR
#   BASE_OC_DIR
create_efi_dirs() {
  echo "Deleting EFI directory..."
  rm -rfv "${BASE_EFI_DIR}"
  echo "Creating EFI directory structure..."
  mkdir -pv "${BASE_EFI_DIR}"
  mkdir -pv "${BASE_EFI_DIR}"/BOOT
  mkdir -pv "${BASE_OC_DIR}"
  mkdir -pv "${BASE_OC_DIR}"/{ACPI,Bootstrap,Drivers,Kexts,Resources,Tools}
  mkdir -pv "${BASE_OC_DIR}"/Resources/{Audio,Font,Image,Label}
}

# Copy OpenCore binaries to EFI directory
# Globals:
#   BASE_EFI_DIR
#   BASE_OC_DIR
#   PKG_OC
#   TMP_DIR
copy_oc_bin() {
  echo "Copying OpenCore binaries to EFI directories..."
  cp -v "${TMP_DIR}/${PKG_OC}/EFI/BOOT/BOOTx64.efi" "${BASE_EFI_DIR}"/BOOT/
  cp -v "${TMP_DIR}/${PKG_OC}/EFI/OC/OpenCore.efi" "${BASE_OC_DIR}"/
  cp -v "${TMP_DIR}/${PKG_OC}/EFI/OC/Bootstrap/Bootstrap.efi" "${BASE_OC_DIR}"/Bootstrap/
  cp -v "${TMP_DIR}/${PKG_OC}/EFI/OC/Tools/"{OpenControl.efi,OpenShell.efi,ResetSystem.efi} "${BASE_OC_DIR}"/Tools/
}

# Copy OpenCore configuration template to EFI folder
# Globals:
#   BASE_OC_DIR
#   TMP_DIR
copy_oc_config() {
  echo "Copying OpenCore configuration template..."
  cp -v "${TMP_DIR}/config.plist" "${BASE_OC_DIR}"/
}

# Copy ACPI SSDT to EFI/ACPI directory
# Globals:
#   BASE_OC_DIR
#   TMP_DIR
copy_acpi_ssdt() {
  echo "Copying ACPI SSTDs to EFI/ACPI directory..."
  cp -rv "${TMP_DIR}/ACPI"/{SSDT-AWAC.dsl,SSDT-EC-USBX.dsl,SSDT-PLUG.dsl,SSDT-PMC.dsl,SSDT-UIAC.aml} "${BASE_OC_DIR}"/ACPI
}

# Copy OpenCore drivers to EFI directory
# Globals:
#   BASE_OC_DIR
#   PKG_OC
#   PKG_OC_BINDATA
#   TMP_DIR
copy_oc_drivers() {
  echo "Copying OpenCore drivers to EFI/Drivers directory..."
  cp -v "${TMP_DIR}/${PKG_OC}/EFI/OC/Drivers/"{OpenCanopy.efi,OpenRuntime.efi} "${BASE_OC_DIR}"/Drivers/
  cp -v "${TMP_DIR}/${PKG_OC_BINDATA}/OcBinaryData-master/Drivers/HfsPlus.efi" "${BASE_OC_DIR}"/Drivers/
}

# Copy Kexts to EFI directory
# Globals:
#   BASE_OC_DIR
#   PKG_KEXT_APPLEALC
#   PKG_KEXT_INTELMAUSI
#   PKG_KEXT_LILU
#   PKG_KEXT_USBINJECTALL
#   PKG_KEXT_VIRTUALSMC
#   PKG_KEXT_WHATEVERGREEN
#   TMP_DIR
copy_kexts() {
  echo "Copying Kexts to EFI/Kexts directory..."
  # TODO: Implement me
}

# Copy OpenCore resource files to EFI/Resources directories
# Globals:
#   BASE_OC_DIR
#   PKG_OC_BINDATA
#   TMP_DIR
copy_oc_resources() {
  echo "Copying OpenCore resource files to EFI/Resources directories..."
  # TODO: Implement me
}

## Start the ball
# Download all required data
download_acpi_ssdt
download_oc_config
download_pkg
unarchive_pkg
# Create EFI folder
create_efi_dirs
copy_oc_bin
copy_oc_config
copy_acpi_ssdt
copy_oc_drivers
copy_kexts
copy_oc_resources

# EOF
