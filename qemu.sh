qemu-system-x86_64 -m 2048m -smp cores=`nproc` \
	--no-acpi \
	--trace "fw_cfg_*" -mmio-fw_cfg \
        -cpu qemu64 \
        -mem-path /dev/kvm -L /usr/share/qemu/pc-bios -bios $2 \
    --nographic --no-reboot -kernel $1 \
    --enable-kvm -append "panic=-1 debug console=ttySEV0 root=/dev/ram0 rw rodata=off" \
    -nic tap,model=virtio-net-pci,ifname=tap0,script=no,downscript=no,vhost=on \
    -device vmbus-bridge
        #-object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1,policy=0x5 \
        #-machine memory-encryption=sev0  \
