class MathTest {
    calculate() : Int {
        let a : Int <- 5, b : Int <- 10, c : Int in {
            -- Should generate TAC that multiplies (b * 2) first
            c <- a + b * 2;       
            
            -- Should generate TAC that adds (a + b) first
            c <- (a + b) * 2;     
            
            -- Should handle division and subtraction
            c <- a / b - 3;
        }
    };
};