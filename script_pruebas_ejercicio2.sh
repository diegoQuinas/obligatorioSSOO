 #!/bin/bash

# Nombre del archivo de salida
output="salida.txt"
bad_results_file="casos_fallidos.txt"
echo "Batería de pruebas corrida el $(date)" > "$bad_results_file"
# Número d veces que se ejecutará el programa
if [ $# -eq 0 ]; then
  num_executions=50
else
  num_executions="$1"
fi


check_output(){
  
  temp_output="temp.txt"

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
    ((failed_cases++))
    echo "===========================" >> "$bad_results_file"
    cat "$temp_output" >> "$bad_results_file"
    echo -e "RESULTADO \e[31mFALLIDO\e[0m" | tee -a "$bad_results_file"
    echo "===========================" >> "$bad_results_file"
    rm "$temp_output"
    return 1
  else
    echo -e "\e[34m$(cat $output)\e[0m"
    echo -e "RESULTADO \e[32mOK\e[0m"
    rm "$temp_output"
    return 0
  fi

}

# Compila el programa
gcc -pthread -o ejercicio2 ejercicio2.c

# Verifica si la compilación tuvo éxito
if [ $? -eq 0 ]; then
  echo "Compilación exitosa."
  failed_cases=0
  # Bucle para ejecutar el programa 200 veces
  for ((i = 1; i <= $num_executions; i++)); do
    # Ejecuta el programa y guarda la salida estándar en el archivo
    ./ejercicio2 > $output
    echo "============================="
    # Verifica si la ejecución tuvo éxito
    if [ $? -eq 0 ]; then
      echo "Ejecución $i"
      check_output 
    else
      echo "Error en la ejecución $i."
    fi
    echo "============================="
  done
   
  if [ "$failed_cases" -eq 0 ]; then
    echo "Todas las $num_executions ejecuciones salieron en el órden correcto"
  else
    echo "Fallaron $failed_cases casos. Estan en el archivo $bad_results_file"
  fi
  rm "$output" 
 
else
  echo "Error de compilación."
fi


