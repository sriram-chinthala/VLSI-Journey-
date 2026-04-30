module pack_vs_unpack (
    output logic [3:0][7:0] packed_array,
    input logic [7:0] unpacked_array [3:0]
);
    always @* begin
        for (int i = 0; i < 4; i++)
            packed_array[i] = unpacked_array[i];
    end
endmodule
