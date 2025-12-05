org 0X7C00 ; Boot sector starts at memory address 0x7C00


jmp start

gdtStart :
    dd 0x0
    dd 0x0
gdtCode :
    dw 0xFFFF ; limite
    dw 0x0 ; base low
    db 0x00 ; base middle
    db 10011010b ; acces
    db 11001111b ; granularity
    db 0x00 ; base high

gdtData :
    dw 0xFFFF ; limite
    dw 0x0 ; base low
    db 0x00 ; base middle   
    db 10010010b ; acces
    db 11001111b ; granularity
    db 0x00 ; base high
gdtEnd :

gdtDescriptor :
    dw gdtEnd - gdtStart - 1 ; taille de la GDT
    dd gdtStart ; adresse de la GDT

CODE_SEG equ gdtCode - gdtStart
DATA_SEG equ gdtData - gdtStart

start : 

    mov ah, 0x0e
    mov al, '1'
    int 0x10
    mov ah, 0x0
;AVANT DE PASSER EN 32 BITS ON DOIT CHARGER L'OS DANS LA RAM
    mov ah, 0x02 ; fonction de lecture des secteurs
    mov al, 9 ; nombre de secteurs à lire
    mov ch, 0 ; cylindre 0
    mov cl, 2 ; secteur 2 (le secteur 1 est le bootloader
    mov dh, 0 ; tête 0
    mov bx, 0X100
    mov es, bx
    mov bx, 0x0000 ;
    mov dl,dl
    int 0x13 
    jc disk_error

    mov ah, 0x0e
    mov al, '2'
    int 0x10
    ;

    cli ; on désactive les interruptions

    lgdt [gdtDescriptor] ; on charge la structure de la GDT (on est en flat model)
    mov eax, cr0
    or eax , 1
    mov cr0, eax 
    jmp CODE_SEG:init_32bit

[bits 32]
init_32bit : 
    mov ax, DATA_SEG

    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp
    mov ecx, msg

    
    jmp 0x1000






msg : db "Hello, World!;",0


print_string :
    push ebp            ; Sauvegarde de l'ancre
    mov ebp, esp        ; Nouvelle ancre
    pusha  

    xor eax, eax
    ; --- CODE ---
    startAddr equ 0xB8000
    mov eax, [ebp+8] ; Récupère l'offset du string
    mov ebx, [ebp+12] ; Récupère la longueur du
    mov ecx,80
    mul ecx
    add eax, ebx
    mov ecx,2
    mul ecx
    
    add eax, startAddr
    mov dl, [ebp+16] ;
    mov byte[eax], dl; Caractère
    mov byte[eax+1], 0x0F 

    xor eax, eax
    popa                ; Restauration des registres
    mov esp, ebp        ; Nettoyage du cadre
    pop ebp             ; Restauration de l'ancre
    ret   




disk_error :
    mov ah, 0x0e
    mov al, 'E'
    int 0x10
    
    jmp end

end :
    jmp end
    times 510-($-$$) db 0 ; le boot secotr doit faire 512 octets
    dw 0xAA55 