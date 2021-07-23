`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 22:00:21
// Design Name: 
// Module Name: IROM
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


module IROM(
    input wire[31:0] PC,
    output wire[31:0] instruction
    );
    prgrom U0_irom(
    .a(PC[15:2]),
    .spo(instruction)
    );
endmodule
