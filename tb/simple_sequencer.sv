class simple_sequencer extends uvm_sequencer#(simple_trans);
    `uvm_component_utils(simple_sequencer)

    function new(string name = "simple_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
