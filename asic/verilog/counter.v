module counter(
    input wire rst_init,
    input wire count_up,
    input wire count_reset,
    output reg [3:0] count
    );

    always @ (posedge count_up, negedge count_reset, posedge rst_init)
    begin
        if (rst_init)
            count <= 4'h0;
        else if (count_reset)
            count <= 4'h0;
        else if (count_up)
            count <= count + 1'b1;
    end

endmodule