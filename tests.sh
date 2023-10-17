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


save_bad_output() {
  echo "=====================" >> "$bad_output_file"
  echo "$1" >> "$bad_output_file"
  echo "=====================" >> "$bad_output_file"
}

check_output(){
  bad_output=false
  # Verificar que D nunca va antes de B ni E antes de C ni G antes de H
  if grep -q 'D.*B\|E.*C\|G.*H' <<< "$output" || grep -q 'F.*D\|F.*E\|G.*E\|G.*H' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que Q nunca va antes de F o G
  if grep -q 'Q.*F\|Q.*G' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que I, J, y K nunca van antes de Q
  if grep -q 'I.*Q\|J.*Q\|K.*Q' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que L nunca va antes de I
  if grep -q 'L.*I' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que M nunca va antes de I o J
  if grep -q 'M.*I\|M.*J' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que N nunca va antes de L
  if grep -q 'N.*L' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que O nunca va antes de P
  if grep -q 'O.*P' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Verificar que P nunca va antes de M
  if grep -q 'P.*M' <<< "$output"; then
    bad_output=true # Bandera para indicar que esta mal el output
  fi

  # Si se encontraron errores, mostrar un mensaje
  if $bad_output; then
    save_bad_output $output
    echo "Orden incorrecto. Se ha guardado en $bad_output_file."
  else
    echo "Orden correcto."
  fi
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


