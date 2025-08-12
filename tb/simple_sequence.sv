class simple_sequence extends uvm_sequence#(simple_trans);
  `uvm_object_utils(simple_sequence)

  function new(string name = "simple_sequence");
    super.new(name);
  endfunction

  extern task body();

endclass

task simple_sequence::body();
  simple_trans tr;
  repeat (1000) begin
    tr = simple_trans::type_id::create("tr");
    tr.write = 1;
    tr.data  = $urandom_range(0, 255);
    start_item(tr);
    finish_item(tr);

    tr = simple_trans::type_id::create("tr");
    tr.read = 1;
    start_item(tr);
    finish_item(tr);
  end
endtask