module interconnect(
    input apb_if.slave s1,
    output transaction_done
);

    assign transaction_done = s1.psel && s1.pready && s1.penable;
endmodule