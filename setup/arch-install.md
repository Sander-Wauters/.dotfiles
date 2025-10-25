# My Arch system installation

This is an installation guide for **Arch** with an encrypted root partition.

## Keyboard setup

Set the keyboard layout (Belgium `azerty`).

```
loadkeys be-latin1
```

## Disk partition and encryption

Use `lsblk` to list all available disks. Here we use `sda`.

Create the new partitions.

```
fdisk /dev/sda
d <- Repeat this for every partition you want removed.
n <- Create the boot partition (sda1). First sector: default; Last sector: +512M
n <- Create the swap partition (sda2). First sector: default; Last sector: +4G
n <- Create the root partition (sda3). First sector: default; Last sector: default
w <- Save changes.
```

Format the boot partition. When using `UEFI` the boot partition needs to use `FAT32`.

```
mkfs.fat -F 32 /dev/sda1
```

Format the swap partition.

```
mkswap /dev/sda2
```

(Optional) For extra security you can populate the root partition with random data.
Note that this will take a **LONG** time.

```
dd if=/dev/urandom of=/dev/sda3
```

Encrypt the root partition. Choose a good password, you can **NOT** change this later.

```
cryptsetup luksFormat /dev/sda3
```

Decrypt the partition so it can be mounted and we can continue with the installation.

```
cryptsetup open /dev/sda3 root
```

Format the root partition and mount it along with the boot partition.

```
mkfs.btrfs /dev/mapper/root
mount /dev/mapper/root /mnt
mount --mkdir /dev/sda1 /mnt/boot
```

Enable the swap volume.

```
swapon /dev/sda2
```

## Package installation

(Optional) Change the pacman mirror list `/etc/pacman.d/mirrorlist` for better package download speed.
Mirrors at the top of the file get chosen first.

Install the packages needed for the installation.

- base base-devel <- Core packages needed for Arch linux along with essential tools for building and compiling from source.
- linux linux-firmware <- The kernel and firmware.
- grub <- The boot loader.
- networkmanager <- High level network interface manager.
- cryptsetup lvm2 <- Encrypting and decrypting the drives.
- neovim <- Editing files.
- efibootmgr <- Boot manager for UEFI.

```
pacstrap -K /mnt base base-devel linux linux-firmware grub networkmanager cryptsetup lvm2 neovim efibootmgr
```

Generate the fstab file.

```
genfstab -U /mnt >> /mnt/etc/fstab
```

(Optional) When using `btrfs` on the root partition.
You can compress data on the fly by adding an `compress-zstd` option to each of the `btrfs` entries in `/etc/fstab`.
This way data is compressed on the fly, so you can fit much more in your drive.
The only cost being a minor CPU usage increase.
The crypt-device will also have less physical data to encrypt, so the CPU-time needed might actually go down, resulting in higher total disk throughput.

Chroot into the new Arch system. You are now using the actual OS.

```
arch-chroot /mnt
```

## Localization and time zone

Link your current time zone to `/etc/localtime`.
A list of all time zones can be found in `/usr/share/zoneinfo`.

```
ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
```

Syncronize the hardware clock.

```
hwclock --systohc
```

To set the system keyboard layout, add the following to `/etc/vconsole.conf`.

```
KEYMAP=be-latin1
```

Uncomment the locales you desire in `/etc/locale.gen`.

```
en_US.UTF-8 UTF-8
en_US ISO-8859-1
nl_BE.UTF-8 UTF-8
nl_BE ISO-8859-1
```

Generate the selected locales.

```
locale-gen
```

To set your locale systemwide add the following lines to `/etc/locale.conf`.
In this case we set the system language to English and everything else to Dutch Belgium.

```
export LANG=en_US.UTF-8
export LC_MESSAGES="en_US.UTF-8"
export LC_CTYPE="nl_BE.UTF-8"
export LC_COLLATE="nl_BE.UTF-8"
export LC_TIME="nl_BE"
export LC_NUMERIC="nl_BE"
export LC_MONETARY="nl_BE.UTF-8"
export LC_PAPER="nl_BE"
export LC_TELEPHONE="nl_BE"
export LC_ADDRESS="nl_BE"
export LC_MEASUREMENT="nl_BE"
export LC_NAME="nl_BE"
```

## Network settings

Give the computer a device name.
Here we will be naming the device `ws-sw` (Work Station Sander Wauters).

```
echo "ws-sw" > /etc/hostname
```

Add matching entries to hosts in `/etc/hosts`.

```
127.0.0.1 localhost
::1       localhost
127.0.1.1 ws-sw.localdomain ws-sw
```

## Uses and login

Add a root password.

```
passwd
```

Add a new root user with a new home directory. In this case we will be naming the user `sander`.

```
useradd -G wheel -m sander
passwd sander
```

Make wheel user sudoer.

```
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/00-wheel-can-sudo
```

## Drive decryption with password on boot

Add `encrypt lvm2` to `HOOKS` between `block` and `filesystem` in `/etc/mkinicpio.conf`.
Check the config by running.

```
mkinitcpio -p linux
```

Get the UUIDs of the drives and append the output to `/etc/default/grub`.

```
lsblk -f >> /etc/default/grub
```

The only data we need from the appended output is the UUIDs of the root partition (`sda3`) and the mapped partition (`root`).
Append the following to `GRUB_CMDLINE_LINUX_DEFAULT`.

```
cryptdevice=UUID=<your-uuid-for-sda3>:cryptlvm root=UUID=<your-uuid-for-root>
```

Make sure the output from `lsblk -f` is removed or commented.

Install the grub bootloader.

When using BIOS:

```
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

When using UEFI:

```
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
```

## Done

Exit and reboot the system.

```
exit
reboot
```

(Optional) Automatically log on with your user when decrypting the drive on boot.
Add the following to `/etc/systemd/system/getty@tty1.service.d/autologin.conf` (create the directory if it does not exist):

```
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noreset --noclear --autologin sander - ${TERM}
```

