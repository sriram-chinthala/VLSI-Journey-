// parameterized ALU Top module

module alu #(
    parameter DATA_WIDTH = 8,
    parameter SHIFT_BITS = $clog2(DATA_WIDTH)
) (
    input [DATA_WIDTH-1:0] a,                    
    input [DATA_WIDTH-1:0] b,                    
    input [4:0] opcode,
    input [SHIFT_BITS-1:0] shift_amount,
    
    output reg [DATA_WIDTH-1:0] result,          
    output reg carry_out,
    output reg [2*DATA_WIDTH-1:0] mult_result
);

    // Internal signals
    wire [DATA_WIDTH-1:0] arith_result;
    wire arith_carry;
    wire [2*DATA_WIDTH-1:0] arith_mult_result;
    
    wire [DATA_WIDTH-1:0] logic_result;
    
    wire [DATA_WIDTH-1:0] shift_result;
    
    wire [1:0] unit_select = opcode[4:3];
    wire [2:0] unit_opcode = opcode[2:0];
    
    //ARITHEMATIC UNIT
    
    arithmetic_unit #(.DATA_WIDTH(DATA_WIDTH)) arith_inst (
        .a(a),
        .b(b),
        .arith_op(unit_opcode),
        .result(arith_result),
        .carry_out(arith_carry),
        .mult_result(arith_mult_result)
    );
    
    // LOGIC UNIT 

    logic_unit #(.DATA_WIDTH(DATA_WIDTH)) logic_inst (
        .a(a),
        .b(b),
        .logic_op(unit_opcode),
        .result(logic_result)
    );
       
    // SHIFTER UNIT 

    shifter #(
        .DATA_WIDTH(DATA_WIDTH),
        .SHIFT_AMOUNT_WIDTH(SHIFT_BITS)
    ) shifter_inst (
        .data(a),              // Passed only the first operand 'a' for shifting
        .shift_amount(shift_amount),
        .shift_op(unit_opcode[1:0]),
        .result(shift_result)
    );
    
    // ============================================================
    // MULTIPLEXER: SELECT OUTPUT BASED ON UNIT
    // ============================================================
    
    always @(*) begin
        case (unit_select)
            2'b00: begin  // ARITHMETIC UNIT
                result = arith_result;
                carry_out = arith_carry;
                mult_result = arith_mult_result;
            end
            
            2'b01: begin  // LOGIC UNIT
                result = logic_result;
                carry_out = 1'b0;
                mult_result = {2*DATA_WIDTH{1'b0}};
            end
            
            2'b10: begin  // SHIFTER UNIT
                result = shift_result;
                carry_out = 1'b0;
                mult_result = {2*DATA_WIDTH{1'b0}};
            end
            
            2'b11: begin  // RESERVED
                result = {DATA_WIDTH{1'b0}};
                carry_out = 1'b0;
                mult_result = {2*DATA_WIDTH{1'b0}};
            end
            default: begin
                result = {DATA_WIDTH{1'b0}};
                carry_out = 1'b0;
                mult_result = {2*DATA_WIDTH{1'b0}};
            end
        endcase
    end
    
endmodule
