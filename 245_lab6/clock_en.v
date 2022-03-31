`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2020 09:00:01 PM
// Design Name: 
// Module Name: clock_en
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


module clock_en(
    input clk_in,
    input clr,
    output reg clk_out
    );
    integer count = 0;
    
    always @(posedge clk_in or posedge clr)
    begin
        if(count == 9) begin
            count <= 0;
            clk_out <= 1;
        end
        else if(clr == 1) begin
            count <= 0;
            clk_out <= 0;
        end
        else begin
            count <= count + 1;
            clk_out <= 0;
        end
    end
endmodule
