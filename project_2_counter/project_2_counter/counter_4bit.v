// This is a 4-bit counter with parametarisations and with asyn reset,enable and load signals.
// This is part of my vlsi learning journey week 2 , project 2.
// notion link:https://www.notion.so/Forge-Quest-Forging-the-4-Bit-Counter-244abc13ad0f80488d05e54697c1ff88?source=copy_link

/* about the project: i am creating a 4 bit counter initially with parameter and it can be implemented for various 
number of bit sizes also. the counter is setted to '0'  when a active low reset signal is used and only will 
count when syncronous enable signal is activated. And when the load is selected the counter value will be loaded
into the output . So the priorirty goes like, asyn reset, load , sync enable , and finally count.  */

// author : chinthala sriram (B.tech 4 th year).



module counter_4bit #(
    parameter width=4
) (
    input clk,rst_n,enable,load,
    input [width-1:0] data_in,
    output [width-1:0] out
);
reg [width-1:0] count = 0;
    always @(posedge clk or negedge rst_n)begin
        if(~rst_n)begin
            count<=0;
        end
        else
            if(load)
                count<=data_in;
            
            else if(enable)begin
                count<=count+1;
            end
    end
    assign out=count;
endmodule