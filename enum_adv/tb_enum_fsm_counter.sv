module tb_enum_fsm_counter;
    import fsm_pkg::*; 

    logic clk, rst_n, start;
    logic [3:0] count_value;
    logic done;

    // Instantiate with name "u_dut"
    enum_fsm_counter u_dut (.*);  // a auto connection way to connect ports and signals of design and tb with same names.

    // --- THE MONITORING BLOCK ---
    always @(u_dut.current_state) begin
        $display("Time: %0t | State Changed to: %s | done: %0b | count: %0d", 
                 $time, 
                 u_dut.current_state.name(), // <--- HIERARCHICAL ACCESS
                 u_dut.done,
                 u_dut.count_value
        );
    end

    initial begin
        // Test Stimulus
        clk = 0; rst_n = 0; start = 0;
        #15 rst_n = 1;
        #10 start = 1;
        #10 start = 0;
        #400 start = 1;
        #10 start = 0;
        #10000 $finish;
    end

    initial begin
        $dumpfile("tb_enum_fsm_counter.vcd");
        $dumpvars(0, tb_enum_fsm_counter);
    end
    
    always #5 clk = ~clk;

endmodule