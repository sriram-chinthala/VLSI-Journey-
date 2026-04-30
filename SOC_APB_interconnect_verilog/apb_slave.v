module apb_slave (
    input PCLK, PRESETn,

    input [31:0] PADDR,
    input [31:0] PWDATA,
    output reg [31:0] PRDATA,
    input PSEL,
    input PENABLE,
    input PWRITE,
    output PREADY
);

    reg [31:0] mem [0:255];

    always @(posedge PCLK) begin
        if (PSEL && PENABLE) begin
            if (PWRITE)
                mem[PADDR[7:0]] <= PWDATA;
            else
                PRDATA <= mem[PADDR[7:0]];
        end
    end

    assign PREADY = 1;

endmodule