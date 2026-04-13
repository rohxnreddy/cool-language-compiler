class Main {
    main() : Int {
        let x : Int <- 10, y : Int <- 0 in {
            while 0 < x loop {
                y <- y + x;
                x <- x - 1;
            } pool;

            if y <= 50 then
                y <- 50
            else
                y <- y
            fi;
        }
    };
};
