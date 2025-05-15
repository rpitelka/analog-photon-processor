`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2025 03:45:54 PM
// Design Name: 
// Module Name: tb
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


module tb_behav(

    );
    
    reg clk = 1'b0;
    reg rst = 1'b0;
    
    app_1ch_behav app_tb (
        .clk(clk),
        .rst_init(rst)
    );
    
    always #10 clk = ~clk; // System clock 50MHz
   
    initial begin
        #0  rst = 1'b0;
    end
    
endmodule
