#!/bin/bash

# Verificar si se pasaron los argumentos necesarios
if [ $# -ne 8 ]; then
  echo "Uso: $0 <nombre_vm> <tipo_os> <cpus> <memoria_ram> <memoria_vram> <tamano_disco> <controlador_sata> <controlador_ide>"
  echo "Ejemplo: $0 MiVM Linux 2 2048 128 20G SATAController IDEController"
  exit 1
fi

# Asignar argumentos a variables
NOMBRE_VM=$1
TIPO_OS=$2
CPUS=$3
MEMORIA_RAM=$4
MEMORIA_VRAM=$5
DISCO=$6
CONTROLADOR_SATA=$7
CONTROLADOR_IDE=$8

# Crear la máquina virtual
VBoxManage createvm --name "$NOMBRE_VM" --ostype "$TIPO_OS" --register

# Configurar la máquina virtual
VBoxManage modifyvm "$NOMBRE_VM" --cpus "$CPUS" --memory "$MEMORIA_RAM" --vram "$MEMORIA_VRAM" --nic1 nat

# Crear el disco duro virtual
VBoxManage createmedium disk --filename "$NOMBRE_VM.vdi" --size $(($DISCO * 1024)) --format VDI

# Crear y asociar el controlador SATA
VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_SATA" --add sata --controller IntelAhci
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_SATA" --port 0 --device 0 --type hdd --medium "$NOMBRE_VM.vdi"

# Crear y asociar el controlador IDE
VBoxManage storagectl "$NOMBRE_VM" --name "$CONTROLADOR_IDE" --add ide
VBoxManage storageattach "$NOMBRE_VM" --storagectl "$CONTROLADOR_IDE" --port 0 --device 0 --type dvddrive --medium emptydrive

# Imprimir la configuración final de la máquina virtual
VBoxManage showvminfo "$NOMBRE_VM"
