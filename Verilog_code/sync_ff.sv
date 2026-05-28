/*This a two flip flop synchronizer. 
A 2-FF (Two Flip-Flop) synchronizer is a clock domain crossing technique used to safely transfer signals between two different clock domains and reduce metastability issues.*/


module sync_ff2 #(parameter int w_addr = 4,w_ptr=w_addr+1)(
  input logic [w_ptr-1:0] a_in, //gray code input
    input logic rst,
  output logic [w_ptr-1:0]sync_out, // gray code output
    input logic clk
);
logic [w_ptr-1:0]w1;
always @(posedge clk)begin
    if(rst == 1)begin
    w1 <= 0;
    sync_out <= 0;
    end
    else  begin
    w1 <= a_in;
   sync_out <= w1;
    end
end


endmodule
