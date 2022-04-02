// 5-state Mealy machine
// Config:
// 1
// 5
// 0 1 0 4 1 1 0 2 1
// 1 4 0 2 1 4 0 0 0
// 2 4 1 2 1 3 0 3 0
// 3 2 1 2 1 1 0 0 0
// 4 1 1 3 1 0 0 4 1

module mealy5(
  input wire clk, reset,
  input wire [1:0] sw_in,
  input wire ctrl_in,
  input wire [2:0] state_in,
  output reg [2:0] state,
  output reg out
  );

  reg [2:0] next;
  reg out_int;

  always @(posedge clk or posedge reset) begin
    if(reset) begin
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
            next = 1;
            out_int = 0;
          end
          1: begin
            next = 4;
            out_int = 1;
          end
          2: begin
            next = 1;
            out_int = 0;
          end
          3: begin
            next = 2;
            out_int = 0;    // ERROR: should be 1
          end
        endcase
      end

      1: begin
        case(sw_in)
          0: begin
            next = 3;       // ERROR: should be 4
            out_int = 1;    // ERROR: should be 0
          end
          1: begin
            next = 2;
            out_int = 1;
          end
          2: begin
            next = 4;
            out_int = 0;
          end
          3: begin
            next = 0;
            out_int = 0;
          end
        endcase
      end

      2: begin
        case(sw_in)
          0: begin
            next = 4;
            out_int = 1;
          end
          1: begin
            next = 2;
            out_int = 1;
          end
          2: begin
            next = 3;
            out_int = 0;
          end
          3: begin
            next = 3;
            out_int = 0;
          end
        endcase
      end

      3: begin
        case(sw_in)
          0: begin
            next = 2;
            out_int = 1;
          end
          1: begin
            next = 1;     // ERROR: should be 2
            out_int = 1;
          end
          2: begin
            next = 1;
            out_int = 0;
          end
          3: begin
            next = 0;
            out_int = 0;
          end
        endcase
      end

      4: begin
        case(sw_in)
          0: begin
            next = 1;
            out_int = 0;    // ERROR: should be 1
          end
          1: begin
            next = 3;
            out_int = 1;
          end
          2: begin
            next = 0;
            out_int = 0;
          end
          3: begin
            next = 2;     // ERROR: should be 4
            out_int = 0;  // ERROR: should be 1
          end
        endcase
      end
    endcase
  end
endmodule
