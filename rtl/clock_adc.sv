module clock_adc(
    input logic clk,
    input logic rst,
    output logic clk_adc,
    input logic [11:0] counter_max
    );
    
    
    int counter;
    
    always_ff @( posedge clk) begin
        if(rst) begin
            clk_adc <= '0;
            counter <= '0;
        end
        else if(counter == counter_max)begin
            clk_adc <= ~clk_adc;
            counter <= 0;
        end
        else begin
            counter <= counter +1;
        end
    end
    
endmodule