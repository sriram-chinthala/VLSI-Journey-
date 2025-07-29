module tb_ALU_4bit;
localparam WIDTH = 4; // or any value to test

reg signed [WIDTH-1:0] a, b;
reg [1:0] sel;
wire signed [WIDTH-1:0] out; 
wire carry;

// Instantiate the design
ALU_4bit #(.width(WIDTH)) dut (
    .a(a),
    .b(b),
    .sel(sel),
    .out(out),
    .carry(carry)
);

initial begin
    $display("USER INSTRUCTION: Enter all ALU inputs (a, b) as signed 2's complement numbers.");
    $display("For SUBTRACTION (A - B), input A directly and input B as its 2's complement negative value. (No unsigned operations supported.)");

    $monitor("time=%t : sel = %b, a = %b , b = %b , out = %b , carry = %b",$time,sel,a,b,out,carry);

    sel = 2'b00; a=4'b0011; b=4'b0111; #10;     // AND TEST
    a=4'b0001; b=4'b0101; #10;
    a=4'b0111; b=4'b0011; #10; 
    a=4'b0010; b=4'b1111; #10;
    a=4'b1011; b=4'b0011; #10;
    a=4'b1011; b=4'b0110; #10; 
    a=4'b1111; b=4'b0100; #10;
    sel = 2'b10;                                //ADDITION AND SUBTRACTION TEST
    a=4'b0011; b=4'b0111; #10;
    a=4'b0001; b=4'b0101; #10;
    a=4'b0111; b=4'b0011; #10; 
    a=4'b0010; b=4'b1111; #10;
    a=4'b1011; b=4'b0011; #10;
    a=4'b1011; b=4'b0110; #10; 
    a=4'b1111; b=4'b0100; #10;
    sel = 2'b01;                                // OR TEST
    a=4'b0011; b=4'b0111; #10;
    a=4'b0001; b=4'b0101; #10;
    a=4'b0111; b=4'b0011; #10; 
    a=4'b0010; b=4'b1111; #10;
    a=4'b1011; b=4'b0011; #10;
    a=4'b1011; b=4'b0110; #10; 
    a=4'b1111; b=4'b0100; #10;
    
    #10 $finish;
end
    
endmodule