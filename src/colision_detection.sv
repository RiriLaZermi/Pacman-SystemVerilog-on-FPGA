`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2024 19:52:44
// Design Name: 
// Module Name: colision_detection
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


module colision_detection(
input logic[8:0] x_pos_pixel,
input logic[8:0] y_pos_pixel,
output logic can_left,
output logic can_right,
output logic can_up,
output logic can_down
    );
    //signals
    logic[4:0] x_mod,y_mod;
     //-------x_pos y_pos----------
    localparam scaling = 10;
    localparam futur_offset = 6;
    
    logic is_wall[31][28];
    initial begin
        `include "../include/walls_init.txt"
        
    end
    always_comb begin;
        x_mod = x_pos_pixel%scaling;
        y_mod = y_pos_pixel%scaling;
        if(y_mod>=4 && y_mod<=5)begin
            //LEFT
            if( !is_wall[ (y_pos_pixel)/scaling] [(x_pos_pixel-futur_offset)/scaling]) can_left=1;
            else can_left=0;
            //RIGHT
            if( !is_wall[ (y_pos_pixel)/scaling] [(x_pos_pixel+futur_offset)/scaling] ) can_right=1;
            else can_right=0;
        end else begin
            can_left=0;
            can_right=0;
        end
        if(x_mod>=4 && x_mod<=5)begin
            //UP
            if( !is_wall[ (y_pos_pixel+futur_offset)/scaling] [(x_pos_pixel)/scaling]) can_up=1;
            else can_up=0;
            //DOWN
            if( !is_wall[ (y_pos_pixel-futur_offset)/scaling] [(x_pos_pixel)/scaling] ) can_down=1;
            else can_down=0;
        end else begin
            can_up=0;
            can_down=0; 
        end
            
    end 
    
    
   
    
    
endmodule
