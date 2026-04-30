module tb_trans_struct;
  import types_pkg::*; // Import struct here too!

  txn_t in_struct_tb;
  logic [1:0] push_idx;
  txn_t fifo_tb [3:0];

  trans_struct u_trans_struct (
      .in_struct(in_struct_tb),
      .push_idx(push_idx),
      .fifo(fifo_tb)
  ); 

  initial begin
    in_struct_tb = '{8'hA0, 32'hDEADBEEF, 1'b1};
    push_idx = 2;
    #10;
    $display("FIFO[2]: %h", fifo_tb[2].data);
    $finish;
  end
endmodule