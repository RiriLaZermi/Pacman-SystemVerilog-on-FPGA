`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2024 01:58:49
// Design Name: 
// Module Name: vga_rgb
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
module vga_rgb(
input clk,
input reset,
input logic[11:0] rgb_walls,
input color_t rgb_pacman,rgb_dots,rgb_squares,rgb_picture,rgb_picture2,
rgb_blinky,rgb_pinky,rgb_inky,rgb_clyde,rgb_target,
input logic[11:0] rgb_HUD,rgb_score,
input logic pacman_drawing,dots_drawing,walls_drawing,squares_drawing,picture_drawing,picture2_drawing,
blinky_drawing,inky_drawing,pinky_drawing,clyde_drawing,target_drawing,HUD_drawing,score_drawing,

output logic[11:0] rgb_out

    );
    //force rgb = 0 during 3s
    int counter_time;
    logic[11:0] rgb_mask;
    logic[11:0] rgb;
    always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            counter_time<=0;
            rgb_mask<=BLACK;
        end else begin
            if(counter_time<3 * 25_000_000)begin
                counter_time<=counter_time+1;
                rgb_mask <= 12'h000; // force rgb_out to 0
            end else rgb_mask <= 12'hFFF; //rgb_out = rgb_in
        end
    end
    
    //Multiplexeur
    always_comb begin
        if(pacman_drawing) rgb<=rgb_pacman;
        else if (blinky_drawing) rgb<=rgb_blinky;
        else if (pinky_drawing) rgb<=rgb_pinky;
        else if (inky_drawing) rgb<=rgb_inky;
        else if (clyde_drawing) rgb<=rgb_clyde;
        else if (target_drawing) rgb<=rgb_target;
        else if (dots_drawing) rgb<=rgb_dots;
        else if (HUD_drawing) rgb<=rgb_HUD;
        else if (score_drawing) rgb<=rgb_score;
        else if (walls_drawing) rgb<=rgb_walls;
        else if (squares_drawing) rgb<=rgb_squares;
        else if (picture_drawing) rgb<=rgb_picture;
        else if (picture2_drawing) rgb<=rgb_picture2;
        else rgb<=BLACK;
    end
    assign rgb_out = rgb & rgb_mask;
endmodule
