module logic_unit #(
    parameter DATA_WIDTH = 8
) (
    input [DATA_WIDTH-1:0] a, b,
    input [2:0] logic_op,
    output  reg [DATA_WIDTH-1:0] result
);
    always @(*) begin
        case (logic_op)
            3'b000: result = a & b;      // AND
            3'b001: result = a | b;      // OR
            3'b010: result = a ^ b;      // XOR
            3'b011: result = ~a;         // NOT
            3'b100: result = ~(a & b);   // NAND
            3'b101: result = ~(a | b);    // NOR
            3'b110 : result = ~(a ^ b);   // XNOR
            default: result = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule
