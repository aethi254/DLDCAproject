nasm -f elf64 -g tower-of-hanoi.asm -o tower-of-hanoi.o
ld -g tower-of-hanoi.o -o tower-of-hanoi