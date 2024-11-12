module two_bits_random_gen(
input logic clk,reset,
output logic[1:0] random
);
parameter logic[15:0] SEED=1;

lfsr_16bit #(.SEED(SEED)) first_bit(.clk(clk),
.reset(reset),
.feedback(random[0]));

lfsr_16bit #(.SEED(SEED+16'h1A5B)) second_bit(.clk(clk),
.reset(reset),
.feedback(random[1]));


endmodule