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
logic LEVEL_TRIGGER;
logic [7:0] trigger_buffer [0:255];
logic [7:0] i;
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
property hcount_max;
    @(posedge clk)
    disable iff (!rst || hcount == 'bx)
    (hcount <= 1055 || hcount == 'bx) |-> (hcount <= 1055);
endproperty

property vcount_max;
    @(posedge clk)
    disable iff (($realtime < 2*CLK_PERIOD) || !rst || vcount == 'bx)
    (vcount <=  627) |-> (vcount <= 627);
endproperty

property hblnk_on;
    @(posedge clk) disable iff (($realtime <= 2*CLK_PERIOD) || !rst ) ((hcount >= 800 & hcount <=1055 & hblnk == 1'b1) || (!(hcount >= 800 & hcount <=1055) & hblnk == 1'b0));
endproperty

property vblnk_on;
    @(posedge clk) disable iff (!rst || (vcount <= 600)) vblnk == 1'b1;
endproperty

    assert property(hcount_max)
    else
    $warning("hcount > 1055");

    assert property(vcount_max)
    else
    $warning("vcount > 627");

    assert property(hblnk_on)
    else
    $error("hblnk error");

    assert property(vblnk_on)
    else
    $warning("vblnk error");

//assert property (@(posedge clk) vcount==VER_PIXELS |=> vcount==0) else
//    $error("jakis komentarz");
*/
/**
 * Main test 
 */
assign LEVEL_TRIGGER = 8'd20; // ustawione na 20
assign mode = 2'b01; // mode ustawiony na teigger level
//initial begin
//   @(posedge rst);
//  @(negedge rst);
/*
    always @(posegde clk) begin
        if (rst!) begin
            data_input <= 8'd0;
            i = 8'd0;
        end else if (i<= 32) begin 
            data_input = data_input + 2;
            i++;
        end else if (i <= 64 && i>=32) begin
            data_input = data_input - 2;
            i++;
        end else if (i <= 128 && i>= 64)begin
                data_input = data_input - 2;
                i++;
        end else if (i >= 128) begin
                $finish;
            end
    end
    always @(posegde clk) begin
       $display("data_input = %d", data_input, "   triger_buffer = %d", trigger_buffer);
    end
*/

initial begin
    @(posedge rst);
    @(negedge rst);
    repeat(64) begin
    $display("data_input = %d", data_input, "   triger_buffer = %d", trigger_buffer);
        data_input = data_input + 1;
        @(posedge clk);
    end
    repeat(64) begin
    $display("data_input = %d", data_input, "   triger_buffer = %d", trigger_buffer);
        data_input = data_input - 1;
        @(posedge clk);
    end
    repeat(64) begin
    $display("data_input = %d", data_input, "   triger_buffer = %d", trigger_buffer);
        data_input = data_input + 1;
    end
    repeat(64) begin
    $display("data_input = %d", data_input, "   triger_buffer = %d", trigger_buffer);
        data_input = data_input + 1;
        @(posedge clk);
    end
    $finish;
end
endmodule
