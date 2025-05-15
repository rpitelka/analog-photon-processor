/******************************************************************************
 * Behavioral model of APP analog channel digital outputs.
 * On rising edge of TOT events:
 * -- samplex asserted -- ping
 * -- samplexP on TOT(x+1) -- pong
 * -- sample(x+2) on TOT(x+2) -- ping, etc.
 * -- ping/pong deasserted on falling edge of (x+1) event
 * -- VP_front/back asserted on rising/falling edge
 * -- VP_front/back deasserted on rising edge of clock up to 1.5CLK away 
 *    from falling edge of TOT
 *
 ******************************************************************************
*/

module app_1ch_behav(
	input wire clk,
	input wire rst_init,
	input wire read_en,
	input wire vcomp, // TOT
	output reg [3:0] sample,
	output reg [3:0] sampleP,
	output wire [7:0] VP_front,
	output wire [7:0] VP_back,
	output reg [3:0] count,
	// ignore DAC and alignment for now
    input wire timeout
);

	// internal registers
    reg [5:0] curr_state;
    reg [5:0] next_state;
    reg [7:0] VP_fr_trig;
    reg [7:0] VP_bk_trig;
    
    // internal connections
    wire clk_half;
	
    // states
    localparam [5:0]
                PING1 = 0, // rising edge
                PING1A = 1, // falling edge
                TO1 = 2, // timeout
                PONG2 = 3,
                PONG2A = 4,
                TO2 = 5,
                PING3 = 6,
                PING3A = 7,
                TO3 = 8,
                PONG4 = 9,
                PONG4A = 10,
                TO4 = 11,
                PING5 = 12,
                PING5A = 13,
                TO5 = 14,
                PONG6 = 15,
                PONG6A = 16,
                TO6 = 17,
                PING7 = 18,
                PING7A = 19,
                TO7 = 20,
                PONG8 = 21,
                PONG8A = 22, // START
                TO8 = 23,
                // unused: 24 -- 30
                ERROR = 31;

    // TODO: add ~15ns or randomized delays to TOT input

    // async state machine driven by TOT edges and programmable timeout
    always @ (posedge vcomp, negedge vcomp, posedge timeout, posedge rst_init)
    begin
        if (rst_init)
        begin
            curr_state <= PONG8A; // TODO: should be distinct START state
            next_state <= PING1;
        end
        else
            curr_state <= next_state;
    end

    // "fake" TAC signals
    // TODO: extend to always 0.5--1.5 + 2 clk 
    // randomize the 0.5--1.5x ?
    clock_div
        #(.DIVISOR(2))
        halfclk (
        .clock_in(clk), 
        .clock_out(clk_half)
    );
    genvar i; 
    generate
        for (i = 0; i < 8; i = i + 1)
        begin
            oneshot osf(
                .clk(clk),
                .trigger_in(VP_fr_trig[i]),
                .pulse_out(VP_front[i])
            );
        end
    endgenerate
    genvar j; 
    generate
        for (j = 0; j < 8; j = j + 1)
        begin
            oneshot osb(
                .clk(clk),
                .trigger_in(VP_bk_trig[j]),
                .pulse_out(VP_back[j])
            );
        end
    endgenerate

    // state machine
    // ***
    // TODO : ADD eight TO states
    // ***
    always @ (*)
	begin
        case (curr_state)
            PING1: 
            begin 
                if (vcomp) // rising edge event 1
                begin
                    sample =  4'b0001; // amplitude
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b00000001; // TAC for rising edge
                    VP_bk_trig = 8'b00000000;
                    count = 4'h1;
                    next_state = PING1A;
                end
            end
            PING1A: 
            begin
                if (!vcomp) // falling edge event 1
                begin
                    sample =  4'b0001;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b00000001;
                    VP_bk_trig = 8'b00000001; // TAC for falling edge
                    count = 4'h1;
                    next_state = PONG2;
                end
            end
            PONG2: 
            begin
                if (vcomp)
                begin
                    sample =  4'b0001;
                    sampleP = 4'b0001;
                    VP_fr_trig = 8'b00000011;
                    VP_bk_trig = 8'b00000001;
                    count = 4'h2;
                    next_state = PONG2A;
                end
            end   
            PONG2A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b0001;
                    VP_fr_trig = 8'b00000011;
                    VP_bk_trig = 8'b00000011;
                    count = 4'h2;
                    next_state = PING3;
                end
            end
            PING3: 
            begin
                if (vcomp)
                begin
                    sample = 4'b0010;
                    sampleP = 4'b0001;
                    VP_fr_trig = 8'b00000111;
                    VP_bk_trig = 8'b00000011;
                    count = 4'h3;
                    next_state = PING3A;
                end
            end
            PING3A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b0010;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b00000111;
                    VP_bk_trig = 8'b00000111;
                    count = 4'h3;
                    next_state = PONG4;
                end
            end
            PONG4: 
            begin
                if (vcomp)
                begin
                    sample =  4'b0010;
                    sampleP = 4'b0010;
                    VP_fr_trig = 8'b00001111;
                    VP_bk_trig = 8'b00000111;
                    count = 4'h4;
                    next_state = PONG4A;
                end
            end
            PONG4A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b0010;
                    VP_fr_trig = 8'b00001111;
                    VP_bk_trig = 8'b00001111;
                    count = 4'h4;
                    next_state = PING5;
                end
            end
            PING5: 
            begin
                if (vcomp)
                begin
                    sample =  4'b0100;
                    sampleP = 4'b0010;
                    VP_fr_trig = 8'b00011111;
                    VP_bk_trig = 8'b00001111;
                    count = 4'h5;
                    next_state = PING5A;
                end
            end
            PING5A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b0100;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b00011111;
                    VP_bk_trig = 8'b00011111;
                    count = 4'h5;
                    next_state = PONG6;
                end
            end
            PONG6: 
            begin
                if (vcomp)
                begin
                    sample =  4'b0100;
                    sampleP = 4'b0100;
                    VP_fr_trig = 8'b00111111;
                    VP_bk_trig = 8'b00011111;
                    count = 4'h6;
                    next_state = PONG6A;
                end
            end
            PONG6A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b0100;
                    VP_fr_trig = 8'b00111111;
                    VP_bk_trig = 8'b00111111;
                    count = 4'h6;
                    next_state = PING7;
                end
            end
            PING7: 
            begin
                if (vcomp)
                begin
                    sample =  4'b1000;
                    sampleP = 4'b0100;
                    VP_fr_trig = 8'b01111111;
                    VP_bk_trig = 8'b00111111;
                    count = 4'h7;
                    next_state = PING7A;
                end
            end
            PING7A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b1000;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b01111111;
                    VP_bk_trig = 8'b01111111;
                    count = 4'h7;
                    next_state = PONG8;
                end
            end
            PONG8: 
            begin
                if (vcomp)
                begin
                    sample =  4'b1000;
                    sampleP = 4'b1000;
                    VP_fr_trig = 8'b11111111;
                    VP_bk_trig = 8'b01111111;
                    count = 4'h8;
                    next_state = PONG8A;
                end
            end
            PONG8A: 
            begin
                if (!vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b1000;
                    VP_fr_trig = 8'b11111110; // Need [0] OFF before PING1 
                    VP_bk_trig = 8'b11111110;
                    count = 4'h8;
                    next_state = PING1; // restart
                end
            end
            default: next_state = PONG8A;
        endcase
    end

endmodule

