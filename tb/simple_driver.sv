class simple_driver extends uvm_driver#(simple_trans);
  `uvm_component_utils(simple_driver)
  virtual simple_if vif;

  function new(string name = "simple_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

function void simple_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if (!uvm_config_db#(virtual simple_if)::get(this, "", "vif", vif))
    `uvm_fatal("NOVIF", "Driver: virtual interface not set")
endfunction

task simple_driver::run_phase(uvm_phase phase);
  simple_trans tr;

  forever begin
    seq_item_port.get_next_item(tr);

    this.vif.write    = 0;
    this.vif.read     = 0;
    this.vif.data_in  = 0;

    if (tr.write) begin
      this.vif.data_in = tr.data;
      this.vif.write   = 1;

      @(posedge this.vif.clk);
      this.vif.write = 0;

    end

    if (tr.read) begin
      this.vif.read = 1;

      @(posedge vif.clk);
      this.vif.read = 0;

    end

    seq_item_port.item_done();
  end
endtask