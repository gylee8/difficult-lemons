#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void sandp(int A, int B, int C, int D, int *F1, int *F2);
int octTodec(int oct);
int xinputand(int X, int a, int b, int c, int d);
int xinputor(int X, int a, int b, int c, int d);

/*int main(){
  int F1, F2, A, B, C, D;
  printf("ABCD  F1  F2\n");
  for (A = 0; A<2; A++){
    for (B = 0; B<2; B++){
      for (C = 0; C<2; C++){
        for (D = 0; D<2; D++){
          sandp(A, B, C, D, &F1, &F2);
          printf("%d%d%d%d  %d   %d\n", A, B, C, D, F1, F2);
        }
      }
    }
  }
}*/

void sandp(int A, int B, int C, int D, int *F1, int *F2){
  FILE *arrFile;
  arrFile = fopen("funcs.txt", "r"); //argv[1]
  if (arrFile == NULL){
    printf("Could not open %s\n", "funcs.txt");
    exit(-1);
  }
  //printf("opened file\n");

  int arr[2][4] = {0}; //stores decimal version of each binary number
  int n1, n2, n3, n4;
  int numLine = 0;
  while(fscanf(arrFile, "%o %o %o %o", &n1, &n2, &n3, &n4) != EOF && numLine != 2) {
    //printf("fscanf, numLine = %d\n", numLine);
    //printf("a = %o, b = %o, c = %o, d = %o\n", a, b, c, d);
    //printf("a = %o\n", a);
    arr[numLine][0] = octTodec(n1);
    //printf("b = %o\n", b);
    arr[numLine][1] = octTodec(n2);
    //printf("c = %o\n", c);
    arr[numLine][2] = octTodec(n3);
    //printf("d = %o\n", d);
    arr[numLine][3] = octTodec(n4);
    numLine++;
  }
  fclose(arrFile);
  //printf("scanned i = %d lines\n", i);
  //print array to check
  /*
  for (int r = 0; r<20; r++){
    printf("%d %d %d %d\n", arr[r][0], arr[r][1], arr[r][2], arr[r][3]);
  }
  */
  int sum1, sum2, sum3, prod1, prod2, prod3;

  if (arr[0][0] == 0){ //line 1 F1 (SOP) --> line 2 F2 (POS)
    prod1 = xinputand(arr[0][1], A, B, C, D);
    prod2 = xinputand(arr[0][2], A, B, C, D);
    prod3 = xinputand(arr[0][3], A, B, C, D);

    sum1 = xinputor(arr[1][1], A, B, C, D);
    sum2 = xinputor(arr[1][2], A, B, C, D);
    sum3 = xinputor(arr[1][3], A, B, C, D);
  } else if (arr[0][0] == 1){ //line 1 F2 (POS) --> line 2 F1 (SOP)
    sum1 = xinputor(arr[0][1], A, B, C, D);
    sum2 = xinputor(arr[0][2], A, B, C, D);
    sum3 = xinputor(arr[0][3], A, B, C, D);

    prod1 = xinputand(arr[1][1], A, B, C, D);
    prod2 = xinputand(arr[1][2], A, B, C, D);
    prod3 = xinputand(arr[1][3], A, B, C, D);
  } else{
    printf("ERROR: missing first function specifier\n");
  }
  *F1 = prod1 || prod2 || prod3; //F1 SOP
  //printf("F2 = (%d) && (%d) && (%d)\n", sum1, sum2, sum3);
  *F2 = sum1 && sum2 && sum3; //F2 POS
}

int octTodec(int oct){
  int out = 0;
  int curBit = 0;
  for (int i = 0; i<8; i++){
    //printf("i = %d\n", i);
    //printf("  oct = %o\n", oct);
    curBit = oct & 1;
    //printf("  curBit = %d\n", curBit);
    out += (curBit*pow(2,i));
    //printf("  out = %d\n", out);
    oct = oct >> 3;
    //printf("  oct = %o\n", oct);
  }
  return out;
}

//maximum input X: 4-bit binary number
int xinputand(int X, int a, int b, int c, int d){
  int flagBitsReversed[4] = {0}; //initialize only 4 bits
  int flagBits[4] = {0};    //stores 1 if it's supposed to be input into AND
  int flagCount = 0;

  int l = 0;    //var to iterate through bits
  int q = X;    //quotient

  //algorithm generates binary number from bit 0 (reverse order)
  while (q > 0){
    int bit = q%2;
    flagBitsReversed[l] = bit;  //store remainder
    q /=2;    //quotient for calculating next bit
    l++;      //increment length
  }

  //iterate through to store in correct order
  for (int i = 0; i<4; i++){
    flagBits[i] = flagBitsReversed[3-i];
    if (flagBits[i] == 1)
      flagCount++;
  }

  //printf("Flags: %d%d%d%d\n", flagBits[0], flagBits[1], flagBits[2], flagBits[3]);
  //printf("flagCount = %d\n", flagCount);
  //iterate through all bit combinations
  int curBits[4] = {a, b, c, d};
  int output = 0;
  int curFlagCount = 0;
  for (int i = 0; i<4; i++){    //compute select input AND
    if (flagBits[i] != 0){
      //printf("flagBits[%d] = %d\n", i, flagBits[i]);
      curFlagCount++;
      //printf("\toutput = %d\n", output);
      //printf("\tcurFlagCount = %d\n", curFlagCount);
      if (flagCount != 0 && curFlagCount == 1){
        output = flagBits[i];   //set output to start with 1st bit
      }
      output = output && curBits[i];
      //printf("\toutput = %d\n", output);
    }
  }
  //printf("Input: %d%d%d%d \tOutput: %d\n", a, b, c, d, output);
  return output;
}

//maximum input X: 4-bit binary number
int xinputor(int X, int a, int b, int c, int d){
  //printf("xinputor\n");
  int flagBitsReversed[4] = {0}; //initialize only 4 bits
  int flagBits[4] = {0};    //stores 1 if it's supposed to be input into AND
  int flagCount = 0;

  int l = 0;    //var to iterate through bits
  int q = X;    //quotient

  //algorithm generates binary number from bit 0 (reverse order)
  while (q > 0){
    int bit = q%2;
    flagBitsReversed[l] = bit;  //store remainder
    q /=2;    //quotient for calculating next bit
    l++;      //increment length
  }

  //iterate through to store in correct order
  for (int i = 0; i<4; i++){
    flagBits[i] = flagBitsReversed[3-i];
    if (flagBits[i] == 1)
      flagCount++;
  }
  /*printf("abcd: %d%d%d%d\n", a, b, c, d);
  printf("Flags: %d%d%d%d\n", flagBits[0], flagBits[1], flagBits[2], flagBits[3]);
  printf("flagCount = %d\n", flagCount);*/
  //iterate through all bit combinations
  int curBits[4] = {a, b, c, d};
  int output = 0;
  int curFlagCount = 0;
  for (int i = 0; i<4; i++){    //compute select input OR
    if (flagBits[i] != 0){
      /*printf("flagBits[%d] = %d\n", i, flagBits[i]);
      printf("\toutput = %d\n", output);
      printf("\tcurFlagCount = %d\n", curFlagCount);*/
      /*if (flagCount != 0 && curFlagCount == 1){
        output = flagBits[i];   //set output to start with 1st bit
      }*/
      curFlagCount++;
      output = output || curBits[i];
      //printf("\toutput = %d\n", output);
    }
  }
  //printf("Input: %d%d%d%d \tOutput: %d\n", a, b, c, d, output);
  return output;
}
