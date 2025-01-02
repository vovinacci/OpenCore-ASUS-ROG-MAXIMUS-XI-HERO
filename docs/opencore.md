# OpenCore configuration details

You may find great installation guide [here](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/).

- [Dortania OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)
- [Desktop Coffee Lake](https://dortania.github.io/OpenCore-Install-Guide/config.plist/coffee-lake.html)
- [OpenCanopy](https://dortania.github.io/OpenCore-Post-Install/cosmetic/gui.html)
- [FileVault](https://dortania.github.io/OpenCore-Post-Install/universal/security/filevault.html)

## ACPI

As per [Dortania OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/config.plist/coffee-lake.html#acpi), compiled SSDTs:

- [SSDT-AWAC.aml](../assets/ACPI/SSDT-AWAC.aml)
- [SSDT-EC-USBX.aml](../assets/ACPI/SSDT-EC-USBX.aml)
- [SSDT-PLUG.aml](../assets/ACPI/SSDT-PLUG.aml)
- [SSDT-PMC.aml](../assets/ACPI/SSDT-PMC.aml)

## USB

Based on Dortania [USB Mapping Guide](https://dortania.github.io/OpenCore-Post-Install/usb/) and [Intel USB mapping](https://dortania.github.io/OpenCore-Post-Install/usb/intel-mapping/intel.html).

USB port naming taken from [this great reddit post](https://www.reddit.com/r/hackintosh/comments/agzo9l/i99900k_asus_rog_maximus_xi_hero_64gb_ram/).
![USB port mapping](../assets/usb-mapping.png)

Resulting [USBMap.kext](../Kexts/USBMap.kext) is used.

## Drivers

- OpenCore
  - `OpenCanopy.efi`
  - `OpenRuntime.efi`
  - `ResetNvramEntry.efi`
  - `ToggleSipEntry.efi`
- [OcBinaryData](https://github.com/acidanthera/OcBinaryData)
  - [HfsPlus.efi](https://github.com/acidanthera/OcBinaryData/blob/master/Drivers/HfsPlus.efi)

## Kext

- [AppleALC 1.9.3](https://github.com/acidanthera/AppleALC/releases/tag/1.9.3)
- [IntelMausi 1.0.8](https://github.com/acidanthera/IntelMausi/releases/tag/1.0.8)
- [Lilu 1.7.0](https://github.com/acidanthera/Lilu/releases/tag/1.7.0)
- [VirtualSMC 1.3.4](https://github.com/acidanthera/VirtualSMC/releases/tag/1.3.4) (`SMCProcessor.kext`, `SMCSuperIO.kext`)
- [WhateverGreen 1.6.9](https://github.com/acidanthera/WhateverGreen/releases/tag/1.6.9)

### Resources

- [OpenCanopy](https://dortania.github.io/OpenCore-Post-Install/cosmetic/gui.html) theme - `Acidanthera\GoldenGate`
  - OpenCanopy theme [background](../assets/README.md) - `Background.icns`
- [OcBinaryData](https://github.com/acidanthera/OcBinaryData) - [Resources/](https://github.com/acidanthera/OcBinaryData/blob/master/Resources)

### Tools

- OpenCore
  - `OpenControl.efi`
  - `OpenShell.efi`
  - `ResetSystem.efi`
- [PassMark MemTest86](../tools/README.md#passmark-memtest86)
