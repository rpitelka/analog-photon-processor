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
    wire timeout_en = 0;
    wire timeout_length = 5;

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
        .timeout_en(timeout_en),
        .timeout_length(timeout_length)
    );

    always #10 clk = ~clk; // 50MHz clock

    initial begin
        #0 rst = 1'b0;
    end

endmodule