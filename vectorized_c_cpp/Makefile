all: slimechunks.S
	clang slimechunks.c -o slimechunks -O3
debug: 
	make all
	gdb slimechunks
run: 
	make all
	./slimechunks
clean:
	rm -rf slimechunks