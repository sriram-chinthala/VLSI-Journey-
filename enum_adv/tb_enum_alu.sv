module tb_enum_alu;
    import alu_pkg::*;

    parameter WIDTH = 8;
    logic [WIDTH-1:0] in_a, in_b;
    alu_state op_code;
    logic [$clog2(WIDTH)-1:0] shift_amt;
    logic [WIDTH-1:0] out;

    // Instantiate with name "u_dut"
    enum_alu #(WIDTH) u_dut (.*);  // a auto connection way to connect ports and signals of design and tb with same names.  

    always @(in_a, in_b, op_code, shift_amt, out) begin
        #0;
        $display("Time: %0t | in_a: %0d | in_b: %0d | op: %s | shift: %0d | out: %0d", 
                 $time, 
                 in_a, 
                 in_b, 
                 op_code.name(), // This works in $display!
                 shift_amt, 
                 out
        );
    end

    initial begin
        
        // Test Stimulus
        in_a = 8'd15; in_b = 8'd3; shift_amt = 3'd2;

        op_code = add;          #10;
        op_code = sub;          #10;
        op_code = and_op;       #10;
        op_code = or_op;        #10;
        op_code = not_op;       #10;
        op_code = xor_op;       #10;
        op_code = right_shift;  #10;
        op_code = left_shift;   #10;
        op_code = right_sign_shift; #10;

        in_a = -8'd32;          #10;
        op_code = right_sign_shift; #10;

        in_a = 8'd100; in_b = 8'd25; shift_amt = 3'd3; #10;
        op_code = add;          #10;
        op_code = sub;          #10;
        op_code = and_op;       #10;
        op_code = or_op;        #10;
        op_code = not_op;       #10;
        op_code = xor_op;       #10;
        op_code = right_shift;  #10;
        op_code = left_shift;   #10;
        op_code = right_sign_shift; #10;

        #100 $finish;
    end 

    initial begin
        $dumpfile("out_enum_alu.vcd");
        $dumpvars(0,tb_enum_alu);
    end
    


endmodule