module tb_fsm_2_always;

reg clk,in_bit,rst;
wire out;

fsm_2_always DUT (.clk(clk),.rst(rst),.in_bit(in_bit),.out(out));

initial begin
    clk = 0;
    rst = 0;
    in_bit = 0;
    // forever #5 clk = ~clk; // Uncomment this line to create a clock signal when simulating
end
/*  REMOVE THE COMMENTS WHEN SIMULATING
initial begin
    $monitor("Time=%0d rst=%b in_bit=%b out=%b",$time,rst,in_bit,out);
    #5 rst = 1; // Assert reset
    #10 rst = 0; // Deassert reset

    // Test sequence: 1,0,1,1 (should detect sequence)
    #10 in_bit = 1;
    #10 in_bit = 0;
    #10 in_bit = 1;
    #10 in_bit = 1;

    // Test sequence: 0,1,0,1 (should not detect sequence)
    #10 in_bit = 0;
    #10 in_bit = 1;
    #10 in_bit = 0;
    #10 in_bit = 1;

    // Test sequence: 1,0,1,1 (should detect sequence again but due to reset it won't be detected)
    #10 in_bit = 1;
    #10 in_bit = 0;
    #10 rst = 1; // Assert reset
    #10 rst = 0; // Deassert reset
    #10 in_bit = 1;
    #10 in_bit = 1;

    #20 $finish; // End simulation
end

initial begin
    $dumpfile("fsm_waveform.vcd");
    $dumpvars(0,tb_fsm_2_always);   
end
*/
endmodule 