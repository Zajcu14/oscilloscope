`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.08.2023 23:26:55
// Design Name: 
// Module Name: sampled_data
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


module acquisition_data(
        input logic clk,
        input logic rst,
        input logic  [11:0] sample,
        output logic [11:0] data [0:255],
        input logic ready
      
    );
    
    int counter, counter_nxt;
    int index, index_nxt;
    logic  [11:0] rev_sample;
    
    always_ff @(posedge clk, posedge rst) begin
        if(rst) begin
            counter <= 0;
            index <= 0;
            
        end else begin
       // counter <= counter_nxt;
       // index <= index_nxt;
        
       // if (index == 0) begin
            if (ready == 1)begin
              //  if (rev_sample == sample) begin
              //  index <= index;
            //    end else begin
            data[index] <= sample;
            //if (index == 255)begin
            //index <= 0;
           // end else begin
            index <= index + 1;
        //   end
         //   end
            end
       // end else if(rev_sample !== sample) begin
       //     data[index] <= sample;
       //     rev_sample <= sample;
       // end
        
    end
    end
    
    /*always_comb begin
    
       if(counter == 45) begin
            counter_nxt <= 0;
            
            if(index == 255) begin
               index_nxt <= 0;
            end else begin
               index_nxt <= index + 1;
            end
        end else begin
            counter_nxt <= counter + 1;
            index_nxt <= index;
    end
   end
    */
 
    
endmodule
