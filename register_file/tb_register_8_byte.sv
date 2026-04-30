module tb_register_8_byte ;

logic clk, we;
logic [2:0] waddr, raddr;
logic [7:0] wdata;
logic [7:0] rdata;  

register_8_byte DUT (
    .clk(clk),
    .we(we),
    .waddr(waddr),
    .raddr(raddr),
    .wdata(wdata),
    .rdata(rdata)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end     

initial begin
    we = 1;
    waddr = 3'b000;
    wdata = 8'd15;
    #10;
    waddr = 3'b001;
    wdata = 8'd25;
    #10;
    waddr = 3'b010;
    wdata = 8'd35;
    #10;
    waddr = 3'b011;
    wdata = 8'd45;
    #10;
    we = 0;
    raddr = 3'b000;
    #10;
    $display("Read data at address 0 is %d", rdata);
    raddr = 3'b001;
    #10;
    $display("Read data at address 1 is %d", rdata);
    raddr = 3'b010;
    #10;    
    $display("Read data at address 2 is %d", rdata);
    raddr = 3'b011;
    #10;    
    $display("Read data at address 3 is %d", rdata);
    raddr = 3'b100;
    #10;    
    $display("Read data at address 3 is %d", rdata);

    $finish;
end
    
endmodule