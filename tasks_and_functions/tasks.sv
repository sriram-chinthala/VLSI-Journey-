module tasks;

    int a,b;

    task pass_by_value(input int x,int y);

        x=x+y;
        $display("auguemnt a value inside the task (as x) is %0d ",x);

    endtask

    function int counter();// shared memory per call
        int c = 0;
        c++;
        return c;
    endfunction

    function automatic int counter_a();//differen memory per call
        int c = 0;
        c++;
        return c;
    endfunction

    /*
    task swap(ref int a, ref int b);
        int t;
        t = a;
        a = b;
        b = t;
    endtask
    */
    task automatic send(int id);
        int x;
        x = id;
        #10;
        $display(x);
    endtask


    

    initial 
    begin
        a = 10 ;
        pass_by_value(a,3);
        $display("the aurgument outside the task is %0d",a);

    b=counter();
    $display("counter value in with function call using static function is %d",b);
    b=counter();
    $display("counter value in with function call using static function is %d",b);
    b=counter();
    $display("counter value in with function call using static function is %d",b);
    b=counter();
    $display("counter value in with function call using static function is %d",b);

    b=counter_a();
    $display("counter value in with function call using automatic function is %d",b);
    b=counter_a();
    $display("counter value in with function call using automatic function is %d",b);
    b=counter_a();
    $display("counter value in with function call using automatic function is %d",b);
    b=counter_a();
    $display("counter value in with function call using automatic function is %d",b);

    /*
    swap(a,b);  //ref is not working with icarus
    $display(" the final values of a = %0d and b = %0d",a,b);
    */
    end

    initial

    fork        // when using fork we need to use automatic tasks.
        send(1);    
        send(2);
    join


endmodule