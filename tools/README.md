# Tools

Additional tools used with OpenCore.

## PassMark MemTest86

[PassMark MemTest86](https://www.memtest86.com/) is the original, free, standalone memory testing software for x86 and ARM computers.

Version used - `10.4 Build 1000`.

**Notes**:

- Currently, installation process is not automated - files are extracted manually to the [memtest86](memtest86) folder below.
- It's assumed that steps below are done from macOS.
- If done from Linux - follow [this guide](https://www.funtoo.org/User:Hackbyte/Memtest_from_EFI_boot_selection) for extracting files to the directory specified
  below.

Installation:

- Download [MemTest86 archive](https://www.memtest86.com/downloads/memtest86-usb.zip).
- Unzip it and mount `memtest86-usb.img`. It's assumed that it's located in `~/Downloads/memtest86-usb/memtest86-usb.img`

  ```console
  $ hdiutil mount ~/Downloads/memtest86-usb/memtest86-usb.img
  /dev/disk6              GUID_partition_scheme
  /dev/disk6s1            Microsoft Basic Data            /Volumes/NO NAME
  /dev/disk6s2            EFI
  ```

- (Optional) Remove old `memtest86` folder contents:

  ```shell
  rm -fr ./memtest86
  mkdir -p ./memtest86
  ```

- Copy `/Volumes/NO NAME/EFI/BOOT/` contents to `memtest86` directory:

  ```shell
  cp /Volumes/NO\ NAME/EFI/BOOT/{BOOTX64.efi,blacklist.cfg,mt86.png,unifont.bin} ./memtest86/
  chmod 0644 ./memtest86/{BOOTX64.efi,blacklist.cfg,mt86.png,unifont.bin}
  ```

- Unmount the volume and cleanup

  ```console
  $ hdiutil unmount /Volumes/NO\ NAME
  "/Volumes/NO NAME" unmounted successfully.
  $ rm -fr ~/Downloads/{memtest86-usb.zip,memtest86-usb}
  ```
