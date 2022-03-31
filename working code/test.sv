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

  constraint c_sizeSW{SWInputArr.size() inside {[20:30]};}
  constraint c_dataSW{foreach(SWInputArr[i])
                        SWInputArr[i] inside {[0:3]};}
  constraint c_sizeCtr{CtrInputArr.size() == SWInputArr.size();}
  constraint c_dataCtr{foreach(CtrInputArr[i])
                        CtrInputArr[i] inside {[0:1]};}

  function new();
    SWInputArr = new[5];
    CtrInputArr = new[5];
  endfunction

  function void print();
    $display("SWInputArr:  %p", SWInputArr);
    $display("CtrInputArr: %p", CtrInputArr);
  endfunction
endclass

class randDelays;
  rand int swDelay;
  rand int ctrDelay;

  constraint c_sw{swDelay inside {[5:10]};}
  constraint c_ctr{ctrDelay > swDelay; ctrDelay <= 10;}
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

  int i,j;
  int totalErrCount, numTransitions; //total number of errors and number of attempted transitions
  int outErrCount; //number of output errors
  int nextErrCount; //number of incorrect next states
  int numStErrCount; //number of times the incorrect number of states was detected
  byte numStates, curState;
  logic curOut;
  byte fsmType; //0 = mealy, 1 = moore
  byte arr [44:0]; //stores raw state transition table
  stateTr transitions [][];
  randInputs inputArr;
  //int inputDelay, ctrDelay;
  randDelays delays;

  // byte num;


  logic clk, reset;
  logic [1:0] swIn;
  logic ctrIn;
  reg [2:0] startState; //3-bits to account for possible 5-state
  wire [2:0] DUTcurState; //3-bits to account for possible 5-state
  wire DUTout;

  import "DPI-C" function void readTable(output byte fsmType, output byte numStates, output byte arr[45]);

  //declare DUT
  moore2 FSM(clk, reset, swIn, ctrIn, startState, DUTcurState, DUTout);
  // mealy2 FSM(clk, reset, swIn, ctrIn, startState, DUTcurState, DUTout);

  initial begin
    clk = 0;
    totalErrCount = 0;
    numTransitions = 0;
    outErrCount = 0;
    nextErrCount = 0;
    numStErrCount = 0;
    forever #1s clk=~clk;
  end

  initial begin
    reset = 0;
    //$display("initial begin");
    //parse transition table
    readTable(fsmType, numStates, arr);
    // #10
    //fsmType = 0;
    //numStates = 2;
//    arr = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0};
    //arr = {0,0,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; //mealy2 array
    delays = new();
    $display("-----Inside test.sv-----");
    $display("finished readTable");
    $display("fsmType: %0d", fsmType);
    $display("numStates: %0d", numStates);
    $display("arr: %p", arr);
    $display("arr:");
    for (i = 0; i<45; i++) begin
      $display("i=%0d: %0d", i, arr[i]);
    end
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
        transitions[i][0].nextState = (arr[$size(arr)-1-(9*i+1)]);
        transitions[i][0].out = (arr[$size(arr)-1-(9*i+2)]);
        $display("(%0d,%0d)", transitions[i][0].nextState, transitions[i][0].out);

        transitions[i][1] = new(); //corresponding to input=1
        transitions[i][1].nextState = (arr[$size(arr)-1-(9*i+3)]);
        transitions[i][1].out = (arr[$size(arr)-1-(9*i+4)]);
        $display("(%0d,%0d)", transitions[i][1].nextState, transitions[i][1].out);

        transitions[i][2] = new();
        transitions[i][2].nextState = (arr[$size(arr)-1-(9*i+5)]);
        transitions[i][2].out = (arr[$size(arr)-1-(9*i+6)]);
        $display("(%0d,%0d)", transitions[i][2].nextState, transitions[i][2].out);

        transitions[i][3] = new();
        transitions[i][3].nextState = (arr[$size(arr)-1-(9*i+7)]);
        transitions[i][3].out = (arr[$size(arr)-1-(9*i+8)]);
        $display("(%0d,%0d)", transitions[i][3].nextState, transitions[i][3].out);
        $display("transitions[%0d]: (%0d,%0d), (%0d,%0d), (%0d,%0d), (%0d,%0d)", i, transitions[i][0].nextState, transitions[i][0].out, transitions[i][1].nextState, transitions[i][1].out, transitions[i][2].nextState, transitions[i][2].out, transitions[i][3].nextState, transitions[i][3].out);
      end
    end else if (fsmType == 0) begin //parse transitions for moore machine
      $display("parsing transitions for Moore machine");
      for (i=0; i<numStates; i++) begin
        //$display("~~ i = %0d ~~", i);
        transitions[i][0] = new(); //corresponding to input=0
        //$display("-- %0d --", ($size(arr)-1-(6*i+1)));
        transitions[i][0].nextState = (arr[$size(arr)-1-(6*i+1)]);
        //$display("-- %0d --", ($size(arr)-1-(6*i+5)));
        transitions[i][0].out = (arr[$size(arr)-1-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[$size(arr)-1-(6*i+1)]),(arr[$size(arr)-1-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][0].nextState, transitions[i][0].out);

        transitions[i][1] = new(); //corresponding to input=1
        //$display("-- %0d --", ($size(arr)-1-(6*i+2)));
        transitions[i][1].nextState = (arr[$size(arr)-1-(6*i+2)]);
        //$display("-- %0d --", ($size(arr)-1-(6*i+5)));
        transitions[i][1].out = (arr[$size(arr)-1-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[$size(arr)-1-(6*i+2)]),(arr[$size(arr)-1-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][1].nextState, transitions[i][1].out);

        transitions[i][2] = new();
        //$display("-- %0d --", ($size(arr)-1-(6*i+3)));
        transitions[i][2].nextState = (arr[$size(arr)-1-(6*i+3)]);
        //$display("-- %0d --", ($size(arr)-1-(6*i+5)));
        transitions[i][2].out = (arr[$size(arr)-1-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[$size(arr)-1-(6*i+3)]),(arr[$size(arr)-1-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][2].nextState, transitions[i][2].out);

        transitions[i][3] = new();
        //$display("-- %0d --", ($size(arr)-1-(6*i+4)));
        transitions[i][3].nextState = (arr[$size(arr)-1-(6*i+4)]);
        //$display("-- %0d --", ($size(arr)-1-(6*i+5)));
        transitions[i][3].out = (arr[$size(arr)-1-(6*i+5)]);
        //$display("expect (%0d,%0d)",(arr[$size(arr)-1-(6*i+4)]),(arr[$size(arr)-1-(6*i+5)]));
        //$display("actual (%0d,%0d)", transitions[i][3].nextState, transitions[i][3].out);
        $display("transitions[%0d]: (%0d,%0d), (%0d,%0d), (%0d,%0d), (%0d,%0d)", i, transitions[i][0].nextState, transitions[i][0].out, transitions[i][1].nextState, transitions[i][1].out, transitions[i][2].nextState, transitions[i][2].out, transitions[i][3].nextState, transitions[i][3].out);
      end
    end
    $display();

    startState = $urandom_range(numStates-1); //generate random starting state
    $display("startState: %0d", startState);
    curState = startState;

    reset = 1;
    #2s reset = 0;

    inputArr = new();
    `SV_RAND_CHECK(inputArr.randomize()); //randomize SW_input and CTR_input
    $display("randomized sw and ctr inputs");
    inputArr.print();
    $display();
    $display("----------------------------");
    $display("Starting");
    $display("state: %0d", curState);


    //$finish;

    foreach(inputArr.SWInputArr[i]) begin
      `SV_RAND_CHECK(delays.randomize());
      $display();
      //std::randomize(inputDelay) with {inputDelay > 4; inputDelay < 11;};
      $display("#%0d", delays.swDelay);
      #(delays.swDelay * 1s);
      swIn = inputArr.SWInputArr[i];
      $display("SW: %0d", swIn);

      //std::randomize(ctrDelay) with {ctrDelay > 4; ctrDelay < 11; ctrDelay>=inputDelay;};
      $display("#%0d", delays.ctrDelay);
      #(delays.ctrDelay * 1s);
      ctrIn = inputArr.CtrInputArr[i]; //input accepted when ctr_input is HIGH
      $display("CTR: %0d", ctrIn);
    end
    $display();
    $display("----------------------------");
    $display("Total Errors: %0d", numStErrCount+nextErrCount+outErrCount);
    $display("# times incorrect number of states was detected: %0d", numStErrCount);
    $display("# times next state was incorrect: %0d", nextErrCount);
    $display("# times output was incorrect: %0d", outErrCount);
    $finish;
  end

  always @(posedge clk) begin
    //change state and generate output if ctr is enabled (ctrIn HIGH)
    if (ctrIn == 1) begin
      if (fsmType == 0) begin //moore machine
        transitions[curState][swIn].print();
        curState = transitions[curState][swIn].nextState;
        transitions[curState][0].print();
        curOut = transitions[curState][0].out;
      end else if (fsmType == 1) begin //mealy machine
        curOut = transitions[curState][swIn].out;
        curState = transitions[curState][swIn].nextState;
      end
    end

    #10ns;
    $display("\n\nexpected state = %0d, output = %0d", curState, curOut);
    $display("DUT      state = %0d, output = %0d", DUTcurState, DUTout);
    if (curState != DUTcurState || curOut != DUTout) begin //compare to DUT
      $display("  ###############  ");
      if (curState != DUTcurState) begin
        if (DUTcurState > numStates-1) begin
          numStErrCount++;
          $display("ERROR--incorrect number of states");
          $display(" max state: %0d", numStates-1);
          $display(" DUT state: %0d", DUTcurState);
          $display();
          $display("----------------------------");
          $display("Total Errors: %0d", numStErrCount+nextErrCount+outErrCount);
          $display("# times incorrect number of states was detected: %0d", numStErrCount);
          $display("# times next state was incorrect: %0d", nextErrCount);
          $display("# times output was incorrect: %0d", outErrCount);
          $finish;
        end else begin
          nextErrCount++;
          $display("ERROR--incorrect next state");
          $display(" expected : %0d", curState);
          $display(" DUT state: %0d", DUTcurState);
          curState = DUTcurState;
        end
      end
      if (curOut != DUTout) begin
        outErrCount++;
        $display("ERROR--incorrect output");
        $display(" expected  : %0d", curOut);
        $display(" DUT output: %0d", DUTout);
      end
    end
  end
endmodule
