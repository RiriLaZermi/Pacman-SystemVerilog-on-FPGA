`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2024 23:05:47
// Design Name: 
// Module Name: Sound_controller
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
module Sound_controller(
input logic clk, reset,
input logic clk100MHz,
input logic restart,
input logic pause,
input logic[9:0] pacman_xpos_sframe,pacman_ypos_sframe,
input logic[4:0] pacman_xpos_pframe,pacman_ypos_pframe, 
input logic[4:0] blinky_xpos,blinky_ypos,
input logic[4:0] clyde_xpos,clyde_ypos,
input logic[4:0] pinky_xpos, pinky_ypos,
input logic[4:0] inky_xpos, inky_ypos,
input ghost_modes_t blinky_state,inky_state,pinky_state,clyde_state,
output logic wave
    );
    logic off1,off2,off3,off4,off5,off6,off7;
    logic[9:0] last_pacman_xpos_sframe,last_pacman_ypos_sframe;
    
    //instance
    dual_sound_mixer mixer(.clk(clk),
    .reset(reset),
    .off1(off1),
    .off2(off2),
    .off3(off3),
    .off4(off4),
    .off5(off5),
    .off6(off6),
    .off7(off7),
    .combined_wave(wave));
    
//    ila_0 ilaa(.clk(clk100MHz),
//    .probe0(off1),
//    .probe1(off2),
//    .probe2(off3),
//    .probe3(off4),
//    .probe4(off5),
//    .probe5(off6),
//    .probe6(off7)
//    );
    
    
    //moove sound
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            last_pacman_xpos_sframe<=pacman_xpos_sframe;
            last_pacman_ypos_sframe<=pacman_ypos_sframe;
            off1=1;
        end else begin
            last_pacman_xpos_sframe <= pacman_xpos_sframe;
            last_pacman_ypos_sframe <= pacman_ypos_sframe;
            if ( !restart && ((last_pacman_xpos_sframe != pacman_xpos_sframe) || (last_pacman_ypos_sframe !=pacman_ypos_sframe)))
                off1=0;
            else
                off1=1;
        end
    end
    
    //affraid sound
    always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            off2=1;
        end else begin
            if (blinky_state == AFFRAID || inky_state == AFFRAID || pinky_state == AFFRAID || clyde_state == AFFRAID)
                off2=0;
            else
                off2=1;
        end
    end
    
    //pacman get eat sound
    always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            off3<=1;
        end else begin
             if (!pause)begin
                if((blinky_state == SCATTER) || (blinky_state == CHASE))begin 
                    if ((pacman_xpos_pframe == blinky_xpos) && (pacman_ypos_pframe == blinky_ypos))begin
                        off3<=0;
                    end
                end
                if(pinky_state == SCATTER || pinky_state == CHASE)begin
                    if (pacman_xpos_pframe == pinky_xpos && pacman_ypos_pframe == pinky_ypos)begin
                        off3<=0;
                    end
                end
                if(inky_state == SCATTER || inky_state == CHASE)begin
                    if (pacman_xpos_pframe == inky_xpos && pacman_ypos_pframe == inky_ypos)begin
                        off3<=0;
                    end
                end
                if(clyde_state == SCATTER || clyde_state == CHASE)begin
                    if (pacman_xpos_pframe == clyde_xpos && pacman_ypos_pframe == clyde_ypos)begin
                        off3<=0;
                    end
                end
                    
             end else begin
                if (!off3) off3<=1;
             end
                        
            
        end
    end
    
    
    //pacman eat ghost sound
    
    always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            off4<=1;
            off5<=1;
            off6<=1;
            off7<=1;
        end else begin
            if (pacman_xpos_pframe==blinky_xpos && pacman_ypos_pframe==blinky_ypos && blinky_state==AFFRAID) off4<=0;
            else if (!off4) off4=1; 
            if (pacman_xpos_pframe==inky_xpos && pacman_ypos_pframe==inky_ypos && inky_state==AFFRAID) off5<=0;
            else if (!off5) off5=1;
            if (pacman_xpos_pframe==pinky_xpos && pacman_ypos_pframe==pinky_ypos && pinky_state==AFFRAID) off6<=0;
            else if (!off6) off6=1;
            if (pacman_xpos_pframe==clyde_xpos && pacman_ypos_pframe==clyde_ypos && clyde_state==AFFRAID) off7<=0;
             else if (!off7) off7=1;
        end
     end
    
    
    
endmodule
