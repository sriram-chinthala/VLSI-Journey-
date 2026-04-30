module array_access;

    // Data Types
    logic [7:0] pack_array;          // 8-bit vector
    logic [3:0][7:0] multi_pack_array; // 2D Packed Array (4 rows, 8 columns)
    logic unpack_array [7:0];  // Array of 8 single bits
    logic [3:0] multi_array [1:0]; // 2D Array (2 rows, 4 columns)
    //logic assos_array [int];   // Associative array (integer index)
    logic dynamic_array [];    // Dynamic array (empty initially)
    int int_dynamic_array []; // Dynamic array of integers

    // Use 'initial' for simulation constructs like dynamic allocation
    initial begin : main_block

        // 1. Packed Array (Vector) Operation
        pack_array = 8'd44;
        $display("Content of packed array is %b | %b" , pack_array[3:0], pack_array[7:4]);
        multi_pack_array = {8'd10, 8'd20, 8'd30}; // Assigning values using concatenation
        multi_pack_array[3] = 8'd40; // Assigning value to the 3rd row
        $display("Content of multi_pack_array row 0 is %d", multi_pack_array[0][7:0]);
        $display("Content of multi_pack_array row 1 is %d", multi_pack_array[1]);
        $display("Content of multi_pack_array row 2 is %b | %b | %b | %b | %b | %b | %b | %b |", multi_pack_array[2][0], multi_pack_array[2][1], multi_pack_array[2][2], multi_pack_array[2][3], multi_pack_array[2][4], multi_pack_array[2][5], multi_pack_array[2][6], multi_pack_array[2][7]);
        $display("Content of multi_pack_array row 3 is %d", multi_pack_array[3][7:0]);

        // 2. Unpacked Array Operation

        unpack_array[0] = 1'b1;
        unpack_array[1] = 1'b0;
        unpack_array[2] = 1'b1;
        unpack_array[3] = 1'b0;
        unpack_array[4] = 1'b1;
        unpack_array[5] = 1'b0;
        unpack_array[6] = 1'b1;
        unpack_array[7] = 1'b0;
        $display("Content of unpacked array is %b | %b | %b | %b | %b | %b | %b | %b |" ,unpack_array[0],unpack_array[1],unpack_array[2], unpack_array[3], unpack_array[4],unpack_array[5],unpack_array[6],unpack_array[7]);

        multi_array[0][0] = 1'b1;
        multi_array[0][1] = 1'b1;
        multi_array[0][2] = 1'b0;
        multi_array[0][3] = 1'b0;
        multi_array[1] = 4'b1010; // Assigning entire row at once
        $display("Content of multi_array row 0 is %b | %b | %b | %b", multi_array[0][0], multi_array[0][1], multi_array[0][2], multi_array[0][3]);
        $display("content of the first word in multi_array is %b", multi_array[0]);
        $display("content of the second word in multi_array is %b", multi_array[1]);
        //$display("content of the in multi_array is %b", multi_array);

        // 3. Dynamic Array Operation
        // Allocate 8 locations. In Simulation, this is valid. 
        // In Synthesis (Hardware), this is ILLEGAL.
        dynamic_array = new[8]; 
        
        $display("Size of the dynamic array is %0d", dynamic_array.size());
        //dynamic_array [7:0]= 8'd10;
        //$display("Content of dynamic array is %b", dynamic_array);

        dynamic_array[0] = 1'b1;
        dynamic_array[1] = 1'b0;
        dynamic_array[2] = 1'b1;
        dynamic_array[3] = 1'b0;
        dynamic_array[4] = 1'b1;
        dynamic_array[5] = 1'b0;
        dynamic_array[6] = 1'b1;
        dynamic_array[7] = 1'b0;
        $display("Content of dynamic array is %b | %b | %b | %b | %b | %b | %b | %b |" ,dynamic_array[0],dynamic_array[1],dynamic_array[2], dynamic_array[3], dynamic_array[4],dynamic_array[5],dynamic_array[6],dynamic_array[7]);

        // Dynamic array of integers
        int_dynamic_array = new[4]; // Allocate 4 integer locations
        int_dynamic_array = {10, 30, 40}; // Assign values using concatenation
        int_dynamic_array[2] = 50; // modifying value to the 3rd element
        int_dynamic_array[3] = 5; // assigning the 4th element -> but it is not working as intended may be because the delcatation in the curly braces is not done .
        $display("Content of integer dynamic array is %0d | %0d | %0d | %0d |" ,int_dynamic_array[0], int_dynamic_array[1], int_dynamic_array[2], int_dynamic_array[3]);
    end

endmodule