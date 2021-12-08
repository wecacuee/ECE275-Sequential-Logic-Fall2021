// Downloaded from: https://github.com/projf/projf-explore/blob/1286308a1e568a3991295da14dfc6c464e07de43/lib/memory/rom_async.sv
// 
// Project F Library - Asynchronous ROM
// (C)2021 Will Green, Open source hardware released under the MIT License
// Learn more at https://projectf.io

`default_nettype none
`timescale 1ns / 1ps

module rom_async #(
    parameter WIDTH=8,
    parameter DEPTH=512,
    parameter INIT_F=""
    ) (
    input wire [ADDRW-1:0] addr,
    output     [WIDTH-1:0] data
    );
    localparam ADDRW=$clog2(DEPTH);
    reg [WIDTH-1:0] memory [DEPTH];

    initial begin
        if (INIT_F != 0) begin
            $display("Creating rom_async from init file '%s'.", INIT_F);
            $readmemh(INIT_F, memory);
        end
    end

    assign data = memory[addr];
endmodule