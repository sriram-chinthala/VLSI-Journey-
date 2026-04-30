module counter_16 (
    input logic clk,
    input logic rst_n,
    output logic [15:0] count
);
always @(posedge clk)
begin
    if (!rst_n==1)
        count <= 0;
    else
    begin
        if (count == {16{1'b1}})
            count <= 0;
        else
            count <= count+1 ;
    end
end
endmodule