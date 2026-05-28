/* This is the top module where all the modules are connected to each other.*/
/*This is a parameterised module where user can define how many address bits and data bits one wants. Here the address width is set to 4 bits and data width is set to 8 bits. 
According to the logic discussed previoulsy(in write_full module), the pointer width would be address bit + 1 that is 5 . The MSB is the parity bit which helps to determine the full and empty flag*/


`include "sync_ff.sv"
`include "wptr_full.sv"
`include "rptr_empty.sv"
module fifo #( parameter int w_addr=4,w_ptr = w_addr+1,
parameter int data_width = 8 )(
    input  logic [data_width-1:0]   w_data,
    output logic full, empty,
    input logic wclk,rclk,w_en,r_en,w_rst,r_rst,
    output  logic [data_width-1:0]   r_data
    
);

logic [w_ptr-1:0] wbin,wbin_next,wgray_next,rgray_sync;
logic [w_ptr-1:0] wgray,rgray,rbin,rbin_next,rgray_next,wgray_sync;


write #(.w_addr(w_addr)) write_pointer(
    .wclk(wclk),
    .w_en(w_en),
    .w_rst(w_rst),
    .rgray(rgray_sync),
    .wgray(wgray),
    .wbin(wbin),
    .wbin_next(wbin_next),
    .wgray_next(wgray_next),
    .full(full)
);

read #(.w_addr(w_addr)) read_pointer(
    .rclk(rclk),
    .r_en(r_en),
    .r_rst(r_rst),
    .rgray(rgray),
    .wgray(wgray_sync),
    .rbin(rbin),
    .rbin_next(rbin_next),
    .rgray_next(rgray_next),
    .empty(empty)
);

sync_ff2 #(.w_addr(w_addr)) readtowrite(
    .rst(w_rst),
    .clk(wclk),
    .a_in(rgray),
    .sync_out(rgray_sync)
);
sync_ff2 #(.w_addr(w_addr)) writetoread(
    .rst(r_rst),
    .clk(rclk),
    .a_in(wgray),
    .sync_out(wgray_sync)
);

Fifo_mem #(.w_addr(w_addr),.data_width(data_width)) Fifo_store(
    .wclk(wclk),
    .w_en(w_en && !full),
    .w_address(wbin),
    .w_data(w_data),
    .rclk(rclk),
    .r_en(r_en && !empty),
    .r_address(rbin),
    .r_data(r_data)

);

endmodule
