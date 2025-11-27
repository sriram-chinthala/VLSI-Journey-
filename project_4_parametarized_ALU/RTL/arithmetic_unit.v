module arithmetic_unit #(
    parameter DATA_WIDTH = 8
) (
    input [DATA_WIDTH-1:0] a, b,
    input [2:0] arith_op,
    output reg [DATA_WIDTH-1:0] result,
    output reg carry_out,
    output reg [2*DATA_WIDTH-1:0] mult_result
);

    wire [DATA_WIDTH:0] add_result, sub_result;
    
    // Addition: capture 9-bit result to detect carry
    assign add_result = a + b;
    
    // Subtraction: use two's complement (a - b = a + ~b + 1)
    assign sub_result = a - b;
    
    always @(*) begin
        case (arith_op)
            3'b000: begin
                result = add_result[DATA_WIDTH-1:0];  // 8-bit result
                carry_out = add_result[DATA_WIDTH];    // Carry flag
            end
            3'b001: begin
                result = sub_result[DATA_WIDTH-1:0];
                carry_out = sub_result[DATA_WIDTH];
            end
            3'b010: begin
                result = a + 1;  // INC
                carry_out = (a == {DATA_WIDTH{1'b1}});
            end
            3'b011: begin
                result = a - 1;  // DEC
                carry_out = (a == {DATA_WIDTH{1'b0}});
            end
            3'b100: begin 
                mult_result = a * b; // MUL: 2*data width -bit result
                carry_out=1'b0;
            end
                         
            default: begin
                result = {DATA_WIDTH{1'b0}};
                carry_out = 1'b0;
            end
        endcase
    end
endmodule
