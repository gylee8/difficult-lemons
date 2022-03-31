`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2020 12:57:15 PM
// Design Name: 
// Module Name: four_one_MUX
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


module four_one_MUX(
    input wire [3:0] dig1,
    input wire [3:0] dig2,
    input wire [3:0] dig3,
    input wire [3:0] dig4,
    input wire [1:0] S,
    output reg [3:0] X
    );
    
    always @(S)
        case(S)
            2'b00 : X = dig1;
            2'b01 : X = dig2;
            2'b10 : X = dig3;
            2'b11 : X = dig4;
            default : X = 2'b00;
        endcase
        
endmodule
