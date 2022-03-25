base="/root/cvm"
BUILDROOT_BUILD="$base/buildroot/build"
linux_dir2="$base/snplinux"
linux_dir="$base/linux"
VMPL0_MEM_SIZE=4096
VMPL2_MEM_SIZE=2048
IP_PLACE_HOLDER="192.168.0.102"
VMPL0_IP="192.168.0.111"
VMPL2_IP="192.168.0.222"
VMPL0="vmpl0"
VMPL2="vmpl2"
MNT0=/mnt/rootfs-$VMPL0
MNT2=/mnt/rootfs-$VMPL2
if [ $# -gt 0 ] ; then
    BUILDROOT_BUILD=$1
fi
if [ $# -gt 1 ] ; then
    linux_dir=$2  
fi


cp $BUILDROOT_BUILD/images/rootfs.ext2 $BUILDROOT_BUILD/images/rootfs-$VMPL0.ext2

mkdir $MNT0
umount $MNT0
mount $BUILDROOT_BUILD/images/rootfs-$VMPL0.ext2 $MNT0
cp $linux_dir/$VMPL2/arch/x86/boot/bzImage $MNT0/bzImage
#cp $linux_dir/$VMPL2/vmlinux $MNT0/vmlinux
#cp $linux_dir2/$VMPL2/arch/x86/boot/bzImage $MNT0/bzImage2
cp $BUILDROOT_BUILD/build/qboot-*/build/bios.bin $MNT0/usr/share/qemu/qboot.bin
cp S60linux2 $MNT0/etc/init.d/S60linux2
cp qemu.sh $MNT0/usr/bin/qemu.sh
echo "
PermitRootLogin yes
PermitEmptyPasswords yes
PasswordAuthentication yes
" >> $MNT0/etc/ssh/sshd_config
sed -i 's/'$IP_PLACE_HOLDER'/'$VMPL0_IP/'g' $MNT0/etc/init.d/S40network
#sh mkramdisk.sh $MNT0
umount $MNT0
qemu-img convert -O vhdx $BUILDROOT_BUILD/images/rootfs-$VMPL0.ext2 $BUILDROOT_BUILD/images/rootfs-$VMPL0.vhdx


cp $BUILDROOT_BUILD/images/rootfs.ext2 $BUILDROOT_BUILD/images/rootfs-$VMPL2.ext2
mkdir $MNT2
umount $MNT2
mount $BUILDROOT_BUILD/images/rootfs-$VMPL2.ext2 $MNT2
rm -r $MNT2/usr/share/qemu
rm -r $MNT2/usr/bin/qemu*
sed -i 's/'$IP_PLACE_HOLDER'/'$VMPL2_IP/'g' $MNT2/etc/init.d/S40network
echo "
PermitRootLogin yes
PermitEmptyPasswords yes
PasswordAuthentication yes
" >> $MNT2/etc/ssh/sshd_config
umount $MNT2
qemu-img convert -O vhdx $BUILDROOT_BUILD/images/rootfs-$VMPL2.ext2 $BUILDROOT_BUILD/images/rootfs-$VMPL2.vhdx
