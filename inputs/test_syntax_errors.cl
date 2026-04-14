class Broken {
    -- ERROR: Missing colon ':' before the return type
    brokenMethod() Int {
        
        -- ERROR: Missing the 'in' keyword for the let expression
        let x : Int <- 5 {
            
            -- ERROR: 'if' statement is missing the 'fi' closing keyword
            if x < 10 then
                x <- x + 1
            else
                x <- x - 1;
                
        }
    };
};