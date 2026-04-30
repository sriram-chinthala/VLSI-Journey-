module tb_apb_protocol();

    //only tb driving signals
    logic t_clk,t_rst_n ,t_tx_start,t_op_value;

    //only master driving signals
    logic t_psel,t_penable,t_pwrite;

    //only slave driving signals
    logic t_pready;

    //bidirectional signals
    logic [31:0] t_paddr,t_pwrite_data,t_pread_data;

    apb_protocol master (
        .clk(t_clk),
        .rst_n(t_rst_n),
        .pready(t_pready),
        .tx_start(t_tx_start),
        .op_value(t_op_value),
        .pread_data(t_pread_data),
        .paddr(t_paddr),
        .pwrite_data(t_pwrite_data),
        .pwrite(t_pwrite),
        .penable(t_penable),
        .psel(t_psel)
    );

    apb_slave slave (
        .clk(t_clk),
        .rst_n(t_rst_n),
        .psel(t_psel),
        .penable(t_penable),
        .pwrite(t_pwrite),
        .paddr(t_paddr),
        .pwrite_data(t_pwrite_data),
        .pready(t_pready),
        .pread_data(t_pread_data)
    );

    //clock generation
    always #5 t_clk = ~t_clk;

    initial begin
        // staring the trasaction
        t_clk = 0;
        t_rst_n = 0;
        t_tx_start = 0;
        t_op_value = 0;

        repeat(2) @(posedge t_clk);
        t_rst_n = 1; // release reset
        @(posedge t_clk);
        t_op_value = 1; // set operation value to write
        @(posedge t_clk);
        t_tx_start = 1; // start transaction
        @(posedge t_clk);
        t_tx_start = 0;

        @(posedge t_clk);
        t_tx_start = 1;
        @(posedge t_clk);
        t_tx_start = 0;
        t_op_value = 0; // set operation value to read
        @(posedge t_clk);
        repeat(3) @(posedge t_clk);
        t_tx_start = 0;
    
        @(posedge t_clk);

        $finish;

    end

    initial begin 
        $monitor("Time: %0t | psel: %b | penable: %b | pwrite: %b | tx_start: %h | paddr: %h | pwrite_data: %h | pready: %b | pread_data: %h",
                 $time, t_psel, t_penable, t_pwrite, t_tx_start, t_paddr, t_pwrite_data, t_pready, t_pread_data);
    end

    initial begin
        $dumpfile("apb_protocol_tb.vcd");
        $dumpvars(0, tb_apb_protocol);
    end
endmodule