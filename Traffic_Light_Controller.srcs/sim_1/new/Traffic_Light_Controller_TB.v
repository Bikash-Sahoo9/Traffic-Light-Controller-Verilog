`timescale 1ns/1ps
module Traffic_Light_Controller_TB;

    reg clk;
    reg rst;
    wire [2:0] light_M1;
    wire [2:0] light_S;
    wire [2:0] light_MT;
    wire [2:0] light_M2;

    Traffic_Light_Controller dut(
        .clk(clk),
        .rst(rst),
        .light_M1(light_M1),
        .light_S(light_S),
        .light_M2(light_M2),
        .light_MT(light_MT)
    );

    // Fast clock for simulation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz

    // Reset
    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    // Simulation runtime
    initial begin
        $monitor("Time=%0t | State=%0d | M1=%b M2=%b MT=%b S=%b", $time, dut.ps, light_M1, light_M2, light_MT, light_S);
        #500; // Simulate enough cycles
        $finish;
    end

endmodule
