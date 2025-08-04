class gpio_in_pattern_test extends gpio_base_test;
  `uvm_component_utils(gpio_in_pattern_test)
 
  function new(input string name = "gpio_in_pattern_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_in_toggle_base_seq tseq;
  gpio_in_read_repeat_seq rseq;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rseq  = gpio_in_read_repeat_seq::type_id::create("rseq");
    tseq   = gpio_in_toggle_base_seq::type_id::create("tseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    rseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    tseq.randomize with {no_of_txn == 10;};
    tseq.start(genv.g_agent.gseqr);
    rseq.randomize with {no_of_txn == 10;};
    rseq.start(genv.gr_agent.grseqr);
    
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 

