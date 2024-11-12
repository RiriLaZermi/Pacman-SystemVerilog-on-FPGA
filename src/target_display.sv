`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2024 19:17:54
// Design Name: 
// Module Name: target_display
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

import utils::*;

module target_display(
input logic[9:0] target_blinky,target_pinky,target_inky,target_clyde,
input logic[9:0] h_count,v_count,
output color_t rgb_target,
output logic target_drawing
    );
    
    //param
    localparam x_offset=180;
    localparam y_offset=379;
    logic[8:0] row,col;
    logic pacman_field;
    assign pacman_field = (h_count>=180 && h_count<460) && (v_count>=70 && v_count<380);
    //---Signals 

   
    
    always_latch begin
        target_drawing<=0;
        if(pacman_field)begin
            col=(h_count-x_offset)/10;
            row=(y_offset-v_count)/10;
            if(row==target_blinky[9:5] && col==target_blinky[4:0]) begin
                target_drawing<=1;
                rgb_target<=RED;
            end 
            
            if(row==target_pinky[9:5] && col==target_pinky[4:0]) begin
                target_drawing<=1;
                rgb_target<=PINK;
            end 
            
            if(row==target_inky[9:5] && col==target_inky[4:0]) begin
                target_drawing<=1;
                rgb_target<=CYAN;
            end 
            
            if(row==target_clyde[9:5] && col==target_clyde[4:0]) begin
                target_drawing<=1;
                rgb_target<=ORANGE;
            end       
        end
    end
endmodule
 
