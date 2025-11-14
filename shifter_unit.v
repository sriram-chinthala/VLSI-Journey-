module shifter #(
    parameter DATA_WIDTH = 8
) (
    input [DATA_WIDTH-1:0] data,
    input [2:0] shift_amount,
    input [1:0] shift_op,
    output reg [DATA_WIDTH-1:0] result
);
    always @(*) begin
        case (shift_op)
            2'b00: result = data << shift_amount;  // SLL
            2'b01: result = data >> shift_amount;  // SRL
            2'b10: result = data >>> shift_amount; // SRA
            default: result = data;
        endcase
    end
endmodule
