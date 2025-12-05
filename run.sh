#!/bin/bash
set -e # Arrête le script si une commande échoue

# Nettoyage
rm -f *.bin *.o

# Compilation
nasm -f bin boot.asm -o boot.bin
nasm -f elf kernel_entry.asm -o kernel_entry.o
gcc -ffreestanding -m32 -fno-pie -c kernel.c -o kernel.o

# Linker (Entry point d'abord !)
ld -m elf_i386 -o kernel.bin -Ttext 0x1000 --oformat binary kernel_entry.o kernel.o

# Création image
cat boot.bin kernel.bin > os-image.bin

# Lancement
echo "Lancement de l'OS..."
qemu-system-x86_64 -drive format=raw,file=os-image.bin