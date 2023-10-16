#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <unistd.h>

sem_t sE,sG;


// Función que genera una espera aleatoria
void random_wait(){
  int min_wait=0;
  int max_wait=500000;
  srand(time(NULL)); // Randomiza
  int sleep_time = (rand() % (max_wait - min_wait + 1)) + min_wait; //Obtiene un numero al azar entre minimo y maximo
  usleep(sleep_time); //Hace esperar al hilo
}

//Función para simular la ejecución de procesos y imprimirlos en salida standar
void execute_process(char name){
  //random_wait();
  printf("%c \n", name);
}

void* lA (void * x){
  execute_process('A');
  pthread_exit(NULL);
  return 0;
}

void* lB (void * x){
  execute_process('B');
  execute_process('D');
  sem_wait(&sE);
  execute_process('F');
  sem_wait(&sG);
  execute_process('Q');
  execute_process('I');
  execute_process('L');
  execute_process('N');
  execute_process('O');
  return 0;
}

void* lC (void * x){
  execute_process('C');
  execute_process('E');
  sem_post(&sE);
  pthread_exit(NULL);
  return 0;
}

void* lH (void * x){
  execute_process('H');
  sem_wait(&sE);
  execute_process('G');
  sem_post(&sG);
  pthread_exit(NULL);
  return 0;
}


int main(){
  sem_init(&sE, 0, 0);
  sem_init(&sG, 0, 0);
  pthread_t t1,t2,t3,t4;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_create(&t1, &attr, lA, NULL);
  pthread_create(&t2, &attr, lB, NULL);
  pthread_create(&t3, &attr, lC, NULL);
  pthread_create(&t4, &attr, lH, NULL);

  pthread_join(t1, NULL);
  pthread_join(t2, NULL);
  pthread_join(t3, NULL);
  pthread_join(t4, NULL);

  return 0;
}