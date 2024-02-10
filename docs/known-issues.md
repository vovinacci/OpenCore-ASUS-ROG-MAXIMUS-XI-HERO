# Known issues

**Open**:

- [ ] Wireless doesn't work in Sonoma.

  - Sonoma, removed IO80211FamilyLegacy support, which drops support for **BCM943224**, **BCM94331**, **BCM94350**, **BCM94360**, **BCM943602** based cards.
    This drops [Fenvi HB1200 WiFi + Bluetooth 4.0 BCM4360](https://www.amazon.com/gp/product/B07T9JD93Y/) and
    [Fenvi T-919 Wi-Fi + Bluetooth 4.0 BCM94360CD](https://pcpartpicker.com/product/BJ97YJ/fenvi-fv-t919-none-wi-fi-adapter-fv-t919) Wi-Fi support.

    Bluetooth works just fine.

    More details: [macOS Sonoma and OpenCore Legacy Patcher Support](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1076)

    **Workaround**: (28-Sep-2023) Bought [BrosTrend AC1200 WiFi to Ethernet Adapter](https://www.amazon.com/BrosTrend-600Mbps-Adapter-Wireless-WNA016/dp/B0118SPFCK)
    and connected via Ethernet cable.

**Resolved**:

- [x] [Fenvi T-919 Wi-Fi + Bluetooth 4.0 BCM94360CD](https://pcpartpicker.com/product/BJ97YJ/fenvi-fv-t919-none-wi-fi-adapter-fv-t919) started having issues mid-autumn 2020:

  - After shut down and then powering on PC again, Bluetooth will not work when logged in to macOS. However, it's fine at earlier stages, e.g., when typing password during the boot. Workaround: unplug and plug power cord after the shutdown.
  - Keyboard and trackpad were working unstable from time to time (input garbage, freezes). Workaround: power cycle keyboard and trackpad, reboot.

  **Solution**: (06-Dec-2020) Replaced [Fenvi T-919 Wi-Fi + Bluetooth 4.0 BCM94360CD](https://pcpartpicker.com/product/BJ97YJ/fenvi-fv-t919-none-wi-fi-adapter-fv-t919) with [Fenvi HB1200 Wi-Fi + Bluetooth 4.0 BCM4360](https://www.amazon.com/gp/product/B07T9JD93Y/).

- [x] macOS Catalina version 10.15.7 started rebooting suddenly

  - [MemTest86](https://www.memtest86.com/) revealed one [BLS16G4D240FSB](https://pcpartpicker.com/product/8GJtt6/crucial-ballistix-sport-lt-16gb-1-x-16gb-ddr4-2400-memory-bls16g4d240fsb) UDIMM to be faulty. Workaround: Remove faulty UDIMM.

  **Solution**: (30-Nov-2020) Ordered and replaced faulty UDIMM.
