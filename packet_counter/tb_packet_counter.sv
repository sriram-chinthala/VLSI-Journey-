module tb_packet_counter;

    import pkt_counter_pkg::*;

    logic clk, valid, rst_n;
    pkt_t pkt_in;
    int unsigned total_bytes;
    int unsigned data_pkts, ctrl_pkts, err_pkts;

    packet_counter dut (
        .clk(clk),
        .valid(valid),
        .rst_n(rst_n),
        .pkt_in(pkt_in),
        .total_bytes(total_bytes),
        .data_pkts(data_pkts),
        .ctrl_pkts(ctrl_pkts),
        .err_pkts(err_pkts)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time unit clock period
    end

    initial begin // THE SIMULATION FAILS WITH ICARUS DUE TO TOOL LIMITAION

        rst_n = 0;
        valid = 0;
        pkt_in = '{ptype: PKT_NONE, length: 0, payload: 0};
        #15;
        rst_n = 1;
        #10;
        pkt_in = '{ptype: PKT_DATA, length: 100, payload: 32'hDEADBEEF};
        valid = 1;
        #10;
        pkt_in = '{ptype: PKT_CTRL, length: 50, payload: 32'hCAFEBABE};
        #10;
        pkt_in = '{ptype: PKT_ERR, length: 25, payload: 32'hBADF00D};
        #10;
        valid = 0;
        #10;
        pkt_in = '{ptype: PKT_DATA, length: 200, payload: 32'hFEEDFACE};
        valid = 1;
        #10;
        valid = 0;
        #20;
        $finish;

    end

    initial begin 

        $monitor("total bytes : %d | data pkts : %d | ctrl pkts : %d | err pkts : %d", total_bytes, data_pkts, ctrl_pkts, err_pkts);
    end

endmodule