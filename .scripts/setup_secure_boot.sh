#!/usr/bin/env bash

#
# Arch Linux Secure Boot setup script (GRUB + Shim).
# Based on: https://blog.azurezeng.com/arch-linux-grub-sb-with-font-and-some-optimization
#
# !!! CAUTION !!!
# Incorrect configuration of UUIDs or prefix paths will break the boot process.
# Please review and modify all 'CAUTION' sections within the script before running.
#

set -e # Exit on error

# ==========================================
# Configuration (CAUTION: Review and modify as needed)
# ==========================================
SB_DIR="/etc/secureboot"
KEYPAIR_PATH="$SB_DIR/keys"
EFI_DIR="/efi" 
ARCH_EFI_DIR="$EFI_DIR/EFI/arch"
GRUB_STUB_DIR="$SB_DIR/grub-sb-stub"
MOK_SUBJ="/CN=My Arch Linux Machine Owner Key/"
ARCH_KERNEL_PACKAGES=("linux-lts" "linux-zen") # Change this to your kernel in use
GRUB_DEV_UUID="5682-B92F" # Set to your GRUB partition UUID

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: the script must be run as root." 
   exit 1
fi

# Check for required packages
REQUIRED_CMDS=("sbsign" "sbverify" "mokutil" "grub-mkimage" "grub-probe" "efibootmgr" "openssl")
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: Required package '$cmd' is not installed."
        exit 1
    fi
done

if [ ! -f /usr/share/shim-signed/shimx64.efi ]; then
    echo "Error: 'shim-signed' package is not installed."
    echo "Please install it from AUR before running this script."
    exit 1
fi

echo "=== Arch Linux Secure Boot (GRUB) ==="

# ==========================================
# 1. Generate MOK Key Pair
# ==========================================
echo "-> 1. Generating MOK key pair..."
mkdir -p "$KEYPAIR_PATH"

if [ -f "$KEYPAIR_PATH/MOK.key" ]; then
    echo "   The MOK key pair already exists. Skipping generation."
else
    openssl req -newkey rsa:4096 -nodes -keyout "$KEYPAIR_PATH/MOK.key" \
        -new -x509 -sha256 -days 3650 \
        -subj "$MOK_SUBJ" -out "$KEYPAIR_PATH/MOK.crt"
    openssl x509 -outform DER -in "$KEYPAIR_PATH/MOK.crt" -out "$KEYPAIR_PATH/MOK.cer"
    echo "  Key pair generated at $KEYPAIR_PATH."
fi

# ==========================================
# 2. Create mok_sign.sh Helper Script
# ==========================================
echo "-> 2. Creating mok_sign.sh helper script..."
mkdir -p "$SB_DIR/libs"
cat > "$SB_DIR/libs/mok_sign.sh" <<EOF
mok_sign() {
    KEYPAIR_PATH='$KEYPAIR_PATH'
    # sign if not already done so.
    if ! /usr/bin/sbverify --list "\$1" 2>/dev/null | /usr/bin/grep -q "signature certificates"; then
        printf 'Signing %s...\n' "\$1"
        /usr/bin/sbsign --key "\$KEYPAIR_PATH/MOK.key" --cert "\$KEYPAIR_PATH/MOK.crt" --output "\$1" "\$1"
    else
        printf 'Skip sign: %s\n' "\$1"
    fi
}
EOF

# ==========================================
# 3. Prepare GRUB MemDisk
# ==========================================
echo "-> 3. Preparing GRUB MemDisk ..."
mkdir -p "$GRUB_STUB_DIR/memdisk/fonts"

# Copy unicode font
if [ -f /usr/share/grub/unicode.pf2 ]; then
    cp /usr/share/grub/unicode.pf2 "$GRUB_STUB_DIR/memdisk/fonts/"
else
    echo "Warning: no /usr/share/grub/unicode.pf2 found，GRUB GUI may lack fonts."
fi

cd "$GRUB_STUB_DIR"
tar -cf memdisk.tar -C memdisk .
cd - > /dev/null

# ==========================================
# 4. Generate grub-pre.cfg
# ==========================================
echo "-> 4. Generating grub-pre.cfg..."

# CAUTION: Check the search.fs_uuid line and prefix path to match your setup.
cat > "$GRUB_STUB_DIR/grub-pre.cfg" <<EOF
insmod part_msdos
insmod part_gpt
insmod font

loadfont /fonts/unicode.pf2

search.fs_uuid $GRUB_DEV_UUID root hd0,gpt2

set prefix=(\$root)/grub
configfile (\$prefix)/grub.cfg
EOF

# ==========================================
# 5. Create update-sb-grub-efi.sh
# ==========================================
echo "-> 5. Creating update-sb-grub-efi.sh..."

# Copy sbat.csv
cp /usr/share/grub/sbat.csv "$SB_DIR/grub-sbat.csv"

cat > "$SB_DIR/update-sb-grub-efi.sh" <<EOF
#! /bin/bash
set -u

BASIC_MODULES="all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat
 font gettext gfxmenu gfxterm gfxterm_background gzio halt help hfsplus iso9660 jpeg 
 keystatus loadenv loopback linux ls lsefi lsefimmap lsefisystab lssal memdisk minicmd
 normal ntfs part_apple part_msdos part_gpt password_pbkdf2 png probe read reboot regexp
 search search_fs_uuid search_fs_file search_label sleep smbios squash4 test true video videoinfo
 xfs zfs zstd zfscrypt zfsinfo cpuid play tpm usb tar"

GRUB_MODULES="$BASIC_MODULES cryptodisk crypto gcry_arcfour gcry_blowfish gcry_camellia
 gcry_cast5 gcry_crc gcry_des gcry_dsa gcry_idea gcry_md4 gcry_md5 gcry_rfc2268 gcry_rijndael
 gcry_rmd160 gcry_rsa gcry_seed gcry_serpent gcry_sha1 gcry_sha256 gcry_sha512 gcry_tiger 
 gcry_twofish gcry_whirlpool luks lvm mdraid09 mdraid1x raid5rec raid6rec"

SCRIPT_PATH="$(dirname "$(realpath $0)")"

grub-mkimage -c "$SCRIPT_PATH/grub-sb-stub/grub-pre.cfg" \
    -o $EFI_DIR/EFI/arch/grubx64.efi -O x86_64-efi \
    --sbat "$SCRIPT_PATH/grub-sbat.csv" \
    -m "$SCRIPT_PATH/grub-sb-stub/memdisk.tar" \
    $GRUB_MODULES

source "$(dirname "$0")/libs/mok_sign.sh"

mok_sign $EFI_DIR/EFI/arch/grubx64.efi
EOF

chmod +x "$SB_DIR/update-sb-grub-efi.sh"

# ==========================================
# 6. Configure mkinitcpio Kernel Signing Hook
# ==========================================
echo "-> 6. Configuring mkinitcpio kernel signing hook..."
mkdir -p /etc/initcpio/post
cat > "/etc/initcpio/post/kernel-sbsign" <<EOF
#!/usr/bin/env bash

kernel="\$1"
[[ -n "\$kernel" ]] || exit 0

# use already installed kernel if it exists
[[ ! -f "\$KERNELDESTINATION" ]] || kernel="\$KERNELDESTINATION"

keypairs=($KEYPAIR_PATH/MOK.key $KEYPAIR_PATH/MOK.crt)

for (( i=0; i<\${#keypairs[@]}; i+=2 )); do
    key="\${keypairs[\$i]}" cert="\${keypairs[(( i + 1 ))]}"
    if ! sbverify --cert "\$cert" "\$kernel" &>/dev/null; then
        sbsign --key "\$key" --cert "\$cert" --output "\$kernel" "\$kernel"
    fi
done
EOF
chmod +x /etc/initcpio/post/kernel-sbsign

# ==========================================
# 7. Configure Pacman Hooks
# ==========================================
echo "-> 7. Configuring Pacman hooks..."
mkdir -p /etc/pacman.d/hooks

# Hook 1: Update GRUB EFI
cat > /etc/pacman.d/hooks/1-update-grub-efi.hook <<EOF
[Trigger]
Operation=Install
Operation=Upgrade
Type=Package
Target=grub

[Action]
Description=Update GRUB UEFI binaries
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c '$SB_DIR/update-sb-grub-efi.sh'
EOF

# Hook 2: Update GRUB Config
if ! command -v update-grub &> /dev/null; then
    echo "   Creating update-grub command..."
    cat > /usr/local/bin/update-grub <<'EOG'
#!/bin/sh
set -e
exec grub-mkconfig -o /boot/grub/grub.cfg "$@"
EOG
    chmod +x /usr/local/bin/update-grub
fi

cat > /etc/pacman.d/hooks/999-update-grub-cfg.hook <<EOF
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=grub
Target=linux
Target=linux-lts
Target=linux-zen
Target=linux-hardened

[Action]
Description=Update GRUB configuration file
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c '/usr/bin/update-grub'
Depends=grub
EOF

# ==========================================
# 8. Initial GRUB Generation and Kernel Signing
# ==========================================
echo "-> 8. Generating and signing initial GRUB EFI binary..."

"$SB_DIR/update-sb-grub-efi.sh"

echo "  Regenerating initramfs and signing installed kernels..."
for kernel_pkg in "${ARCH_KERNEL_PACKAGES[@]}"; do
    pacman -S "$kernel_pkg"
done


# ==========================================
# 9. Deploy Shim Bootloader 
# ==========================================
echo "-> 9. Deploy Shim Bootloader..."
mkdir -p "$ARCH_EFI_DIR/keys"
cp "$KEYPAIR_PATH/MOK.cer" "$ARCH_EFI_DIR/keys/"
cp /usr/share/shim-signed/mmx64.efi "$ARCH_EFI_DIR/"
cp /usr/share/shim-signed/shimx64.efi "$ARCH_EFI_DIR/"

# ==========================================
# 10. Add UEFI Boot Entry
# ==========================================
echo "-> 10. Adding UEFI boot entry..."
# EFI_DEV_SOURCE=$(findmnt -n -o SOURCE "$EFI_DIR")
EFI_DEV_SOURCE=$(findmnt -nvo SOURCE "$EFI_DIR" | sed 's/\[.*\]//')
if [ -z "$EFI_DEV_SOURCE" ]; then
    echo "Error: Unable to determine the EFI partition device."
else
    DISK_PATH="/dev/$(lsblk -no pkname "$EFI_DEV_SOURCE" | head -n1 | xargs)"
    PART_NUM=$(lsblk -no partn "$EFI_DEV_SOURCE" | xargs)
    
    echo "  Detected EFI partition on disk: $DISK_PATH, partition number: $PART_NUM"
    
    # efibootmgr -B -L "arch-shim" &> /dev/null || true

    efibootmgr --unicode --disk "$DISK_PATH" --part "$PART_NUM" \
        --create --label "arch-shim" --loader /EFI/arch/shimx64.efi
fi

echo "=========================================="
echo "Setup complete! Next steps:"
echo "1. Reboot your computer and enter BIOS."
echo "2. Enable Secure Boot."
echo "3. Select the 'arch-shim' boot entry to boot."
echo "4. In the blue MOK management screen, select 'Enroll MOK'."
echo "5. Import the key to Machine Owner Key database."
echo "=========================================="
