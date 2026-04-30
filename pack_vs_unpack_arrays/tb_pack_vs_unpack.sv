module tb_pack_vs_unpack ;

logic [3:0][7:0] packed_array;
logic [7:0] unpacked_array [3:0];

pack_vs_unpack DUT (
    .packed_array(packed_array),
    .unpacked_array(unpacked_array)
);

initial begin : main_block
    #10;
    unpacked_array [0]= 8'd11;
    unpacked_array [1] = 8'd22;
    unpacked_array [2] =  8'd33;
    unpacked_array [3] =  8'd44;
    #10;
    $display("Content of packed_array row 0 is %d", packed_array[0]);
    $display("Content of packed_array row 1 is %d", packed_array[1]);
    $display("Content of packed_array row 2 is %d", packed_array[2]);
    $display("Content of packed_array row 3 is %d", packed_array[3]);

    $finish;
end

endmodule