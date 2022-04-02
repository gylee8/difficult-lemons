// 4-state Moore machine
// Config:
// 0
// 4
// 0 1 1 0 1 1
// 1 0 0 2 2 1
// 2 1 3 3 0 1
// 3 3 3 2 1 0

module moore4(
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
        if(sw_in < 2 || sw_in == 3) begin
          next = 1;
          out_int = 1;
        end
        else begin
          next = 0;
          out_int = 1;
        end
      end

      1: begin
        if(sw_in == 0 || sw_in == 1) begin
          next = 1;       // ERROR: should be 0
          out_int = 0;    // ERROR: should be 1
        end
        else begin
          next = 2;
          out_int = 1;
        end
      end

      2: begin
        if(sw_in == 0) begin
          next = 1;
          out_int = 1;
        end
        else if(sw_in == 1 || sw_in == 2) begin
          next = 3;
          out_int = 1;    // ERROR: should be 0
        end
        else begin
          next = 0;
          out_int = 1;
        end
      end

      3: begin
        if(sw_in < 2) begin
          next = 3;
          out_int = 0;
        end
        else if(sw_in == 2) begin
          next = 3;     // ERROR: should be 2
          out_int = 1;
        end
        else begin
          next = 1;
          out_int = 1;
        end
      end
    endcase
  end
endmodule
