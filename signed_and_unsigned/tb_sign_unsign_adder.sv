module tb_sign_unsign_adder;
    // Unsigned signals
    bit [7:0] u_a, u_b;
    logic [8:0] u_sum;

    // Signed signals
    logic signed [7:0] s_a, s_b;
    logic signed [8:0] s_sum;

    //sign and unsigned sum
    logic  [8:0] sign_unsign_sum;

    // Instantiate the DUT
    sign_unsing_adder dut (
        .u_a(u_a),
        .u_b(u_b),
        .u_sum(u_sum),
        .s_a(s_a),
        .s_b(s_b),
        .s_sum(s_sum),
        .sign_unsign_sum(sign_unsign_sum)
    );

    initial begin
        // Test unsigned addition
        u_a = 8'd100;
        u_b = 8'd28;
        #10;
        $display("Unsigned Addition: %0d + %0d = %0d", u_a, u_b, u_sum);

        // Test signed addition
        s_a = 8'sd10;
        s_b = -8'sd28;
        #10;
        $display("Signed Addition: %0d + %0d = %0d", s_a, s_b, s_sum);
        $display("sign and unsigned sum is : %d + %d = %d",u_a,s_b,sign_unsign_sum);
        // Test unsigned addition
        u_a = 8'd0;
        u_b = 8'd28;
        #10;
        $display("Unsigned Addition: %0d + %0d = %0d", u_a, u_b, u_sum);

        // Test signed addition
        s_a = -8'sd10;
        s_b = -8'sd28;
        #10;
        $display("Signed Addition: %0d + %0d = %0d", s_a, s_b, s_sum);
        $display("sign and unsigned sum is : %d + %d = %d",u_a,s_b,sign_unsign_sum);

        // Test unsigned addition
        u_a = 8'd127;
        u_b = 8'd128;
        #10;
        $display("Unsigned Addition: %0d + %0d = %0d", u_a, u_b, u_sum);

        // Test signed addition
        s_a = 8'sd127;
        s_b = 8'sd128;
        #10;
        $display("Signed Addition: %0d + %0d = %0d", s_a, s_b, s_sum);
        $display("sign and unsigned sum is : %d + %d = %d",u_a,s_b,sign_unsign_sum);

        // Finish simulation
        $finish;
    end
endmodule