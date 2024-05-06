# Parameterized-Synchronous-FIFO
 This project focuses on modeling a parameterized Synchronous FIFO.
 
## Description 
  This Verilog project implements a FIFO (First-In-First-Out) module with configurable parameters for data width, depth, and flag behaviors. The FIFO design incorporates features such as read/write operations, status flags, and test cases to verify functionality.

###FIFO Module Features:
Parameterization:
 - Data width and depth of the FIFO are configurable parameters.
 - Default test case parameters: Width = 8 bits, Depth = 32 entries.
   
Clock Usage:
 - Read and write operations are synchronized using the same clock signal.
   
Status Flags:
 - Empty/Full Flags: Indicate FIFO empty/full conditions.
 - Almost Empty/Almost Full Flags: Threshold-based flags controlled by a parameter (ALMOST_FULL_THRESHOLD = 2 in test case).
   
Counters:
 - Separate read and write counters to track data locations.
 - Provide a count of the current number of entries in the FIFO (count output).
   
Valid Signal:
 - Output a valid signal upon successful read operation.
   
Overflow/Underflow Flags:
 - Flag conditions for FIFO overflow (exceeding depth) and underflow (attempting to read from an empty FIFO).
   
Mutual Exclusivity:
 - Ensure that the FIFO cannot be simultaneously empty and full, similar to other flag conditions.
   
Design Implementation:
 - The FIFO module design ensures proper data handling, flag management, and synchronization of read/write operations.
Special attention is given to flag behaviors, counter updates, and status validation during FIFO operations.

Testing:
 - Develop a testbench to cover all flag behaviors and functional aspects of the FIFO module.
 - Test scenarios include write and read operations to all FIFO locations.
 - Demonstrate simultaneous write and read operations within the FIFO to showcase data integrity and behavior under concurrent access.


## Dependencies
### Software
* https://mobaxterm.mobatek.net/

### Author
* Steven Hernandez
  - www.linkedin.com/in/steven-hernandez-a55a11300
  - https://github.com/stevenhernandezz
