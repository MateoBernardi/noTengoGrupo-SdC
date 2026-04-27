.code16
.global _start

_start:
    cli                         # Desactivar interrupciones
    lgdt gdt_descriptor         # Cargar la GDT

    # Pasar a Modo Protegido (setear bit PE en CR0)
    mov %cr0, %eax
    or $1, %eax
    mov %eax, %cr0

    # Salto largo (Far Jump) para cargar CS con el selector de código (0x08)
    ljmp $0x08, $protected_mode

.code32
protected_mode:
    # 5. Cargar registros de segmento de datos con el selector 0x10
    mov $0x10, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    # INTENTO DE ESCRITURA EN SEGMENTO DE SOLO LECTURA
    # Esto provocará un General Protection Fault (#GP)
    movl $0xDEADBEEF, (0x0)

hang:
    jmp hang

# --- Estructura de la GDT ---
.align 4
gdt_start:
    .quad 0x0000000000000000    # Descriptor Nulo (obligatorio)

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

