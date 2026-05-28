# Asynchronous FIFO
 This is a Clock Domain Crossing Project. 
## Table of Contents
* [Introduction](#introduction)
  * [FIFO Architecture](#fifo-architecture)
* [Working Principle](#working-principle)
* [Main Components of an Asynchronous FIFO](#main-components-of-an-asynchronous-fifo)
* [Design and its working](#design-and-its-working)
* [Signals](#signals)
* [Key Features](#key-features)
* [Module Description](#module-description)
* [Conclusion](#conclusion)

# Introduction
FIFO stands for **First-In, First-Out**.  


An Asynchronous FIFO (First In First Out) is a memory buffer used for safe data transfer between two different clock domains.  

Unlike a synchronous FIFO, where both read and write operations use the same clock, an asynchronous FIFO operates with separate clocks:

- **Write Clock (`wclk`)** → Controls writing of data  
- **Read Clock (`rclk`)** → Controls reading of data  

This makes asynchronous FIFOs extremely important in digital systems where different modules operate at different speeds or frequencies.
 FIFO Architecture

<img width="1150" height="714" alt="fifodiagram" src="https://github.com/user-attachments/assets/24d3ce51-5d4b-46e0-b7ab-eb04b2dbc84a" />



# Working Principle

The FIFO stores incoming data in memory locations sequentially:

1. Data is written into the FIFO using the write clock.  
2. Data is read from the FIFO using the read clock.  
3. The first data written into the FIFO is the first data read out.  



# Main Components of an Asynchronous FIFO

- FIFO Memory Array  
- Write Pointer  
- Read Pointer  
- Gray Code Conversion  
- Pointer Synchronizers  
- Full Flag Logic  
- Empty Flag Logic  


# Design and it's working

- The Write operation : The write pointer always points towards the next address where the data has to be written. when w_rst and r_rst are equal to 1 both read and write pointers returns to there initial positions. 
- The read operation : the read pointer always points to the current FIFO word to be read.
The FIFO is considered empty when both the read and write pointers point to the same memory location, indicating that there is no data left to read.
The FIFO is considered full when the write pointer completes a full cycle around the memory and reaches the read pointer, indicating that no more data can be written until some data is read out.
An extra Most Significant Bit (MSB) is added to the pointers to detect the wrap-around condition and distinguish between Full and Empty states.
Gray code is used because only one bit changes at a time during pointer transitions. This reduces the chances of incorrect pointer synchronization between clock domains.The synchronized Gray code pointers are converted back into binary form for memory addressing and pointer calculations.
- Synchronizers : 
When a signal moves from one clock domain to another, the destination clock may try to read the signal exactly while it is changing.In this situation, the flip-flop may not immediately decide whether the signal is 0 or 1. This unstable condition is called metastability.To solve this problem, two flip-flops are connected in series:
1)The first flip-flop receives the asynchronous signal. If metastability occurs, it gets time to settle.
2)The second flip-flop captures the stabilized output from the first flip-flop on the next clock edge.
This makes the signal much more stable and reliable before it is used in the destination clock domain.

Due to the two-stage synchronizer, the Full and Empty flags are updated after synchronization delay, typically taking two destination clock cycles.


# Signals 

- Signals used in the code:
Following is the list of signals used in the design with their definition:

wclk: Write clock signal that controls the write domain.

rclk: Read clock signal that controls the read domain.

w_data: Write data bits. The actual data byte entering the FIFO.

r_data: Read data bits. The data byte being read out of the FIFO memory.

w_en: Write enable control signal from the user to request a write operation.

r_en: Read enable control signal from the user to request a read operation.

w_rst: Reset signal for the write domain logic to clear write pointers.

r_rst: Reset signal for the read domain logic to clear read pointers.

full: FIFO full flag. Goes high if the FIFO memory is full to block further writes.

empty: FIFO empty flag. Goes high if the FIFO memory is empty to block further reads.

wbin: Current binary write pointer address used to index the location of the FIFO memory to which data (w_data) is to be written.

rbin: Current binary read pointer address used to index the location of the FIFO memory from where data (r_data) is to be read.

wbin_next: The calculated next binary write pointer value. It increments by 1 if w_en is high and full is low.

rbin_next: The calculated next binary read pointer value. It increments by 1 if r_en is high and empty is low.

wgray: Write pointer converted into Gray code format.

rgray: Read pointer converted into Gray code format.

wgray_next: The calculated next Gray code write pointer value, used for immediate flag checks before the clock edge.

rgray_next: The calculated next Gray code read pointer value, used for immediate flag checks before the clock edge.

wgray_sync: Write pointer signal (wgray) synchronized to the rclk domain via a 2-stage flip-flop synchronizer block.

rgray_sync: Read pointer signal (rgray) synchronized to the wclk domain via a 2-stage flip-flop synchronizer block.

- Parameters Definition
w_addr: The number of address bits defining the depth of the FIFO memory (e.g., 4 bits allows 16 memory rows).

w_ptr: The total pointer bit-width (w_addr + 1), where the extra bit tracks wrap-around conditions.

data_width: The bit-width of each data word stored in the memory buffer (e.g., 8 bits).

# Key Features
- Parameterizable Design - Easily adjust memory depth (w_addr) and data width (data_width).
- Supports different read and write clock frequencies  
- Prevents metastability during clock domain crossing  
- Maintains data order (FIFO behavior)  
- Generates Full and Empty status flags  
- Widely used in high-speed digital communication systems  




# Module Description

| Module | Description |
|---|---|
| `FIFO.sv` | Top-level module that connects all FIFO submodules and controls overall FIFO operation. |
| `FIFO_mem.sv` | Implements the FIFO memory array used to store data. |
| `write_full.sv` | Handles write-side logic and Full flag generation. |
| `read_empty.sv` | Handles read-side logic and Empty flag generation. |
| `sync_ff.sv` | Two-flip-flop synchronizer used for safe clock domain crossing. |

# Conclusion
The asynchronous FIFO design works perfectly for transferring data between different clock speeds. Using Gray code kept everything synced, and our tests showed the design is reliable and efficient.


However, software tests cannot catch "metastability," which is a physical hardware glitch. Preventing this requires real hardware solutions like synchronizers and careful timing.

Overall, this is a strong design for data transfer between two different clock domain systems.For future work, we should put this design on a real hardware. Testing various clock speeds and data patterns will guarantee it performs well under real conditions.

# Sources:
1) VLSI verify Blog - Asynchronous FIFO

---
### Author : URJA SHETH
