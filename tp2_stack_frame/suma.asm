global procesar_gini_via_stack

section .text
procesar_gini_via_stack:
    ; xmm0 ya contiene el float que viene desde C

    ; Convertir float a int truncado
    cvttss2si eax, xmm0

    ; Sumar 1
    add eax, 1

    ret

section .note.GNU-stack noalloc noexec nowrite progbits