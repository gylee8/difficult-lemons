module moore2(
  input wire clk, reset,
  input wire [1:0] sw_in,
  input wire ctrl_in,
  output reg state, out
  );

  reg next, out_int;

  parameter s1 = 1'b0;
  parameter s2 = 1'b1;

  always @(posedge clk or ctrl_in) begin
    if(reset) begin
      state <= 0;
    end
    else if (ctrl_in) begin
      state <= next;
      out <= out_int;
    end
  end

  always @(sw_in, state) begin
    next = state;
    out_int = 0;
    case(state)
      s1: begin
        if(sw_in > 0) begin
          next = 1;
        end
        else begin
          next = 0;
        end
        out_int = 1;
      end

      s2: begin
        if(sw_in == 0 || sw_in == 2) begin
          next = 1;
        end
        else begin
          next = 0;
        end
        out_int = 0;
      end
    endcase
  end
endmodule
