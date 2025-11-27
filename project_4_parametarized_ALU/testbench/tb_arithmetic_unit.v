module tb_arithmetic_unit;
    parameter DATA_WIDTH = 8;
    
    reg [DATA_WIDTH-1:0] a, b;
    reg [2:0] arith_op;
    wire [DATA_WIDTH-1:0] result;
    wire carry_out;
    wire [2*DATA_WIDTH-1:0] mult_result;
    
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    arithmetic_unit #(.DATA_WIDTH(DATA_WIDTH)) uut (
        .a(a),
        .b(b),
        .arith_op(arith_op),
        .result(result),
        .carry_out(carry_out),
        .mult_result(mult_result)
    );
    
    // Simplified task without string parameter
    task run_test;
        input [7:0] op_code;  // 0=ADD, 1=SUB, 2=INC, 3=DEC, 4=MUL
        input [DATA_WIDTH-1:0] test_a;
        input [DATA_WIDTH-1:0] test_b;
        input [DATA_WIDTH-1:0] exp_result;
        input exp_carry;
        input [2*DATA_WIDTH-1:0] exp_mult;
        
        reg [19:0] op_name;  // Store operation name as reg (not string)
        
        begin
            test_count = test_count + 1;
            a = test_a;
            b = test_b;
            arith_op = op_code;
            #10;
            
            // Determine operation name
            case (op_code)
                3'b000: op_name = "ADD ";
                3'b001: op_name = "SUB ";
                3'b010: op_name = "INC ";
                3'b011: op_name = "DEC ";
                3'b100: op_name = "MUL ";
                default: op_name = "UNKN";
            endcase
            
            // Check results based on operation type
            if (op_code == 3'b100) begin  // MUL
                if (mult_result == exp_mult) begin
                    $display("[PASS %3d] %s | a=%3d, b=%3d | mult_result=%5d", 
                             test_count, op_name, test_a, test_b, mult_result);
                    pass_count = pass_count + 1;
                end else begin
                    $display("[FAIL %3d] %s | a=%3d, b=%3d | Got: %5d, Expected: %5d", 
                             test_count, op_name, test_a, test_b, mult_result, exp_mult);
                    fail_count = fail_count + 1;
                end
            end else begin  // ADD, SUB, INC, DEC
                if (result == exp_result && carry_out == exp_carry) begin
                    $display("[PASS %3d] %s | a=%3d, b=%3d | result=%3d, carry=%b", 
                             test_count, op_name, test_a, test_b, result, carry_out);
                    pass_count = pass_count + 1;
                end else begin
                    $display("[FAIL %3d] %s | a=%3d, b=%3d | Got: result=%3d, carry=%b | Expected: result=%3d, carry=%b", 
                             test_count, op_name, test_a, test_b, result, carry_out, exp_result, exp_carry);
                    fail_count = fail_count + 1;
                end
            end
        end
    endtask
    
    initial begin
        $display("\n========== ARITHMETIC UNIT TEST SUITE (DATA_WIDTH = %0d bits) ==========\n", DATA_WIDTH);
        
        // ADD TESTS (opcode 3'b000)
        $display("=== ADD TESTS ===");
        run_test(3'b000, 8'd150, 8'd100, 8'd250, 1'b0, 16'd0);    // Normal add
        run_test(3'b000, 8'd200, 8'd100, 8'd44,  1'b1, 16'd0);    // With carry (300 mod 256 = 44)
        run_test(3'b000, 8'd255, 8'd1,   8'd0,   1'b1, 16'd0);    // Max + 1
        run_test(3'b000, 8'd0,   8'd0,   8'd0,   1'b0, 16'd0);    // Zero + Zero
        run_test(3'b000, 8'd128, 8'd127, 8'd255, 1'b0, 16'd0);    // Near max
        run_test(3'b000, 8'd255, 8'd255, 8'd254, 1'b1, 16'd0);    // Max + Max
        
        // SUB TESTS (opcode 3'b001)
        $display("\n=== SUB TESTS ===");
        run_test(3'b001, 8'd150, 8'd100, 8'd50,  1'b0, 16'd0);    // Normal subtract
        run_test(3'b001, 8'd50,  8'd100, 8'd206, 1'b1, 16'd0);    // Underflow (-50 mod 256 = 206)
        run_test(3'b001, 8'd255, 8'd1,   8'd254, 1'b0, 16'd0);    // Max - 1
        run_test(3'b001, 8'd0,   8'd0,   8'd0,   1'b0, 16'd0);    // Zero - Zero
        run_test(3'b001, 8'd100, 8'd100, 8'd0,   1'b0, 16'd0);    // a == b
        run_test(3'b001, 8'd0,   8'd1,   8'd255, 1'b1, 16'd0);    // 0 - 1
        
        // INC TESTS (opcode 3'b010)
        $display("\n=== INC TESTS ===");
        run_test(3'b010, 8'd255, 8'd0, 8'd0,   1'b1, 16'd0);      // Max increment
        run_test(3'b010, 8'd100, 8'd0, 8'd101, 1'b0, 16'd0);      // Normal
        run_test(3'b010, 8'd0,   8'd0, 8'd1,   1'b0, 16'd0);      // Zero increment
        run_test(3'b010, 8'd127, 8'd0, 8'd128, 1'b0, 16'd0);      // Middle
        run_test(3'b010, 8'd254, 8'd0, 8'd255, 1'b0, 16'd0);      // Near max
        
        // DEC TESTS (opcode 3'b011)
        $display("\n=== DEC TESTS ===");
        run_test(3'b011, 8'd0,   8'd0, 8'd255, 1'b1, 16'd0);      // Zero decrement
        run_test(3'b011, 8'd100, 8'd0, 8'd99,  1'b0, 16'd0);      // Normal
        run_test(3'b011, 8'd1,   8'd0, 8'd0,   1'b0, 16'd0);      // To zero
        run_test(3'b011, 8'd128, 8'd0, 8'd127, 1'b0, 16'd0);      // Middle
        run_test(3'b011, 8'd2,   8'd0, 8'd1,   1'b0, 16'd0);      // Near zero
        
        // MUL TESTS (opcode 3'b100)
        $display("\n=== MUL TESTS ===");
        run_test(3'b100, 8'd10,  8'd5,   8'd0, 1'b0, 16'd50);           // Normal
        run_test(3'b100, 8'd255, 8'd2,   8'd0, 1'b0, 16'd510);          // Max * 2
        run_test(3'b100, 8'd255, 8'd255, 8'd0, 1'b0, 16'd65025);        // Max * Max
        run_test(3'b100, 8'd0,   8'd100, 8'd0, 1'b0, 16'd0);            // Zero multiply
        run_test(3'b100, 8'd1,   8'd255, 8'd0, 1'b0, 16'd255);          // 1 * Max
        run_test(3'b100, 8'd16,  8'd16,  8'd0, 1'b0, 16'd256);          // 16^2
        run_test(3'b100, 8'd200, 8'd200, 8'd0, 1'b0, 16'd40000);        // Medium
        run_test(3'b100, 8'd7,   8'd11,  8'd0, 1'b0, 16'd77);           // Small
        
        // TEST SUMMARY
        $display("\n========== TEST SUMMARY ==========");
        $display("Total Tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        if (test_count > 0)
            $display("Success Rate: %0.1f%%", (pass_count * 100.0) / test_count);
        $display("\n");
        
        if (fail_count == 0)
            $display("✓ ALL TESTS PASSED!");
        else
            $display("✗ SOME TESTS FAILED!");
        
        $finish;
    end
endmodule
