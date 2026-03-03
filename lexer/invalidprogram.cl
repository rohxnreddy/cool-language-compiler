class Main {

    main() : Object {

        {
            -- Variable declaration using let
            let x : Int     ,
                y : Int = 2, -- ERROR : no '=' operator
                1z : Int <- 3, --ERROR : identifier starts with number 
                flag : Bool <- false
            in
            {

                -- Assignment statement
                x <- 1;

                -- multiple precedence (* higher than +)
                z <- x + y * 2;     
                
                -- Loop statement
                while z > 0 loop -- ERROR : no '>' operator
                    {
                        z <- z - 1; -- ERROR : wrong '>-' operator
                    }
                pool;

                -- Conditional statement
                if (x < y) and not flag then
                    out_string("Condition True\n")
                else
                    out_string("Condition False\n")
                fi;
                (*
                    this is a multiline comment
                    here it is closed with * and )
                
            };
        }
    };
};