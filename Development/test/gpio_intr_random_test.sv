class gpio_intr_random_test extends gpio_in_pattern_test;
  `uvm_component_utils(gpio_intr_random_test)
 
  intr_random_seq irseq;
  intr_clear_seq cseq;
  function new(input string name = "gpio_intr_random_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    irseq   = intr_random_seq::type_id::create("irseq");
    cseq   = intr_clear_seq::type_id::create("cseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    irseq.regmodel = genv.regmodel;
    cseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_HIGH);
    irseq.randomize;
    irseq.start(genv.gr_agent.grseqr);
    in_seq.start(genv.g_agent.gseqr);
    cseq.start(genv.gr_agent.grseqr);
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_HIGH);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 
