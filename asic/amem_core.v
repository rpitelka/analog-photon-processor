/******************************************************************************
 * Digital interface to analog memory cells, APP core logic, and outside
 * world.
 *
 ******************************************************************************
*/

module amem_core(
	// Signals to/from APP analog measurement circuitry
	input wire TOT,
	input wire ping,
	input wire pong,
	input wire [3:0] last_cell,
	input wire [7:0] metadata,
	output wire reset_pingpong,

	// signals to/from APP analog memory
	output wire read_en,
	output wire [2:0] event_mux,
	
	// signals to/from outside world
	input wire clk,
	input wire resetb_full,
	input wire adc_ready,
	input wire adc_done,
	input wire circular_en,
	input wire read_next,
	output wire amem_empty,
	output wire amem_full
);

	// internal registers
	reg [63:0] timestamp = 64'h0;
	reg [63:0] curr_ts = 64'h0;
	reg [2:0] column = 3'b000;

	reg empty = 1'b1;
	reg full = 1'b0;
	assign amem_empty = empty;
	assign amem_full = full;

	reg reset_pingpong_reg = 1'b0;
	reg read_en_reg = 1'b0;
	reg [2:0] event_mux_reg = 3'b000;
	assign reset_pingpong = reset_pingpong_reg;
	assign read_en = read_en_reg;
	assign event_mux = event_mux_reg;

	reg [7:0] metadata_reg = 3'b000;
	reg [7:0] curr_metadata = 3'b000;

	// logic
	always @ (negedge resetb_full)
	begin
		timestamp <= 64'h0;
		column <= 4'h0;
	end

	always @ (posedge clk)
	begin
		timestamp <= timestamp + 1'b1;

		metadata_reg <= metadata;

		if (column == 3'b000)
		begin
			empty <= 1'b1;
			full <= 1'b0;
		end
		if (column != 3'b000)
		begin
			empty <= 1'b0;
			full <= 1'b0;
		end
		if (column == 3'b111)
		begin
			empty <= 1'b0;
			full <= 1'b1;
		end
		
	end

	always @ (negedge TOT) // synchronize
	begin
		curr_ts <= timestamp; // Put this in FIFO
		curr_metadata <= metadata_reg;
		if (column != 3'b111)
			column <= column + 1'b1;
	end

endmodule

