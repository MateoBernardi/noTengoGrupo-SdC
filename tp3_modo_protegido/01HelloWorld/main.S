.code16
.global _start

_start:
    cli                         # Desactivar interrupciones para inicializar
    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %ss
    mov $0x7c00, %sp            # Definir un stack seguro
    sti

    mov $msg, %si
    mov $0x0e, %ah              # Función Teletype del BIOS

loop:
    lodsb                       # Carga AL con [DS:SI] e incrementa SI
    cmp $0, %al                 # ¿Es el fin de la cadena?
    je halt
    int $0x10                   # Imprimir caracter
    jmp loop

halt:
    hlt
    jmp halt

.align 2                        # Asegura que los datos no tengan basura de alineación
msg:
    .asciz "Hello World"    
