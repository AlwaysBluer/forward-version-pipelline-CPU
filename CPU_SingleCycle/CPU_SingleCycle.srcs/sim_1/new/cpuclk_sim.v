`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:05:15
// Design Name: 
// Module Name: cpuclk_sim
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


module cpuclk_sim();
    // input
    reg pclk = 0;
    // output
    wire clock;
    cpuclk UCLK (
        .clk_in1    (pclk),
        .clk_out1   (clock)
    );
    always #5 pclk = ~pclk;
endmodule
