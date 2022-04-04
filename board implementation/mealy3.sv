`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 01:05:12 AM
// Design Name: 
// Module Name: mealy3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mealy3(
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
            next = 1;
            out_int = 1;
          end
          1: begin
            next = 2;
            out_int = 0;
          end
          2: begin
            next = 1;
            out_int = 1;
          end
          3: begin
            next = 0;
            out_int = 0;
          end
        endcase
      end

      1: begin
        case(sw_in)
          0: begin
            next = 2;
            out_int = 1;
          end
          1: begin
            next = 2;
            out_int = 1;
          end
          2: begin
            next = 2;
            out_int = 1;
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
            next = 0;
            out_int = 1;
          end
          1: begin
            next = 0;
            out_int = 1;
          end
          2: begin
            next = 2;
            out_int = 0;
          end
          3: begin
            next = 0;
            out_int = 0;
          end
        endcase
      end
    endcase
  end
endmodule