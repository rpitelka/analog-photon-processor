`timescale 1ns / 1ps

module APP_tb;

    reg clk = 1'b0;
    reg rst = 1'b0;

    // Analog memory signals
    reg TOT = 0;
    reg resetb_full = 0;
    reg [7:0] metadata = 0;

    // App 1ch signals
    reg vcomp = 0;
    reg rst_init = 0;
    reg timeout_enable = 1;
    reg [3:0] timeout_threshold = 10;

    // Instantiate analog memory core
    amem_core amem_core_tb (
        .clk(clk),
        .resetb_full(resetb_full),
        .TOT(TOT),
        .metadata(metadata)
    );

    // Instantiate app 1ch behavioral model
    app_1ch_behav app_1ch_tb (
        .clk(clk),
        .rst_init(rst_init),
        .vcomp(vcomp),
        .timeout_enable(timeout_enable), // Enable timeout for testing
        .timeout_threshold(timeout_threshold)
    );

    always #10 clk = ~clk; // 50MHz clock

    initial begin
        #0 rst = 1'b0;
    end

endmodule