#!/bin/bash

# Nombre del archivo de salida
output="salida.txt"
bad_output_file="salidas_incorrectas.txt"

# Número de veces que se ejecutará el programa
if [ $# -eq 0 ]; then
  num_executions=50
else
  num_executions="$1"
fi


check_output(){
  # Verificar que D nunca va antes de B ni E antes de C ni G antes de H
  cat "$output" | grep --color=always 'D.*B\|E.*C\|G.*H' 
  cat "$output" | grep --color=always 'F.*D\|F.*E\|G.*E\|G.*H' 
  cat "$output" | grep --color=always 'Q.*F\|Q.*G' 
  cat "$output" | grep --color=always 'I.*Q\|J.*Q\|K.*Q'
  cat "$output" | grep --color=always 'L.*I' 
  cat "$output" | grep --color=always 'M.*I\|M.*J'
  cat "$output" | grep --color=always 'N.*L'
  cat "$output" | grep --color=always 'O.*P' 
  cat "$output" | grep --color=always 'P.*M'
}

# Compila el programa
gcc -pthread -o ejercicio2 ejercicio2.c

# Verifica si la compilación tuvo éxito
if [ $? -eq 0 ]; then
  echo "Compilación exitosa."

  # Bucle para ejecutar el programa 200 veces
  for ((i = 1; i <= $num_executions; i++)); do
    # Ejecuta el programa y guarda la salida estándar en el archivo
    ./ejercicio2 > $output

    echo "============================="
    # Verifica si la ejecución tuvo éxito
    if [ $? -eq 0 ]; then
      echo "Ejecución $i"
      # Verifica el orden de las letras en el archivo de salida
      check_output 
      
    else
      echo "Error en la ejecución $i."
    fi
  done

  # Realiza verificaciones adicionales en el archivo de salida aquí

else
  echo "Error de compilación."
fi


