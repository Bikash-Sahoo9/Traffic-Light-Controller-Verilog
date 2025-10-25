`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 17:40:11
// Design Name: 
// Module Name: Traffic_Light_Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Traffic_Light_Controller(
    input clk,
    input rst,
    output reg [2:0] light_M1,
    output reg [2:0] light_S,
    output reg [2:0] light_MT,
    output reg [2:0] light_M2
);

    // State encoding
    parameter S1 = 3'd0,
              S2 = 3'd1,
              S3 = 3'd2,
              S4 = 3'd3,
              S5 = 3'd4,
              S6 = 3'd5;

    reg [2:0] ps;  // Present state
    reg [2:0] ns;  // Next state
    reg [23:0] count;

    // Duration counters (for simulation, can be small)
    parameter SEC7 = 7; // for simulation cycles
    parameter SEC5 = 5;
    parameter SEC3 = 3;
    parameter SEC2 = 2;

    // Sequential logic: state transition
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ps <= S1;
            count <= 0;
        end else begin
            if (count < state_duration(ps)) begin
                count <= count + 1;
                ps <= ps; // stay in current state
            end else begin
                ps <= next_state(ps);
                count <= 0;
            end
        end
    end

    // Combinational next state
    function [2:0] next_state;
        input [2:0] state;
        begin
            case(state)
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S4;
                S4: next_state = S5;
                S5: next_state = S6;
                S6: next_state = S1;
                default: next_state = S1;
            endcase
        end
    endfunction

    // Combinational state duration
    function [23:0] state_duration;
        input [2:0] state;
        begin
            case(state)
                S1: state_duration = SEC7;
                S2: state_duration = SEC2;
                S3: state_duration = SEC5;
                S4: state_duration = SEC2;
                S5: state_duration = SEC3;
                S6: state_duration = SEC2;
                default: state_duration = SEC2;
            endcase
        end
    endfunction

    // Output logic
    always @(ps) begin
        case(ps)
            S1: begin
                light_M1 = 3'b001;
                light_M2 = 3'b001;
                light_MT = 3'b100;
                light_S  = 3'b100;
            end
            S2: begin
                light_M1 = 3'b001;
                light_M2 = 3'b010;
                light_MT = 3'b100;
                light_S  = 3'b100;
            end
            S3: begin
                light_M1 = 3'b001;
                light_M2 = 3'b100;
                light_MT = 3'b001;
                light_S  = 3'b100;
            end
            S4: begin
                light_M1 = 3'b010;
                light_M2 = 3'b100;
                light_MT = 3'b010;
                light_S  = 3'b100;
            end
            S5: begin
                light_M1 = 3'b100;
                light_M2 = 3'b100;
                light_MT = 3'b100;
                light_S  = 3'b001;
            end
            S6: begin
                light_M1 = 3'b100;
                light_M2 = 3'b100;
                light_MT = 3'b100;
                light_S  = 3'b100;
            end
            default: begin
                light_M1 = 3'b000;
                light_M2 = 3'b000;
                light_MT = 3'b000;
                light_S  = 3'b000;
            end
        endcase
    end

endmodule
