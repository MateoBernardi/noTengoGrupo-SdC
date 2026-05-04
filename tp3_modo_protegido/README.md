## Informe del Trabajo Práctico
[Informe TP3 ](<./tp3 - SdC-1.pdf>)

### Compilar y ejecutar "Hello World"
```bash
cd tp3_modo_protegido/edk2
. edksetup.sh
build --platform=UefiPkg/UefiPkg.dsc --module=UefiPkg/HelloWorld/HelloWorld.inf --arch=X64 --buildtarget=RELEASE --tagname=GCC
cp Build/UefiLessonsPkg/RELEASE_GCC/X64/HelloWorld.efi ~/UEFI_disk/
qemu-system-x86_64 -drive if=pflash,format=raw,file=Build/OvmfX64/RELEASE_GCC/FV/OVMF.fd \
                   -drive format=raw,file=fat:rw:~/UEFI_disk \
                   -nographic \
                   -net none
```

<img width="1095" height="423" alt="Image" src="https://github.com/user-attachments/assets/ba36acee-460b-4a3a-aa48-a7a8fe75d1eb" />
