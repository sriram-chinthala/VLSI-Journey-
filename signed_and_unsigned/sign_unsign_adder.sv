module sign_unsing_adder (
    input  byte u_a,u_b,
    output bit [8:0] u_sum,
    input  logic signed [7:0] s_a,s_b,
    output bit signed [8:0] s_sum,
    output logic [8:0] sign_unsign_sum
);
    assign u_sum = u_a + u_b;
    assign s_sum = s_a + s_b;
    assign sign_unsign_sum = u_a + s_b;
    
endmodule