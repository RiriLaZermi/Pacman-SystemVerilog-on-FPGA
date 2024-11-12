`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2024 01:20:02
// Design Name: 
// Module Name: vga_controller
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


 module vga_controller(
input logic clk,
input logic reset,
output logic[9:0] x,
output logic[9:0] y,
output logic v_sync,
output logic h_sync,
output logic video_on
    );
    //parameter of VGA standarts
    parameter HD = 640; //horizontal display
    parameter HF = 16; //horizontal front porch
    parameter HB = 48; //horizontal back porch
    parameter HR = 96 ; // horizontal retrace
    parameter HMAX = HD + HF + HB + HR -1; //total horizontal pixel
    
    parameter VD = 480; //vertical display
    parameter VF = 10; //vertical front porch 
    parameter VB = 33; //vertical back porch 
    parameter VR = 2; //vertical retrace
    parameter VMAX = VD + VF + VB + VR -1; //total vertical pixel
    
     
     //----horizontal counter
     always_ff @(posedge clk or posedge reset ) begin
        if (reset) x<=0;
        else begin
            if (x == HMAX) x<=0;
            else x<=x+1;
        end   
     end
     
     //----vertical counter
     always_ff @(posedge clk or posedge reset) begin
        if (reset) y<=0;
        else begin
            if (x==HMAX)begin
                if(y==VMAX) y<=0;
                else y<=y+1;
            end
        end
     end
     
     //-----h sync, v sync, video_on
     assign h_sync = (x>=(HD+HB)) && (x<(HD+HB+HR)) ;
     assign v_sync = (y>=(VD+VB)) && (y<(VD+VB+VR)) ;
     assign video_on = (x<HD) && (y<VD); 
    
    
endmodule
