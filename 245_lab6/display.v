`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2020 12:00:07 AM
// Design Name: 
// Module Name: display
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


module display(
    input clr,
    input clk,
    input [3:0] dig1,
    input [3:0] dig2,
    input [3:0] dig3,
    input [3:0] dig4,
    output wire [3:0] AN,
    output wire [6:0] CA
    );
    
    wire clock_en;
    wire [1:0] S;
    wire [3:0] X;
    clock_en clock(.clk_in(clk), .clk_out(clock_en), .clr(clr));
    anode_driver drive(.reset(clr), .clk(clk), .clk_en(clock_en), .S(S), .AN(AN));
    four_one_MUX mux(.dig1(dig1), .dig2(dig2), .dig3(dig3), .dig4(dig4), .S(S), .X(X));
    hexToLED hex(.x(X), .ca(CA));
    
endmodule
