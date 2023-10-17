#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <unistd.h>

sem_t sE,sG, sP, sI;


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
  random_wait();
  printf("%c", name);
}

void* lA (void * x){
  execute_process('A');
  pthread_exit(NULL);
  return 0;
}


void* lJ (void * x) {
  // Implementa las operaciones necesarias para 'J'
  execute_process('J');
  sem_wait(&sI);
  execute_process('M');
  execute_process('P');
  sem_post(&sP);
  return 0;
}

void* lk (void * x) {
  execute_process('K');
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
  pthread_t t5, t6;
  pthread_create(&t5, NULL, lJ, NULL);
  pthread_create(&t6, NULL, lk, NULL);
  execute_process('I');
  sem_post(&sI);
  execute_process('L');
  execute_process('N');
  execute_process('O');
  return 0;
}
void* lC (void * x){
  execute_process('C');
  execute_process('E');
  sem_post(&sE);
  sem_post(&sE);
  return 0;
}

void* lH (void * x){
  execute_process('H');
  sem_wait(&sE);
  execute_process('G');
  sem_post(&sG);
  return 0;
}


int main(){
  sem_init(&sE, 0, 0);
  sem_init(&sG, 0, 0);
  sem_init(&sP, 0, 0);
  sem_init(&sI, 0, 0);
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

  sem_destroy(&sE);
  sem_destroy(&sG);
  sem_destroy(&sP);
  sem_destroy(&sI);

  return 0;
}
