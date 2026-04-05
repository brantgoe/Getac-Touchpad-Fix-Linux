# Getac Touchpad Fix for Linux

## Goal
Diagnose and fix touchpad issues on a Getac device running Linux. This was written after I had to apply a fix to my Getac s410g4
## Device Info
- Device: Getac (S410G4)
- OS: Linux (distro/version TBD)

## Problem Description
Pointer is able to be moved and user is able to click by tapping but not with physical buttions
## Investigation

### Hardware ID
```
# Run: lsusb / lspci to identify touchpad hardware
```

### Kernel / Driver Info
```
# Run: dmesg | grep -i touch
# Run: xinput list
# Run: libinput list-devices
```

## Attempted Fixes
Updating, installing synaptic drives 

## Solution
Applying a fix that changes how the click is logged to the OS.
