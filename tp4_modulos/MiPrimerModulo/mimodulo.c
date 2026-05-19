#include <linux/module.h>
#include <linux/kernel.h>
MODULE_LICENSE("GPL");
MODULE_AUTHOR("NoTengoGrupo");
MODULE_DESCRIPTION("Un módulo de ejemplo para Linux");

int modulo_lin_init(void) {
    printk(KERN_INFO "Hola, este es nuestro primer módulo de Linux!\n");
    return 0; // Indica que el módulo se cargó correctamente
}

void modulo_lin_clean(void) {
    printk(KERN_INFO "Adiós, ese fue nuestro primer módulo de Linux!\n");
}

module_init(modulo_lin_init);
module_exit(modulo_lin_clean);

