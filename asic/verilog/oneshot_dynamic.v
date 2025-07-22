module oneshot_dynamic #(
  parameter integer WIDTH = 5      // width of your length bus
)(
  input  wire              clk,
  input  wire              rst,
  input  wire              trig_in,
  input  wire [WIDTH-1:0]  pulse_width,
  output wire              pulse_out
);

  // counter
  reg [WIDTH-1:0] cnt;

  always @ (posedge trig_in or posedge rst) begin
    if (rst)
      cnt <= 0;
    else
      cnt <= pulse_width;
  end

  always @(posedge clk) begin
    if (cnt != 0)
      cnt <= cnt - 1;
    else
      cnt <= 0;
  end

  assign pulse_out = (cnt != 0);

endmodule
