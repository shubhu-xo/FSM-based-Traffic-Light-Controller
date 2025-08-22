`timescale 1ns/1ps
// Traffic light controller (fast-ticking version for simulation)
module traffic_light(
    output reg [2:0] light_highway,
    output reg [2:0] light_farm,
    input  wire      C,       // sensor: 1 = car on farm road
    input  wire      clk,
    input  wire      rst_n    // active-low reset
);
  // state encoding
  localparam HGRE_FRED = 2'b00, // highway G / farm R
             HYEL_FRED = 2'b01, // highway Y / farm R
             HRED_FGRE = 2'b10, // highway R / farm G
             HRED_FYEL = 2'b11; // highway R / farm Y

  reg [1:0] state, next_state;

  // small counters for quick sim (1 "second" every 4 clocks)
  reg  [27:0] count = 0, count_delay = 0;
  wire        clk_enable;

  // delay flags
  reg delay10s = 0, delay3s1 = 0, delay3s2 = 0;
  reg RED_count_en = 0, YELLOW_count_en1 = 0, YELLOW_count_en2 = 0;

  // state register
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) state <= HGRE_FRED;
    else       state <= next_state;
  end

  // next-state + outputs (with safe defaults)
  always @* begin
    light_highway     = 3'b001;  // default G
    light_farm        = 3'b100;  // default R
    RED_count_en      = 1'b0;
    YELLOW_count_en1  = 1'b0;
    YELLOW_count_en2  = 1'b0;
    next_state        = state;

    case (state)
      HGRE_FRED: begin
        light_highway = 3'b001; // G
        light_farm    = 3'b100; // R
        if (C) next_state = HYEL_FRED;
      end

      HYEL_FRED: begin
        light_highway    = 3'b010; // Y
        light_farm       = 3'b100; // R
        YELLOW_count_en1 = 1'b1;
        if (delay3s1) next_state = HRED_FGRE;
      end

      HRED_FGRE: begin
        light_highway = 3'b100; // R
        light_farm    = 3'b001; // G
        RED_count_en  = 1'b1;
        if (delay10s) next_state = HRED_FYEL;
      end

      HRED_FYEL: begin
        light_highway    = 3'b100; // R
        light_farm       = 3'b010; // Y
        YELLOW_count_en2 = 1'b1;
        if (delay3s2) next_state = HGRE_FRED;
      end
    endcase
  end

  // delay generator (uses clk_enable as a "1s" tick in sim)
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      count_delay <= 0;
      delay10s <= 0; delay3s1 <= 0; delay3s2 <= 0;
    end else if (clk_enable) begin
      if (RED_count_en || YELLOW_count_en1 || YELLOW_count_en2) begin
        count_delay <= count_delay + 1;

        if (RED_count_en && count_delay == 9) begin
          delay10s <= 1; delay3s1 <= 0; delay3s2 <= 0; count_delay <= 0;
        end else if (YELLOW_count_en1 && count_delay == 2) begin
          delay10s <= 0; delay3s1 <= 1; delay3s2 <= 0; count_delay <= 0;
        end else if (YELLOW_count_en2 && count_delay == 2) begin
          delay10s <= 0; delay3s1 <= 0; delay3s2 <= 1; count_delay <= 0;
        end else begin
          delay10s <= 0; delay3s1 <= 0; delay3s2 <= 0;
        end
      end else begin
        count_delay <= 0;
        delay10s <= 0; delay3s1 <= 0; delay3s2 <= 0;
      end
    end else begin
      delay10s <= 0; delay3s1 <= 0; delay3s2 <= 0;
    end
  end

  // 1-second enable (tiny for sim; change 3?50_000_000 for 50 MHz real HW)
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n)      count <= 0;
    else if(count==3) count <= 0;
    else            count <= count + 1;
  end
  assign clk_enable = (count == 3);

endmodule
