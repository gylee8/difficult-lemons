class stateTr;
  int nextState, out;

  function new();
    nextState = 0;
    out = 0;
  endfunction

  function void setNextState(int s);
    this.nextState = s;
  endfunction

  function void setOutput(int o);
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
  byte arr [5:0][4:0];
  stateTr [2:0] transitions [];

  initial begin
    //pass numStates, initialState, arr into function call
    if (fsmType == 0) begin //parse transitions for mealy machine
      for (i=0; i<numStates; i++) begin
        
      end
    end

  end
endmodule
