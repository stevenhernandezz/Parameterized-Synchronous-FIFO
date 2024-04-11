/***************************************************************************
***                                                                      ***
*** EE 526 L Experiment #11                 Steven Hernandez, Fall, 2023 ***
***                                                                      ***
*** Experiment #11 Synchronous FIFO                                      ***
 ***                                                                     ***
****************************************************************************
*** Filename: FIFO.v           Created by Steven Hernandez, 12/2/23 	   ***
***                                                                      ***
****************************************************************************
*** This module is for my FIFO where will have flags for overflow/underflow ***
*** valid signal on successful read, can't be empty and full at the same ***
*** time, use read/write counter to keep track of data locations, provide ***
*** empty/full and almsot empty/almost full flags, and use the same clock ***
*** for read and write                                                    ***
****************************************************************************/

`timescale 1 ns / 1ns
module FIFO(clk, wr_en, rd_en, rst_n, data_in, data_out, empty, almost_empty, full, almost_full, valid, overflow, underflow, count);
    // Parameters for FIFO width
      parameter WIDTH = 8;
      parameter DEPTH = 32;
      parameter almost_flag = 2;
    //I.O
      input [WIDTH-1:0] data_in;
      input clk, wr_en, rd_en, rst_n;
      output reg [DEPTH-1:0] count;
      output reg [WIDTH-1:0] data_out;
      output reg empty, almost_empty, full, almost_full, valid, overflow, underflow;
    //counters, and memory 
      reg [DEPTH-1:0] wr_cnt;
      reg [DEPTH-1:0] rd_cnt;
      reg [WIDTH-1:0] mem [0:DEPTH-1];
      integer i;

    // Reset conditions
    always @(posedge clk) begin
      if (!rst_n) begin
        wr_cnt <= 0;
        rd_cnt <= 0;
        count <= 0;
        overflow <= 0;
        underflow <= 0;
        valid <= 0;
    end else begin
        // flags
        full <= (count == DEPTH); //full flag when count reaches depth
        empty <= (count == 0); //empty flag when count is zero
        almost_empty <= (count <= almost_flag); //almost_empty flag based on thresh
        almost_full <= (count >= DEPTH - almost_flag); //almost_full flag based on thresh

        // Write 
        if (wr_en) begin
            if (full) begin
                overflow <= 1; //overflow flag if FIFO is full
            end else begin
                mem[wr_cnt] <= data_in; // Write data to memory
                wr_cnt <= (wr_cnt == DEPTH-1) ? 0 : wr_cnt + 1; // Increment  counter
                overflow <= 0; // Clear overflow flag
                count <= count + 1; // Increment count
            end
        end

        // Read 
        if (rd_en) begin
            if (empty) begin
                underflow <= 1; //underflow flag if FIFO is empty
                valid <= 0; // Clear valid 
            end else begin
                data_out <= mem[rd_cnt]; // Read data from memory
                rd_cnt <= (rd_cnt == DEPTH-1) ? 0 : rd_cnt + 1; // Increment read counter
                underflow <= 0; // Clear underflow flag
                valid <= 1; // Set valid flag
                count <= count - 1; // Decrement 
            end
        end
    end
end

      // initialize counts
          initial begin
            wr_cnt = 0;
            rd_cnt = 0;
end
endmodule