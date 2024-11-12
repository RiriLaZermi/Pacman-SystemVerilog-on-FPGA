import utils::*;

module game_master(
input logic clk,
input logic clk100MHz,
input logic reset,
input logic ready,
input logic big_gum_eat,
input logic all_dots_eat,
input logic in_housse_blinky,in_housse_pinky, in_housse_inky, in_housse_clyde,
input logic[4:0] pacman_xpos_pframe,pacman_ypos_pframe, //one more bit for signed
input logic[4:0] blinky_xpos,blinky_ypos,
input logic[4:0] clyde_xpos,clyde_ypos,
input logic[4:0] pinky_xpos, pinky_ypos,
input logic[4:0] inky_xpos, inky_ypos,
input direction_t pacman_dir,
output logic restart_pacman, restart_ghosts, restart_dots, 
output logic pause,
output logic loose_game,
output int level,
output logic[1:0] pacman_lifes,
output int score,
output logic[9:0] target_blinky,target_pinky,target_inky,target_clyde,
output logic blinky_twinkle, pinky_twinkle, inky_twinkle, clyde_twinkle,
output logic pinky_leave, inky_leave, clyde_leave,
output ghost_modes_t blinky_state,inky_state,pinky_state,clyde_state

);
     
    
   //Signals
   logic twinkle;
   logic[2:0] set_param;
   //level design signals
   //int unsigned level;
   int counter_phase,counter_freeze;
//   logic[1:0] pacman_lifes;
   logic restart_level, next_level;
   logic restart_game_master_timer;
   
   //pacman
   logic[5:0] pacman_xpos,pacman_ypos;
   //ghost
   logic[4:0] pinky_xtarget,pinky_ytarget;
   logic[5:0] inky_tmpxTarget,inky_tmpyTarget;
   logic[4:0] inky_xtarget,inky_ytarget;
   logic[4:0] clyde_xtarget,clyde_ytarget;
   //state machine
   ghost_modes_t old_state, current_state, next_state;
   int unsigned counter_time,counter_time_affraid,counter_time_leave;//need two counter because when ghost are affraid we keep
   localparam CLOCK_FREQ= 25_000_000;
   
   //instanciation
   //blinky
   ghost_state_machine blinky_state_machine(.clk(clk),
   .reset(reset),
   .restart_ghosts(restart_ghosts),
   .big_gum_eat(big_gum_eat),
   .twinkle(twinkle),
   .in_housse(in_housse_blinky),
   .ghost_xpos(blinky_xpos),
   .ghost_ypos(blinky_ypos),
   .pacman_xpos(pacman_xpos_pframe),
   .pacman_ypos(pacman_ypos_pframe),
   .general_state(current_state),
   .old_general_state(old_state),
   .ghost_twinkle(blinky_twinkle),
   .ghost_state(blinky_state)
   ); 
   
   //pinky
      ghost_state_machine pinky_state_machine(.clk(clk),
      .reset(reset),
      .restart_ghosts(restart_ghosts),
      .big_gum_eat(big_gum_eat),
      .twinkle(twinkle),
      .in_housse(in_housse_pinky),
      .ghost_xpos(pinky_xpos),
      .ghost_ypos(pinky_ypos),
      .pacman_xpos(pacman_xpos_pframe),
      .pacman_ypos(pacman_ypos_pframe),
      .general_state(current_state),
      .old_general_state(old_state),
      .ghost_twinkle(pinky_twinkle),
      .ghost_state(pinky_state)
      ); 
      
 //inky
     ghost_state_machine inky_state_machine(.clk(clk),
     .reset(reset),
     .restart_ghosts(restart_ghosts),
     .big_gum_eat(big_gum_eat),
     .twinkle(twinkle),
     .in_housse(in_housse_inky),
     .ghost_xpos(inky_xpos),
     .ghost_ypos(inky_ypos),
     .pacman_xpos(pacman_xpos_pframe),
     .pacman_ypos(pacman_ypos_pframe),
     .general_state(current_state),
     .old_general_state(old_state),
     .ghost_twinkle(inky_twinkle),
     .ghost_state(inky_state)
     );  
//clyde
    ghost_state_machine clyde_state_machine(.clk(clk),
    .reset(reset),
    .restart_ghosts(restart_ghosts),
    .big_gum_eat(big_gum_eat),
    .twinkle(twinkle),
    .in_housse(in_housse_clyde),
    .ghost_xpos(clyde_xpos),
    .ghost_ypos(clyde_ypos),
    .pacman_xpos(pacman_xpos_pframe),
    .pacman_ypos(pacman_ypos_pframe),
    .general_state(current_state),
    .old_general_state(old_state),
    .ghost_twinkle(clyde_twinkle),
    .ghost_state(clyde_state)
    );    
   //
   
  
   
   assign pacman_xpos={1'b0,pacman_xpos_pframe}; 
   assign pacman_ypos={1'b0,pacman_ypos_pframe};
   localparam ghost_modes_t A = CHASE;
//   always_ff @(posedge reset)begin
//        blinky_state=A;
//        pinky_state=A;
//        inky_state=A;
//        clyde_state=A;
//    end

// --------------  LEVEL DESIGN ---------------
    always_ff @(posedge clk or posedge reset)begin
        if (reset || restart_game_master_timer) begin
            counter_phase=1;
            
        end else begin
            if (current_state==SCATTER && next_state==CHASE) counter_phase ++;
            else if(current_state==CHASE && next_state==SCATTER) counter_phase++;
            
        end 
    end
    
    //loose conditions and pacman lifes + freeze game
    always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            pacman_lifes<=3;
            restart_level<=0;
            next_level<=0;
            counter_freeze<=0; 
            pause<=0;
            loose_game<=0;
            level<=1;
        end else begin
            //end game
             if (pacman_lifes==0)begin
                pause<=1;
                loose_game=1;
             end
            
            //pause when we are not playing
            if (pacman_dir==IDLE)
                pause<=1;
            
            if(ready)
                pause<=0;
                               
            //---
            //-restart if we get touch       
            if(!loose_game)begin
                if (counter_freeze==0)begin
                    restart_level=0;
                    if((blinky_state == SCATTER) || (blinky_state == CHASE))begin 
                        if ((pacman_xpos_pframe == blinky_xpos) && (pacman_ypos_pframe == blinky_ypos))begin
                            pacman_lifes<=pacman_lifes-1;
                            if(pacman_lifes!=0) restart_level=1;
                        end
                    end
                    if(pinky_state == SCATTER || pinky_state == CHASE)begin
                        if (pacman_xpos_pframe == pinky_xpos && pacman_ypos_pframe == pinky_ypos)begin
                            pacman_lifes<=pacman_lifes-1;
                            if(pacman_lifes!=0) restart_level=1;
                        end
                    end
                    if(inky_state == SCATTER || inky_state == CHASE)begin
                        if (pacman_xpos_pframe == inky_xpos && pacman_ypos_pframe == inky_ypos)begin
                            pacman_lifes<=pacman_lifes-1;
                            if(pacman_lifes!=0) restart_level=1;
                        end
                    end
                    if(clyde_state == SCATTER || clyde_state == CHASE)begin
                        if (pacman_xpos_pframe == clyde_xpos && pacman_ypos_pframe == clyde_ypos)begin
                            pacman_lifes<=pacman_lifes-1;
                            if(pacman_lifes!=0) restart_level=1;
                        end
                    end
                end               
               
                                         
           
                //next level
                if (counter_freeze==0)begin
                    if(all_dots_eat)begin
                        next_level=1;  
                        level<=level+1; 
                    end else begin
                        next_level=0;
                    end 
                end
                
                //little freeze
                if (restart_level || next_level) begin
                    if(counter_freeze < CLOCK_FREQ + 35)begin //wait one sec  //+35 for initialisation of dots
                        counter_freeze<=counter_freeze+1;
                        pause<=1;
                    end else begin 
                        counter_freeze<=0;
                        pause<=0;
                    end
                 end
             end //end !loose_game
                
             
             
                
        end
     end
     
     //level settings
     always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            set_param<=0;            
        end else begin
            if(level<5) set_param<=level-1;
            else set_param<=4;
        end
     end
     
     //restart level + game loose conditions 
     always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            restart_pacman = 0;
            restart_ghosts = 0;
            restart_dots = 0;
            restart_game_master_timer=0;
            
        end else begin
            //restart level if we loose
            if (restart_level && counter_freeze == CLOCK_FREQ)begin
                restart_pacman<=1;
                restart_ghosts<=1;
                restart_game_master_timer<=1;
            end else if(next_level && counter_freeze == CLOCK_FREQ)begin
                restart_pacman<=1;
                restart_ghosts<=1;
                restart_game_master_timer<=1;
                restart_dots<=1;
            end else begin
                restart_pacman<=0;
                restart_ghosts<=0;
                restart_dots<=0;
                restart_game_master_timer<=0;
            end
        end   
     end
     
     //score
     always_ff @(posedge clk or posedge reset)begin
        if (reset) begin
            score<=0;
        end else begin
            if (pacman_xpos_pframe==blinky_xpos && pacman_ypos_pframe==blinky_ypos && blinky_state==AFFRAID) score=score+200;
            if (pacman_xpos_pframe==inky_xpos && pacman_ypos_pframe==inky_ypos && inky_state==AFFRAID) score=score+200;
            if (pacman_xpos_pframe==pinky_xpos && pacman_ypos_pframe==pinky_ypos && pinky_state==AFFRAID) score=score+200;
            if (pacman_xpos_pframe==clyde_xpos && pacman_ypos_pframe==clyde_ypos && clyde_state==AFFRAID) score=score+200;
        end
      end
       

      
   
//   //-----------Machine A Etats-------
   // Durées des modes en secondes
    localparam logic [5:0] SCATTER_DURATION[5] = '{10,9,8,6,4};   
    localparam logic [5:0] CHASE_DURATION[5] = '{15,20,25,30,35};    
    localparam logic [5:0] AFFRAID_DURATION[5] = '{7,6,5,4,2};
    
    localparam int unsigned SCATTER_CYCLES[5] = '{
    SCATTER_DURATION[0] * CLOCK_FREQ, 
    SCATTER_DURATION[1] * CLOCK_FREQ,
    SCATTER_DURATION[2] * CLOCK_FREQ, 
    SCATTER_DURATION[3] * CLOCK_FREQ, 
    SCATTER_DURATION[4] * CLOCK_FREQ};
    
    localparam int unsigned CHASE_CYCLES[5] = '{
    CHASE_DURATION[0] * CLOCK_FREQ, 
    CHASE_DURATION[1] * CLOCK_FREQ,
    CHASE_DURATION[2] * CLOCK_FREQ, 
    CHASE_DURATION[3] * CLOCK_FREQ, 
    CHASE_DURATION[4] * CLOCK_FREQ};
    
    localparam int unsigned AFFRAID_CYCLES[5] = '{
    AFFRAID_DURATION[0] * CLOCK_FREQ,
    AFFRAID_DURATION[1] * CLOCK_FREQ,
    AFFRAID_DURATION[2] * CLOCK_FREQ,
    AFFRAID_DURATION[3] * CLOCK_FREQ,
    AFFRAID_DURATION[4] * CLOCK_FREQ
    };
    //counter_time
    always_ff @(posedge clk or posedge reset)begin
        if(reset || restart_game_master_timer)begin
            counter_time<=0;
            counter_time_affraid<=0;
        end else if (!pause) begin
            case (current_state)
                CHASE: begin
                    if (counter_time < CHASE_CYCLES[set_param])
                        counter_time++;
                    else
                        counter_time = 0; 
                end
                
                SCATTER: begin
                    if (counter_time < SCATTER_CYCLES[set_param])
                        counter_time++;
                    else
                        counter_time = 0; 
                end
                
                AFFRAID: begin
                    if(big_gum_eat)
                        counter_time_affraid = 0; //reset time if we eat big gum again
                    else if(counter_time_affraid < AFFRAID_CYCLES[set_param])
                        counter_time_affraid++;
                    else 
                        counter_time_affraid=0;
                          
                end
            endcase

        end
          
    end
 
    //transition function
    always_comb begin
        twinkle=0;
        case (current_state)
            SCATTER: begin
                if (big_gum_eat)begin
                    next_state = AFFRAID;
                end else if (counter_time >= SCATTER_CYCLES[set_param] || level>5) begin //if level>5 no scatter anymore
                    next_state = CHASE;
                end else begin
                    next_state = SCATTER;
                end
            end

            CHASE: begin
                if (big_gum_eat)begin
                    next_state = AFFRAID;
                end else if (counter_time >= CHASE_CYCLES[set_param] && counter_phase<8 && level<=5) begin //if level>5 no scatter anymore
                    next_state = SCATTER;
                end else begin
                    next_state = CHASE;
                end
               
            end
            
            AFFRAID: begin
                if(counter_time_affraid >= AFFRAID_CYCLES[set_param])begin
                    next_state = old_state;
                end else begin
                    next_state = AFFRAID;
                end
                
                if(counter_time_affraid>=AFFRAID_CYCLES[set_param] -  2*CLOCK_FREQ)
                    twinkle=1;
                else
                    twinkle=0;
            end
        endcase
     end   
   
   //registre capture state machine
     always_ff @(posedge clk or posedge reset)begin
        if (reset || restart_ghosts) begin
            current_state <= SCATTER;           
        end else if (!pause) begin
            current_state<=next_state;
            if(next_state != current_state) old_state<=current_state; 
        end
     end
     
     
     
     
   //--------------TARGET------------------------------------------------
   //blinky  
   always_comb begin
        if(blinky_state==SCATTER)begin
            target_blinky = {5'd30,5'd27};//up right
        end else if(blinky_state==CHASE) begin
            //blinky
            target_blinky={pacman_ypos_pframe,pacman_xpos_pframe};                              
        end else if(blinky_state==EATEN)begin
            target_blinky={5'd19,5'd14};//infront ghost housse
        end
    end
   //pinky
    always_comb begin
        if(pinky_state==SCATTER)begin
            target_pinky= {5'd30,5'd0};//up left
        end else if(pinky_state==CHASE) begin
            //pinky 
            case(pacman_dir)
            LEFT: begin
                pinky_xtarget = (signed'(pacman_xpos-4)<=0) ? 0 :pacman_xpos-4;
                pinky_ytarget=pacman_ypos;
            end
            RIGHT:begin
                pinky_xtarget = pacman_xpos+4>=27 ? 27:pacman_xpos+4;
                pinky_ytarget=pacman_ypos;
            end
            UP:begin
                pinky_xtarget = pacman_xpos;
                pinky_ytarget=pacman_ypos+4>=30 ? 30 : pacman_ypos+4;
            end
            DOWN:begin
                pinky_xtarget = pacman_xpos;
                pinky_ytarget= (signed'(pacman_ypos-4)<=0) ? 0 : pacman_ypos-4;
            end
            default:begin
                pinky_xtarget=5'd27;
                pinky_ytarget=5'd30;
            end
            endcase
            
            target_pinky={pinky_ytarget,pinky_xtarget};
    
        end else if(pinky_state==EATEN)begin 
            target_pinky={5'd19,5'd14};//infront ghost housse
        end
    end
   //inky
   always_comb begin
        if(inky_state==SCATTER)begin
            target_inky={5'd0,5'd27}; //bottom right
        end else if(inky_state==CHASE) begin
            //inky
            
            case(pacman_dir)
            LEFT: begin
                inky_tmpxTarget = (signed'(pacman_xpos-2)<=0) ? 0 :pacman_xpos-4;
                inky_tmpyTarget=pacman_ypos;
            end
            RIGHT:begin
                inky_tmpxTarget = pacman_xpos+2>=27 ? 27:pacman_xpos+2;
                inky_tmpyTarget=pacman_ypos;
            end
            UP:begin
                inky_tmpxTarget = pacman_xpos;
                inky_tmpyTarget=pacman_ypos+2>=30 ? 30 : pacman_ypos+2;
            end
            DOWN:begin
                inky_tmpxTarget = pacman_xpos;
                inky_tmpyTarget= (signed'(pacman_ypos-2)<=0) ? 0 : pacman_ypos-2;
            end
            default:begin
                inky_tmpxTarget=5'd27;
                inky_tmpyTarget=0;
            end
            endcase
            if(signed'(2*inky_tmpxTarget - blinky_xpos)<=0)inky_xtarget=0;
            else if( 2*inky_tmpxTarget - blinky_xpos >=27)inky_xtarget=27;
            else inky_xtarget= 2*inky_tmpxTarget - blinky_xpos;
            
            if(signed'(2*inky_tmpyTarget - blinky_ypos)<=0)inky_ytarget=0;
            else if( 2*inky_tmpyTarget - blinky_ypos >=30)inky_ytarget=30;
            else inky_ytarget= 2*inky_tmpyTarget - blinky_ypos;
            
            target_inky={inky_ytarget,inky_xtarget};
            
                                
        end else if(inky_state==EATEN)begin
            target_inky={5'd19,5'd14};//infront ghost housse
        end
    end
   //clyde
   always_comb begin
        if(clyde_state==SCATTER)begin
            target_clyde={5'd0,5'd0}; //bottom left
        end else if(clyde_state==CHASE) begin
            
            //clyde
            if ( (clyde_xpos-pacman_xpos)**2 + (clyde_ypos-pacman_ypos)**2>64)begin
                clyde_xtarget=pacman_xpos_pframe;
                clyde_ytarget=pacman_ypos_pframe;
            end else begin
                clyde_xtarget=0;
                clyde_ytarget=0;
            end
            
            target_clyde={clyde_ytarget,clyde_xtarget};
                                
        end else if(clyde_state==EATEN)begin
            target_clyde={5'd19,5'd14};//infront ghost housse
        end
    end
   //---------
   //--------leave ghost housse
   localparam logic[5:0] PINKY_LEAVE_DURATION[5] = '{15,13,11,9,5};
   localparam logic[5:0] INKY_LEAVE_DURATION[5] = '{25,21,17,13,8};
   localparam logic[5:0] CLYDE_LEAVE_DURATION[5] = '{35,30,25,20,13};
   localparam int unsigned PINKY_LEAVE_CYCLES[5] = '{
   PINKY_LEAVE_DURATION[0] * CLOCK_FREQ,
   PINKY_LEAVE_DURATION[1] * CLOCK_FREQ,
   PINKY_LEAVE_DURATION[2] * CLOCK_FREQ,
   PINKY_LEAVE_DURATION[3] * CLOCK_FREQ,
   PINKY_LEAVE_DURATION[4] * CLOCK_FREQ };
   
   localparam int unsigned INKY_LEAVE_CYCLES[5] = '{
   INKY_LEAVE_DURATION[0] * CLOCK_FREQ,
   INKY_LEAVE_DURATION[1] * CLOCK_FREQ,
   INKY_LEAVE_DURATION[2] * CLOCK_FREQ,
   INKY_LEAVE_DURATION[3] * CLOCK_FREQ,
   INKY_LEAVE_DURATION[4] * CLOCK_FREQ };
   
   localparam int unsigned CLYDE_LEAVE_CYCLES[5] = '{
   CLYDE_LEAVE_DURATION[0] * CLOCK_FREQ,
   CLYDE_LEAVE_DURATION[1] * CLOCK_FREQ,
   CLYDE_LEAVE_DURATION[2] * CLOCK_FREQ,
   CLYDE_LEAVE_DURATION[3] * CLOCK_FREQ,
   CLYDE_LEAVE_DURATION[4] * CLOCK_FREQ};
   
   always_ff @(posedge clk or posedge reset)begin
    if (reset || restart_game_master_timer) begin
        counter_time_leave <= 0;
        pinky_leave<=0;
        clyde_leave<=0;
        inky_leave<=0;
    end else if(!pause) begin 
        counter_time_leave<=counter_time_leave+1;
        if(counter_time_leave>=PINKY_LEAVE_CYCLES[set_param])pinky_leave=1;
        if(counter_time_leave>=INKY_LEAVE_CYCLES[set_param])inky_leave=1;
        if(counter_time_leave>=CLYDE_LEAVE_CYCLES[set_param])clyde_leave=1;
    end
   end 
    
    
endmodule