# Slimechunk Finder in Assembly
Small Slimechunk Finder in x64 Assembly that can reach speeds up to 1 billion seeds in 10 seconds.

## Compiling
`gcc -m64 slimechunks.S && gdb a.out`

## Debugging
To run it in the GDB shell, type 'r'. 
Pause using Ctrl + C.
Check the amount of seeds ran through using `i r rdi`. 
Quit GDB using `q`

#### NOT OPTIMIZED - SINGLETHREADED - GOALLESS
