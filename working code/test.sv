class stateTr;
  byte nextState, out;

  function new();
    nextState = 0;
    out = 0;
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
  constraint c_sizeCtr{CtrInputArr.size() == SWInputArr.size();}
  constraint c_dataCtr{foreach(CtrInputArr[i])
                        CtrInputArr[i] inside {[0:1]};}

  function new();
    SWInputArr = new[5];
    CtrInputArr = new[5];
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
  stateTr transitions [][];
  randInputs inputArr;
  int inputDelay, ctrDelay;

  import "DPI-C" function void readTable(output byte fsmType, output byte numStates, output byte arr[20]);
  //pass input byte into DUT FSM

  initial begin
    //$display("initial begin");
    //parse transition table
    readTable(fsmType, numStates, arr);
    // $display("-----Inside test.sv-----");
    // $display("finished readTable");
    // $display("fsmType: %0d", fsmType);
    // $display("numStates: %0d", numStates);
    // $display("arr: %p", arr);
    // $display("arr:");
    // for (i = 0; i<20; i++) begin
    //   $display("i=%0d: %0d", i, arr[i]);
    // end
    //$display();
    //foreach(transitions[i]) //set size of each dynamic array
      //transitions[i] = new[numStates];
    transitions = new[numStates];
    foreach(transitions[i]) begin
      transitions[i] = new[4];
    end
    if (fsmType == 1) begin //parse transitions for mealy machine
      $display("parsing transitions for Mealy machine");
      for (i=0; i<numStates; i++) begin
        transitions[i][0] = new(); //corresponding to input=0
        transitions[i][0].nextState = (arr[19-(9*i+1)]);
        transitions[i][0].out = (arr[19-(9*i+2)]);
        $display("(%0d,%0d)", transitions[i][0].nextState, transitions[i][0].out);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].nextState = (arr[19-(9*i+3)]);
        transitions[i][1].out = (arr[19-(9*i+4)]);
        $display("(%0d,%0d)", transitions[i][1].nextState, transitions[i][1].out);

        transitions[i][2] = new();
        transitions[i][2].nextState = (arr[19-(9*i+5)]);
        transitions[i][2].out = (arr[19-(9*i+6)]);
        $display("(%0d,%0d)", transitions[i][2].nextState, transitions[i][2].out);

        transitions[i][3] = new();
        transitions[i][3].nextState = (arr[19-(9*i+7)]);
        transitions[i][3].out = (arr[19-(9*i+8)]);
        $display("(%0d,%0d)", transitions[i][3].nextState, transitions[i][3].out);
        $display("transitions[%0d]: (%0d,%0d), (%0d,%0d), (%0d,%0d), (%0d,%0d)", i, transitions[i][0].nextState, transitions[i][0].out, transitions[i][1].nextState, transitions[i][1].out, transitions[i][2].nextState, transitions[i][2].out, transitions[i][3].nextState, transitions[i][3].out);
      end
    end else if (fsmType == 0) begin //parse transitions for moore machine
      //$display("parsing transitions for Moore machine");
      for (i=0; i<numStates; i++) begin
        //$display("~~ i = %0d ~~", i);
        transitions[i][0] = new(); //corresponding to input=0
        //$display("-- %0d --", (19-(6*i+1)));
        transitions[i][0].nextState = (arr[19-(6*i+1)]);
        //$display("-- %0d --", (19-(6*i+5)));
        transitions[i][0].out = (arr[19-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[19-(6*i+1)]),(arr[19-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][0].nextState, transitions[i][0].out);

        transitions[i][1] = new(); //corresponding to input=1
        //$display("-- %0d --", (19-(6*i+2)));
        transitions[i][1].nextState = (arr[19-(6*i+2)]);
        //$display("-- %0d --", (19-(6*i+5)));
        transitions[i][1].out = (arr[19-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[19-(6*i+2)]),(arr[19-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][1].nextState, transitions[i][1].out);

        transitions[i][2] = new();
        //$display("-- %0d --", (19-(6*i+3)));
        transitions[i][2].nextState = (arr[19-(6*i+3)]);
        //$display("-- %0d --", (19-(6*i+5)));
        transitions[i][2].out = (arr[19-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[19-(6*i+3)]),(arr[19-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][2].nextState, transitions[i][2].out);

        transitions[i][3] = new();
        //$display("-- %0d --", (19-(6*i+4)));
        transitions[i][3].nextState = (arr[19-(6*i+4)]);
        //$display("-- %0d --", (19-(6*i+5)));
        transitions[i][3].out = (arr[19-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[19-(6*i+4)]),(arr[19-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][3].nextState, transitions[i][3].out);
        $display("transitions[%0d]: (%0d,%0d), (%0d,%0d), (%0d,%0d), (%0d,%0d)", i, transitions[i][0].nextState, transitions[i][0].out, transitions[i][1].nextState, transitions[i][1].out, transitions[i][2].nextState, transitions[i][2].out, transitions[i][3].nextState, transitions[i][3].out);
      end
    end

    inputArr = new();
    `SV_RAND_CHECK(inputArr.randomize()); //randomize SW_input and CTR_input
    $display();
    $display("randomized sw and ctr inputs");

    foreach(inputArr.SWInputArr[i]) begin
      std::randomize(inputDelay) with {inputDelay > 4; inputDelay < 11;};
      #(inputDelay * 1ns);
      swIn = inputArr.SWInputArr[i];

      std::randomize(ctrDelay) with {ctrDelay > 4; ctrDelay < 11; ctrDelay>=inputDelay;};
      #(ctrDelay * 1ns);
      ctrIn = inputArr.CtrInputArr[i];
    end
  end

endmodule
