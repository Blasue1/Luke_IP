class simple_trans extends uvm_sequence_item;

  rand bit [7:0] data;
  rand bit [7:0] data_out;
  rand bit       write;
  rand bit       read;

  `uvm_object_utils(simple_trans)

  function new(string name = "simple_trans");
    super.new(name);
  endfunction

endclass