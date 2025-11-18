module tb_alu;
    parameter DATA_WIDTH = 32;
    parameter SHIFT_BITS = $clog2(DATA_WIDTH); // $clog2(32) = 5
    
    reg [DATA_WIDTH-1:0] a, b;
    reg [4:0] opcode;
    reg [SHIFT_BITS-1:0] shift_amount;
    wire [DATA_WIDTH-1:0] result;
    wire carry_out;
    wire [2*DATA_WIDTH-1:0] mult_result; // 64 bits

    // Max 32-bit value
    localparam MAX_32 = 32'hFFFF_FFFF; // 4294967295
    localparam HALF_32 = 32'h8000_0000; // 2147483648
    
    // Instantiate ALU
    alu #(.DATA_WIDTH(DATA_WIDTH), .SHIFT_BITS(SHIFT_BITS)) uut (
        .a(a), .b(b), .opcode(opcode), .shift_amount(shift_amount),
        .result(result), .carry_out(carry_out), .mult_result(mult_result)
    );
    
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Task for regular operations (ADD, SUB, INC, DEC, AND, OR, XOR, etc.)
    task run_test;
        input [DATA_WIDTH-1:0] test_a;
        input [DATA_WIDTH-1:0] test_b;
        input [4:0] test_opcode;
        input [SHIFT_BITS-1:0] test_shift;
        input [DATA_WIDTH-1:0] exp_result;
        input exp_carry;
        input [132:0] test_name;
        
        begin
            test_count = test_count + 1;
            a = test_a;
            b = test_b;
            opcode = test_opcode;
            shift_amount = test_shift;
            #10;
            
            if (result == exp_result && carry_out == exp_carry) begin
                $display("[PASS %3d] %-20s | a=%10d, b=%10d, shift=%d | result=%10d, carry=%b", 
                         test_count, test_name, test_a, test_b, test_shift, result, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL %3d] %-20s | a=%10d, b=%10d, shift=%d | Got: result=%10d, carry=%b | Exp: result=%10d, carry=%b", 
                         test_count, test_name, test_a, test_b, test_shift, result, carry_out, exp_result, exp_carry);
                fail_count = fail_count + 1;
            end
        end
    endtask
    
    // Task for MUL operations (verifies mult_result output)
    task run_test_mul;
        input [DATA_WIDTH-1:0] test_a;
        input [DATA_WIDTH-1:0] test_b;
        input [2*DATA_WIDTH-1:0] exp_mult_result;
        input [31:0] test_name;
        
        begin
            test_count = test_count + 1;
            a = test_a;
            b = test_b;
            opcode = 5'b00_100;  // MUL opcode
            shift_amount = 5'b00000;
            #10;
            
            if (mult_result == exp_mult_result) begin
                $display("[PASS %3d] %-20s | a=%10d, b=%10d | mult_result=%20d", 
                         test_count, test_name, test_a, test_b, mult_result);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL %3d] %-20s | a=%10d, b=%10d | Got mult_result=%20d | Expected: %20d", 
                         test_count, test_name, test_a, test_b, mult_result, exp_mult_result);
                fail_count = fail_count + 1;
            end
        end
    endtask
    
    initial begin
        $display("\n");
        $display("╔══════════════════════════════════════════════════════════════════════╗");
        $display("║       COMPREHENSIVE ALU TEST SUITE (DATA_WIDTH = %d bits)            ║", DATA_WIDTH);
        $display("╚══════════════════════════════════════════════════════════════════════╝\n");
        
        
        // ================================================================
        // ARITHMETIC UNIT TESTS (opcode[4:3] = 2'b00)
        // ================================================================
        
        $display("═══════════════════════════════════════════════════════════════════════");
        $display("ARITHMETIC UNIT TESTS (Opcode 5'b00_XXX)");
        $display("═══════════════════════════════════════════════════════════════════════\n");
        
        // ─────────────────────────────────────────────────────────────
        // ADD Tests (opcode = 5'b00_000)
        // ─────────────────────────────────────────────────────────────
        $display("--- ADD OPERATION (5'b00_000) ---");
        run_test(32'd1000000000, 32'd2000000000, 5'b00_000, 5'b00000, 32'd3000000000, 1'b0, "ADD: Normal");
        run_test(HALF_32,        HALF_32,        5'b00_000, 5'b00000, 32'd0,          1'b1, "ADD: Overflow Mid");
        run_test(MAX_32,         32'd1,          5'b00_000, 5'b00000, 32'd0,          1'b1, "ADD: Max+1");
        run_test(MAX_32,         MAX_32,         5'b00_000, 5'b00000, 32'd4294967294, 1'b1, "ADD: Max+Max");
        
        // ─────────────────────────────────────────────────────────────
        // SUB Tests (opcode = 5'b00_001)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- SUB OPERATION (5'b00_001) ---");
        run_test(32'd3000000000, 32'd1000000000, 5'b00_001, 5'b00000, 32'd2000000000, 1'b0, "SUB: Normal");
        run_test(32'd10000,      32'd20000,      5'b00_001, 5'b00000, 32'd4294957296, 1'b1, "SUB: Underflow");
        run_test(MAX_32,         32'd1,          5'b00_001, 5'b00000, 32'd4294967294, 1'b0, "SUB: Max-1");
        run_test(32'd0,          32'd1,          5'b00_001, 5'b00000, MAX_32,         1'b1, "SUB: 0-1");
        
        // ─────────────────────────────────────────────────────────────
        // INC Tests (opcode = 5'b00_010)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- INC OPERATION (5'b00_010) ---");
        run_test(MAX_32, 32'd0, 5'b00_010, 5'b00000, 32'd0,            1'b1, "INC: Max");
        run_test(32'd1000000000, 32'd0, 5'b00_010, 5'b00000, 32'd1000000001, 1'b0, "INC: Normal");
        
        // ─────────────────────────────────────────────────────────────
        // DEC Tests (opcode = 5'b00_011)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- DEC OPERATION (5'b00_011) ---");
        run_test(32'd0, 32'd0, 5'b00_011, 5'b00000, MAX_32,         1'b1, "DEC: Zero");
        run_test(32'd1000000000, 32'd0, 5'b00_011, 5'b00000, 32'd999999999, 1'b0, "DEC: Normal");
        
        // ─────────────────────────────────────────────────────────────
        // MUL Tests (opcode = 5'b00_100) - USING MUL TASK
        // ─────────────────────────────────────────────────────────────
        $display("\n--- MUL OPERATION (5'b00_100) ---");
        run_test_mul(32'd100000, 32'd10000, 64'd1000000000,          "MUL: 1e5 * 1e4");
        run_test_mul(32'd50000, 32'd50000, 64'd2500000000,           "MUL: 5e4 * 5e4");
        run_test_mul(32'd65536, 32'd65536, 64'd4294967296,           "MUL: 2^16 * 2^16");
        run_test_mul(32'd2,     32'd2147483647, 64'd4294967294,      "MUL: 2 * (Max/2)");
        
        // ================================================================
        // LOGIC UNIT TESTS (opcode[4:3] = 2'b01)
        // ================================================================
        
        $display("\n═══════════════════════════════════════════════════════════════════════");
        $display("LOGIC UNIT TESTS (Opcode 5'b01_XXX)");
        $display("═══════════════════════════════════════════════════════════════════════\n");
        
        // ─────────────────────────────────────────────────────────────
        // AND Tests (opcode = 5'b01_000)
        // ─────────────────────────────────────────────────────────────
        $display("--- AND OPERATION (5'b01_000) ---");
        run_test(32'hFFFF0000, 32'h0000FFFF, 5'b01_000, 5'b00000, 32'h00000000, 1'b0, "AND: Disjoint");
        run_test(32'hAAAA_AAAA, 32'h5555_5555, 5'b01_000, 5'b00000, 32'h0000_0000, 1'b0, "AND: Complement");
        
        // ─────────────────────────────────────────────────────────────
        // OR Tests (opcode = 5'b01_001)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- OR OPERATION (5'b01_001) ---");
        run_test(32'hFFFF0000, 32'h0000FFFF, 5'b01_001, 5'b00000, 32'hFFFFFFFF, 1'b0, "OR: Combine");
        
        // ─────────────────────────────────────────────────────────────
        // XOR Tests (opcode = 5'b01_010)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- XOR OPERATION (5'b01_010) ---");
        run_test(32'hFFFF0000, 32'hFFFF0000, 5'b01_010, 5'b00000, 32'h00000000, 1'b0, "XOR: Same");
        
        // ─────────────────────────────────────────────────────────────
        // NOT Tests (opcode = 5'b01_011)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- NOT OPERATION (5'b01_011) ---");
        run_test(32'hF0F0F0F0, 32'd0, 5'b01_011, 5'b00000, 32'h0F0F0F0F, 1'b0, "NOT: Pattern");
        
        // ─────────────────────────────────────────────────────────────
        // NAND Tests (opcode = 5'b01_100)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- NAND OPERATION (5'b01_100) ---");
        run_test(32'hFFFF0000, 32'h0000FFFF, 5'b01_100, 5'b00000, 32'hFFFFFFFF, 1'b0, "NAND: Disjoint");
        
        // ─────────────────────────────────────────────────────────────
        // NOR Tests (opcode = 5'b01_101)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- NOR OPERATION (5'b01_101) ---");
        run_test(32'hFFFF0000, 32'h0000FFFF, 5'b01_101, 5'b00000, 32'h00000000, 1'b0, "NOR: Combine");
        
        // ─────────────────────────────────────────────────────────────
        // XNOR Tests (opcode = 5'b01_110)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- XNOR OPERATION (5'b01_110) ---");
        run_test(32'hAAAA_AAAA, 32'h5555_5555, 5'b01_110, 5'b00000, 32'h0000_0000, 1'b0, "XNOR: Complement");
        
        // ================================================================
        // SHIFTER UNIT TESTS (opcode[4:3] = 2'b10)
        // ================================================================
        
        $display("\n═══════════════════════════════════════════════════════════════════════");
        $display("SHIFTER UNIT TESTS (Opcode 5'b10_XXX)");
        $display("═══════════════════════════════════════════════════════════════════════\n");
        
        // ─────────────────────────────────────────────────────────────
        // SLL Tests (opcode = 5'b10_000, shift_op = 2'b00)
        // ─────────────────────────────────────────────────────────────
        $display("--- SLL OPERATION (5'b10_000) - Shift Left Logical ---");
        run_test(32'h00000001, 32'd0, 5'b10_000, 5'd31, 32'h80000000, 1'b0, "SLL: Shift 31");
        run_test(32'h80000000, 32'd0, 5'b10_000, 5'd1, 32'h00000000, 1'b0, "SLL: MSB Out");
        
        // ─────────────────────────────────────────────────────────────
        // SRL Tests (opcode = 5'b10_001, shift_op = 2'b01)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- SRL OPERATION (5'b10_001) - Shift Right Logical ---");
        run_test(32'h80000000, 32'd0, 5'b10_001, 5'd1, 32'h40000000, 1'b0, "SRL: Normal 1");
        run_test(32'h80000000, 32'd0, 5'b10_001, 5'd31, 32'h00000001, 1'b0, "SRL: Shift 31");
        
        // ─────────────────────────────────────────────────────────────
        // SRA Tests (opcode = 5'b10_010, shift_op = 2'b10)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- SRA OPERATION (5'b10_010) - Shift Right Arithmetic ---");
        run_test(32'h80000000, 32'd0, 5'b10_010, 5'd1, 32'hC0000000, 1'b0, "SRA: Max neg >> 1"); // -2^31 >> 1 = -2^30
        run_test(32'hF0000000, 32'd0, 5'b10_010, 5'd4, 32'hFF000000, 1'b0, "SRA: Negative 4");
        run_test(32'h80000000, 32'd0, 5'b10_010, 5'd31, 32'hFFFFFFFF, 1'b0, "SRA: Neg to -1");
        
        // ================================================================
        // FLAG VERIFICATION TESTS
        // ================================================================
        
        $display("\n═══════════════════════════════════════════════════════════════════════");
        $display("FLAG VERIFICATION TESTS");
        $display("═══════════════════════════════════════════════════════════════════════\n");
        
        $display("--- Carry Flag Tests ---");
        run_test(MAX_32, 32'd1,  5'b00_000, 5'b00000, 32'd0,     1'b1, "Carry from ADD");
        run_test(32'd0,  32'd1,  5'b00_011, 5'b00000, MAX_32,    1'b1, "Carry from DEC (Borrow)");
        
        $display("\n--- No Carry Tests (Logic, Shifter) ---");
        run_test(32'hFFFFFFFF, 32'd0, 5'b01_011, 5'b00000, 32'h00000000, 1'b0, "Logic: No carry");
        run_test(32'hAAAA_AAAA, 32'd0, 5'b10_000, 5'd10, 32'hAAAAA800, 1'b0, "Shifter: No carry");
        
        // ================================================================
        // TEST SUMMARY
        // ================================================================
        
        $display("\n═══════════════════════════════════════════════════════════════════════");
        $display("╔══════════════════════════════════════════════════════════════════════╗");
        $display("║                           TEST SUMMARY                               ║");
        $display("╠══════════════════════════════════════════════════════════════════════╣");
        $display("║ Total Tests:       %3d                                               ║", test_count);
        $display("║ Passed:            %3d                                               ║", pass_count);
        $display("║ Failed:            %3d                                               ║", fail_count);
        if (test_count > 0)
            $display("║ Success Rate:      %6.2f%%                                            ║", (pass_count * 100.0) / test_count);
        $display("╚══════════════════════════════════════════════════════════════════════╝\n");
        
        if (fail_count == 0) begin
            $display("✓ ALL TESTS PASSED - ALU DESIGN VERIFIED!");
        end else begin
            $display("✗ %d TESTS FAILED - REVIEW DESIGN", fail_count);
        end
        
        $display("\n");
        $finish;
    end
    
endmodule