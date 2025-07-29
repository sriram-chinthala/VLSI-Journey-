// this is the notion page taks : https://www.notion.so/Forge-Quest-Forging-the-ALU-NAND-Only-236abc13ad0f8099a53eec88855b7576?source=copy_link
//this is a part of the my vlsi learing journey with my valerius system.

//coder: sriram (B.tech 4th year)
//code : ALU design using only nand gates with operations like add, subtract, AND and OR.
/*
==================================================================================
IMPORTANT USER NOTE:
- ALU_4bit expects ALL input numbers (a, b) to be in signed 2’s complement form.
- For SUBTRACTION: Provide B in 2’s complement negative form (i.e., input -B directly).
- Internal carry-in is fixed at 0; no internal inversion or subtraction hardware.
- This ALU does NOT support unsigned numbers or native subtraction control.
==================================================================================
*/

module or_nand (
    input a,b,
    output out
);
   wire a1,b1;
   nand n1(a1,a,a);
   nand n2(b1,b,b);
   nand n3(out,b1,a1);

endmodule

module and_nand (
    input a,b,
    output out
);
    wire o1; 
    nand n4(o1,b,a);
    nand n5(out,o1,o1);
   
endmodule


module nand_xor (
    input a,b,
    output out
);
    wire w1,w2,not_a,not_b;
    nand n6(not_a,a,a);
    nand n7(not_b,b,b);
    nand n8(w1,not_a,b);
    nand n9(w2,a,not_b);
    nand n10(out,w1,w2);
endmodule

module full_adder_nand (        // same circuit will be also used for subtraction as we are using 2's complement
    input a,b,c,
    output sum,carry
);
    wire a_xor_b,a_and_b,w1;
    nand_xor m1(a,b,a_xor_b);
    nand_xor m2(a_xor_b,c,sum);
    and_nand m3(a,b,a_and_b);
    and_nand m4(c,a_xor_b,w1);
    or_nand m5(a_and_b,w1,carry);
endmodule

// top module

module ALU_4bit #(parameter  width = 4 ) (
    input signed [width-1:0] a,b,                   // using 'signed' construct will allow number to input in 2's complement form.
    input [1:0] sel,
    output reg signed [width-1:0] out,  
    output reg carry
);
wire [width:0] c ;
wire [width-1:0] and_out,or_out,adder_out,sum_out;
assign c[0]=0;
genvar i;
generate             
        for (i=0;i<width;i=i+1)begin: gen_loop
        and_nand main1(a[i],b[i],and_out[i]);      // bitwise AND
        or_nand main2(a[i],b[i],or_out[i]);       // bitwise OR
        full_adder_nand main3(a[i],b[i],c[i],sum_out[i],c[i+1]);      // addition and subtraction based no the number given .
       end 
        
endgenerate

always @(*) begin
    case (sel)
        2'b00: out = and_out;
        2'b01: out = or_out;
        2'b10:begin
            out=sum_out;
            carry = c[width];
        end
        default: out = {width{1'b0}};
    endcase
end
endmodule
