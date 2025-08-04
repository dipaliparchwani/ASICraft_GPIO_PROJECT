class gpio_intr_clear_test extends gpio_base_test;
  `uvm_component_utils(gpio_intr_clear_test)
 
  function new(input string name = "gpio_intr_clear_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_in_random_seq irseq;
  gpio_intr_status_clear_seq cseq;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cseq  = gpio_intr_status_clear_seq::type_id::create("cseq");
    irseq   = gpio_in_random_seq::type_id::create("irseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    cseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    irseq.randomize with {no_of_txn == 20;};
    cseq.randomize;
    fork
      irseq.start(genv.g_agent.gseqr);
      cseq.start(genv.gr_agent.grseqr);
    join
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 
