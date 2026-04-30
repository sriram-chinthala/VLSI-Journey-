interface apb_if;

    logic clk,rst_n;
    logic pwrite;
    logic [7:0] paddr;
    logic [15:0] pwdata,prdata;
    logic psel,penable,pready;

    //master connection
    modport master(input clk,rst_n,prdata,pready,
                   output pwrite,pwdata,paddr,psel,penable);
    
    //slave connection
    modport slave (input clk,rst_n,pwrite,paddr,pwdata,psel,penable,
                  output prdata,pready);
endinterface

module multi_master(
    apb_if.master m1,
    //logic start_tx

);  

    typedef enum logic[1:0]{IDLE,SETUP,ACCESS} state_t;

    state_t current_state, next_state;

    always_ff @(posedge m1.clk or negedge m1.rst_n) begin
        if(!m1.rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if(start_tx)
                    next_state = SETUP;

            end

            SETUP: next_state = ACCESS;
            ACCESS:begin
                if(m1.pready)
                    next_state = IDLE;
                else
                    next_state = ACCESS;
            end
            default : next_state = IDLE;
        endcase
        
    end

    always_ff @(posedge m1.clk or negedge m1.rst_n) begin
        if(!m1.rst_n)
        begin
            m1.psel <= 0 ;
            m1.penable <= 0;
            m1.pwrite <= 0;
            m1.paddr <= 8'b0;
            m1.pwdata <= 16'b0;
        end
        else begin
        case (current_state)

            IDLE : begin

                m1.psel <= 0 ;
                m1.penable <= 0;
                m1.pwrite <= 0;
                m1.paddr <= 8'b0;
                m1.pwdata <= 16'b0;
            end

            SETUP : begin

                m1.psel <= 1;
                m1.penable <= 0;
                m1.pwrite <= 1;
                m1.paddr <= 8'hA6;
                m1.pwdata <= 16'd784;
            end

            ACCESS : begin
                m1.penable <= 1;
    
            end

            default : begin

                m1.psel <= 0 ;
                m1.penable <= 0;
                m1.pwrite <= 0;
                m1.paddr <= 8'b0;
                m1.pwdata <= 16'b0;
            end
        endcase
    end
    end

endmodule