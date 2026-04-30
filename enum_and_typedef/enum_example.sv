module enum_ex;

enum logic [1:0] {IDLE= 2'b01 ,RUN , STOP = 2'b00} state,next_state; // these are variables.

/*I used the enum data type to check whether i can create my own varilabe without rewriting the line of code
again and it woked , but this can not replace the typedef function, as typedef is portatble and can be used
in module instatiation or for input or output of a module which are not possible with enum thye can be used
for a private variable within a module those who do not used for function inputs or cross modules.*/

initial begin
    state = RUN;
    next_state = IDLE ;
    $display("the first value in the enum is %d", IDLE);
    $display("the last value in the enum is %d", STOP);
    $display("the current value in the enum is %s", state.name());
    $display("the current value in the next_state enum is %s", next_state.name());

end

endmodule