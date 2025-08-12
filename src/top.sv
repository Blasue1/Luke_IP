`timescale 1ns/1ps
`include "uvm_macros.svh"
module top;
  import uvm_pkg::*;

  logic clk, rst_n;
  simple_if vif();

  assign vif.clk   = clk;
  assign vif.rst_n = rst_n;

  dut dut0 (
    .clk    (clk),
    .rst_n  (rst_n),
    .write  (vif.write),
    .read   (vif.read),
    .data_in(vif.data_in),
    .data_out(vif.data_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst_n = 0;
    #5 rst_n = 1;
  end

  initial begin
    uvm_config_db#(virtual simple_if)::set(null, "", "vif", vif);
    run_test("simple_test");
  end

  initial begin
    string fsdb;

    if($value$plusargs("FSDB_DUMP=%s", fsdb)) begin
      if(fsdb == "FULL") begin
        $fsdbDumpfile("top.fsdb");
        $fsdbDumpvars(0, top, "+all");
      end
    end
  end
endmodule
