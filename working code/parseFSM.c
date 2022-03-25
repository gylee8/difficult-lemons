#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Auxiliary function to count the number of lines in the file
int numLines(FILE *f);

// Read information from config.txt
void readTable(char *type, char *states, char *table);


int main(){
  char *table = (char *) malloc(sizeof(char) * 4);
  char *type = (char *) malloc(sizeof(char));
  char *states = (char *) malloc(sizeof(char));
  readTable(type, states, table);
  printf("type: %d, states: %d\n", *type, *states);
  int i = 0;
  // printf("table: ");
  for(i = 0; i<4; i++){
    printf("table element %d in %p: %d\n", i, table + i*sizeof(char), *(table + i*sizeof(char)));
  }
}

void readTable(char *type, char *states, char *table){
  FILE *file;
  file = fopen("config.txt", "r");

  // int lines = numLines(file);

  int num = 0;
  fscanf(file, "%d", type);   // Value: {0, 1}
  fscanf(file, "%d", states); // Value: {2, 3, 4}

  char c;
  int i = 0;
  while(fscanf(file, "%d", &c) == 1){
    // printf("read in: %d\n", c);
    *(table + sizeof(char)*i) = c;
    i++;
  }

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
