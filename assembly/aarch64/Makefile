all: slimechunks.S
	aarch64-none-elf-as -c slimechunks.S -o slimechunks.o
	aarch64-none-elf-gcc -T linker.ld -o slimechunks.elf -ffreestanding -nostdlib slimechunks.o -lgcc
	aarch64-none-elf-objcopy slimechunks.elf -O binary kernel8.img
debug: 
	make all
	qemu-system-aarch64 -M raspi3 -kernel kernel8.img
clean:
	rm -rf *.elf *.o *.img