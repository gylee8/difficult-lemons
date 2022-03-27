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

  function void print();
    $display("(%0d, %0d)", nextState, out);
  endfunction
endclass

class randInputs;
  rand byte SWInputArr[];
  rand byte CtrInputArr[];

  constraint c_sizeSW{SWInputArr.size() inside {[5:10]};}
  constraint c_dataSW{foreach(SWInputArr[i])
                        SWInputArr[i] inside {[0:3]};}
  constraint c_sizeCtr{CtrInputArr.size() = SWInputArr.size()};
  constraint c_dataCtr{foreach(CtrInputArr[i])
                        CtrInputArr[i] inside {[0:1]};}

  function new();
    arr = new[5];
  endfunction

  function void print();
    $display("array size: %0d", arr.size());
    $display("printing elements in array");
    $display("%p", arr);
  endfunction
endclass

`define SV_RAND_CHECK(r) \
do begin \
  if (!(r)) begin \
    $display("%s:%0d: Randomization failed \"%s\"", \
    `__FILE__, `__LINE__, `"r`"); \
    $finish; \
  end \
end while (0)

module test();
  //call parseFSM.c --> parseFSM.c returns 1D array of all text file info
  //parseFSM should return an object because otherwise, the number of states can't be obtained since there's no way to define the array on the lefthand side of the equals sign
  //stateTr class --> defines objects to store in 2D array of state transitions

  //iterate through parseFSM's array to construct the array of transitions
  logic clk;
  int i,j;
  byte swIn, ctrIn, numStates;
  byte fsmType; //0 = mealy, 1 = moore
  byte arr [19:0]; //stores raw state transition table
  stateTr [3:0] transitions [];
  randInput inputArr;
  int inputDelay, ctrDelay;

  import "DPI-C" function void readTable(output byte fsmType, output byte numStates, output byte arr[])
  //pass input byte into DUT FSM

  initial begin
    //parse transition table
    readTable(fsmType, numStates, arr);
    foreach(transitions[i]) //set size of each dynamic array
      transitions[i] = new[numStates];
    if (fsmType == 0) begin //parse transitions for mealy machine
      $display("parsing transitions for Mealy machine");
      for (i=0; i<numStates; i++) begin
        transitions[i][0] = new(); //corresponding to input=0
        transitions[i][0].setNextState(arr[5*i+1]);
        transitions[i][0].setOutput(arr[5*i+2]);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].setNextState(arr[5*i+3]);
        transitions[i][1].setOutput(arr[5*i+4]);

        transitions[i][2] = new();
        transitions[i][2].setNextState(arr[5*i+5]);
        transitions[i][2].setOutput(arr[5*i+6]);

        transitions[i][3] = new();
        transitions[i][3].setNextState(arr[5*i+7]);
        transitions[i][3].setOutput(arr[5*i+8]);
        $display("transitions[%0d]: %p, %p, %p, %p", i, transitions[i][0], transitions[i][1], transitions[i][2], transitions[i]3);
      end
    end else if (fsmType == 1) begin //parse transitions for moore machine
      $display("parsing transitions for Moore machine");
      for (i=0; i<numStates; i++) begin
        transitions[i][0] = new(); //corresponding to input=0
        transitions[i][0].setNextState(arr[4*i+1]);
        transitions[i][0].setOutput(arr[4*i+5]);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].setNextState(arr[i][4*i+2]);
        transitions[i][1].setOutput(arr[i][4*i+5]);

        transitions[i][2] = new();
        transitions[i][2].setNextState(arr[i][4*i+3]);
        transitions[i][2].setOutput(arr[i][4*i+5]);

        transitions[i][3] = new();
        transitions[i][3].setNextState(arr[i][4*i+4]);
        transitions[i][3].setOutput(arr[i][4*i+5]);
        $display("transitions[%0d]: %p, %p, %p, %p", i, transitions[i][0], transitions[i][1], transitions[i][2], transitions[i][3]);
      end
    end

    inputArr = new();
    `SV_RAND_CHECK(inputArr.randomize()); //randomize SW_input and CTR_input
    $display();
    $display("randomized sw and ctr inputs");

    foreach(inputArr.arr[i]) begin
      std::randomize(inputDelay) with {inputDelay > 4; inputDelay < 11;};
      #(inputDelay * 1s);
      in = inputArr.SWInputArr[i];

      std::randomize(ctrDelay) with {ctrDelay > 4; ctrDelay < 11; ctrDelay>=inputDelay;};
      #(ctrDelay * 1s);
      ctrIn = inputArr.CtrInputArr[i];

    end

  end

endmodule
