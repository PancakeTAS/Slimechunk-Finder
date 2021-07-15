all: slimechunks.c
	clang slimechunks.c -o slimechunks -pthread -O3
debug:
	make all
	gdb slimechunks
run:
	make all
	./slimechunks
clean:
	rm -rf slimechunks
