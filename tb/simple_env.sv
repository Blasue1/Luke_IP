class simple_env extends uvm_env;
  `uvm_component_utils(simple_env)
  simple_agent      agent0;
  simple_scoreboard sb0;

  function new(string name = "simple_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass

function void simple_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  this.agent0 = simple_agent::type_id::create("agent0", this);
  this.sb0    = simple_scoreboard::type_id::create("sb0", this);
endfunction

function void simple_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  this.agent0.mon.ap.connect(this.sb0.ap_imp);
endfunction