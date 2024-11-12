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

module ghost_parameters(
input logic clk,
input logic reset,
input logic pause,
input logic restart_ghosts,
input logic[9:0] target_loc,
input logic leave_housse,//on when ghost can leave ghost housse
output logic in_housse, //in housse
input ghost_modes_t ghost_state,
output logic [4:0] x_pos_pframe,
output logic [4:0] y_pos_pframe,
output logic [9:0] x_pos_sframe,
output logic [9:0] y_pos_sframe,
output direction_t dir
    );
    parameter logic[8:0] x_base=15;
    parameter logic[8:0] y_base=15;
    parameter logic[15:0] LSFR_SEED=1;
    localparam CLOCK_FREQ = 25_000_000;
    //Signals
    logic [8:0] x_pos_pframe_pixel,y_pos_pframe_pixel;
    logic[3:0] tmp1,tmp2;
    logic[10:0] r_dist,u_dist,l_dist,d_dist;
    logic[9:0] right_dist,up_dist,left_dist,down_dist; //if the distance is invalid we put them to max
    logic[9:0] min_01,min_23;
    logic[1:0] index_01,index_23,index_min;
    logic[3:0] dir_available,old_dir_available; //left up right down
    logic[1:0] dir_available_index[4];
    direction_t old_dir;
    logic waiting_dir;
    
    logic[1:0] random_n;
    
    int new_dir_counter;
    
    int pixel_per_seconde;
    int counter_pos_max,previous_counter_pos_max; 
//     localparam counter_pos_max = 50_000_000/40; 
   
   
    colision_detection pac_colision(.x_pos_pixel(x_pos_pframe_pixel),
    .y_pos_pixel(y_pos_pframe_pixel),
    .can_up(can_up),
    .can_right(can_right),
    .can_left(can_left),
    .can_down(can_down));
    
    distance_target dist_(.target_loc(target_loc),
    .x_pos(x_pos_pframe),
    .y_pos(y_pos_pframe),
    .r_dist(r_dist),
    .u_dist(u_dist),
    .d_dist(d_dist),
    .l_dist(l_dist));
    
    //Frame converter
     frame_converter frame_conv(.x_frame_in(x_pos_pframe_pixel),
    .y_frame_in(y_pos_pframe_pixel),
    .x_frame_out(x_pos_sframe),
    .y_frame_out(y_pos_sframe));
    
    //random direction gen
     two_bits_random_gen #(.SEED(LSFR_SEED)) random_dir_gen(.clk(clk),
     .reset(reset),
     .random(random_n));
 
    
     //-------x_pos y_pos----------                   
     localparam scaling = 10;                         
     assign x_pos_pframe = x_pos_pframe_pixel/scaling;
     assign y_pos_pframe = y_pos_pframe_pixel/scaling;
     
     
     //invalid distance
    always_ff @(posedge clk or posedge reset) begin
        if(reset || restart_ghosts)begin
            tmp1=4'h0; 
            tmp2=4'h0; 
            dir=IDLE;
            new_dir_counter=0;
            waiting_dir=0;
            dir_available<=0;
            in_housse<=0;           
            for(int i=0;i<4;i++)dir_available_index[i]=0;
        end else if (!pause) begin
            if(waiting_dir)begin //if we change dir we wait ghost moove 5 pixels
                new_dir_counter++;
                if(new_dir_counter==5* (GHOST_SPEED[0]) )begin //cconstant value counter_pos max
                    new_dir_counter<=0;
                    waiting_dir=0;
                end   
            end else if( x_pos_pframe_pixel == 145 && (y_pos_pframe<=19 && y_pos_pframe>=16) && ghost_state==EATEN)begin
                dir<=DOWN; //go back to ghoust housse
                if(y_pos_pframe == 16) in_housse=1;   
                else in_housse=0;
            end else if( x_pos_pframe>=11 && x_pos_pframe<=16 && y_pos_pframe>=15 && y_pos_pframe<=18) begin //if we are in ghost housse  
                if(x_pos_pframe>=11 && x_pos_pframe<=16 && y_pos_pframe>=15 && y_pos_pframe<=17) in_housse=1;         
                if(y_pos_pframe==15) dir=UP;
                else if(y_pos_pframe==17 || y_pos_pframe==18)begin 
                    if(leave_housse)begin
                        if(x_pos_pframe==12)dir=RIGHT;
                        if(x_pos_pframe_pixel==140)dir=UP;
                        if(x_pos_pframe==16)dir=LEFT;                        
                    end else begin 
                        dir=DOWN;
                    end      
                end        
            end else begin
                old_dir=dir;
                old_dir_available=dir_available;
                in_housse=0;
                //available dir algo
                case(dir)
                    LEFT:begin tmp1=4'b1101;end
                    UP : begin tmp1=4'b1110;end
                    RIGHT :begin tmp1=4'b0111;end
                    DOWN : begin tmp1=4'b1011;end
                    default: begin tmp1=4'b1111;end
                endcase
                
                tmp2={can_left,can_up,can_right,can_down};
                
                dir_available= tmp2 & tmp1;
                           
                if( ghost_state != AFFRAID)begin
                    if(dir_available[3]) left_dist=l_dist;
                    else left_dist=10'h3FF;//left
                    
                    if(dir_available[2]) up_dist=u_dist;
                    else up_dist=10'h3FF;//up
                    
                    if(dir_available[1]) right_dist=r_dist;
                    else right_dist=10'h3FF;//right
                    
                    if(dir_available[0]) down_dist=d_dist;
                    else down_dist=10'h3FF;//down
                    
                             
                    
                    //min algo
                    if (left_dist < up_dist)begin 
                        min_01 = left_dist; 
                        index_01 =2'b00;
                    end else begin 
                        min_01 = up_dist;
                        index_01 = 2'b01;
                    end
                    
                    
                    if (right_dist < down_dist)begin 
                        min_23 = right_dist; 
                        index_23 =2'b10;
                    end else begin 
                        min_23= down_dist;
                        index_23 = 2'b11;
                    end
                    
                    if(min_01<=min_23)begin
                        index_min=index_01;
                    end else begin 
                        index_min=index_23;
                    end
                    
                    
                    case(index_min)
                            2'b00:dir=LEFT; 
                            2'b01:dir=UP;                       
                            2'b10:dir=RIGHT;
                            2'b11:dir=DOWN; 
                    endcase   
                    
                    if (dir != old_dir) begin
                        waiting_dir=1; 
                        old_dir=dir;
                    end
                    
                end else begin
                    
                    if(dir_available != old_dir_available)begin
                        automatic logic[2:0] count=0;
                        for(int i=0;i<4;i++)begin 
                            if(dir_available[3-i])begin
                                dir_available_index[count]=i;
                                count++;
                            end
                        end  
                                     
                        if(count>0)begin
                            case(dir_available_index[random_n%count])
                                0:dir=LEFT;
                                1:dir=UP;
                                2:dir=RIGHT;
                                3:dir=DOWN;
                            endcase
                        end
                        if (dir != old_dir) begin
                            waiting_dir=1; 
                            old_dir=dir;
                        end
                     end   
                    
                end
             end 
         end     
    end
    //------ghost speed-------
     localparam int GHOST_SPEED[3]={CLOCK_FREQ/60,CLOCK_FREQ /30,CLOCK_FREQ /100}; //reduce slack
    
    //position controller
    logic[31:0] compteur_pos;
    always_ff @(posedge clk or posedge reset)begin
        if (reset || restart_ghosts ) 
            compteur_pos<=0;
        else if (!pause) begin
            previous_counter_pos_max = counter_pos_max;
            case(ghost_state)
                            SCATTER:counter_pos_max=GHOST_SPEED[0];
                            CHASE:counter_pos_max=GHOST_SPEED[0];
                            AFFRAID:counter_pos_max=GHOST_SPEED[1];
                            EATEN:counter_pos_max=GHOST_SPEED[2];
            endcase         
            if(previous_counter_pos_max != counter_pos_max) 
                compteur_pos<=0;   
            else if (compteur_pos == counter_pos_max ) 
                compteur_pos<=0;
            else 
                compteur_pos<=compteur_pos+1;
            
        end
    end      
     
    always_ff @(posedge clk or posedge reset)begin
        if (reset || restart_ghosts)begin
            x_pos_pframe_pixel<=x_base;
            y_pos_pframe_pixel<=y_base;
        end else if (!pause) begin 
        
            if(compteur_pos==1) begin 
               if (dir==LEFT) begin
                if(x_pos_pframe_pixel==0) x_pos_pframe_pixel=280;
                else x_pos_pframe_pixel--;
               end else if(dir==RIGHT)begin
                 if(x_pos_pframe_pixel==280) x_pos_pframe_pixel=0;
                 else x_pos_pframe_pixel++;
               end else if(dir==UP)begin
                y_pos_pframe_pixel++;
               end else if(dir==DOWN)begin
                 y_pos_pframe_pixel--;      
               end       
            end 
            
        end
    end
   
   
    
    
    
endmodule
