// ---------------------------------------------------------
// PART 1: The Package (MUST be at the top of the file)
// ---------------------------------------------------------
package types_pkg;
    typedef struct packed {
        logic [7:0]  addr;
        logic [31:0] data;
        logic        write;
    } txn_t;
endpackage
// *** THIS FILE AND IT'S TB WON'T RUN WITH ICARUS VERILOG BECAUSE OF THE TOOL LIMITATIONS. ***
// ---------------------------------------------------------
// PART 2: The Design Module (Imports the package below it)
// ---------------------------------------------------------
module trans_struct 
    import types_pkg::*; // Now this works because the package exists above!
(
    input  txn_t        in_struct,
    input  logic [1:0]  push_idx,
    output txn_t        fifo [3:0]
);

    always_comb begin 
        // Default assignment to prevent Latches
        for (int i=0; i<4; i++) fifo[i] = '0;
        
        // Drive the selected index
        fifo[push_idx] = in_struct; 
    end

endmodule