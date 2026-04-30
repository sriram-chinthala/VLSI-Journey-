module arbiter(
    input logic clk,rst_n,transaction_done,
    input logic [2:0] grant_req, //request from the masters
    output logic [2:0] grant     //request approal from the arbiter
);
    

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            grant <= 3'b000;
        else if( grant != 3'b000 && !transaction_done)
            grant <= grant; // hold the grant until transaction is done
        else
            if(grant_req[0])
                grant <= 3'b001;
            else if(grant_req[1])
                grant <= 3'b010;
            else if(grant_req[2])
                grant <= 3'b100;
            else
                grant <= 3'b000; // no request

            

    end
       
endmodule