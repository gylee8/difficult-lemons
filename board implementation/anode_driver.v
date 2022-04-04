`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2022 08:36:26 PM
// Design Name: 
// Module Name: anode_driver
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


module anode_driver(
    input reset,
    input clk_en,
    input clk,
    output reg [3:0] AN,
    output reg [1:0] S
    );
    
    initial begin
        S = 2'b00;
        AN = 4'b1110;
    end
    
    always @(posedge clk_en or posedge reset)
        begin
        if(reset == 1) begin
            S <= 0;
            //AN = 4'b1110;
        end
        else
            S <= S+1;
    end
    
    always @(S)
    begin 
        case (S)
            2'b00   : AN = 4'b1110;
            2'b01   : AN = 4'b1101;
            2'b10   : AN = 4'b1011;
            2'b11   : AN = 4'b0111;
            default : AN = 4'b1110;
        endcase
    end
endmodule


