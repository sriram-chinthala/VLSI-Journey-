// this is testbench file for a counter .

module tb_counter_4bit;
localparam width = 4;
reg clk,rst_n,load,enable;
reg [width-1:0] data_in;
wire [width-1:0] out;

counter_4bit #(.width(width)) 
            uut ( .clk(clk),
                .rst_n(rst_n),
                .enable(enable),
                .load(load),
                .data_in(data_in),
                .out(out)
            );


// commenting below block to avoid linting error while simulating remove comments for the below block.
/*
initial begin
    $dumpfile("counter.vcd");  // Name of the waveform file to generate
    $dumpvars(0, tb_counter_4bit); // 'tb_counter_4bit' is testbench module name.
end
*/

initial begin
    clk = 0;      // Initialize clock to a known state (low)
     /* verilator lint_off INFINITELOOP */
    forever #5 clk = ~clk; // Toggle the clock every 5 time units
    /* verilator lint_on INFINITELOOP */
end

initial begin
    // commenting due to avoid linting error , while running uncomment below line.
    //$monitor("time = %0t , enable = %b , rst_n = %b , load = %b , data_in=%d , out = %d",$time,enable,rst_n,load,data_in,out );
    
    enable=1'b1;
    rst_n=1'b1;
    load=1'b0;

    #10 enable=1'b0;
    #10 enable=1'b1;

    #50 rst_n=1'b0;
    #10 rst_n=1'b1;

    

    #100 data_in=4'b1011 ; load=1'b1;
    #10  load=1'b0;
    #100 data_in=4'b1111 ; load=1'b1;
    #10  load=1'b0;
    #10 enable=1'b0;
    #100 data_in=4'b0000 ; load=1'b1;
    #10  load=1'b0;
    #20 enable=1'b1;
    #100 data_in=4'b0011 ; load=1'b0;
    #20 rst_n=1'b0;
    #50 rst_n=1'b1;
#100 $finish;
end


endmodule