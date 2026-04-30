/*
the typedef here is defined globally so that it can be used in testbench also.
The professinal way is to defind the shared resouces like definitions in a pakageage file 
and import it , but it must be compoiled first before design and testbench files.
for that we creat a seperate .sv file and use package and endpackage and the same as a the file 
is used in the package name as well.
this will avoid type mismatches and redefinig the same type in multiple files problem.
*/

typedef enum logic [2:0] {
    ALU_ADD, ALU_SUB, ALU_AND, ALU_OR,
    ALU_XOR, ALU_NOT, ALU_PASS
  } alu_op_t;

module alu_typedef(
    input alu_op_t operation,
    input logic [7:0] a_in,b_in,
    output logic [7:0] alu_output
);

always_comb begin 

    case(operation)
    ALU_ADD: alu_output = a_in + b_in;
    ALU_AND: alu_output = a_in & b_in;
    ALU_NOT: alu_output = ~a_in;
    ALU_OR:  alu_output = a_in | b_in;
    ALU_SUB: alu_output = a_in - b_in;
    ALU_XOR: alu_output = a_in ^ b_in;
    ALU_PASS:alu_output = a_in;
    default: alu_output = 8'd0;
    endcase
    
end

endmodule