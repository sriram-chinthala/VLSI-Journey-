package status_types_pkg;

    // 1. Define the Error Codes as named labels
    typedef enum logic [3:0] {
        ERR_NONE      = 4'h0,
        ERR_OVERFLOW  = 4'h1,
        ERR_UNDERFLOW = 4'h2,
        ERR_TIMEOUT   = 4'hA, 
        ERR_UNKNOWN   = 4'hF
    } err_code_e;

    // 2. Use the Enum INSIDE the Struct
    typedef struct packed {
        logic       busy;
        logic       error;
        err_code_e  error_code; // <--- This is now a Type, not just bits!
        logic [7:0] count;
    } status_t;

endpackage
// *** THIS FILE AND IT'S TB WON'T RUN WITH ICARUS VERILOG BECAUSE OF THE TOOL LIMITATIONS. ***
module struct_status 
import status_types_pkg ::*;
(
    input status_t in_status,
    output status_t out_status
);

    always_comb begin
        out_status = in_status;
    end

endmodule