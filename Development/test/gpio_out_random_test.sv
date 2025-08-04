class gpio_out_random_test extends gpio_base_test;
  `uvm_component_utils(gpio_out_random_test)
 
  function new(input string name = "gpio_in_random_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_base_seq bseq;
  gpio_out_write_repeat_seq wseq;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wseq  = gpio_out_write_repeat_seq::type_id::create("wseq");
    bseq   = gpio_base_seq::type_id::create("bseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    wseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    bseq.start(genv.g_agent.gseqr);
    wseq.randomize with {no_of_txn == 20;};
    wseq.start(genv.gr_agent.grseqr);
    
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 



