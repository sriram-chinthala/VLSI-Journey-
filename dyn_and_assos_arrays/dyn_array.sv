module dyn_array;

int dyn1[], dyn2[],dyn3[];

initial begin 

    dyn1 = new[3]('{20,30,500});

    $display("Dynamic array contents:");
    foreach (dyn1[i])
        $display("dyn1[%0d] = %0d", i, dyn1[i]);

    //$display("dyn1 = %p", dyn1);//this statement is not working with iverilog but working with revera pro


    $display("size of the dynamic array is %0d" , dyn1.size());

    dyn1 = new[7](dyn1);

    dyn1[3] = 90;
    dyn1[4] = 1000;

    $display("dyamic array after increasing it's size by extending with it's elements : ");

    foreach (dyn1[i])
        $display("dyn1[%0d] = %0d", i, dyn1[i]);

    dyn2 = dyn1;// with this copy both arrays are independent on one another.
    $display("dynamic array 2 content : ");
    foreach (dyn2[i])
        $display("dyn2[%0d] = %0d", i, dyn2[i]);

    dyn2[5] = dyn2[1] + 20;
    dyn2[6] = dyn2[4] - 200;
    dyn2[1] = dyn2[5] * 2;   

    $display("dynamic array 2 after the operations to its members :");
    foreach (dyn2[i])
        $display("dyn2[%0d] = %0d", i, dyn2[i]);

    //the statement below with operations is not working with iverilog but works with rivera pro
    //$display("sum of the array is %d | or of the array is %b | and of the array is %b |",dyn2.sum(),dyn2.or(),dyn2.and());

    dyn3 = new[6]('{1,2,3,4,5,6});
    $display("dynamic array 3 content : ");
    foreach (dyn3[i])
        $display("dyn3[%0d] = %0d", i, dyn3[i]);

    dyn3 = new[4](dyn1);

    $display("dynamic array 3 content after decreasing it's size: ");
    foreach (dyn3[i])
        $display("dyn3[%0d] = %0d", i, dyn3[i]);

    $display("Dynamic array 1 contents:");    
    foreach (dyn1[i])
        $display("dyn1[%0d] = %0d", i, dyn1[i]);

    dyn1.delete();
    $display("size after delete = %0d", dyn1.size());



end

endmodule
