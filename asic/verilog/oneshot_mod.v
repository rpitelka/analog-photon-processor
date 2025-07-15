// MODIFIED one-shot
// starts async on trigger_in,
// ends on posedge clock,
// delays to get up to 1.5clk

module oneshot_mod(
    output reg pulse_out, 
    input trigger_in, 
    input clk
    );

    reg delay, delay2;

    always @ (posedge clk, posedge trigger_in)
    begin
	    if (trigger_in && !delay2) 
            pulse_out <= 1'b1;
	    else
            pulse_out <= 1'b0;
	    delay <= trigger_in;
        delay2 <= delay;
    end 
endmodule
