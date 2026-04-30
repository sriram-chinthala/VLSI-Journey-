`timescale 1ns / 1ps

module apb_master (
    // ------------------------------------------------------------------------
    // Clock and Reset
    // ------------------------------------------------------------------------
    input  wire        PCLK,
    input  wire        PRESETn,

    // ------------------------------------------------------------------------
    // Application Interface (From your CPU/Interconnect)
    // ------------------------------------------------------------------------
    input  wire        req_start,   // Pulse HIGH to start transaction
    input  wire        req_write,   // 1 = Write, 0 = Read
    input  wire [31:0] req_addr,
    input  wire [31:0] req_data,
    output reg         req_done,    // Pulses HIGH for 1 cycle when finished
    output reg  [31:0] req_rdata,   // Data read from slave

    // ------------------------------------------------------------------------
    // AMBA 3 APB Bus Interface (To Interconnect/Slaves)
    // ------------------------------------------------------------------------
    output reg         PSEL,
    output reg         PENABLE,
    output reg         PWRITE,
    output reg  [31:0] PADDR,
    output reg  [31:0] PWDATA,
    input  wire        PREADY,
    input  wire [31:0] PRDATA,
    input  wire        PSLVERR      // Ignored in this basic implementation
);

    localparam [1:0] 
        IDLE   = 2'b00,
        SETUP  = 2'b01,
        ACCESS = 2'b10;

    reg [1:0] current_state, next_state;

    // ========================================================================
    // COMBINATIONAL BLOCK: Next State Logic
    // ========================================================================
    always @(*) begin
        next_state = current_state; 

        case (current_state)
            IDLE: begin
                if (req_start) next_state = SETUP;
                else           next_state = IDLE;
            end

            SETUP: begin
                next_state = ACCESS; // Unconditional transition
            end

            ACCESS: begin
                if (PREADY) begin
                    if (req_start) next_state = SETUP; // Back-to-back transfer
                    else           next_state = IDLE;  // Transaction complete
                end else begin
                    next_state = ACCESS;               // Wait states
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // ========================================================================
    // SEQUENTIAL BLOCK: Handshakes and Look-Ahead Bus Outputs
    // ========================================================================
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            current_state <= IDLE;
            PSEL          <= 1'b0;
            PENABLE       <= 1'b0;
            PWRITE        <= 1'b0;
            PADDR         <= 32'h00000000;
            PWDATA        <= 32'h00000000;
            req_done      <= 1'b0;
            req_rdata     <= 32'h00000000;
        end else begin
            // 1. Advance State
            current_state <= next_state;

            // 2. Handshake & Read Logic (Based on Current State)
            if (current_state == ACCESS && PREADY) begin
                req_done <= 1'b1;
                if (!PWRITE) begin
                    req_rdata <= PRDATA; // Capture read data
                end
            end else begin
                req_done <= 1'b0;
            end

            // 3. APB Bus Output Logic (Based on Next State for glitch-free routing)
            case (next_state)
                IDLE: begin
                    PSEL    <= 1'b0;
                    PENABLE <= 1'b0;
                end
                
                SETUP: begin
                    PSEL    <= 1'b1;
                    PENABLE <= 1'b0;         
                    PWRITE  <= req_write;    // Dynamic read/write control
                    PADDR   <= req_addr;     
                    PWDATA  <= req_data;     
                end
                
                ACCESS: begin
                    PENABLE <= 1'b1;         
                    // PSEL, PADDR, PWDATA, PWRITE maintain stable values
                end
            endcase
        end
    end

endmodule