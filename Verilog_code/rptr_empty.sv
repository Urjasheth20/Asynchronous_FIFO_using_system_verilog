//the main purpose of this module is two things : 1) To check the flag of empty 2) to increment the read pointer if conditions are satisfied

module read #(parameter int w_addr = 4, w_ptr = w_addr+1 )( //as 0 1 2 3 are bits 4 id parity bit
    input logic rclk,
    input logic r_en,
    input logic r_rst,
  input logic [w_ptr-1:0] wgray, // gray pointer from write
    output logic [w_ptr-1:0] rbin,
  output logic [w_ptr-1:0] rgray, // gray pointer from read
    output logic [w_ptr-1:0] rbin_next, 
    output logic [w_ptr-1:0] rgray_next,
    output logic empty
);
logic empty_next;

assign empty_next= ((rgray_next == wgray) ? 1 : 0);
assign rbin_next = ((r_en == 1 && empty == 0) ? rbin + 1 : rbin);
assign rgray_next = rbin_next ^ (rbin_next >> 1);

always_ff @(posedge rclk) begin
    if (r_rst) begin
        rbin  <= 0;
        rgray <= 0;
        empty <= 1;
    end
    else begin
        rbin  <= rbin_next;
        rgray <= rgray_next;
        empty <= empty_next;
        
    end
end



endmodule

