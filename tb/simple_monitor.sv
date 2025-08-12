class simple_monitor extends uvm_monitor;
  `uvm_component_utils(simple_monitor)
  virtual simple_if vif;
  uvm_analysis_port#(simple_trans) ap;

  function new(string name = "simple_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

function void simple_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual simple_if)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", "Monitor: virtual interface not set")
  this.ap = new("ap", this);
endfunction

task simple_monitor::run_phase(uvm_phase phase);
  simple_trans tr;

  forever begin
    @(posedge this.vif.clk);

    if (this.vif.write) begin
      tr = simple_trans::type_id::create("tr");
      tr.write = 1;
      tr.data  = this.vif.data_in;
      `uvm_info("MON", $sformatf("LUKE_MON_WRITE: write=%d data_in=%d", tr.write, tr.data), UVM_LOW)
      if (this.ap != null) this.ap.write(tr);
    end

    if (this.vif.read) begin
      fork
        begin
          simple_trans read_tr = simple_trans::type_id::create("tr");
          @(posedge this.vif.clk);
          read_tr.read = 1;
          read_tr.data_out = this.vif.data_out;
          `uvm_info("MON", $sformatf("LUKE_MON_READ: read=%d, data_out=%d", read_tr.read, read_tr.data_out), UVM_LOW)
          if (this.ap != null) this.ap.write(read_tr);
        end
      join_none
    end
  end
endtask