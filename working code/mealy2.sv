// 2-state Mealy machine
// Config:
// 1
// 2
// 0 0 1 0 0 1 1 1 1
// 1 0 0 1 1 1 1 1 0

module mealy2(
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
  //   $display("mealy2.sv: state = %0d", state);
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
        case(sw_in)
          0: begin
            next = 0;
            out_int = 1;
          end
          1: begin
            next = 0;
            out_int = 0;
          end
          2: begin
            next = 1;
            out_int = 1;
          end
          3: begin
            next = 1;
            out_int = 1;
          end
        endcase
      end
      1: begin
        case(sw_in)
          0: begin
            next = 0;
            out_int = 0;
          end
          1: begin
            next = 1;
            out_int = 1;
          end
          2: begin
            next = 1;
            out_int = 1;
          end
          3: begin
            next = 1;
            out_int = 0;
          end
        endcase
      end
    endcase
  end
endmodule
