/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Pawel Mozgowiec
 *  *
 * 
 * Description:
 * sync form 100 to 40 Mhz use gray code.
 */




module data_sync(
    input logic mclk, 
    input logic pclk, 
    input logic rst, 
    input logic [11:0] x_pos, 
    output logic [11:0] x_pos_sync,
    input logic [11:0] y_pos, 
    output logic [11:0] y_pos_sync,
    output logic left_mouse_sync,
    output logic right_mouse_sync,
    output logic middle_sync,
    input logic left_mouse,
    input logic right_mouse,
    input logic middle
);
/*
    logic [11:0] x_pos_synced;
    logic [11:0] x_pos_gray;
    logic [11:0] y_pos_synced;
    logic [11:0] y_pos_gray;

  
    // Synchronizacja sygnału x_pos z 100 MHz do 40 MHz
    always_ff @(posedge mclk) begin
      if (rst) begin
        x_pos_synced <= '0;
        y_pos_synced <= '0;
      end else begin
        x_pos_synced <= x_pos;
        y_pos_synced <= y_pos;
      end
    end
  
    // Konwersja sygnału x_pos_synced na kod Gray'a
    always_comb begin
        x_pos_gray = $gray(x_pos_synced);
        y_pos_gray = $gray(y_pos_synced);
    end

    // Synchronizacja kodu Gray'a z 100 MHz do 40 MHz
    always_ff @(posedge pclk) begin
      if (rst) begin
        x_pos_sync <= '0;
        y_pos_sync <= '0;
      end else begin
        x_pos_sync <= $grayinv(x_pos_gray);
        y_pos_sync <= $grayinv(y_pos_gray);
      end
    end
*/

// Synchronization Register Chain - 3 poziomy (2 rejestry synchronizacyjne)
logic [26:0] synced_x_0;
logic [26:0] synced_x_1;
logic [26:0] synced_x_2;

// Pierwszy rejestr synchronizacyjny na wejściu
always_ff @(posedge mclk) begin
    if(rst)begin
        synced_x_0 <= 0;
    end else begin
        synced_x_0 <= {x_pos, y_pos,left_mouse,right_mouse,middle};
    end
end
// Drugi rejestr synchronizacyjny
always_ff @(posedge pclk) begin
    if(rst)begin
        synced_x_1 <= 0;
    end else begin
        synced_x_1 <= synced_x_0;
    end
end

// Trzeci rejestr synchronizacyjny, który wyjmuje wartość z zegarem docelowym
always_ff @(posedge pclk) begin
    if(rst)begin
        synced_x_2 <= 0;
    end else begin
        synced_x_2 <= synced_x_1;
    end
end

// Dekodowanie sygnału z łańcucha rejestrów synchronizacyjnych
assign x_pos_sync = synced_x_2[26:15];
assign y_pos_sync = synced_x_2[14:3];
assign left_mouse_sync = synced_x_2[2];
assign right_mouse_sync = synced_x_2[1];
assign middle_sync = synced_x_2[0];

  endmodule