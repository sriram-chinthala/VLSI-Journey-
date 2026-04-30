module tb_struct_status;

    import status_types_pkg::*; 
    status_t in_status_tb;
    status_t out_status_tb;

    struct_status u_struct_status (
        .in_status(in_status_tb),
        .out_status(out_status_tb)
    );

    initial begin

        in_status_tb = '{1'b1, 1'b0, ERR_TIMEOUT, 8'hFF};
        #10;
        
        // DISPLAY TRICK:
        // Use .name() on the specific field inside the struct
        $display("Status: Busy=%b | Error=%b | Count=%h", 
                 out_status_tb.busy, out_status_tb.error, out_status_tb.count);
                 
        $display("Error Code Raw: %h | Error Code Name: %s", 
                 out_status_tb.error_code,      // Prints 'a'
                 out_status_tb.error_code.name() // Prints 'ERR_TIMEOUT'
        );

        in_status_tb = '{1'b0, 1'b1, ERR_UNKNOWN, 8'hEF};
        #10;
        
        // DISPLAY TRICK:
        // Use .name() on the specific field inside the struct
        $display("Status: Busy=%b | Error=%b | Count=%h", 
                 out_status_tb.busy, out_status_tb.error, out_status_tb.count);
                 
        $display("Error Code Raw: %h | Error Code Name: %s", 
                 out_status_tb.error_code,      
                 out_status_tb.error_code.name() 
        );

        in_status_tb = '{1'b1, 1'b0, ERR_NONE, 8'h00};
        #10;
        
        // DISPLAY TRICK:
        // Use .name() on the specific field inside the struct
        $display("Status: Busy=%b | Error=%b | Count=%h", 
                 out_status_tb.busy, out_status_tb.error, out_status_tb.count);
                 
        $display("Error Code Raw: %h | Error Code Name: %s", 
                 out_status_tb.error_code,      
                 out_status_tb.error_code.name() 
        );
        $finish;

    end


endmodule