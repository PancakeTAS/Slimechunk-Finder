rm rom -r
rm *.img
rm *.EFI
rm *.vdi
mkdir build
make
cp emptydisk.empty build/os.img
cd build
losetup -o 1048576 --sizelimit 8388608 -f os.img
mkdir rom
mount /dev/loop0 rom

mkdir -p rom/EFI/BOOT
cp ../BOOTX64.EFI rom/EFI/BOOT/

umount rom
losetup -D
rm rom -r

cd ..
mv build/os.img ./os.img
qemu-system-x86_64 --bios ovmf/bios.bin -net none -monitor stdio -machine q35 -hda os.img
rm build -r
rm *.o
rm *.EFI
rm *.img