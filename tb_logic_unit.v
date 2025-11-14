module tb_logic_unit;
parameter DATA_WIDTH = 8;
reg [DATA_WIDTH-1:0] a, b;
reg [2:0] logic_op;
wire [DATA_WIDTH-1:0] result;
logic_unit #(.DATA_WIDTH(DATA_WIDTH)) uut (
    .a(a),
    .b(b),
    .logic_op(logic_op),
    .result(result)
);
integer test_count = 0;
integer pass_count = 0;
integer fail_count = 0;

task run_test;
    input [2:0] op_code;  // 0=AND, 1=OR, 2=XOR, 3=NOT, 4=NAND, 5=NOR, 6=XNOR
    input [DATA_WIDTH-1:0] test_a;
    input [DATA_WIDTH-1:0] test_b;
    input [DATA_WIDTH-1:0] exp_result;

    begin
        test_count = test_count + 1;
        a = test_a;
        b = test_b;
        logic_op = op_code;
        #10;
        // Check results
        if (result == exp_result) begin
            $display("[PASS %3d] | a=%3d, b=%3d | operation = %3d | result=%3d", 
                     test_count,  test_a, test_b, op_code, result);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL %3d] | a=%3d, b=%3d | operation = %3d | Got: %3d, Expected: %3d", 
                     test_count, test_a, test_b, op_code , result, exp_result);
            fail_count = fail_count + 1;
        end
    end
endtask
initial begin
    $display("Starting Logic Unit Tests...");
    // Test AND
    $display("\nStarting AND Tests...");
    run_test(3'b000, 8'b11001100, 8'b10101010, 8'b10001000);
    run_test(3'b000, 8'b00000000, 8'b10101010, 8'b00000000);
    run_test(3'b000, 8'b11111111, 8'b10101010, 8'b10101010);
    run_test(3'b000, 8'b10101010, 8'b01010101, 8'b00000000);
    // Test OR
    $display("\nStarting OR Tests...");
    run_test(3'b001, 8'b11001100, 8'b10101010, 8'b11101110);
    run_test(3'b001, 8'b00000000, 8'b10101010, 8'b10101010);
    run_test(3'b001, 8'b11111111, 8'b10101010, 8'b11111111);
    run_test(3'b001, 8'b10101010, 8'b01010101, 8'b11111111);
    run_test(3'b001, 8'b00000000, 8'b00000000, 8'b00000000);
    run_test(3'b001, 8'b11111111, 8'b11111111, 8'b11111111);
    // Test XOR
    $display("\nStarting XOR Tests...");
    run_test(3'b010, 8'b11001100, 8'b10101010, 8'b01100110);
    run_test(3'b010, 8'b00000000, 8'b00000000, 8'b00000000);
    run_test(3'b010, 8'b11111111, 8'b00000000, 8'b11111111);
    run_test(3'b010, 8'b11111111, 8'b11111111, 8'b00000000);
    run_test(3'b010, 8'b01010101, 8'b10101010, 8'b11111111);

    // --- Test NOT (OpCode: 3'b011) ---
    $display("\nStarting NOT Tests...");
    // 1. General Pattern (~A)
    run_test(3'b011, 8'b11001100, 8'b00000000, 8'b00110011);
    // 2. All Ones (~11111111 = 00000000)
    run_test(3'b011, 8'b11111111, 8'b00000000, 8'b00000000);
    // 3. All Zeros (~00000000 = 11111111)
    run_test(3'b011, 8'b00000000, 8'b00000000, 8'b11111111);
    // 4. Alternating Pattern (~10101010 = 01010101)
    run_test(3'b011, 8'b10101010, 8'b00000000, 8'b01010101);

    // --- Test NAND (OpCode: 3'b100) ---
    $display("\nStarting NAND Tests...");
    // 1. General Pattern (~(A & B))
    run_test(3'b100, 8'b11001100, 8'b10101010, 8'b01110111); // A&B = 10001000, ~(10001000) = 01110111
    // 2. Both All Ones (~(11111111 & 11111111) = 00000000)
    run_test(3'b100, 8'b11111111, 8'b11111111, 8'b00000000);
    // 3. One Input Zero (~(00000000 & 11111111) = 11111111)
    run_test(3'b100, 8'b00000000, 8'b11111111, 8'b11111111);
    // 4. Both All Zeros (~(00000000 & 00000000) = 11111111)
    run_test(3'b100, 8'b00000000, 8'b00000000, 8'b11111111);
    // 5. Opposite Alternating (~(10101010 & 01010101) = 11111111)
    run_test(3'b100, 8'b10101010, 8'b01010101, 8'b11111111);

    // --- Test NOR (OpCode: 3'b101) ---
    $display("\nStarting NOR Tests...");
    // 1. General Pattern (~(A | B))
    run_test(3'b101, 8'b11001100, 8'b10101010, 8'b00010001); // A|B = 11101110, ~(11101110) = 00010001
    // 2. One Input One (~(11111111 | 00000000) = 00000000)
    run_test(3'b101, 8'b11111111, 8'b00000000, 8'b00000000);
    // 3. Both All Zeros (~(00000000 | 00000000) = 11111111)
    run_test(3'b101, 8'b00000000, 8'b00000000, 8'b11111111);
    // 4. Both All Ones (~(11111111 | 11111111) = 00000000)
    run_test(3'b101, 8'b11111111, 8'b11111111, 8'b00000000);
    // 5. Different Patterns (~(11110000 | 00001111) = 00000000)
    run_test(3'b101, 8'b11110000, 8'b00001111, 8'b00000000);

    // --- Test XNOR (OpCode: 3'b110) ---
    $display("\nStarting XNOR Tests...");
    // 1. General Pattern (~(A ^ B))
    run_test(3'b110, 8'b11001100, 8'b10101010, 8'b10011001); // A^B = 01100110, ~(01100110) = 10011001
    // 2. Identical Inputs (A XNOR A = 11111111)
    run_test(3'b110, 8'b11001100, 8'b11001100, 8'b11111111);
    // 3. Opposite Inputs (A XNOR ~A = 00000000)
    run_test(3'b110, 8'b11001100, 8'b00110011, 8'b00000000);
    // 4. Input B is All Zeros (A XNOR 0 = ~A = 00110011)
    run_test(3'b110, 8'b11001100, 8'b00000000, 8'b00110011);
    // 5. Input B is All Ones (A XNOR 1 = A = 11001100)
    run_test(3'b110, 8'b00110011, 8'b11111111, 8'b00110011);

    $display("Total Tests: %d, Passed: %d, Failed: %d", test_count, pass_count, fail_count);
    if (test_count > 0)
        $display("Success Rate: %0.1f%%\n", (pass_count * 100.0) / test_count);
    $finish;
end
endmodule