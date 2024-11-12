module tone (
    input logic clk,                     
    input logic reset,                 
    input logic[9:0] target_freq,  
    output logic square_wave             
);
    localparam CLK_FREQ = 25_000_000; //Fr�quence en s
    // Calcul de la valeur du compteur pour obtenir la fr�quence cible
    int unsigned counter_limit;
    
    
    always_ff @(posedge clk) begin
        if (target_freq == 0)
            counter_limit=0;
        else     
            counter_limit = (CLK_FREQ / (2 * target_freq)) - 1;
    end
            
    // Compteur et g�n�ration du signal carr�
    int unsigned counter;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            square_wave <= 0;
        end else begin
           if (target_freq !=0)begin 
                if (counter >= counter_limit) begin
                    counter <= 0;
                    square_wave <= ~square_wave; // Inversion du signal pour cr�er l'onde carr�e
                end else begin
                    counter <= counter + 1;
                end
            end else
                square_wave <= 0;
                     
        end
    end

    

endmodule
