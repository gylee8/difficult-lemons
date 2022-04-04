`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 12:12:41 AM
// Design Name: 
// Module Name: fsm_display
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

//display shows (left to right): 0 [current state] 0 [output]
module fsm_display(
    input wire clk, //board clock signal -- 100MHz
    input wire reset,
    input wire [1:0] swIn,
    input wire ctrIn,
    input wire [2:0] startState,
    output wire [3:0] AN,
    output wire [6:0] CA
    );
    
    wire fsmClk;
    wire [2:0] DUTcurState;
    wire DUTout;
    
    clocken1Hz mooreClk(.clk(clk), .reset(reset), .clk_en(fsmClk));
    //uncomment the FSM to display on the board
    //moore2 FSM(.clk(fsmClk), .reset(reset), .sw_in(swIn), .ctrl_in(ctrIn), .state_in(startState), .state(DUTcurState), .out(DUTout));
    //mealy2 FSM(.clk(fsmClk), .reset(reset), .sw_in(swIn), .ctrl_in(ctrIn), .state_in(startState), .state(DUTcurState), .out(DUTout));
    //moore3 FSM(.clk(fsmClk), .reset(reset), .sw_in(swIn), .ctrl_in(ctrIn), .state_in(startState), .state(DUTcurState), .out(DUTout));
    mealy3 FSM(.clk(fsmClk), .reset(reset), .sw_in(swIn), .ctrl_in(ctrIn), .state_in(startState), .state(DUTcurState), .out(DUTout));
    display d(.clk(clk), .clr(reset), .dig1({0,0,0,0}), .dig2({0,0,0,DUTcurState}), .dig3({0,0,0,0}), .dig4({0,DUTout}), .AN(AN), .CA(CA));
endmodule
