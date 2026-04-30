module arbiter (
    input [1:0] req,
    output reg grant
);

    always @(*) begin
        if (req[0])
            grant = 0;
        else if (req[1])
            grant = 1;
        else
            grant = 0;
    end

endmodule