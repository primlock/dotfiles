# Optimizing Power Consumption on T14

These are the steps I took to configure the power settings on this T14 G5.

## CPU Power Management
The most impactful tool is amd-pstate, which should already be active on kernel 6.12. Verify with:
```bash
~
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver
amd-pstate-epp
```

You want to see `amd-pstate-epp`. If you see just `amd-pstate` or `acpi-cpufreq`, add this to your kernel cmdline in `/etc/default/grub`:
```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_pstate=active"
```

Then run `sudo update-grub`.

Once `amd-pstate-epp` is active, set the energy preference for all cores on battery:
```bash
$ echo power_saver | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
```

>Note: This change does not persist a reboot. You must apply the energy preference with TLP under the
>`CPU_ENERGY_PREF_POLICY_ON_BAT`.

To check the valid options for `energy_performance_preference`, you can use this command:
```bash
$ cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_available_preferences
```

## TLP
TLP is the easiest way to automate AC vs. battery profiles:
```bash
$ sudo apt install tlp tlp-rdw
$ sudo systemctl enable --now tlp
```

The defaults are solid, but edit /etc/tlp.conf and make sure these are set:
```bash
CPU_ENERGY_PERF_POLICY_ON_BAT=power
CPU_SCALING_GOVERNOR_ON_BAT=powersave
PLATFORM_PROFILE_ON_BAT=low-power
PLATFORM_PROFILE_ON_AC=performance

# Preserve battery health (charge to 80%, start charging at 75%)
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
```

After editing, apply with `sudo tlp start`.

## powertop
Run this to get a sense of what's drawing power and auto-tune tunables:
```bash
$ sudo apt install powertop
$ sudo powertop --auto-tune
```
It is ideal for extending laptop battery life but must be reapplied after every reboot. It is run using sudo
`powertop --auto-tune` and can be automated via systemd.  Be cautious with `--auto-tune` in isolation — it can
occasionally cause USB devices to become unresponsive (wake-on-USB is a common culprit). Check sudo powertop
interactively first and look at the "Tunables" tab to see what's marked "Bad".

`sudo powertop --auto-tune` can disable WiFi when power saving settings are applied. You can bring it back up
by getting the name of the Wifi Device:
```bash
~
$ nmcli dev
DEVICE    TYPE      STATE                   CONNECTION
lo        loopback  connected (externally)  lo
enp1s0f0  ethernet  unavailable             --
wlp2s0    wifi      unavailable             --
```

Then making sure the interface is unblocked by `rfkill`:
```bash
$ sudo rfkill unblock all
```

And then bringing the `ip link` back up:
```bash
$ sudo ip link set wlp2s0 up
```

## IRQ Balance & Graphics
For the integrated AMD GPU, the amdgpu driver handles runtime power management automatically, but verify it's
on:

```bash
$ cat /sys/bus/pci/devices/0000:*/power/control
```

You want to see `auto` not `on`. If any show on, TLP's `RUNTIME_PM_ON_BAT=auto` setting will fix this.
