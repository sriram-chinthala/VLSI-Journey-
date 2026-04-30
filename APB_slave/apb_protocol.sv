module apb_protocol(    // MASTER MODULE
    input logic clk ,rst_n ,pready,tx_start,op_value,
    input logic [31:0] pread_data,
    output logic [31:0] paddr,pwrite_data,
    output logic pwrite,penable,psel

);
typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;

state_t current_state,next_state;

logic [31:0] read_data_reg; // internal register to hold read data


always_ff @(posedge clk)
begin 
    if (!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always_comb begin 

    next_state = current_state;

    case(current_state)
        IDLE : begin
            if (tx_start)
                next_state = SETUP;
        end
        SETUP : next_state = ACCESS;        
        ACCESS : begin
            if (pready)
                begin
                    if(tx_start)
                        next_state = SETUP;
                    else
                        next_state = IDLE;
                end
        end
        default : next_state = IDLE;
    endcase
end


always_ff @(posedge clk)
begin 

    if(!rst_n)
    begin
        psel <= 0 ;
        penable <= 0 ;
        pwrite <= 0 ; // '0' means it is in read mode
        pwrite_data <= 32'h0000_0001;
        read_data_reg <=0;
        paddr <= 32'h0000_0000;
    end
    
    else
    begin
        case(current_state)

        IDLE: begin 
            penable <= 0;
            pwrite <= 0;
            paddr <= 32'h0000_0000;
            pwrite_data <= '0;
            psel <= 0 ;

        end

        SETUP: begin
            psel <= 1 ;
            penable <= 0 ;
            pwrite <= op_value ; // Set read/write based on op_value
            paddr <= 32'h0000_00FF; // Example address
            if(op_value) // used op_value instead of pwrite since pwrite is being set here with non blocking so it will take previous value not current.
            begin   
                pwrite_data <= 32'hDEAD_BEEF; // Example data to write
            end

        end

        ACCESS: begin
            penable <= 1 ;
            psel <= 1 ;
            // pwrite, paddr, and pwrite_data remain unchanged during ACCESS
            if (pready& ~pwrite) 
            begin
                read_data_reg <= pread_data; // Capture read data
                
            end 

        end
        default: begin
            penable <= 0 ;
            pwrite <= 0 ;
            paddr <= 32'h0000_0000;
            pwrite_data <= '0;  
        end
        endcase
    end
end


endmodule