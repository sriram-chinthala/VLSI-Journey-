// Code your testbench here
// or browse Examples
module tb;

    ex_if intf();                 // interface instance
    interface_ex dut(intf);       // connect interface to DUT

    initial begin
        intf.a = 0;
        intf.b = 1;
        #1;
        $display("the resulting value of c is %0d", intf.c);
        $finish;
    end

endmodule