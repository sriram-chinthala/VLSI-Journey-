module apb_slave (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] paddr,
    input  logic [31:0] pwrite_data,
    output logic        pready,
    output logic [31:0] pread_data
);

    // 256 x 32-bit register memory
    logic [31:0] memory_array [0:255];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            pready     <= 1'b1;
            pread_data <= 32'h0;
        end
        else begin
            // Default ready (no wait states)
            pready <= 1'b1;

            // ACCESS phase only
            if (psel && penable) begin
                if (pwrite) begin
                    // WRITE operation
                    memory_array[paddr[7:0]] <= pwrite_data;
                end
                else begin
                    // READ operation
                    pread_data <= memory_array[paddr[7:0]];
                end
            end
        end
    end

endmodule
