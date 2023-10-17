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
  
  temp_output="$(mktemp)"

  cat "$output" | grep --color=always 'D.*B\|E.*C\|G.*H' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'F.*D\|F.*E\|G.*E\|G.*H' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'Q.*F\|Q.*G' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'I.*Q\|J.*Q\|K.*Q' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'L.*I' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'M.*I\|M.*J' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'N.*L' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'O.*P' | tee -a "$temp_output"
  cat "$output" | grep --color=always 'P.*M' | tee -a "$temp_output"
  if [ -s "$temp_output" ]; then
    echo -e "RESULTADO \e[31mFALLIDO\e[0m"
    return 1
    rm "$temp_output"
  else
    echo -e "RESULTADO \e[32mOK\e[0m"
  fi

  rm "$temp_output"
}

# Compila el programa
gcc -pthread -o ejercicio2 ejercicio2.c

# Verifica si la compilación tuvo éxito
if [ $? -eq 0 ]; then
  echo "Compilación exitosa."
  temp_failed_cases="$(mktemp)"

  # Bucle para ejecutar el programa 200 veces
  for ((i = 1; i <= $num_executions; i++)); do
    # Ejecuta el programa y guarda la salida estándar en el archivo
    ./ejercicio2 > $output
    echo "============================="
    # Verifica si la ejecución tuvo éxito
    if [ $? -eq 0 ]; then
      echo "Ejecución $i"
      echo -e "\e[34m$(cat $output)\e[0m"
      check_output 
      if [ $? -eq 1 ]; then
        echo "$i" >> temp_failed_cases
      fi
    else
      echo "Error en la ejecución $i."
    fi
    echo "============================="
  done
  
  if [ -s "$temp_failed_cases" ]; then
    echo "Fallaron los casos $temp_failed_cases"
  else
    echo "Todas las $num_executions ejecuciones salieron en el órden correcto"
  fi
 
else
  echo "Error de compilación."
fi


