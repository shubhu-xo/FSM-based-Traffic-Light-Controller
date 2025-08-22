`timescale 1ns/1ps
module tb_traffic;
  reg clk;
  reg rst_n;
  reg sensor;
  wire [2:0] light_highway;
  wire [2:0] light_farm;

  // DUT
  traffic_light dut (
    .light_highway(light_highway),
    .light_farm(light_farm),
    .C(sensor),
    .clk(clk),
    .rst_n(rst_n)
  );

  // 100 MHz clock (10 ns period)
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // stimulus (same timing as the code you shared)
  initial begin
    rst_n  = 0;
    sensor = 0;
    #40  rst_n = 1;          // release reset at 40 ns

    #600  sensor = 1;        // car arrives on farm
    #1200 sensor = 0;        // goes away
    #1200 sensor = 1;        // new car

    #2000 $stop;             // stop and keep wave window
  end

  // console trace
  initial begin
    $display(" time   sensor   HW  FARM  (HW:001=G,010=Y,100=R)");
    $monitor("%6t     %b      %03b  %03b", $time, sensor, light_highway, light_farm);
  end
endmodule
