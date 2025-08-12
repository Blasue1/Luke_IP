class simple_test extends uvm_test;
  `uvm_component_utils(simple_test)
  simple_env m_env;

  function new(string name = "simple_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass

function void simple_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  this.m_env = simple_env::type_id::create("m_env", this);
endfunction

task simple_test::run_phase(uvm_phase phase);
  simple_sequence seq;
  super.run_phase(phase);
  phase.raise_objection(this);
  seq = simple_sequence::type_id::create("seq");
  seq.start(this.m_env.agent0.m_seqr);
  #1000ns;
  phase.drop_objection(this);
endtask