class simple_agent extends uvm_agent;
  `uvm_component_utils(simple_agent)
  simple_sequencer m_seqr;
  simple_driver    drv;
  simple_monitor   mon;

  function new(string name = "simple_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass

function void simple_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (is_active == UVM_ACTIVE) begin
    this.m_seqr = simple_sequencer::type_id::create("m_seqr", this);
  end
  if (is_active == UVM_ACTIVE) begin
    this.drv  = simple_driver::type_id::create("drv", this);
  end
  this.mon  = simple_monitor::type_id::create("mon", this);
endfunction

function void simple_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  this.drv.seq_item_port.connect(m_seqr.seq_item_export);
endfunction