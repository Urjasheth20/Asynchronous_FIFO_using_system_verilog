`timescale 1ns/1ps

module tb_fifo1;


parameter w_addr     = 4;
parameter w_ptr      = w_addr + 1;
parameter data_width = 8;



logic [data_width-1:0] w_data;
logic [data_width-1:0] r_data;

logic full;
logic empty;

logic wclk;
logic rclk;

logic w_en;
logic r_en;

logic w_rst;
logic r_rst;


fifo #(
    .w_addr(w_addr),
    .w_ptr(w_ptr),
    .data_width(data_width)
) DUT (

    .w_data(w_data),

    .full(full),
    .empty(empty),

    .wclk(wclk),
    .rclk(rclk),

    .w_en(w_en),
    .r_en(r_en),

    .w_rst(w_rst),
    .r_rst(r_rst),

    .r_data(r_data)
);


always #5 wclk = ~wclk;



always #7 rclk = ~rclk;


initial begin




    $monitor(
    "TIME=%0t | FULL=%b EMPTY=%b | W_EN=%b R_EN=%b | WDATA=%h RDATA=%h",
     $time, full, empty, w_en, r_en, w_data, r_data);

end

//empty flag test

initial begin


    $dumpfile("fifo1.vcd");
    $dumpvars(0, tb_fifo1);

  

    wclk   = 0;
    rclk   = 0;

    w_en   = 0;
    r_en   = 0;

    w_rst  = 1;
    r_rst  = 1;

    w_data = 0;


    #20;

    w_rst = 0;
    r_rst = 0;

 

$display("\n==== TEST CASE 1 : WRITE + READ ====\n");

@(negedge wclk);

w_en   = 1;
w_data = 8'h11;

@(negedge wclk);
w_data = 8'h22;

@(negedge wclk);
w_data = 8'h33;

@(negedge wclk);
w_data = 8'h44;

@(negedge wclk);
w_data = 8'h55;

@(negedge wclk);

w_en = 0;


#1;

$display("\n==== MEMORY DUMP ====\n");

for (int i = 0; i < (1<<w_addr); i++) begin
    $display("MEM[%0d] = %h",
             i,
             DUT.Fifo_store.mem[i]);
end

$display("\n");



#50;


@(posedge rclk);

r_en = 1;

repeat(5) begin

    @(posedge rclk);

    $display(
    "TIME=%0t | READ DATA = %h | EMPTY=%b",
     $time, r_data, empty);

end

@(posedge rclk);

r_en = 0;

  

    #50;

    $finish;

end

endmodule
