`timescale 1ns / 1ps

module tb_apb_master;

    // 1. TB Signals
    reg         PCLK;
    reg         PRESETn;
    
    // Application Side
    reg         req_start;
    reg         req_write;
    reg  [31:0] req_addr;
    reg  [31:0] req_data;
    wire        req_done;
    wire [31:0] req_rdata;
    
    // APB Bus Side
    wire        PSEL;
    wire        PENABLE;
    wire        PWRITE;
    wire [31:0] PADDR;
    wire [31:0] PWDATA;
    reg         PREADY;
    reg  [31:0] PRDATA;
    reg         PSLVERR;

    // 2. Instantiate DUT
    apb_master uut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .req_start(req_start),
        .req_write(req_write),
        .req_addr(req_addr),
        .req_data(req_data),
        .req_done(req_done),
        .req_rdata(req_rdata),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PREADY(PREADY),
        .PRDATA(PRDATA),
        .PSLVERR(PSLVERR)
    );

    // 3. Clock Gen (10ns -> 100MHz)
    always #5 PCLK = ~PCLK;

    // 4. Test Sequence
    initial begin
        $dumpfile("apb_master_waves.vcd");
        $dumpvars(0, tb_apb_master);

        // Initialize
        PCLK      = 0;
        PRESETn   = 0;
        req_start = 0;
        req_write = 0;
        req_addr  = 0;
        req_data  = 0;
        PREADY    = 0;
        PRDATA    = 0;
        PSLVERR   = 0;

        // Reset system
        #15 PRESETn = 1;

        // ==========================================
        // TEST 1: WRITE (With 1 Wait State)
        // ==========================================
        @(posedge PCLK); 
        req_start = 1;
        req_write = 1;
        req_addr  = 32'hAAAA_BBBB;
        req_data  = 32'hDEAD_BEEF;

        @(posedge PCLK);
        req_start = 0; // Master in SETUP
        PREADY    = 0; // Slave not ready yet

        @(posedge PCLK);
        // Master in ACCESS (Wait State 1)
        PREADY    = 1; // Slave is now ready

        @(posedge PCLK);
        // Transaction finishes
        PREADY    = 0;

        #20; // Idle gap

        // ==========================================
        // TEST 2: READ (0 Wait States)
        // ==========================================
        @(posedge PCLK); 
        req_start = 1;
        req_write = 0; // 0 for READ
        req_addr  = 32'h1111_2222;

        @(posedge PCLK);
        req_start = 0; // Master in SETUP

        @(posedge PCLK);
        // Master in ACCESS
        PREADY    = 1; 
        PRDATA    = 32'hCAFE_F00D; // Slave provides data

        @(posedge PCLK);
        PREADY    = 0;

        #30;
        $finish;
    end

endmodule