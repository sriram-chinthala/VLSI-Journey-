module tb_counter_16;
logic clk;
logic rst_n;
logic [15:0] count;

counter_16 dut(.clk(clk),.rst_n(rst_n),.count(count));

initial begin
    rst_n = 1;
    clk = 0;

end

initial begin
    #10 rst_n = 0 ;
    #10 rst_n = 1; 
    #100 rst_n = 0 ;
    #30 rst_n = 1 ;
end

always #5 clk = ~clk ;

initial begin
    $monitor("%0t\t%b\t%0d", $time, rst_n, count);
    #1000 $finish ;

end
initial begin
    $dumpfile("counter_16.vcd");
    $dumpvars(0,tb_counter_16);
end
endmodule