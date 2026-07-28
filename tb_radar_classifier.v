// Copyright © 2026 Sam Jensen. All rights reserved.

`timescale 1ns/1ps

module tb_radar_classifier;

    reg target_valid;
    reg [7:0] range_code;
    reg [7:0] speed_code;
    reg [7:0] amp_code;
    reg [3:0] spread_code;
    reg [3:0] motion_code;

    wire dog;
    wire human;
    wire car;
    wire plane;
    wire alien;

    radar_classifier dut (
        .target_valid(target_valid),
        .range_code(range_code),
        .speed_code(speed_code),
        .amp_code(amp_code),
        .spread_code(spread_code),
        .motion_code(motion_code),
        .dog(dog),
        .human(human),
        .car(car),
        .plane(plane),
        .alien(alien)
    );

    initial begin
        $display("scenario,target_valid,range,speed,amp,spread,motion,dog,human,car,plane,alien");

        // Dog-like target
        target_valid = 1;
        range_code = 22;
        speed_code = 6;
        amp_code = 120;
        spread_code = 9;
        motion_code = 8;
        #10;
        $display("dog_case,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
            target_valid, range_code, speed_code, amp_code, spread_code, motion_code,
            dog, human, car, plane, alien);

        // Human-like target
        target_valid = 1;
        range_code = 18;
        speed_code = 2;
        amp_code = 90;
        spread_code = 5;
        motion_code = 4;
        #10;
        $display("human_case,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
            target_valid, range_code, speed_code, amp_code, spread_code, motion_code,
            dog, human, car, plane, alien);

        // Car-like target
        target_valid = 1;
        range_code = 80;
        speed_code = 28;
        amp_code = 210;
        spread_code = 2;
        motion_code = 1;
        #10;
        $display("car_case,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
            target_valid, range_code, speed_code, amp_code, spread_code, motion_code,
            dog, human, car, plane, alien);

        // Plane-like target
        target_valid = 1;
        range_code = 200;
        speed_code = 95;
        amp_code = 240;
        spread_code = 1;
        motion_code = 1;
        #10;
        $display("plane_case,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
            target_valid, range_code, speed_code, amp_code, spread_code, motion_code,
            dog, human, car, plane, alien);

        // Alien / unknown target
        target_valid = 1;
        range_code = 44;
        speed_code = 13;
        amp_code = 160;
        spread_code = 12;
        motion_code = 15;
        #10;
        $display("alien_case,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
            target_valid, range_code, speed_code, amp_code, spread_code, motion_code,
            dog, human, car, plane, alien);

        $finish;
    end

endmodule
