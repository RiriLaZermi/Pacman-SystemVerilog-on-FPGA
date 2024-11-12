`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2024 00:47:09
// Design Name: 
// Module Name: dots
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
module dots_display_logic(
input logic clk,
input logic reset,
input logic restart_dots,
input logic[4:0] x_pac,
input logic[4:0] y_pac,
input logic[9:0] h_count,
input logic[9:0] v_count,
output color_t rgb,
output int points_counter,
output logic big_gum_eat,
output logic dots_drawing,
output logic all_dots_eat
    );
    localparam x_offset=180;
    localparam y_offset=379;
    localparam scaling = 10;
    
    logic[0:27] is_dot_tab[0:30];
    logic[0:27] is_dot[0:30];
    logic[3:0] is_big_dot;
    logic pacman_field;
    logic[5:0] x_cord,y_cord;
    logic [9:0] x_rect_corner,y_rect_corner,x_rect_center,y_rect_center;
    
    //signal
    logic finish_init;
    logic[4:0] counter_init;
    
    
    initial begin
        `include "../include/dots_init.txt"  
                                        
    end 
    
    always_comb begin
        all_dots_eat=1;
        for(int i=0;i<31;i++)begin //first verif
            if(is_dot[i]!=0)begin
                all_dots_eat=0;
                break;
            end
        end
        
        if(is_big_dot !=0) all_dots_eat=0; //second verif
           
    end

    always_ff @(posedge clk or posedge reset)begin
        if (reset)begin
            is_big_dot<=4'b1111;
            big_gum_eat<=0; 
            finish_init<=0;
            counter_init<=0;
            points_counter<=0;       
        end else if (restart_dots) begin
            finish_init<=0;
            counter_init<=0;
            is_big_dot<=4'b1111;
            big_gum_eat<=0;
        end else begin
            if (!finish_init)begin //Initialisation is_dot after reset
                if (counter_init==30) finish_init<=1;
                is_dot[counter_init]<=is_dot_tab[counter_init];
                counter_init<=counter_init+1;
                
            end else if (finish_init)begin //if pacman walk on a dot +10 and the dot disapear
            big_gum_eat=0;
                if (is_dot[y_pac][x_pac])begin
                    is_dot[y_pac][x_pac]<=0;
                    points_counter<=points_counter+10;
                //else if for big dots
                end else if (y_pac==7 && x_pac==1 && is_big_dot[0]  ) begin 
                    big_gum_eat=1;
                    is_big_dot[0]=0;       
                end else if (y_pac==27 && x_pac==1 && is_big_dot[1] ) begin
                    big_gum_eat=1; 
                    is_big_dot[1]=0;
                end else if (y_pac==7 && x_pac==26 && is_big_dot[2] ) begin
                    big_gum_eat=1; 
                    is_big_dot[2]=0;
                end else if (y_pac==27 && x_pac==26 && is_big_dot[3] ) begin 
                    big_gum_eat=1;
                    is_big_dot[3]=0;
                end
            end
        end
    end
        
    assign pacman_field = (h_count>=180 && h_count<460) && (v_count>=70 && v_count<380);
    
    always_latch begin
        if (reset) begin 
            dots_drawing<=0;
        end else if(finish_init) begin  
            dots_drawing<=0;        
            if (pacman_field) begin          
                x_cord = (h_count-x_offset)/scaling;
                y_cord = (y_offset-v_count)/scaling;
                
                x_rect_center = x_offset + x_cord * scaling+5;
                y_rect_center = y_offset - y_cord * scaling -5;
                if (is_dot[y_cord][x_cord]) begin
                    x_rect_corner = x_offset + x_cord * scaling;
                    y_rect_corner = y_offset - y_cord * scaling;
     
                    if ( (h_count>= x_rect_corner +4) && (h_count<= x_rect_corner +5)
                    && (v_count <= y_rect_corner -4) && (v_count >=y_rect_corner -5)) begin
                        dots_drawing<=1;
                        
                        rgb<=PINK;
                    end else begin                     
                        rgb<=BLACK;   
                    end              
                end else if (y_cord==7 && x_cord==1 )begin    
                    if(is_big_dot[0])begin
                        if( (h_count-x_rect_center)**2 + (v_count-y_rect_center)**2 <= 20)begin
                            rgb<=PINK;
                            dots_drawing<=1;
                        end else rgb<=BLACK;
                    end    
                end else if (y_cord==27 && x_cord==1 ) begin                 
                    if(is_big_dot[1])begin
                        if( (h_count-x_rect_center)**2 + (v_count-y_rect_center)**2 <= 20)begin
                            rgb<=PINK;
                            dots_drawing<=1;
                        end else rgb<=BLACK;
                    end  
                end else if (y_cord==7 && x_cord==26 ) begin 
                    if(is_big_dot[2])begin                       
                        if( (h_count-x_rect_center)**2 + (v_count-y_rect_center)**2 <= 20)begin
                            rgb<=PINK;
                            dots_drawing<=1;
                        end else rgb<=BLACK;
                    end  
                end else if (y_cord==27 && x_cord==26 ) begin 
                    if(is_big_dot[3])begin
                        if( (h_count-x_rect_center)**2 + (v_count-y_rect_center)**2 <= 20)begin
                            rgb<=PINK;
                            dots_drawing<=1;
                        end else rgb<=BLACK;
                    end  
                end                                   
            end
           
        end

    end
    
       
endmodule
