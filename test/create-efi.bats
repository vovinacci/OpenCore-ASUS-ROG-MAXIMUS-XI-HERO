#!/usr/bin/env bats
#
# 'create-efi.sh' tests.
# shellcheck disable=SC2030,SC2031

TEST_BREW_PREFIX="$(brew --prefix)"
readonly TEST_BREW_PREFIX

load "${TEST_BREW_PREFIX}/lib/bats-support/load.bash"
load "${TEST_BREW_PREFIX}/lib/bats-assert/load.bash"

# Cleanup after each test case
function teardown() {
  make clean
}

# Replace OpenCore configuration template placeholders with dummy values.
# Save resulting file as './EFI/OC/config.plist.test'
function replace_dummy_values() {
  OC_CONFIG_FILE="./EFI/OC/config.plist"
  OC_CONFIG_PLIST_TEMPLATE=$(<"./EFI/OC/config.plist")
  readonly OC_CONFIG_FILE OC_CONFIG_PLIST_TEMPLATE

  OC_CONFIG_PLIST="${OC_CONFIG_PLIST_TEMPLATE//\{\{BOARDSERIAL\}\}/M0000000000000001}"
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{MACADDRESS\}\}/ESIzRFVm}"
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{SERIAL\}\}/W00000000001}"
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{SMUUID\}\}/00000000-0000-0000-0000-000000000000}"
  echo "$OC_CONFIG_PLIST" >"${OC_CONFIG_FILE}.test"
}

@test "create-efi.sh: OC_PKG_VARIANT != RELEASE|DEBUG should fail the script" {
  export OC_PKG_VARIANT=TEST
  run ./create-efi.sh
  assert_failure 1
  assert_output --partial "Unsupported OpenCore package variant \"${OC_PKG_VARIANT}\". OC_PKG_VARIANT should be set to \"DEBUG\" or \"RELEASE\"."
}

@test "create-efi.sh: Running with defaults should be successful" {
  run ./create-efi.sh
  # Assert status code
  assert_success
  # Assert output
  assert_output --partial "OpenCore package variant: \"RELEASE\"."
  assert_output --partial "Downloading ACPI SSDTs..."
  assert_output --partial "Downloading extra Kexts..."
  assert_output --partial "Downloading config.plist..."
  assert_output --partial "Downloading theme background image..."
  assert_output --partial "Downloading packages..."
  assert_output --partial "Downloading tools..."
  assert_output --partial "Unarchiving packages..."
  assert_output --partial "Deleting EFI directory..."
  assert_output --partial "Creating EFI directory structure..."
  assert_output --partial "Copying OpenCore binaries to EFI directories..."
  assert_output --partial "Copying OpenCore configuration template..."
  assert_output --partial "Copying ACPI SSTDs to EFI/ACPI directory..."
  assert_output --partial "Copying OpenCore drivers to EFI/Drivers directory..."
  assert_output --partial "Copying Kexts to EFI/Kexts directory..."
  assert_output --partial "Copying OpenCore resource files to EFI/Resources directories..."
  assert_output --partial "Copying OpenCore theme to EFI/Resources/Image/Acidanthera/GoldenGate' directory..."
  assert_output --partial "Copying tools to EFI/Tools directory..."
  # Assert files
  assert [ -d ./EFI ]
  assert [ -d ./EFI/BOOT ]
  assert [ -e ./EFI/BOOT/BOOTx64.efi ]
  assert [ -d ./EFI/OC ]
  assert [ -d ./EFI/OC/ACPI ]
  assert [ -e ./EFI/OC/ACPI/SSDT-AWAC.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-EC-USBX.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-PLUG.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-PMC.aml ]
  assert [ -d ./EFI/OC/Drivers ]
  assert [ -e ./EFI/OC/Drivers/HfsPlus.efi ]
  assert [ -e ./EFI/OC/Drivers/OpenCanopy.efi ]
  assert [ -e ./EFI/OC/Drivers/OpenRuntime.efi ]
  assert [ -e ./EFI/OC/Drivers/ResetNvramEntry.efi ]
  assert [ -e ./EFI/OC/Drivers/ToggleSipEntry.efi ]
  assert [ -d ./EFI/OC/Kexts ]
  assert [ -d ./EFI/OC/Kexts/AppleALC.kext ]
  assert [ -d ./EFI/OC/Kexts/IntelMausi.kext ]
  assert [ -d ./EFI/OC/Kexts/Lilu.kext ]
  assert [ -d ./EFI/OC/Kexts/SMCProcessor.kext ]
  assert [ -d ./EFI/OC/Kexts/SMCSuperIO.kext ]
  assert [ -e ./EFI/OC/Kexts/USBMap.kext/Contents/Info.plist ]
  assert [ -d ./EFI/OC/Kexts/VirtualSMC.kext ]
  assert [ -d ./EFI/OC/Resources ]
  assert [ -d ./EFI/OC/Resources/Audio ]
  assert [ -d ./EFI/OC/Resources/Font ]
  assert [ -e ./EFI/OC/Resources/Font/Terminus.hex ]
  assert [ -e ./EFI/OC/Resources/Font/TerminusCore.hex ]
  assert [ -d ./EFI/OC/Resources/Image/Acidanthera ]
  assert [ -e ./EFI/OC/Resources/Image/Acidanthera/GoldenGate/Background.icns ]
  assert [ -d ./EFI/OC/Resources/Label ]
  assert [ -d ./EFI/OC/Tools ]
  assert [ -d ./EFI/OC/Tools/memtest86 ]
  assert [ -e ./EFI/OC/Tools/memtest86/blacklist.cfg ]
  assert [ -e ./EFI/OC/Tools/memtest86/BOOTX64.efi ]
  assert [ -e ./EFI/OC/Tools/memtest86/mt86.png ]
  assert [ -e ./EFI/OC/Tools/memtest86/unifont.bin ]
  assert [ -e ./EFI/OC/Tools/OpenControl.efi ]
  assert [ -e ./EFI/OC/Tools/OpenShell.efi ]
  assert [ -e ./EFI/OC/Tools/ResetSystem.efi ]
  assert [ -e ./EFI/OC/config.plist ]
  assert [ -e ./EFI/OC/OpenCore.efi ]
}

@test "create-efi.sh: Running with LOCAL_RUN=1 should be successful" {
  export LOCAL_RUN=1
  run ./create-efi.sh
  assert_success
  assert_output --partial "OpenCore package variant: \"RELEASE\"."
  assert_output --partial "Local run: Don't download Kexts, tools and config.plist."
  assert_output --partial "Downloading ACPI SSDTs..."
  assert_output --partial "Copying extra Kexts..."
  assert_output --partial "Copying config.plist..."
  assert_output --partial "Copying theme background image..."
  assert_output --partial "Downloading packages..."
  assert_output --partial "Copying tools..."
  assert_output --partial "Unarchiving packages..."
  assert_output --partial "Local run: Copy OpenCore configuration validation utility (ocvalidate)..."
  assert_output --partial "Deleting EFI directory..."
  assert_output --partial "Creating EFI directory structure..."
  assert_output --partial "Copying OpenCore binaries to EFI directories..."
  assert_output --partial "Copying OpenCore configuration template..."
  assert_output --partial "Copying ACPI SSTDs to EFI/ACPI directory..."
  assert_output --partial "Copying OpenCore drivers to EFI/Drivers directory..."
  assert_output --partial "Copying Kexts to EFI/Kexts directory..."
  assert_output --partial "Copying OpenCore resource files to EFI/Resources directories..."
  assert_output --partial "Copying OpenCore theme to EFI/Resources/Image/Acidanthera/GoldenGate' directory..."
  assert_output --partial "Copying tools to EFI/Tools directory..."
  # Assert files
  assert [ -d ./EFI ]
  assert [ -d ./EFI/BOOT ]
  assert [ -e ./EFI/BOOT/BOOTx64.efi ]
  assert [ -d ./EFI/OC ]
  assert [ -d ./EFI/OC/ACPI ]
  assert [ -e ./EFI/OC/ACPI/SSDT-AWAC.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-EC-USBX.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-PLUG.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-PMC.aml ]
  assert [ -d ./EFI/OC/Drivers ]
  assert [ -e ./EFI/OC/Drivers/HfsPlus.efi ]
  assert [ -e ./EFI/OC/Drivers/OpenCanopy.efi ]
  assert [ -e ./EFI/OC/Drivers/OpenRuntime.efi ]
  assert [ -e ./EFI/OC/Drivers/ResetNvramEntry.efi ]
  assert [ -e ./EFI/OC/Drivers/ToggleSipEntry.efi ]
  assert [ -d ./EFI/OC/Kexts ]
  assert [ -d ./EFI/OC/Kexts/AppleALC.kext ]
  assert [ -d ./EFI/OC/Kexts/IntelMausi.kext ]
  assert [ -d ./EFI/OC/Kexts/Lilu.kext ]
  assert [ -d ./EFI/OC/Kexts/SMCProcessor.kext ]
  assert [ -d ./EFI/OC/Kexts/SMCSuperIO.kext ]
  assert [ -e ./EFI/OC/Kexts/USBMap.kext/Contents/Info.plist ]
  assert [ -d ./EFI/OC/Kexts/VirtualSMC.kext ]
  assert [ -d ./EFI/OC/Resources ]
  assert [ -d ./EFI/OC/Resources/Audio ]
  assert [ -d ./EFI/OC/Resources/Font ]
  assert [ -d ./EFI/OC/Resources/Image/Acidanthera ]
  assert [ -e ./EFI/OC/Resources/Image/Acidanthera/GoldenGate/Background.icns ]
  assert [ -d ./EFI/OC/Resources/Label ]
  assert [ -d ./EFI/OC/Tools ]
  assert [ -d ./EFI/OC/Tools/memtest86 ]
  assert [ -e ./EFI/OC/Tools/memtest86/blacklist.cfg ]
  assert [ -e ./EFI/OC/Tools/memtest86/BOOTX64.efi ]
  assert [ -e ./EFI/OC/Tools/memtest86/mt86.png ]
  assert [ -e ./EFI/OC/Tools/memtest86/unifont.bin ]
  assert [ -e ./EFI/OC/Tools/OpenControl.efi ]
  assert [ -e ./EFI/OC/Tools/OpenShell.efi ]
  assert [ -e ./EFI/OC/Tools/ResetSystem.efi ]
  assert [ -e ./EFI/OC/config.plist ]
  assert [ -e ./EFI/OC/OpenCore.efi ]
  assert [ -e ./util/ocvalidate ]
  # Assert configuration validation
  replace_dummy_values
  run ./util/ocvalidate ./EFI/OC/config.plist.test
  assert_success
}

@test "create-efi.sh: Running with LOCAL_RUN=1 and OC_PKG_VARIANT=DEBUG should be successful" {
  export LOCAL_RUN=1
  export OC_PKG_VARIANT=DEBUG
  run ./create-efi.sh
  assert_success
  assert_output --partial "OpenCore package variant: \"DEBUG\"."
  assert_output --partial "Local run: Don't download Kexts, tools and config.plist."
  assert_output --partial "Downloading ACPI SSDTs..."
  assert_output --partial "Copying extra Kexts..."
  assert_output --partial "Copying config.plist..."
  assert_output --partial "Copying theme background image..."
  assert_output --partial "Downloading packages..."
  assert_output --partial "Copying tools..."
  assert_output --partial "Unarchiving packages..."
  assert_output --partial "Local run: Copy OpenCore configuration validation utility (ocvalidate)..."
  assert_output --partial "Deleting EFI directory..."
  assert_output --partial "Creating EFI directory structure..."
  assert_output --partial "Copying OpenCore binaries to EFI directories..."
  assert_output --partial "Copying OpenCore configuration template..."
  assert_output --partial "Copying ACPI SSTDs to EFI/ACPI directory..."
  assert_output --partial "Copying OpenCore drivers to EFI/Drivers directory..."
  assert_output --partial "Copying Kexts to EFI/Kexts directory..."
  assert_output --partial "Copying OpenCore resource files to EFI/Resources directories..."
  assert_output --partial "Copying OpenCore theme to EFI/Resources/Image/Acidanthera/GoldenGate' directory..."
  assert_output --partial "Copying tools to EFI/Tools directory..."
  # Assert files
  assert [ -d ./EFI ]
  assert [ -d ./EFI/BOOT ]
  assert [ -e ./EFI/BOOT/BOOTx64.efi ]
  assert [ -d ./EFI/OC ]
  assert [ -d ./EFI/OC/ACPI ]
  assert [ -e ./EFI/OC/ACPI/SSDT-AWAC.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-EC-USBX.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-PLUG.aml ]
  assert [ -e ./EFI/OC/ACPI/SSDT-PMC.aml ]
  assert [ -d ./EFI/OC/Drivers ]
  assert [ -e ./EFI/OC/Drivers/HfsPlus.efi ]
  assert [ -e ./EFI/OC/Drivers/OpenCanopy.efi ]
  assert [ -e ./EFI/OC/Drivers/OpenRuntime.efi ]
  assert [ -e ./EFI/OC/Drivers/ResetNvramEntry.efi ]
  assert [ -e ./EFI/OC/Drivers/ToggleSipEntry.efi ]
  assert [ -d ./EFI/OC/Kexts ]
  assert [ -d ./EFI/OC/Kexts/AppleALC.kext ]
  assert [ -d ./EFI/OC/Kexts/IntelMausi.kext ]
  assert [ -d ./EFI/OC/Kexts/Lilu.kext ]
  assert [ -d ./EFI/OC/Kexts/SMCProcessor.kext ]
  assert [ -d ./EFI/OC/Kexts/SMCSuperIO.kext ]
  assert [ -e ./EFI/OC/Kexts/USBMap.kext/Contents/Info.plist ]
  assert [ -d ./EFI/OC/Kexts/VirtualSMC.kext ]
  assert [ -d ./EFI/OC/Resources ]
  assert [ -d ./EFI/OC/Resources/Audio ]
  assert [ -d ./EFI/OC/Resources/Font ]
  assert [ -e ./EFI/OC/Resources/Font/Terminus.hex ]
  assert [ -e ./EFI/OC/Resources/Font/TerminusCore.hex ]
  assert [ -d ./EFI/OC/Resources/Image/Acidanthera ]
  assert [ -e ./EFI/OC/Resources/Image/Acidanthera/GoldenGate/Background.icns ]
  assert [ -d ./EFI/OC/Resources/Label ]
  assert [ -d ./EFI/OC/Tools ]
  assert [ -d ./EFI/OC/Tools/memtest86 ]
  assert [ -e ./EFI/OC/Tools/memtest86/blacklist.cfg ]
  assert [ -e ./EFI/OC/Tools/memtest86/BOOTX64.efi ]
  assert [ -e ./EFI/OC/Tools/memtest86/mt86.png ]
  assert [ -e ./EFI/OC/Tools/memtest86/unifont.bin ]
  assert [ -e ./EFI/OC/Tools/OpenControl.efi ]
  assert [ -e ./EFI/OC/Tools/OpenShell.efi ]
  assert [ -e ./EFI/OC/Tools/ResetSystem.efi ]
  assert [ -e ./EFI/OC/config.plist ]
  assert [ -e ./EFI/OC/OpenCore.efi ]
  assert [ -e ./util/ocvalidate ]
  # Assert configuration validation
  replace_dummy_values
  run ./util/ocvalidate ./EFI/OC/config.plist.test
  assert_success
}
