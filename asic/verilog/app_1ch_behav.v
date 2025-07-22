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
    input wire timeout_en, // enable timeout
    input wire [5:0] timeout_length // configurable timeout length
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
                PONG2T = 4, // rising edge after timeout
                PONG2A = 5,
                TO2 = 6,
                PING3 = 7,
                PING3T = 8,
                PING3A = 9,
                TO3 = 10,
                PONG4 = 11,
                PONG4T = 12,
                PONG4A = 13,
                TO4 = 14,
                PING5 = 15,
                PING5T = 16,
                PING5A = 17,
                TO5 = 18,
                PONG6 = 19,
                PONG6T = 20,
                PONG6A = 21,
                TO6 = 22,
                PING7 = 23,
                PING7T = 24,
                PING7A = 25,
                TO7 = 26,
                PONG8 = 27,
                PONG8T = 28,
                PONG8A = 29, // START
                TO8 = 30,
                // unused: 31
                ERROR = 31;

    // TODO: add ~15ns or randomized delays to TOT input

    // async state machine driven by TOT edges and programmable timeout
    always @ (posedge vcomp, negedge vcomp, posedge rst_init)
    begin
        if (rst_init)
        begin
            curr_state <= PONG8A; // TODO: should be distinct START state
            next_state <= PING1;
        end
        else
            curr_state <= next_state;
    end

    // Configurable timeout pulse generator
    wire timeout_trigger;
    wire timeout;
    reg timeout_trigger_reg;

    // Generate timeout trigger on vcomp falling edges
    always @(posedge vcomp, negedge vcomp, posedge rst_init)
    begin
        if (rst_init)
            timeout_trigger_reg <= 1'b0;
        else if (!vcomp & timeout_en) // Trigger on falling edge of vcomp
            timeout_trigger_reg <= 1'b1;
        else
            timeout_trigger_reg <= 1'b0;
    end

    assign timeout_trigger = timeout_trigger_reg;

    // Generate timeout pulse on vcomp falling edges
    // Pulse starts one clock cycle after the trigger
    oneshot_dynamic timeout_gen(
        .clk(clk),
        .rst(rst_init),
        .trig_in(timeout_trigger),
        .pulse_out(timeout),
        .pulse_width(timeout_length)
    );

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
                    VP_fr_trig = 8'b00000010;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h2;
                    next_state = PONG2A;
                end
            end
            PONG2T: 
            begin
                if (vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b0001;
                    VP_fr_trig = 8'b00000010;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b00000010;
                    VP_bk_trig = 8'b00000010;
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
                    VP_fr_trig = 8'b00000100;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h3;
                    next_state = PING3A;
                end
            end
            PING3T:
            begin
                if (vcomp)
                begin
                    sample =  4'b0010;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b00000100;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b00000100;
                    VP_bk_trig = 8'b00000100;
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
                    VP_fr_trig = 8'b00001000;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h4;
                    next_state = PONG4A;
                end
            end
            PONG4T:
            begin
                if (vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b0010;
                    VP_fr_trig = 8'b00001000;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b00001000;
                    VP_bk_trig = 8'b00001000;
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
                    VP_fr_trig = 8'b00010000;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h5;
                    next_state = PING5A;
                end
            end
            PING5T:
            begin
                if (vcomp)
                begin
                    sample =  4'b0100;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b00010000;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b00010000;
                    VP_bk_trig = 8'b00010000;
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
                    VP_fr_trig = 8'b00100000;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h6;
                    next_state = PONG6A;
                end
            end
            PONG6T:
            begin
                if (vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b0100;
                    VP_fr_trig = 8'b00100000;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b00100000;
                    VP_bk_trig = 8'b00100000;
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
                    VP_fr_trig = 8'b01000000;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h7;
                    next_state = PING7A;
                end
            end
            PING7T:
            begin
                if (vcomp)
                begin
                    sample =  4'b1000;
                    sampleP = 4'b0000;
                    VP_fr_trig = 8'b01000000;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b01000000;
                    VP_bk_trig = 8'b01000000;
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
                    VP_fr_trig = 8'b10000000;
                    VP_bk_trig = 8'b00000000;
                    count = 4'h8;
                    next_state = PONG8A;
                end
            end
            PONG8T:
            begin
                if (vcomp)
                begin
                    sample =  4'b0000;
                    sampleP = 4'b1000;
                    VP_fr_trig = 8'b10000000;
                    VP_bk_trig = 8'b00000000;
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
                    VP_fr_trig = 8'b10000000; // Need [0] OFF before PING1 
                    VP_bk_trig = 8'b10000000;
                    count = 4'h8;
                    next_state = PING1; // restart
                end
            end
            default: next_state = PONG8A;
        endcase
    end

endmodule

