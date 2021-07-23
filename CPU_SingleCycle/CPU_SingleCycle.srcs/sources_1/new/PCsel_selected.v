`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 20:16:33
// Design Name: 
// Module Name: PCsel_selected
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


module PCsel_selected(
    input wire [1:0] PCsel,
    input wire Branch,
    output reg [1:0]PCsel_out
    );
    always@(*) begin
        PCsel_out = (Branch == 1'b0)? PCsel : 2'b01;
    end
    
endmodule
