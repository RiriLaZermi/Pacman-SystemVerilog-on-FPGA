`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.10.2024 14:33:10
// Design Name: 
// Module Name: score_printer_fpga
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


module score_printer_fpga(
input logic clk,
input logic reset,
input int points_counter,
output logic[6:0] SEG,
output logic[7:0] AN

    );
    localparam CLOCK_FREQ = 25_000_000;
    localparam counter_limit_500Hz = CLOCK_FREQ/1000 - 1;
    //--
    logic[4:0] counter_operation;
    logic [3:0] counter_digits; 
    logic calculating;
    logic[4:0] quo;
    int r;
    logic[4:0] digits[7];
    
    
    logic [31:0] powers_of_10 [6:0] = '{1_000_000, 100_000, 10_000, 1_000, 100, 10, 1};
    logic[6:0] seg_value[10]='{
    7'b0111111, // 0 : a, b, c, d, e, f (segments activ�s pour le chiffre 0)
    7'b0000110, // 1 : b, c (segments activ�s pour le chiffre 1)
    7'b1011011, // 2 : a, b, d, e, g (segments activ�s pour le chiffre 2)
    7'b1001111, // 3 : a, b, c, d, g (segments activ�s pour le chiffre 3)
    7'b1100110, // 4 : b, c, f, g (segments activ�s pour le chiffre 4)
    7'b1101101, // 5 : a, c, d, f, g (segments activ�s pour le chiffre 5)
    7'b1111101, // 6 : a, c, d, e, f, g (segments activ�s pour le chiffre 6)
    7'b0000111, // 7 : a, b, c (segments activ�s pour le chiffre 7)
    7'b1111111, // 8 : a, b, c, d, e, f, g (segments activ�s pour le chiffre 8)
    7'b1101111 // 9 : a, b, c, d, f, g (segments activ�s pour le chiffre 9)      
    };
     //-------------------Clock for digits
        int counter;
        logic clk_digits;
        always_ff @(posedge clk or posedge reset) begin
           if (reset) begin
             counter <= 0;
             clk_digits <= 0;
           end else begin
             if (counter == counter_limit_500Hz) begin // counter = CLK_FREQ / (2*target_freq)  // target_freq = 500 Hz
               counter <= 0;
               clk_digits <= ~clk_digits;  
             end else begin
               counter <= counter + 1;
             end
           end
         end
    
   
    always_ff @(posedge clk_digits or posedge reset)begin
        if(reset)begin
            counter_operation<=0;
            quo<=0;
            r<=0; 
            calculating<=0;
            for (int i =0;i<7;i++) digits[i]=0;
        end else begin
            if (counter_operation==0  && !calculating ) begin
                r=points_counter; 
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
    
    end 

  
    always_ff @(posedge clk_digits or posedge reset)begin
        if(reset) counter_digits<=0;
        else begin
            if(counter_digits==6) counter_digits<=0;
            else counter_digits<=counter_digits+1;           
       end
           
    end
    

    assign SEG = ~seg_value[digits[counter_digits]];
    assign AN= ~(1<<counter_digits);
//    assign AN = 0;

    
    
endmodule
