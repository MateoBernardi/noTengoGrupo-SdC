# SISTEMAS DE COMPUTACIÓN  
## TRABAJO PRÁCTICO 2

**Grupo:** NoTengoGrupo.exe  

**Alumnos:**  
- Bernardi Mateo 
- Regñicoli Gustavo  
- Schreiner Federico  

**Docentes:**  
- Miguel Angel Solinas  
- Javier Alejandro Jorge  

**Año:** 2026  

---

## Introducción

En el presente trabajo práctico se propone la implementación de una arquitectura en capas para calcular y mostrar el índice GINI de un país, utilizando datos provistos por la API del Banco Mundial.   

Este trabajo tiene como finalidad no solo resolver un problema de recolección y visualización de datos, sino también utilizar técnicas de bajo nivel, explorando cómo un lenguaje de alto nivel puede convocar funciones de bajo nivel usando el stack como medio de comunicación de parámetros y retorno de resultados, respetando la convención ABI del sistema.

---

## Desarrollo

### Capa Superior – Python

La capa superior es responsable de la recolección de datos del índice GINI desde el siguiente endpoint REST del Banco Mundial:

https://api.worldbank.org/v2/en/country/all/indicator/SI.POV.GINI?format=json&date=2011:2020&per_page=32500&page=1&country="Argentina"

Se utiliza la biblioteca `requests` para consultar el API y recuperar los datos en formato JSON. Esta capa se encarga de parsear el resultado, obtener los valores del índice GINI (en `float`) y transferirlos a la capa intermedia (C) para su procesamiento.

---

### Capa Intermedia – C

La capa intermedia actúa como puente entre el script en Python y el programa en ensamblador. Su responsabilidad es:

- Recibir datos tipo `float` (simulados o desde Python).  
- Invocar la función en ensamblador, utilizando la convención de llamadas ABI (System V x86-64).  
- Mostrar o devolver el resultado procesado (índice convertido a entero y aumentado en +1).  

La función declarada en C es:

```c
extern int procesar_gini_via_stack(float valor);

Llamada por el programa principal, recorre un arreglo de índices y guarda los resultados retornados por el programa en ASM.

En este entorno, se respeta la convención de llamada estándar:

- Los parámetros `float` son pasados en el registro `xmm0`.  
- El valor de retorno `int` se devuelve por `eax`.  
- El stack se usa implícitamente para guardar el frame, dirección de retorno y `rbp`, cumpliendo así el uso del stack como mecanismo de paso de información entre capas.  

---

### Capa Baja – Ensamblador

La capa de bajo nivel se implementa en ensamblador (NASM) para arquitectura x86-64. La función se encarga de:

- Recibir un valor `float` desde `xmm0` (por convención).  
- Convertir el `float` a `int` truncado (sin redondeo).  
- Sumar 1.  
- Devolver el resultado en `eax`.  

Esta rutina es llamada desde el programa en C utilizando la convención estándar de llamada, lo que implica que aunque no se manipule el stack manualmente, sí se utiliza para mantener el contexto de ejecución.

---

## Compilación

Para compilar el proyecto es necesario realizarlo en varias etapas, generando los archivos objeto y finalmente una librería compartida.

A continuación se explican cada una de las líneas de compilación utilizadas:

nasm -f elf64 suma.asm -o procesar_via_stack.o

Compila el archivo de ensamblador suma_uno_v2.asm usando NASM.
El flag -f elf64 indica que el formato de salida es ELF de 64 bits (compatible con Linux x86_64).
El archivo de salida procesar_gini_via_stack.o es un objeto intermedio que contiene la función en ASM compilada.

gcc -c connect_py_with_asm.c -o procesar_gini.o

Compila el archivo en C sin vincularlo (-c), generando un archivo objeto (procesar_gini.o).
Este archivo contiene la función principal en C que llama al ensamblador.

gcc -shared -o converter.so procesar_gini.o procesar_via_stack.o

Crea una librería compartida (.so), llamada converter.so, combinando:

El objeto en C (procesar_gini.o)
El objeto en ASM (procesar_gini_via_stack.o)

## Pruebas de Uso

Las pruebas se realizaron a través de la consola, resultando la siguiente salida:

<img width="950" height="261" alt="Image" src="https://github.com/user-attachments/assets/6c8761a4-aeb2-461c-8984-59d941396889" />

---

## Conclusión

Se logró cumplir con los objetivos propuestos en la consigna:

- Se implementó una arquitectura en capas utilizando Python, C y ASM.  
- Se utilizaron las convenciones de llamada del sistema para pasar parámetros y obtener resultados entre C y ensamblador.  
- Se utilizó el stack como mecanismo de soporte de la ejecución, respetando el ABI x86-64.  
- Se validó la comunicación entre capas y el procesamiento correcto de los datos.    
