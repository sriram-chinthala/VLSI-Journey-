module tb_shifter_unit;

parameter DATA_WIDTH=8;
parameter SHIFT_AMOUNT_WIDTH=$clog2(DATA_WIDTH);
    
reg [DATA_WIDTH-1:0] data;
reg [SHIFT_AMOUNT_WIDTH-1:0] shift_amount;
reg [1:0] shift_op;
wire [DATA_WIDTH-1:0] result;   

shifter #(DATA_WIDTH, SHIFT_AMOUNT_WIDTH) uut (
    .data(data),
    .shift_amount(shift_amount),
    .shift_op(shift_op),
    .result(result)
);

integer test_count=0;
integer pass_count=0;
integer fail_count=0;

task test_run;

input [DATA_WIDTH-1:0] test_data_in;
input [SHIFT_AMOUNT_WIDTH-1:0] test_shift_amount;
input [1:0] test_shift_op;
input [DATA_WIDTH-1:0] expected_result;

begin
    test_count = test_count + 1;
    data = test_data_in;
    shift_amount = test_shift_amount;
    shift_op = test_shift_op;
    #10;
    // Check results
    if (result == expected_result) begin
        $display("[PASS %3d] | data=%3d, shift_amount=%3d | operation = %2b | result=%3d", 
                 test_count,  test_data_in, test_shift_amount, test_shift_op, result);
        pass_count = pass_count + 1;
    end else begin
        $display("[FAIL %3d] | data=%3d, shift_amount=%3d | operation = %2b | Got: %3d, Expected: %3d", 
                 test_count, test_data_in, test_shift_amount, test_shift_op , result, expected_result);
        fail_count = fail_count + 1;
    end
end
endtask

initial
begin
    $display("Starting Shifter Unit Tests...");
    // Test SLL
    $display("\nStarting SLL Tests...");
    test_run(8'b00001111, 3'b001, 2'b00, 8'b00011110);
    test_run(8'b11110000, 3'b010, 2'b00, 8'b11000000);
    test_run(8'b10101010, 3'b000, 2'b00, 8'b10101010);
    test_run(8'b10101010, 3'b111, 2'b00, 8'b00000000);
    test_run(8'b00000000, 3'b111, 2'b00, 8'b00000000);
    // Test SRL
    $display("\nStarting SRL Tests...");
    test_run(8'b00001111, 3'b001, 2'b01, 8'b00000111);
    test_run(8'b11110000, 3'b010, 2'b01, 8'b00111100);
    test_run(8'b10101010, 3'b000, 2'b01, 8'b10101010);
    test_run(8'b10101010, 3'b111, 2'b01, 8'b00000001);
    test_run(8'b00000000, 3'b111, 2'b00, 8'b00000000);
    // Test SRA... the MSB is treated as sign bit
    $display("\nStarting SRA Tests...");
    test_run(8'b10001111, 3'b001, 2'b10, 8'b11000111);
    test_run(8'b11110000, 3'b010, 2'b10, 8'b11111100);
    test_run(8'b00101010, 3'b000, 2'b10, 8'b00101010);
    test_run(8'b10101010, 3'b111, 2'b10, 8'b11111111);
    test_run(8'b00000000, 3'b111, 2'b10, 8'b00000000);
    
    $display("\nTest Summary: Total=%d, Passed=%d, Failed=%d", test_count, pass_count, fail_count);
    if (pass_count>0)
    begin
        $display(" Percentage of tests passed: %f%%", (pass_count*100.0)/test_count);
    end
    $finish;
end

endmodule