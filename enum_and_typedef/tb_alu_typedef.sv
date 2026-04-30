module tb_alu_typedef;

    // 1. Declare signals using the CUSTOM TYPE
    // Since alu_op_t is global in your design file, we can use it here directly.
    alu_op_t    tb_op;       
    logic [7:0] tb_a, tb_b;
    logic [7:0] tb_out;

    // 2. Instantiate the DUT
    alu_typedef dut (
        .operation (tb_op),  // Connect custom type to custom type
        .a_in      (tb_a),
        .b_in      (tb_b),
        .alu_output(tb_out)
    );

    initial begin
        $display("-----------------------------------------");
        $display(" VALERIUS LOG: ALU TYPEDEF TEST START ");
        $display("-----------------------------------------");

        // Initialize Data
        tb_a = 8'd10;
        tb_b = 8'd5;

        // ---------------------------------------------------------
        // METHOD 1: Direct Assignment
        // ---------------------------------------------------------
        tb_op = ALU_ADD;
        #10;
        // Use .name() to print "ALU_ADD" instead of "0"
        $display("Op: %s | A: %d, B: %d | Result: %d", tb_op.name(), tb_a, tb_b, tb_out);

        tb_op = ALU_AND;
        #10;
        $display("Op: %s | A: %d, B: %d | Result: %d", tb_op.name(), tb_a, tb_b, tb_out);


        // ---------------------------------------------------------
        // METHOD 2: Automatic Iteration (The Professional Way)
        // ---------------------------------------------------------
        $display("\n--- Starting Automatic Loop ---");
        
        // Start at the first enum value
        tb_op = tb_op.first(); 

        // Loop through all 7 enum values
        for (int i = 0; i < tb_op.num(); i++) begin
            #10;
            $display("Op: %10s | Result: %d", tb_op.name(), tb_out);
            
            // Move to the next enum value automatically
            tb_op = tb_op.next(); 
        end

        $display("-----------------------------------------");
        $finish;
    end

endmodule