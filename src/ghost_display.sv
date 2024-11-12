import utils::*; 

module ghost_display(
//from vga control
input clk,
input reset,
input video_on,
input twinkle,
input logic[9:0] h_count,
input logic[9:0] v_count,
input direction_t dir,
input ghost_modes_t ghost_state,
//input logic twinkle, //when ghost affraid at the end they twinkle
input logic[9:0] x_pos,
input logic[9:0] y_pos,
output color_t rgb,
output logic ghost_drawing
    );
    parameter color_t ghost_color = CYAN;
   //signals
    logic ghost_moove;
    int counter_moove;
    
    
    //pacman draw
    localparam int circle_radius = 7;
    
    
    always_latch  begin
        if (reset) begin
            rgb <= BLACK;  // Couleur noire en cas de reset
            ghost_drawing<=0;
        end else begin
            ghost_drawing<=0;
            rgb<=BLACK;
            if (video_on) begin
                if(ghost_state != EATEN)begin
                    if ( (((h_count-x_pos)**2 + (v_count-y_pos)**2 )<= circle_radius**2 + 4 && v_count<y_pos) ||
                            (h_count>=x_pos-circle_radius && h_count<=x_pos +circle_radius && v_count>=y_pos && v_count<=y_pos+7)) begin
                         if (!ghost_moove)begin
                            if( (( (h_count-x_pos)**2 + (v_count-y_pos-7)**2 ) >= 2) &&
                                (( (h_count-x_pos-5)**2 + (v_count-y_pos-7)**2 ) >= 2) &&
                                (( (h_count-x_pos+5)**2 + (v_count-y_pos-7)**2 ) >= 2) )  begin                
                                if (ghost_state != AFFRAID) rgb<=ghost_color;
                                else begin
                                    if (twinkle) rgb<=WHITE;
                                    else rgb<=BLUE;
                                end
                                ghost_drawing<=1;
                            end 
                         end else begin
                            if( (( (h_count-x_pos+2)**2 + (v_count-y_pos-7)**2 ) >= 2) &&
                                (( (h_count-x_pos-2)**2 + (v_count-y_pos-7)**2 ) >= 2) &&
                                (( (h_count-x_pos-6)**2 + (v_count-y_pos-7)**2 ) >= 2) &&
                                (( (h_count-x_pos+6)**2 + (v_count-y_pos-7)**2 ) >= 2) )  begin                
                                if (ghost_state != AFFRAID) rgb<=ghost_color;
                                else rgb<=BLUE;
                                ghost_drawing<=1;
                            end 
                         end
                    end
                end
                //Eyes direction
                if (ghost_state != AFFRAID)begin
                    if(dir==LEFT || dir==RIGHT)begin
                        int dir_leftright;
                        if (dir==LEFT) dir_leftright=1; else dir_leftright=-1;
                        
                        if (  (((h_count-(x_pos- dir_leftright*5))**2 + (v_count-y_pos)**2 )<= 5) || (((h_count-(x_pos+ dir_leftright*2))**2 + (v_count-y_pos)**2 )<= 5))begin
                            rgb<=WHITE;
                            ghost_drawing<=1;  
                        end
                        
                        if ( ( (h_count ==x_pos-dir_leftright*7 || h_count==x_pos-dir_leftright*6) && (v_count==y_pos-1 || v_count==y_pos+1 || v_count==y_pos))   
                        ||   ((h_count==x_pos+dir_leftright*1 || h_count==x_pos) && (v_count==y_pos-1 || v_count==y_pos+1 || v_count==y_pos) ))begin
                            rgb<=BLUE;
                            ghost_drawing<=1;
                        end           
                        
                    end else if (dir==UP)begin
                        if (  (((h_count- (x_pos-3))**2 + (v_count-(y_pos-3))**2 )<= 5) || (((h_count-(x_pos+3))**2 + (v_count-(y_pos-3))**2 )<= 5))begin
                            rgb<=WHITE;
                            ghost_drawing<=1;  
                        end
                        
                        if ( ( (h_count ==x_pos-3 || h_count==x_pos-4 || h_count==x_pos-2) && (v_count==y_pos-4 || v_count==y_pos-5 ))   
                        ||   ((h_count==x_pos+3 || h_count==x_pos+4 || h_count==x_pos+2) && (v_count==y_pos-5 || v_count==y_pos-4 ) ))begin
                            rgb<=BLUE;
                            ghost_drawing<=1;
                        end              
                        
                     
                    end else if(dir==DOWN) begin
                        if (  (((h_count- (x_pos-3))**2 + (v_count-(y_pos+2))**2 )<= 5) || (((h_count-(x_pos+3))**2 + (v_count-(y_pos+2))**2 )<= 5))begin
                            rgb<=WHITE;
                            ghost_drawing<=1;  
                        end
                        
                        if ( ( (h_count ==x_pos-3 || h_count==x_pos-4 || h_count==x_pos-2) && (v_count==y_pos+3 || v_count==y_pos+4 ))   
                        ||   ((h_count==x_pos+3 || h_count==x_pos+4 || h_count==x_pos+2) && (v_count==y_pos+3 || v_count==y_pos+4 ) ))begin
                            rgb<=BLUE;
                            ghost_drawing<=1;
                        end       
                    end
                end else begin
                       if ( ( (h_count ==x_pos-2 || h_count==x_pos-3 ) && (v_count==y_pos-1 || v_count==y_pos-2 ))   
                        ||   ((h_count==x_pos+2 || h_count==x_pos+3 ) && (v_count==y_pos-1 || v_count==y_pos-2 ) ))begin
                            if(twinkle)begin
                                if(!ghost_moove) rgb<=RED;
                                else rgb<=BEIGE;
                            end else rgb<=BEIGE;
                            ghost_drawing<=1;
                       end else if ( v_count==y_pos+2 && ((h_count==x_pos || h_count==x_pos-1 || h_count==x_pos+1 )
                                ||( h_count==x_pos-4|| h_count==x_pos-5)
                                ||( h_count==x_pos+4|| h_count==x_pos+5)))begin
                            if(twinkle)begin
                                if(!ghost_moove) rgb<=RED;
                                else rgb<=BEIGE;
                            end else rgb<=BEIGE;
                            ghost_drawing<=1;
                       end else if (  v_count==y_pos+3 && ((h_count==x_pos-2 || h_count==x_pos-3 )
                                ||( h_count==x_pos+2|| h_count==x_pos+3)
                                || h_count==x_pos+6 || h_count==x_pos-6 ))begin
                            if(twinkle)begin
                                if(!ghost_moove) rgb<=RED;
                                else rgb<=BEIGE;
                            end else rgb<=BEIGE;
                            ghost_drawing<=1;    
                       end         
                end
            end 
         end 
                                
    end
    
    //----mooving ghost animationlogic ghost_moove;
        localparam int freq_ghost= 25_000_000 * (1.0/4);
        always_ff @(posedge clk or posedge reset)begin
            if(reset) begin
                ghost_moove=0;
                counter_moove=0;
            end else begin
                counter_moove++;
                if(counter_moove == freq_ghost) begin
                    ghost_moove++;
                    counter_moove<=0;
                end
                             
            end
        end
    //--
    

    
    
    
endmodule