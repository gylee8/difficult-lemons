`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2022 11:57:38 AM
// Design Name: 
// Module Name: clocken1Hz
// Description: creates a 1Hz clock signal enable signal from a 100MHz clock
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module clocken1Hz(
    input clk,
    input reset,
    output reg clk_en
    );
    
    initial begin
        clk_en = 0;
    end
    
    integer count = 0;
    always @(posedge clk or posedge reset)
        if (reset == 1) begin
            count <= 0;
            clk_en <= 0;
        end else if(count == 99999999) begin //count 10^8 number of 100MHz pulses
            count = 0;
            clk_en = 1'b1;
        end else begin
            count = count + 1;
            clk_en = 0;
        end
endmodule
