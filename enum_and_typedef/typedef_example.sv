module typedef_example;

typedef logic [7:0] byte_t; /* it is a type and it is a professional way to use ' _t ' for differentiating 
the type from variable to avoid assigning values to them.*/

byte_t a_byte ,b_byte;
byte_t c_byte;

initial begin
    a_byte = 8'd099;
    b_byte = 8'd201;
    c_byte = a_byte + b_byte;
    
    $display("the values that are added are %d | %d  result is %d",a_byte,b_byte,c_byte);

end


endmodule
