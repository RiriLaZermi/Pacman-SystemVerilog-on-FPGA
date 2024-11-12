import utils::*; 

module pacman_display(
//from vga control
input clk,
input reset,
input video_on,
input logic[9:0] h_count,
input logic[9:0] v_count,
//from pacman parameters
input logic[9:0] x_pos,
input logic[9:0] y_pos,
input direction_t dir,
output color_t rgb,
output logic pacman_drawing
    );

    //open mouth variable
    logic unsigned[1:0] alpha;
    int counter_alpha;
    logic rising;
    
    //pacman draw
    localparam int circle_radius = 7;
    always_latch  begin
        if (reset) begin
            rgb <= BLACK;  // Couleur noire en cas de reset
            pacman_drawing<=0;
        end else begin
            pacman_drawing<=0;
            if (video_on) begin
                
                if (((h_count-x_pos)**2 + (v_count-y_pos)**2 )<= circle_radius**2 + 4) begin
                                            
                    int dx,dy;
                    int scaled_dx,scaled_dy;
                    dx=h_count -x_pos;
                    dy=v_count -y_pos;
                    scaled_dx= signed'(alpha*dx)>>>1;
                    scaled_dy = signed'(alpha*dy)>>>1;
                    case(dir)
                        UP:begin 
                            if ( dx<=-scaled_dy && dx>=scaled_dy && alpha!=0 )begin 
                                rgb<=BLACK; 
                            end else begin 
                                rgb<=YELLOW;
                                pacman_drawing<=1;
                            end 
                        end
                        DOWN : begin 
                            if ( dx<=scaled_dy && dx>=-scaled_dy && alpha!=0 )begin 
                                rgb<=BLACK; 
                            end else begin 
                                rgb<=YELLOW;
                                pacman_drawing<=1;
                            end 
                        end
                        RIGHT :begin 
                            if ( scaled_dx>=dy && dy>=-scaled_dx && alpha!=0 )begin 
                                rgb<=BLACK;
                            end else begin 
                                rgb<=YELLOW;
                                pacman_drawing<=1;
                            end 
                        end
                        LEFT : begin 
                            if ( scaled_dx<=dy && dy<=-scaled_dx && alpha!=0 )begin 
                                rgb<=BLACK; 
                            end else begin 
                                rgb<=YELLOW;
                                pacman_drawing<=1;
                            end 
                        end
                        IDLE : begin 
                            rgb<=YELLOW;
                            pacman_drawing<=1;
                        end
                        default : rgb<=BLACK;
                    endcase
                    
                 end else begin
                    rgb<=BLACK;pacman_drawing<=0;
                 end
                
             end    
         end 
                                
    end
    
    //----open mouth animation 
    always_ff @(posedge clk or posedge reset)begin
        if(reset) begin
            alpha<=0;
            counter_alpha<=0;
            rising<=1;
        end else begin
            counter_alpha++;
            if (counter_alpha == 1_000_000)begin
                counter_alpha<=0;
                if (rising) alpha++;
                else alpha--;    
            end
            if (alpha==2'b11) rising<=0;
            if (alpha==2'b00) rising<=1;
        end
    end
    
    
    
    
endmodule