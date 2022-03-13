qemu-system-x86_64 -m 1024m -smp cores=`nproc` \
	--trace "fw_cfg_*" -mmio-fw_cfg \
        -cpu qemu64,rdrand,xlevel=0x8000001f,hv-vpindex,hv-synic,hv-time,hv-ipi,hv-tlbflush \
        -mem-path /dev/kvm -L /usr/share/qemu/pc-bios -bios $2 \
    -drive format=raw,file=/dev/sdb,if=virtio \
    --nographic --no-reboot -kernel $1 \
    --enable-kvm -append "debug console=ttyS0 root=/dev/vda rw" \
    -nic tap,model=virtio-net-pci,ifname=tap0,script=no,downscript=no,vhost=on \
    -device vmbus-bridge
        #-object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1,policy=0x5 \
        #-machine memory-encryption=sev0  \
