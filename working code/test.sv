class stateTr;
  byte nextState, out;

  function new();
    nextState = 0;
    out = 0;
  endfunction

  function void setNextState(byte s);
    this.nextState = s;
  endfunction

  function void setOutput(byte o);
    this.out = o;
  endfunction
endclass

class randInput;
  rand byte arr[];

  constraint c_size{arr.size() inside {[5:10]};}
  constraint c_data{foreach(arr[i])
                      arr[i] inside {[0:3]};}

  function new();
    arr = new[5];
  endfunction

  function void print();
    $display("array size: %0d", arr.size());
    $display("printing elements in array");
    $display("%p", arr);
  endfunction
endclass

module test();
  //call parseFSM.c --> parseFSM.c returns 1D array of all text file info
  //parseFSM should return an object because otherwise, the number of states can't be obtained since there's no way to define the array on the lefthand side of the equals sign
  //stateTr class --> defines objects to store in 2D array of state transitions

  //iterate through parseFSM's array to construct the array of transitions
  int i,j;
  byte numStates;
  byte fsmType; //0 = mealy, 1 = moore
  byte arr [19:0]; //stores raw state transition table
  stateTr [2:0] transitions [];
  randInput inputs;

  import "DPI-C" function void readTable(output byte fsmType, output byte numStates, output byte arr[])

  initial begin
    //parse transition table
    readTable(fsmType, numStates, arr);
    transitions = new[numStates]; //set size of dynamic array
    if (fsmType == 0) begin //parse transitions for mealy machine
      for (i=0; i<numStates; i++) begin
        transitions[i][0] = new(); //corresponding to input=0
        transitions[i][0].setNextState(arr[5*i+1]);
        transitions[i][0].setOutput(arr[5*i+2]);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].setNextState(arr[5*i+3]);
        transitions[i][1].setOutput(arr[5*i+4]);
      end
    end else if (fsmType == 1) begin //parse transitions for moore machine
      for (i=0; i<numStates; i++) begin
        transitions[i][0] = new(); //corresponding to input=0
        transitions[i][0].setNextState(arr[4*i+1]);
        transitions[i][0].setOutput(arr[4*i+3]);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].setNextState(arr[i][4*i+2]);
        transitions[i][1].setOutput(arr[i][4*i+3]);
      end
    end

    

  end
endmodule
