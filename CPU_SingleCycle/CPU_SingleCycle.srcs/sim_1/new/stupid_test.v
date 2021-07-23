`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/18 20:32:23
// Design Name: 
// Module Name: stupid_test
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


module stupid_test(

    );
    
    
    reg test1;
    reg test2;
    wire cmp;
    reg signal;
    assign cmp = (test1 == test2);
    assign x = test1;
    always@(*)begin
        if(cmp == 1) 
            signal = 1;
        else if(x == 1)
            signal = 1;
        else signal = 0;
    end
    initial begin
        #30 test1 = 1;
        #10 test2 = 0;
        #10 test2 = 1;
    end
    
    
endmodule
