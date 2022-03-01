TPM_DIR=/tmp/tpm2
SOCK_FILE=$TMP_DIR/swtpm-sock
rm -r $TPM_DIR
mkdir $TPM_DIR
swtpm socket --tpmstate dir=$TPM_DIR --tpm2 \
  --ctrl type=unixio,path=$SOCK_FILE \
  --log level=20 &> swtpm.log &
qemu-system-x86_64 -m 1024m -smp cores=`nproc` \
    -mem-path /dev/kvm -L /usr/share/qemu/pc-bios -bios bios-microvm.bin \
    -drive format=raw,file=/dev/sdb,if=virtio \
    --nographic --no-reboot -kernel /bzImage \
    --enable-kvm -append "debug console=ttyS0 root=/dev/vda rw" \
    -nic tap,model=virtio-net-pci,ifname=tap0,script=no,downscript=no,vhost=on \
    -chardev socket,id=chrtpm,path=$SOCK_FILE \
    -tpmdev emulator,id=tpm0,chardev=chrtpm \
    -device tpm-tis,tpmdev=tpm0
