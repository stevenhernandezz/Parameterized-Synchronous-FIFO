/***************************************************************************
***                                                                      ***
*** EE 526 L Experiment #11                 Steven Hernandez, Fall, 2023 ***
***                                                                      ***
*** Experiment #11 Synchronous FIFO                                      ***
 ***                                                                     ***
****************************************************************************
*** Filename: FIFO_tb.v           Created by Steven Hernandez, 12/2/23 	 ***
***                                                                      ***
****************************************************************************
*** This module is my testbench for my FIFO where I will cover all flag  ***
*** behaviour, test write and read to all locations, write and read in   ***
*** the middle of my module and show that what i read is different than  ***
*** what i wrote, and show my count, and valid working correctly         ***
****************************************************************************/

`timescale 1ns / 1ns
`define FWFT
`define MONITOR_STR_1  "%d: data_in = %h, data_out = %h, count = %d, empty = %b, almost_empty = %b, full = %b, almost_full = %b,valid = %b, overflow = %b, underflow = %b"
module FIFO_tb;
    //parameters 
      parameter DATA_WIDTH = 8;
      parameter DEPTH = 32;
       parameter almost_flag = 2;
    //I.O
      reg clk, rst_n, wr_en, rd_en;
      reg [DATA_WIDTH-1:0] data_in;
      wire [DATA_WIDTH-1:0] data_out;
      wire empty, almost_empty, full, almost_full, valid, overflow, underflow;
      wire [DEPTH-1:0] count;
      integer i;
    
    //Instantiation
      FIFO uut(.clk(clk), .rst_n(rst_n), .wr_en(wr_en), .rd_en(rd_en), .data_in(data_in), .data_out(data_out), .empty(empty), .almost_empty(almost_empty), .full(full), .almost_full(almost_full), .valid(valid), .overflow(overflow), .underflow(underflow), .count(count));

    //monitoring
      initial begin
        $monitor(`MONITOR_STR_1, $time, data_in, data_out, count, empty, almost_empty, full, almost_full, valid,overflow, underflow);
      end
      
    //clock
      initial begin
          clk = 0;
          forever #5 clk = !clk;
      end

    initial begin
    $vcdpluson;
      rd_en = 0;
      rst_n = 0;
      wr_en = 0;
      data_in = 0;
    
    //Reseting FIFO
    #10 rst_n = 0;
    #10 rst_n = 1;
    
      // Write and Read to All Locations
        $display("WRITE AND READ ALL LOCATIONS");
          for (i = 0; i < DEPTH; i = i + 1) begin
            wr_en = 1;
            data_in = i;
        #10;
            wr_en = 0;
        #10;
      end

    // Read data from all locations
        for (i = 0; i < DEPTH; i = i + 1) begin
            rd_en = 1;
        #10;
    // Check if the read data matches the expected value
            if (data_out !== i)
              $display("Error: Read data does not match expected value", data_out);
              rd_en = 0;
        #10;
      end
      
      //testing full 
       $display("TESTING FULL");
          for (i = 0; i < DEPTH; i = i + 1) begin
            wr_en = 1;
            data_in = i;
        #10;
              wr_en = 0;
        #10;
        end
      // Check full
        if (full)
          $display("FIFO is full");
    
      //Check overflow 
      wr_en = 1;
      data_in = 8'b11111111; 
    #10;
      $display("Overflow");
    #10;
    
     //read and Check empty  flag
      #10;
        rd_en = 1;
      #10;
      if (empty)
        $display("FIFO is empty");
      rd_en = 0;
    #10;
  
      // fill FIFO
      #10;
        for (i = 0; i < DEPTH - almost_flag + 1; i = i + 1) begin
            wr_en = 1;
             data_in = i; 
      #10;
          wr_en = 0;
      #10;
      end

    // Check almost full
      #10;
           if (almost_full)
            $display("FIFO is almost full");

    // Read until it is almost empty
      #10;
          for (i = 0; i < DEPTH - almost_flag + 1; i = i + 1) begin
          rd_en = 1;
      #10;
          rd_en = 0;
      #10;
        end
    // Write and Read in the Middle
      #10;
    // Write data to all locations
         for (i = 0; i < DEPTH; i = i + 1) begin
              wr_en = 1;
              data_in = i; 
        #10;
              wr_en = 0;
        #10;
    end

    // Read from the middle of the FIFO
        #10;
            rd_en = 1;
        #10;

    // Check if the read data is different from what was just written
        #10;
              if (data_out === (DEPTH/2)) begin
                  $display("Error: Read data matches");
          end else begin
                  $display("Read data is different from what was just written at the middle location", data_out);
          end
                  rd_en = 0;
      #10;
  
    // Check almost empty
      #10;
        if (almost_empty)
          $display("FIFO is almost empty");
    // Check Valid
      #10;
          wr_en = 1;
          data_in = 8'b10101010;
      #10;
          rd_en = 1;
      #10;
    // Read and Check underflow flag
      #10;
          rd_en = 1;
      #10;
          if (underflow)
            $display("Underflow occurred");
            rd_en = 0;
      #10;
      
    // Check if FIFO is valid
      #10;
        if (valid)
          $display("FIFO is valid");

    // Check Underflow
      #10;
        rd_en = 1;
      #10;

    // Check if underflow is asserted
      #10;
        if (underflow)
          $display("Underflow is correctly asserted");

    // Check Count
      #10;
        wr_en = 1;
        data_in = 8'b11110000;
      #10;
        rd_en = 1;
      #10;

    // Check count after read and write operations
      #10;
        $display("Current count: %0d", count);
    
`ifdef FWFT
          //initial begin
    // Write data to FIFO
          #10;
                wr_en = 1;
                data_in = 8'hB6; 
          #10;
                wr_en = 0;
    // Read data to check valid flag
            #10;
                rd_en = 1;
            #10;
                rd_en = 0;
                $display("FWFT : data_out = %h", data_out);
`endif
    $finish;
end
endmodule