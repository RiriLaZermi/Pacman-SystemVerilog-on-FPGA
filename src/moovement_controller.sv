`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2024 21:33:51
// Design Name: 
// Module Name: moovement_controller
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
module moovement_controller(
input logic clk,
input restart,
input logic reset,
input logic up,right,down,left,
output direction_t dir

    );
    always_ff @(posedge clk or posedge reset)begin
        if (reset || restart) begin
            dir = IDLE;
        end else begin
            if (right) dir=RIGHT; //On appuie que une fois pour tourner dans la bonne direction
            if (left) dir=LEFT;  //Une direction a la fois
            if (up) dir=UP;
            if (down) dir=DOWN;
        end
    end
    
endmodule
