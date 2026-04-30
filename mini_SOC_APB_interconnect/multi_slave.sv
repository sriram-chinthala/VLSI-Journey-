module multi_slave(
    apb_if.slave s1
);

    logic [15:0] mem [255:0];

    always_ff @(posedge s1.clk or negedge s1.rst_n) begin
        if (!s1.rst_n) begin
            s1.prdata <= 16'h0000;
            s1.pready <= 1'b0;
        end
        else begin
            s1.pready <= 1'b0; // default

            if (s1.psel && s1.penable) begin
                s1.pready <= 1'b1;

                if (s1.pwrite) begin
                    mem[s1.paddr] <= s1.pwdata;   // WRITE
                end
                else begin
                    s1.prdata <= mem[s1.paddr];   // READ
                end
            end
        end
    end

endmodule