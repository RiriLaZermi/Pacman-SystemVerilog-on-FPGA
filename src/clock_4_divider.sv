module clock_4_divider(
input logic clk_in,
input logic reset,
output logic clk_out

    );
    logic counter;
    always_ff @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <=0;
            counter<=0;
        end else begin
            counter<=counter+1;
            if(counter) clk_out<=~clk_out;             
        end
     end
endmodule
