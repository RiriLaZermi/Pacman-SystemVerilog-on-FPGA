`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2024 01:56:36
// Design Name: 
// Module Name: pacman_parameters
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

module pacman_parameters(
input logic clk,
input logic reset,
input logic pause,
input logic restart_pacman,
input direction_t dirController,
output logic [4:0] x_pos_pframe,
output logic [4:0] y_pos_pframe,
output logic [9:0] x_pos_sframe,
output logic [9:0] y_pos_sframe,
output direction_t dir
    );
    localparam CLOCK_FREQ = 25_000_000;
    //Signals
    logic [8:0] x_pos_pframe_pixel,y_pos_pframe_pixel;
    logic can_up,can_right,can_left,can_down;
    
    localparam int pixel_per_seconde = 75; 
    localparam int counter_pos_max = CLOCK_FREQ * (1.0/ pixel_per_seconde); 
    
        
    
    //-------x_pos y_pos----------
    localparam scaling = 10;
    assign x_pos_pframe = x_pos_pframe_pixel/scaling;
    assign y_pos_pframe = y_pos_pframe_pixel/scaling;
    
    //Colision Init
    colision_detection pac_colision(.x_pos_pixel(x_pos_pframe_pixel),
    .y_pos_pixel(y_pos_pframe_pixel),
    .can_up(can_up),
    .can_right(can_right),
    .can_left(can_left),
    .can_down(can_down));
    
    //Frame converter
     frame_converter frame_conv(.x_frame_in(x_pos_pframe_pixel),
    .y_frame_in(y_pos_pframe_pixel),
    .x_frame_out(x_pos_sframe),
    .y_frame_out(y_pos_sframe));
    
    //position controller
    logic[31:0] compteur_pos;
    always_ff @(posedge clk or posedge reset)begin
        if (reset) compteur_pos<=0;
        else if (!pause) begin
            if (compteur_pos == counter_pos_max) compteur_pos<=0;
            else compteur_pos<=compteur_pos+1;
            
        end
    end        
    
    //pixel
    always_ff @(posedge clk or posedge reset)begin
        if (reset || restart_pacman)begin
            x_pos_pframe_pixel<=140;
            y_pos_pframe_pixel<=75; 
        end else if (!pause) begin         
            if (compteur_pos==1)begin 
                if (dir==LEFT && can_left) begin
                    if(x_pos_pframe_pixel==0) x_pos_pframe_pixel=280;
                    else x_pos_pframe_pixel--;               
                end 
                if (dir==RIGHT && can_right) begin
                   if(x_pos_pframe_pixel==280) x_pos_pframe_pixel=0;
                   else x_pos_pframe_pixel++;
                end 
                if (dir==UP && can_up) begin
                    y_pos_pframe_pixel++;
                end 
                if (dir==DOWN && can_down) begin
                    y_pos_pframe_pixel--;
                end
                  
            end 
        end
    end
    //DIR
    always_ff @(posedge clk) begin
        if (!pause) begin
            if (dirController==IDLE) dir=IDLE;
            if (dirController==LEFT && can_left) begin
                dir=LEFT;
            end 
            if (dirController==RIGHT && can_right) begin
                dir=RIGHT;
            end 
            if (dirController==UP && can_up) begin
                dir=UP;
            end 
            if (dirController==DOWN && can_down) begin
                dir=DOWN;
            end
        end
    end   
   
    
    
    
endmodule
