`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2024 22:53:29
// Design Name: 
// Module Name: frame_converter
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


module frame_converter(
input logic [8:0] x_frame_in,
input logic [8:0] y_frame_in,
output logic [9:0] x_frame_out,
output logic [9:0] y_frame_out
    );
    localparam x_origin = 180;
    localparam y_origin = 379;
    assign x_frame_out = x_origin + x_frame_in;
    assign y_frame_out = y_origin - y_frame_in;
    
endmodule
