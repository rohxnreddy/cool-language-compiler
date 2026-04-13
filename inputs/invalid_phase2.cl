class Main {
    main() : Int {
        let x : Int <- 10 in {
            while 0 < x loop {
                x <- x - 1    -- ERROR: Missing semicolon here
            } pool;
            
            if x < 5 then
                x <- 5
            -- ERROR: Missing 'else' branch (required by grammar)
            fi;
        }
    };
};