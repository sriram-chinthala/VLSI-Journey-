module queue_arrays;

int qu1[$], qu2[$];
int u, v;

initial begin

    qu1.push_back(1);
    qu1.push_back(2);
    qu1.push_back(3);
    qu1.push_front(4);
    qu1.push_front(5);

    $display("qu1 content:");
    foreach (qu1[i])
        $display("qu1[%0d] = %0d", i, qu1[i]);

    $display("different operations on queue:");

    u = qu1.pop_back();
    v = qu1.pop_front();

    $display("pop back value = %0d", u);
    $display("pop front value = %0d", v);

    $display("resulting queue:");
    foreach (qu1[i])
        $display("qu1[%0d] = %0d", i, qu1[i]);

    //u = qu1.min();// it is not working due to tool limitation use u = int'(qu1.min()); when using rivera 
    //$display(" the minimum value in the queue is %0d " , u);

    //the sort method do not work in icarus but will work with riviera
    /*
    qu1.sort();
    $display("resulting queue after sorting:");
    foreach (qu1[i])
        $display("qu1[%0d] = %0d", i, qu1[i]);

    */
end

endmodule
