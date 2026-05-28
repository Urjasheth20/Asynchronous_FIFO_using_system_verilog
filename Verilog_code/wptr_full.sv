/*there are two important concepts used in the module :- 1) usage of gray code conversion so there are less chances of error in bit transfer 
2) Understanding the concept of Parity bit : if we look at empty condition the w_ptr = r_ptr and full ondition is w_ptr = r_ptr , as both of them are same we need a
n extra bit to differentiate between them. Thus we use a parity bit if the parity bits  are equal,given other bits are also equal then empty = 1 otherwise full = 1.  */

//the main purpose of this module is two things : 1) To check the flag of full 2) to increment the write pointer if conditions are satisfied

module write #(parameter int w_addr = 4, w_ptr = w_addr+1)(
    input logic wclk,
    input logic w_en,
    input logic w_rst,
    input logic [w_ptr-1:0] rgray, // gray pointer from read
  output logic [w_ptr-1:0] wbin, //current binary pointer 
    output logic [w_ptr-1:0] wgray, // gray pointer from write
  output logic [w_ptr-1:0] wbin_next, 
    output logic [w_ptr-1:0] wgray_next,
    output logic full
);


assign full_next = ((wgray_next  == {~rgray[w_ptr-1:w_ptr-2],rgray[w_ptr-3:0]}) ? 1 : 0);
assign wbin_next = ((w_en == 1 && full == 0) ? wbin + 1 : wbin);
assign wgray_next = wbin_next ^ (wbin_next >> 1);

logic full_next;
always_ff @(posedge wclk) begin
    if (w_rst) begin
        wbin  <= 0;
        wgray <= 0;
        full <= 0;
    end
    else begin
        wbin  <= wbin_next;
        wgray <= wgray_next;
        full  <= full_next;
    end
end
endmodule
