`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2024 19:24:20
// Design Name: 
// Module Name: HUD
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
module HUD(
input logic[9:0] h_count,v_count,
input logic[1:0] pacman_lifes,
input logic waiting,
output logic[11:0] rgb_HUD,
output logic HUD_drawing
    );
    logic[11:0] pacman_rom[20][20];
    logic[11:0] ready_rom[10][59];
    logic[11:0] score_rom[10][65];
    logic[11:0] level_rom[10][51];
    
    initial begin
        `include "../include/display_HUD.txt"
    end
    
    // Coordonnées de départ pour chaque image
        localparam int PACMAN_X_START = 180; 
        localparam int PACMAN_Y_START = 389; 
        localparam int PACMAN_SPACING= 30;
        
        localparam int READY_X_START = 290;  
        localparam int READY_Y_START = 240; 
          
        localparam int SCORE_X_START = 180;  
        localparam int SCORE_Y_START = 40; 
        
        localparam int LEVEL_X_START = 330;  
        localparam int LEVEL_Y_START = 389;

         
    //pacman
    always_comb begin
            rgb_HUD = 12'h0;
            HUD_drawing = 0;
            // pacman
            
            for(int i=0;i<pacman_lifes;i++)begin
                automatic int PACMAN_X= PACMAN_X_START + i* PACMAN_SPACING;
                if (h_count >= PACMAN_X && h_count < PACMAN_X + 20 &&
                    v_count >= PACMAN_Y_START && v_count < PACMAN_Y_START + 20) begin
                    
                    // Calculer l'index dans pacman_rom en fonction des coordonnées de h_count et v_count
                    automatic int x_index = h_count - PACMAN_X;
                    automatic int y_index = v_count - PACMAN_Y_START;
                    
                    // Assignation de la couleur de l'image au signal de sortie
                    rgb_HUD = pacman_rom[y_index][x_index];
                    HUD_drawing = 1;
                end
             end
                
//            if (h_count >= PACMAN_X_START && h_count < PACMAN_X_START + 20 &&
//                    v_count >= PACMAN_Y_START && v_count < PACMAN_Y_START + 20) begin
                    
//                    // Calculer l'index dans pacman_rom en fonction des coordonnées de h_count et v_count
//                    automatic int x_index = h_count - PACMAN_X_START;
//                    automatic int y_index = v_count - PACMAN_Y_START;
                    
//                    // Assignation de la couleur de l'image au signal de sortie
//                    rgb_HUD = pacman_rom[y_index][x_index];
//                    HUD_drawing = 1;
//            end
            //ready
            if (h_count >= READY_X_START && h_count < READY_X_START + 59 &&
                            v_count >= READY_Y_START && v_count < READY_Y_START + 10 && waiting) begin
                            
                automatic int x_index = h_count - READY_X_START;
                automatic int y_index = v_count - READY_Y_START;
                
                rgb_HUD = ready_rom[y_index][x_index];
                HUD_drawing = 1;
            
            end
            //score
            if (h_count >= SCORE_X_START && h_count < SCORE_X_START + 65 &&
                            v_count >= SCORE_Y_START && v_count < SCORE_Y_START + 10) begin
                            
                automatic int x_index = h_count - SCORE_X_START;
                automatic int y_index = v_count - SCORE_Y_START;
                
                rgb_HUD = score_rom[y_index][x_index];
                HUD_drawing = 1;
            end
            if (h_count >= LEVEL_X_START && h_count < LEVEL_X_START + 51 &&
                                            v_count >= LEVEL_Y_START && v_count < LEVEL_Y_START + 10) begin
                                            
                automatic int x_index = h_count - LEVEL_X_START;
                automatic int y_index = v_count - LEVEL_Y_START;
                
                rgb_HUD = level_rom[y_index][x_index];
                HUD_drawing = 1;
            end               
                            
//            end else begin
//                rgb_HUD = 12'h0;
//                HUD_drawing = 0;
//            end
               
            
        end
        
    
    
endmodule
