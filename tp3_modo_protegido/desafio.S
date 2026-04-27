# desafio.S
.code16
.global _start
_start:
    cli                         # Desactiva interrupciones [cite: 499, 507]
    lgdt gdt_descriptor         # Carga la GDT [cite: 500, 514]

    mov %cr0, %eax              # Activa el bit PE (bit 0) de CR0 [cite: 501, 515, 516]
    or $0x1, %eax
    mov %eax, %cr0              # Aquí entramos técnicamente a modo protegido [cite: 517, 518]

    ljmp $0x08, $protected_mode # Salto largo para cargar el selector de código (0x08) [cite: 502, 521]

.code32
protected_mode:
    mov $0x10, %ax              # Carga el selector de datos (0x10) [cite: 550]
    mov %ax, %ds                # Actualiza registros de segmento [cite: 551, 552]
    
    # INTENTO DE ESCRITURA: Esto causará un General Protection Fault (#GP)
    # porque el segmento 0x10 está definido como solo lectura (0x90).
    movl $0xDEADBEEF, (0x0)     # Intenta escribir en el offset 0 [cite: 637, 669]

hang:
    jmp hang

# Definición de la GDT [cite: 523, 601, 608]
gdt_start:
    .quad 0                     # Descriptor nulo [cite: 523, 617]
gdt_code:                       # Selector 0x08: Base 0, Límite 4GB, Ejec/Lect [cite: 601, 620]
    .word 0xffff, 0x0000, 0x9a00, 0x00cf 
gdt_data:                       # Selector 0x10: Solo Lectura (byte de acceso 0x90) [cite: 615, 632]
    .word 0xffff, 0x0000, 0x9000, 0x00cf 
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1
    .long gdt_start
