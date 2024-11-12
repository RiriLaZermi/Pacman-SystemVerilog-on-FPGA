module dual_sound_mixer(
    input logic clk,
    input logic reset,
    input logic off1,off2,off3,off4,off5,off6,off7,
    output logic combined_wave  // Signal combiné des deux sons
);

    logic pacman_wave;
    logic ghost_wave;
    logic p_eat_wave;
    logic[3:0] ghost_eat_wave;
    
    logic counter;

    // Instance pour le son de Pacman (melody_select = 0)
                
    melody_gen #(.MELODY_SELECT(0)) pacman_sound (
                .clk(clk),
                .reset(reset),
                .off(off1),
                .square_wave(pacman_wave)
    );

    // Instance pour le son des fantômes (melody_select = 1)
    melody_gen #(.MELODY_SELECT(1)) ghost_sound (
                .clk(clk),
                .reset(reset),
                .off(off2),
                .square_wave(ghost_wave)
    );
    
    melody_gen #(.MELODY_SELECT(2)) pacman_get_eat_sound (
                .clk(clk),
                .reset(reset),
                .off(off3),
                .square_wave(eat_wave)
        );
    
    melody_gen #(.MELODY_SELECT(3)) blinky_get_eat_sound (
                .clk(clk),
                .reset(reset),
                .off(off4),
                .square_wave(ghost_eat_wave[0])
                );
    melody_gen #(.MELODY_SELECT(3)) inky_get_eat_sound (
                .clk(clk),
                .reset(reset),
                .off(off5),
                .square_wave(ghost_eat_wave[1])
            );
            
     melody_gen #(.MELODY_SELECT(3)) pinky_get_eat_sound (
                .clk(clk),
                .reset(reset),
                .off(off6),
                .square_wave(ghost_eat_wave[2])
                        );
     melody_gen #(.MELODY_SELECT(3)) clyde_get_eat_sound (
                .clk(clk),
                .reset(reset),
                .off(off7),
                .square_wave(ghost_eat_wave[3])
            );
                           

    
    // Mélange des deux sons avec un XOR
    assign combined_wave = pacman_wave ^ ghost_wave ^ eat_wave ^ ghost_eat_wave[0] ^ghost_eat_wave[1]^ghost_eat_wave[2] ^ghost_eat_wave[3];

endmodule
