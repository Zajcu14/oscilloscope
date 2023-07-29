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
`timescale 1 ns / 1 ps

module trigger_tb(
);

logic clk;
logic [1:0] mode;
logic rst;
logic [7:0] LEVEL_TRIGGER;
reg [7:0] trigger_buffer [0:255];
logic [7:0] z;
logic [7:0] data_input = 0;

trigger u_trigger(
    .clk,
    .data_input,
    .mode,
    .rst,
    .LEVEL_TRIGGER, 
    .trigger_buffer
);

/**
 * Clock generation
 */
localparam CLK_PERIOD = 25;     // 40 MHz
initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end

/**
 * Tasks and functions
 */

 // Here you can declare tasks with immediate assertions (assert).


/**
 * Assertions
 */
// Here you can declare concurrent assertions (assert property).
/*

*/
/**
 * Main test 
 */
assign LEVEL_TRIGGER = 8'd10; // ustawione na 20
assign mode = 2'b01; // mode ustawiony na teigger level

initial begin
    @(posedge rst);
    @(negedge rst);

    repeat(10) begin
    @(posedge clk);
    data_input = data_input + 2;
    $display("data_input = %d", data_input);
    for (int z = 0; z<12; z++) begin
        $display("trigger_buffer[%0d]: %0d", z, trigger_buffer[z]);
    end
    end
    repeat(10) begin
        @(posedge clk);
        data_input = data_input - 2;
        $display("data_input = %d", data_input);
        for (int z = 0; z<12; z++) begin
            $display("trigger_buffer[%0d]: %0d", z, trigger_buffer[z]);
        end
    end

    repeat(10) begin
        @(posedge clk);
        data_input = data_input + 2;
        $display("data_input = %d", data_input);
        for (int z = 0; z<12; z++) begin
            $display("trigger_buffer[%0d]: %0d", z, trigger_buffer[z]);
        end
    end

    repeat(10) begin
        @(posedge clk);
        data_input = data_input - 2;
        $display("data_input = %d", data_input);
        for (int z = 0; z<12; z++) begin
            $display("trigger_buffer[%0d]: %0d", z, trigger_buffer[z]);
        end
    end


    $finish;
end

endmodule
