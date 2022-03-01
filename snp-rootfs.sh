BUILDROOT_BUILD="/root/cvm/buildroot-artifact/build-tpm"
snplinux_dir="/root/cvm/snplinux"
VMPL0_MEM_SIZE=4096
VMPL2_MEM_SIZE=1024
IP_PLACE_HOLDER="192.168.0.102"
VMPL0_IP="192.168.0.111"
VMPL2_IP="192.168.0.222"
VMPL2="vmpl2"
VMPL0="vmpl0"
cp $BUILDROOT_BUILD/images/rootfs.ext2 $BUILDROOT_BUILD/images/rootfs-vmpl0.ext2
mkdir /mnt/rootfs-vmpl0
umount /mnt/rootfs-vmpl0
mount $BUILDROOT_BUILD/images/rootfs-vmpl0.ext2 /mnt/rootfs-vmpl0
cp $snplinux_dir/$VMPL2/arch/x86/boot/bzImage /mnt/rootfs-vmpl0/
echo "
PermitRootLogin yes
PermitEmptyPasswords yes
PasswordAuthentication yes
" >> /mnt/rootfs-vmpl0/etc/ssh/sshd_config

sed -i 's/'$IP_PLACE_HOLDER'/'$VMPL0_IP/'g' /mnt/rootfs-vmpl0/etc/init.d/S40network
umount /mnt/rootfs-vmpl0
qemu-img convert -O vhdx $BUILDROOT_BUILD/images/rootfs-vmpl0.ext2 $BUILDROOT_BUILD/images/rootfs-vmpl0.vhdx

cp $BUILDROOT_BUILD/images/rootfs.ext2 $BUILDROOT_BUILD/images/rootfs-vmpl2.ext2
mkdir /mnt/rootfs-vmpl2
umount /mnt/rootfs-vmpl2
mount $BUILDROOT_BUILD/images/rootfs-vmpl2.ext2 /mnt/rootfs-vmpl2
rm -r /mnt/rootfs-vmpl2/usr/share/qemu
rm -r /mnt/rootfs-vmpl2/usr/bin/qemu*
sed -i 's/'$IP_PLACE_HOLDER'/'$VMPL2_IP/'g' /mnt/rootfs-vmpl2/etc/init.d/S40network
echo "
PermitRootLogin yes
PermitEmptyPasswords yes
PasswordAuthentication yes
" >> /mnt/rootfs-vmpl2/etc/ssh/sshd_config
umount /mnt/rootfs-vmpl2
qemu-img convert -O vhdx $BUILDROOT_BUILD/images/rootfs-vmpl2.ext2 $BUILDROOT_BUILD/images/rootfs-vmpl2.vhdx
