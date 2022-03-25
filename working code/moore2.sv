module moore2(
  input wire clk, reset,
  input wire [1:0] sw_in,
  input wire ctrl_in,
  output reg state
  );

  reg next;

  always @(posedge clk and (posedge reset or ctrl_in)) begin
    if(reset) begin
      state <= 0;
    end
    else if (ctrl_in) begin
      state <= next;
    end
  end

  always @(sw_in, state) begin
    next = state;
    case(state)
      0: begin
        if(sw_in > 0) begin
          next = 1;
        end
        else begin
          next = 0;
        end
      end

      1: begin
        if(sw_in == 0 or sw_in == 2) begin
          next = 1;
        end
        else begin
          next = 0;
        end
      end
    endcase
  end
endmodule
