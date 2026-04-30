module overflow_test;
  
  int accum_int;              // 32-bit signed integer
  logic [10:0] accum_fix;     // 16-bit unsigned value
  logic [7:0] random_val;     // 8-bit random value (0-255)
  
  initial begin
    // Initialize accumulators to zero
    accum_int = 0;
    accum_fix = 0;
    
    // Loop 300 times
    for (int i = 0; i < 30; i++) begin
      // Generate random 8-bit value (0 to 255)
      random_val = $urandom_range(255,0);
      
      // Add to both accumulators
      accum_int = accum_int + random_val;
      accum_fix = accum_fix + random_val;
      
      // Display values every iteration
      $display("Iteration %0d: random=%0d, accum_int=%0d, accum_fix=%0d", 
               i, random_val, accum_int, accum_fix);
      
      // Check for overflow in accum_fix
      if (accum_fix < random_val) begin
        $display("*** accum_fix OVERFLOWED at iteration %0d! ***", i);
      end
    end
    
    $display("\nFinal Results:");
    $display("accum_int = %0d", accum_int);
    $display("accum_fix = %0d", accum_fix);
    
    $finish;
  end
  
endmodule