#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Auxiliary function to count the number of lines in the file
int numLines(FILE *f);

// Convert int representing octal into normal binary
char octToBin(int i);

// Read information from config.txt
void readTable(char *table);

int main(){
  printf("010 = %d", octToBin(10000000));
}

void readTable(char *type, char *states, char **table){
  FILE *file;
  file = fopen("config.txt", "r");

  int lines = numLines(file);

  int num = 0;
  fscanf(file, "%o", &num);
  *type = octToBin(num);
  fscanf(file, "%o", &num);
  *states = octToBin(num);

}

char octToBin(int i){
  return ((i >> 11) & 1)*4 + ((i >> 7) & 1)*2 + ((i >> 3) & 1);
}
