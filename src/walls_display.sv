`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2024 01:04:35
// Design Name: 
// Module Name: walls_display
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
// set_param synth.elaboration.rodinMoreOptions "rt::set_parameter var_size_limit 4194304" for error
import utils::*;
module walls_display(
input logic[9:0] h_count,
input logic[9:0] v_count,
output logic[11:0] rgb,
output logic walls_drawing
    );
    //param
    localparam x_offset=180;//180
    localparam y_offset=70;//70
    //Signals
    logic[11:0] rom[310][280];
    logic[8:0] row,col;
    
    logic pacman_field;
    //
    assign pacman_field = (h_count>=180 && h_count<460) && (v_count>=70 && v_count<380);
//    assign pacman_field = (h_count>=0 && h_count<280) && (v_count>=0 && v_count<310);
    
    initial begin
//        `include "rom_init.txt"
        `include "../include/rom_init_pacman_map.txt"
    end
    
    
    always_latch begin
        walls_drawing<=0;
        rgb<=BLACK;
        if(pacman_field)begin
            col=h_count-x_offset;
            row=v_count-y_offset;
            if (rom[row][col])begin
                rgb<=rom[row][col];
                walls_drawing<=1;
            end          
        end
    end
    
    
    
endmodule
