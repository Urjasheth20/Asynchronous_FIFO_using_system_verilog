/*This is the module which stores the data at a certain address and it works with two independent clocks - write clock and read clock.*/

module Fifo_mem #( parameter int w_addr = 4,w_ptr = w_addr+1,
parameter int data_width = 8 )
(
    input  logic wclk,
    input  logic w_en, // for incrementing the write pointer
    input  logic [w_ptr-1:0] w_address,
    input  logic [data_width-1:0] w_data,

    input  logic rclk,
    input  logic r_en,// for incrementing the read pointer
    input  logic [w_ptr-1:0] r_address,
    output  logic [data_width-1:0]   r_data
);

logic [data_width-1:0] mem [0:(1<<w_ptr-1)-1];

always @(posedge wclk) begin
        if (w_en) begin
            mem[w_address[w_ptr-2:0]] <= w_data;
        end
    end

always @(posedge rclk) begin
    if(r_en) begin
        r_data <= mem[r_address[w_ptr-2:0]];
    end
end

endmodule
