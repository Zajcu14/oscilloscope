`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2023 18:32:31
// Design Name: 
// Module Name: adc_control_sim
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


module adc_control_sim(
);

logic clk;
wire sda;
logic scl;

adc_control u_adc_control(
.clk,
.channel(1'b0),
.sda,
.scl
);

initial begin

#10 clk = 0;

forever begin
    #1 clk = ~clk;
end

end



endmodule
