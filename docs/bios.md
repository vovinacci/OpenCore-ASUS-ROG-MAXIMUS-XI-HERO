# BIOS

This section describes BIOS settings for ASUS ROG MAXIMUS XI HERO.

## BIOS settings

- Version [2004](https://dlcdnets.asus.com/pub/ASUS/mb/BIOS/ROG-MAXIMUS-XI-HERO-ASUS-2004.ZIP) could be obtained from
  the [download page](https://rog.asus.com/motherboards/rog-maximus/rog-maximus-xi-hero-model/helpdesk_bios/).
- Settings [backup](../BIOS/V2004.CMO).

BIOS settings are based on Dortania
[Coffee Lake Intel BIOS settings](https://dortania.github.io/OpenCore-Install-Guide/config.plist/coffee-lake.html#intel-bios-settings) recommendations:

- Advanced

  | Submenu                         | Key / Value                                      | Comment                                                |
  |---------------------------------|--------------------------------------------------|--------------------------------------------------------|
  | CPU Configuration               | Software Guard Extensions (SGX): `Disabled`      |                                                        |
  | CPU Configuration               | Intel (VMX) Virtualization Technology: `Enabled` | Required for [Docker](https://www.docker.com/)         |
  | System Agent (SA) Configuration | VT-d: `Enabled`                                  | Could be enabled as `DisableIoMapper` is set to `true` |
  | System Agent (SA) Configuration | Above 4G Decoding: `Enabled`                     |                                                        |
  | USB Configuration               | XHCI Hand-off: `Enabled`                         |                                                        |
  | USB Configuration               | Legacy USB Support: `Enabled`                    |                                                        |

- Boot

  | Submenu            | Key / Value                   | Comment                                                                                                                                                                 |
  |--------------------|-------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
  | Boot Configuration | Fast Boot: `Disabled`         |                                                                                                                                                                         |
  | Boot Configuration | Boot Logo Display: `Disabled` |                                                                                                                                                                         |
  | Boot Configuration | Bootup NumLock State: `Off`   | This is a matter of personal preferences                                                                                                                                |
  | Secure Boot        | OS Type: `Windows UEFI mode`  | Ensure `Secure Boot state` is in `Disabled` state. If this is not the case, navigate to `Boot` -> `Secure Boot` -> `Key Management` and select `Clear Secure Boot Keys` |
