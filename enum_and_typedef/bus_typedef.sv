module bus_typedef(
    input typedef logic [31:o] data_in,
    input typedef logic [3:0] addr_in,
    input logic op,
    output typedef logic [31:0] data_out
)
logic [31:0]memory [3:0];

always_comb
begin
    if(op)//read operation if op is 1.
    data_out = memory[addr_in];
    else // write operation for 0 .
    memory [addr_in] = data_in;
end

endmodule