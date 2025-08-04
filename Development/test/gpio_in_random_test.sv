class gpio_in_random_test extends gpio_base_test;
  `uvm_component_utils(gpio_in_random_test)
 
  function new(input string name = "gpio_in_random_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_in_random_seq raseq;
  gpio_in_read_repeat_seq rseq;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rseq  = gpio_in_read_repeat_seq::type_id::create("rseq");
    raseq   = gpio_in_random_seq::type_id::create("raseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    rseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    raseq.randomize with {no_of_txn == 20;};
    raseq.start(genv.g_agent.gseqr);
    rseq.randomize with {no_of_txn == 20;};
    rseq.start(genv.gr_agent.grseqr);
    
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 


