INITRD=qemu/initrd-run.img
KERNEL=qemu/vmlinuz-run
IMAGE=qemu/debian11-arm64.img
MOUNT=/home/impervguin/Projects/Machine-dependent-languages/Task12

.Phony : runqemu
runqemu :
	qemu-system-aarch64 -machine virt -cpu cortex-a72 -nographic -smp 1 -m 512 -kernel $(KERNEL) -initrd $(INITRD) -append "root=/dev/sda2 console=ttyAMA0" -global virtio-blk-device.scsi=off -device virtio-scsi-device,id=scsi -drive file=$(IMAGE),id=rootimg,cache=unsafe,if=none -device scsi-hd,drive=rootimg -virtfs local,path=$(MOUNT),mount_tag=host0,security_model=none,id=host0debian11-arm64.img

main.exe : main.c
	gcc $^ -o $@