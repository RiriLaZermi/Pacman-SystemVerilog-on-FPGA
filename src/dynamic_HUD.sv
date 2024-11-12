`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2024 01:55:09
// Design Name: 
// Module Name: dynamic_HUD
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


module SCORE_LEVEL_HUD(
input logic clk,reset,
input logic[9:0] h_count,
input logic[9:0] v_count,
input int score1,score2,level,
output logic[11:0] rgb,
output logic drawing
    );
    //parameter
    localparam SCORE_X_START=250;
    localparam SCORE_Y_START=40; 
    
    localparam LEVEL_X_START=385;
    localparam LEVEL_Y_START=389; 
    
    localparam SPACING=15;
    //signals
    int score;
   
        
    logic[3:0] score_digits[7];
    logic[3:0] level_digits[7];
    logic[11:0] digit_0[10][10];
    logic[11:0] digit_1[10][10];
    logic[11:0] digit_2[10][10];
    logic[11:0] digit_3[10][10];
    logic[11:0] digit_4[10][10];
    logic[11:0] digit_5[10][10];
    logic[11:0] digit_6[10][10];
    logic[11:0] digit_7[10][10];
    logic[11:0] digit_8[10][10];
    logic[11:0] digit_9[10][10];
    //
    int_to_7digit score_converter(.clk(clk),
    .reset(reset),
    .number(score),
    .digits(score_digits));
    
    int_to_7digit level_converter(.clk(clk),
    .reset(reset),
    .number(level),
    .digits(level_digits));
        

    
    //Logic
    initial begin
        `include "../include/numbers.txt"
        
    end
    
    assign score = score1 + score2;
    
    //signals 
    logic[2:0] score_x_shift,level_x_shift;
    logic score_leading_zero,level_leading_zero;
    always_comb begin
        //default
        score_x_shift=0;
        score_leading_zero=1;
        level_x_shift=0;
        level_leading_zero=1;
        rgb=0;
        drawing=0;
        
        //score  
        for (int i=0; i<7;i++)begin
            if ( score_digits[6-i]!=0 || !score_leading_zero || i==6)begin // if the digits is a non zero OR we already have a non zero digit OR we are in the last digit
                automatic int SCORE_X = SCORE_X_START  + score_x_shift * SPACING;
                
                score_leading_zero=0;
                if (h_count>= SCORE_X && h_count< SCORE_X +10
                    && v_count>=SCORE_Y_START && v_count<SCORE_Y_START+10)begin
                    
                    automatic int x_index = h_count - SCORE_X;
                    automatic int y_index = v_count - SCORE_Y_START;
                    automatic logic[11:0] digit_print[10][10];
                    case (score_digits[6-i])
                        4'd0: digit_print = digit_0;
                        4'd1: digit_print = digit_1;
                        4'd2: digit_print = digit_2;
                        4'd3: digit_print = digit_3;
                        4'd4: digit_print = digit_4;
                        4'd5: digit_print = digit_5;
                        4'd6: digit_print = digit_6;
                        4'd7: digit_print = digit_7;
                        4'd8: digit_print = digit_8;
                        4'd9: digit_print = digit_9;
                        default : digit_print = digit_0;
                    endcase
                    
                    rgb=digit_print[y_index][x_index];
                    drawing=1;             
                end
                score_x_shift = score_x_shift + 1;
            end
        end//endfor
        
        //level       
        for (int i=0; i<7;i++)begin
            if ( level_digits[6-i]!=0 || !level_leading_zero || i==6)begin // if the digits is a non zero OR we already have a non zero digit OR we are in the last digit
                automatic int LEVEL_X = LEVEL_X_START  + level_x_shift * SPACING;
                
                level_leading_zero=0;
                if (h_count>= LEVEL_X && h_count< LEVEL_X +10
                    && v_count>=LEVEL_Y_START && v_count<LEVEL_Y_START+10)begin
                    
                    automatic int x_index = h_count - LEVEL_X;
                    automatic int y_index = v_count - LEVEL_Y_START;
                    automatic logic[11:0] digit_print[10][10];
                    case (level_digits[6-i])
                        4'd0: digit_print = digit_0;
                        4'd1: digit_print = digit_1;
                        4'd2: digit_print = digit_2;
                        4'd3: digit_print = digit_3;
                        4'd4: digit_print = digit_4;
                        4'd5: digit_print = digit_5;
                        4'd6: digit_print = digit_6;
                        4'd7: digit_print = digit_7;
                        4'd8: digit_print = digit_8;
                        4'd9: digit_print = digit_9;
                        default : digit_print = digit_0;
                    endcase
                    
                    rgb=digit_print[y_index][x_index];
                    drawing=1;             
                end
                level_x_shift = level_x_shift + 1;
            end
        end//endfor
        
    end
    
    
        
         
          
    
    
endmodule
