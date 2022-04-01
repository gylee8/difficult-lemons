#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Auxiliary function to count the number of lines in the file
int numLines(FILE *f);

// Read information from config.txt
void readTable(char *type, char *states, char *table);


// int main(){
//   char *table = (char *) malloc(sizeof(char) * 4);
//   char *type = (char *) malloc(sizeof(char));
//   char *states = (char *) malloc(sizeof(char));
//   readTable(type, states, table);
//   printf("type: %d, states: %d\n", *type, *states);
//   int i = 0;
//   // printf("table: ");
//   for(i = 0; i<4; i++){
//     printf("table element %d in %p: %d\n", i, table + i*sizeof(char), *(table + i*sizeof(char)));
//   }
// }

void readTable(char *type, char *states, char *table){
  // printf("\ninside readTable()\n");
  FILE *file;
  file = fopen("config.txt", "r");

  // int lines = numLines(file);

  char str[10];
  int temp;
  // if(fgets(str, 10, file) != NULL){
  //   printf("no error with fgets\n");
  //   printf("'%s'", str);
  // }
  // if(sscanf(str, "%d", &temp) == 1){
  //   printf("no error with sscanf\n");
  //   printf("temp = %d\n", temp);
  // }
  fscanf(file, "%d", &temp) == 1;
  // if(fscanf(file, "%d", &temp) == 1){
  //   printf("no error with fscanf\n");
  // }
  // printf("temp = %d\n", temp);
  fscanf(file, "%d", states); // Value: {2, 3, 4}
  // printf("temp = %d\n", temp);
  *type = temp;
  // printf("type = %d\n", *type);
  // printf("\ninside parseFSM: type = %d, # states = %d\n", *type, *states);

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
