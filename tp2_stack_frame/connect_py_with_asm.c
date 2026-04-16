#include <stdio.h>

// Declaración de la función en assembler
extern int procesar_gini_via_stack(float valor);

int process_gini(float valor)
{
    return procesar_gini_via_stack(valor);
}