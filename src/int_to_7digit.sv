`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 14:08:56
// Design Name: 
// Module Name: int_to_7digit
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


module int_to_7digit(
input clk,reset,
input int number,
output logic[3:0] digits[7]

    );
    logic[4:0] counter_operation;
            logic [3:0] counter_digits; 
            logic calculating;
            logic[4:0] quo;
            int r;
            logic slowed_clk;
            //logic[4:0] digits[7];
            //slowed clock for slack
            
            clock_4_divider slow_clock_ins(.clk_in(clk),
            .reset(reset),
            .clk_out(slowed_clk));
            
            logic [31:0] powers_of_10 [6:0] = '{1_000_000, 100_000, 10_000, 1_000, 100, 10, 1};   
                
            always_ff @(posedge slowed_clk or posedge reset)begin
                if(reset)begin
                    counter_operation<=0;
                    quo<=0;
                    r<=0; 
                    calculating<=0;
                    for (int i =0;i<7;i++) digits[i]=0;
                end else begin
                    if (counter_operation==0  && !calculating ) begin
                        r=number; 
                        calculating<=1;
                        counter_operation<=6;         
                    end else if (counter_operation <=6 && calculating)begin
                        quo= r/powers_of_10[counter_operation];
                        digits[counter_operation]=quo;
                        r = r - quo*powers_of_10[counter_operation];               
                        if (counter_operation==0)calculating<=0;
                        else counter_operation<=counter_operation-1;
                    end
                           
                    
                end 
            
             end //end always
endmodule
