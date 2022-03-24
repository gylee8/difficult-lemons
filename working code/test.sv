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

module test();
  //call parseFSM.c --> parseFSM.c returns 2D array of all text file info
  //parseFSM should return an object because otherwise, the number of states can't be obtained since there's no way to define the array on the lefthand side of the equals sign
  //stateTr class --> defines objects to store in 2D array of state transitions

  //iterate through parseFSM's array to construct the array of transitions
  int i,j;
  byte numStates;
  byte fsmType; //0 = mealy, 1 = moore
  byte arr [5:0][4:0]; //stores raw state transition table
  stateTr [2:0] transitions [];

  initial begin
    //pass numStates, initialState, arr into function call
    transitions = new[numStates]; //set size of dynamic array
    if (fsmType == 1) begin //parse transitions for moore machine
      for (i=0; i<numStates; i++) begin
        transitions[i][0] = new(); //corresponding to input=0
        transitions[i][0].setNextState(arr[i][1]);
        transitions[i][0].setOutput(arr[i][3]);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].setNextState(arr[i][2]);
        transitions[i][1].setOutput(arr[i][3]);
      end
    end

  end
endmodule
