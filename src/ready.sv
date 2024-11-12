`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2024 02:15:52
// Design Name: 
// Module Name: ready
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


module ready(
input logic clk,reset,pause,loose_game,restart_pacman,
input logic up,right,down,left,
output logic ready,waiting
    );
    logic first_one;
    always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            ready<=0;
            first_one<=1;
        end else begin
            if(pause && !loose_game)begin 
                if ( right || left) ready<=1;
            end else 
                ready=0;
            
            if((restart_pacman || first_one) && pause)begin
                waiting<=1;
                first_one<=0;
            end else if (ready)begin
                waiting<=0;
            end
            
        end
    end
endmodule
