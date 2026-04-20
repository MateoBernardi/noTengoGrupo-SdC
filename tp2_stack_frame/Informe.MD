# SISTEMAS DE COMPUTACION
## TRABAJO PRACTICO 2

**Grupo:** NoTengoGrupo.exe

**Alumnos:**
- Bernardi Mateo
- Regnicoli Gustavo
- Schreiner Federico

**Docentes:**
- Miguel Angel Solinas
- Javier Alejandro Jorge

**Ano:** 2026

---

## Introduccion

En el presente trabajo practico se propone la implementacion de una arquitectura en capas para calcular y mostrar el indice GINI de un pais, utilizando datos provistos por la API del Banco Mundial.

Este trabajo tiene como finalidad no solo resolver un problema de recoleccion y visualizacion de datos, sino tambien aplicar tecnicas de bajo nivel. En particular, se explora como un lenguaje de alto nivel puede invocar funciones de bajo nivel utilizando el stack como medio de comunicacion de parametros y retorno de resultados, respetando la convencion ABI del sistema.

---

## Desarrollo

### Capa Superior - Python

La capa superior es responsable de la recoleccion de datos del indice GINI desde el siguiente endpoint REST del Banco Mundial:

`https://api.worldbank.org/v2/en/country/all/indicator/SI.POV.GINI?format=json&date=2011:2020&per_page=32500&page=1&country=%22Argentina%22`

Se utiliza la biblioteca `requests` para consultar la API y recuperar los datos en formato JSON. Esta capa se encarga de parsear el resultado, obtener los valores del indice GINI (en `float`) y transferirlos a la capa intermedia (C) para su procesamiento.

---

### Capa Intermedia - C

La capa intermedia actua como puente entre el script en Python y el programa en ensamblador. Sus responsabilidades son:

- Recibir datos de tipo `float` (simulados o desde Python).
- Invocar la funcion en ensamblador, utilizando la convencion de llamadas ABI (System V x86-64).
- Devolver el resultado procesado (indice convertido a entero y aumentado en +1).

La funcion declarada en C es:

```c
extern int procesar_gini_via_stack(float valor);
```

La funcion expuesta a Python es:

```c
int process_gini(float valor)
{
	return procesar_gini_via_stack(valor);
}
```

En este entorno, se respeta la convencion de llamada estandar:

- Los parametros `float` se pasan en el registro `xmm0`.
- El valor de retorno `int` se devuelve en `eax`.
- El stack se usa implicitamente para guardar el frame, la direccion de retorno y `rbp`, cumpliendo asi su rol como mecanismo de paso de informacion entre capas.

---

### Capa Baja - Ensamblador

La capa de bajo nivel se implementa en ensamblador (NASM) para arquitectura x86-64. La funcion se encarga de:

- Recibir un valor `float` desde `xmm0` (por convencion).
- Convertir el `float` a `int` truncado (sin redondeo).
- Sumar 1.
- Devolver el resultado en `eax`.

Esta rutina es llamada desde el programa en C utilizando la convencion estandar de llamada. Aunque no se manipule el stack de forma manual en el codigo ASM, el stack igualmente se utiliza para mantener el contexto de ejecucion.

---

## Compilacion

Para compilar el proyecto es necesario hacerlo en varias etapas, generando archivos objeto y finalmente una libreria compartida.

Comandos utilizados:

```bash
nasm -f elf64 suma.asm -o procesar_via_stack.o
gcc -c connect_py_with_asm.c -o procesar_gini.o
gcc -shared -o converter.so procesar_gini.o procesar_via_stack.o
```

Descripcion de cada etapa:

- `nasm -f elf64 suma.asm -o procesar_via_stack.o`: compila el archivo de ensamblador `suma.asm` con formato ELF de 64 bits, generando el objeto ASM.
- `gcc -c connect_py_with_asm.c -o procesar_gini.o`: compila el archivo C sin enlazar (`-c`) y genera el objeto intermedio C.
- `gcc -shared -o converter.so procesar_gini.o procesar_via_stack.o`: enlaza ambos objetos y crea la libreria compartida `converter.so`.

## Pruebas de Uso

Las pruebas se realizaron desde consola y se obtuvo la siguiente salida:

<img width="950" height="261" alt="Salida por consola" src="https://github.com/user-attachments/assets/6c8761a4-aeb2-461c-8984-59d941396889" />

---

## Conclusion

Se cumplieron los objetivos propuestos en la consigna:

- Se implemento una arquitectura en capas utilizando Python, C y ASM.
- Se utilizaron las convenciones de llamada del sistema para pasar parametros y obtener resultados entre C y ensamblador.
- Se utilizo el stack como mecanismo de soporte de la ejecucion, respetando el ABI x86-64.
- Se valido la comunicacion entre capas y el procesamiento correcto de los datos.
