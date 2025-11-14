module alu #(
    parameter DATA_WIDTH = 8,
    parameter OPCODE_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] a, b,
    input [OPCODE_WIDTH-1:0] opcode,
    output reg [DATA_WIDTH-1:0] result
);
    // Internal wires connecting submodules
    wire [DATA_WIDTH-1:0] arith_result, logic_result, shift_result;
    
    // Instantiate arithmetic unit
    arithmetic_unit #(.DATA_WIDTH(DATA_WIDTH)) 
    arith_inst (
        .a(a), 
        .b(b), 
        .arith_op(opcode[1:0]), 
        .result(arith_result)
    );
    
    // Instantiate logic unit
    logic_unit #(.DATA_WIDTH(DATA_WIDTH)) 
    logic_inst (
        .a(a), 
        .b(b), 
        .logic_op(opcode[1:0]), 
        .result(logic_result)
    );
    
    // Instantiate shifter
    shifter #(.DATA_WIDTH(DATA_WIDTH)) 
    shift_inst (
        .data(a), 
        .shift_amount(opcode[2:0]), 
        .shift_op(opcode[1:0]), 
        .result(shift_result)
    );
    
    // Mux to select final result based on opcode
    always @(*) begin
        case (opcode[3:2])
            2'b00: result = arith_result;
            2'b01: result = logic_result;
            2'b10: result = shift_result;
            default: result = {DATA_WIDTH{1'b0}}; // Default case
        endcase
    end
endmodule
