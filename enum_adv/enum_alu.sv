package alu_pkg;
    typedef enum {add,sub,and_op,or_op,not_op,xor_op,right_shift,left_shift,right_sign_shift} alu_state;

    
endpackage

module enum_alu
import alu_pkg::*;
#(parameter WIDTH = 8)
(
    input logic [WIDTH-1:0] in_a,in_b,
    input alu_state op_code,
    input logic [$clog2(WIDTH)-1:0] shift_amt,
    output logic [WIDTH-1:0] out
);

always_comb begin

    out = '0; // Default assignment

    case(op_code)

        add : out = in_a + in_b;
        sub : out = in_a - in_b;
        and_op : out = in_a & in_b;
        or_op : out = in_a | in_b;
        not_op : out = ~in_a;
        xor_op : out = in_a ^ in_b;
        right_shift : out = in_a >> shift_amt;
        left_shift : out = in_a << shift_amt;
        right_sign_shift : out = $signed(in_a) >>> shift_amt;
        default : out = 'x;

    
    endcase



end


endmodule