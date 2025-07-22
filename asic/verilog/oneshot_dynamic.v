module oneshot_dynamic #(
  parameter integer WIDTH = 5      // width of your length bus
)(
  input  wire              clk,
  input  wire              rst,
  input  wire              trig_in,
  input  wire [WIDTH-1:0]  pulse_width,
  output wire              pulse_out
);

  // edge detect
  reg trig_d;
  always @(posedge clk) trig_d <= trig_in;
  wire trig_posedge = trig_in & ~trig_d;

  // counter
  reg [WIDTH-1:0] cnt;
  always @(posedge clk) begin
    if (rst)
      cnt <= 0;
    else if (trig_posedge)
      cnt <= pulse_width;
    else if (cnt != 0)
      cnt <= cnt - 1;
    else
      cnt <= 0;
  end

  assign pulse_out = (cnt != 0);

endmodule
