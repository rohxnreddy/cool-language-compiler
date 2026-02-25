class Main {

    main() : Object {

        {
            let x : Int,
                y : Int <- 2,
                z : Int <- 3,
                flag : Bool <- false
            in
            {

                x = 1;   -- ERROR 1: wrong assignment operator (should be <-)

                z <- x + y * ;   --  ERROR 2: incomplete expression

                while z > 0
                    {
                        z <- z - 1
                    }
                pool;   --  ERROR 3: missing 'loop' keyword and missing semicolon

                if (x < y) and not flag
                    out_string("Condition True\n")
                else
                    out_string("Condition False\n");
                --  ERROR 4: missing 'then' and missing 'fi'

            };
        }
    };
};