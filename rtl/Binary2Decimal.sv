`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 20:43:11
// Design Name: 
// Module Name: Binary2Decimal
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
module Binary2Decimal(         
    input             clk,
    input             rst,
	input 		 [11:0]bindata,           //12-bit ADC values
	output wire  [23:0] decimalout
);
	reg [3:0]dig_5,dig_4,dig_3,dig_2,dig_1,dig_0;
	assign decimalout ={dig_0,dig_1,dig_2,dig_3,dig_4,dig_5};
	//assign bindata_24bit = {{12'b0},bindata};

always_ff @(posedge clk) begin
    if (rst)begin

    dig_0 <= '0;
    dig_1 <= '0;
    dig_2 <= '0;
    dig_3 <= '0;
    dig_4 <= '0;
    dig_5 <= '0;

	 end
    else begin

		dig_0 <=  bindata/100000; 
        dig_1 <= (bindata % 100000)/10000;
        dig_2 <= (bindata % 10000)/1000;
		dig_3 <= (bindata % 1000)/100;
		dig_4 <= (bindata % 100)/10;
		dig_5 <= (bindata % 10);
		
	end
end

endmodule