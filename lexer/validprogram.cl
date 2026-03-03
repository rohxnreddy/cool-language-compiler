class Main {

    main() : Object {

        {
            -- Variable declaration using let
            let x : Int     ,
                y : Int <- 2,
                z : Int <- 3,
                flag : Bool <- false
            in
            {

                -- Assignment statement
                x <- 1;

                -- multiple precedence (* higher than +)
                z <- x + y * 2;     
                (*
                    this is a multiline comment
                    here it is closed with * and )
                *)
                -- Loop statement
                while 0 < z loop
                    {
                        z <- z - 1;
                    }
                pool;

                -- Conditional statement
                if (x < y) and not flag then
                    out_string("Condition True\n")
                else
                    out_string("Condition False\n")
                fi;

            };
        }
    };
};