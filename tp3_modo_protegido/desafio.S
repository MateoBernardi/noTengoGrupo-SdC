.code16
.global _start

_start:
    cli                         # Desactivamos interrupciones
    lgdt gdt_descriptor        

    # con esto pasamos a modo protegido
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0
    ljmp $0x08, $protected_mode

.code32
protected_mode:
    # Con esto cargamos los registros de segmento de datos con el selector 0x10
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    # intentamos escriturar en segmeto de solo lectura, provoca un GP
    movl $0xDEADBEEF, (0x0)

hang:
    jmp hang

# --- Estructura de la GDT ---
.align 4
gdt_start:
    .quad 0x0000000000000000    # Descriptor Nulo 

    # Selector 0x08: Código (Base 0, Límite 4GB, Ejec/Lect, Granularidad 4KB)
    # Access byte: 0x9A (10011010b)
    .word 0xffff, 0x0000, 0x9a00, 0x00cf

    # Selector 0x10: Datos (Base 0, Límite 4GB, SOLO LECTURA, Granularidad 4KB)
    # Access byte: 0x90 (10010000b) -> Bit de escritura en 0
    .word 0xffff, 0x0000, 0x9000, 0x00cf
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1
    .long gdt_start

