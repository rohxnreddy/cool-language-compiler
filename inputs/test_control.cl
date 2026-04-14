class ControlFlow {
    run() : Bool {
        let flag : Bool <- true, counter : Int <- 0 in {
            while counter < 10 loop {
                if flag then
                    counter <- counter + 2
                else
                    counter <- counter + 1
                fi;
                
                flag <- not flag;
            } pool;
            
            flag;
        }
    };
};