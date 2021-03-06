// 2-state Moore machine
// Config:
// 0
// 2
// 0 0 1 1 1 1
// 1 1 0 1 0 0

// ERROR: wrong (flipped) output

module moore2(
  input wire clk, reset,
  input wire [1:0] sw_in,
  input wire ctrl_in,
  input wire [2:0] state_in,
  output reg [2:0] state,
  output reg out
  );

  reg [2:0] next;
  reg out_int;

  // initial begin
  //   #5    // need this delay for state initialization to happen correctly
  //   //$display("initial begin: state <= state_in");
  //   state = state_in;
  // end

  always @(posedge clk or posedge reset) begin
    // $display("posedge clk");
    if(reset) begin
      // $display("reset");
      state <= state_in;
    end
    else if (ctrl_in) begin
      state <= next;
      out <= out_int;
    end
  end

  always @(sw_in, state) begin
    next = state;
    case(state)
      0: begin
        if(sw_in > 0) begin
          next = 1;
          out_int = 1;
        end
        else begin
          next = 0;
          out_int = 0;
        end
      end

      1: begin
        if(sw_in == 0 || sw_in == 2) begin
          next = 1;
          out_int = 1;
        end
        else begin
          next = 0;
          out_int = 0;
        end
      end
    endcase
  end
endmodule
