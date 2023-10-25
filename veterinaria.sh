#!/bin/bash

function volver_al_menu(){
  read -p "Presione cualquier tecla para volver al menú "
} 

function validar_cedula(){
 if $(cat socios.txt | grep -q $cedula); then
    echo "La cédula $cedula ya está registrada"
    volver_al_menu
    return
  fi
}  

function registrar_socio(){

  echo "==================================" 
  
  
  read -p "Ingrese cédula del dueño: " cedula
  validar_cedula "$cedula"
  temp_socio="$cedula," 
  
  read -p "Ingrese nombre del dueño: " nombre_d
  temp_socio="$temp_socio$nombre_d," 
  
	 echo "==================================" 
  for ((i = 1; i < 4; i++)); do
    
    read -p "Ingrese nombre de la mascota: " nombre_m
    temp_socio="$temp_socio$nombre_m," 
    read -p "Ingrese edad de la mascota: " edad_m
    temp_socio="$temp_socio$edad_m," 
    
    if [ $i -lt 4 ]; then
      read -p "¿Quiere registrar otra mascota? [s/n] " resp
      resp=$(echo "$resp" | tr '[:upper:]' '[:lower:]')
      if [ "$resp" = "s" ] || [ "$resp" = "si" ] || [ "$resp" = "sí" ] || [ "$resp" = "yes" ] || [ "$resp" = "y" ];then
	 echo "==================================" 
	else
          for ((j = 4; j > i; j--)); do
	    temp_socio+="NULL,NULL,"
	  done
	  break
      fi
    fi

  done

	 echo "==================================" 
  read -p "Ingrese opción de contacto (email o teléfono): " contacto
  temp_socio="$temp_socio$contacto" 

	 echo "==================================" 
  echo "$temp_socio" | tee -a socios.txt
  volver_al_menu

}

function salir() {
 echo "Saliendo del programa."
 exit 0
}        

function main() {
  while true; do
    clear
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
	salir
       ;;
      q)
	salir
	;;
      *)
        echo "Opción no válida. Por favor, seleccione una opción válida."
        ;;
    esac
  done
}

clear
main

