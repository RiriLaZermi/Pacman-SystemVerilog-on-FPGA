`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2024 18:46:12
// Design Name: 
// Module Name: ghost_state_machine
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
module ghost_state_machine(
input logic clk, reset,
input restart_ghosts,
input big_gum_eat,
input logic twinkle,
input logic in_housse,
input logic[4:0] ghost_xpos,ghost_ypos,
input logic[4:0] pacman_xpos,pacman_ypos,
input ghost_modes_t general_state,old_general_state,
output ghost_twinkle,
output ghost_modes_t ghost_state
    );
    
    //first state machine
    ghost_modes_t old_state, current_state, next_state;
    logic got_eaten,no_affraid;
    logic was_in_housse;
    //second state machine 
    
    enum logic {CAN_BE_EAT,CANT_BE_EAT} state, state_;
    
    
    assign ghost_state = current_state;
    assign ghost_twinkle = twinkle && (current_state==AFFRAID);
    //---------STATE MACHINE
    assign got_eaten = (pacman_xpos==ghost_xpos) && (pacman_ypos==ghost_ypos);
   //Transitions function
   always_comb begin
    case(current_state)
        SCATTER:begin
            if(in_housse)
                next_state<=SCATTER;
            else if ( general_state == AFFRAID && state==CAN_BE_EAT) //if we can be eat we go affraid
                next_state<=AFFRAID;
            else if(general_state == AFFRAID && state==CANT_BE_EAT)
                next_state<=SCATTER;
            else
                next_state<=general_state;
        end
        CHASE :begin
            if(in_housse)
                next_state<=CHASE;
            else if ( general_state == AFFRAID && state==CAN_BE_EAT) //if we can be eat we go affraid
                next_state<=AFFRAID;
            else if(general_state == AFFRAID && state==CANT_BE_EAT)
                next_state<=CHASE;
            else
                next_state<=general_state;
        end
        AFFRAID:begin
            if(got_eaten)
                next_state<=EATEN;
            else if(general_state != AFFRAID)
                next_state<=general_state;
            else
                next_state<=AFFRAID;              
        end
        EATEN:begin
                if(in_housse)begin
                    if(general_state==AFFRAID)
                        next_state<=old_general_state;
                else 
                    next_state<=general_state;             
            end else begin
                next_state<=EATEN;
            end
        end
        
    endcase
   end 
   
   
   
   //state machine register
    always_ff @(posedge clk or posedge reset)begin 
        if (reset || restart_ghosts) begin 
            current_state<=SCATTER;
        end else begin 
            current_state<=next_state;
            if (current_state != next_state) old_state<=current_state;
        end
    end
    
    //------SECOND STATE MACHINE
    //transistion function
    always_comb begin
        case(state)
            CAN_BE_EAT:begin
                if(current_state==EATEN)
                    state_<=CANT_BE_EAT;
                else
                    state_<=CAN_BE_EAT;
            end
            CANT_BE_EAT:begin
                if(big_gum_eat)
                    state_<=CAN_BE_EAT;
                else
                    state_<=CANT_BE_EAT;
            end
        endcase
    end
    
    //register state machine
    always_ff @(posedge clk or posedge reset)begin
        if (reset || restart_ghosts) begin
            state<=CANT_BE_EAT;
        end else begin
            state<=state_;
        end
    end
endmodule
