all: slimechunks.S
	gcc -m64 slimechunks.S -o slimechunks
debug: 
	make all
	gdb slimechunks
clean:
	rm -rf slimechunks