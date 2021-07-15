all: slimechunks.rs
	rustc slimechunks.rs -o slimechunks -O
debug:
	make all
	gdb slimechunks
run:
	make all
	./slimechunks
clean:
	rm -rf slimechunks
