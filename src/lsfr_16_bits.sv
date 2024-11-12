module lfsr_16bit (
    input logic clk,
    input logic reset,
    output logic feedback
);
    parameter logic[15:0] SEED=1;
    // Polynôme générateur pour un LFSR de 16 bits : x^16 + x^14 + x^13 + x^11 + 1
    logic [15:0] lfsr;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialisation de l'état du LFSR à une valeur non nulle
            lfsr <= SEED;
        end else begin
            // Calcul du bit de feedback
            feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];
            // Décalage du registre et insertion du bit de feedback
            lfsr <= {lfsr[14:0], feedback};
        end
    end
endmodule