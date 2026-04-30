module apb_interconnect (

    // Master 0
    input [31:0] PADDR_M0, PWDATA_M0,
    input PSEL_M0, PENABLE_M0, PWRITE_M0,
    output [31:0] PRDATA_M0,
    output PREADY_M0,

    // Master 1
    input [31:0] PADDR_M1, PWDATA_M1,
    input PSEL_M1, PENABLE_M1, PWRITE_M1,
    output [31:0] PRDATA_M1,
    output PREADY_M1,

    // Grant
    input grant,

    // Slave 0
    output [31:0] PADDR_S0, PWDATA_S0,
    output PSEL_S0, PENABLE_S0, PWRITE_S0,
    input [31:0] PRDATA_S0,
    input PREADY_S0,

    // Slave 1
    output [31:0] PADDR_S1, PWDATA_S1,
    output PSEL_S1, PENABLE_S1, PWRITE_S1,
    input [31:0] PRDATA_S1,
    input PREADY_S1
);

    wire [31:0] PADDR;
    wire [31:0] PWDATA;
    wire PSEL, PENABLE, PWRITE;

    // Select master
    assign PADDR   = (grant == 0) ? PADDR_M0   : PADDR_M1;
    assign PWDATA  = (grant == 0) ? PWDATA_M0  : PWDATA_M1;
    assign PSEL    = (grant == 0) ? PSEL_M0    : PSEL_M1;
    assign PENABLE = (grant == 0) ? PENABLE_M0 : PENABLE_M1;
    assign PWRITE  = (grant == 0) ? PWRITE_M0  : PWRITE_M1;

    // Address decoding
    assign PSEL_S0 = PSEL & (PADDR[15:12] == 4'h0);
    assign PSEL_S1 = PSEL & (PADDR[15:12] == 4'h1);

    // Route to slaves
    assign PADDR_S0 = PADDR;
    assign PWDATA_S0 = PWDATA;
    assign PENABLE_S0 = PENABLE;
    assign PWRITE_S0 = PWRITE;

    assign PADDR_S1 = PADDR;
    assign PWDATA_S1 = PWDATA;
    assign PENABLE_S1 = PENABLE;
    assign PWRITE_S1 = PWRITE;

    // Return path
    assign PRDATA_M0 = (grant == 0) ? (PRDATA_S0 | PRDATA_S1) : 0;
    assign PRDATA_M1 = (grant == 1) ? (PRDATA_S0 | PRDATA_S1) : 0;

    assign PREADY_M0 = (grant == 0) ? (PREADY_S0 | PREADY_S1) : 0;
    assign PREADY_M1 = (grant == 1) ? (PREADY_S0 | PREADY_S1) : 0;

endmodule