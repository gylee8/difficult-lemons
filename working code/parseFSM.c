#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Auxiliary function to count the number of lines in the file
int numLines(FILE *f);

// Read information from config.txt
void readTable(char *type, char *states);


int main(){
  // char **table;
  char *type = (char *) malloc(8);
  char *states = (char *) malloc(8);
  readTable(type, states);
  printf("type: %d, states: %d\n", *type, *states);
}

void readTable(char *type, char *states){
  FILE *file;
  file = fopen("config.txt", "r");

  // int lines = numLines(file);

  int num = 0;
  fscanf(file, "%d", type);   // Value: {0, 1}
  fscanf(file, "%d", states); // Value: {2, 3, 4}

  fclose(file);
}

int numLines(FILE *f){
  int count = 0;
  char c;

  for(c = fgetc(f); c != EOF; c = fgetc(f)){
    if(c == '\n')
      count++;
  }
  rewind(f);
  return count;
}
