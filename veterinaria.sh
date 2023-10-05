#!/bin/bash

function validar_cedula(){
  if [ -z $(cat socios.txt | grep $1) ] ; then
    return 0
  else
    return 1
  fi
}

function registrar_socio(){
  if ! [ -e "socios.txt" ]; then
     touch socios.txt
  fi
  read -p "Ingrese nombre del dueño: " nombre_duenio
  read -p "Ingrese cédula del dueño: " cedula_a_validar
  read -p "¿Cuántas mascotas va a registrar? " nro_mascotas
  while [ "$nro_mascotas" -gt 4 ] || [ "$nro_mascotas" -lt 1 ]; do
  read -p "Se debe registrar al menos una mascota y un máximo de cuatro mascotas: "
  done
  datos="$nombre_duenio,$cedula_a_validar"
  for ((i = 1; i < $nro_mascotas; i++)); do
      read -p "Ingrese nombre de la mascota: " nombre_mascota
      read -p "Ingrese edad de la mascota: " edad_mascota
      datos="$datos,$nombre_mascota,$edad_mascota"
  done
  read -p "Ingrese nombre de la mascota: " nombre_mascota
  read -p "Ingrese edad de la mascota: " edad_mascota
  read -p "Ingrese opción de contacto (email o teléfono): " contacto

  

  if validar_cedula "$cedula_a_validar" -eq 1; then
    datos="$datos,$contacto"
    echo "$datos" >> socios.txt
    echo "Se registro el socio"
    sleep 2
    return 0
  else 
    echo "El socio con la cédula $cedula_a_validar ya esta registrado"
    sleep 2
    return 1
  fi
}

function main() {
  while true; do
    # clear
    echo "Menú:"
    echo "1. Registrar socio"
    echo "2. Agendar cita"
    echo "3. Actualizar stock en tienda"
    echo "4. Venta de productos"
    echo "5. Informe mensual"
    echo "6. Salir"
    read -p "Seleccione una opción: " opcion
   

    case $opcion in
      1)
        registrar_socio
        
        ;;
      2)
        # Llamar a la función agendar_cita
        echo "1"
        ;;
      3)
        # Llamar a la función actualizar_stock
        echo "1"
        ;;
      4)
        # Llamar a la función realizar_venta
        echo "1"
        ;;
      5)
        # Llamar a la función generar_informe_mensual
        echo "1"
        ;;
      6)
        echo "Saliendo del programa."
        exit 0
        ;;
      *)
        echo "Opción no válida. Por favor, seleccione una opción válida."
        ;;
    esac
  done
}

clear
main

