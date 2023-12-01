#!/bin/bash

function volver_al_menu(){
  read -p "Presione cualquier tecla para volver al menú "
  menu
} 

function validar_cedula(){

while IFS=, read -r cedula_registrada nombre resto; do
  if [[ " $cedula_registrada " =~ " $1 " ]]; then
    echo "El cliente $nombre con la cédula $cedula_registrada ya está registrado"
    return 1 
  fi
done < "socios.txt"

}  

function registrar_socio(){
  
  touch socios.txt
  echo "==================================" 
  
  
  read -p "Ingrese cédula del dueño: " cedula
  cedula_a_validar="$cedula"
  temp_socio="$cedula," 
  validar_cedula "$cedula_a_validar"
  valido=$?
  if [ "$valido" -eq 1 ]; then # Si retorna 1 entonces hay una cédula duplicada
    volver_al_menu
  fi
  
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






function agendar_cita(){
  touch citas.txt # Crea el archivo si no existe
  
  echo "Agendar una nueva cita:"
  read -p "Ingrese cédula del dueño: " cedula_dueno # Cambia 'cedula_dueño' por 'cedula_dueno'
  read -p "Ingrese nombre de la mascota: " nombre_mascota
  echo "Motivos de la cita (por ejemplo: revisión, vacunación, etc.):"
  read -p "Ingrese motivo de la cita: " motivo_cita
  read -p "Ingrese costo de la cita: " costo_cita

  while true; do
    read -p "Ingrese fecha de la cita (formato AAAA-MM-DD): " fecha_cita
    if [[ $fecha_cita =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      break
    else
      echo "Fecha no válida. Por favor, use el formato AAAA-MM-DD."
    fi
  done

  while true; do
    read -p "Ingrese hora de la cita (formato HH:MM): " hora_cita
    if [[ $hora_cita =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
      break
    else
      echo "Hora no válida. Por favor, use el formato HH:MM."
    fi
  done

  cita="$cedula_dueño,$nombre_mascota,$motivo_cita,$costo_cita,$fecha_cita,$hora_cita"
  echo "$cita" | tee -a citas.txt
  echo "Cita agendada con éxito."
  volver_al_menu
}











function actualizar_stock(){
  touch articulos.txt # Crea el archivo si no existe
  
  echo "Actualizar Stock en Tienda:"
  read -p "Ingrese categoría del artículo (ej. medicamentos, accesorios): " categoria
  read -p "Ingrese código del artículo: " codigo
  read -p "Ingrese nombre del artículo: " nombre
  read -p "Ingrese precio del artículo: " precio
  read -p "Ingrese cantidad a agregar al stock: " cantidad

  # Verifica si el artículo ya existe
  articulo_encontrado=false
  while IFS=, read -r cat cod nom pre cant; do
    if [ "$codigo" = "$cod" ]; then
      # Actualizar la cantidad y marcar que el artículo fue encontrado
      nueva_cantidad=$((cant + cantidad))
      sed -i "/$cod/d" articulos.txt
      echo "$categoria,$codigo,$nombre,$precio,$nueva_cantidad" | tee -a articulos.txt
      articulo_encontrado=true
      echo "Stock actualizado para el artículo: $nombre."
      break
    fi
  done < articulos.txt

  # Si el artículo no existe, agregarlo nuevo
  if [ "$articulo_encontrado" = false ]; then
    echo "$categoria,$codigo,$nombre,$precio,$cantidad" | tee -a articulos.txt
    echo "Nuevo artículo agregado: $nombre."
  fi

  volver_al_menu
}











function realizar_venta(){
  touch articulos.txt # Crea el archivo si no existe
  touch ventas.txt # Para registrar las ventas

  echo "Realizar venta de productos:"
  read -p "Ingrese código del artículo a comprar: " codigo_compra
  read -p "Ingrese cantidad a comprar: " cantidad_compra

  articulo_encontrado=false
  while IFS=, read -r categoria codigo nombre precio cantidad; do
    if [ "$codigo" = "$codigo_compra" ]; then
      articulo_encontrado=true
      if [ "$cantidad" -lt "$cantidad_compra" ]; then
        echo "Stock insuficiente. Solo hay $cantidad unidades disponibles."
      else
        nueva_cantidad=$((cantidad - cantidad_compra))
        sed -i "/$codigo/d" articulos.txt
        echo "$categoria,$codigo,$nombre,$precio,$nueva_cantidad" | tee -a articulos.txt
        total_venta=$(echo "$precio * $cantidad_compra" | bc)
        echo "Venta realizada: $nombre, Cantidad: $cantidad_compra, Total: \$${total_venta}"
        echo "$(date +%Y-%m-%d),$codigo,$nombre,$cantidad_compra,\$${total_venta}" | tee -a ventas.txt
      fi
      break
    fi
  done < articulos.txt

  if [ "$articulo_encontrado" = false ]; then
    echo "Artículo no encontrado."
  fi

  volver_al_menu
}










function generar_informe_mensual(){
  touch ventas.txt # Asegúrate de que el archivo exista

  echo "Generar Informe Mensual:"
  read -p "Ingrese el año y mes para el informe (formato AAAA-MM): " mes_informe

  total_mes=0
  cantidad_ventas=0

  while IFS=, read -r fecha codigo nombre cantidad total; do
    if [[ $fecha == $mes_informe-* ]]; then
      cantidad_ventas=$((cantidad_ventas + 1))
      # Extrae el monto total de la venta y lo acumula
      monto_venta=$(echo $total | tr -d '$')
      total_mes=$(echo "$total_mes + $monto_venta" | bc)
    fi
  done < ventas.txt

  if [ "$cantidad_ventas" -eq 0 ]; then
    echo "No se encontraron ventas para $mes_informe."
  else
    echo "Informe del mes $mes_informe:"
    echo "Ventas totales: $cantidad_ventas"
    echo "Total recaudado: \$${total_mes}"
  fi

  volver_al_menu
}















function salir() {
 echo "Saliendo del programa."
 exit 0
}        

function menu() {
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
	agendar_cita
        ;;
      3)
	actualizar_stock
        ;;
      4)
        realizar_venta
        ;;
      5)
        generar_informe_mensual
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

function main(){
menu
}

clear
main

