module register_8_byte(
    input logic clk,we,
    input logic [2:0] waddr, raddr,
    input logic [7:0] wdata,
    output logic [7:0] rdata
);

logic [7:0] mem [7:0]; // 8 8-bit data reg      
                                                                    
                                            
always @(posedge clk)
begin
    if(!we) // if we = 0 read data
    begin
        rdata = mem [raddr];
    end
    else
    begin
        mem [waddr] = wdata; // write data;
    end
end 

endmodule

/* THIS IS MY FAILURE LEARNING :

1. The Syntax Error: input typedef
The Code: input typedef logic [31:0] data_in The Mistake: You are trying to define a new type inside the port list. You cannot do this. The port list is for using types that already exist.

Analogy: You cannot build a brick factory inside the wall you are building. You build the bricks first (typedef), then you bring them to the wall (port list).

2. The Typo: 0 vs O
The Code: [31:o] The Mistake: You used the letter 'o' (lower case O) instead of the number '0' (Zero). This will cause a compilation failure immediately.

3. The Logic Error: Memory in Combinational Logic
The Code:

Code snippet

always_comb begin
    else memory[addr_in] = data_in; // WRITE
end
The Mistake: You are trying to write to a memory array inside always_comb.

Combinational Logic has no "memory" of the past. It effectively creates a Latch, which is a severe timing hazard.

Memory Writes must always happen on a clock edge (always_ff @(posedge clk)).

*/