`timescale 1ns / 1ps

module tb_ahb_apb_bridge();
    // AHB Signals
    reg HCLK, HRESETn, HSEL, HWRITE;
    reg [1:0] HTRANS;
    reg [31:0] HADDR, HWDATA;
    wire [31:0] HRDATA;
    wire HREADYOUT;

    // APB Signals (Internal to Bridge, but we monitor them)
    wire [31:0] PADDR, PWDATA;
    wire PSEL, PENABLE, PWRITE;
    reg [31:0] PRDATA;

    // Instantiate Bridge Top
    bridge_top dut (
        .HCLK(HCLK), .HRESETn(HRESETn), .HSEL(HSEL), 
        .HWRITE(HWRITE), .HTRANS(HTRANS), .HADDR(HADDR), 
        .HWDATA(HWDATA), .HRDATA(HRDATA), .HREADYOUT(HREADYOUT),
        .PADDR(PADDR), .PWDATA(PWDATA), .PSEL(PSEL), 
        .PENABLE(PENABLE), .PWRITE(PWRITE), .PRDATA(PRDATA)
    );

    // Clock Generation
    always #5 HCLK = ~HCLK;

    initial begin
        // Initialize
        HCLK = 0; HRESETn = 0; HSEL = 0; HTRANS = 0; 
        HADDR = 0; HWDATA = 0; PRDATA = 32'hBAADCAFE;
        
        #20 HRESETn = 1;
        #10;

        // --- TEST CASE 1: SINGLE WRITE ---
        @(posedge HCLK);
        HSEL = 1; HADDR = 32'hA0001000; HWRITE = 1; HTRANS = 2'b10; // NONSEQ
        
        @(posedge HCLK);
        HWDATA = 32'h12345678; // Data phase
        HTRANS = 2'b00; // IDLE
        
        wait(PENABLE); // Wait for bridge to trigger APB access
        #20;

        // --- TEST CASE 2: SINGLE READ ---
        @(posedge HCLK);
        HSEL = 1; HADDR = 32'hA0001000; HWRITE = 0; HTRANS = 2'b10;
        
        @(posedge HCLK);
        HTRANS = 2'b00;
        PRDATA = 32'hFEDCBA98; // Simulate Slave returning data

        wait(HREADYOUT);
        $display("Read Data: %h", HRDATA);
        
        #100;
        $finish;
    end
endmodule