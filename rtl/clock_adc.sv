module clock_adc(
    input logic clk,
    input logic rst,
    output logic clk_adc
    );
    
    
    logic [6:0] counter;
    
    always_ff @( posedge clk) begin
        if(rst) begin
            clk_adc <= '0;
            counter <= '0;
        end
        else if(counter == 28)begin
            clk_adc <= ~clk_adc;
            counter <= 0;
        end
        else begin
            counter <= counter +1;
        end
    end
    
endmodule