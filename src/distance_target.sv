`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 16:02:20
// Design Name: 
// Module Name: distance_target
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


module distance_target(
input logic[9:0] target_loc,
input logic [4:0] x_pos,y_pos,
output logic[10:0] r_dist,l_dist,u_dist,d_dist

    );
    logic[4:0] x_target,y_target;
    always_comb begin
        x_target=target_loc[4:0];
        y_target=target_loc[9:5];
        
        r_dist = (x_target-(x_pos+1))**2 + (y_target-y_pos)**2;
        l_dist = (x_target-(x_pos-1))**2 + (y_target-y_pos)**2;
        u_dist = (x_target-x_pos)**2 + (y_target-(y_pos+1))**2;
        d_dist = (x_target-x_pos)**2 + (y_target-(y_pos-1))**2;
        
    end
    
endmodule
