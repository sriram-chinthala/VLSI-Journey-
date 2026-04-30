// interface
interface ex_if;
    logic a, b;
    logic c;
endinterface


// DUT
module interface_ex(ex_if intf);        //interfaces is not suported by icarus use riviera

    always_comb begin
        intf.c = intf.a ^ intf.b;
    end

endmodule
