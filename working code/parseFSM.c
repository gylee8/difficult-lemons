#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Auxiliary function to count the number of lines in the file
int numLines(FILE *f);

int main(){
  FILE *file;
  file = fopen("config.txt", "r");

  int lines = numLines(file);

  int type = 0;
  int states = 0;
  fscanf(file, "%d", &type);
  fscanf(file, "%d", &states);  // Need to change this to parse a binary value

  int nums[numLines][5 - type]  // Assuming Mealy = 1, Moore = 0
}
