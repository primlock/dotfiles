# Wi-Fi "Unavailable" Fix for Debian 13 (Trixie) with Qualcomm WCN6855

## Problem

On a fresh Debian 13 system with a Qualcomm WCN6855 Wi-Fi chip:
- `wlp2s0` interface shows as `unavailable` in NetworkManager (`nmcli dev`)
- `nmcli dev wifi list` returns no networks
- Waybar + wofi dropdown menu does not populate networks

Even though:
- Driver (`ath11k_pci`) is loaded
- Firmware is present
- Radio is enabled

`dmesg` shows:
Failed to set the requested Country regulatory setting
failed to process regulatory info -22

`iw reg get` shows:
global
country 00: DFS-UNSET

---

## Diagnosis Steps

We systematically diagnosed the problem as follows:

1. **NetworkManager configuration**

   Ensured NetworkManager would manage interfaces:

   ```ini
   # /etc/NetworkManager/NetworkManager.conf
   [main]
   plugins=ifupdown,keyfile

   [ifupdown]
   managed=true
    ```

Restart NetworkManager:
sudo systemctl restart NetworkManager

2. **Check device state**
nmcli -f GENERAL.STATE,GENERAL.REASON device show wlp2s0

3. Check interface status
ip link show wlp2s0

4. Check firmware loading
sudo dmesg | grep -i firmware
sudo dmesg | grep ath11k

5. Check regulatory domain
sudo iw reg get

# Packages to Ensure Installed

For a functional Wi-Fi setup on Debian 13:
sudo apt install network-manager firmware-atheros wireless-regdb

Optional:
sudo apt install firmware-linux  # For more up-to-date firmware support

Cause
The driver and firmware were loaded successfully.
The interface was up, and the radio was enabled.
The interface remained unavailable because the kernel could not set a valid country/regulatory domain (world domain 00).
Regulatory mismatch prevents scanning and connecting, which blocks NetworkManager and Waybar/wofi from seeing networks.

## Fix
Set the regulatory domain manually
sudo iw reg set CA

Restart the machine
sudo reboot

Toggle interface if needed
sudo ip link set wlp2s0 down
sudo ip link set wlp2s0 up

Make it persistent (optional)
Edit /etc/default/crda:

REGDOMAIN=CA

Verify

nmcli dev
nmcli dev wifi list

wlp2s0 should now show as disconnected

Networks should appear

Waybar + wofi dropdown will populate

---

It looks like you’ve hit a classic Debian "papercut." Even with the right drivers, the Regulatory Domain acts
as a hard gatekeeper for Wi-Fi scanning. If the kernel doesn't know which country's laws to follow, it
defaults to "World Domain (00)," which often disables active scanning on 5GHz bands to avoid breaking local
laws.

Troubleshooting Qualcomm WCN6855 "Unavailable" on Debian 13

Target Issue: Wi-Fi interface wlp2s0 exists but cannot scan for networks due to regulatory domain mismatches (DFS-UNSET).
1. Initial Verification

Before diving into configuration files, confirm the current state of the hardware and the specific error signature.

    Check Interface Status:
    Bash

    nmcli -f GENERAL.STATE,GENERAL.REASON device show wlp2s0

    If the state is unavailable and the reason is firmware-missing or managed-needed, proceed below.

    Confirm the "Regulatory" Error:
    Run sudo dmesg | grep -E "ath11k|regulatory" and look for:

        Failed to set the requested Country regulatory setting
        failed to process regulatory info -22

2. Dependency Checklist

Debian 13 (Trixie) requires specific packages to bridge the gap between the kernel and the hardware's firmware.
Package	Purpose
network-manager	Handles the connection logic and UI integration.
firmware-atheros	Contains the specific ath11k binaries for the WCN6855.
wireless-regdb	Critical. The database that tells the driver which frequencies are legal.
firmware-linux	(Optional) Meta-package for broader hardware support.

Command to sync:
Bash

sudo apt update && sudo apt install network-manager firmware-atheros wireless-regdb

3. The "Managed" Interface Fix

By default, Debian sometimes leaves interfaces "unmanaged" if they are listed in /etc/network/interfaces. We need NetworkManager to take full control.

    Edit the config: sudo nano /etc/NetworkManager/NetworkManager.conf

    Update the [ifupdown] section:
    Ini, TOML

[ifupdown]
managed=true

Restart the service:
Bash

    sudo systemctl restart NetworkManager

4. Solving the Regulatory Domain (The "Fix")

The WCN6855 driver often fails to initialize scanning if the country code is 00 (World Domain). You must explicitly set your region.
A. Manual Override (Immediate Test)

Set your country code (e.g., US, CA, GB) to unlock the radio:
Bash

sudo iw reg set CA

B. Persistence (The Permanent Fix)

Manual sets are lost on reboot. To make this permanent:

    Install CRDA (if not present): sudo apt install crda

    Edit the config: sudo nano /etc/default/crda

    Set the variable: ```bash
    REGDOMAIN=CA  # Replace CA with your two-letter ISO country code


5. Final Hardware Initialization

After the regulatory domain is set, cycle the interface to force the driver to re-read the environment.
Bash

sudo ip link set wlp2s0 down
sudo ip link set wlp2s0 up

Verification

Run the following to ensure the "Unavailable" status has cleared:

    nmcli dev: Status should now be disconnected (meaning it's ready to connect) or connected.

    nmcli dev wifi list: You should now see a list of nearby Access Points.
