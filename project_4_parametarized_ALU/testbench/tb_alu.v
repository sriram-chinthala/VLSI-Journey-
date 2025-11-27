module tb_alu;
    parameter DATA_WIDTH = 8;
    parameter SHIFT_BITS = $clog2(DATA_WIDTH);
    
    reg [DATA_WIDTH-1:0] a, b;
    reg [4:0] opcode;
    reg [SHIFT_BITS-1:0] shift_amount;
    wire [DATA_WIDTH-1:0] result;
    wire carry_out;
    wire [2*DATA_WIDTH-1:0] mult_result;
    
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
                $display("[PASS %3d] %-20s | a=%3d, b=%3d, shift=%d | result=%3d, carry=%b", 
                         test_count, test_name, test_a, test_b, test_shift, result, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL %3d] %-20s | a=%3d, b=%3d, shift=%d | Got: result=%3d, carry=%b | Exp: result=%3d, carry=%b", 
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
            shift_amount = 3'b000;
            #10;
            
            if (mult_result == exp_mult_result) begin
                $display("[PASS %3d] %-20s | a=%3d, b=%3d | mult_result=%5d", 
                         test_count, test_name, test_a, test_b, mult_result);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL %3d] %-20s | a=%3d, b=%3d | Got mult_result=%5d | Expected: %5d", 
                         test_count, test_name, test_a, test_b, mult_result, exp_mult_result);
                fail_count = fail_count + 1;
            end
        end
    endtask
    
    initial begin
        $display("\n");
        $display("╔══════════════════════════════════════════════════════════════════════╗");
        $display("║         COMPREHENSIVE ALU TEST SUITE (DATA_WIDTH = %d bits)              ║", DATA_WIDTH);
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
        run_test(8'd150, 8'd100, 5'b00_000, 3'b000, 8'd250, 1'b0,   "ADD: Normal");
        run_test(8'd200, 8'd100, 5'b00_000, 3'b000, 8'd44,  1'b1,   "ADD: Overflow");
        run_test(8'd255, 8'd1,   5'b00_000, 3'b000, 8'd0,   1'b1,   "ADD: Max+1");
        run_test(8'd0,   8'd0,   5'b00_000, 3'b000, 8'd0,   1'b0,   "ADD: Zero+Zero");
        run_test(8'd128, 8'd127, 5'b00_000, 3'b000, 8'd255, 1'b0,   "ADD: Near Max");
        run_test(8'd255, 8'd255, 5'b00_000, 3'b000, 8'd254, 1'b1,   "ADD: Max+Max");
        run_test(8'd1,   8'd1,   5'b00_000, 3'b000, 8'd2,   1'b0,   "ADD: One+One");
        run_test(8'd127, 8'd1,   5'b00_000, 3'b000, 8'd128, 1'b0,   "ADD: Boundary");
        
        // ─────────────────────────────────────────────────────────────
        // SUB Tests (opcode = 5'b00_001)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- SUB OPERATION (5'b00_001) ---");
        run_test(8'd150, 8'd100, 5'b00_001, 3'b000, 8'd50,  1'b0,   "SUB: Normal");
        run_test(8'd50,  8'd100, 5'b00_001, 3'b000, 8'd206, 1'b1,   "SUB: Underflow");
        run_test(8'd255, 8'd1,   5'b00_001, 3'b000, 8'd254, 1'b0,   "SUB: Max-1");
        run_test(8'd0,   8'd0,   5'b00_001, 3'b000, 8'd0,   1'b0,   "SUB: Zero-Zero");
        run_test(8'd100, 8'd100, 5'b00_001, 3'b000, 8'd0,   1'b0,   "SUB: Equal");
        run_test(8'd0,   8'd1,   5'b00_001, 3'b000, 8'd255, 1'b1,   "SUB: 0-1");
        run_test(8'd128, 8'd128, 5'b00_001, 3'b000, 8'd0,   1'b0,   "SUB: Mid-Mid");
        run_test(8'd200, 8'd50,  5'b00_001, 3'b000, 8'd150, 1'b0,   "SUB: Large-Small");
        
        // ─────────────────────────────────────────────────────────────
        // INC Tests (opcode = 5'b00_010)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- INC OPERATION (5'b00_010) ---");
        run_test(8'd255, 8'd0,   5'b00_010, 3'b000, 8'd0,   1'b1,   "INC: Max");
        run_test(8'd100, 8'd0,   5'b00_010, 3'b000, 8'd101, 1'b0,   "INC: Normal");
        run_test(8'd0,   8'd0,   5'b00_010, 3'b000, 8'd1,   1'b0,   "INC: Zero");
        run_test(8'd127, 8'd0,   5'b00_010, 3'b000, 8'd128, 1'b0,   "INC: Mid");
        run_test(8'd254, 8'd0,   5'b00_010, 3'b000, 8'd255, 1'b0,   "INC: Near Max");
        run_test(8'd1,   8'd0,   5'b00_010, 3'b000, 8'd2,   1'b0,   "INC: One");
        
        // ─────────────────────────────────────────────────────────────
        // DEC Tests (opcode = 5'b00_011)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- DEC OPERATION (5'b00_011) ---");
        run_test(8'd0,   8'd0,   5'b00_011, 3'b000, 8'd255, 1'b1,   "DEC: Zero");
        run_test(8'd100, 8'd0,   5'b00_011, 3'b000, 8'd99,  1'b0,   "DEC: Normal");
        run_test(8'd1,   8'd0,   5'b00_011, 3'b000, 8'd0,   1'b0,   "DEC: One");
        run_test(8'd128, 8'd0,   5'b00_011, 3'b000, 8'd127, 1'b0,   "DEC: Mid");
        run_test(8'd255, 8'd0,   5'b00_011, 3'b000, 8'd254, 1'b0,   "DEC: Max");
        run_test(8'd2,   8'd0,   5'b00_011, 3'b000, 8'd1,   1'b0,   "DEC: Two");
        
        // ─────────────────────────────────────────────────────────────
        // MUL Tests (opcode = 5'b00_100) - USING MUL TASK
        // ─────────────────────────────────────────────────────────────
        $display("\n--- MUL OPERATION (5'b00_100) ---");
        run_test_mul(8'd10,  8'd5,   16'd50,       "MUL: 10*5");
        run_test_mul(8'd255, 8'd2,   16'd510,      "MUL: 255*2");
        run_test_mul(8'd255, 8'd255, 16'd65025,    "MUL: Max*Max");
        run_test_mul(8'd0,   8'd100, 16'd0,        "MUL: 0*100");
        run_test_mul(8'd1,   8'd255, 16'd255,      "MUL: 1*Max");
        run_test_mul(8'd16,  8'd16,  16'd256,      "MUL: 16*16");
        run_test_mul(8'd200, 8'd200, 16'd40000,    "MUL: 200*200");
        run_test_mul(8'd7,   8'd11,  16'd77,       "MUL: 7*11");
        run_test_mul(8'd12,  8'd8,   16'd96,       "MUL: 12*8");
        
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
        run_test(8'b11111111, 8'b11111111, 5'b01_000, 3'b000, 8'b11111111, 1'b0, "AND: All 1s");
        run_test(8'b00000000, 8'b00000000, 5'b01_000, 3'b000, 8'b00000000, 1'b0, "AND: All 0s");
        run_test(8'b11111111, 8'b00000000, 5'b01_000, 3'b000, 8'b00000000, 1'b0, "AND: 1s & 0s");
        run_test(8'b11001100, 8'b10101010, 5'b01_000, 3'b000, 8'b10001000, 1'b0, "AND: Mixed");
        run_test(8'b10101010, 8'b01010101, 5'b01_000, 3'b000, 8'b00000000, 1'b0, "AND: Complement");
        
        // ─────────────────────────────────────────────────────────────
        // OR Tests (opcode = 5'b01_001)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- OR OPERATION (5'b01_001) ---");
        run_test(8'b00000000, 8'b00000000, 5'b01_001, 3'b000, 8'b00000000, 1'b0, "OR: All 0s");
        run_test(8'b11111111, 8'b11111111, 5'b01_001, 3'b000, 8'b11111111, 1'b0, "OR: All 1s");
        run_test(8'b11111111, 8'b00000000, 5'b01_001, 3'b000, 8'b11111111, 1'b0, "OR: 1s | 0s");
        run_test(8'b11110000, 8'b00001111, 5'b01_001, 3'b000, 8'b11111111, 1'b0, "OR: Complement");
        run_test(8'b11001100, 8'b10101010, 5'b01_001, 3'b000, 8'b11101110, 1'b0, "OR: Mixed");
        
        // ─────────────────────────────────────────────────────────────
        // XOR Tests (opcode = 5'b01_010)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- XOR OPERATION (5'b01_010) ---");
        run_test(8'b11111111, 8'b11111111, 5'b01_010, 3'b000, 8'b00000000, 1'b0, "XOR: Same");
        run_test(8'b00000000, 8'b00000000, 5'b01_010, 3'b000, 8'b00000000, 1'b0, "XOR: Zero");
        run_test(8'b11111111, 8'b00000000, 5'b01_010, 3'b000, 8'b11111111, 1'b0, "XOR: Opposite");
        run_test(8'b11001100, 8'b10101010, 5'b01_010, 3'b000, 8'b01100110, 1'b0, "XOR: Mixed");
        run_test(8'b10101010, 8'b01010101, 5'b01_010, 3'b000, 8'b11111111, 1'b0, "XOR: Complement");
        
        // ─────────────────────────────────────────────────────────────
        // NOT Tests (opcode = 5'b01_011)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- NOT OPERATION (5'b01_011) ---");
        run_test(8'b11111111, 8'b00000000, 5'b01_011, 3'b000, 8'b00000000, 1'b0, "NOT: All 1s");
        run_test(8'b00000000, 8'b00000000, 5'b01_011, 3'b000, 8'b11111111, 1'b0, "NOT: All 0s");
        run_test(8'b11001100, 8'b00000000, 5'b01_011, 3'b000, 8'b00110011, 1'b0, "NOT: Pattern");
        run_test(8'b10101010, 8'b00000000, 5'b01_011, 3'b000, 8'b01010101, 1'b0, "NOT: Alternate");
        run_test(8'b00000001, 8'b00000000, 5'b01_011, 3'b000, 8'b11111110, 1'b0, "NOT: Single 1");
        
        // ─────────────────────────────────────────────────────────────
        // NAND Tests (opcode = 5'b01_100)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- NAND OPERATION (5'b01_100) ---");
        run_test(8'b11111111, 8'b11111111, 5'b01_100, 3'b000, 8'b00000000, 1'b0, "NAND: All 1s");
        run_test(8'b00000000, 8'b00000000, 5'b01_100, 3'b000, 8'b11111111, 1'b0, "NAND: All 0s");
        run_test(8'b11001100, 8'b10101010, 5'b01_100, 3'b000, 8'b01110111, 1'b0, "NAND: Mixed");
        
        // ─────────────────────────────────────────────────────────────
        // NOR Tests (opcode = 5'b01_101)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- NOR OPERATION (5'b01_101) ---");
        run_test(8'b11111111, 8'b11111111, 5'b01_101, 3'b000, 8'b00000000, 1'b0, "NOR: All 1s");
        run_test(8'b00000000, 8'b00000000, 5'b01_101, 3'b000, 8'b11111111, 1'b0, "NOR: All 0s");
        run_test(8'b11001100, 8'b10101010, 5'b01_101, 3'b000, 8'b00010001, 1'b0, "NOR: Mixed");
        
        // ─────────────────────────────────────────────────────────────
        // XNOR Tests (opcode = 5'b01_110)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- XNOR OPERATION (5'b01_110) ---");
        run_test(8'b11111111, 8'b11111111, 5'b01_110, 3'b000, 8'b11111111, 1'b0, "XNOR: Same");
        run_test(8'b00000000, 8'b00000000, 5'b01_110, 3'b000, 8'b11111111, 1'b0, "XNOR: Zero");
        run_test(8'b11001100, 8'b10101010, 5'b01_110, 3'b000, 8'b10011001, 1'b0, "XNOR: Mixed");
        
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
        run_test(8'b00001111, 8'd0, 5'b10_000, 3'b001, 8'b00011110, 1'b0, "SLL: Normal 1");
        run_test(8'b11110000, 8'd0, 5'b10_000, 3'b010, 8'b11000000, 1'b0, "SLL: Normal 2");
        run_test(8'b10101010, 8'd0, 5'b10_000, 3'b000, 8'b10101010, 1'b0, "SLL: Shift 0");
        run_test(8'b10101010, 8'd0, 5'b10_000, 3'b111, 8'b00000000, 1'b0, "SLL: Shift max");
        run_test(8'b00000001, 8'd0, 5'b10_000, 3'b001, 8'b00000010, 1'b0, "SLL: Single bit");
        run_test(8'b00000001, 8'd0, 5'b10_000, 3'b111, 8'b10000000, 1'b0, "SLL: Bit to MSB");
        
        // ─────────────────────────────────────────────────────────────
        // SRL Tests (opcode = 5'b10_001, shift_op = 2'b01)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- SRL OPERATION (5'b10_001) - Shift Right Logical ---");
        run_test(8'b00001111, 8'd0, 5'b10_001, 3'b001, 8'b00000111, 1'b0, "SRL: Normal 1");
        run_test(8'b11110000, 8'd0, 5'b10_001, 3'b010, 8'b00111100, 1'b0, "SRL: Normal 2");
        run_test(8'b10101010, 8'd0, 5'b10_001, 3'b000, 8'b10101010, 1'b0, "SRL: Shift 0");
        run_test(8'b10101010, 8'd0, 5'b10_001, 3'b111, 8'b00000001, 1'b0, "SRL: Shift max");
        run_test(8'b10000000, 8'd0, 5'b10_001, 3'b001, 8'b01000000, 1'b0, "SRL: MSB shift");
        run_test(8'b10000000, 8'd0, 5'b10_001, 3'b111, 8'b00000001, 1'b0, "SRL: MSB to LSB");
        
        // ─────────────────────────────────────────────────────────────
        // SRA Tests (opcode = 5'b10_010, shift_op = 2'b10)
        // ─────────────────────────────────────────────────────────────
        $display("\n--- SRA OPERATION (5'b10_010) - Shift Right Arithmetic ---");
        run_test(8'b10001111, 8'd0, 5'b10_010, 3'b001, 8'b11000111, 1'b0, "SRA: Negative 1");
        run_test(8'b11110000, 8'd0, 5'b10_010, 3'b010, 8'b11111100, 1'b0, "SRA: Negative 2");
        run_test(8'b00101010, 8'd0, 5'b10_010, 3'b000, 8'b00101010, 1'b0, "SRA: Shift 0");
        run_test(8'b10101010, 8'd0, 5'b10_010, 3'b111, 8'b11111111, 1'b0, "SRA: Neg to -1");
        run_test(8'b00000001, 8'd0, 5'b10_010, 3'b001, 8'b00000000, 1'b0, "SRA: Pos small");
        run_test(8'b01010101, 8'd0, 5'b10_010, 3'b001, 8'b00101010, 1'b0, "SRA: Pos normal");
        run_test(8'b10000000, 8'd0, 5'b10_010, 3'b001, 8'b11000000, 1'b0, "SRA: -128 >> 1");
        
        // ================================================================
        // FLAG VERIFICATION TESTS
        // ================================================================
        
        $display("\n═══════════════════════════════════════════════════════════════════════");
        $display("FLAG VERIFICATION TESTS");
        $display("═══════════════════════════════════════════════════════════════════════\n");
        
        $display("--- Carry Flag Tests ---");
        run_test(8'd255, 8'd1,   5'b00_000, 3'b000, 8'd0,   1'b1, "Carry from ADD");
        run_test(8'd255, 8'd255, 5'b00_000, 3'b000, 8'd254, 1'b1, "Carry Max+Max");
        run_test(8'd100, 8'd50,  5'b00_000, 3'b000, 8'd150, 1'b0, "No carry ADD");
        run_test(8'd255, 8'd1,   5'b00_010, 3'b000, 8'd0,   1'b1, "Carry from INC");
        run_test(8'd0,   8'd1,   5'b00_011, 3'b000, 8'd255, 1'b1, "Carry from DEC");
        
        $display("\n--- No Carry Tests (Logic, Shifter) ---");
        run_test(8'b11111111, 8'b11111111, 5'b01_000, 3'b000, 8'b11111111, 1'b0, "Logic: No carry");
        run_test(8'b11110000, 8'd0,        5'b10_001, 3'b010, 8'b00111100, 1'b0, "Shifter: No carry");
        
        // ================================================================
        // TEST SUMMARY
        // ================================================================
        
        $display("\n═══════════════════════════════════════════════════════════════════════");
        $display("╔══════════════════════════════════════════════════════════════════════╗");
        $display("║                         TEST SUMMARY                                 ║");
        $display("╠══════════════════════════════════════════════════════════════════════╣");
        $display("║ Total Tests:     %3d                                                 ║", test_count);
        $display("║ Passed:          %3d                                                 ║", pass_count);
        $display("║ Failed:          %3d                                                 ║", fail_count);
        if (test_count > 0)
            $display("║ Success Rate:    %6.2f%%                                              ║", (pass_count * 100.0) / test_count);
        $display("╚══════════════════════════════════════════════════════════════════════╝\n");
        
        if (fail_count == 0) begin
            $display("✓ ALL TESTS PASSED - ALU DESIGN VERIFIED!");
        end else begin
            $display("✗ %d TESTS FAILED - REVIEW DESIGN", fail_count);
        end
        
        $display("\n");
        $finish;
    end
    initial begin
        $dumpfile("tb_alu_8.vcd");
        $dumpvars(0, tb_alu);
    end
endmodule