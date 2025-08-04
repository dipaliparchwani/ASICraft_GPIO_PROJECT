class gpio_intr_sanity_test extends gpio_base_test;
  `uvm_component_utils(gpio_intr_sanity_test)
 
  function new(input string name = "gpio_intr_sanity_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_in_toggle_base_seq tseq;
  gpio_intr_with_high_mask_seq mseq;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mseq  = gpio_intr_with_high_mask_seq::type_id::create("mseq");
    tseq   = gpio_in_toggle_base_seq::type_id::create("tseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    mseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    tseq.randomize with {no_of_txn == 20;};
    mseq.randomize;
    fork
      tseq.start(genv.g_agent.gseqr);
      mseq.start(genv.gr_agent.grseqr);
    join
    
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 


