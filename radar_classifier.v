module radar_classifier (
    input target_valid,
    input [7:0] range_code,
    input [7:0] speed_code,
    input [7:0] amp_code,
    input [3:0] spread_code,
    input [3:0] motion_code,

    output dog,
    output human,
    output car,
    output plane,
    output alien
);

    assign dog =
        target_valid &&
        (speed_code >= 4 && speed_code <= 10) &&
        (spread_code >= 7) &&
        (motion_code >= 6);

    assign human =
        target_valid &&
        (speed_code >= 1 && speed_code <= 4) &&
        (spread_code >= 3 && spread_code <= 7) &&
        (motion_code >= 2 && motion_code <= 6);

    assign car =
        target_valid &&
        (speed_code >= 15 && speed_code <= 60) &&
        (amp_code >= 150) &&
        (spread_code <= 4);

    assign plane =
        target_valid &&
        (speed_code >= 70) &&
        (range_code >= 150) &&
        (amp_code >= 180);

    assign alien =
        target_valid &&
        !(dog || human || car || plane);

endmodule
