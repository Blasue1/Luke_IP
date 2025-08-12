module dut(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       write,
    input  logic       read,
    input  logic [7:0] data_in,
    output logic [7:0] data_out
  );
  logic [7:0] mem;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      mem <= 8'h00;
    else if (write)
      mem <= data_in;
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      data_out <= 8'h00;
    else if (read)
      data_out <= mem;
  end

endmodule
