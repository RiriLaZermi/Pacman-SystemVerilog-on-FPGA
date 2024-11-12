module  melody_gen 
(
    input logic clk,
    input logic reset,
    input logic off,
    output logic square_wave
    
);  
    parameter MELODY_SELECT=0;
    parameter CLK_FREQ_per_ms = 25_000;
    ///--
    logic[9:0] target_freq;
    
    // Définition des mélodies A et B
    typedef struct {
        logic[9:0] frequency; // fréquence en Hz
        int unsigned duration;  // durée en nombre de cycles d'horloge 
    } note_t;
    
    localparam MELODY_LENGHT = 
    (MELODY_SELECT==0) ? 3 :
    (MELODY_SELECT==1) ? 3:
    (MELODY_SELECT==2) ? 62 : 
    (MELODY_SELECT==3) ? 62 : 
    10;
    
    note_t melody[MELODY_LENGHT];
    
   
    initial begin
        if (MELODY_SELECT == 0) begin
            // Mélodie A de taille variable
            melody[0] = '{500, CLK_FREQ_per_ms * 100};
            melody[1] = '{0, CLK_FREQ_per_ms * 50};
            melody[2] = '{700, CLK_FREQ_per_ms * 100};
            // Ajoutez des notes supplémentaires si nécessaire pour MELODY_LENGTH > 3
        end else if (MELODY_SELECT==1) begin
            // Mélodie B de taille variable
        
            melody[0] = '{200, CLK_FREQ_per_ms * 200};
            melody[1] = '{0, CLK_FREQ_per_ms * 100};
            melody[2] = '{150, CLK_FREQ_per_ms * 200};
       
            // Ajoutez des notes supplémentaires si nécessaire pour MELODY_LENGTH > 3
        end else if (MELODY_SELECT==2) begin
            automatic int i=0;
            for(logic[15:0] freq=800; freq>=200;freq -= 20)begin               
                melody[2*i]='{freq,CLK_FREQ_per_ms * 10};
                melody[2*i+1] ='{0,CLK_FREQ_per_ms * 10};
                i++;
            end
        end else if (MELODY_SELECT==3) begin
            automatic int i=0;
            for(logic[15:0] freq=200; freq<800;freq += 20)begin               
                melody[2*i]='{freq,CLK_FREQ_per_ms * 10};
                melody[2*i+1] ='{0,CLK_FREQ_per_ms * 10};
                i++;
            end
        end
        
       
    end
    
    //tone
    tone T(.clk(clk),
    .reset(reset),
    .target_freq(target_freq),
    .square_wave(square_wave));

    // Compteur pour la durée de chaque note
    int unsigned note_counter;
    int unsigned note_index; // index de la note actuelle
    logic playing;
    

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            note_index <= 0;
            note_counter <= 0;
            target_freq <= 0;
        end else begin
            if (!off)
               playing<=1;              
             
            if (!playing && note_counter ==0)
                target_freq<=0;    
            else if (playing && note_counter == 0) begin
                // Change la note actuelle après expiration de la durée
                
                note_counter <= melody[note_index].duration;
                target_freq <= melody[note_index].frequency;
                
                if ( note_index < MELODY_LENGHT - 1 ) begin
                    note_index <= note_index + 1;
                end else begin
                    note_index <= 0;
                    playing <= 0;
                end
            end else if(note_counter!=0) begin
                note_counter <= note_counter - 1;
            end
        end
    end
    
endmodule

    
    
 