package pkt_counter_pkg;

typedef enum logic [1:0] {
    PKT_NONE,
    PKT_DATA,
    PKT_CTRL,
    PKT_ERR
  } pkt_type_t;

  typedef struct packed {
    pkt_type_t   ptype;
    logic [7:0]  length;
    logic [31:0] payload;
  } pkt_t;
    
endpackage

module packet_counter
import pkt_counter_pkg::*;
(
    input logic clk,valid,rst_n,
    input pkt_t pkt_in,
    output int unsigned total_bytes,
    output int unsigned data_pkts, ctrl_pkts, err_pkts

);

    always_ff @( posedge clk ) begin 

        if(!rst_n) begin
            total_bytes <= 0;
            data_pkts <= 0;
            ctrl_pkts <= 0;
            err_pkts <= 0;
        end
        else if (valid) begin
            total_bytes <= total_bytes + pkt_in.length;
            case (pkt_in.ptype)
                PKT_DATA: data_pkts <= data_pkts + 1;
                PKT_CTRL: ctrl_pkts <= ctrl_pkts + 1;
                PKT_ERR:  err_pkts <= err_pkts + 1;
            endcase
        end
        
    end


endmodule