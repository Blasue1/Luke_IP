class simple_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(simple_scoreboard)
  uvm_analysis_imp#(simple_trans, simple_scoreboard) ap_imp;

  simple_trans write_q[$];
  simple_trans read_q[$];
  int match_count = 0;
  int mismatch_count = 0;

  function new(string name = "simple_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual task write(simple_trans tr);
  extern task compare_transactions();

endclass

function void simple_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  this.ap_imp = new("ap_imp", this);
endfunction

task simple_scoreboard::write(simple_trans tr);
  if (tr.write) begin
    this.write_q.push_back(tr);
    `uvm_info("SB", $sformatf("WRITE: data=%d", tr.data), UVM_LOW)
  end
  if (tr.read) begin
    this.read_q.push_back(tr);
    `uvm_info("SB", $sformatf("READ: data_out=%d", tr.data_out), UVM_LOW)
  end

  this.compare_transactions();
  `uvm_info("SB", $sformatf("match/mismatch=%d/%d", this.match_count, this.mismatch_count), UVM_LOW)
endtask

task simple_scoreboard::compare_transactions();
  int wr_size = this.write_q.size();
  int rd_size = this.read_q.size();

  `uvm_info("SB", $sformatf("write_size=%d, read_size=%d", wr_size, rd_size), UVM_LOW)

  while (wr_size > 0 && rd_size > 0) begin
    simple_trans write_tr = this.write_q[0];
    simple_trans read_tr  = this.read_q[0];

    if (write_tr.data !== read_tr.data_out) begin
      `uvm_error("SB", $sformatf("Mismatch: expected=%d, actual=%d", write_tr.data, read_tr.data_out))
      this.mismatch_count++;
    end
    else begin
      `uvm_info("SB", $sformatf("Match: write_data=%d, data_out=%d", write_tr.data, read_tr.data_out), UVM_LOW)
      this.match_count++;
    end

    void'(this.write_q.pop_front());
    void'(this.read_q.pop_front());

    wr_size--;
    rd_size--;
  end
endtask
