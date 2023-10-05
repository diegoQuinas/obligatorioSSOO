#!/bin/bash

# Función para verificar si la cédula del socio ya existe en el archivo socios.txt
function verificar_cedula_existente() {
  local cedula="$1"
  if grep -q "^$cedula," socios.txt; then
    return 0 # La cédula ya existe
  else
    return 1 # La cédula no existe
  fi
}

# Función para registrar un nuevo socio en socios.txt
function registrar_socio() {
  local nombre_dueno="$1"
  local cedula="$2"
  local nombre_mascota="$3"
  local edad_mascota="$4"
  local contacto="$5"

  if verificar_cedula_existente "$cedula"; then
    echo "La cédula ya existe en el sistema."
  else
    # Obtener el siguiente número disponible para el socio
    local numero_socio=$(( $(cut -d ',' -f 1 socios.txt | sort -n | tail -n 1) + 1 ))
    echo "$numero_socio,$nombre_dueno,$cedula,$nombre_mascota,$edad_mascota,$contacto" >> socios.txt
    echo "Socio registrado con éxito."
  fi
}

# Función para agendar una nueva cita en citas.txt
function agendar_cita() {
  # Implementar esta función
}

# Función para actualizar el stock de artículos en articulos.txt
function actualizar_stock() {
  # Implementar esta función
}

# Función para realizar la venta de productos
function realizar_venta() {
  # Implementar esta función
}

# Función para generar un informe mensual
function generar_informe_mensual() {
  # Implementar esta función
}

# Función principal del programa
function main() {
  while true; do
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
        # Llamar a la función registrar_socio
        ;;
      2)
        # Llamar a la función agendar_cita
        ;;
      3)
        # Llamar a la función actualizar_stock
        ;;
      4)
        # Llamar a la función realizar_venta
        ;;
      5)
        # Llamar a la función generar_informe_mensual
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

# Llamar a la función principal
main

