// this code is for implemeting a 4 state fsm fr decting sequence 1011 
//using two always blocks each for state transition and output logic

module fsm_2_always (
    input clk,rst,in_bit,
    output reg out
);
parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;

reg [1:0] state;

initial begin  //for initializing state and output
    state = S0;
    out = 0;
end

always @(posedge clk or posedge rst) begin:state_transition
    if(rst)
        state <= S0;
    else begin
        case(state)
            S0: state <= in_bit ? S1 : S0;
            S1: state <= in_bit ? S1 : S2;
            S2: state <= in_bit ? S3 : S0;
            S3: state <= in_bit ? S1 : S1;
            default: state <= S0;
        endcase
    end
end

always @(posedge clk) begin:output_logic
    case(state)
        S0: out = in_bit ? 0 : 0;
        S1: out = in_bit ? 0 : 0;
        S2: out = in_bit ? 0 : 0;
        S3: out = in_bit ? 1 : 0;
        default: out = 0;
    endcase
end

endmodule