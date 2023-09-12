`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.07.2023 18:56:45
// Design Name: Pawe? Mozgowiec & Jakub Zaj?c
// Module Name: draw_display
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
//(* CLOCK_PIN = "clk_adc" *)
module clock_adc(
    input logic clk,
    output logic clk_adc
    );
    BUFR #(
       .BUFR_DIVIDE("8"),   // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
       .SIM_DEVICE("7SERIES")  // Must be set to "7SERIES"
    )
    BUFR_first_stage (
       .O(divided_first_stage),     // 1-bit output: Clock output port
       .CE('b1),   // 1-bit input: Active high, clock enable (Divided modes only)
       .CLR('b0), // 1-bit input: Active high, asynchronous clear (Divided modes only)
       .I(clk)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
    );
    
    
    BUFR #(
       .BUFR_DIVIDE("4"),   // Values: "BYPASS, 1, 2, 3, 4, 5, 6, 7, 8"
       .SIM_DEVICE("7SERIES")  // Must be set to "7SERIES"
    )
    BUFR_second_stage (
       .O(clk_adc),     // 1-bit output: Clock output port
       .CE('b1),   // 1-bit input: Active high, clock enable (Divided modes only)
       .CLR('b0), // 1-bit input: Active high, asynchronous clear (Divided modes only)
       .I(divided_first_stage)      // 1-bit input: Clock buffer input driven by an IBUF, MMCM or local interconnect
    );
    
endmodule