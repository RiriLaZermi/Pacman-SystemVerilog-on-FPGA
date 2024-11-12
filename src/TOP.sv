`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2024 01:56:53
// Design Name: 
// Module Name: TOP
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
import utils::* ;
module TOP(
input logic clk100MHz,
input logic reset_n,
input logic up,
input logic right,
input logic down,
input logic left,
output logic wave,
output logic[11:0] rgb,
output logic h_sync,
output logic v_sync,
output logic[6:0] SEG,
output logic[6:0] AN
    );
    //------parameters
   
    //---------
    int level;
    //signals
    logic reset;
    int points_counter;
    int points2_counter;
    assign reset = ~reset_n;
    logic clk25MHz,clk50MHz,clk10MHz;
    logic big_gum_eat;
    logic all_dots_eat;
    logic restart_pacman,restart_dots,restart_ghosts;
    logic ready;
    logic waiting;
    logic loose_game;
    ghost_modes_t current_state;

    //vga signals
    logic[9:0] h_count,v_count;
    logic[11:0] rgb_walls;
    color_t rgb_pacman,rgb_dots,rgb_squares,rgb_picture,rgb_picture2,rgb_blinky,rgb_pinky,rgb_inky,rgb_clyde,rgb_target;
    //rgb_HUD,rgb_score;
    logic pacman_drawing,dots_drawing,walls_drawing,squares_drawing,picture_drawing,picture2_drawing,blinky_drawing,
        pinky_drawing,inky_drawing,clyde_drawing,target_drawing,HUD_drawing,score_DRAWING;
    logic[11:0] rgb_score,rgb_HUD;
    logic video_on;
    
    //pacman parameters
    logic[8:0] pacman_xpos_pframe_pixel,pacman_ypos_pframe_pixel;
    logic[9:0] pacman_xpos_sframe,pacman_ypos_sframe;
    logic[4:0] pacman_xpos_pframe,pacman_ypos_pframe;
    direction_t dirController,pacman_dir;
    logic[1:0] pacman_lifes;
    
    //ghost parameters
    //blinky
    logic blinky_twinkle;
    logic[9:0] target_blinky;
    logic[4:0] blinky_xpos,blinky_ypos;
    logic[8:0] blinky_xpos_pframe_pixel,blinky_ypos_pframe_pixel;
    logic[9:0] blinky_xpos_sframe,blinky_ypos_sframe;
    logic[4:0] blinky_xpos_pframe,blinky_ypos_pframe;
    direction_t blinky_dir;
    logic in_housse_blinky;
    ghost_modes_t blinky_state;    
    //inky
    logic inky_twinkle;
    logic[9:0] target_inky;
    logic[4:0] inky_xpos,inky_ypos;
    logic[8:0] inky_xpos_pframe_pixel,inky_ypos_pframe_pixel;
    logic[9:0] inky_xpos_sframe,inky_ypos_sframe;
    logic[4:0] inky_xpos_pframe,inky_ypos_pframe;
    direction_t inky_dir;
    logic in_housse_inky; 
    logic inky_leave;
    ghost_modes_t inky_state;
    //pinky
    logic pinky_twinkle;
    logic[9:0] target_pinky;
    logic[4:0] pinky_xpos,pinky_ypos;
    logic[8:0] pinky_xpos_pframe_pixel,pinky_ypos_pframe_pixel;
    logic[9:0] pinky_xpos_sframe,pinky_ypos_sframe;
    logic[4:0] pinky_xpos_pframe,pinky_ypos_pframe;
    direction_t pinky_dir;
    logic in_housse_pinky; 
    logic pinky_leave;
    ghost_modes_t pinky_state;
    //clyde
    logic clyde_twinkle;
    logic[9:0] target_clyde;
    logic[4:0] clyde_xpos,clyde_ypos;
    logic[8:0] clyde_xpos_pframe_pixel,clyde_ypos_pframe_pixel;
    logic[9:0] clyde_xpos_sframe,clyde_ypos_sframe;
    logic[4:0] clyde_xpos_pframe,clyde_ypos_pframe;
    direction_t clyde_dir;
    logic in_housse_clyde; 
    logic clyde_leave;
    ghost_modes_t clyde_state;
    

    clock_4_divider  frequency_div_4(.clk_in(clk100MHz),
    .clk_out(clk25MHz),
    .reset(reset));
    
    //--ready block send signal ready when we moove---
    ready ready_block(.clk(clk25MHz),
    .loose_game(loose_game),
    .restart_pacman(restart_pacman),
    .reset(reset),
    .pause(pause),
    .right(right),
    .left(left),
    .up(up),
    .down(down),
    .waiting(waiting),
    .ready(ready));
    
    
    //---VGA CONTROLLER-------
    vga_controller vga_control(.clk(clk25MHz),
    .reset(reset),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .video_on(video_on),
    .x(h_count),
    .y(v_count));
    
    
    //-------RGB MULTIPLIXER--------
    vga_rgb rgb_control(.clk(clk25MHz),
    .reset(reset),
    .rgb_pacman(rgb_pacman),
    .pacman_drawing(pacman_drawing),
    .rgb_dots(rgb_dots),
    .dots_drawing(dots_drawing),
    .rgb_walls(rgb_walls),
    .walls_drawing(walls_drawing),
    .rgb_squares(rgb_squares), 
    .squares_drawing(squares_drawing),
    .rgb_picture(rgb_picture),
    .picture_drawing(picture_drawing),
    .rgb_picture2(rgb_picture2),
    .picture2_drawing(picture2_drawing),
    .rgb_blinky(rgb_blinky),
    .blinky_drawing(blinky_drawing),
    .rgb_pinky(rgb_pinky),
    .pinky_drawing(pinky_drawing),
    .rgb_inky(rgb_inky),
    .inky_drawing(inky_drawing),
    .rgb_clyde(rgb_clyde),
    .clyde_drawing(clyde_drawing),  
    .rgb_target(rgb_target),
    .target_drawing(target_drawing),
    .rgb_HUD(rgb_HUD),
    .HUD_drawing(HUD_drawing),
    .rgb_score(rgb_score),
    .score_drawing(score_drawing),
    .rgb_out(rgb));
    
    //--------GAME MASTER-----------
    game_master master(.clk(clk25MHz),
    .clk100MHz(clk100MHz),
    .reset(reset),
    .ready(ready),
    .loose_game(loose_game),
    .big_gum_eat(big_gum_eat),
    .all_dots_eat(all_dots_eat),
    .pacman_xpos_pframe(pacman_xpos_pframe),
    .pacman_ypos_pframe(pacman_ypos_pframe),
    .pacman_dir(pacman_dir),
    .blinky_xpos(blinky_xpos),
    .blinky_ypos(blinky_ypos),
    .clyde_xpos(clyde_xpos),
    .clyde_ypos(clyde_ypos),
    .inky_xpos(inky_xpos),
    .inky_ypos(inky_ypos),
    .pinky_xpos(pinky_xpos),
    .pinky_ypos(pinky_ypos),
    .restart_dots(restart_dots),
    .restart_pacman(restart_pacman),
    .restart_ghosts(restart_ghosts),
    .in_housse_blinky(in_housse_blinky),
    .in_housse_pinky(in_housse_pinky),
    .in_housse_inky(in_housse_inky),
    .in_housse_clyde(in_housse_clyde),
    .pinky_leave(pinky_leave),
    .inky_leave(inky_leave),
    .clyde_leave(clyde_leave),
    .target_blinky(target_blinky),
    .target_pinky(target_pinky),
    .target_inky(target_inky),
    .target_clyde(target_clyde),
    .blinky_twinkle(blinky_twinkle),
    .pinky_twinkle(pinky_twinkle),
    .inky_twinkle(inky_twinkle),
    .clyde_twinkle(clyde_twinkle),
    .blinky_state(blinky_state),
    .pinky_state(pinky_state),
    .inky_state(inky_state),
    .clyde_state(clyde_state),
    .pause(pause),
    .level(level),
    .score(points2_counter),
    .pacman_lifes(pacman_lifes)
    );
    
    //BLINKY
     ghost_parameters #(.x_base(140),.y_base(194),.LSFR_SEED(16'd12370)) blinky_parameters(.clk(clk25MHz),
     .reset(reset),
     .pause(pause),
     .restart_ghosts(restart_ghosts),
     .leave_housse(1'b1),
     .in_housse(in_housse_blinky),
     .ghost_state(blinky_state),
     .target_loc(target_blinky),
     .x_pos_pframe(blinky_xpos),
     .y_pos_pframe(blinky_ypos),
     .x_pos_sframe(blinky_xpos_sframe),
     .y_pos_sframe(blinky_ypos_sframe),
     .dir(blinky_dir));
     
     
         
     ghost_display #(.ghost_color(RED)) blinky_display(.clk(clk25MHz),
    .reset(reset),
    .twinkle(blinky_twinkle),
    .ghost_state(blinky_state),
    .video_on(video_on),
    .x_pos(blinky_xpos_sframe),
    .y_pos(blinky_ypos_sframe),
    .dir(blinky_dir),
    .h_count(h_count),
    .v_count(v_count),
    .rgb(rgb_blinky),
    .ghost_drawing(blinky_drawing));
    
    //PINKY
    ghost_parameters #(.x_base(140),.y_base(171),.LSFR_SEED(16'd32444)) pinky_parameters(.clk(clk25MHz),
     .reset(reset),
     .pause(pause),
     .restart_ghosts(restart_ghosts),
     .leave_housse(pinky_leave),
     .in_housse(in_housse_pinky),
     .ghost_state(pinky_state),
     .target_loc(target_pinky),
     .x_pos_pframe(pinky_xpos),
     .y_pos_pframe(pinky_ypos),
     .x_pos_sframe(pinky_xpos_sframe),
     .y_pos_sframe(pinky_ypos_sframe),
     .dir(pinky_dir));
     
     
         
     ghost_display #(.ghost_color(PINK)) pinky_display(.clk(clk25MHz),
    .reset(reset),
    .twinkle(pinky_twinkle),
    .video_on(video_on),
    .ghost_state(pinky_state),
    .x_pos(pinky_xpos_sframe),
    .y_pos(pinky_ypos_sframe),
    .dir(pinky_dir),
    .h_count(h_count),
    .v_count(v_count),
    .rgb(rgb_pinky),
    .ghost_drawing(pinky_drawing));
    
    //INKY              
    ghost_parameters #(.x_base(120),.y_base(159),.LSFR_SEED(16'd40878)) inky_parameters(.clk(clk25MHz),
     .reset(reset),
     .pause(pause),
     .restart_ghosts(restart_ghosts),
     .leave_housse(inky_leave),
     .in_housse(in_housse_inky),
     .ghost_state(inky_state),
     .target_loc(target_inky),
     .x_pos_pframe(inky_xpos),
     .y_pos_pframe(inky_ypos),
     .x_pos_sframe(inky_xpos_sframe),
     .y_pos_sframe(inky_ypos_sframe),
     .dir(inky_dir));
     
     
         
     ghost_display #(.ghost_color(CYAN)) inky_display(.clk(clk25MHz),
    .reset(reset),
    .twinkle(inky_twinkle),
    .video_on(video_on),
    .ghost_state(inky_state),
    .x_pos(inky_xpos_sframe),
    .y_pos(inky_ypos_sframe),
    .dir(inky_dir),
    .h_count(h_count),
    .v_count(v_count),
    .rgb(rgb_inky),
    .ghost_drawing(inky_drawing));
    
    //CLYDE
    ghost_parameters  #(.x_base(160),.y_base(159),.LSFR_SEED(16'd27958)) clyde_parameters(.clk(clk25MHz),
     .reset(reset),
     .pause(pause),
     .restart_ghosts(restart_ghosts),
     .leave_housse(clyde_leave),
     .in_housse(in_housse_clyde),
     .ghost_state(clyde_state),
     .target_loc(target_clyde),
     .x_pos_pframe(clyde_xpos),
     .y_pos_pframe(clyde_ypos),
     .x_pos_sframe(clyde_xpos_sframe),
     .y_pos_sframe(clyde_ypos_sframe),
     .dir(clyde_dir));
     
     
         
     ghost_display #(.ghost_color(ORANGE)) clyde_display(.clk(clk25MHz),
    .reset(reset),
    .twinkle(clyde_twinkle),
    .video_on(video_on),
    .ghost_state(clyde_state),
    .x_pos(clyde_xpos_sframe),
    .y_pos(clyde_ypos_sframe),
    .dir(clyde_dir),
    .h_count(h_count),
    .v_count(v_count),
    .rgb(rgb_clyde),
    .ghost_drawing(clyde_drawing));
    
    
    //--------- Uncomment if you want to print target location on the screen----
    
//    target_display target_disp(.h_count(h_count),
//    .v_count(v_count),
//    .target_blinky(target_blinky),
//    .target_pinky(target_pinky),
//    .target_inky(target_inky),
//    .target_clyde(target_clyde),
//    .rgb_target(rgb_target),
//    .target_drawing(target_drawing));
    //-----
    
    //----pacman parameters-----
    pacman_parameters pac_param(.clk(clk25MHz),
    .reset(reset),
    .pause(pause),
    .restart_pacman(restart_pacman),
    .x_pos_pframe(pacman_xpos_pframe),
    .y_pos_pframe(pacman_ypos_pframe),
    .x_pos_sframe(pacman_xpos_sframe),
    .y_pos_sframe(pacman_ypos_sframe),
    .dirController(dirController),
    .dir(pacman_dir)
    );
    
    
    //--------pacman display----------   
    pacman_display pac_display(.clk(clk25MHz),
    .reset(reset),
    .video_on(video_on),
    .h_count(h_count),
    .v_count(v_count),
    .x_pos(pacman_xpos_sframe),
    .y_pos(pacman_ypos_sframe),
    .dir(pacman_dir),
    .rgb(rgb_pacman),
    .pacman_drawing(pacman_drawing));
    
    
    //-----controller------------    
    moovement_controller control(.clk(clk25MHz),
    .reset(reset),
    .restart(restart_pacman),
    .up(up),
    .down(down),   
    .right(right),
    .left(left),
    .dir(dirController));
    
   
    //--------- LOGIC + DISPLAY of dots on the screen---------
    dots_display_logic dots_display(.clk(clk25MHz),
    .reset(reset), 
    .restart_dots(restart_dots),
    .h_count(h_count),
    .v_count(v_count),
    .x_pac(pacman_xpos_pframe),
    .y_pac(pacman_ypos_pframe),
    .points_counter(points_counter),
    .rgb(rgb_dots),
    .dots_drawing(dots_drawing),
    .big_gum_eat(big_gum_eat),
    .all_dots_eat(all_dots_eat)
    );
    
    //----------Wall display----------
    walls_display walls(.h_count(h_count),
    .v_count(v_count),
    .rgb(rgb_walls),
    .walls_drawing(walls_drawing));
    
    
    //---------- semi-static HUD of pacman lifes, ready and the text of SCORE and LEVEL---
    HUD HUD_display_logic(.h_count(h_count),
        .pacman_lifes(pacman_lifes),
        .waiting(waiting),
        .v_count(v_count),
        .rgb_HUD(rgb_HUD),
        .HUD_drawing(HUD_drawing));
    
    //--------- dynamic HUD to print the score and the level---------    
    SCORE_LEVEL_HUD score_level_print (.clk(clk25MHz),
        .reset(reset),
        .h_count(h_count),
        .score1(points_counter),
        .score2(points2_counter),
        .level(level),
        .v_count(v_count),
        .rgb(rgb_score),
        .drawing(score_drawing));
    
    //-------- Sound controller : connect passif buzzer to wave and ground  ------------------
    Sound_controller Sound(.clk(clk25MHz),
    .clk100MHz(clk100MHz),
    .reset(reset),
    .restart(restart_pacman),
    .pause(pause),
    .pacman_xpos_sframe(pacman_xpos_sframe),
    .pacman_ypos_sframe(pacman_ypos_sframe),
    .pacman_xpos_pframe(pacman_xpos_pframe),
    .pacman_ypos_pframe(pacman_ypos_pframe),
    .blinky_xpos(blinky_xpos),
    .blinky_ypos(blinky_ypos),
    .clyde_xpos(clyde_xpos),
    .clyde_ypos(clyde_ypos),
    .inky_xpos(inky_xpos),
    .inky_ypos(inky_ypos),
    .pinky_xpos(pinky_xpos),
    .pinky_ypos(pinky_ypos),
    .blinky_state(blinky_state),
    .pinky_state(pinky_state),
    .inky_state(inky_state),
    .clyde_state(clyde_state),
    .wave(wave));
    
    
    //-------Show score on FPGA 7-SEGMENT DISPLAY---- 
        score_printer_fpga scorea(.clk(clk25MHz),
        .reset(reset),
        .points_counter(points_counter),
        .SEG(SEG),
        .AN(AN));
    
    
    

    
endmodule
