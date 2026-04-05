#!/usr/bin/env bash
# ============================================================
# Getac S410 G4 — Touchpad Physical Button Fix
# Fixes ELAN0700 misdetected as clickpad on Kubuntu/Ubuntu
# ============================================================

set -e

QUIRKS_DIR="/etc/libinput"
QUIRKS_FILE="$QUIRKS_DIR/local-overrides.quirks"
QUIRKS_CONTENT='[Getac S410 Touchpad]
MatchName=ELAN0700:00 093A:0274 Touchpad
ModelTouchpadButtonAreas=1'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=================================================${NC}"
echo -e "${CYAN}  Getac S410 G4 - Touchpad Button Fix${NC}"
echo -e "${CYAN}=================================================${NC}"
echo ""

# ── Step 1: Check libinput is installed ──────────────────────
echo -e "${YELLOW}[1/4] Checking libinput...${NC}"
if ! command -v libinput &>/dev/null; then
    echo -e "  libinput not found. Installing..."
    sudo apt-get install -y libinput-tools
else
    echo -e "  ${GREEN}libinput found.${NC}"
fi

# ── Step 2: Diagnose current state ───────────────────────────
echo ""
echo -e "${YELLOW}[2/4] Checking for clickpad misdetection...${NC}"
if libinput list-devices 2>/dev/null | grep -q "kernel bug: missing right button"; then
    echo -e "  ${RED}Confirmed: ELAN0700 is being misdetected as a clickpad.${NC}"
else
    echo -e "  ${GREEN}No clickpad misdetection detected — fix may already be applied.${NC}"
    echo -e "  Continuing anyway to ensure the quirk file is in place..."
fi

# ── Step 3: Write the quirks file ────────────────────────────
echo ""
echo -e "${YELLOW}[3/4] Writing libinput quirks override...${NC}"

sudo mkdir -p "$QUIRKS_DIR"

if [ -f "$QUIRKS_FILE" ]; then
    echo -e "  Backing up existing file to ${QUIRKS_FILE}.bak"
    sudo cp "$QUIRKS_FILE" "${QUIRKS_FILE}.bak"
fi

echo "$QUIRKS_CONTENT" | sudo tee "$QUIRKS_FILE" > /dev/null
echo -e "  ${GREEN}Written: $QUIRKS_FILE${NC}"
echo ""
echo "  Contents:"
echo "  ─────────────────────────────────────────"
sed 's/^/  /' "$QUIRKS_FILE"
echo "  ─────────────────────────────────────────"

# ── Step 4: Prompt to reboot ─────────────────────────────────
echo ""
echo -e "${YELLOW}[4/4] Reboot required${NC}"
echo -e "  The fix will take effect after a reboot."
echo ""
read -rp "  Reboot now? [y/N]: " REBOOT_NOW
if [[ "$REBOOT_NOW" =~ ^[Yy]$ ]]; then
    echo -e "  ${CYAN}Rebooting...${NC}"
    sudo reboot
else
    echo -e "  ${GREEN}Skipping reboot. Run 'sudo reboot' when ready.${NC}"
fi

echo ""
echo -e "${GREEN}Done. After reboot, verify with: libinput list-devices${NC}"
echo -e "${CYAN}  The 'clickpad' warning for ELAN0700 should be gone.${NC}"
