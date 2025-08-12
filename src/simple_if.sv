interface simple_if;
  logic clk, rst_n;
  logic write, read;
  logic [7:0] data_in, data_out;

  modport DUT (input clk, rst_n, write, read, data_in, output data_out);
  modport DRV (input clk, rst_n, data_out, output write, read, data_in);
  modport MON (input clk, rst_n, write, read, data_in, data_out);
endinterface