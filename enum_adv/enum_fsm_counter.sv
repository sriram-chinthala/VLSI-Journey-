package fsm_pkg;
    typedef enum logic [1:0] {IDLE, LOAD, COUNT} state_t;
endpackage

module enum_fsm_counter 
import fsm_pkg::*;
(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    output logic [3:0] count_value,
    output logic done
);
    // Removed "logic [3:0] count = 1111" (Bad synthesis style)
    logic [3:0] count; 

    state_t current_state, next_state;

    // --- BLOCK 1: State Memory (OWNS current_state) ---
    always_ff @(posedge clk) begin 
        if(!rst_n )
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // --- BLOCK 2: Next State Logic ---
    always_comb begin 
        // Good habit: Default next_state
        next_state = current_state; 
        
        case(current_state)
            IDLE:  if(start) next_state = LOAD; else next_state = IDLE;
            LOAD:  next_state = COUNT;
            COUNT: if(count == 0) next_state = IDLE; else next_state = COUNT;
            default: next_state = IDLE;
        endcase
    end

    // --- BLOCK 3: Datapath & Outputs ---
    always_ff @(posedge clk) begin
        if(!rst_n) begin
            count <= 4'd0;
            done  <= 1'b0;
        end else begin
            case(current_state)
                IDLE: begin 
                    done <= 1'b1; 
                end
                
                LOAD: begin 
                    count <= 4'd10; // FIX: Actually Load a value!
                    done  <= 1'b0; 
                end
                
                COUNT: begin 
                    count <= count - 1; 
                    done  <= 1'b0; 
                end
                
                // FIX: Removed 'default: current_state <= IDLE' (Multi-driver)
            endcase
        end
    end

    // FIX: Connect output continuously to internal counter
    assign count_value = count;

endmodule

