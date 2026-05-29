`timescale 1ns/1ps

module tb_fifo;




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


initial begin

    $dumpfile("fifo.vcd");
    $dumpvars(0, tb_fifo);


    wclk  = 0;
    rclk  = 0;

    w_en  = 0;
    r_en  = 0;

    w_rst = 1;
    r_rst = 1;

    w_data = 0;

    #20;

    w_rst = 0;
    r_rst = 0;

    

   //full flag test

    @(posedge wclk);

    w_en = 1;

    repeat(20) begin

        @(negedge wclk);

        w_data = w_data + 1;

        if (full)
            $display("FIFO FULL at TIME=%0t", $time);

    end

    w_en = 0;

   

    #50;

    $display("\n==== EMPTY TEST ====\n");

    @(posedge rclk);

    r_en = 1;

    repeat(20) begin

        @(posedge rclk);

        if (empty)
            $display("FIFO EMPTY at TIME=%0t", $time);

    end

    r_en = 0;
   

    #50;

    //Simultaneous read and write tb


    @(negedge wclk);

    w_en   = 1;
    w_data = 8'hA1;

    @(negedge wclk);
    w_data = 8'hA2;

    @(negedge wclk);
    w_data = 8'hA3;

    @(posedge wclk);

    w_en = 0;


    #50;

    

    fork

   

    begin

        @(posedge wclk);

        w_en = 1;

        repeat(10) begin

            @(negedge wclk);

            w_data = w_data + 1;

            $display(
            "WRITE : TIME=%0t DATA=%h FULL=%b",
             $time, w_data, full);

        end

        @(posedge wclk);

        w_en = 0;

    end


    begin

        @(posedge rclk);

        r_en = 1;

        repeat(10) begin

            @(posedge rclk);

            $display(
            "READ  : TIME=%0t DATA=%h EMPTY=%b",
             $time, r_data, empty);

        end

        @(posedge rclk);

        r_en = 0;

    end

    join

    
    

    #100;




    $finish;

end

endmodule
